echo "Starting script --------------------------------------------------------------"
#This will be executed from inside the machine so the path are those of the guest machine.
yum check update -y
yum update -y
machine_hostname=$(hostname) #Checking if the machine is the master
if [ "$machine_hostname" = "master-node" ]; then
    yes | sudo yum install docker
    #install docker
    sudo systemctl start docker
    JENKINS_VERSION="2.0-rc-1"
    sudo docker pull jenkinsci/jenkins:$JENKINS_VERSION
    sudo docker run -d -p 8000:8080 --name jenkins-master jenkinsci/jenkins:$JENKINS_VERSION
    echo "Sleeping for 30s"
    sleep 30
    echo "Printing password-----"
    sudo docker exec jenkins-master sh -c 'cat /var/jenkins_home/secrets/initialAdminPassword'
    echo "Now i can access on 192.168.121.10:8080"
    #Installing and enabling apache
    sudo yum install httpd -y
    #check httpd status
    sudo systemctl start httpd
    sudo chkconfig httpd on
    sudo systemctl status httpd | grep -i active
    sudo cp /vagrant/index.html /var/www/html
    sudo systemctl restart httpd.service
    
fi


if [ "$machine_hostname" = "LoadBalancer" ]; then
    sudo su
    yum install haproxy -y
    yes | rm /etc/haproxy/haproxy.cfg #remove current proxy conf configuration
    cp /vagrant/haproxy.cfg /etc/haproxy/
    echo "HaProxy config has been copied" #The proxy conf must be set only on the master node.
    echo "HAProxyScript enabling, done-------------------------------------------------------"
    systemctl enable haproxy
    systemctl restart haproxy
    sudo systemctl status haproxy.service -l --no-pager | grep -i active
    echo "HAProxyScript executed, done-------------------------------------------------------"
fi    

