-- =============================================================
-- ECE 4990 Database Management Mini Project
-- Testla Smart EV Charging Hub
-- PUBLIC DATASET
--
-- Run your schema.sql before running this file.
-- Do not modify this file to make it match your schema.
-- If it fails, compare your schema with the published contract.
-- =============================================================

USE testla;

-- Temporarily disable Safe Updates for complete data cleanup.
SET SESSION SQL_SAFE_UPDATES = 0;

-- Delete child rows before parent rows.
DELETE FROM charging_session;
DELETE FROM reservation;
DELETE FROM charging_port;
DELETE FROM charging_hub;
DELETE FROM vehicle;
DELETE FROM driver;

-- Turn Safe Updates back on.
SET SESSION SQL_SAFE_UPDATES = 1;

-- Parent table: driver
INSERT INTO driver
    (driver_id, full_name, email, membership_tier, created_at)
VALUES
    (1, 'Maya Chen', 'maya.chen@example.edu', 'PREMIUM', '2026-01-10'),
    (2, 'Liam Patel', 'liam.patel@example.edu', 'STANDARD', '2026-01-12'),
    (3, 'Sofia Ramirez', 'sofia.ramirez@example.edu', 'PREMIUM', '2026-02-01'),
    (4, 'Noah Williams', 'noah.williams@example.edu', 'STANDARD', '2026-02-10'),
    (5, 'Ava Kim', 'ava.kim@example.edu', 'STANDARD', '2026-03-01');

-- Child of driver: vehicle
INSERT INTO vehicle
    (vehicle_id, driver_id, vin, model, model_year, battery_capacity_kwh)
VALUES
    (101, 1, 'SYNTHVIN000000101', 'Model 3', 2024, 60.00),
    (102, 1, 'SYNTHVIN000000102', 'Model Y', 2025, 75.00),
    (103, 2, 'SYNTHVIN000000103', 'Model S', 2023, 100.00),
    (104, 3, 'SYNTHVIN000000104', 'Cybertruck', 2025, 123.00),
    (105, 4, 'SYNTHVIN000000105', 'Model 3', 2022, 55.00);

-- Parent table: charging_hub
INSERT INTO charging_hub
    (hub_id, hub_name, city, state, hub_status)
VALUES
    (10, 'Cal Poly Pomona Hub', 'Pomona', 'CA', 'ACTIVE'),
    (20, 'Downtown LA Hub', 'Los Angeles', 'CA', 'ACTIVE'),
    (30, 'Pasadena Tech Hub', 'Pasadena', 'CA', 'MAINTENANCE');

-- Child of charging_hub: charging_port
INSERT INTO charging_port
    (port_id, hub_id, port_number, connector_type, max_power_kw, port_status)
VALUES
    (1001, 10, 1, 'NACS', 250.00, 'AVAILABLE'),
    (1002, 10, 2, 'NACS', 150.00, 'CHARGING'),
    (1003, 10, 3, 'CCS', 50.00, 'OUT_OF_SERVICE'),
    (2001, 20, 1, 'NACS', 250.00, 'AVAILABLE'),
    (2002, 20, 2, 'NACS', 150.00, 'AVAILABLE'),
    (3001, 30, 1, 'NACS', 250.00, 'OUT_OF_SERVICE'),
    (3002, 30, 2, 'CCS', 100.00, 'OUT_OF_SERVICE');

-- Child of vehicle and charging_port: reservation
INSERT INTO reservation
    (reservation_id, vehicle_id, port_id,
     reserved_start, reserved_end, reservation_status)
VALUES
    (5001, 101, 1001, '2026-09-01 08:00:00', '2026-09-01 09:00:00', 'COMPLETED'),
    (5002, 103, 2001, '2026-09-01 10:00:00', '2026-09-01 11:00:00', 'COMPLETED'),
    (5003, 104, 3001, '2026-09-02 09:00:00', '2026-09-02 10:00:00', 'CANCELLED'),
    (5004, 102, 1002, '2026-09-02 12:00:00', '2026-09-02 13:00:00', 'COMPLETED'),
    (5005, 105, 2002, '2026-09-03 14:00:00', '2026-09-03 15:00:00', 'NO_SHOW'),
    (5006, 104, 2001, '2026-09-04 08:00:00', '2026-09-04 09:00:00', 'COMPLETED'),
    (5007, 101, 1001, '2026-09-10 08:00:00', '2026-09-10 09:00:00', 'BOOKED');

-- Child of vehicle and charging_port; optionally child of reservation.
INSERT INTO charging_session
    (session_id, vehicle_id, port_id, reservation_id,
     started_at, ended_at, energy_kwh, total_cost, session_status)
VALUES
    (9001, 101, 1001, 5001,
     '2026-09-01 08:05:00', '2026-09-01 08:45:00',
     32.50, 9.75, 'COMPLETED'),
    (9002, 103, 2001, 5002,
     '2026-09-01 10:02:00', '2026-09-01 10:50:00',
     55.00, 19.25, 'COMPLETED'),
    (9003, 102, 1002, 5004,
     '2026-09-02 12:05:00', '2026-09-02 12:55:00',
     40.00, 12.00, 'COMPLETED'),
    (9004, 104, 2001, 5006,
     '2026-09-04 08:01:00', '2026-09-04 08:50:00',
     60.00, 21.00, 'COMPLETED'),
    (9005, 101, 2002, NULL,
     '2026-09-03 18:00:00', '2026-09-03 18:30:00',
     20.00, 7.00, 'COMPLETED'),
    (9006, 103, 1001, NULL,
     '2026-09-04 15:00:00', '2026-09-04 16:00:00',
     70.00, 21.00, 'COMPLETED'),
    (9007, 104, 1001, NULL,
     '2026-09-05 10:00:00', '2026-09-05 11:00:00',
     65.00, 19.50, 'COMPLETED'),
    (9008, 105, 2002, NULL,
     '2026-09-05 16:00:00', '2026-09-05 16:40:00',
     25.00, 8.75, 'COMPLETED'),
    (9009, 102, 3001, NULL,
     '2026-09-06 09:00:00', '2026-09-06 09:45:00',
     45.00, 15.75, 'COMPLETED'),
    (9010, 101, 1002, NULL,
     '2026-09-06 11:00:00', NULL,
     10.00, 3.00, 'IN_PROGRESS');

-- Verification: the expected counts are 5, 5, 3, 7, 7, and 10.
SELECT COUNT(*) AS driver_rows FROM driver;
SELECT COUNT(*) AS vehicle_rows FROM vehicle;
SELECT COUNT(*) AS charging_hub_rows FROM charging_hub;
SELECT COUNT(*) AS charging_port_rows FROM charging_port;
SELECT COUNT(*) AS reservation_rows FROM reservation;
SELECT COUNT(*) AS charging_session_rows FROM charging_session;
