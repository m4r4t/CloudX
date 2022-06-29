resource "aws_default_subnet" "az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}