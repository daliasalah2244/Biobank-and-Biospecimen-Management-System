-- Create and use Biobank Database
DROP DATABASE IF EXISTS BiobankDB;
CREATE DATABASE BiobankDB;
USE BiobankDB;

-- 1. Donors Table
CREATE TABLE donors (
    donor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Consents Table
CREATE TABLE consents (
    consent_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    consent_type VARCHAR(100) NOT NULL,
    status ENUM('Active', 'Revoked', 'Expired') DEFAULT 'Active',
    signed_date DATE NOT NULL,
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE
);

-- 3. Sample Types Lookup Table
CREATE TABLE sample_types (
    sample_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    storage_temp_celsius DECIMAL(5,2) NOT NULL
);

-- 4. Storage Locations Table
CREATE TABLE storage_locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    freezer_name VARCHAR(50) NOT NULL,
    shelf_number INT NOT NULL,
    box_number INT NOT NULL,
    capacity INT DEFAULT 100
);

-- 5. Biospecimens Table
CREATE TABLE biospecimens (
    specimen_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    sample_type_id INT NOT NULL,
    collection_date DATE NOT NULL,
    initial_volume_ml DECIMAL(8,2) NOT NULL,
    status ENUM('Available', 'Depleted', 'Discarded') DEFAULT 'Available',
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (sample_type_id) REFERENCES sample_types(sample_type_id)
);

-- 6. Aliquots Table
CREATE TABLE aliquots (
    aliquot_id INT AUTO_INCREMENT PRIMARY KEY,
    specimen_id INT NOT NULL,
    location_id INT NOT NULL,
    volume_ul DECIMAL(8,2) NOT NULL,
    concentration_ng_ul DECIMAL(8,2),
    status ENUM('In Storage', 'Reserved', 'Used', 'Thawed') DEFAULT 'In Storage',
    FOREIGN KEY (specimen_id) REFERENCES biospecimens(specimen_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES storage_locations(location_id)
);

-- 7. Researchers Table
CREATE TABLE researchers (
    researcher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    institution VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

-- 8. Test Requests Table
CREATE TABLE test_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    researcher_id INT NOT NULL,
    request_date DATE NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected', 'Completed') DEFAULT 'Pending',
    purpose TEXT NOT NULL,
    FOREIGN KEY (researcher_id) REFERENCES researchers(researcher_id)
);

-- 9. Request Aliquots (Associative Table for M:N Relationship)
CREATE TABLE request_aliquots (
    request_id INT NOT NULL,
    aliquot_id INT NOT NULL,
    assigned_date DATE NOT NULL,
    PRIMARY KEY (request_id, aliquot_id),
    FOREIGN KEY (request_id) REFERENCES test_requests(request_id) ON DELETE CASCADE,
    FOREIGN KEY (aliquot_id) REFERENCES aliquots(aliquot_id)
);

-- Indexes for performance optimization
CREATE INDEX idx_donor_email ON donors(email);
CREATE INDEX idx_specimen_collection ON biospecimens(collection_date);
CREATE INDEX idx_aliquot_status ON aliquots(status);