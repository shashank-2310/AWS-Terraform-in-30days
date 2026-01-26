locals {
  # Decode CSV file into a list of maps
  users = csvdecode(file("users.csv"))

  user_groups = {
    for g in [
      aws_iam_group.education,
      aws_iam_group.managers,
      aws_iam_group.Finance,
    ] : g.name => g
  }
}
