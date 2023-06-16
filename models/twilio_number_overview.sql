with messages as (

    select *
    from {{ var('message')}}
),

inbound_messages as (

    select 
        message_from as phone_number,
        status,
        count(message_id),
        sum(price)
    
    from messages
),

outbound_messages as (

    select 
        message_to as phone_number,
        status,
        count(message_id),
        sum(price)
    
    from messages
),

final as (

    select * from inbound_messages
    union all
    select * from outbound_messages
)

select * 
from final


-- Total Outgoing Messages
-- Total Messages Sent
-- Total Delivered
-- Total Undelivered 
-- Total Failed 
-- Total Spent
-- Programmable SMS Spend
-- SMS Transactions 
-- Total Number of Responses
-- Current Opt Status 
--      - Are they Opt In or Opt Out
-- Opted out date 
--      - Null if they are not opted out
