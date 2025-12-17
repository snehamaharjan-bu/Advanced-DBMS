-- Iteration 4: Creating sequences and tables
-- ----------------------------------------------------------
-- DROP SEQUENCES (to make code rerunnable)
-- ----------------------------------------------------------
DROP SEQUENCE IF EXISTS user_id CASCADE;
DROP SEQUENCE IF EXISTS gym_id CASCADE;
DROP SEQUENCE IF EXISTS gymclasstype_id CASCADE;
DROP SEQUENCE IF EXISTS classtype_id CASCADE;
DROP SEQUENCE IF EXISTS shop_id CASCADE;
DROP SEQUENCE IF EXISTS credit_id CASCADE;
DROP SEQUENCE IF EXISTS workout_id CASCADE;
DROP SEQUENCE IF EXISTS workouttype_id CASCADE;
DROP SEQUENCE IF EXISTS riskmetric_id CASCADE;
DROP SEQUENCE IF EXISTS frequencytype_id CASCADE;
DROP SEQUENCE IF EXISTS hydrationmetric_id CASCADE;
DROP SEQUENCE IF EXISTS hydrationupdate_id CASCADE;

------------------------------------------------------------
-- DROP TABLES (to make code rerunnable)
------------------------------------------------------------
DROP TABLE IF EXISTS AppUser CASCADE;
DROP TABLE IF EXISTS HealthRiskMetric CASCADE;
DROP TABLE IF EXISTS FrequencyType CASCADE;
DROP TABLE IF EXISTS Workout CASCADE;
DROP TABLE IF EXISTS WorkoutType CASCADE;
DROP TABLE IF EXISTS HydrationMetric CASCADE;
DROP TABLE IF EXISTS Credit CASCADE;
DROP TABLE IF EXISTS GymClass CASCADE;
DROP TABLE IF EXISTS GymClassType CASCADE;
DROP TABLE IF EXISTS Gym CASCADE;
DROP TABLE IF EXISTS ClassType CASCADE;
DROP TABLE IF EXISTS GiftCard CASCADE;
DROP TABLE IF EXISTS Shop CASCADE;
DROP TABLE IF EXISTS HydrationIntakeUpdate CASCADE;

------------------------------------------------------------
-- CREATE THE SEQUENCES
------------------------------------------------------------
CREATE SEQUENCE user_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE gym_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE gymclasstype_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE classtype_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE shop_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE credit_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE workout_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE workouttype_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE riskmetric_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE frequencytype_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE hydrationmetric_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE hydrationupdate_id START WITH 1 INCREMENT BY 1;

------------------------------------------------------------
-- APPUSER TABLE
------------------------------------------------------------
CREATE TABLE AppUser (
    UserID INT PRIMARY KEY DEFAULT NEXTVAL('user_id'),
    PasswordHash VARCHAR(255) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Height DECIMAL(5,2) NOT NULL,
    Weight DECIMAL(5,2) NOT NULL,
    Sex VARCHAR(10) NOT NULL,
    Name VARCHAR(200) NOT NULL,
    ZipCode VARCHAR(10) NOT NULL,
    UserType VARCHAR(10) NOT NULL
);


------------------------------------------------------------
-- GYM TABLE
------------------------------------------------------------
CREATE TABLE Gym (
    GymID INT PRIMARY KEY DEFAULT NEXTVAL('gym_id'),
    GymName VARCHAR(50) NOT NULL,
    StreetAddress VARCHAR(300) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State CHAR(2) NOT NULL,
    ZipCode VARCHAR(10) NOT NULL
);

------------------------------------------------------------
-- CLASS TYPE TABLE (classes offered at each gym)
------------------------------------------------------------
CREATE TABLE ClassType (
    ClassTypeID SMALLINT PRIMARY KEY DEFAULT NEXTVAL('classtype_id'),
    ClassName VARCHAR(50) NOT NULL
);

------------------------------------------------------------
-- GYMCLASSTYPE 
------------------------------------------------------------
CREATE TABLE GymClassType (
    GymClassTypeID INT PRIMARY KEY DEFAULT NEXTVAL('gymclasstype_id'),
    ClassTypeID SMALLINT NOT NULL,
    GymID INT NOT NULL,
    FOREIGN KEY (ClassTypeID) REFERENCES ClassType(ClassTypeID),
    FOREIGN KEY (GymID) REFERENCES Gym(GymID)
);

