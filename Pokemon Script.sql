CREATE TABLE Pokemon (
    Pokemon_ID INT PRIMARY KEY,
    Poke_Ball_ID INT,
    Move_ID INT,
    Region_ID INT,
    Type_ID INT,
    Trainer_ID INT,
    Pokemon_Name VARCHAR(50) NOT NULL,
    Base_HP VARCHAR(5),
    Base_Attack VARCHAR(5),
    Base_Defense VARCHAR(5),
    Base_Speed VARCHAR(5),
    FOREIGN KEY (Poke_Ball_ID) REFERENCES Poke_Ball(Poke_Ball_ID),
    FOREIGN KEY (Move_ID) REFERENCES Moves(Move_ID),
    FOREIGN KEY (Region_ID) REFERENCES Region(Region_ID),
    FOREIGN KEY (Type_ID) REFERENCES Type(Type_ID),
    FOREIGN KEY (Trainer_ID) REFERENCES Trainer(Trainer_ID)
);

INSERT INTO Pokemon (Pokemon_ID, Poke_Ball_ID, Move_ID, Region_ID, Type_ID, Trainer_ID, Pokemon_Name, Base_HP, Base_Attack, Base_Defense, Base_Speed) VALUES 
    (1, 1, 4, 1, 4, 1, 'Bulbasaur', '45', '49', '49', '45'),
    (7, 1, 3, 1, 3, 2, 'Squirtle', '44', '48', '65', '43'),
    (4, 1, 2, 1, 2, 3, 'Charmander', '39', '52', '43', '65'),
    (25, 1, 1, 1, 1, 4, 'Pikachu', '35', '55', '40', '90');

CREATE TABLE Poke_Ball (
    Poke_Ball_ID INT PRIMARY KEY,
    Poke_Ball_Name VARCHAR(50) NOT NULL
);

INSERT INTO Poke_Ball (Poke_Ball_ID, Poke_Ball_Name) VALUES 
    (1, 'Poke Ball'),
    (2, 'Great Ball'),
    (3, 'Ultra Ball'),
    (4, 'Master Ball');

CREATE TABLE Region (
    Region_ID INT PRIMARY KEY,
    Weather_ID INT NOT NULL,
    Region_Name VARCHAR(50) NOT NULL
);

INSERT INTO Region (Region_ID, Weather_ID, Region_Name) VALUES 
    (1, 1, 'Kanto'),
    (2, 2, 'Johto'),
    (3, 3, 'Hoenn'),
    (4, 4, 'Sinnoh');

CREATE TABLE Type (
    Type_ID INT PRIMARY KEY,
    Type_Name VARCHAR(50) NOT NULL
);

INSERT INTO Type (Type_ID, Type_Name) VALUES 
    (1, 'Normal'),
    (2, 'Fire'),
    (3, 'Water'),
    (4, 'Grass');

CREATE TABLE Moves (
    Move_ID INT PRIMARY KEY,
    Move_Name VARCHAR(50) NOT NULL,
    Move_Type VARCHAR(50) NOT NULL,
    Move_Power INT NOT NULL,
    Move_Accuracy INT NOT NULL
);

INSERT INTO Moves (Move_ID, Move_Name, Move_Type, Move_Power, Move_Accuracy) VALUES 
    (1, 'Tackle', 'Normal', 40, 100),
    (2, 'Ember', 'Fire', 40, 100),
    (3, 'Water Gun', 'Water', 40, 100),
    (4, 'Razor Leaf', 'Grass', 55, 95);

CREATE TABLE Trainer (
    Trainer_ID INT PRIMARY KEY,
    Pokemon_ID INT NOT NULL,
    Nickname VARCHAR(50) NOT NULL,
    Level INT NOT NULL,
    Gender VARCHAR(50) NOT NULL,
    FOREIGN KEY (Pokemon_ID) REFERENCES Pokemon(Pokemon_ID)
);

INSERT INTO Trainer (Trainer_ID, Pokemon_ID, Nickname, Level, Gender) VALUES 
    (1, 1, 'Misty', 1, 'Female'),
    (2, 4, 'Brock', 3, 'Male'),
    (3, 7, 'Erika', 4, 'Female'),
    (4, 25, 'Sabrina', 6, 'Female');

