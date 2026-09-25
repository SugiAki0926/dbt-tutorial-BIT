{{ config(materialized='incremental', incremental_strategy='append') }}
with flattened_outputs as (
    select
        tx.hash_key,
        tx.block_number,
        tx.block_timestamp,
        tx.is_coinbase,
        f.value:address::STRING as output_address,
        f.value:value::FLOAT as output_value
    from {{ ref('stg_btc') }} as tx,
        lateral flatten(input => tx.outputs) as f
    where
        f.value:type::STRING = 'witness_v0_keyhash'
        {% if is_incremental() %}
            and tx.block_timestamp > (select max(block_timestamp) from {{ this }})
        {% endif %}
)

select
    hash_key,
    block_number,
    block_timestamp,
    is_coinbase,
    output_address,
    output_value
from flattened_outputs