------------------------------------------------------------
-- CREDIT TABLE
------------------------------------------------------------
CREATE TABLE Credit (
    CreditID INT PRIMARY KEY DEFAULT NEXTVAL('credit_id'),
    SenderUserID INT NOT NULL,
    ReceiverUserID INT NOT NULL,
    CreditType VARCHAR(5) NOT NULL, -- Class or Card
    Redeemed BOOLEAN DEFAULT FALSE,
    ExpirationDate DATE NOT NULL,
    FOREIGN KEY (SenderUserID) REFERENCES AppUser(UserID),
    FOREIGN KEY (ReceiverUserID) REFERENCES AppUser(UserID)
);

------------------------------------------------------------
-- GYMCLASS (mapping credit to gym class type)
------------------------------------------------------------
CREATE TABLE GymClass (
    CreditID INT PRIMARY KEY,
    GymClassTypeID INT NOT NULL,
    FOREIGN KEY (CreditID) REFERENCES Credit(CreditID),
    FOREIGN KEY (GymClassTypeID) REFERENCES GymClassType(GymClassTypeID)
);


------------------------------------------------------------
-- SHOP table for gift card 
------------------------------------------------------------
CREATE TABLE Shop (
    ShopID INT PRIMARY KEY DEFAULT NEXTVAL('shop_id'),
    ShopName VARCHAR(50) NOT NULL
);

------------------------------------------------------------
-- GIFT CARD TABLE
------------------------------------------------------------
CREATE TABLE GiftCard (
    CreditID INT PRIMARY KEY,
    ShopID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CreditID) REFERENCES Credit(CreditID),
    FOREIGN KEY (ShopID) REFERENCES Shop(ShopID)
);


------------------------------------------------------------
-- WORKOUT TYPE TABLE to map different workout types
------------------------------------------------------------
CREATE TABLE WorkoutType (
    WorkoutTypeID SMALLINT PRIMARY KEY DEFAULT NEXTVAL('workouttype_id'),
    WorkoutName VARCHAR(50) NOT NULL
);


------------------------------------------------------------
-- WORKOUT TABLE
------------------------------------------------------------
CREATE TABLE Workout (
    WorkoutID INT PRIMARY KEY DEFAULT NEXTVAL('workout_id'),
    UserID INT NOT NULL,
    WorkoutTypeID SMALLINT NOT NULL,
    DurationMins INT NOT NULL,
    CaloriesBurned INT,
	StartTime TIMESTAMP NOT NULL,
	EndTime TIMESTAMP,
	AverageHeartRate SMALLINT,
	MaxHeartRate SMALLINT,
	DistanceKm DECIMAL(10,2),
    FOREIGN KEY (UserID) REFERENCES AppUser(UserID),
    FOREIGN KEY (WorkoutTypeID) REFERENCES WorkoutType(WorkoutTypeID)
);


------------------------------------------------------------
-- FREQUENCY TYPE TABLE for smoking and alchohol frequency options
------------------------------------------------------------
CREATE TABLE FrequencyType (
    FrequencyTypeID SMALLINT PRIMARY KEY DEFAULT NEXTVAL('frequencytype_id'),
    FrequencyName VARCHAR(50) NOT NULL
);

------------------------------------------------------------
-- HEALTH RISK METRIC TABLE - doctor has to fill out information based on regular health checkup
------------------------------------------------------------
CREATE TABLE HealthRiskMetric (
    RiskMetricID INT PRIMARY KEY DEFAULT NEXTVAL('riskmetric_id'),
    UserID INT NOT NULL,
	SmokingFrequencyID SMALLINT,
    AlcoholFrequencyID SMALLINT,
    SystolicBloodPressure SMALLINT,
    DiastolicBloodPressure SMALLINT,
    CholesterolTotal SMALLINT,
    LDL SMALLINT,
    HDL SMALLINT,
    Triglycerides SMALLINT,
    MetricDate TIMESTAMP NOT NULL,
    FOREIGN KEY (UserID) REFERENCES AppUser(UserID),
    FOREIGN KEY (SmokingFrequencyID) REFERENCES FrequencyType(FrequencyTypeID),
    FOREIGN KEY (AlcoholFrequencyID) REFERENCES FrequencyType(FrequencyTypeID)
);


------------------------------------------------------------
-- HYDRATION METRIC TABLE
------------------------------------------------------------
CREATE TABLE HydrationMetric (
    HydrationMetricID INT PRIMARY KEY DEFAULT NEXTVAL('hydrationmetric_id'),
    UserID INT NOT NULL,
    Temperature DECIMAL(5,1) NOT NULL,
	LastUpdated TIMESTAMP NOT NULL,
	CurrentDayIntakeML INT NOT NULL,
	DailyWaterGoalML INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES AppUser(UserID)
);

