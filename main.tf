provider "aws" {
  region = "eu-west-1"
}

data "template_file" "app_user_data" {
  template = "${file("${path.module}/templates/app/user_data.sh.tpl")}"
  vars {
    db_host = "mongodb://${aws_instance.db_instance.private_ip}:27017/posts"
  }
}

resource "aws_instance" "app-instance" {
  ami = "${var.app_ami_id}"
  instance_type = "t2.micro"
  user_data = "${data.template_file.app_user_data.rendered}"
  tags {
    Name = "Manvir-app"
  }
}

resource "aws_instance" "db_instance" {
  ami = "${var.db_ami_id}"
  instance_type = "t2.micro"
  tags {
    Name = "Manvir-db"
  }
}
