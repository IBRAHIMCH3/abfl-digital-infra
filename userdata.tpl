#!/bin/bash
echo "ECS_CLUSTER= ${cluster_name}" > /etc/ecs/ecs.config
echo 'ECS_RESERVED_MEMORY=114'  >> /etc/ecs/ecs.config
echo 'ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]' >>  /etc/ecs/ecs.config