------------------------------------------------------------
-- HYDRATION HISTORY TABLE
------------------------------------------------------------
CREATE TABLE HydrationIntakeUpdate (
    HydrationIntakeUpdateID INT PRIMARY KEY DEFAULT NEXTVAL('hydrationupdate_id'),
	HydrationMetricID INT NOT NULL,
    OldIntakeML INT NOT NULL,
    NewIntakeML INT NOT NULL,
    InsertionDate TIMESTAMP NOT NULL,
    FOREIGN KEY (HydrationMetricID) REFERENCES HydrationMetric(HydrationMetricID)
);

-- ----------------------------------------------------------
-- Iteration 5: 
-- ----------------------------------------------------------
-- Step 10 A: Transaction 1
-- ----------------------------------------------------------


CREATE OR REPLACE PROCEDURE AddUserWorkout(
    p_password VARCHAR(255),
    p_email VARCHAR(100),
    p_dob DATE,
    p_height DECIMAL(5,2),
    p_weight DECIMAL(5,2),
    p_sex VARCHAR(10),
    p_name VARCHAR(200),
    p_zip VARCHAR(10),
    p_usertype VARCHAR(10),
    p_durationmins INT,
    p_caloriesburned INT,
    p_starttime TIMESTAMP,
    p_endtime TIMESTAMP,
    p_averageheartrate SMALLINT,
    p_maxheartrate SMALLINT,
    p_distance DECIMAL(10,2),
    p_workoutname VARCHAR(50)
)
LANGUAGE plpgsql
AS $proc$
DECLARE
    v_userid INT;
    v_workouttypeid SMALLINT;
BEGIN
    ------------------------------------------------------------------
    -- STEP 1- INSERT NEW APP USER
    ------------------------------------------------------------------
	SELECT UserID INTO v_userid
    FROM AppUser
    WHERE Name = p_name;
	
	IF v_userid IS NULL THEN
	    INSERT INTO AppUser(
	        UserID,
	        PasswordHash,
	        Email,
	        DateOfBirth,
	        Height,
	        Weight,
	        Sex,
	        Name,
	        ZipCode,
	        UserType
	    )
	    VALUES(
	        nextval('user_id'),
	        p_password,
	        p_email,
	        p_dob,
	        p_height,
	        p_weight,
	        p_sex,
	        p_name,
	        p_zip,
	        p_usertype
	    )
	    RETURNING UserID INTO v_userid;
	END IF;

    ------------------------------------------------------------------
    -- STEP 2- INSERT WORKOUT TYPE (if new)
    ------------------------------------------------------------------
    SELECT WorkoutTypeID INTO v_workouttypeid
    FROM WorkoutType
    WHERE WorkoutName = p_workoutname;

    IF v_workouttypeid IS NULL THEN
        INSERT INTO WorkoutType(
            WorkoutTypeID,
            WorkoutName
        )
        VALUES(
            nextval('workouttype_id'),
            p_workoutname
        )
        RETURNING WorkoutTypeID INTO v_workouttypeid;
    END IF;

    ------------------------------------------------------------------
    -- STEP 3- INSERT WORKOUT INSTANCE
    ------------------------------------------------------------------
    INSERT INTO Workout(
        WorkoutID,
        UserID,
        WorkoutTypeID,
        DurationMins,
        CaloriesBurned,
        StartTime,
        EndTime,
        AverageHeartRate,
        MaxHeartRate,
        DistanceKm
    )
    VALUES(
        nextval('workout_id'),
        v_userid,
        v_workouttypeid,
        p_durationmins,
        p_caloriesburned,
        p_starttime,
        p_endtime,
        (p_averageheartrate),
        (p_maxheartrate),
        (p_distance)
    );
END;
$proc$;



START TRANSACTION;
CALL AddUserWorkout(
	'PERG22421@#@$14',
	'mandez.journey@gmail.com',
	'1996-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Jinny Mandez',
	'02342-9921',
	'Beginner',
	45,
	450,
	'2025-12-01 12:05:00'::TIMESTAMP,
	'2025-12-01 12:50:00'::TIMESTAMP,
	125::SMALLINT,
	165::SMALLINT,
	4.12,
	'Jogging'
);

COMMIT;

SELECT * FROM AppUser;
SELECT * FROM WorkoutType;
SELECT * FROM Workout;

-- ----------------------------------------------------------
-- Step 10 B: Transaction 2
-- ----------------------------------------------------------

