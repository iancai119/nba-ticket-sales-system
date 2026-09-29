--   1. Cleanup (Drop tables if they exist)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Ticket_Sales CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE Seat_Tier CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE NBA_game CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE Fan CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

--   2. Create Tables
-- Table: Fan
CREATE TABLE Fan (
    fan_id NUMBER(10) NOT NULL,
    email_address VARCHAR2(50) NOT NULL,
    username VARCHAR2(30) NOT NULL,
    favorite_team VARCHAR2(30),
    zip_code CHAR(5)
);

-- Table: NBA_game
CREATE TABLE NBA_game (
    game_id NUMBER(10) NOT NULL,
    home_team VARCHAR2(30) NOT NULL,
    away_team VARCHAR2(30) NOT NULL,
    tipoff_time DATE NOT NULL
);

-- Table: Seat_Tier
CREATE TABLE Seat_Tier (
    tier_code CHAR(3) NOT NULL,
    tier_name VARCHAR2(20) NOT NULL,
    lounge_access NUMBER(1) NOT NULL -- 0 for False, 1 for True
);

-- Table: Ticket_Sales
CREATE TABLE Ticket_Sales (
    ticket_id NUMBER(10) NOT NULL,
    game_id NUMBER(10) NOT NULL,
    fan_id NUMBER(10) NOT NULL,
    tier_code CHAR(3) NOT NULL,
    section_row VARCHAR2(10) NOT NULL,
    seat_number NUMBER(5) NOT NULL,
    purchase_price NUMBER(10, 2) NOT NULL,
    purchase_time DATE NOT NULL
);

--  3. Add Constraints (PKs, FKs, UNIQUEs and CHECKs)

-- Primary Keys
ALTER TABLE Fan ADD CONSTRAINT PK_Fan PRIMARY KEY (fan_id);
ALTER TABLE NBA_game ADD CONSTRAINT PK_NBA_game PRIMARY KEY (game_id);
ALTER TABLE Seat_Tier ADD CONSTRAINT PK_Seat_Tier PRIMARY KEY (tier_code);
ALTER TABLE Ticket_Sales ADD CONSTRAINT PK_Ticket_Sales PRIMARY KEY (ticket_id);

-- Foreign Keys
ALTER TABLE Ticket_Sales ADD CONSTRAINT FK_Sales_Game
    FOREIGN KEY (game_id) REFERENCES NBA_game (game_id);

ALTER TABLE Ticket_Sales ADD CONSTRAINT FK_Sales_Fan
    FOREIGN KEY (fan_id) REFERENCES Fan (fan_id);

ALTER TABLE Ticket_Sales ADD CONSTRAINT FK_Sales_Tier
    FOREIGN KEY (tier_code) REFERENCES Seat_Tier (tier_code);

-- Unique constraints: no two fans share an email or username
ALTER TABLE Fan ADD CONSTRAINT UQ_Fan_Email UNIQUE (email_address);
ALTER TABLE Fan ADD CONSTRAINT UQ_Fan_Username UNIQUE (username);

-- Check constraints: prices must be positive, lounge flag is 0/1 only
ALTER TABLE Ticket_Sales ADD CONSTRAINT CK_Sales_Price CHECK (purchase_price > 0);
ALTER TABLE Seat_Tier ADD CONSTRAINT CK_Tier_Lounge CHECK (lounge_access IN (0, 1));

 --  4. Insert Sample Data

-- Insert Fans (Generic users)
INSERT INTO Fan VALUES (1, 'john.doe@email.com', 'johndoe88', 'Lakers', '90210');
INSERT INTO Fan VALUES (2, 'alice.smith@provider.net', 'AliceWonder', 'Celtics', '02114');
INSERT INTO Fan VALUES (3, 'mike.jones@work.org', 'MikeJ_Hoops', NULL, '10001');
INSERT INTO Fan VALUES (4, 'sarah.connor@sky.net', 'S_Connor', 'Spurs', '78205');
INSERT INTO Fan VALUES (5, 'david.lee@webmail.com', 'DLee_SF', 'Warriors', '94105');
INSERT INTO Fan VALUES (6, 'emily.white@school.edu', 'EmWhite', 'Bulls', '60612');

