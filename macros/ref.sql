{% macro ref(model_name) %}
  {%- set src_db = env_var('SRC_DB', '') -%}
  {%- set default_database = target.database -%}
  {%- set model_relation = builtins.ref(model_name) -%}

  {%- set database = src_db if src_db != '' else model_relation.database -%}
  {%- set schema = model_relation.schema -%}
  {%- set identifier = model_relation.name -%}
  
  {{ database }}.{{ schema }}.{{ identifier }}
{% endmacro %}
