resource "aws_cloudwatch_log_group" "wordpress-logs" {
  name = "${var.aws_log_group_wordpres}"
}

locals {
  wordpress_ecs_task_name = "adewordpressapplication-${var.region}"
}
resource "aws_ecs_task_definition" "word-press" {
  family                = "adewordpress-${var.region}"
  container_definitions = <<DEFINITION
[
  {
    "name": "${local.wordpress_ecs_task_name}",
    "image": "${var.account_number}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_image_repo_name}:${var.image_tag}",
    "memory": 512,
    "user": "root",
    "logConfiguration": {	
      "logDriver": "awslogs",	
      "options": {	
        "awslogs-group": "${var.aws_log_group_wordpres}",	
        "awslogs-region": "${var.region}"	,
        "awslogs-stream-prefix": "awslogs-wordy"
      }
    }
  }
]
DEFINITION
}