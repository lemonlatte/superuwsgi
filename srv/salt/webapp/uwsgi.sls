{% set app_name = "app-test" %}
{% set app_root = "/tmp" %}
{% set app_log_folder = "/tmp" %}

include:
  - webserver

app_nginx:
  file.managed:
    - name: /etc/nginx/sites-available/site-uwsgi
    - template: jinja
    - source: salt://webserver/configs/nginx/site-uwsgi
    - defaults:
      app_name: {{ app_name }}
    - require:
      - pkg: nginx

  # TODO: Write a module for ensite
  cmd.run:
    - name: ln -s /etc/nginx/sites-available/site-uwsgi /etc/nginx/sites-enabled
    - unless: test -f /etc/nginx/sites-enabled/site-uwsgi
    - require:
      - file: app_nginx
    - watch_in:
      - service: nginx

app_uwsgi:
  file.managed:
    - name: {{ app_root }}/uwsgi.ini
    - template: jinja
    - source: salt://webserver/configs/uwsgi/uwsgi.ini
    - defaults:
      app_name: {{ app_name }}
    - require:
      - pip: uwsgi

app_supervisor:
  file.managed:
    - name: /etc/supervisord/conf.d/app.conf
    - template: jinja
    - source: salt://webserver/configs/supervisor/app.conf
    - defaults:
      app_name: {{ app_name }}
      app_root: {{ app_root }}
      app_log_folder: {{ app_log_folder }}
    - require:
      - file: /etc/supervisord.conf

  cmd.run:
    - name: "supervisorctl reread && supervisorctl update"
    - require:
      - service: supervisor
    - watch:
      - file: app_supervisor
      - file: app_uwsgi
