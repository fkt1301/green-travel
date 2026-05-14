with source as (
    select * from {{ source('owid', 'owid_co2_raw') }}
),

renamed as (
    select
        -- identifiers
        iso_code                            as country_code,
        country                             as country_name,
        cast(year as integer)               as reference_year,

        -- population & economy
        cast(population as float64)         as population,
        cast(gdp as float64)                as gdp_usd,

        -- total CO2 emissions
        cast(co2 as float64)                as co2_mt,
        cast(co2_per_capita as float64)     as co2_per_capita_t,
        cast(co2_per_gdp as float64)        as co2_per_gdp,

        -- transport specific
        cast(transport_co2 as float64)          as transport_co2_mt,
        cast(transport_co2_per_capita as float64) as transport_co2_per_capita_t,

        -- energy
        cast(primary_energy_consumption as float64) as primary_energy_consumption_twh,
        cast(renewables_share_energy as float64)    as renewables_share_pct,
        cast(fossil_share_energy as float64)        as fossil_share_pct,

        -- metadata
        _ingested_at

    from source
    where
        iso_code is not null                -- remove regional aggregates
        and iso_code not like 'OWID_%'     -- remove OWID-specific aggregates
        and year >= 1990
)

select * from renamed
