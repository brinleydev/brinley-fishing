CREATE TABLE pyhfish_leaderboard (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fish_name VARCHAR(255) NOT NULL,
    fish_length DECIMAL(5, 2) NOT NULL,
    player_name VARCHAR(255) NOT NULL,
    caught_at DATETIME NOT NULL
);