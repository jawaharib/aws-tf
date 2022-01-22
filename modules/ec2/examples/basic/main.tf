provider "aws" {
  region = "eu-west-1"
}

locals {
  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
EOF
}

##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################

resource "aws_eip" "this" {
  vpc      = true
  instance = module.ec2.id[0]
}

module "ec2" {
  source = "../../"

  instance_count = var.instance_count

  name          = "${var.app_name}-${var.env}-bastion-host"
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "c5.large"
  subnet_id     = tolist(data.aws_subnet_ids.all.ids)[0]
  #  private_ips                 = ["172.31.32.5", "172.31.46.20"]
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true
  placement_group             = aws_placement_group.web.id

  user_data_base64 = base64encode(local.user_data)

  enable_volume_tags = false
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 15
      tags = {
        Name = "bastion-root-block"
      }
    },
  ]

  tags = {
    "Env"      = "Private"
    "Location" = "Secret"
  }
}