CREATE OR REPLACE PROCEDURE AddCreditReward(
    p_senderuserid INT,
    p_receiveruserid INT,
    p_credittype VARCHAR(5),    
	p_redeemed BOOLEAN,
    p_expirationdate DATE,
    p_classname VARCHAR(100),
    p_gymname VARCHAR(200),
    p_streetaddress VARCHAR(300),
	p_city VARCHAR(50),
	p_state CHAR(2),
	p_zipcode VARCHAR(10),
    p_shopname VARCHAR(200),
    p_amount DECIMAL(10,2),
	p_password_sender VARCHAR(255),
    p_email_sender VARCHAR(100),
    p_dob_sender DATE,
    p_height_sender DECIMAL(5,2),
    p_weight_sender DECIMAL(5,2),
    p_sex_sender VARCHAR(10),
    p_name_sender VARCHAR(200),
    p_zip_sender VARCHAR(10),
    p_usertype_sender VARCHAR(10),
	p_password_receiver VARCHAR(255),
    p_email_receiver VARCHAR(100),
    p_dob_receiver DATE,
    p_height_receiver DECIMAL(5,2),
    p_weight_receiver DECIMAL(5,2),
    p_sex_receiver VARCHAR(10),
    p_name_receiver VARCHAR(200),
    p_zip_receiver VARCHAR(10),
    p_usertype_receiver VARCHAR(10)
)
LANGUAGE plpgsql
AS $proc$
DECLARE
    v_creditid INT;
	v_gymclasstypeid INT;
    v_classtypeid INT;
    v_gymid INT;
    v_shopid INT;
	v_senderid INT;
	v_receiverid INT;
BEGIN

	-- Step 1- Checking if sender exists
	SELECT UserID INTO v_senderid
	FROM AppUser WHERE UserID = p_senderuserid;
	
	IF v_senderid IS NULL THEN
		INSERT INTO AppUser(
	        UserID,
	        PasswordHash,
	        Email,
	        DateOfBirth,
	        Height,
	        Weight,
	        Sex,
	        Name,
	        ZipCode,
	        UserType
	    )
	    VALUES(
	        nextval('user_id'),
	        p_password_sender,
	        p_email_sender,
	        p_dob_sender,
	        p_height_sender,
	        p_weight_sender,
	        p_sex_sender,
	        p_name_sender,
	        p_zip_sender,
	        p_usertype_sender
	    )
	    RETURNING UserID INTO v_senderid;
	END IF;

	-- Step 2- Checking if receiver exists
	SELECT UserID INTO v_receiverid
	FROM AppUser WHERE UserID = p_receiveruserid;
	
	IF v_receiverid IS NULL THEN
	    INSERT INTO AppUser(
	        UserID,
	        PasswordHash,
	        Email,
	        DateOfBirth,
	        Height,
	        Weight,
	        Sex,
	        Name,
	        ZipCode,
	        UserType
	    )
	    VALUES(
	        nextval('user_id'),
	        p_password_receiver,
	        p_email_receiver,
	        p_dob_receiver,
	        p_height_receiver,
	        p_weight_receiver,
	        p_sex_receiver,
	        p_name_receiver,
	        p_zip_receiver,
	        p_usertype_receiver
	    )
	    RETURNING UserID INTO v_receiverid;
	END IF;

    ------------------------------------------------------------------
    -- STEP 3 - INSERT CREDIT
    ------------------------------------------------------------------
    INSERT INTO Credit(
        CreditID,
        SenderUserID,
        ReceiverUserID,
        CreditType,
        Redeemed,
        ExpirationDate
    )
    VALUES(
        nextval('credit_id'),
        v_senderid,
        v_receiverid,
        p_credittype,
        p_redeemed,
        p_expirationdate
    )
    RETURNING CreditID INTO v_creditid;

    ------------------------------------------------------------------
    -- STEP 4- GYM CLASS CREDIT
    ------------------------------------------------------------------
    IF p_credittype = 'Class' THEN
        
        SELECT ClassTypeID INTO v_classtypeid
        FROM ClassType
        WHERE ClassName = p_classname;

        IF v_classtypeid IS NULL THEN
            INSERT INTO ClassType(ClassTypeID, ClassName)
            VALUES (nextval('classtype_id'), p_classname)
            RETURNING ClassTypeID INTO v_classtypeid;
        END IF;

        SELECT GymID INTO v_gymid
        FROM Gym
        WHERE GymName = p_gymname;

        IF v_gymid IS NULL THEN
            INSERT INTO Gym(GymID, GymName, StreetAddress, City, State, ZipCode)
            VALUES(nextval('gym_id'), p_gymname, p_streetaddress, p_city, p_state, p_zipcode)
            RETURNING GymID INTO v_gymid;
        END IF;

        SELECT GymClassTypeID INTO v_gymclasstypeid
        FROM GymClassType
        WHERE ClassTypeID = v_gymclasstypeid AND GymID = v_gymid;

        IF v_gymclasstypeid IS NULL THEN
            INSERT INTO GymClassType(GymClassTypeID, ClassTypeID, GymID)
            VALUES(nextval('gymclasstype_id'), v_classtypeid, v_gymid)
            RETURNING GymClassTypeID INTO v_gymclasstypeid;
        END IF;

        INSERT INTO GymClass(CreditID, GymClassTypeID)
        VALUES(v_creditid, v_gymclasstypeid);

    END IF;

    ------------------------------------------------------------------
    -- STEP 5- IF GIFT CARD CREDIT
    ------------------------------------------------------------------
    IF p_credittype = 'Card' THEN
        
        SELECT ShopID INTO v_shopid
        FROM Shop
        WHERE ShopName = p_shopname;

        IF v_shopid IS NULL THEN
            INSERT INTO Shop(ShopID, ShopName)
            VALUES(nextval('shop_id'), p_shopname)
            RETURNING ShopID INTO v_shopid;
        END IF;

        INSERT INTO GiftCard(CreditID, ShopID, Amount)
        VALUES(v_creditid, v_shopid, p_amount);

    END IF;

