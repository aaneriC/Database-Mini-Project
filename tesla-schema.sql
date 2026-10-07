CREATE DATABASE IF NOT EXISTS testla;
USE testla;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS charging_session;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS charging_port;
DROP TABLE IF EXISTS charging_hub;
DROP TABLE IF EXISTS vehicle;
DROP TABLE IF EXISTS driver;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
-- 1. DRIVER
-- =============================================================
CREATE TABLE driver
(
    driver_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    membership_tier VARCHAR(10) NOT NULL,
    created_at DATE NOT NULL,

    CONSTRAINT check_membership_tier
        CHECK (membership_tier IN ('STANDARD', 'PREMIUM'))
);

-- =============================================================
-- 2. VEHICLE
-- =============================================================
CREATE TABLE vehicle
(
    vehicle_id INT PRIMARY KEY NOT NULL,
    driver_id INT NOT NULL,
    vin CHAR(17) NOT NULL UNIQUE,
    model VARCHAR(50) NOT NULL,
    model_year SMALLINT NOT NULL,
    battery_capacity_kwh DECIMAL(6, 2) NOT NULL,

    CONSTRAINT check_vehicle_vin
        CHECK (CHAR_LENGTH(vin) = 17),
    
    CONSTRAINT check_model_year
        CHECK (model_year BETWEEN 2000 AND 2100),

    CONSTRAINT check_battery_capacity
        CHECK (battery_capacity_kwh > 0),
    
    CONSTRAINT fk_vehicle_driver
        FOREIGN KEY (driver_id)
        REFERENCES driver(driver_id)
        ON DELETE RESTRICT
);


-- -------------------------------------------------------------
-- Verification commands
-- -------------------------------------------------------------
USE testla;
SHOW TABLES;
SHOW CREATE TABLE driver;

