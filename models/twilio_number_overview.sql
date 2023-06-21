with message_enhanced as (

    select *
    from {{ ref('twilio_message_enhanced')}}
)

select 
    phone_number,
    case
        when direction like '%outbound%'
        then count(message_id)
        end as total_outbound_messages,
    case
        when direction like '%inbound%'
        then count(message_id)
        end as total_inbound_messages,
    case 
        when status like '%accepted%'
        then count(message_id)
        end as total_accepted_messages,
    case 
        when status like '%scheduled%'
        then count(message_id)
        end as total_scheduled_messages,
    case 
        when status like '%canceled%'
        then count(message_id)
        end as total_canceled_messages,
    case 
        when status like '%queued%'
        then count(message_id)
        end as total_queued_messages,
    case 
        when status like '%sending%'
        then count(message_id)
        end as total_sending_messages,
    case
        when status like '%sent%'
        then count(message_id)
        end as total_sent_messages,
    case 
        when status like '%failed%'
        then count(message_id)
        end as total_failed_messages,
    case 
        when status like '%delivered%'
        then count(message_id)
        end as total_delivered_messages,
    case 
        when status like '%undelivered%'
        then count(message_id)
        end as total_undelivered_messages,
    case 
        when status like '%receiving%'
        then count(message_id)
        end as total_receiving_messages,
    case 
        when status like '%received%'
        then count(message_id)
        end as total_received_messages,
    case 
        when status like '%read%'
        then count(message_id)
        end as total_read_messages,
    count(message_id) as total_messages,
    sum(price) as total_spent

from message_enhanced
group by phone_number, direction, status