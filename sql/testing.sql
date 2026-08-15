USE BiobankDB;

-- T1: Row counts for all main tables
SELECT 'donors' AS table_name, COUNT(*) AS row_count FROM donors
UNION ALL SELECT 'consents', COUNT(*) FROM consents
UNION ALL SELECT 'sample_types', COUNT(*) FROM sample_types
UNION ALL SELECT 'storage_locations', COUNT(*) FROM storage_locations
UNION ALL SELECT 'biospecimens', COUNT(*) FROM biospecimens
UNION ALL SELECT 'aliquots', COUNT(*) FROM aliquots
UNION ALL SELECT 'researchers', COUNT(*) FROM researchers
UNION ALL SELECT 'test_requests', COUNT(*) FROM test_requests
UNION ALL SELECT 'request_aliquots', COUNT(*) FROM request_aliquots;

-- T2: Available aliquot view
SELECT * FROM view_available_aliquots_detail;

-- T3: Researcher request summary view
SELECT * FROM view_researcher_request_summary ORDER BY total_requests DESC, researcher_id;

-- T4: Stored procedure returns two result sets for donor 1
CALL sp_GetDonorFullHistory(1);

-- T5: Trigger test. This statement is expected to change volume to 0 and status to Used.
UPDATE aliquots
SET volume_ul = 0, status = 'In Storage'
WHERE aliquot_id = 1;
SELECT aliquot_id, volume_ul, status FROM aliquots WHERE aliquot_id = 1;

-- T6: Foreign-key protection test. This should fail because donor 1 has specimens.
-- DELETE FROM donors WHERE donor_id = 1;

-- T7: Confirm indexes exist
SHOW INDEX FROM donors;
SHOW INDEX FROM biospecimens;
SHOW INDEX FROM aliquots;
