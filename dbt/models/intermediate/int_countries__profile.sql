with countries as (
    select
        country_code,
        country_name,
        reference_year,
        population,
        gdp_usd,

        -- derived
        case
            when gdp_usd is not null and population > 0
            then gdp_usd / population
        end                                     as gdp_per_capita_usd,

        co2_per_unit_energy,

        -- energy profile flag
        case
            when co2_per_unit_energy < 1.5  then 'low_carbon'
            when co2_per_unit_energy < 2.5  then 'transitioning'
            else                                 'fossil_dependent'
        end                                     as energy_profile

    from {{ ref('stg_owid__co2') }}
    where population > 0
)

select * from countries
