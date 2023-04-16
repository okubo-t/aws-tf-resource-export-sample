#
# リソースの情報をCloudformationのOutputs機能を使ってエクスポートする
# このStackでTerraformのバックエンド用のリソースを作成する
#
resource "aws_cloudformation_stack" "this" {
  name = "tf-resource-export-sample"

  template_body = templatefile("./tf-resource-export.yml", {

    # tfstateのリソース作成用
    tfstate_backend = {
      s3_bucket_name          = "tf-resource-export-sample"
      dynamodb_for_state_lock = "tf-resource-export-sample"
    },

    # サブネット情報のOutputs用
    network = {
      private_subnet_1a_name = "PrivateSubnet1a"
      private_subnet_1a_id   = module.network.private_subnets[0]
      private_subnet_1c_name = "PrivateSubnet1c"
      private_subnet_1c_id   = module.network.private_subnets[1]
    },

    # セキュリティグループ情報のOutputs用
    security_group = {
      name_for_lambda = "HelloWorldFunctionSG"
      id_for_lambda   = aws_security_group.this.id
    }
  })
}

#
# Terraformで構築するリソース
#
module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "tf-resource-export-sample"

  cidr            = "10.0.0.0/16"
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]

  create_igw           = false
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "this" {
  name        = "tf-resource-export-sample"
  description = "Security Group"
  vpc_id      = module.network.vpc_id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
