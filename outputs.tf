output "ecs_role_arn" {
  value = coalesce(concat(aws_iam_role.ecs_execution.*.arn, ["NOT CREATED"])...)
}
