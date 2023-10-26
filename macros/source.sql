{% macro source(source_name, table_name, lowercase=False, v=None) %}
  {%- set src_db = env_var('SRC_DB', '') -%}
  {%- set default_database = target.database -%}
  {%- set source_relation = builtins.source(source_name, table_name) -%}

  {%- set database = src_db if src_db != '' else source_relation.database -%}
  {%- set schema = source_relation.schema -%}
  {%- set identifier = source_relation.name -%}
  
  {%- set table_reference -%}
    {{ database }}.{{ schema }}.{% if lowercase %}{{ adapter.quote(identifier) }}{% else %}{{ identifier }}{% endif %}
  {%- endset -%}
  
  {%- set query_with_at = ('@' + table_reference) in model.sql -%}
  {{- '@' if query_with_at else '' -}}{{ table_reference }}
{% endmacro %}
