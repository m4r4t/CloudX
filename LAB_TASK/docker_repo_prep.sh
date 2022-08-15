docker tag ghost:4.12 047259566030.dkr.ecr.eu-west-1.amazonaws.com/ghost:4.12
aws ecr get-login-password --region eu-west-1 --profile epam_test | docker login --username AWS --password-stdin 047259566030.dkr.ecr.eu-west-1.amazonaws.com/ghost
docker push 047259566030.dkr.ecr.eu-west-1.amazonaws.com/ghost:4.12