END;
$proc$;


-- Executing the sproc
START TRANSACTION;

CALL AddCreditReward(
    108,
	104,
	'Class',
	FALSE,
	'2025-12-01'::DATE,
	'Yoga',
	'Bars and Bells',
	'239 Brenton St',
	'Franconia',
	'NH',
	'03213-5352',
	NULL,
	NULL,
	'REGE231@#@$14',
	'harrington.smiles@gmail.com',
	'1991-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Emilia Harrington',
	'02342-9921',
	'Beginner',
	'REG32E231@#@$14',
	'antonio.family@gmail.com',
	'1998-06-11'::DATE,
    200.01,
	190.58,
	'Male',
	'Antonio Mandez',
	'02342-9921',
	'Beginner'
);

COMMIT;

SELECT * FROM Credit;
SELECT * FROM GymClass;
SELECT * FROM GymClassType;
SELECT * FROM ClassType;
SELECT * FROM Gym;
SELECT * FROM GiftCard;
SELECT * FROM Shop;


--  ------------------------------------------------------------------
-- Step 11A: Query 1
--  ------------------------------------------------------------------

-- adding new users and their workouts
START TRANSACTION;
CALL AddUserWorkout(
	'REGE231@#42',
	'jemma.journey@gmail.com',
	'1990-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Jemma Longheart',
	'02342-9921',
	'Beginner',
	60,
	600,
	'2025-12-01 12:05:00'::TIMESTAMP,
	'2025-12-01 13:05:00'::TIMESTAMP,
	125::SMALLINT,
	165::SMALLINT,
	4.12,
	'Running'
);

COMMIT;


START TRANSACTION;
CALL AddUserWorkout(
	'REGE231@#42',
	'courtney.journey@gmail.com',
	'1990-05-11'::DATE,
    200.01,
	190.58,
	'Female',
	'Courtney Longheart',
	'02342-9921',
	'Beginner',
	60,
	600,
	'2025-12-01 12:05:00'::TIMESTAMP,
	'2025-12-01 13:05:00'::TIMESTAMP,
	125::SMALLINT,
	165::SMALLINT,
	4.12,
	'Jogging'
);

COMMIT;


START TRANSACTION;
CALL AddUserWorkout(
	'REGE231@#42',
	'healthy.journey@gmail.com',
	'2001-05-11'::DATE,
    200.01,
	190.58,
	'Male',
	'George Healthy',
	'02342-9921',
	'Beginner',
	50,
	560,
	'2025-08-01 12:05:00'::TIMESTAMP,
	'2025-08-01 12:55:00'::TIMESTAMP,
	125::SMALLINT,
	165::SMALLINT,
	4.12,
	'Yoga'
);

COMMIT;

SELECT * FROM AppUser;

-- we need inserts into the frequency and healthriskmetric tables

INSERT INTO FrequencyType (FrequencyName)
VALUES
    ('Never'),
    ('Occasionally'),
    ('Weekly'),
    ('Daily'),
    ('Frequently');


INSERT INTO HealthRiskMetric (
    UserID,
    SmokingFrequencyID,
    AlcoholFrequencyID,
    SystolicBloodPressure,
    DiastolicBloodPressure,
    CholesterolTotal,
    LDL,
    HDL,
    Triglycerides,
    MetricDate
)
VALUES
    -- healthy reading
    (2, 1, 2, 118, 76, 165, 90, 55, 120, NOW()),

    -- mildly elevated BP
    (5, 2, 3, 132, 84, 190, 120, 45, 160, NOW() - INTERVAL '30 days'),

    -- higher risk reading
    (6, 3, 4, 148, 92, 220, 150, 40, 200,NOW() - INTERVAL '60 days');

-- Running query 1

