provider "aws" {
    region = "us-east-1"
    access_key = "AKIAZM4YJKGVVBI6N5MK"
    secret_key = "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"
}

resource "aws_ecs_cluster" "Jenkins" {
    name = "Jenkins_Cluster"
    capacity_providers = [ "FARGATE" ]
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

resource "aws_cloudwatch_log_group" "Jenkins" {
    name = "Jenkins"
}

resource "aws_ecs_task_definition" "Jenkins" {
    family = "service"
    task_role_arn = "arn:aws:iam::646175084971:role/ecsTaskExecutionRole"
    execution_role_arn = "arn:aws:iam::646175084971:role/ecsTaskExecutionRole"
    network_mode = "awsvpc"
    requires_compatibilities = [ "FARGATE" ]
    cpu = "256"
    memory = "1024"
    container_definitions = jsonencode([
        {
            name = "Jenkins"
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-region = "us-east-1"
                    awslogs-group = aws_cloudwatch_log_group.Jenkins.id
                    awslogs-stream-prefix = "ecs"
                }
            }
            essential = true
            image = "public.ecr.aws/f4d7n5x3/jenkins"
            portMappings = [
                {
                    containerPort = 8080
                }
            ]
            mountPoints = [
                {
                    sourceVolume = "Jenkins"
                    containerPath = "/var/jenkins_home"
                }
            ]
            
        } 
    ])
    
    volume {
      name = "Jenkins"
      efs_volume_configuration {
          file_system_id = "fs-876e6c32"
          root_directory = "/"
      }
    }
}

resource "aws_ecs_service" "Jenkins" {
    name = "Jenkins"
    cluster = aws_ecs_cluster.Jenkins.id
    task_definition = aws_ecs_task_definition.Jenkins.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        assign_public_ip = true
        subnets = [ aws_default_subnet.default_az1.id ]
    }
}

///resource "aws_efs_file_system" "Jenkins" {
///    creation_token = "Jenkins"
///    lifecycle {
///     prevent_destroy = true
///    }
///}

///resource "aws_efs_mount_target" "Jenkins" {
    ///file_system_id = aws_efs_file_system.Jenkins.id
    ///subnet_id = aws_default_subnet.default_az1.id
///}

///resource "aws_efs_access_point" "Jenkins" {
    ///file_system_id = aws_efs_file_system.Jenkins.id
    ///lifecycle {
      ///prevent_destroy = true
    ///}
    ///root_directory {
      ///path = "/mnt/efs"
    ///}
  
///}
//output "Jenkins_IP" {
//    value = aws_ecs_task_definition.Jenkins.*.public_ip
//}
