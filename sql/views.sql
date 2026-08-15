USE BiobankDB;

-- View 1: Available Aliquots with Complete Location & Donor Context
CREATE OR REPLACE VIEW view_available_aliquots_detail AS
SELECT 
    a.aliquot_id,
    st.type_name AS sample_type,
    a.volume_ul,
    a.concentration_ng_ul,
    sl.freezer_name,
    sl.shelf_number,
    sl.box_number,
    d.donor_id,
    d.blood_type,
    c.status AS consent_status
FROM aliquots a
JOIN biospecimens b ON a.specimen_id = b.specimen_id
JOIN sample_types st ON b.sample_type_id = st.sample_type_id
JOIN storage_locations sl ON a.location_id = sl.location_id
JOIN donors d ON b.donor_id = d.donor_id
JOIN consents c ON d.donor_id = c.donor_id
WHERE a.status = 'In Storage' AND c.status = 'Active';

-- View 2: Researcher Request Summary
CREATE OR REPLACE VIEW view_researcher_request_summary AS
SELECT 
    r.researcher_id,
    r.full_name,
    r.institution,
    COUNT(tr.request_id) AS total_requests,
    SUM(CASE WHEN tr.status = 'Approved' THEN 1 ELSE 0 END) AS approved_requests,
    SUM(CASE WHEN tr.status = 'Pending' THEN 1 ELSE 0 END) AS pending_requests,
    SUM(CASE WHEN tr.status = 'Rejected' THEN 1 ELSE 0 END) AS rejected_requests
FROM researchers r
LEFT JOIN test_requests tr ON r.researcher_id = tr.researcher_id
GROUP BY r.researcher_id, r.full_name, r.institution;