SELECT 
    u.UserID,
    u.Name AS UserName,
    wt.WorkoutName,
    hm.SystolicBloodPressure,
    hm.DiastolicBloodPressure
FROM AppUser u
JOIN Workout w
    ON w.UserID = u.UserID
JOIN WorkoutType wt
    ON wt.WorkoutTypeID = w.WorkoutTypeID
JOIN HealthRiskMetric hm
    ON hm.UserID = u.UserID
WHERE hm.SystolicBloodPressure>=130 
  AND hm.DiastolicBloodPressure>=80;

--  ------------------------------------------------------------------
-- Step 11B: Query 2
--  ------------------------------------------------------------------

-- Adding credit transactions for query 2
START TRANSACTION;

CALL AddCreditReward(
    8,
	9,
	'Class',
	FALSE,
	'2025-12-01'::DATE,
	'Pilates',
	'Bars and Bells',
	'239 Brenton St',
	'Beverly',
	'MA',
	'02313-5352',
	NULL,
	NULL,
	'REGE231@#@$1314',
	'blessings.smiles@gmail.com',
	'1999-05-11'::DATE,
    200.01,
	180.58,
	'Female',
	'Julia Serrano',
	'02342-9921',
	'Beginner',
	'REG32E2311@#@$14',
	'medina.active@gmail.com',
	'1999-01-03'::DATE,
    200.01,
	190.58,
	'Male',
	'Marcus Medina',
	'02342-9921',
	'Beginner'
);

COMMIT;

START TRANSACTION;

CALL AddCreditReward(
    10,
	11,
	'Card',
	FALSE,
	'2025-12-12'::DATE,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	'Reggies Bakery',
	50.00,
	'REGE231@#@$1314',
	'blessings.smiles@gmail.com',
	'1999-05-11'::DATE,
    200.01,
	180.58,
	'Female',
	'Julia Serrano',
	'02342-9921',
	'Beginner',
	'REG32E2311@#@$14',
	'medina.active@gmail.com',
	'1999-01-03'::DATE,
    200.01,
	190.58,
	'Male',
	'Marcus Medina',
	'02342-9921',
	'Beginner'
);

COMMIT;


START TRANSACTION;

CALL AddCreditReward(
    12,
	13,
	'Class',
	FALSE,
	'2026-03-01'::DATE,
	'Yoga',
	'Minis Yoga Studio',
	'21 Fullerton St',
	'Beverly',
	'MA',
	'02313-5352',
	NULL,
	NULL,
	'REGE111@#@$1314',
	'handyman.smiles@gmail.com',
	'2001-05-11'::DATE,
    200.01,
	180.58,
	'Female',
	'Bonita Frenza',
	'02342-9921',
	'Beginner',
	'REG32E23111@#@$14',
	'fitness.queen@gmail.com',
	'1992-01-03'::DATE,
    210.01,
	180.58,
	'Female',
	'Samantha Medina',
	'02342-9921',
	'Beginner'
);

COMMIT;

SELECT * FROM Credit;
SELECT * FROM GymClass;
SELECT * FROM GymClassType;
SELECT * FROM ClassType;
SELECT * FROM Gym;
SELECT * FROM GiftCard;
SELECT * FROM Shop;

-- implementing query 2
SELECT 
    u.UserID AS ReceiverID,
    u.Name AS ReceiverName,
    s.Name AS SenderName,
    g.GymName,
    ct.ClassName,
 	c.Redeemed,
	c.ExpirationDate
	
FROM Credit c --supertype

JOIN AppUser u 
    ON u.UserID = c.ReceiverUserID
	
JOIN AppUser s
    ON s.UserID = c.SenderUserID
	
JOIN GymClass gc 
    ON gc.CreditID = c.CreditID
	
JOIN GymClassType gct  
    ON gct.GymClassTypeID = gc.GymClassTypeID   
	
JOIN ClassType ct 
    ON ct.ClassTypeID = gct.ClassTypeID      
	
JOIN Gym g 
    ON g.GymID = gct.GymID   
	
WHERE c.Redeemed IS FALSE;

--  ------------------------------------------------------------------
-- Step 11C: Query 3
--  ------------------------------------------------------------------

-- adding workouts for an existing user

START TRANSACTION;
CALL AddUserWorkout(
	'PERG22421@#@$14',
	'mandez.journey@gmail.com',
	'1996-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Seline Mandez',
	'02342-9921',
	'Beginner',
	45,
	450,
	'2025-11-02 12:05:00'::TIMESTAMP,
	'2025-11-02 12:50:00'::TIMESTAMP,
	125::SMALLINT,
	155::SMALLINT,
	6,
	'Jogging'
);

COMMIT;

