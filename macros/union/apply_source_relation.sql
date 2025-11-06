{% macro apply_source_relation() -%}

{{ adapter.dispatch('apply_source_relation', 'twilio') () }}

{%- endmacro %}

{% macro default__apply_source_relation() -%}

{% if var('twilio_sources', []) != [] %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ var("twilio_database", target.database) }}' || '.'|| '{{ var("twilio_schema", "twilio") }}' as source_relation
{% endif %}

{%- endmacro %}