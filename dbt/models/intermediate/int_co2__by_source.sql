with source as (
    select * from {{ ref('stg_owid__co2') }}
),

by_source as (
    select
        country_code,
        country_name,
        reference_year,
        co2_mt,

        -- absolute emissions by source
        coal_co2_mt,
        oil_co2_mt,
        gas_co2_mt,
        land_use_change_co2_mt,
        other_industry_co2_mt,

        -- share of each source in total emissions
        safe_divide(coal_co2_mt, co2_mt)                as coal_share,
        safe_divide(oil_co2_mt, co2_mt)                 as oil_share,
        safe_divide(gas_co2_mt, co2_mt)                 as gas_share,
        safe_divide(land_use_change_co2_mt, co2_mt)     as land_use_share,

        -- fossil fuels combined
        coalesce(coal_co2_mt, 0)
            + coalesce(oil_co2_mt, 0)
            + coalesce(gas_co2_mt, 0)                   as fossil_co2_mt,

        safe_divide(
            coalesce(coal_co2_mt, 0)
                + coalesce(oil_co2_mt, 0)
                + coalesce(gas_co2_mt, 0),
            co2_mt
        )                                               as fossil_share,

        -- consumption vs production gap (positive = net importer of emissions)
        coalesce(consumption_co2_mt, 0)
            - coalesce(co2_mt, 0)                       as emissions_trade_gap_mt

    from source
    where co2_mt is not null
)

select * from by_source
