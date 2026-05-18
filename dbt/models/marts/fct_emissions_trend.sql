{{
    config(
        materialized='table',
        cluster_by=['country_code']
    )
}}

with emissions as (
    select * from {{ ref('fct_co2_emissions') }}
),

with_yoy as (
    select
        emission_id,
        country_code,
        country_name,
        reference_year,
        co2_mt,
        co2_mt - lag(co2_mt) over (
            partition by country_code
            order by reference_year
        )                                       as co2_yoy_change_mt,

        safe_divide(
            co2_mt - lag(co2_mt) over (
                partition by country_code
                order by reference_year
            ),
            lag(co2_mt) over (
                partition by country_code
                order by reference_year
            )
        )                                       as co2_yoy_change_pct,

        fossil_share,
        fossil_share - lag(fossil_share) over (
            partition by country_code
            order by reference_year
        )                                       as fossil_share_yoy_change,

        gdp_per_capita_usd,
        energy_profile,
        dbt_updated_at

    from emissions
)

select * from with_yoy
