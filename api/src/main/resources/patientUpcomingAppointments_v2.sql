UPDATE global_property
SET property_value = 'SELECT
    pa.uuid,
    app_service.name AS "DASHBOARD_APPOINTMENTS_SERVICE_KEY",
    app_service_type.name AS "DASHBOARD_APPOINTMENTS_SERVICE_TYPE_KEY",
    TO_CHAR(pa.start_date_time, ''DD/MM/YYYY'') AS "DASHBOARD_APPOINTMENTS_DATE_KEY",
    CONCAT(
        TO_CHAR(pa.start_date_time, ''HH12:MI AM''),
        '' - '',
        TO_CHAR(pa.end_date_time, ''HH12:MI AM'')
    ) AS "DASHBOARD_APPOINTMENTS_SLOT_KEY",
    CONCAT(pn.given_name, '' '', pn.family_name) AS "DASHBOARD_APPOINTMENTS_PROVIDER_KEY",
    pa.status AS "DASHBOARD_APPOINTMENTS_STATUS_KEY",
    pa.appointment_kind AS "DASHBOARD_APPOINTMENTS_KIND",
    pa.start_date_time AS "DASHBOARD_APPOINTMENTS_START_DATE_KEY",
    pa.end_date_time AS "DASHBOARD_APPOINTMENTS_END_DATE_KEY",
    pa.tele_health_video_link
FROM
    patient_appointment pa
    JOIN person p
        ON p.person_id = pa.patient_id
        AND pa.voided = FALSE
    JOIN appointment_service app_service
        ON app_service.appointment_service_id = pa.appointment_service_id
        AND app_service.voided = FALSE
    LEFT JOIN patient_appointment_provider pap
        ON pa.patient_appointment_id = pap.patient_appointment_id
        AND COALESCE(pap.voided, FALSE) = FALSE
    LEFT JOIN provider prov
        ON prov.provider_id = pap.provider_id
        AND prov.retired = FALSE
    LEFT JOIN person_name pn
        ON pn.person_id = prov.person_id
        AND pn.voided = FALSE
    LEFT JOIN appointment_service_type app_service_type
        ON app_service_type.appointment_service_type_id = pa.appointment_service_type_id
WHERE
    p.uuid = ${patientUuid}
    AND pa.start_date_time >= CURRENT_DATE
    AND COALESCE(app_service_type.voided, FALSE) = FALSE
ORDER BY
    pa.start_date_time ASC;'
WHERE property = 'bahmni.sqlGet.upComingAppointments';