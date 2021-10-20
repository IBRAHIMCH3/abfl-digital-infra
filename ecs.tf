
# Create a user profile which has our ecsInstance Role


resource "aws_iam_instance_profile" "ecs-ec2-profile" {
  name =  var.iam_profile
  role =  var.iam_role
}



# LAUNCH CONFIGURATION & AUTOSCALING GROUP

# This is an EC2 launch configurations with all the required settings and will be accompanied by an autoscaling group later


data "aws_ami" "amazon-ecs-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"] # Canonical
}


resource "aws_launch_configuration" "ecs-launch-config" {
  name_prefix     	     = "${var.env_name}-lc"
  image_id        	     = data.aws_ami.amazon-ecs-ami.id
  instance_type          = var.instance_type
  key_name               = var.keypair
  security_groups        = var.alb_security_groups
  user_data              = data.template_file.cluster-init.rendered
  iam_instance_profile   = aws_iam_instance_profile.ecs-ec2-profile.id
  lifecycle {
    create_before_destroy = true
  }
}

# This autoscaling group will take the above launch configuration and spin up/down the servers
/*
resource "aws_autoscaling_group" "ecs-as-group" {
  name                 = "${var.env_name}-asg"
  launch_configuration = aws_launch_configuration.ecs-launch-config.name
  min_size             = var.min_instance_count
  max_size             = var.max_instance_count
  vpc_zone_identifier  = ["${var.ecs_asg_subnets[0]}"]
  lifecycle {
    create_before_destroy = true
  }
}

# APP LOADBALANCER, TARGETGROUPS, LISTENERS
#==================================================#

# Create Application Load Balancer
resource "aws_lb" "ecs-alb" {
  name               = "${var.env_name}-alb"
  internal           = var.alb_internal
  load_balancer_type = var.load_balancer_type 
  security_groups    = var.ecs_lb_sg
  subnets            = var.ecs_lb_subnets
}

# Create Target Groups
resource "aws_lb_target_group" "django" {
  name     = "${var.env_name}-django-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  depends_on = [aws_lb.ecs-alb]
  health_check {
  interval = 30
  matcher = "200"
  path = "/static/index.html"
 }
}
# Celery target group is not required

resource "aws_lb_target_group" "bpm" {
  name     = "${var.env_name}-bpm-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  depends_on = [aws_lb.ecs-alb]
  health_check {
  interval = 30
  matcher = "200"
  path = "/984763987324_rand_index.jsp"
 }
}
resource "aws_lb_target_group" "frontend" {
  name     = "${var.env_name}-frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  depends_on = [aws_lb.ecs-alb]
  health_check {
  interval = 30
  matcher = "200"
  path = "/"
 }
}

# Listeners and default Rules
resource "aws_lb_listener" "http80" {
  load_balancer_arn = aws_lb.ecs-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django.arn
  }
 }

resource "aws_lb_listener" "https443" {
  load_balancer_arn = aws_lb.ecs-alb.arn
  port              = "8080"
  protocol          = "HTTP"
  #ssl_policy        = var.listener_ssl_policy
  #certificate_arn   = var.listener_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
 }

# Listener Rules other than defaults
resource "aws_lb_listener_rule" "http80-rules" {
  listener_arn = aws_lb_listener.http80.arn
  priority     = 100
  action {
    type          = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  condition {
    host_header {
      values = [var.django-fqdn]
    }
  }
}

resource "aws_lb_listener_rule" "https443-rules-django" {
  listener_arn = aws_lb_listener.https443.arn
  priority     = 101
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django.arn
  }
  condition {
    host_header {
      values = [
          var.django-fqdn,
          var.ca-portal-fqdn,
          var.ops-portal-fqdn
      ]
    }
  }
}

resource "aws_lb_listener_rule" "https443-rules-bpm" {
  listener_arn = aws_lb_listener.https443.arn
  priority     = 102
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bpm.arn
  }
  condition {
    host_header {
      values = [var.bpm-fqdn]
    }
  }
}

resource "aws_lb_listener_rule" "https443-rules-frontend" {
  listener_arn = aws_lb_listener.https443.arn
  priority     = 103
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
  condition {
    host_header {
      values = [var.frontend-fqdn]
    }
  }
}
*/
# ECS CLUSTER
#==================================================#

# Create a template file which contains the ecs cluster name and used by ecs-agent
data "template_file" "cluster-init" {
  template = "${file("userdata.tpl")}"
  vars = {
    cluster_name = var.ecs_cluster_name
  }
}

