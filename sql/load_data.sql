USE BiobankDB;

-- 1. Insert Sample Types
INSERT INTO sample_types (type_name, description, storage_temp_celsius) VALUES
('Whole Blood', 'Fresh unseparated blood', -80.00),
('Plasma', 'Blood plasma isolated via centrifugation', -80.00),
('DNA Extract', 'Purified genomic DNA', -20.00),
('Tissue Biopsy', 'Cryopreserved tissue samples', -196.00);

-- 2. Insert Donors (10 Donors)
INSERT INTO donors (first_name, last_name, gender, date_of_birth, blood_type, email) VALUES
('Ahmed', 'Ali', 'Male', '1990-05-14', 'A+', 'ahmed.ali@example.com'),
('Sara', 'Hassan', 'Female', '1985-11-22', 'O+', 'sara.hassan@example.com'),
('Omar', 'Khaled', 'Male', '1998-03-10', 'B-', 'omar.khaled@example.com'),
('Mona', 'Ibrahim', 'Female', '1992-07-19', 'AB+', 'mona.ibrahim@example.com'),
('Youssef', 'Mahmoud', 'Male', '1980-01-30', 'O-', 'youssef.m@example.com'),
('Nour', 'El-Din', 'Female', '1995-09-05', 'A-', 'nour.e@example.com'),
('Khaled', 'Tarek', 'Male', '2000-12-12', 'B+', 'khaled.t@example.com'),
('Heba', 'Mostafa', 'Female', '1988-04-18', 'AB-', 'heba.m@example.com'),
('Mostafa', 'Sami', 'Male', '1993-08-25', 'O+', 'mostafa.s@example.com'),
('Dina', 'Fouad', 'Female', '1997-02-14', 'A+', 'dina.f@example.com');

-- 3. Insert Consents (10 Consents)
INSERT INTO consents (donor_id, consent_type, status, signed_date) VALUES
(1, 'General Research', 'Active', '2024-01-10'),
(2, 'Genomic Study', 'Active', '2024-01-15'),
(3, 'Oncology Research', 'Active', '2024-02-01'),
(4, 'General Research', 'Revoked', '2024-02-10'),
(5, 'Cardiovascular Study', 'Active', '2024-02-20'),
(6, 'General Research', 'Active', '2024-03-05'),
(7, 'Genomic Study', 'Active', '2024-03-12'),
(8, 'Oncology Research', 'Expired', '2023-01-01'),
(9, 'General Research', 'Active', '2024-04-01'),
(10, 'Genomic Study', 'Active', '2024-04-15');

-- 4. Insert Storage Locations (10 Locations)
INSERT INTO storage_locations (freezer_name, shelf_number, box_number, capacity) VALUES
('Freezer Alpha', 1, 101, 50),
('Freezer Alpha', 1, 102, 50),
('Freezer Alpha', 2, 201, 50),
('Freezer Beta', 1, 101, 100),
('Freezer Beta', 2, 201, 100),
('CryoTank 1', 1, 1, 20),
('CryoTank 1', 1, 2, 20),
('Freezer Gamma', 1, 101, 50),
('Freezer Gamma', 2, 102, 50),
('Freezer Gamma', 3, 103, 50);

-- 5. Insert Biospecimens (10 Biospecimens)
INSERT INTO biospecimens (donor_id, sample_type_id, collection_date, initial_volume_ml, status) VALUES
(1, 1, '2024-01-11', 10.00, 'Available'),
(2, 2, '2024-01-16', 5.00, 'Available'),
(3, 3, '2024-02-02', 2.50, 'Available'),
(5, 1, '2024-02-21', 10.00, 'Available'),
(6, 4, '2024-03-06', 1.00, 'Available'),
(7, 2, '2024-03-13', 5.00, 'Available'),
(9, 3, '2024-04-02', 3.00, 'Available'),
(10, 1, '2024-04-16', 10.00, 'Available'),
(1, 2, '2024-05-01', 5.00, 'Available'),
(2, 3, '2024-05-10', 2.00, 'Available');

-- 6. Insert Aliquots (10 Aliquots)
INSERT INTO aliquots (specimen_id, location_id, volume_ul, concentration_ng_ul, status) VALUES
(1, 1, 500.00, 50.0, 'In Storage'),
(1, 1, 500.00, 50.0, 'In Storage'),
(2, 2, 250.00, 120.0, 'In Storage'),
(3, 3, 100.00, 300.0, 'In Storage'),
(4, 4, 500.00, 45.0, 'In Storage'),
(5, 6, 50.00, 500.0, 'In Storage'),
(6, 5, 250.00, 110.0, 'In Storage'),
(7, 3, 100.00, 280.0, 'In Storage'),
(8, 7, 500.00, 55.0, 'In Storage'),
(9, 8, 250.00, 100.0, 'In Storage');

-- 7. Insert Researchers (10 Researchers)
INSERT INTO researchers (full_name, institution, email, phone) VALUES
('Dr. Ayman Samir', 'Cairo Biotech Lab', 'ayman@cairobiotech.org', '01011112222'),
('Dr. Laila Fouad', 'National Research Center', 'laila@nrc.sci.eg', '01122223333'),
('Prof. Adel Zaki', 'Ain Shams University', 'adel.zaki@asu.edu.eg', '01233334444'),
('Dr. Mona Reda', 'Alexandria Cancer Institute', 'mona.reda@aci.edu.eg', '01044445555'),
('Dr. Hazem Nabil', 'Genomics Arabia', 'hazem@genomicsarabia.com', '01155556666'),
('Dr. Reem El-Sayed', 'Mansoura University', 'reem@mans.edu.eg', '01266667777'),
('Prof. Sherif Taha', 'Zewail City', 'staha@zewailcity.edu.eg', '01077778888'),
('Dr. Rania Mahmoud', 'GUC Research Center', 'rania.mahmoud@guc.edu.eg', '01188889999'),
('Dr. Tarek Yassin', 'Assiut Medical Center', 'tarek@assuit.edu.eg', '01299990000'),
('Dr. Salma Hany', 'Suez Canal University', 'salma.hany@scu.edu.eg', '01000001111');

-- 8. Insert Test Requests (10 Requests)
INSERT INTO test_requests (researcher_id, request_date, status, purpose) VALUES
(1, '2024-05-15', 'Approved', 'PCR Analysis for biomarker discovery'),
(2, '2024-05-18', 'Completed', 'RNA Sequencing'),
(3, '2024-05-20', 'Pending', 'Leukemia Genetic Profiling'),
(4, '2024-05-22', 'Approved', 'Diabetes Risk Analysis'),
(5, '2024-05-25', 'Rejected', 'Commercial Product Testing'),
(6, '2024-06-01', 'Approved', 'Cardiovascular Disease Marker Research'),
(7, '2024-06-03', 'Pending', 'Whole Genome Sequencing'),
(8, '2024-06-05', 'Completed', 'Immune Response Assessment'),
(9, '2024-06-10', 'Approved', 'Stem Cell Line Generation'),
(10, '2024-06-12', 'Pending', 'Epigenetic Modification Analysis');

-- 9. Insert Request Aliquots
INSERT INTO request_aliquots (request_id, aliquot_id, assigned_date) VALUES
(1, 1, '2024-05-16'),
(1, 2, '2024-05-16'),
(2, 3, '2024-05-19'),
(4, 4, '2024-05-23'),
(6, 5, '2024-06-02'),
(8, 6, '2024-06-06'),
(8, 7, '2024-06-06'),
(9, 8, '2024-06-11'),
(1, 9, '2024-05-16'),
(4, 10, '2024-05-23');