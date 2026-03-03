INSERT INTO users (name, email)
SELECT 'Alice Martin', 'alice.martin@example.com'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'alice.martin@example.com');

INSERT INTO users (name, email)
SELECT 'Bob Dupont', 'bob.dupont@example.com'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'bob.dupont@example.com');

INSERT INTO users (name, email)
SELECT 'Charlie Durand', 'charlie.durand@example.com'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'charlie.durand@example.com');

INSERT INTO users (name, email)
SELECT 'Diana Leroy', 'diana.leroy@example.com'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'diana.leroy@example.com');
