USE sql_queries_beyoncengina;

-- 1. RESET TABLES
DROP TABLE IF EXISTS leases; 
DROP TABLE IF EXISTS units; 
DROP TABLE IF EXISTS properties; 
DROP TABLE IF EXISTS tenants; 
DROP TABLE IF EXISTS locations;

-- 2. CREATE TABLES
CREATE TABLE locations (id INT PRIMARY KEY, name VARCHAR(100));
CREATE TABLE properties (id INT PRIMARY KEY, name VARCHAR(100), location_id INT);
CREATE TABLE units (id INT PRIMARY KEY, property_id INT, name VARCHAR(50), size DECIMAL(10,2));
CREATE TABLE tenants (id INT PRIMARY KEY, name VARCHAR(100), email VARCHAR(100));
CREATE TABLE leases (id INT PRIMARY KEY, unit_id INT, tenant_id INT, rent_per_month DECIMAL(10,2), arrears DECIMAL(10,2), start_date DATE, end_date DATE, annual_rent DECIMAL(15,2), lease_duration_months INT, valid_lease INT, lease_status VARCHAR(50));

-- 3. INSERT DATA (Locations)
INSERT INTO locations VALUES (1, 'Nairobi Cbd');
INSERT INTO locations VALUES (2, 'Westlands');
INSERT INTO locations VALUES (3, 'Kilimani');

-- 4. INSERT DATA (Properties)
INSERT INTO properties VALUES (1, 'NSSF Towers', 1);
INSERT INTO properties VALUES (2, 'Delta Corner', 2);
INSERT INTO properties VALUES (3, 'The Junction Residences', 3);
INSERT INTO properties VALUES (4, 'Riverside Court', 2);
INSERT INTO properties VALUES (5, 'Kimathi House', 1);

-- 5. INSERT DATA (Units)
INSERT INTO units VALUES (1, 1, 'A-101', 75.0), (2, 1, 'A-102', 80.5), (3, 1, 'B-201', 65.0), (4, 1, 'B-202', 92.0), (5, 1, 'C-301', 120.0);
INSERT INTO units VALUES (6, 2, 'DC-1A', 55.0), (7, 2, 'DC-1B', 60.0), (8, 2, 'DC-2A', 85.0), (9, 2, 'DC-2B', 100.0), (10, 2, 'DC-3A', 73.5);
INSERT INTO units VALUES (11, 3, 'JR-101', 48.0), (12, 3, 'JR-102', 52.0), (13, 3, 'JR-201', 66.0), (14, 3, 'JR-202', 70.0);
INSERT INTO units VALUES (15, 4, 'RC-1A', 64.5), (16, 4, 'RC-1B', 68.0), (17, 4, 'RC-2A', 90.0), (18, 5, 'KH-101', 40.0), (19, 5, 'KH-201', 58.0), (20, 5, 'KH-301', 77.0);

-- 6. INSERT DATA (Tenants)
INSERT INTO tenants VALUES (1, 'Amina Mwangi', 'amina.mwangi@example.com'), (2, 'Brian Otieno', 'brian.otieno@example.com'), (3, 'Carol Wanjiru', 'carol.wanjiru@example.com'), (4, 'David Kiptoo', 'david.kiptoo@example.com'), (5, 'Eunice Njeri', 'eunice.njeri@example.com'), (6, 'Farah Hassan', 'farah.hassan@example.com'), (7, 'George Ouma', 'george.ouma@example.com'), (8, 'Hannah Achieng', 'hannah.achieng@example.com'), (9, 'Ian Wachira', 'ian.wachira@example.com'), (10, 'Joy Wambui', 'joy.wambui@example.com'), (11, 'Kelvin Muli', 'kelvin.muli@example.com'), (12, 'Lydia Chebet', 'lydia.chebet@example.com'), (13, 'Mark Ndungu', 'mark.ndungu@example.com'), (14, 'Naomi Nyawira', NULL), (15, 'Oscar Owino', 'oscar.owino@example.com');

-- 7. INSERT DATA (Leases)
INSERT INTO leases VALUES (1, 1, 1, 45000, 0, '2024-01-01', NULL, 540000, 24, 1, 'ongoing');
INSERT INTO leases VALUES (2, 2, 2, 55000, 5000, '2023-11-01', '2024-10-31', 660000, 12, 1, 'expired');
INSERT INTO leases VALUES (3, 3, 3, 65000, -2000, '2024-02-01', NULL, 780000, 23, 1, 'ongoing');
INSERT INTO leases VALUES (4, 4, 4, 30000, 1000, '2024-03-01', NULL, 360000, 22, 1, 'ongoing');
INSERT INTO leases VALUES (5, 5, 3, 70000, 0, '2025-02-01', '2025-12-31', 840000, 11, 1, 'expired');
INSERT INTO leases VALUES (6, 6, 5, 40000, 8000, '2024-06-15', '2025-06-14', 480000, 12, 1, 'expired');
INSERT INTO leases VALUES (7, 7, 6, 52000, 0, '2024-08-01', '2024-07-31', 624000, 0, 0, 'invalid');
INSERT INTO leases VALUES (8, 8, 7, 38000, 12000, '2023-09-01', NULL, 456000, 28, 1, 'ongoing');
INSERT INTO leases VALUES (9, 9, 8, 60000, 0, '2025-01-01', NULL, 720000, 12, 1, 'ongoing');
INSERT INTO leases VALUES (10, 10, 2, 45000, 1000, '2024-02-01', '2024-12-31', 540000, 11, 1, 'expired');
INSERT INTO leases VALUES (11, 11, 9, 31000, 0, '2023-05-01', '2024-04-30', 372000, 12, 1, 'expired');
INSERT INTO leases VALUES (12, 12, 10, 47000, 3000, '2024-10-01', '2025-09-30', 564000, 12, 1, 'expired');

-- 1. Properties with occupancy below 80%
SELECT p.name, (COUNT(le.id) * 100.0 / COUNT(u.id)) AS occupancy_rate
FROM properties p
JOIN units u ON p.id = u.property_id
LEFT JOIN leases le ON u.id = le.unit_id AND (le.end_date IS NULL OR le.end_date > '2025-01-01')
GROUP BY p.id, p.name
HAVING occupancy_rate < 80;

-- 2. Total arrears per location
SELECT l.name, SUM(le.arrears) AS total_arrears
FROM leases le
JOIN units u ON le.unit_id = u.id
JOIN properties p ON u.property_id = p.id
JOIN locations l ON p.location_id = l.id
GROUP BY l.name;

-- 3. Top 3 properties by collection efficiency
SELECT p.name, 
       ROUND(SUM(le.rent_per_month - le.arrears) / SUM(le.rent_per_month) * 100, 2) AS efficiency
FROM leases le
JOIN units u ON le.unit_id = u.id
JOIN properties p ON u.property_id = p.id
GROUP BY p.id, p.name
ORDER BY efficiency DESC
LIMIT 3;

-- 4. Invalid leases (Negative rent or end date before start date)
SELECT * FROM leases WHERE rent_per_month < 0 OR end_date < start_date;

-- 5. Tenants with 2 or more units
SELECT t.name, COUNT(le.unit_id) AS unit_count
FROM tenants t
JOIN leases le ON t.id = le.tenant_id
GROUP BY t.id, t.name
HAVING unit_count >= 2;