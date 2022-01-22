
################# Commom Variables #######################
locals {
  name   = var.env
  region = var.region
}

########################## VPC ############################
locals {
  vpc_settings = {
    vpc1 = {
      name = "${var.app_name}-${var.env}-vpc"
      cidr                               = "10.169.0.0/16"
      public_subnets                     = ["10.169.0.0/21", "10.169.8.0/21"]
      private_subnets                    = ["10.169.32.0/21", "10.169.40.0/21"]
      database_subnets                   = ["10.169.96.0/24", "10.169.97.0/24"]
      azs                                = ["ap-southeast-1a", "ap-southeast-1b"]
      manage_default_route_table         = true
      create_database_subnet_route_table = true
      create_database_subnet_group       = false
      public_subnet_tags = {
        "subnet_type" = "public"
      }
      private_subnet_tags = {
        "subnet_type" = "private"
      }
      database_subnet_tags = {
        "subnet_type" = "database"
      }
      private_dedicated_network_acl = true
      private_inbound_acl_rules = [
        {
          "rule_number" = 10
          "rule_action" = "allow"
          "from_port"   = 1024
          "to_port"     = 65535
          "protocol"    = "tcp"
          "cidr_block"  = "10.169.0.0/21"
        },
        {
          "rule_number" = 20
          "rule_action" = "allow"
          "from_port"   = 1024
          "to_port"     = 65535
          "protocol"    = "tcp"
          "cidr_block"  = "10.169.8.0/21"
        },
        {
          "rule_number" = 30
          "rule_action" = "allow"
          "from_port"   = 22
          "to_port"     = 22
          "protocol"    = "tcp"
          "cidr_block"  = "10.169.0.232/32"
        },
        {
          "rule_number" = 35
          "rule_action" = "allow"
          "from_port"   = 443
          "to_port"     = 443
          "protocol"    = "tcp"
          "cidr_block"  = "0.0.0.0/0"
        },
        {
          "rule_number" = 40
          "rule_action" = "allow"
          "from_port"   = 0
          "to_port"     = 0
          "protocol"    = "-1"
          "cidr_block"  = "10.169.0.0/21"
        },
        {
          "rule_number" = 50
          "rule_action" = "allow"
          "from_port"   = 0
          "to_port"     = 0
          "protocol"    = "-1"
          "cidr_block"  = "10.169.8.0/21"
        },
        {
          "rule_number" = 60
          "rule_action" = "allow"
          "from_port"   = 0
          "to_port"     = 0
          "protocol"    = "-1"
          "cidr_block"  = "0.0.0.0/0"
        }
      ]
      database_dedicated_network_acl = false
      database_inbound_acl_rules = [
        {
          "rule_number" = 10
          "rule_action" = "allow"
          "from_port"   = 5432
          "to_port"     = 5432
          "protocol"    = "tcp"
          "cidr_block"  = "10.169.32.0/21"
        },
        {
          "rule_number" = 20
          "rule_action" = "allow"
          "from_port"   = 5432
          "to_port"     = 5432
          "protocol"    = "tcp"
          "cidr_block"  = "10.169.40.0/21"
        },
        {
          "rule_number" = 30
          "rule_action" = "allow"
          "from_port"   = 5432
          "to_port"     = 5432
          "protocol"    = "tcp"
          "cidr_block"  = "10.169.0.232/32"
        }
      ]
    }
  }
}

##################### VPC Endpoints ######################
locals {
  endpoints = {
    s3_vpc1 = {
      service   = "s3"
      vpc_index = "vpc1"
      tags = {
        Name = "s3-vpc-endpoint-develop"
      }
    },
    dynamodb_vpc1 = {
      service      = "dynamodb"
      vpc_index    = "vpc1"
      service_type = "Gateway"
//      policy       = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
      tags = {
        Name = "dynamodb-vpc-endpoint-develop"
      }
    }
  }
}

