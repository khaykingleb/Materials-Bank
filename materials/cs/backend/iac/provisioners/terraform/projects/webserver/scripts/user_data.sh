#!/bin/bash
yum -y update
yum -y install httpd

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold">Build by Power of <font color="red">Terraform</font></h2><br><p>
<font color="blue">
<b>Version 2.0</b>
</body>
</html>
EOF

service httpd start
chkconfig httpd on
