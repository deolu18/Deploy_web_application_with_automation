data "aws_ecr_image" "worddpress" {
  repository_name = "${var.ecr_image_repo_name}"
  image_tag = "${var.image_tag}"
}