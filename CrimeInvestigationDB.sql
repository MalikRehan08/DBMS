-- Create database
CREATE DATABASE IF NOT EXISTS crime_record_management;

-- Use database
USE crime_record_management;

-- Create tables

-- Investigation Teams table
CREATE TABLE IF NOT EXISTS investigation_teams (
  investigation_team_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (investigation_team_id)
);

-- Crime Categories table
CREATE TABLE IF NOT EXISTS crime_categories (
  category_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255) NOT NULL,
  PRIMARY KEY (category_id)
);

-- Victims table
CREATE TABLE IF NOT EXISTS victims (
  victim_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  birthday DATE NOT NULL,
  address VARCHAR(255) NOT NULL,
  phone_number VARCHAR(255) NOT NULL,
  investigation_team_id INT,
  PRIMARY KEY (victim_id),
  FOREIGN KEY (investigation_team_id) REFERENCES investigation_teams (investigation_team_id)
);

-- Suspects table
CREATE TABLE IF NOT EXISTS suspects (
  suspect_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  birthday DATE NOT NULL,
  gender VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  phone_number VARCHAR(255) NOT NULL,
  PRIMARY KEY (suspect_id)
);

-- Officers table
CREATE TABLE IF NOT EXISTS officers (
  officer_badge_number INT NOT NULL AUTO_INCREMENT,
  officer_rank VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  investigation_team_id INT,
  PRIMARY KEY (officer_badge_number),
  FOREIGN KEY (investigation_team_id) REFERENCES investigation_teams (investigation_team_id)
);

-- Crimes table
CREATE TABLE IF NOT EXISTS crimes (
  crime_id INT NOT NULL AUTO_INCREMENT,
  category_id INT NOT NULL,
  investigation_team_id INT NOT NULL,
  date_opened DATE NOT NULL,
  date_closed DATE,
  status ENUM('Open','Closed') NOT NULL,
  location VARCHAR(255) NOT NULL,
  PRIMARY KEY (crime_id),
  FOREIGN KEY (category_id) REFERENCES crime_categories (category_id),
  FOREIGN KEY (investigation_team_id) REFERENCES investigation_teams (investigation_team_id)
);

-- Insert into investigation_teams
INSERT INTO investigation_teams (name)
VALUES
('Alpha Team'),
('Beta Team'),
('Gamma Team'),
('Delta Team'),
('Ruby Team'),
('Aqua Team'),
('Theta Team'),
('Epsilon Team'),
('Omega Team');

-- Crime Categories table
INSERT INTO crime_categories (name, description)
VALUES
('Assault', 'The act of intentionally causing physical harm to another person'),
('Robbery', 'The taking of property from another person by force or threat of force'),
('Burglary', 'The unlawful entry into a building with the intent to commit a crime'),
('Murder', 'The unlawful killing of another human being with malice aforethought'),
('Kidnapping', 'The abduction or unlawful detention of a person'),
('Arson', 'The intentional setting of fire to property'),
('Vandalism', 'The willful destruction or damage of property'),
('Drug Trafficking', 'The illegal production, distribution, or possession of drugs'),
('Cybercrime', 'A crime committed using a computer or network');

-- Victims table
INSERT INTO victims (name, birthday, address, phone_number, investigation_team_id)
VALUES
('John Doe', '2002-11-17', '123 Main Street', '123-456-7890', 1),
('Jane Doe', '1997-05-19', '456 Elm Street', '987-654-3210', 2),
('Peter Parker', '1989-10-07', '789 Park Avenue', '098-765-4321', 3),
('Mary Jane Watson', '1992-05-12', '1011 Queen Street', '101-203-405-6', 4),
('Bruce Banner', '1982-03-18', '1112 Gamma Drive', '555-555-5555', 5),
('Tony Stark', '2000-09-11', '1213 Stark Tower', '888-888-8888', 6),
('Steve Rogers', '1967-02-10', '1314 Avengers Tower', '999-999-9999', 7),
('Thor Odinson', '1979-01-23', '1415 Asgardian Palace', '000-000-0000', 8),
('Natasha Romanoff', '1980-07-27', '1516 Red Room Academy', '111-222-3333', 9);

