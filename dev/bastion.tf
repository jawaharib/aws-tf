module "key_pair_bastion" {
  source = "../modules/ec2-key-pair"

  key_name   = "${var.app_name}-${var.env}-bastion"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPOpgWA1Us+DwkR1m/HCVXTAnQrdUKijskLoELPfptkbX2VkDTppIIROl9tg7fM2r2+6GRJESlnsYOloiygGKZv8nUlkMeTDxbGroB0CvhdjtkrTSv+1RzWYomEzc+ZBrBwO+8cKVorVIRKuUzErfJ5RbVe91f+GKMkMExpR43yhrZbmcaKgBzcI9mxaCeOMtPjSYAAMOysjycL1XXZrD0JKwWODNGOToA/uWghiFPViDS4XshfrniRYS/TIN8pZeVtIaQCDEGYMCsrL2+wh3Ole/U9S1xvFv3QqRlyNGGVA8UTzxPD4vgkBkJD7yK1gey5GhOpl5qjRr5llmCdEQ1n7zgunwBvlfjo06wapMLXq1nxJNKhMsiW91gIgUYvcgRyiDyVlOw3Afn1ctOq8SOfhqxlTcBBOzwsO23T23Cxm6Yw+pRvgS5vNpveCfuUVsD6RVjj8nhIkjgOk+HMebeX/KfNGvnvxj29hz4M7wxWYHovUX7rFmvN/blQs5fx4E= app_coinswitch"

  tags = local.tags
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
  instance = module.bastion_server.id[0]
  tags = merge(
    {
      "Name" = "${var.app_name}-${var.env}-bastion-host-eip"
    },
    local.tags
  )
}

module "bastion_server" {
  source = "../modules/ec2"

  instance_count = 1

  name                        = "${var.app_name}-${var.env}-bastion-host"
  ami                         = "ami-0d058fe428540cd89"
  instance_type               = "t3.small"
  subnet_ids                  = module.vpc["vpc1"].public_subnets
  private_ips                 = ["10.169.0.232"]
  vpc_security_group_ids      = [module.bastion_security_group.id]
  associate_public_ip_address = true
  key_name                    = module.key_pair_bastion.key_pair_key_name

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

  tags = local.tags
}
