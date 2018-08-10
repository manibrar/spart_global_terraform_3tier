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
  availability_zone = "eu-west-1a"
  tags {
    Name = "Manvir-app"
  }
}

resource "aws_instance" "db_instance" {
  ami = "${var.db_ami_id}"
  instance_type = "t2.micro"
  availability_zone = "eu-west-1a"
  tags {
    Name = "Manvir-db"
  }
}

resource "aws_elb" "elb_manvir" {
  name               = "elb-manvir"
  availability_zones = ["eu-west-1a"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.app-instance.id}"]

  tags {
    Name = "elb-manvir"
  }
}
