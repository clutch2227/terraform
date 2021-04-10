module "shared_vpc" {
  source = "./modules/shared_vpc"
  cidr_block_public1  = "10.1.0.0/16"
  cidr_block_public2  = "10.2.0.0/16"
  cidr_block_private1 = "10.3.0.0/16"
  cidr_block_private2 = "10.4.0.0/16"
}