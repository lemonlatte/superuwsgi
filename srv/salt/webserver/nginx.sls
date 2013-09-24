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
    - unless: test -f /etc/nginx/sites-enabled/site-uwsgi
    - require:
      - file: nginx

  service:
    - running
    - restart: True
    - watch:
      - cmd: nginx

