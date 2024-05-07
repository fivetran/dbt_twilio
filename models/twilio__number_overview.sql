{# Every model in the twilio transform package relies on message data and will be disabled by setting using_twilio_message to False #}
{{ config(enabled=var('using_twilio_message', True)) }}

{% set message_categories = ['accepted', 'scheduled', 'canceled', 'queued', 'sending', 'sent', 'failed', 'delivered', 'undelivered', 'receiving','received', 'read'] %}

with messages as (

    select *
    from {{ ref('int_twilio__messages')}}
)

select
    phone_number,
    count(case
        when direction like '%outbound%'
        then message_id end)
        as total_outbound_messages,
    count(case
        when direction like '%inbound%'
        then message_id end)
        as total_inbound_messages,

    {% for m in message_categories %}
    count(case
        when status like '{{ m }}'
        then message_id end)
        as total_{{m}}_messages,
    {% endfor %}
    
    count(message_id) as total_messages,
    sum(price) as total_spend

from messages
group by 1