CREATE TABLE Caught (
    Trainer_ID INT NOT NULL,
    Pokemon_ID INT NOT NULL,
    FOREIGN KEY (Trainer_ID) REFERENCES Trainer(Trainer_ID),
    FOREIGN KEY (Pokemon_ID) REFERENCES Pokemon(Pokemon_ID),
    CONSTRAINT pk_caught PRIMARY KEY (Trainer_ID, Pokemon_ID)
);

INSERT INTO Caught (Trainer_ID, Pokemon_ID) VALUES 
    (1, 1),
    (2, 4),
    (3, 7),
    (4, 25);
    
CREATE TABLE Pokemon_Moves (
	Pokemon_ID INT NOT NULL,
	Move_ID INT NOT NULL,
	FOREIGN KEY (Pokemon_ID) REFERENCES Pokemon(Pokemon_ID),
	FOREIGN KEY (Move_ID) REFERENCES Moves(Move_ID),
	CONSTRAINT pk_pokemon_moves PRIMARY KEY (Pokemon_ID, Move_ID)
);

INSERT INTO Pokemon_Moves (Pokemon_ID, Move_ID) VALUES
	(1, 4),
	(7, 3),
	(4, 2),
	(25, 1);
    
SELECT * FROM Pokemon;
SELECT ' ' AS spacer;

SELECT * FROM Poke_Ball;
SELECT ' ' AS spacer;

SELECT * FROM Region;
SELECT ' ' AS spacer;

SELECT * FROM Type;
SELECT ' ' AS spacer;

SELECT * FROM Moves;
SELECT ' ' AS spacer;

SELECT * FROM Trainer;
SELECT ' ' AS spacer;

SELECT * FROM Caught;
SELECT ' ' AS spacer;

SELECT * FROM Pokemon_Moves;
SELECT ' ' AS spacer;
    
-- This inner join query returns a table with two columns, "Pokemon_Name" and "Nickname". 
-- Each row represents a Pokemon and its corresponding trainer, where the "Pokemon_Name" 
-- column contains the name of the Pokemon and the "Nickname" column contains the nickname of its trainer.
SELECT Pokemon.Pokemon_Name, Trainer.Nickname
FROM Pokemon
INNER JOIN Trainer
ON Pokemon.Trainer_ID = Trainer.Trainer_ID;

-- This outer join query returns a table with two columns, "Nickname" and "Pokemon_ID". 
-- Each row represents a trainer and the ID of a Pokemon they have caught. If a trainer 
-- has not caught any Pokemon, their "Pokemon_ID" value would be NULL.
SELECT ' ' AS spacer;
SELECT Trainer.Nickname, Caught.Pokemon_ID
FROM Trainer
LEFT OUTER JOIN Caught
ON Trainer.Trainer_ID = Caught.Trainer_ID;

-- Sub query to find all the trainers who have caught a Pokemon with the move "Water Gun"
SELECT ' ' AS spacer;
SELECT Nickname
FROM Trainer
WHERE Trainer_ID IN (
  SELECT Trainer_ID
  FROM Caught
  WHERE Pokemon_ID IN (
    SELECT Pokemon_ID
    FROM Pokemon
    WHERE Move_ID = (
      SELECT Move_ID
      FROM Moves
      WHERE Move_Name = 'Water Gun'
    )
  )
);

-- Correlated sub query to to find all the Pokemon caught by each trainer along with 
-- their move types, but only include trainers who have caught at least one Pokemon of the Water type
SELECT ' ' AS spacer;
SELECT 
  T.Nickname,
  P.Pokemon_Name,
  M.Move_Type
FROM Trainer T
INNER JOIN Caught C ON T.Trainer_ID = C.Trainer_ID
INNER JOIN Pokemon P ON C.Pokemon_ID = P.Pokemon_ID
INNER JOIN Moves M ON P.Move_ID = M.Move_ID
WHERE EXISTS (
  SELECT 1
  FROM Pokemon P2
  WHERE P2.Move_ID = P.Move_ID
  AND Type_ID = (
    SELECT Type_ID
    FROM Type
    WHERE Type_Name = 'Water'
  )
);
