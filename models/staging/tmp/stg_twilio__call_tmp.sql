--To disable this model, set the using_twilio_call variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_twilio_call', True)) }}

{{
    twilio.twilio_union_connections(
        connection_dictionary='twilio_sources',
        single_source_name='twilio',
        single_table_name='call'
    )
}}
