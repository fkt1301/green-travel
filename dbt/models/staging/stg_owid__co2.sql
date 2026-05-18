with source as (
    select * from {{ source('owid', 'owid_co2_raw') }}
),

renamed as (
    select
        -- identifiers
        iso_code                                        as country_code,
        country                                         as country_name,
        cast(year as integer)                           as reference_year,

        -- population & economy
        cast(population as float64)                     as population,
        cast(gdp as float64)                            as gdp_usd,

        -- total CO2
        cast(co2 as float64)                            as co2_mt,
        cast(co2_per_capita as float64)                 as co2_per_capita_t,
        cast(co2_per_gdp as float64)                    as co2_per_gdp,

        -- CO2 by source (useful for sectoral analysis)
        cast(coal_co2 as float64)                       as coal_co2_mt,
        cast(oil_co2 as float64)                        as oil_co2_mt,
        cast(gas_co2 as float64)                        as gas_co2_mt,
        cast(land_use_change_co2 as float64)            as land_use_change_co2_mt,
        cast(other_industry_co2 as float64)             as other_industry_co2_mt,

        -- consumption-based (vs production-based co2)
        cast(consumption_co2 as float64)                as consumption_co2_mt,
        cast(consumption_co2_per_capita as float64)     as consumption_co2_per_capita_t,

        -- trade
        cast(trade_co2 as float64)                      as trade_co2_mt,

        -- shares
        cast(share_global_co2 as float64)               as share_global_co2_pct,

        -- energy
        cast(co2_per_unit_energy as float64)            as co2_per_unit_energy,

        -- metadata
        _ingested_at

    from source
    where
        iso_code is not null
        and iso_code not like 'OWID_%'
        and year >= 1990
)

select * from renamed