############ Security Groups ################
locals {
  frontend_security_group = {
    name = "frontend-develop",
    ingress = [
      {
        type        = "ingress"
        cidr_blocks = ["49.36.211.153/32", "18.138.215.40/32"]
        description = "Allows traffic on Port 80"
        from_port   = "80"
        to_port     = "80"
        protocol    = "tcp"
      },
      {
        type        = "ingress"
        cidr_blocks = ["49.36.211.153/32", "18.138.215.40/32"]
        description = "Allows traffic on Port 80"
        from_port   = "8000"
        to_port     = "8000"
        protocol    = "tcp"
      },
      {
        cidr_blocks = ["49.36.211.153/32", "18.138.215.40/32"]
        type        = "ingress"
        description = "Allows traffic on Port 443"
        from_port   = "443"
        to_port     = "443"
        protocol    = "tcp"
      }
    ],
    egress = [
      {
        type        = "egress"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow All Outbound"
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
      }
    ]
  }
  backend_security_group = {
    name = "backend-develop",
    ingress = [
      {
        type        = "ingress"
        self        = true
        description = "Allows all traffic from self"
        from_port   = "0"
        to_port     = "65535"
        protocol    = "tcp"
      },
      {
        type           = "ingress"
        description    = "Allows all traffic from Frontend SG(${module.frontend_security_group.id})"
        from_port      = "0"
        to_port        = "65535"
        protocol       = "tcp"
        security_group = toset([module.frontend_security_group.id])
      },
      {
        type        = "ingress"
        description = "Allows SSH from Bastion Private IP"
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = [format("%s/32", module.bastion_server.private_ip[0])]
      }
    ],
    egress = [
      {
        type        = "egress"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow All Outbound"
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
      },
      {
        type        = "egress"
        ipv6_cidr_blocks = ["::/0"]
        description = "Allow All Outbound"
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
      }
    ]
  }
  bastion_security_group = {
    name = "bastion-develop",
    ingress = [
      {
        type        = "ingress"
        cidr_blocks = ["18.138.215.40/32"]
        description = "Allows traffic on Port 22 from CoinSwitch VPN"
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
      }
    ],
    egress = [
      {
        type        = "egress"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow All Outbound"
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
      }
    ]
  }
  lambda_security_group = {
    name    = "lambda-develop",
    ingress = [],
    egress = [
      {
        type        = "egress"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow All Outbound Communication 1"
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
      },
      {
        type             = "egress"
        ipv6_cidr_blocks = ["::/0"]
        description      = "Allow All Outbound Communication 2"
        from_port        = "0"
        to_port          = "0"
        protocol         = "-1"
      }
    ]
  }
}

