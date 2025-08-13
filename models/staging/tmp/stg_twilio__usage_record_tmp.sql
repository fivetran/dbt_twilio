{{ config(enabled=var('using_twilio_usage_record', True)) }}

select {{ dbt_utils.star(source('twilio', 'usage_record')) }}
from {{ var('usage_record') }}
