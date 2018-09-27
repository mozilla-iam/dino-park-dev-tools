# dino-park-dev-tools
Some helper tools for DinoPark development.

## Local Development / Preview

### Prerequisites

#### Minikube

In order to bootstrap and run a local instance of DinoPark we need a local kubernetes cluster.
The easiest way to achieve this using [minikube](https://github.com/kubernetes/minikube).

We most likely need [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed.

Now we can start a cluster via:
```
$ minikube start
```

Make sure we enable the ingress addon:
```
$ minikube addons enable ingress
```

To stop it again run:
```
$ minikube stop
```

And to delete it:
```
$ minikube delete
```

#### DNS Cheating

To make ingress work for us we need to point `dinopark.mozilla.community` to the k8s cluster.
Just add a line to your `/etc/hosts`.

We can obtain the cluster IP via:
```
$ minikube ip
```

#### Docker

Please [install docker](https://docs.docker.com/install/).

In order to point docker to our k8s cluster run:
```
$ eval $(minikube docker-env)
```

#### Myke

We use [myke](https://github.com/goeuro/myke) to automate things.

We can download an install it from the [release page](https://github.com/goeuro/myke/releases).

There is also a clone of [myke written in Rust](https://github.com/fiji-flo/myke/releases) which is on par and stable.


## Running the Dev-Preview

Running the dev-preview is as simple as running:
```
$ git clone  https://github.com/mozilla-iam/dino-park-dev-tools.git

$ cd dino-park-dev-tools

# This will clone all DinoPark repositories to the parent directory for dino-park-dev-tools if they don't exist
$ myke git/checkout 

# Build all services
$ myke package

# Deploy to k8s
$ myke run-k8s
```

You should see the services and pods in k8s via:
```
$ kubectl get svc -ndino-park
$ kubectl get pods -ndino-park
```

The front-end will be served on [http://dinopark.mozilla.community](http://dinopark.mozilla.community).
