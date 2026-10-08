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

-- =============================================================
-- 3. CHARGING HUB
-- =============================================================
CREATE TABLE charging_hub
(
    hub_id INT PRIMARY KEY NOT NULL,
    hub_name VARCHAR(100) NOT NULL,
    city VARCHAR(80) NOT NULL,
    state CHAR(2) NOT NULL,
    hub_status VARCHAR(20) NOT NULL,

    CONSTRAINT check_charging_hub
        CHECK (hub_status IN ('ACTIVE', 'MAINTENANCE', 'CLOSED'))
);

-- =============================================================
-- 4. CHARGING PORT
-- =============================================================
CREATE TABLE charging_port
(
    port_id INT PRIMARY KEY NOT NULL, 
    hub_id INT NOT NULL, 
    port_number INT NOT NULL, 
    connector_type VARCHAR(10) NOT NULL, 
    max_power_kw DECIMAL(6, 2) NOT NULL, 
    port_status VARCHAR(20) NOT NULL,

    CONSTRAINT unique_hub_port
        UNIQUE (hub_id, port_number),

    CONSTRAINT check_port_number
        CHECK (port_number > 0),
    
    CONSTRAINT check_max_power
        CHECK (max_power_kw >= 0),

    CONSTRAINT  check_connector_type
        CHECK (connector_type IN ('NACS', 'CCS')),

    CONSTRAINT check_port_status
        CHECK (port_status IN ('AVAILABLE', 'CHARGING', 'OUT_OF_SERVICE')),

    CONSTRAINT fk_charging_hub
        FOREIGN KEY (hub_id)
        REFERENCES charging_hub(hub_id)
        ON DELETE RESTRICT
);

-- =============================================================
-- 5. RESERVATION
-- =============================================================
CREATE TABLE reservation
(
    reservation_id INT PRIMARY KEY NOT NULL, 
    vehicle_id INT NOT NULL, 
    port_id INT NOT NULL,
    reserved_start DATETIME NOT NULL, 
    reserved_end DATETIME NOT NULL, 
    reservation_status VARCHAR(12) NOT NULL, 

    CONSTRAINT check_reservation_dates 
        CHECK (reserved_end > reserved_start),
    
    CONSTRAINT check_reservation_status
        CHECK (reservation_status IN ('BOOKED', 'COMPLETED', 'CANCELLED', 'NO_SHOW')),
    
    CONSTRAINT fk_reservation_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES vehicle(vehicle_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_reservation_port
        FOREIGN KEY (port_id)
        REFERENCES charging_port(port_id)
        ON DELETE RESTRICT
);

-- =============================================================
-- 6. CHARGING SESSION
-- =============================================================
CREATE TABLE charging_session
(
    session_id INT PRIMARY KEY NOT NULL, 
    vehicle_id INT NOT NULL, 
    port_id INT NOT NULL, 
    reservation_id INT NULL UNIQUE,
    started_at DATETIME NOT NULL, 
    ended_at DATETIME NULL, 
    energy_kwh DECIMAL(7, 2) NOT NULL, 
    total_cost DECIMAL(8, 2) NOT NULL, 
    session_status VARCHAR(12) NOT NULL,

    CONSTRAINT check_charging_energy
        CHECK (energy_kwh >= 0),
    
    CONSTRAINT check_total_cost
        CHECK (total_cost >= 0),
    
    CONSTRAINT check_session_status
        CHECK (session_status IN('IN_PROGRESS', 'COMPLETED', 'INTERRUPTED')),
    
    CONSTRAINT check_session_end_time
        CHECK
        (
            (session_status = 'IN_PROGRESS' AND ended_at IS NULL)
            OR
            (
                session_status IN ('COMPLETED', 'INTERRUPTED')
                AND ended_at IS NOT NULL
                AND ended_at > started_at
            )
        ),

    CONSTRAINT fk_session_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES vehicle(vehicle_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_session_port
        FOREIGN KEY (port_id)
        REFERENCES charging_port(port_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_session_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservation(reservation_id)
        ON DELETE RESTRICT
);

-- -------------------------------------------------------------
-- Verification commands    
-- -------------------------------------------------------------
USE testla;
SHOW TABLES;
SHOW CREATE TABLE driver;
SHOW CREATE TABLE vehicle;
SHOW CREATE TABLE charging_hub;
SHOW CREATE TABLE charging_port;
SHOW CREATE TABLE reservation;
SHOW CREATE TABLE charging_session;
