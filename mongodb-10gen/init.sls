{% set mongodb = pillar.get("mongodb_10gen", {}) %}

10gen-repo:
  pkgrepo.managed:
    - humanname: 10gen-repo
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com

mongodb-10gen:
  pkg.installed:
    - require:
      - pkgrepo: 10gen-repo
{% if "version" in mongodb %}
    - version: {{ mongodb.version }}
{% endif %}
