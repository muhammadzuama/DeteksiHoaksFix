CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
drop table users;
select * from users;
INSERT INTO users (name, email, password) 
VALUES ('zuzu', 'zuzu@example.com', '090789');


CREATE TABLE history (
    id SERIAL PRIMARY KEY,            -- ID unik untuk setiap catatan
    user_id INT NOT NULL,             -- ID pengguna yang terkait
    input TEXT NOT NULL,              -- Input yang diberikan oleh pengguna
    hasil VARCHAR(255) NOT NULL,      -- Hasil yang dihasilkan dari input
    waktu TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Waktu pencatatan (timestamp)
    release VARCHAR(50) NOT NULL,     -- Menyimpan informasi rilis
    FOREIGN KEY (user_id) REFERENCES users(user_id)  -- Mengaitkan user_id dengan tabel users
);

INSERT INTO history (user_id, input, hasil, release) 
VALUES 
(1, 'Input pengguna contoh', 'Hasil yang dihasilkan', 'v1.0'),
(1, 'Input lainnya', 'Hasil untuk input lainnya', 'v1.1'),
(1, 'Input tambahan', 'Hasil tambahan', 'v1.2');

select * from history;

