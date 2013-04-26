# m12rbox is just a vagrant project to get a virtual environment going for personal use. nothing fancy.

m12rbox uses vagrant (http://www.vagrantup.com)

## Download the needed software to run the environment 
* Download & install Oracle virtual box (https://www.virtualbox.org/wiki/Downloads)
* Download & install Vagrant (http://www.vagrantup.com)
* Download & install git (http://git-scm.com if you are comfortable with command line, otherwise use Github app)

## Install the environment
* Clone m12rbox in your favorite work folder (~/Documents ?) 
* Start your virtual machine, from command line

	`$vagrant up`

* Connect to your virtualized local environment

    `$vagrant ssh`


-----------------------------------------------------------------------    

* Install and run virtual env from your local repository

    `$cd ~/PunchTab/ && virtualenv venv && source venv/bin/activate`

* Install python libraries

    `$sudo pip install -r web/requirements.txt`

* Create the table & fixtures
    `cd web/punchtab/ && python manage.py syncdb`

* Then run your server
    
    `python manage.py runserver [::]:8000 --nostatic`


### Generate ssh key for Windows
	* Download PuttyGen
	* Use insecure_private_key to generate a ppk file
	* Use the new ppk file to generate
