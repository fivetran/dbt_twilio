{{ config(enabled=var('using_twilio_usage_record', True)) }}

{{
    twilio.twilio_union_connections(
        connection_dictionary='twilio_sources',
        single_source_name='twilio',
        single_table_name='usage_record'
    )
}}
