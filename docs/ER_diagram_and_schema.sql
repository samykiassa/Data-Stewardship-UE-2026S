DROP TABLE IF EXISTS accident_casualty;
DROP TABLE IF EXISTS accident;
DROP TABLE IF EXISTS person;

DROP TABLE IF EXISTS casualty_severity;
DROP TABLE IF EXISTS casualty_class;
DROP TABLE IF EXISTS vehicle;

DROP TABLE IF EXISTS weather;
DROP TABLE IF EXISTS lighting;
DROP TABLE IF EXISTS road_surface;
DROP TABLE IF EXISTS road_class;

DROP TABLE IF EXISTS sex;

CREATE TABLE weather (
    weather_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE lighting (
    lighting_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE vehicle (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE road_surface (
    road_surface_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE road_class (
    road_class_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE casualty_class (
    casualty_class_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE casualty_severity (
    casualty_severity_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE sex (
    sex_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE accident (
    reference_number VARCHAR(20) PRIMARY KEY,
    easting INT,
    northing INT,
    number_of_vehicles INT,
    date DATE,
    time INT,

    road_class_id INT,
    road_surface_id INT,
    lighting_id INT,
    weather_id INT,

    FOREIGN KEY (road_class_id) REFERENCES road_class(road_class_id),
    FOREIGN KEY (road_surface_id) REFERENCES road_surface(road_surface_id),
    FOREIGN KEY (lighting_id) REFERENCES lighting(lighting_id),
    FOREIGN KEY (weather_id) REFERENCES weather(weather_id)
);

CREATE TABLE person (
    person_id INT AUTO_INCREMENT PRIMARY KEY,
    sex_id INT,
    age INT,

    FOREIGN KEY (sex_id) REFERENCES sex(sex_id)
);

CREATE TABLE accident_casualty (
    reference_number VARCHAR(20),
    person_id INT,

    casualty_class_id INT,
    casualty_severity_id INT,
    vehicle_id INT,

    PRIMARY KEY (reference_number, person_id),

    FOREIGN KEY (reference_number) REFERENCES accident(reference_number),
    FOREIGN KEY (person_id) REFERENCES person(person_id),
    FOREIGN KEY (casualty_class_id) REFERENCES casualty_class(casualty_class_id),
    FOREIGN KEY (casualty_severity_id) REFERENCES casualty_severity(casualty_severity_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
);

-- Added spurious cheese dataset table
CREATE TABLE cheese_consumption (
    Year INT PRIMARY KEY,
    Cheese_Consumption_lbs DECIMAL(5,2)
);
