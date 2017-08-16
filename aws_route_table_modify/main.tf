provider "aws" {
  region = "ap-southeast-2"
  alias  = "local"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "ap-southeast-2a"
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "ap-southeast-2a"
  cidr_block        = "10.0.2.0/24"
}

resource "aws_instance" "server" {
  instance_type = "t2.nano"
  ami           = "ami-ae6259cd"
  subnet_id     = "${aws_subnet.subnet1.id}"
}

resource "aws_network_interface" "test" {
  subnet_id   = "${aws_subnet.subnet2.id}"
  private_ips = ["10.0.2.100"]

  attachment {
    instance     = "${aws_instance.server.id}"
    device_index = 1
  }
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block           = "10.1.1.1/32"
    instance_id = "${aws_instance.server.id}"
  }
}
