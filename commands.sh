export CONTAINER_REGISTRY=test.test.com
export version=1

#Replace environment variables in a file
#envsubst < ./scripts/kubernetes/deploy.yaml
envsubst < deploy.yaml
#Output:
# Deploys the video-streaming microservice to Kubernetes.
#
# To deploy:
#
# export CONTAINER_REGISTRY=<your-container-registry>
# export VERSION=<the-version-to-deploy>
# envsubst < ./scripts/kubernetes/deploy.yaml | kubectl apply -f -
#
#apiVersion: apps/v1
#kind: Deployment
#metadata:
#  name: video-streaming
#spec:
#  replicas: 1
#  selector:
#    matchLabels:
#      app: video-streaming
#  template:
#    metadata:
#      labels:
#        app: video-streaming
#    spec:
#      containers:
#      - name: video-streaming
#>>        image: test.test.com/video-streaming:1
#        imagePullPolicy: IfNotPresent
#        env:
#        - name: PORT
#          value: "4000"
#---
#apiVersion: v1
#kind: Service
#metadata:
#  name: video-streaming
#spec:
#  selector:
#    app: video-streaming
#  type: LoadBalancer
#  ports:
#    - protocol: TCP
#      port: 80
#      targetPort: 4000

# chapter-8-example-3/scripts/build-image.sh
docker build -t $CONTAINER_REGISTRY/video-streaming:$VERSION --file ./Dockerfile-prod .

#Get credentials
cat ~/.kube/config

#Check how many contexts are already connected
kubectl config get-contexts
#CURRENT   NAME             CLUSTER          AUTHINFO                            NAMESPACE
#          aksdemo1         aksdemo1         clusterUser_aks-rg1_aksdemo1
#          docker-desktop   docker-desktop   docker-desktop
#*         msflixtube       msflixtube       clusterUser_msflixtube_msflixtube


#if you have previously connected to other clusters (meaning you are now connected to multiple clusters) you might want to delete your Kubectl configuration file and invoke az aks get-credentials again to ensure that you only have the one set of credentials stored locally.
rm ~/.kube/config

#To make our Kubectl configuration available to our workflow through an environment variable we first have to base64 encode it:
cat ~/.kube/config | base64

# Copy the base64 encoded version to a new file to make it easier to copy:
cat ~/.kube/config | base64 > ~/kubeconfig.txt

