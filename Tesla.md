flowchart TD

    %% =========================================================
    %% Driver
    %% =========================================================

    D["Driver"]:::entity

    D_ID(["driver_id (PK)"]):::keyAttribute
    D_NAME(["full_name"]):::attribute
    D_EMAIL(["email"]):::attribute
    D_TIER(["membership_tier"]):::attribute
    D_CREATED(["created_at"]):::attribute

    D_ID --- D
    D_NAME --- D
    D_EMAIL --- D
    D_TIER --- D
    D_CREATED --- D

    %% =========================================================
    %% Vehicle
    %% =========================================================

    V["Vehicle"]:::entity

    V_ID(["vehicle_id (PK)"]):::keyAttribute
    V_DRIVER_ID(["driver_id (FK)"]):::attribute
    V_VIN(["vin"]):::attribute
    V_MODEL(["model"]):::attribute
    V_YEAR(["model_year"]):::attribute
    V_BATTERY(["battery_capacity_kwh"]):::attribute

    V_ID --- V
    V_DRIVER_ID --- V
    V_VIN --- V
    V_MODEL --- V
    V_YEAR --- V
    V_BATTERY --- V

    %% =========================================================
    %% Charging Hub
    %% =========================================================

    H["ChargingHub"]:::entity

    H_ID(["hub_id (PK)"]):::keyAttribute
    H_NAME(["hub_name"]):::attribute
    H_CITY(["city"]):::attribute
    H_STATE(["state"]):::attribute
    H_STATUS(["hub_status"]):::attribute

    H_ID --- H
    H_NAME --- H
    H_CITY --- H
    H_STATE --- H
    H_STATUS --- H

    %% =========================================================
    %% Charging Port
    %% =========================================================

    P["ChargingPort"]:::entity

    P_ID(["port_id (PK)"]):::keyAttribute
    P_HUB_ID(["hub_id (FK)"]):::attribute
    P_NUMBER(["port_number"]):::attribute
    P_CONNECTOR(["connector_type"]):::attribute
    P_POWER(["max_power_kw"]):::attribute
    P_STATUS(["port_status"]):::attribute

    P_ID --- P
    P_HUB_ID --- P
    P_NUMBER --- P
    P_CONNECTOR --- P
    P_POWER --- P
    P_STATUS --- P

    %% =========================================================
    %% Reservation
    %% =========================================================

    R["Reservation"]:::entity

    R_ID(["reservation_id (PK)"]):::keyAttribute
    R_VEHICLE_ID(["vehicle_id (FK)"]):::attribute
    R_PORT_ID(["port_id (FK)"]):::attribute
    R_START(["reserved_start"]):::attribute
    R_END(["reserved_end"]):::attribute
    R_STATUS(["reservation_status"]):::attribute

    R_ID --- R
    R_VEHICLE_ID --- R
    R_PORT_ID --- R
    R_START --- R
    R_END --- R
    R_STATUS --- R

    %% =========================================================
    %% Charging Session
    %% =========================================================

    CS["ChargingSession"]:::entity

    CS_ID(["session_id (PK)"]):::keyAttribute
    CS_VEHICLE_ID(["vehicle_id (FK)"]):::attribute
    CS_PORT_ID(["port_id (FK)"]):::attribute
    CS_RESERVATION_ID(["reservation_id (FK, nullable)"]):::attribute
    CS_STARTED(["started_at"]):::attribute
    CS_ENDED(["ended_at"]):::attribute
    CS_ENERGY(["energy_kwh"]):::attribute
    CS_COST(["total_cost"]):::attribute
    CS_STATUS(["session_status"]):::attribute

    CS_ID --- CS
    CS_VEHICLE_ID --- CS
    CS_PORT_ID --- CS
    CS_RESERVATION_ID --- CS
    CS_STARTED --- CS
    CS_ENDED --- CS
    CS_ENERGY --- CS
    CS_COST --- CS
    CS_STATUS --- CS

    %% =========================================================
    %% Relationships and cardinalities
    %% =========================================================

    OWNS{"OWNS"}:::relationship
    D ---|"(0..*)"| OWNS
    OWNS ---|"(1)"| V

    CONTAINS{"CONTAINS"}:::relationship
    H ---|"(0..*)"| CONTAINS
    CONTAINS ---|"(1)"| P

    SCHEDULES{"SCHEDULES"}:::relationship
    R ---|"(1)"| SCHEDULES
    SCHEDULES ---|"(0..*)"| V

    BOOKS{"BOOKS"}:::relationship
    R ---|"(1)"| BOOKS
    BOOKS ---|"(0..*)"| P

    CHARGES{"CHARGES"}:::relationship
    CS ---|"(1)"| CHARGES
    CHARGES ---|"(0..*)"| V

    USES{"USES"}:::relationship
    CS ---|"(1)"| USES
    USES ---|"(0..*)"| P

    FULFILLS{"FULFILLS"}:::relationship
    CS ---|"(0..1)"| FULFILLS
    FULFILLS ---|"(0..1)"| R

    %% =========================================================
    %% Styles
    %% =========================================================

    classDef entity fill:#D9EAF7,stroke:#1F4E79,stroke-width:2px,color:#000;
    classDef keyAttribute fill:#FFF2CC,stroke:#BF9000,stroke-width:1px,color:#000;
    classDef attribute fill:#F2F2F2,stroke:#666,stroke-width:1px,color:#000;
    classDef relationship fill:#E2F0D9,stroke:#548235,stroke-width:2px,color:#000;
