USE BiobankDB;

-- 1. SELECT with JOIN & WHERE: Get all active DNA samples in Storage
SELECT 
    b.specimen_id,
    d.first_name,
    d.last_name,
    st.type_name,
    a.volume_ul,
    a.concentration_ng_ul
FROM biospecimens b
JOIN donors d ON b.donor_id = d.donor_id
JOIN sample_types st ON b.sample_type_id = st.sample_type_id
JOIN aliquots a ON b.specimen_id = a.specimen_id
WHERE st.type_name = 'DNA Extract' AND a.status = 'In Storage';

-- 2. AGGREGATION & GROUP BY: Count of specimens collected per sample type
SELECT 
    st.type_name,
    COUNT(b.specimen_id) AS total_specimens,
    AVG(b.initial_volume_ml) AS avg_initial_volume_ml
FROM sample_types st
LEFT JOIN biospecimens b ON st.sample_type_id = b.sample_type_id
GROUP BY st.sample_type_id, st.type_name;

-- 3. NESTED SUBQUERY: Find Donors who have Active consent but NO specimens collected yet
SELECT donor_id, first_name, last_name, email
FROM donors
WHERE donor_id IN (
    SELECT donor_id FROM consents WHERE status = 'Active'
)
AND donor_id NOT IN (
    SELECT DISTINCT donor_id FROM biospecimens
);

-- 4. INSERT Operation: Add a new storage location for a demonstration
INSERT INTO storage_locations (freezer_name, shelf_number, box_number, capacity)
VALUES ('Freezer Delta', 1, 401, 75);

-- 5. UPDATE Operation: Change request status
UPDATE test_requests 
SET status = 'Approved' 
WHERE request_id = 3;

-- 6. DELETE Operation: Safe removal of an expired consent record
DELETE FROM consents 
WHERE status = 'Expired' AND signed_date < '2023-06-01';

-- 7. Testing both required views
SELECT * FROM view_available_aliquots_detail;
SELECT * FROM view_researcher_request_summary;

-- 8. Testing the Stored Procedure
CALL sp_GetDonorFullHistory(1);