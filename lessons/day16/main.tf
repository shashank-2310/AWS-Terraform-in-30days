resource "aws_iam_user" "users" {
  for_each = { for user in local.users : user.first_name => user }
  name     = lower("${substr(each.value.first_name, 0, 1)}${each.value.last_name}")
  path     = "/users/"

  tags = {
    "DisplayName" = "${each.value.first_name} ${each.value.last_name}"
    "Department"  = each.value.department
    "JobTitle"    = each.value.job_title
  }

  force_destroy = true # Only in test env
}

resource "aws_iam_user_login_profile" "users" {
  for_each                = aws_iam_user.users
  user                    = each.value.name
  password_reset_required = true
  password_length         = 12

  lifecycle {
    ignore_changes = [password_reset_required, password_length]
  }
}

# IAM Policy to enforce MFA
resource "aws_iam_policy" "force_mfa_policy" {
  name        = "ForceMFA"
  description = "Denies every action if MFA is not setup"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "AllowAllActionsWithMFA",
        Effect : "Allow",
        Action : "*",
        Resource : "*",
        Condition : {
          Bool : {
            "aws:MultiFactorAuthPresent" : "true"
          }
        }
      },
      {
        Sid : "DenyAllActionsWithoutMFA",
        Effect : "Deny",
        Action : "*",
        Resource : "*",
        Condition : {
          Bool : {
            "aws:MultiFactorAuthPresent" : "false"
          }
        }
      }
    ]
  })
}

# Enforce MFA policy on users and groups
resource "aws_iam_user_policy_attachment" "force_mfa_users" {
  for_each   = aws_iam_user.users
  user       = each.value.name
  policy_arn = aws_iam_policy.force_mfa_policy.arn
}

resource "aws_iam_group_policy_attachment" "force_mfa_user_groups" {
  for_each = local.user_groups
  group      = each.value.name
  policy_arn = aws_iam_policy.force_mfa_policy.arn
}