-- Suspects table
INSERT INTO suspects (name, birthday, gender, address, phone_number)
VALUES
('Green Goblin', '2000-10-19', 'Male', '1234 Oscorp Tower', '555-555-5555'),
('Doctor Octopus', '1987-06-12', 'Male', '5678 Octopus Industries', '888-888-8888'),
('Lizard', '1978-03-25', 'Male', '9012 Sewer System', '999-999-9999'),
('Sandman', '1987-11-30', 'Male', '1113 Beach Street', '000-000-0000'),
('Loki', '1992-05-12', 'Male', '1214 Asgardian Prison', '111-222-3333'),
('Magneto', '1982-04-10', 'Male', '1315 Brotherhood of Mutants Headquarters', '222-333-4444'),
('Ultron', '2001-10-21', 'Male', '1416 Ultron Base', '333-444-5555'),
('Kraven the Hunter', '1996-12-14', 'Male', '1517 Kraven Manor', '444-555-6666'),
('Kingpin', '1978-05-02', 'Male', '1617 Fisk Tower', '555-666-7777');

-- Officers table
INSERT INTO officers (officer_rank, name, investigation_team_id)
VALUES
('Captain', 'George Stacy', 1),
('Detective', 'John Jameson', 2),
('Sergeant', 'Gwen Stacy', 3),
('Patrolman', 'Flash Thompson', 4),
('Sergeant', 'Joe Robertson', 5),
('Investigator', 'Christine Palmer', 6),
('Director', 'Maria Hill', 7),
('Agent', 'Coulson', 8),
('Agent', 'Melinda May', 9);

-- Crimes table
INSERT INTO crimes (category_id, investigation_team_id, date_opened, date_closed, status, location)
VALUES
(1, 1, '2023-11-17', NULL, 'Open', 'Oscorp Tower'),
(2, 2, '2023-11-18', NULL, 'Open', 'Octopus Industries'),
(3, 3, '2023-11-19', NULL, 'Open', 'Sewer System'),
(4, 4, '2023-11-20', NULL, 'Open', 'Beach Street'),
(5, 1, '2023-11-21', '2023-11-22', 'Closed', 'Asgardian Palace'),
(6, 3, '2023-11-22', '2023-11-23', 'Closed', 'Brotherhood of Mutants Headquarters'),
(7, 2, '2023-11-24', '2023-11-25', 'Closed','Ultron Base'),
(8, 4, '2023-11-26', '2023-11-27', 'Closed','Kraven Manor'),
(9, 1, '2023-11-28', NULL, 'Open','Gotham');


-- Crime Victims table
CREATE TABLE IF NOT EXISTS crime_victims (
  crime_id INT NOT NULL,
  victim_id INT NOT NULL,
  PRIMARY KEY (crime_id, victim_id),
  FOREIGN KEY (crime_id) REFERENCES crimes (crime_id),
  FOREIGN KEY (victim_id) REFERENCES victims (victim_id)
);

-- Crime Suspects table
CREATE TABLE IF NOT EXISTS crime_suspects (
  crime_id INT NOT NULL,
  suspect_id INT NOT NULL,
  PRIMARY KEY (crime_id, suspect_id),
  FOREIGN KEY (crime_id) REFERENCES crimes (crime_id),
  FOREIGN KEY (suspect_id) REFERENCES suspects (suspect_id)
);

-- Insert into crime_victims
INSERT INTO crime_victims (crime_id, victim_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9);

-- Insert into crime_suspects
INSERT INTO crime_suspects (crime_id, suspect_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9);

--Trigger
DELIMITER //
CREATE TRIGGER update_status
BEFORE INSERT ON crimes
FOR EACH ROW
BEGIN
    IF NEW.date_closed IS NOT NULL THEN
        SET NEW.status = 'Closed';
    ELSE
        SET NEW.status = 'Open';
    END IF;
