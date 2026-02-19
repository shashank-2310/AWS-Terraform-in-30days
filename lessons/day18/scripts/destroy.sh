#!/bin/bash
set -e

echo "🗑️  Destroying Image Processor Application..."

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first."
    exit 1
fi

cd "$PROJECT_DIR/terraform"

# Ensure terraform is initialized so `state show` and `output` work
terraform init -input=false >/dev/null 2>&1 || true

# Try getting a bucket name by checking outputs first, then falling back to state resource address
get_bucket_name() {
    local try_names=()
    local want="$1"

    # common output names used by deploy.sh
    if [ "$want" = "upload" ]; then
        try_names=("upload_bucket_name" "aws_s3_bucket.upload_bucket")
    elif [ "$want" = "processed" ]; then
        try_names=("processed_bucket_name" "aws_s3_bucket.processed_bucket")
    elif [ "$want" = "frontend" ]; then
        try_names=("frontend_bucket_name" "aws_s3_bucket.frontend_bucket")
    else
        try_names=("$want")
    fi

    for name in "${try_names[@]}"; do
        # try terraform output (raw) first
        out=$(terraform output -raw "$name" 2>/dev/null || true)
        if [ -n "$out" ]; then
            echo "$out"
            return 0
        fi

        # try parsing terraform state show for the resource address
        out=$(terraform state show "$name" 2>/dev/null || true)
        if [ -n "$out" ]; then
            echo "$out" | awk -F'= ' '/^\s*id\s*=/{gsub(/\"/,"",$2); print $2; exit}' || true
            return 0
        fi
    done

    echo ""
}

# Get bucket names
UPLOAD_BUCKET=$(get_bucket_name upload)
PROCESSED_BUCKET=$(get_bucket_name processed)
FRONTEND_BUCKET=$(get_bucket_name frontend)

# Function to empty versioned S3 bucket
empty_versioned_bucket() {
    local bucket=$1
    echo "🗑️  Emptying bucket: $bucket (including all versions)..."
    
    # Delete all object versions
    aws s3api list-object-versions --bucket "$bucket" --query 'Versions[].{Key:Key,VersionId:VersionId}' --output text | \
    while IFS=$'\t' read -r key version; do
        if [ -n "$key" ]; then
            aws s3api delete-object --bucket "$bucket" --key "$key" --version-id "$version" 2>/dev/null || true
        fi
    done
    
    # Delete all delete markers
    aws s3api list-object-versions --bucket "$bucket" --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output text | \
    while IFS=$'\t' read -r key version; do
        if [ -n "$key" ]; then
            aws s3api delete-object --bucket "$bucket" --key "$key" --version-id "$version" 2>/dev/null || true
        fi
    done
    
    echo "✓ Bucket $bucket emptied"

    # Try deleting the bucket itself (will fail if region/policy prevents it)
    if aws s3api delete-bucket --bucket "$bucket" 2>/dev/null; then
        echo "✓ Bucket $bucket deleted"
    else
        echo "⚠ Could not delete bucket $bucket now; Terraform will attempt to delete it during destroy."
    fi
}

# Empty S3 buckets
if [ ! -z "$UPLOAD_BUCKET" ]; then
    empty_versioned_bucket "$UPLOAD_BUCKET"
fi

if [ ! -z "$PROCESSED_BUCKET" ]; then
    empty_versioned_bucket "$PROCESSED_BUCKET"
fi

if [ ! -z "$FRONTEND_BUCKET" ]; then
    empty_versioned_bucket "$FRONTEND_BUCKET"
fi

# Destroy Terraform resources
echo "🔥 Destroying Terraform resources..."
terraform destroy -auto-approve

echo "✅ All resources destroyed successfully!"