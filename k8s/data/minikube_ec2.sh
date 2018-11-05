#!/usr/bin/env bash

# docker
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable --now docker
sudo usermod -a -G docker ubuntu

# minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo cp minikube /usr/bin/ && rm minikube
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo cp kubectl /usr/bin/ && rm kubectl

mkdir -p $HOME/.kube
touch $HOME/.kube/config
cat <<EOF > $HOME/.profile
export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
export KUBECONFIG=$HOME/.kube/config
EOF
source $HOME/.profile
sudo -E minikube config set vm-driver none
sudo -E minikube start

for i in {1..150}; do # timeout for 5 minutes
   kubectl get po &> /dev/null
   if [ $? -ne 1 ]; then
      break
  fi
  sleep 2
done
sudo cp -v /root/.minikube/{client.crt,client.key,ca.crt} ~/.minikube/certs/
sudo -E minikube addons enable ingress

# dinopark

sudo curl -L -o /usr/bin/myke https://github.com/fiji-flo/myke/releases/download/0.9.11/myke-0.9.11-x86_64-unknown-linux-musl
sudo chmod +x /usr/bin/myke

mkdir -p $HOME/dinopark
cd $HOME/dinopark
git clone https://github.com/mozilla-iam/dino-park-dev-tools.git

cd dino-park-dev-tools
myke checkout
myke package
myke run-k8s