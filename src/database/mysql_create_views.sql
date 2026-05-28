-- View 1: Main feature table. Joins accident, person, vehicle, road, weather, lighting,
-- casualty class, and casualty severity into one table.

CREATE OR REPLACE VIEW vw_accident_casualty_ml_features AS
SELECT
    a.reference_number,
    a.easting,
    a.northing,
    a.number_of_vehicles,
    a.date,
    a.time,

    rc.description AS road_class,
    rs.description AS road_surface,
    l.description AS lighting,
    w.description AS weather,

    p.person_id,
    p.age,
    s.description AS sex,

    v.description AS vehicle,
    cc.description AS casualty_class,
    cs.description AS casualty_severity

FROM accident_casualty ac
JOIN accident a
    ON ac.reference_number = a.reference_number
JOIN person p
    ON ac.person_id = p.person_id

LEFT JOIN road_class rc
    ON a.road_class_id = rc.road_class_id
LEFT JOIN road_surface rs
    ON a.road_surface_id = rs.road_surface_id
LEFT JOIN lighting l
    ON a.lighting_id = l.lighting_id
LEFT JOIN weather w
    ON a.weather_id = w.weather_id

LEFT JOIN sex s
    ON p.sex_id = s.sex_id
LEFT JOIN vehicle v
    ON ac.vehicle_id = v.vehicle_id
LEFT JOIN casualty_class cc
    ON ac.casualty_class_id = cc.casualty_class_id
LEFT JOIN casualty_severity cs
    ON ac.casualty_severity_id = cs.casualty_severity_id;



-- View 2: Environmental severity feature table.
-- Focuses on environmental and road-related factors: weather, lighting, road surface, road class, and severity.

CREATE OR REPLACE VIEW vw_environmental_severity_features AS
SELECT
    a.reference_number,
    a.date,
    a.time,
    a.number_of_vehicles,

    w.description AS weather,
    l.description AS lighting,
    rs.description AS road_surface,
    rc.description AS road_class,

    cs.description AS casualty_severity

FROM accident_casualty ac
JOIN accident a
    ON ac.reference_number = a.reference_number

LEFT JOIN weather w
    ON a.weather_id = w.weather_id
LEFT JOIN lighting l
    ON a.lighting_id = l.lighting_id
LEFT JOIN road_surface rs
    ON a.road_surface_id = rs.road_surface_id
LEFT JOIN road_class rc
    ON a.road_class_id = rc.road_class_id
LEFT JOIN casualty_severity cs
    ON ac.casualty_severity_id = cs.casualty_severity_id;



-- View 3: Binary severity classification table.
-- Converts casualty severity into binary classes: fatal/serious = high_severity, all others = low_severity.

CREATE OR REPLACE VIEW vw_binary_severity_features AS
SELECT
    a.reference_number,
    a.easting,
    a.northing,
    a.number_of_vehicles,
    a.date,
    a.time,

    rc.description AS road_class,
    rs.description AS road_surface,
    l.description AS lighting,
    w.description AS weather,

    p.age,
    s.description AS sex,
    v.description AS vehicle,
    cc.description AS casualty_class,

    cs.description AS original_casualty_severity,

    CASE
        WHEN LOWER(cs.description) LIKE '%fatal%'
          OR LOWER(cs.description) LIKE '%serious%'
        THEN 'high_severity'
        ELSE 'low_severity'
    END AS binary_severity

FROM accident_casualty ac
JOIN accident a
    ON ac.reference_number = a.reference_number
JOIN person p
    ON ac.person_id = p.person_id

LEFT JOIN road_class rc
    ON a.road_class_id = rc.road_class_id
LEFT JOIN road_surface rs
    ON a.road_surface_id = rs.road_surface_id
LEFT JOIN lighting l
    ON a.lighting_id = l.lighting_id
LEFT JOIN weather w
    ON a.weather_id = w.weather_id

