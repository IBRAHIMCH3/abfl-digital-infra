# Environmental variables

aws_region                      = "ap-southeast-1"
env_name                        = "abfl-digital"
vpc_id                          = "vpc-d80dc3be"
iam_profile 					          = "ecs-ec2-profile"
iam_role 						            = "ecsInstanceRole"
keypair 						            = "NewAws"
alb_security_groups 			      = ["sg-e02a8eac"]
alb_internal 					          = "false"
load_balancer_type 				      = "application"

# EC2 and ALB Instance related variables
instance_type                   = "t2.micro"
min_instance_count              = 1
max_instance_count              = 2
ecs_ec2_sg                      = ["sg-e02a8eac"]
ecs_asg_subnets                 = ["subnet-d32d8e9b"]
ecs_lb_sg                       = ["sg-e02a8eac"]
ecs_lb_subnets                  = ["subnet-d32d8e9b", "subnet-5bc6a802"]
#listener_ssl_policy             = "ELBSecurityPolicy-TLS-1-2-2017-01"
#listener_certificate_arn        = "arn:aws:acm:ap-southeast-1:605473850426:certificate/7bca7704-b84f-4f0f-b9c9-f4cd6928da09"
# ECS Cluster
ecs_cluster_name                =  "abfl-digital-kuliza-dev"

# Django variables
django-fqdn                     = "dr-django.abfldirect.com"
django-awslogs-group            = "dr-ecs-django-logs"
django-awslogs-region           = "ap-southeast-1"
django-awslogs-stream-prefix    = "/var/log/django-gunicorn-ng.login"
django-container_port           = 8000
django-cpu                      = 100
django-memory                   = 600
django-image                    = "109420162169.dkr.ecr.ap-southeast-1.amazonaws.com/django:latest"
django-labels                   = "dr-ecs-django-container"
django-container_name           = "dr-ecs-django-container"
django_tasks_count              = 1

# Celery variables
celery-fqdn                     = "dr-celery.abfldirect.com"
celery-awslogs-group            = "dr-ecs-celery-logs"
celery-awslogs-region           = "ap-southeast-1"
celery-awslogs-stream-prefix    = "/var/log/celery"
celery-container_port           = 80
celery-cpu                      = 100
celery-memory                   = 512
celery-image                    = "109420162169.dkr.ecr.ap-southeast-1.amazonaws.com/celery:latest"
celery-labels                   = "dr-ecs-celery-container"
celery-container_name           = "dr-ecs-celery-container"
celery_tasks_count              = 1

# BPM variables
bpm-fqdn                        = "dr-bpm.abfldirect.com"
bpm-awslogs-group               = "dr-ecs-bpm-logs"
bpm-awslogs-region              = "ap-southeast-1"
bpm-awslogs-stream-prefix       = "/opt/tomcat/logs/debug.log"
bpm-container_port              = 8080
bpm-cpu                         = 100
bpm-memory                      = 512
bpm-image                       = "109420162169.dkr.ecr.ap-southeast-1.amazonaws.com/bpm:latest"
bpm-labels                      = "dr-ecs-bpm-container"
bpm-container_name              = "dr-ecs-bpm-container"
bpm_tasks_count                 = 1

# Frontend variables
frontend-fqdn                   = "dr-frontend.abfldirect.com"
frontend-awslogs-group          = "dr-ecs-frontend-logs"
frontend-awslogs-region         = "ap-southeast-1"
frontend-awslogs-stream-prefix  = "/opt/tomcat/logs/debug.log"
frontend-container_port         = 80
frontend-cpu                    = 100
frontend-memory                 = 100
frontend-image                  = "109420162169.dkr.ecr.ap-southeast-1.amazonaws.com/frontend:latest"
frontend-labels                 = "dr-ecs-frontend-container"
frontend-container_name         = "dr-ecs-frontend-container"
frontend_tasks_count            = 1

# Other Access URLS
ca-portal-fqdn                  = "dr-ca-portal.abfldirect.com"
ops-portal-fqdn                 = "dr-ops-portal.abfldirect.com"

