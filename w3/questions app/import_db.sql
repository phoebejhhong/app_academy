CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  follower_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (follower_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  liker_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (liker_id) REFERENCES users(id)
);

INSERT INTO
users (fname, lname)
VALUES
('Anton', 'Shain'),
('Phoebe', 'Hong'),
('Test', 'User');

INSERT INTO
questions (title, body, author_id)
VALUES
('SQL', 'What is this?', (SELECT id FROM users WHERE fname = 'Anton' AND lname = 'Shain')),
('SQL2', 'What is this?', (SELECT id FROM users WHERE fname = 'Anton' AND lname = 'Shain')),
('SQL3', 'What is this?', (SELECT id FROM users WHERE fname = 'Anton' AND lname = 'Shain')),
('Ruby', 'What is OOP?', (SELECT id FROM users WHERE fname = 'Phoebe' AND lname = 'Hong'));

INSERT INTO
question_followers (question_id, follower_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(4, 2);

INSERT INTO
replies (question_id, author_id, parent_reply_id, body)
VALUES
(1, 2, null, "I don't know either"),
(1, 1, 1, 'cool'),
(1, 3, 1, 'very cool'),
(1, 2, 3, 'very very cool'),
(2, 1, null, 'good question');


INSERT INTO
question_likes (question_id, liker_id)
VALUES
(1, 2),
(1, 1),
(1, 3),
(4, 1);
