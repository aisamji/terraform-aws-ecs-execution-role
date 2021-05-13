resource "aws_iam_role" "ecs_execution" {
  count                 = var.create_role ? 1 : 0
  name                  = var.name
  assume_role_policy    = data.aws_iam_policy_document.ecs_assume_role.json
  force_detach_policies = true
  tags                  = var.tags
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  count      = var.create_role ? 1 : 0
  role       = aws_iam_role.ecs_execution[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "read_secrets" {
  count  = var.create_role ? 1 : 0
  name   = "SecretsReadOnly"
  role   = aws_iam_role.ecs_execution[count.index].id
  policy = data.aws_iam_policy_document.read_secrets.json
}

data "aws_iam_policy_document" "read_secrets" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters"]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = ["kms:Decrypt", "secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*",
      "arn:aws:secretsmanager:*:${data.aws_caller_identity.current.account_id}:secret:*"
    ]
  }
}

data "aws_caller_identity" "current" {}