END;
//

 -- Function
 -- SQL Function: calculate_average_victim_age
DELIMITER //
CREATE FUNCTION calculate_average_victim_age(category_name VARCHAR(255))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_age DECIMAL(10, 2) DEFAULT 0;
    DECLARE victim_count INT DEFAULT 0;
    DECLARE average_age DECIMAL(10, 2) DEFAULT 0;

    -- Get the total age and count of victims for the specified category
    SELECT 
        SUM(YEAR(CURDATE()) - YEAR(v.birthday)),
        COUNT(*)
    INTO 
        total_age, victim_count
    FROM 
        crime_victims cv
    JOIN 
        victims v ON cv.victim_id = v.victim_id
    JOIN 
        crimes c ON cv.crime_id = c.crime_id
    JOIN 
        crime_categories cc ON c.category_id = cc.category_id
    WHERE 
        cc.name = category_name;

    -- Calculate the average age, avoiding division by zero
    IF victim_count > 0 THEN
        SET average_age = total_age / victim_count;
    END IF;

    RETURN average_age;
END;
//

--This JOIN query retrieves information about crimes, including details about the crime category, investigation team, victims, and suspects. It uses various JOINs to connect the related tables.
SELECT 
    crimes.crime_id,
    crimes.category_id,
    crime_categories.name AS crime_category,
    crimes.investigation_team_id,
    investigation_teams.name AS investigation_team,
    crimes.date_opened,
    crimes.date_closed,
    crimes.location,
    crimes.status,
    GROUP_CONCAT(DISTINCT victims.name SEPARATOR ', ') AS victim_names,
    GROUP_CONCAT(DISTINCT suspects.name SEPARATOR ', ') AS suspect_names
FROM 
    crimes
JOIN 
    crime_categories ON crimes.category_id = crime_categories.category_id
JOIN 
    investigation_teams ON crimes.investigation_team_id = investigation_teams.investigation_team_id
LEFT JOIN 
    crime_victims ON crimes.crime_id = crime_victims.crime_id
LEFT JOIN 
    victims ON crime_victims.victim_id = victims.victim_id
LEFT JOIN 
    crime_suspects ON crimes.crime_id = crime_suspects.crime_id
LEFT JOIN 
    suspects ON crime_suspects.suspect_id = suspects.suspect_id
GROUP BY 
    crimes.crime_id;

--aggregate query to calculate the total number of crimes for each category:
SELECT 
    crime_categories.name AS crime_category,
    COUNT(crimes.crime_id) AS total_crimes
FROM 
    crimes
JOIN 
    crime_categories ON crimes.category_id = crime_categories.category_id
GROUP BY 
    crime_categories.name;

--nested query to retrieve crimes where the average age of victims is greater than a certain threshold:
--This query retrieves crimes where the average age of victims is greater than 30.
SELECT 
    crimes.crime_id,
    crimes.location,
    crimes.date_opened,
    crimes.date_closed,
    crimes.status
FROM 
    crimes
WHERE 
    (
        SELECT AVG(YEAR(CURDATE()) - YEAR(v.birthday))
        FROM 
            crime_victims cv
        JOIN 
            victims v ON cv.victim_id = v.victim_id
        WHERE 
            cv.crime_id = crimes.crime_id
    ) > 30;

-- Create two roles
CREATE ROLE 'investigator_role';
CREATE ROLE 'admin_role';

-- Grant privileges to the 'investigator_role'
GRANT SELECT, INSERT, UPDATE ON crime_record_management.* TO 'investigator_role';

-- Grant privileges to the 'admin_role'
GRANT ALL PRIVILEGES ON crime_record_management.* TO 'admin_role';

-- Create users and assign roles
CREATE USER 'investigator_user'@'localhost' IDENTIFIED BY 'investigator_password';
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_password';

-- Assign roles to users
GRANT 'investigator_role' TO 'investigator_user'@'localhost';
GRANT 'admin_role' TO 'admin_user'@'localhost';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;