################# ALB #######################
locals {
  alb_settings = {
    load_balancer_1_with_listeners = {
      name                       = "frontend"
      internal                   = false
      load_balancer_type         = "application"
      subnets                    = module.vpc["vpc1"].public_subnets
      vpc_id                     = module.vpc["vpc1"].vpc_id
//      security_groups            = [module.frontend_security_group.id, "sg-018318ede3112d2b9"]
      security_groups            = [module.frontend_security_group.id]
      drop_invalid_header_fields = true
      enable_deletion_protection = true
      target_groups = [
        {
          name                 = "nginx-develop"
          backend_protocol     = "HTTP"
          backend_port         = 80
          target_type          = "instance"
          deregistration_delay = 10
          health_check = {
            enabled             = true
            interval            = 30
            path                = "/status"
            port                = "traffic-port"
            healthy_threshold   = 3
            unhealthy_threshold = 3
            timeout             = 6
            protocol            = "HTTP"
            matcher             = "200-399"
          }
          protocol_version = "HTTP1"
          tags = {
            InstanceTargetGroupTag = "baz-develop"
          }
        },
        {
          name                 = "cs-web-uwsgi-service-develop"
          backend_protocol     = "HTTP"
          backend_port         = 80
          target_type          = "instance"
          deregistration_delay = 10
          health_check = {
            enabled             = true
            interval            = 30
            path                = "/test"
            port                = "traffic-port"
            healthy_threshold   = 3
            unhealthy_threshold = 5
            timeout             = 10
            protocol            = "HTTP"
            matcher             = "200-399"
          }
          protocol_version = "HTTP1"
          tags = {
            InstanceTargetGroupTag = "cs-web-uwsgi-stage-service-develop"
          }
        },
        {
          name                 = "cs-india-uwsgi-develop-tg"
          backend_protocol     = "HTTP"
          backend_port         = 80
          target_type          = "instance"
          deregistration_delay = 10
          health_check = {
            enabled             = true
            interval            = 30
            path                = "/test"
            port                = "traffic-port"
            healthy_threshold   = 3
            unhealthy_threshold = 3
            timeout             = 6
            protocol            = "HTTP"
            matcher             = "200-399"
          }
          protocol_version = "HTTP1"
          tags = {
            InstanceTargetGroupTag = "cs-india-uwsgi-develop"
          }
        },
        {
          name                 = "cs-web-ui-develop"
          backend_protocol     = "HTTP"
          backend_port         = 80
          target_type          = "instance"
          deregistration_delay = 10
          health_check = {
            enabled             = true
            interval            = 30
            path                = "/proxy/test"
            port                = "traffic-port"
            healthy_threshold   = 3
            unhealthy_threshold = 3
            timeout             = 6
            protocol            = "HTTP"
            matcher             = "200-399"
          }
          protocol_version = "HTTP1"
          tags = {
            InstanceTargetGroupTag = "cs-india-uwsgi-develop"
          }
        },
        {
          name                 = "ledger-develop"
          backend_protocol     = "HTTP"
          backend_port         = 80
          target_type          = "instance"
          deregistration_delay = 10
          health_check = {
            enabled             = true
            interval            = 30
            path                = "/test"
            port                = "traffic-port"
            healthy_threshold   = 3
            unhealthy_threshold = 3
            timeout             = 6
            protocol            = "HTTP"
            matcher             = "200-399"
          }
          protocol_version = "HTTP1"
          tags = {
            InstanceTargetGroupTag = "ledger-develop"
          }
        },
        {
          name                 = "cs-india-kyc-develop"
          backend_protocol     = "HTTP"
          backend_port         = 80
          target_type          = "instance"
          deregistration_delay = 10
          health_check = {
            enabled             = true
            interval            = 30
            path                = "/api/v2/kyc/test"
            port                = "traffic-port"
            healthy_threshold   = 3
            unhealthy_threshold = 3
            timeout             = 6
            protocol            = "HTTP"
            matcher             = "200-399"
          }
          protocol_version = "HTTP1"
          tags = {
            InstanceTargetGroupTag = "cs-india-kyc-develop"
          }
        },
        {
          name                 = "cs-india-auth-develop"
          backend_protocol     = "HTTP"
          backend_port         = 80
          target_type          = "instance"
          deregistration_delay = 10
          health_check = {
            enabled             = true
            interval            = 300
            path                = "/auth/api/v1/test1"
            port                = "traffic-port"
            healthy_threshold   = 2
            unhealthy_threshold = 10
            timeout             = 60
            protocol            = "HTTP"
            matcher             = "200-399"
          }
          protocol_version = "HTTP1"
          tags = {
            InstanceTargetGroupTag = "cs-india-auth-develop"
          }
        }
      ]
      target_group_tags = {
        key1 = "value1"
      }
      http_tcp_listeners = [
        {
          port               = 80
          protocol           = "HTTP"
          target_group_index = 1
          action_type        = "forward"
        }
        # },
        # {
        #   port               = 443
        #   protocol           = "HTTP"
        #   target_group_index = 1
        #   action_type        = "forward"
        # }
      ]
      http_listener_rules = []
      https_listeners = [
        {
          port               = 443
          protocol           = "HTTPS"
          target_group_index = 1
          action_type        = "forward"
          certificate_arn    = "arn:aws:acm:ap-southeast-1:162877423038:certificate/3e3e3391-0e02-4400-93f8-80bb3fdbb79a"
        }
      ]

      https_listener_rules = [
        {
          https_listener_index = 0
          priority             = 37
          actions = [
            {
              type               = "forward"
              target_group_index = 2
            }
          ]
          conditions = [{
            host_headers = ["cs-india-stage.coinswitch.co", "cs-india-stage1.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 38
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/inr-pre-launch/*", "/support/*", "/in/*", "/cryptocurency-exchange-in-india"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 39
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/blog/*", "/referral-giveaway/*", "/india-pre-launch/*", "/wallets/*"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 40
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/bnb-swap/*", "/pro/*", "/simplex/*", "/wallet-exchange/*"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 41
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/tron-link/*", "/kin-swap/*", "/about-us/*", "/payment/*"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 42
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/products/*", "media-portal/*", "/switch-demo/*", "/referral/*"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 43
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/aws-upload/*", "/switch/*", "/static/*", "/pay/*"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 44
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/partners/*", "/site/*", "/tools/*", "/athena/*"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 45
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/news/*", "/info/*", "/coins/*", "/widget/*"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 47
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/inr-pre-launch/*", "/support/*", "/in/*", "/cryptocurency-exchange-in-india"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 48
          actions = [
            {
              type               = "forward"
              target_group_index = 3
            }
          ]
          conditions = [{
            path_patterns = ["/proxy/*", "/video/*", "/airdrop/*", "/youtube-partners/*"]
            host_headers  = ["dev.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 49
          actions = [
            {
              type               = "forward"
              target_group_index = 4
            }
          ]
          conditions = [{
            path_patterns = ["/ledger-dev-service/*"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 35
          actions = [
            {
              type               = "forward"
              target_group_index = 5
            }
          ]
          conditions = [{
            path_patterns = ["/api/v2/kyc/*"]
            host_headers  = ["cs-india-stage.coinswitch.co"]
          }]
        },
        {
          https_listener_index = 0
          priority             = 36
          actions = [
            {
              type               = "forward"
              target_group_index = 6
            }
          ]
          conditions = [{
            path_patterns = ["/auth/*"]
            host_headers  = ["cs-india-stage.coinswitch.co"]
          }]
        }
      ]
    }
  }
}

################ CW Alerts ##################
//locals {
//  cloudwatch_alarm_settings = {
//    "elb1" = {
//      alarm_name          = "CoinSwitch Alert: Website LB 500 increased"
//      alarm_description   = "High number of API 500"
//      datapoints_to_alarm = 5
//      dimensions = {
//        LoadBalancer = module.alb["load_balancer_1_with_listeners"].lb_arn_suffix
//      }
//      threshold = "1000"
//      tags = {
//        "Name" = "CoinSwitch Alert: Website LB 500 increased"
//      }
//      comparison_operator = "GreaterThanOrEqualToThreshold"
//      evaluation_periods  = "5"
//      metric_name         = "HTTPCode_Target_5XX_Count"
//      namespace           = "AWS/ApplicationELB"
//      period              = "60"
//      statistic           = "Sum"
//      alarm_actions       = ["arn:aws:sns:ap-southeast-1:162877423038:slack-only-alert-dev"]
//      treat_missing_data  = "notBreaching"
//    },
//
//    "elb2" = {
//      alarm_name          = "CoinSwitch Alert: Low healthy host for website LB"
//      alarm_description   = "Created from EC2 Console"
//      datapoints_to_alarm = 4
//      dimensions = {
//        LoadBalancer = module.alb["load_balancer_1_with_listeners"].lb_arn_suffix
//        TargetGroup  = module.alb["load_balancer_1_with_listeners"].target_group_arn_suffixes[0]
//      }
//      threshold = "2"
//      tags = {
//        "Name" = "CoinSwitch Alert: Website LB 500 increased"
//      }
//      comparison_operator = "LessThanThreshold"
//      evaluation_periods  = "4"
//      metric_name         = "HealthyHostCount"
//      namespace           = "AWS/ApplicationELB"
//      period              = "60"
//      statistic           = "Average"
//      alarm_actions       = ["arn:aws:sns:ap-southeast-1:162877423038:slack-only-alert-dev"]
//      treat_missing_data  = "missing"
//    }
//
//  }
//}
