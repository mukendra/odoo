from ansible/ubuntu14.04-ansible
maintainer mukki
run apt-get -y update && apt-get -y upgrade

run apt-get install -y 	subversion git bzr bzrtools postgresql postgresql-server-dev-9.3 \
		    	python-pip python-all-dev python-dev python-setuptools \
		    	libxml2-dev libxslt1-dev libevent-dev libsasl2-dev \
		    	libldap2-dev pkg-config libtiff5-dev \
		    	libjpeg8-dev libjpeg-dev zlib1g-dev \
		   	libfreetype6-dev liblcms2-dev liblcms2-utils \
		    	libwebp-dev tcl8.6-dev tk8.6-dev python-tk libyaml-dev fontconfig \
			wget nano ssh ssmtp 

run adduser --system --home=/opt/odoo --group odoo
run mkdir /var/log/odoo

workdir /opt/odoo
run git clone https://github.com/mukendra/odoo.git
run rm -r /opt/odoo/odoo/odoo-9/addons
run cp -r /opt/odoo/odoo/odoo-9/* /opt/odoo/ && rm -r /opt/odoo/odoo/odoo-9
run cp -r /opt/odoo/odoo/* /opt/odoo/ && rm -r /opt/odoo/odoo

run pip install -r /opt/odoo/odoo/doc/requirements.txt
run pip install -r /opt/odoo/odoo/requirements.txt
run wget -qO- https://deb.nodesource.com/setup | sudo bash -
run apt-get install -y nodejs
run npm install -g less less-plugin-clean-css
run dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb

run cp -r /usr/local/bin/wkhtmltopdf /usr/bin
run cp -r /usr/local/bin/wkhtmltoimage /usr/bin

run cp /opt/odoo/debian/openerp-server.conf /etc/odoo-server.conf
workdir /etc
run sed -i "s|; admin_passwd = admin|admin_passwd = postgres|g" odoo-server.conf
run sed -i "s|db_host = False|db_host = 192.168.1.63|g" odoo-server.conf
run sed -i "s|db_port = False|db_port = 5432|g" odoo-server.conf
run sed -i "s|db_user = odoo|db_user = odoo|g" odoo-server.conf
run sed -i "s|db_password = False|db_password = root|g" odoo-server.conf
run sed -i "s|addons_path = /usr/lib/python2.7/dist-packages/openerp/addons|#addons_path = /usr/lib/python2.7/dist-packages/openerp/addons|g" odoo-server.conf
run rm -r /etc/ssmtp/ssmtp.conf
run cp -r /opt/odoo/odoo/ssmtp.conf /etc/ssmtp/ssmtp.conf

workdir /opt/odoo
run cp -r /opt/odoo/odoo/odoo-server /etc/init.d/
run chmod 755 /etc/init.d/odoo-server
run chown root: /etc/init.d/odoo-server
run chown -R odoo: /opt/odoo/
run chown odoo:root /var/log/odoo
run chown odoo: /etc/odoo-server.conf
run chmod 640 /etc/odoo-server.conf
run update-rc.d odoo-server defaults
run rm -r wkhtmltox-0.12.1_linux-trusty-amd64.deb odoo-server

expose 8069
entrypoint /etc/init.d/odoo-server start && tail -f /var/log/apt/history.log && bash