START TRANSACTION;
CALL AddUserWorkout(
	'PERG22421@#@$14',
	'mandez.journey@gmail.com',
	'1996-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Seline Mandez',
	'02342-9921',
	'Beginner',
	25,
	300,
	'2025-11-04 11:05:00'::TIMESTAMP,
	'2025-11-04 11:30:00'::TIMESTAMP,
	120::SMALLINT,
	150::SMALLINT,
	NULL,
	'Yoga'
);

COMMIT;

START TRANSACTION;
CALL AddUserWorkout(
	'PERG22421@#@$14',
	'mandez.journey@gmail.com',
	'1996-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Seline Mandez',
	'02342-9921',
	'Beginner',
	25,
	300,
	'2025-11-05 11:05:00'::TIMESTAMP,
	'2025-11-05 11:30:00'::TIMESTAMP,
	120::SMALLINT,
	149::SMALLINT,
	NULL,
	'Yoga'
);

COMMIT;

START TRANSACTION;
CALL AddUserWorkout(
	'PERG22421@#@$14',
	'mandez.journey@gmail.com',
	'1996-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Seline Mandez',
	'02342-9921',
	'Beginner',
	50,
	400,
	'2025-11-07 11:05:00'::TIMESTAMP,
	'2025-11-07 11:30:00'::TIMESTAMP,
	129::SMALLINT,
	145::SMALLINT,
	4.12,
	'Walking'
);

COMMIT;

START TRANSACTION;
CALL AddUserWorkout(
	'PERG22421@#@$14',
	'mandez.journey@gmail.com',
	'1996-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Seline Mandez',
	'02342-9921',
	'Beginner',
	50,
	400,
	'2025-11-15 11:05:00'::TIMESTAMP,
	'2025-11-15 11:30:00'::TIMESTAMP,
	129::SMALLINT,
	145::SMALLINT,
	4,
	'Walking'
);

COMMIT;

START TRANSACTION;
CALL AddUserWorkout(
	'PERG22421@#@$14',
	'mandez.journey@gmail.com',
	'1996-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Seline Mandez',
	'02342-9921',
	'Beginner',
	20,
	230,
	'2025-11-20 12:05:00'::TIMESTAMP,
	'2025-11-20 12:50:00'::TIMESTAMP,
	125::SMALLINT,
	155::SMALLINT,
	3,
	'Jogging'
);

COMMIT;

START TRANSACTION;
CALL AddUserWorkout(
	'PERG22421@#@$14',
	'mandez.journey@gmail.com',
	'1996-05-11'::DATE,
    190.01,
	170.58,
	'Female',
	'Seline Mandez',
	'02342-9921',
	'Beginner',
	45,
	450,
	'2025-12-02 12:05:00'::TIMESTAMP,
	'2025-12-02 12:50:00'::TIMESTAMP,
	125::SMALLINT,
	155::SMALLINT,
	6,
	'Jogging'
);

COMMIT;

-- VIEW SETUP AND EXECUTION

DROP VIEW IF EXISTS MonthlyWorkoutSummary;

CREATE OR REPLACE VIEW MonthlyWorkoutSummary AS
SELECT
    w.UserID,
	u.Name,
	DATE_TRUNC('month', w.StartTime) AS WorkoutMonth,
    SUM(w.CaloriesBurned) AS TotalCaloriesBurned,
    AVG(w.CaloriesBurned) AS AvgCaloriesBurned,

    SUM(w.DurationMins) AS TotalWorkoutMinutes,
    AVG(w.DurationMins) AS AvgWorkoutDurationMinutes,

    MAX(w.MaxHeartRate) AS OverallMaxHeartRate,
    AVG(w.AverageHeartRate) AS OverallAvgHeartRate

FROM Workout w
JOIN AppUser u
ON u.UserID = w.UserID

WHERE w.DurationMins > 1 AND w.DistanceKm > 0.1

GROUP BY
    w.UserID,
	u.Name,
    DATE_TRUNC('month', w.StartTime)

ORDER BY
    w.UserID,
	u.Name,
    DATE_TRUNC('month', w.StartTime);

-- 
SELECT * FROM MonthlyWorkoutSummary;

SELECT * FROM MonthlyWorkoutSummary
WHERE name='Seline Mandez' AND 
EXTRACT(MONTH FROM WorkoutMonth) = 11
;

--  ------------------------------------------------------------------
-- Step 12: Indexes
--  ------------------------------------------------------------------

CREATE INDEX Workout_DurationMins_Idx ON Workout(DurationMins);
CREATE INDEX Credit_ReceiverUserID_QIdx ON Credit(ReceiverUserID);
CREATE INDEX Workout_StartTime_Idx ON Workout(StartTime);

--  ------------------------------------------------------------------
-- Step 13: Attribute History
--  ------------------------------------------------------------------

