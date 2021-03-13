echo "Starting script --------------------------------------------------------------"
#This will be executed from inside the machine so the path are those of the guest machine.
yum check update -y
yum update -y
#create file and populate with redirection
touch file.txt
echo 'This is lab1' >> file.txt
cat file.txt
cat file.txt | grep -i 'lab1'
less file.txt
more file.txt
sudo setenforce 0
tar -czvf file_compressed.tar.gz file.txt
ls -hal | grep file_compressed.tar.gz
#install httpd
sudo yum install httpd -y
#check httpd status
sudo systemctl start httpd
#check
sudo su
chkconfig httpd on
systemctl status httpd | grep -i active
machine_hostname=$(hostname) #Checking if the machine is the master
if [ "$machine_hostname" = "master-node" ]; then
    yes | rm /etc/httpd/conf.d/proxy.conf #remove current proxy conf configuration
    cp /vagrant/proxy.conf /etc/httpd/conf.d/
    echo "Proxy config has been copied" #The proxy conf must be set only on the master node.
fi    
cp /vagrant/index.html /var/www/html
sudo systemctl restart httpd.service #restart the httpd to take effects --> https://www.centlinux.com/2019/01/configure-apache-http-load-balancer-centos-7.html#point2
echo "Script executed, done-------------------------------------------------------"

