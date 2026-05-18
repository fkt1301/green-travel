{{
    config(
        materialized='table',
        cluster_by=['country_code', 'reference_year']
    )
}}

with co2_by_source as (
    select * from {{ ref('int_co2__by_source') }}
),

countries as (
    select * from {{ ref('int_countries__profile') }}
),

joined as (
    select
        -- keys
        {{ dbt_utils.generate_surrogate_key(['c.country_code', 'c.reference_year']) }}
                                                as emission_id,
        c.country_code,
        c.country_name,
        c.reference_year,

        -- country profile
        c.population,
        c.gdp_usd,
        c.gdp_per_capita_usd,
        c.energy_profile,

        -- emissions totals
        s.co2_mt,
        s.fossil_co2_mt,
        s.fossil_share,

        -- by source
        s.coal_co2_mt,
        s.oil_co2_mt,
        s.gas_co2_mt,
        s.land_use_change_co2_mt,

        -- shares
        s.coal_share,
        s.oil_share,
        s.gas_share,

        -- trade
        s.emissions_trade_gap_mt,

        -- metadata
        current_timestamp()                     as dbt_updated_at

    from countries c
    inner join co2_by_source s
        on c.country_code = s.country_code
        and c.reference_year = s.reference_year
)

select * from joined
