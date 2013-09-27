## Settings for PyCon APAC 2014 Mezzanine
{% set app_name = "pycon" %}
{% set app_user = app_name %}
{% set package_name = "confweb" %}
{% set app_log_folder = "/var/log" %}
{% set wsgi_module = "confweb.wsgi:application" %}
{% set pip_subpath = "requirements/project.txt" %}

##### Settings for project repo
{% set git_repo = "https://bitbucket.org/pycontw/pycon-apac-2014" %}
{% set git_branch = "mezzanine"%}

{% include "webapp/base.sls" with context %}
