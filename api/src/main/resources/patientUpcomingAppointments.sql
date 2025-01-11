INSERT INTO global_property (property, property_value, description, uuid)
VALUES ('bahmni.sqlGet.upComingAppointments',
        'SELECT
          app_service.name AS "DASHBOARD_APPOINTMENTS_SERVICE_KEY",
          app_service_type.name AS "DASHBOARD_APPOINTMENTS_SERVICE_TYPE_KEY",
          TO_CHAR(pa.start_date_time, ''DD/MM/YYYY'') AS "DASHBOARD_APPOINTMENTS_DATE_KEY",
          CONCAT(TO_CHAR(pa.start_date_time, ''HH12:MI AM''), '' - '', TO_CHAR(pa.end_date_time, ''HH12:MI AM'')) AS "DASHBOARD_APPOINTMENTS_SLOT_KEY",
          CONCAT(pn.given_name, '' '', pn.family_name) AS "DASHBOARD_APPOINTMENTS_PROVIDER_KEY",
          pa.status AS "DASHBOARD_APPOINTMENTS_STATUS_KEY"
        FROM
          patient_appointment pa
        JOIN person p ON p.person_id = pa.patient_id AND pa.voided IS FALSE
        JOIN appointment_service app_service
          ON app_service.appointment_service_id = pa.appointment_service_id AND app_service.voided IS FALSE
        LEFT JOIN patient_appointment_provider pap ON pa.patient_appointment_id = pap.patient_appointment_id AND (pap.voided = 0 OR pap.voided IS NULL)
        LEFT JOIN provider prov ON prov.provider_id = pap.provider_id AND prov.retired IS FALSE
        LEFT JOIN person_name pn ON pn.person_id = prov.person_id AND pn.voided IS FALSE
        LEFT JOIN appointment_service_type app_service_type
          ON app_service_type.appointment_service_type_id = pa.appointment_service_type_id
        WHERE p.uuid = ${patientUuid} AND
              pa.start_date_time >= CURRENT_DATE AND
              (app_service_type.voided IS FALSE OR app_service_type.voided IS NULL)
        ORDER BY pa.start_date_time ASC;'
, 'Upcoming appointments for patient', uuid());