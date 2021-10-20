# Environmental variables
variable "aws_region" {} 
#variable "env_name" {}  
#variable "vpc_id" {} 
#variable "iam_profile" {}
#variable "iam_role" {}
#variable  "keypair" {}
#variable  "alb_security_groups"  {}
#variable  "alb_internal" {}
#variable  "load_balancer_type" {}


# SSH Key related variables
# variable "key_name" {}
# variable "public_key" {} # or
# variable "public_key_path" {} 

# EC2 and ALB Instance related variables
#variable "instance_type" {}
#variable "min_instance_count" {}
#variable "max_instance_count" {}
#variable "ecs_ec2_sg" { type = list(string)}
#variable "ecs_asg_subnets" { type = list(string)}
#variable "ecs_lb_sg" { type = list(string)}
#variable "ecs_lb_subnets" { type = list(string)}
#variable "listener_ssl_policy" {}        
#variable "listener_certificate_arn" {}   

# ECS Cluster
variable "ecs_cluster_name" {}

# Django variables
variable "django-fqdn" {}
variable "django-awslogs-group" {}
variable "django-awslogs-region" {}          
variable "django-awslogs-stream-prefix" {}
variable "django-container_port" {}          
variable "django-cpu" {}                    
variable "django-memory" {}                 
variable "django-image" {}              
variable "django-labels" {}             
variable "django-container_name" {}  
variable "django_tasks_count" {}    

# Celery variables
variable "celery-fqdn" {}
variable "celery-awslogs-group" {}
variable "celery-awslogs-region" {}          
variable "celery-awslogs-stream-prefix" {}
variable "celery-container_port" {}          
variable "celery-cpu" {}                    
variable "celery-memory" {}                 
variable "celery-image" {}              
variable "celery-labels" {}             
variable "celery-container_name" {}  
variable "celery_tasks_count" {}  

# BPM variables
variable "bpm-fqdn" {}
variable "bpm-awslogs-group" {}
variable "bpm-awslogs-region" {}          
variable "bpm-awslogs-stream-prefix" {}
variable "bpm-container_port" {}          
variable "bpm-cpu" {}                    
variable "bpm-memory" {}                 
variable "bpm-image" {}              
variable "bpm-labels" {}             
variable "bpm-container_name" {}  
variable "bpm_tasks_count" {}

# Frontend variables
variable "frontend-fqdn" {}
variable "frontend-awslogs-group" {}
variable "frontend-awslogs-region" {}          
variable "frontend-awslogs-stream-prefix" {}
variable "frontend-container_port" {}          
variable "frontend-cpu" {}                    
variable "frontend-memory" {}                 
variable "frontend-image" {}              
variable "frontend-labels" {}             
variable "frontend-container_name" {}  
variable "frontend_tasks_count" {} 

# Other Access URLS
variable "ca-portal-fqdn" {}                      
variable "ops-portal-fqdn" {}     


############# AMI #########

#variable "instance-migration-name" {}
#variable "source_instance_id" {}
