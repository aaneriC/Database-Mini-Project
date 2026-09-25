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


-- Q2: List every vehicle and its registered driver.
-- Required columns: vehicle_id, vin, model, owner_name
-- Required order: vehicle_id ASC
-- TODO: Write Q2 here.


-- Q3: List completed reservations with their driver, vehicle,
--     charging hub, port number, and reserved start time.
-- Required columns: reservation_id, driver_name, model, hub_name,
--                   port_number, reserved_start
-- Required order: reservation_id ASC
-- TODO: Write Q3 here.


-- Q4: List every driver and the number of registered vehicles,
--     including drivers who have zero vehicles.
-- Required columns: driver_id, full_name, vehicle_count
-- Required order: driver_id ASC
-- TODO: Write Q4 here.


-- Q5: For each hub represented by at least one COMPLETED session,
--     calculate completed-session count, total energy, and total cost.
-- Required columns: hub_id, hub_name, completed_session_count,
--                   total_energy_kwh, total_cost_usd
-- Required order: hub_id ASC
-- TODO: Write Q5 here.


-- Q6: Find drivers with at least two COMPLETED charging sessions.
-- Required columns: driver_id, full_name, completed_session_count
-- Required order: completed_session_count DESC, driver_id ASC
-- TODO: Write Q6 here.


-- Q7: Find COMPLETED sessions whose energy_kwh is greater than the
--     average energy_kwh of all COMPLETED sessions.
-- Required columns: session_id, vehicle_id, energy_kwh
-- Required order: energy_kwh DESC, session_id ASC
-- TODO: Write Q7 here.


-- Q8: Find charging ports that have never been used by any session.
-- Required columns: port_id, hub_name, port_number
-- Required order: hub_id ASC, port_number ASC
-- TODO: Write Q8 here.


-- Q9: Find drivers who have a COMPLETED session at every ACTIVE hub.
-- Required columns: driver_id, full_name
-- Required order: driver_id ASC
-- TODO: Write Q9 here.


-- Q10: Find the highest-energy COMPLETED session at each hub.
--      Include all tied sessions.
-- Required columns: hub_id, hub_name, session_id, driver_name,
--                   model, energy_kwh
-- Required order: hub_id ASC, session_id ASC
-- TODO: Write Q10 here.
