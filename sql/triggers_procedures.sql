USE BiobankDB;

-- 1. Trigger: Automatically update Aliquot status when volume drops to zero
DELIMITER //
CREATE TRIGGER trg_check_aliquot_volume
BEFORE UPDATE ON aliquots
FOR EACH ROW
BEGIN
    IF NEW.volume_ul <= 0 THEN
        SET NEW.status = 'Used';
        SET NEW.volume_ul = 0;
    END IF;
END //
DELIMITER ;

-- 2. Stored Procedure: Fetch Full History for a Given Donor ID
DELIMITER //
CREATE PROCEDURE sp_GetDonorFullHistory(IN in_donor_id INT)
BEGIN
    -- Donor & Consent Info
    SELECT d.donor_id, d.first_name, d.last_name, d.blood_type, c.consent_type, c.status AS consent_status
    FROM donors d
    LEFT JOIN consents c ON d.donor_id = c.donor_id
    WHERE d.donor_id = in_donor_id;

    -- Associated Biospecimens and Aliquots
    SELECT 
        b.specimen_id,
        st.type_name,
        b.collection_date,
        a.aliquot_id,
        a.volume_ul,
        a.status AS aliquot_status,
        sl.freezer_name
    FROM biospecimens b
    JOIN sample_types st ON b.sample_type_id = st.sample_type_id
    LEFT JOIN aliquots a ON b.specimen_id = a.specimen_id
    LEFT JOIN storage_locations sl ON a.location_id = sl.location_id
    WHERE b.donor_id = in_donor_id;
END //
DELIMITER ;