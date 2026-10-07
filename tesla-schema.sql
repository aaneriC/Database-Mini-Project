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

-- -------------------------------------------------------------
-- Verification commands
-- -------------------------------------------------------------
USE testla;
SHOW TABLES;
SHOW CREATE TABLE driver;



