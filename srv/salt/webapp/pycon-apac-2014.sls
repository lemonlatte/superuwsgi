##### Settings for app
{% set app_name = "pycon" %}
{% set app_user = app_name %}
{% set project_name = "confweb" %}
{% set app_log_folder = "/var/log" %}

##### Settings for project repo
{% set git_repo = "https://bitbucket.org/pycontw/pycon-apac-2014" %}
{% set git_branch = "mezzanine"%}

##### Auto configuration
{% set app_home = "/home/%s" % app_user %}
{% set project_root = "%s/%s_project" % (app_home, app_name) %}
{% set package_root = "%s/%s" % (project_root, project_name) %}
{% set pip_requirements = "%s/%s" % (package_root, "requirements/project.txt") %}
{% set wsgi_module = "confweb.wsgi:application" %}

include:
  - webserver

{{ app_user }}:
  user.present:
    - shell: /bin/bash
    - home: {{ app_home }}

{{ git_repo }}:
  git.latest:
    - user: {{ app_name }}
    - rev: {{ git_branch }}
    - target: {{ project_root }}
    - require:
      - user: {{ app_user }}

{{ project_root }}/.venv:
  virtualenv.managed:
    - system_site_packages: False
    - requirements: {{ pip_requirements }}
    - require:
      - git: {{ git_repo }}

app_nginx:
  file.managed:
    - name: /etc/nginx/sites-available/{{ app_name }}-site-uwsgi
    - template: jinja
    - source: salt://webapp/templates/app-nginx.jinja
    - defaults:
      app_name: {{ app_name }}
    - require:
      - pkg: nginx

  # TODO: Write a module for ensite
  cmd.run:
    - name: ln -s /etc/nginx/sites-available/{{ app_name }}-site-uwsgi /etc/nginx/sites-enabled/{{ app_name }}-site-uwsgi
    - unless: test -f /etc/nginx/sites-enabled/{{ app_name }}-site-uwsgi
    - require:
      - file: app_nginx
    - watch_in:
      - service: nginx

app_uwsgi:
  file.managed:
    - name: {{ project_root }}/uwsgi.ini
    - template: jinja
    - source: salt://webapp/templates/app-uwsgi.jinja
    - defaults:
      app_name: {{ app_name }}
      wsgi_module: {{ wsgi_module }}
    - require:
      - pip: uwsgi

app_supervisor:
  file.managed:
    - name: /etc/supervisord/conf.d/{{ app_name }}.conf
    - template: jinja
    - source: salt://webapp/templates/app-supervisor.jinja
    - defaults:
      app_name: {{ app_name }}
      project_root: {{ project_root }}
      app_log_folder: {{ app_log_folder }}
    - require:
      - file: /etc/supervisord.conf

  cmd.run:
    - name: "supervisorctl reread && supervisorctl update && supervisorctl restart {{ app_name }}"
    - require:
      - service: supervisor
    - watch:
      - file: app_supervisor
      - file: app_uwsgi
