CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  follower_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  PRIMARY KEY (follower_id, question_id),
  FOREIGN KEY (follower_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body VARCHAR(255) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  liker_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  PRIMARY KEY (liker_id, question_id),
  FOREIGN KEY (liker_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Robert', 'Romano'), ('William', 'Horton'), ('Frank', 'Samson');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Mets', 'How good are the Mets?', (SELECT id FROM users WHERE lname = 'Romano')),
  ('App Academy', 'How much SQL can you learn?', (SELECT id FROM users WHERE lname = 'Horton')),
  ('App Academy 2', 'How much SQL can you forget?', (SELECT id FROM users WHERE lname = 'Horton')),
  ('Suitcase', 'How much can you fit?', (SELECT id FROM users WHERE lname = 'Samson'));

INSERT INTO
  question_follows (follower_id, question_id)
VALUES
  ((SELECT id FROM users WHERE lname = 'Horton'), (SELECT id FROM questions WHERE title = 'Mets')),
  ((SELECT id FROM users WHERE lname = 'Horton'), (SELECT id FROM questions WHERE title = 'Suitcase'));

INSERT INTO
  replies (question_id, user_id, body)
VALUES
((SELECT id FROM questions WHERE title = 'Mets'), (SELECT id FROM users WHERE lname = 'Horton'), 'They are really good'),
((SELECT id FROM questions WHERE title = 'Mets'), (SELECT id FROM users WHERE lname = 'Romano'), 'I know');

INSERT INTO
  question_likes (liker_id, question_id)
VALUES
  ((SELECT id FROM users WHERE lname = 'Romano'), (SELECT id FROM questions WHERE title = 'App Academy')),
  ((SELECT id FROM users WHERE lname = 'Samson'), (SELECT id FROM questions WHERE title = 'App Academy'));
