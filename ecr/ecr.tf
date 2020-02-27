resource "aws_ecr_repository" "wordpress_repo" {
  name = "adeoluwordpress"
}


resource "aws_ecs_cluster" "wordcluster" {
  name = "wordprApp"
}


resource "aws_ecs_service" "wordservice" {
  name            = "wordpressservice"
  cluster         = "${aws_ecs_cluster.wordcluster.id}"
  task_definition = "${aws_ecs_task_definition.word-press.arn}"
  desired_count   = 1
}
