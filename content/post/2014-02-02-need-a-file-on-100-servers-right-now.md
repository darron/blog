---
categories: null
comments: true
date: 2014-02-02T00:00:00Z
title: Need a file on 100+ servers right now?
url: /2014/02/02/need-a-file-on-100-servers-right-now/
---

Friday evening I needed to replace a SSH key for one of my developers. I was trying to get out of the office and start the weekend, but since I was heading out of town, I wanted it done right now.

My chef-client runs were failing mysteriously and I had no idea what was going on - that seems to be a bigger problem - but I needed this done right now. Once chef-client ran successfully, it would automatically replaces all the ssh keys and correct the problem, but I was stuck and needed to get home.

Now, I love [Chef](http://www.getchef.com/), but at the moment it wasn't working, and I needed to push the file out quickly.

Enter my new friend [Ansible](http://www.ansible.com/get-started) - I had used it to build the first version of [octohost](http://www.octohost.io) - that should be able to help with this.

Let's install it.

```
[] darron@~/Dropbox/src/key-blast: brew install ansible
==> Downloading https://github.com/ansible/ansible/archive/v1.4.4.tar.gz
######################################################################## 100.0%
==> Downloading https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.tar.gz
Already downloaded: /Library/Caches/Homebrew/ansible--pycrypto-2.6.tar.gz
==> python setup.py install --prefix=/usr/local/Cellar/ansible/1.4.4/libexec
==> Downloading https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz
Already downloaded: /Library/Caches/Homebrew/ansible--pyyaml-3.10.tar.gz
==> python setup.py install --prefix=/usr/local/Cellar/ansible/1.4.4/libexec
==> Downloading https://pypi.python.org/packages/source/p/paramiko/paramiko-1.11.0.tar.gz
Already downloaded: /Library/Caches/Homebrew/ansible--paramiko-1.11.0.tar.gz
==> python setup.py install --prefix=/usr/local/Cellar/ansible/1.4.4/libexec
==> Downloading https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.18.tar.gz
Already downloaded: /Library/Caches/Homebrew/ansible--markupsafe-0.18.tar.gz
==> python setup.py install --prefix=/usr/local/Cellar/ansible/1.4.4/libexec
==> Downloading https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.1.tar.gz
Already downloaded: /Library/Caches/Homebrew/ansible--jinja2-2.7.1.tar.gz
==> python setup.py install --prefix=/usr/local/Cellar/ansible/1.4.4/libexec
==> python setup.py install --prefix=/usr/local/Cellar/ansible/1.4.4
==> Caveats
Set PYTHONPATH if you need Python to find the installed site-packages:
  export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
==> Summary
🍺  /usr/local/Cellar/ansible/1.4.4: 763 files, 8.8M, built in 18 seconds
[] darron@~/Dropbox/src/key-blast: ansible --version
ansible 1.4.4
```

Ansible is a really [nice and flexible way](http://www.ansible.com/how-ansible-works) to do a lot of things on a lot of different servers quickly.

Here's the Ansible [role](http://docs.ansible.com/playbooks_roles.html#roles) I whipped up:

```
---
- name: Install a url to a file.
  get_url: url='{{ url }}' dest='{{ dest }}' force='{{ should_i_force }}'

- name: Set permissions on file.
  file: path='{{ dest }}' owner='{{ owner }}' group='{{ group }}' mode='{{ perms }}'
```

And here's the [playbook](http://docs.ansible.com/playbooks_intro.html) that drives it - names have been changed to protect the guilty:

```
- hosts: nonfiction
  user: darron
  sudo: True
  gather_facts: False
  vars:
    url: https://github.com/darron.keys
    dest: /home/darron/.ssh/authorized_keys
    should_i_force: 'yes'
    owner: darron
    group: darron
    perms: '0600'

  roles:
    - key-blast
```

This playbook, puts the *url* at the *dest* and makes sure the ownership and permissions are correct. In this case, it would replace my SSH key on all *nonfiction* hosts.

A quick run looks something like this:

```
[] darron@~/Dropbox/src/key-blast: ansible-playbook key-blast.yml 

PLAY [nonfiction] ************************************************************* 

TASK: [key-blast | Install a url to a file.] ********************************** 
changed: [193.22.97.199]
changed: [193.22.107.186]
changed: [193.22.107.156]
changed: [193.22.99.47]
changed: [193.45.232.193]
changed: [193.22.96.19]
changed: [74.12.189.199]
changed: [74.12.235.234]
changed: [74.12.233.43]
changed: [74.12.228.168]
changed: [74.12.228.172]
changed: [74.56.217.80]
changed: [74.56.242.194]
changed: [193.22.107.110]

TASK: [key-blast | Set permissions on file.] ********************************** 
ok: [193.22.107.186]
ok: [193.22.97.199]
ok: [193.22.107.156]
ok: [193.45.232.193]
ok: [193.22.99.47]
ok: [193.22.107.110]
ok: [74.12.189.199]
ok: [193.22.96.19]
ok: [74.12.235.234]
ok: [74.12.233.43]
ok: [74.12.228.168]
ok: [74.56.242.194]
ok: [74.56.217.80]
ok: [74.12.228.172]

PLAY RECAP ******************************************************************** 
193.22.107.110            : ok=2    changed=1    unreachable=0    failed=0   
193.22.107.156            : ok=2    changed=1    unreachable=0    failed=0   
193.22.107.186            : ok=2    changed=1    unreachable=0    failed=0   
193.22.96.19              : ok=2    changed=1    unreachable=0    failed=0   
193.22.97.199             : ok=2    changed=1    unreachable=0    failed=0   
193.22.99.47              : ok=2    changed=1    unreachable=0    failed=0   
193.45.232.193             : ok=2    changed=1    unreachable=0    failed=0   
74.56.217.80               : ok=2    changed=1    unreachable=0    failed=0   
74.56.242.194              : ok=2    changed=1    unreachable=0    failed=0   
74.12.189.199              : ok=2    changed=1    unreachable=0    failed=0   
74.12.228.168              : ok=2    changed=1    unreachable=0    failed=0   
74.12.228.172              : ok=2    changed=1    unreachable=0    failed=0   
74.12.233.43               : ok=2    changed=1    unreachable=0    failed=0   
74.12.235.234              : ok=2    changed=1    unreachable=0    failed=0   
```

That was a really nice way to make that happen - the role is very flexible and can be used anytime for really any type of file.

I'm very impressed by Ansible for these sorts of problems. It allows me to do this quickly and easily - and doesn't require a rocket surgeon to implement.

Give Ansible a spin - it's a handy tool to have in the toolbox. I will look at why my Chef run is failing on Monday - but this helped me out in a jam when I needed it.

If you've got a problem like this, or just want to see the code - [take a look here](https://github.com/darron/key-blast).

Please note, I also updated the playbook to have a local file as an option - for those types of files that can't be available on the internet.

Enjoy!