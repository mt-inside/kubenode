* Install ubuntu 17.10 server
    * Accept all the defaults
    * Enable OpenSSH server
    * user: matt; password: password
    * Select no apt auto updates
* When the machine is up:
    * Even selecting no auto-updates isn't enough: `echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic`
    * check DNS and add 8.8.8.8 to /etc/systemd/system/resolv.conf
    * sudo halt
* Export that machine as an OVF 2.0
* Update packer.json to point to that OVA
* `$ packer build packer.json`
* Import the output file back 
* Boot and log-in as matt
    * `$ kubectl run --image=nginx web`
    * `$ kubectl expose deployment web --port=80 --name=web`
    * `$ kubectl run -ti --image=busybox client`
        * `$wget web`

TODO:
* virtualbox's fileformat dances are annoying; change to another virtualiser
