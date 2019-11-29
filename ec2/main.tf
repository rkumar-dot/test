terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}

  # The latest version of Terragrunt (v0.19.0 and above) requires Terraform 0.12.0 or above.
  required_version = ">= 0.12.0"
}

resource "aws_instance" "web" {
  ami = "ami-0c5204531f799e0c6"
  instance_type = "t2.micro"
  tags {
    Name = "HelloWorld"
  }
  security_groups = [ "${aws_security_group.my_security_group.id}" ]
}
