provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app" {
  ami = "${var.app_ami_id}"
  instance_type = "t2.micro"

  tags {
    Name = "Manvir-app"
  }
}
