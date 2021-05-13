variable "create_role" {
  type        = bool
  description = "A value indicating whether an IAM role should be created."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to apply to the created IAM role."
  default     = {}
}

variable "name" {
  type        = string
  description = "The name to give to the created IAM role."
  default     = "ECSExecutionRole"
}
