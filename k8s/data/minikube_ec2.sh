#!/usr/bin/env bash
sudo su ec2-user
export EC2USER=/home/ec2-user

# docker
sudo yum update -y
sudo amazon-linux-extras install -y docker
sudo systemctl enable --now docker
sudo usermod -a -G docker ec2-user
newgrp docker

# minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo cp minikube /usr/bin/ && rm minikube
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo cp kubectl /usr/bin/ && rm kubectl

mkdir -p $EC2USER/.kube
touch $EC2USER/.kube/config
cat <<EOF > $EC2USER/.profile
export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_EC2USER=$EC2USER
export CHANGE_MINIKUBE_NONE_USER=true
export KUBECONFIG=$EC2USER/.kube/config
EOF
source $EC2USER/.profile
sudo -E minikube config set vm-driver none
sudo -E minikube start

for i in {1..150}; do # timeout for 5 minutes
   kubectl get po &> /dev/null
   if [ $? -ne 1 ]; then
      break
  fi
  sleep 2
done
sudo -E minikube addons enable ingress

# dinopark
sudo yum install -y git

sudo curl -L -o /usr/bin/myke https://github.com/fiji-flo/myke/releases/download/0.9.9/myke-0.9.9-x86_64-unknown-linux-musl
sudo chmod +x /usr/bin/myke

mkdir -p $EC2USER/dinopark
cd $EC2USER/dinopark
git clone https://github.com/mozilla-iam/dino-park-dev-tools.git

cd dino-park-dev-tools
myke checkout
myke package
myke run-k8s
