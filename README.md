# DEPI-Kubernetes-Assignment
## a)	Create a Deployment 
##### •	Create a Kubernetes deployment that runs 3 replicas of the web server container from Assignment 2.
##### •	Ensure that all replicas are load-balanced across the cluster using a ClusterIP service.
##### •	Describe how you would test the load balancing functionality.
## Answer:-
### Step 1:- Build and push the Docker image
          docker build -t depi-web:latest .
          docker tag depi-web:latest marwansabry/depi-web:latest
          docker container run -d -p 8080:8080 --name web-server-container -l app=web-server marwansabry/depi-web:latest
          docker push marwansabry/depi-web:latest
### Step 2:- Apply the YAML files
          kubectl apply -f deployment.yaml
          kubectl apply -f clusterip-service.yaml
### Step 3:- Creating a client pod for testing the Load Balancing
          kubectl apply -f client-pod.yaml
### Step 4:-Check the logs of the web server pods
##### Get the web pods name
          kubectl get pods
##### Get Ngnix Logs for each pod using its name "POD_NAME"
          kubectl exec -it "POD_NAME" -- tail /var/log/nginx/access.log
##### We will see requests being distributed across the different pods.
---
## b)	Service Exposure
##### •	Expose your deployment to the outside world using a NodePort service. Map the external port to 80 on the Kubernetes cluster.
##### •	Verify the service is reachable by accessing the external IP and port from your browser.
## Answer:-
### Step 1:- Apply the YAML files
          kubectl apply -f nodeport-service.yaml
          kubectl apply -f loadbalance.yaml
### Step 2:- Access the service from your browser
##### Get services details using this command
          kubectl get service
##### Find the "EXTERNAL-IP" address located to my-loadbalancer-service service and use this ip for externally access  
          http://<my-loadbalancer-service EXTERNAL-IP>:<Port>
          http://213.154.39.222:31435
##### We should see the "Hello from my DEPI Web" message in the browser.
---
## c)	Scaling with Autoscaling
##### •	Set up the Kubernetes Horizontal Pod Autoscaler (HPA) to automatically scale the web server deployment up to 10 replicas when CPU utilization exceeds 70%.
##### •	Simulate high CPU usage using kubectl or a stress test tool, and observe how Kubernetes scales the pods.
## Answer:-
### Step 1:- Apply the HPA
          kubectl apply -f hpa.yaml
### Step 2:- Use kubectl exec to run stress inside a pod
##### Get the web pods name
          kubectl get pods
##### Edit the Stress.sh script to add pods names and then run it to start the stress
          ./Stress.sh &
### Step 3:- Observe the HPA in action
          kubectl get hpa web-server-hpa
##### By running the above command many times we will find that :-
##### 1. The CURRENT CPU utilization will start to rise above 70%.
##### 2. The REPLICAS count will increase as the HPA scales up the deployment.
##### Run the below command and we will find The EVENTS section that show events related to scaling up and down.
          kubectl describe hpa web-server-hpa
##### After 600 seconds the process will stop automatically CPU utilization will decrease and the HPA will scales down
##### We can see the scale down as we previously saw the scale up using the same commands
          kubectl get hpa web-server-hpa
##### By running the above command many times we will find that :-
##### 1. The CURRENT CPU utilization will start to decrease.
##### 2. The REPLICAS count will decrease as the HPA scales down the deployment.
##### Run the below command and we will find The EVENTS section that show events related to scaling up and down.
          kubectl describe hpa web-server-hpa