-- Insert Games
INSERT INTO NBA_game VALUES (101, 'Lakers', 'Warriors', TO_DATE('2025-10-25 19:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NBA_game VALUES (102, 'Celtics', 'Heat', TO_DATE('2025-10-26 20:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NBA_game VALUES (103, 'Knicks', 'Nets', TO_DATE('2025-10-27 19:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NBA_game VALUES (104, 'Bulls', 'Bucks', TO_DATE('2025-10-28 18:30:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Insert Seat Tiers
INSERT INTO Seat_Tier VALUES ('VIP', 'Courtside', 1);
INSERT INTO Seat_Tier VALUES ('LWR', 'Lower Bowl', 0);
INSERT INTO Seat_Tier VALUES ('UPR', 'Upper Bowl', 0);
INSERT INTO Seat_Tier VALUES ('BOX', 'Luxury Box', 1);

-- Insert Ticket Sales (Linking Fans to Games)

-- Game 101: Lakers vs Warriors
INSERT INTO Ticket_Sales VALUES (5001, 101, 1, 'VIP', 'Row 1', 12, 2500.00, TO_DATE('2025-10-20 10:15:00', 'YYYY-MM-DD HH24:MI:SS')); -- John Doe buys VIP
INSERT INTO Ticket_Sales VALUES (5002, 101, 5, 'LWR', 'Row A', 101, 450.00, TO_DATE('2025-10-21 14:30:00', 'YYYY-MM-DD HH24:MI:SS')); -- David Lee buys Lower
INSERT INTO Ticket_Sales VALUES (5003, 101, 3, 'UPR', 'Row 20', 15, 85.50, TO_DATE('2025-10-22 09:05:00', 'YYYY-MM-DD HH24:MI:SS'));  -- Mike Jones buys Upper

-- Game 102: Celtics vs Heat
INSERT INTO Ticket_Sales VALUES (5004, 102, 2, 'LWR', 'Row F', 44, 320.00, TO_DATE('2025-10-21 16:45:00', 'YYYY-MM-DD HH24:MI:SS'));  -- Alice buys Lower
INSERT INTO Ticket_Sales VALUES (5005, 102, 2, 'LWR', 'Row F', 45, 320.00, TO_DATE('2025-10-21 16:47:00', 'YYYY-MM-DD HH24:MI:SS'));  -- Alice buys another
INSERT INTO Ticket_Sales VALUES (5006, 102, 6, 'UPR', 'Row 5', 10, 60.00, TO_DATE('2025-10-23 11:20:00', 'YYYY-MM-DD HH24:MI:SS'));   -- Emily buys Upper

-- Game 103: Knicks vs Nets
INSERT INTO Ticket_Sales VALUES (5007, 103, 3, 'BOX', 'Suite 1', 1, 5000.00, TO_DATE('2025-10-22 13:00:00', 'YYYY-MM-DD HH24:MI:SS')); -- Mike Jones splurges
INSERT INTO Ticket_Sales VALUES (5008, 103, 4, 'UPR', 'Row 30', 22, 55.00, TO_DATE('2025-10-24 18:10:00', 'YYYY-MM-DD HH24:MI:SS'));   -- Sarah buys Upper

-- Game 104: Bulls vs Bucks
INSERT INTO Ticket_Sales VALUES (5009, 104, 6, 'LWR', 'Row B', 12, 210.00, TO_DATE('2025-10-23 12:25:00', 'YYYY-MM-DD HH24:MI:SS'));  -- Emily buys Lower
INSERT INTO Ticket_Sales VALUES (5010, 104, 1, 'VIP', 'Row 1', 5, 1800.00, TO_DATE('2025-10-24 20:40:00', 'YYYY-MM-DD HH24:MI:SS'));  -- John Doe buys VIP again

-- Commit the transaction
COMMIT;


--   5. Verification Query
SELECT * FROM Ticket_Sales;

SELECT USER FROM DUAL;