-- Function linked to trigger setup

CREATE OR REPLACE FUNCTION HydrationIntakeUpdateFunction()
RETURNS TRIGGER LANGUAGE plpgsql
AS $trigfunc$
BEGIN
    INSERT INTO HydrationIntakeUpdate(
        HydrationIntakeUpdateID,
        OldIntakeML,
        NewIntakeML,
        HydrationMetricID,
        InsertionDate
    )
    VALUES(
        nextval('hydrationupdate_id'),
        OLD.CurrentDayIntakeML,
        NEW.CurrentDayIntakeML,
        NEW.HydrationMetricID,
        NOW()
    );

    RETURN NEW;
END;
$trigfunc$;


-- Trigger setup
DROP TRIGGER IF EXISTS HydrationIntakeUpdateTrigger ON HydrationMetric;

CREATE TRIGGER HydrationIntakeUpdateTrigger
BEFORE UPDATE OF CurrentDayIntakeML ON HydrationMetric
FOR EACH ROW
EXECUTE PROCEDURE HydrationIntakeUpdateFunction();


-- Inserting the initial sample HydrationMetric rows

SELECT * FROM AppUser;

INSERT INTO HydrationMetric(
    UserID,
    Temperature,
	LastUpdated,
	CurrentDayIntakeML,
	DailyWaterGoalML)
VALUES(1, 100.5, NOW(), 300, 2800),
(2, 87, NOW(), 500, 2600);

SELECT * FROM HydrationMetric;

-- Updating the HydrationMetric.CurrentDayIntakeML values for users

UPDATE HydrationMetric
SET CurrentDayIntakeML = 450, LastUpdated = NOW()
WHERE HydrationMetricID = 1;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 650, LastUpdated = NOW()
WHERE HydrationMetricID = 2;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 600, LastUpdated = NOW()
WHERE HydrationMetricID = 1;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 800, LastUpdated = NOW()
WHERE HydrationMetricID = 2;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 700, LastUpdated = NOW()
WHERE HydrationMetricID = 1;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 990, LastUpdated = NOW()
WHERE HydrationMetricID = 2;

-- Checking for history of changes for the 2 users in the new table
SELECT * FROM HydrationIntakeUpdate;
SELECT * FROM HydrationMetric;

--  ------------------------------------------------------------------
-- Step 14: Visualizations
--  ------------------------------------------------------------------

-- Inserting some more sample hydration metrics for visualization setup 1

SELECT * FROM AppUser;

INSERT INTO HydrationMetric(
    UserID,
    Temperature,
	LastUpdated,
	CurrentDayIntakeML,
	DailyWaterGoalML)
VALUES(3, 100.5, NOW(), 0, 3000),
(4, 87, NOW(), 0, 2900);

SELECT * FROM HydrationMetric;

-- Updating the HydrationMetric.CurrentDayIntakeML values for users

UPDATE HydrationMetric
SET CurrentDayIntakeML = 450, LastUpdated = NOW()
WHERE HydrationMetricID = 3;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 300, LastUpdated = NOW()
WHERE HydrationMetricID = 4;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 500, LastUpdated = NOW()
WHERE HydrationMetricID = 3;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 400, LastUpdated = NOW()
WHERE HydrationMetricID = 4;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 700, LastUpdated = NOW()
WHERE HydrationMetricID = 3;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 600, LastUpdated = NOW()
WHERE HydrationMetricID = 4;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 800, LastUpdated = NOW()
WHERE HydrationMetricID = 3;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 800, LastUpdated = NOW()
WHERE HydrationMetricID = 4;

UPDATE HydrationMetric
SET CurrentDayIntakeML = 900, LastUpdated = NOW()
WHERE HydrationMetricID = 4;

SELECT * FROM HydrationIntakeUpdate;
SELECT * FROM HydrationMetric;

-- Visualization Query 1

SELECT 
    InsertionDate::date AS DateRecordeed,
    AVG(NewIntakeML - OldIntakeML) AS AvgIntakeIncrease,
	COUNT(*) AS totalDrinks,
	u.Name
FROM HydrationIntakeUpdate i
JOIN HydrationMetric h 
ON i.HydrationMetricID = h.HydrationMetricID
JOIN AppUser u 
ON h.UserID = u.UserID
GROUP BY InsertionDate::date, u.Name
ORDER BY DateRecordeed, u.Name;

-- Visualization Query 2 

SELECT h.CurrentDayIntakeML, h.DailyWaterGoalML, u.Name
FROM HydrationMetric h
JOIN AppUser u
ON h.UserID = u.UserID
WHERE h.CurrentDayIntakeML < h.DailyWaterGoalML



