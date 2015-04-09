# vim: sts=2 ts=2 sw=2 et ai
{% from "composer/map.jinja" import composer with context %}

include:
  - composer 

{%- for name, value in composer.get("projects",[]).iteritems() %}

# Create config if unexists
composer-scripts_{{name}}:
  file.managed:
    - name: {{value.path|default("/tmp")}}/composer.json 
    - source: salt://composer/files/config.tmpl
    - mode: 775
    - template: jinja
    - context: 
        data:
          {% for item in value.config.split('\n')|default("{}") %}
          - "{{ item }}"
          {% endfor %}
    - unless: 'test -e {{value.path}}/composer.json'

# Install composer, working only have internet 
composer_install_package_{{name}}:
  cmd.run:
    - name: "/usr/bin/env composer install"
    - cwd: {{ value.path|default("/tmp") }}
    - require:
      - pkg: php5-composer
      - file.managed: composer-scripts_{{name}} 

# Update composer install 
{% if value.update is defined %}
composer_update_{{name}}:
  cmd.run:
    - name: "/usr/bin/env composer update"
    - cwd: {{ value.path|default("/tmp") }}
    - require:
      - pkg: php5-composer
      - file.managed: composer-scripts_{{name}} 
{% endif %}


{%- endfor %}
