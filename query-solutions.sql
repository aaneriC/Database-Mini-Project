-- =============================================================
-- ECE 4990 Database Management Mini Project
-- Testla Smart EV Charging Hub
-- PUBLIC query-solutions.sql TEMPLATE
--
-- Rename this file to query-solutions.sql before submission.
-- Do not change question order, required aliases, or ordering.
-- Replace each TODO with exactly one query.
-- =============================================================

USE testla;

-- Q1: List available ports with at least 150 kW of power.
-- Required columns: port_id, hub_name, port_number, max_power_kw
-- Required order: hub_id ASC, port_number ASC
-- TODO: Write Q1 here.
SELECT p.port_id, h.hub_name, p.port_number, p.max_power_kw
FROM charging_port p
JOIN charging_hub h ON p.hub_id = h.hub_id
WHERE p.port_status = 'AVAILABLE' AND p.max_power_kw >= 150
ORDER BY h.hub_id, p.port_number;


-- Q2: List every vehicle and its registered driver.
-- Required columns: vehicle_id, vin, model, owner_name
-- Required order: vehicle_id ASC
-- TODO: Write Q2 here
SELECT v.vehicle_id, v.vin, v.model, d.full_name AS owner_name
FROM vehicle v
JOIN driver d ON v.driver_id = d.driver_id
ORDER BY v.vehicle_id ASC; 


-- Q3: List completed reservations with their driver, vehicle,
--     charging hub, port number, and reserved start time.
-- Required columns: reservation_id, driver_name, model, hub_name,
--                   port_number, reserved_start
-- Required order: reservation_id ASC
-- TODO: Write Q3 here.
SELECT r.reservation_id, d.full_name AS driver_name, v.model, h.hub_name, p.port_number, r.reserved_start
FROM reservation r
JOIN vehicle v ON r.vehicle_id = v.vehicle_id
JOIN driver d ON v.driver_id = d.driver_id
JOIN charging_port p ON r.port_id = p.port_id
JOIN charging_hub h ON p.hub_id = h.hub_id
WHERE r.reservation_status = 'COMPLETED'
ORDER BY r.reservation_id ASC;
-- Q4: List every driver and the number of registered vehicles,
--     including drivers who have zero vehicles.
-- Required columns: driver_id, full_name, vehicle_count
-- Required order: driver_id ASC
-- TODO: Write Q4 here.
SELECT d.driver_id, d.full_name, COUNT(v.vehicle_id) AS vehicle_count
FROM driver AS d
LEFT JOIN vehicle AS v ON v.driver_id = d.driver_id
GROUP BY d.driver_id, d.full_name
ORDER BY d.driver_id ASC;


-- Q5: For each hub represented by at least one COMPLETED session,
--     calculate completed-session count, total energy, and total cost.
-- Required columns: hub_id, hub_name, completed_session_count,
--                   total_energy_kwh, total_cost_usd
-- Required order: hub_id ASC
-- TODO: Write Q5 here.
SELECT h.hub_id, h.hub_name, COUNT(s.session_id) AS completed_session_count, SUM(s.energy_kwh)   AS total_energy_kwh, SUM(s.total_cost)   AS total_cost_usd      
FROM charging_session AS s
JOIN charging_port AS p ON p.port_id = s.port_id
JOIN charging_hub AS h ON h.hub_id  = p.hub_id
WHERE s.session_status = 'COMPLETED'
GROUP BY h.hub_id, h.hub_name
ORDER BY h.hub_id ASC;


-- Q6: Find drivers with at least two COMPLETED charging sessions.
-- Required columns: driver_id, full_name, completed_session_count
-- Required order: completed_session_count DESC, driver_id ASC
-- TODO: Write Q6 here.
SELECT d.driver_id, d.full_name, COUNT(s.session_id) AS completed_session_count     
FROM charging_session AS s
JOIN vehicle AS v ON v.vehicle_id = s.vehicle_id
JOIN driver AS d ON d.driver_id  = v.driver_id
WHERE s.session_status = 'COMPLETED'
GROUP BY d.driver_id, d.full_name
HAVING COUNT(s.session_id) >= 2
ORDER BY completed_session_count DESC, d.driver_id ASC;


-- Q7: Find COMPLETED sessions whose energy_kwh is greater than the
--     average energy_kwh of all COMPLETED sessions.
-- Required columns: session_id, vehicle_id, energy_kwh
-- Required order: energy_kwh DESC, session_id ASC
-- TODO: Write Q7 here.
SELECT s.session_id, s.vehicle_id, s.energy_kwh
FROM charging_session AS s
WHERE s.session_status = 'COMPLETED'
  AND s.energy_kwh > (
        SELECT AVG(s2.energy_kwh)
        FROM charging_session AS s2
        WHERE s2.session_status = 'COMPLETED'
      )
ORDER BY s.energy_kwh DESC, s.session_id ASC;


-- Q8: Find charging ports that have never been used by any session.
-- Required columns: port_id, hub_name, port_number
-- Required order: hub_id ASC, port_number ASC
-- TODO: Write Q8 here.
SELECT d.driver_id, d.full_name
FROM driver AS d
JOIN vehicle AS v ON v.driver_id = d.driver_id
JOIN charging_session AS s ON s.vehicle_id = v.vehicle_id
JOIN charging_port AS p ON p.port_id = s.port_id
JOIN charging_hub AS h ON h.hub_id = p.hub_id
WHERE s.session_status = 'COMPLETED'
  AND h.hub_status = 'ACTIVE'
GROUP BY d.driver_id, d.full_name
HAVING COUNT(DISTINCT h.hub_id) = (
    SELECT COUNT(*) FROM charging_hub WHERE hub_status = 'ACTIVE'
)
ORDER BY d.driver_id ASC;

-- Q10: Find the highest-energy COMPLETED session at each hub.
--      Include all tied sessions.
-- Required columns: hub_id, hub_name, session_id, driver_name,
--                   model, energy_kwh
-- Required order: hub_id ASC, session_id ASC
-- TODO: Write Q10 here.
SELECT h.hub_id, h.hub_name, s.session_id, d.full_name AS driver_name, v.model, s.energy_kwh
FROM charging_session AS s
JOIN charging_port AS p ON p.port_id = s.port_id
JOIN charging_hub AS h ON h.hub_id = p.hub_id
JOIN vehicle AS v ON v.vehicle_id = s.vehicle_id
JOIN driver AS d ON d.driver_id = v.driver_id
WHERE s.session_status = 'COMPLETED'
  AND s.energy_kwh = (
        SELECT MAX(s2.energy_kwh)
        FROM charging_session AS s2
        JOIN charging_port AS p2 ON p2.port_id = s2.port_id
        WHERE p2.hub_id = p.hub_id
          AND s2.session_status = 'COMPLETED'
      )
ORDER BY h.hub_id ASC, s.session_id ASC;