# Create ECS Cluster
resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.ecs_cluster_name
}

# Create a template file for each task definitions to pass certain values as variable
data "template_file" "django-td" {
  template = "${file("task-definitions/template.json")}"
  vars = {
    awslogs-group           = "${var.django-awslogs-group}"
    awslogs-region          = "${var.django-awslogs-region}"
    awslogs-stream-prefix   = "${var.django-awslogs-stream-prefix}"
    container_port          = "${var.django-container_port}"
    cpu                     = "${var.django-cpu}"
    memory                  = "${var.django-memory}"
    image                   = "${var.django-image}"
    labels                  = "${var.django-labels}"
    container_name          = "${var.django-container_name}"
  }
}

data "template_file" "celery-td" {
  template = "${file("task-definitions/template.json")}"
  vars = {
    awslogs-group           = "${var.celery-awslogs-group}"
    awslogs-region          = "${var.celery-awslogs-region}"
    awslogs-stream-prefix   = "${var.celery-awslogs-stream-prefix}"
    container_port          = "${var.celery-container_port}"
    cpu                     = "${var.celery-cpu}"
    memory                  = "${var.celery-memory}"
    image                   = "${var.celery-image}"
    labels                  = "${var.celery-labels}"
    container_name          = "${var.celery-container_name}"
  }
}

data "template_file" "bpm-td" {
  template = "${file("task-definitions/template.json")}"
  vars = {
    awslogs-group           = "${var.bpm-awslogs-group}"
    awslogs-region          = "${var.bpm-awslogs-region}"
    awslogs-stream-prefix   = "${var.bpm-awslogs-stream-prefix}"
    container_port          = "${var.bpm-container_port}"
    cpu                     = "${var.bpm-cpu}"
    memory                  = "${var.bpm-memory}"
    image                   = "${var.bpm-image}"
    labels                  = "${var.bpm-labels}"
    container_name          = "${var.bpm-container_name}"
  }
}

data "template_file" "frontend-td" {
  template = "${file("task-definitions/template.json")}"
  vars = {
    awslogs-group           = "${var.frontend-awslogs-group}"
    awslogs-region          = "${var.frontend-awslogs-region}"
    awslogs-stream-prefix   = "${var.frontend-awslogs-stream-prefix}"
    container_port          = "${var.frontend-container_port}"
    cpu                     = "${var.frontend-cpu}"
    memory                  = "${var.frontend-memory}"
    image                   = "${var.frontend-image}"
    labels                  = "${var.frontend-labels}"
    container_name          = "${var.frontend-container_name}"
  }
}

# Task definitions
resource "aws_ecs_task_definition" "django" {
  family                = "${var.env_name}-django-task"
  container_definitions = data.template_file.django-td.rendered
}
resource "aws_ecs_task_definition" "celery" {
  family                = "${var.env_name}-celery-task"
  container_definitions = data.template_file.celery-td.rendered
}
resource "aws_ecs_task_definition" "bpm" {
  family                = "${var.env_name}-bpm-task"
  container_definitions = data.template_file.bpm-td.rendered
}
resource "aws_ecs_task_definition" "frontend" {
  family                = "${var.env_name}-frontend-task"
  container_definitions = data.template_file.frontend-td.rendered
}

# Service Creation
resource "aws_ecs_service" "django" {
  name            = "${var.env_name}-django-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.django.arn
  desired_count   = var.django_tasks_count
  launch_type     = "EC2"
  /*
  load_balancer {
    target_group_arn = aws_lb_target_group.django.arn
    container_name   = var.django-container_name
    container_port   = var.django-container_port
  }
  */
}
resource "aws_ecs_service" "celery" {
  name            = "${var.env_name}-celery-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.celery.arn
  desired_count   = var.celery_tasks_count
  launch_type     = "EC2"
}
resource "aws_ecs_service" "bpm" {
  name            = "${var.env_name}-bpm-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.bpm.arn
  desired_count   = var.bpm_tasks_count
  launch_type     = "EC2"
  /*
  load_balancer {
    target_group_arn = aws_lb_target_group.django.arn
    container_name   = var.bpm-container_name
    container_port   = var.bpm-container_port
  }
  */
}
resource "aws_ecs_service" "frontend" {
  name            = "${var.env_name}-frontend-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = var.frontend_tasks_count
  launch_type     = "EC2"
  /*
  load_balancer {
    target_group_arn = aws_lb_target_group.django.arn
    container_name   = var.frontend-container_name
    container_port   = var.frontend-container_port
  }
  */
}

