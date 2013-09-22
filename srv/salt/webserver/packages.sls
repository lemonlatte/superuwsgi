base-pkgs:
  pkg.installed:
    - names:
      - build-essential
      - python-dev
      - python-pip
      - python-virtualenv
      - libevent-dev

nginx:
  pkg:
    - installed
  file:
    - managed
    - name: /etc/nginx/sites-available/site-uwsgi
    - template: jinja
    - source: salt://webserver/configs/nginx/site-uwsgi
    - require:
      - pkg: nginx
  # TODO: Write a module for ensite
  cmd:
    - run
    - name: ln -s /etc/nginx/sites-available/site-uwsgi /etc/nginx/sites-enabled
    - unless: test -f /etc/nginx/site-enabled
    - require:
      - file: nginx

  service:
    - running
    - restart: True
    - watch:
      - cmd: nginx

supervisor:
  pip.installed:
    - require:
      - pkg: base-pkgs

  file:
    - managed
    - name: /etc/init/supervisor.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://webserver/configs/supervisor/upstart.jinja
    - require:
      - pip: supervisor

  cmd:
    - run
    - name: echo_supervisord_conf > /etc/supervisord.conf
    - unless: test -f /etc/supervisord.conf
    - require:
      - pip: supervisor

  service:
    - running
    - restart: True
    - watch:
      - file: supervisor
      - cmd: supervisor

gevent:
  pip.installed:
    - require:
      - pkg: base-pkgs

uwsgi:
  pip.installed:
    - require:
      - pkg: base-pkgs