LEFT JOIN sex s
    ON p.sex_id = s.sex_id
LEFT JOIN vehicle v
    ON ac.vehicle_id = v.vehicle_id
LEFT JOIN casualty_class cc
    ON ac.casualty_class_id = cc.casualty_class_id
LEFT JOIN casualty_severity cs
    ON ac.casualty_severity_id = cs.casualty_severity_id;


-- View 4: Severity count by weather

CREATE OR REPLACE VIEW vw_severity_by_weather AS
SELECT
    w.description AS weather,
    cs.description AS casualty_severity,
    COUNT(*) AS casualty_count
FROM accident_casualty ac
JOIN accident a
    ON ac.reference_number = a.reference_number
LEFT JOIN weather w
    ON a.weather_id = w.weather_id
LEFT JOIN casualty_severity cs
    ON ac.casualty_severity_id = cs.casualty_severity_id
GROUP BY
    w.description,
    cs.description;


-- View 5: Severity count by lighting

CREATE OR REPLACE VIEW vw_severity_by_lighting AS
SELECT
    l.description AS lighting,
    cs.description AS casualty_severity,
    COUNT(*) AS casualty_count
FROM accident_casualty ac
JOIN accident a
    ON ac.reference_number = a.reference_number
LEFT JOIN lighting l
    ON a.lighting_id = l.lighting_id
LEFT JOIN casualty_severity cs
    ON ac.casualty_severity_id = cs.casualty_severity_id
GROUP BY
    l.description,
    cs.description;


-- View 6: Severity count by road surface

CREATE OR REPLACE VIEW vw_severity_by_road_surface AS
SELECT
    rs.description AS road_surface,
    cs.description AS casualty_severity,
    COUNT(*) AS casualty_count
FROM accident_casualty ac
JOIN accident a
    ON ac.reference_number = a.reference_number
LEFT JOIN road_surface rs
    ON a.road_surface_id = rs.road_surface_id
LEFT JOIN casualty_severity cs
    ON ac.casualty_severity_id = cs.casualty_severity_id
GROUP BY
    rs.description,
    cs.description;


-- View 7: Severity count by vehicle type

CREATE OR REPLACE VIEW vw_severity_by_vehicle AS
SELECT
    v.description AS vehicle,
    cs.description AS casualty_severity,
    COUNT(*) AS casualty_count
FROM accident_casualty ac
LEFT JOIN vehicle v
    ON ac.vehicle_id = v.vehicle_id
LEFT JOIN casualty_severity cs
    ON ac.casualty_severity_id = cs.casualty_severity_id
GROUP BY
    v.description,
    cs.description;


-- View verification queries - check SQL views return valid results

-- SELECT COUNT(*) AS rows_ml_features
-- FROM vw_accident_casualty_ml_features;

-- SELECT COUNT(*) AS rows_environmental_features
-- FROM vw_environmental_severity_features;

-- SELECT COUNT(*) AS rows_binary_features
-- FROM vw_binary_severity_features;

-- SELECT COUNT(*) AS rows_weather_summary
-- FROM vw_severity_by_weather;

-- SELECT COUNT(*) AS rows_lighting_summary
-- FROM vw_severity_by_lighting;

-- SELECT COUNT(*) AS rows_road_surface_summary
-- FROM vw_severity_by_road_surface;

-- SELECT COUNT(*) AS rows_vehicle_summary
-- FROM vw_severity_by_vehicle;


-- Preview main ML feature table

-- SELECT *
-- FROM vw_accident_casualty_ml_features
-- LIMIT 10;


-- Check binary severity distribution

-- SELECT
--     binary_severity,
--     COUNT(*) AS casualty_count
-- FROM vw_binary_severity_features
-- GROUP BY binary_severity;


-- Check original severity distribution

-- SELECT
--     casualty_severity,
--     COUNT(*) AS casualty_count
-- FROM vw_accident_casualty_ml_features
-- GROUP BY casualty_severity;