-- BOARD
INSERT INTO board (id, name, sigla)
VALUES (0, 'Haskell', 'hs'), (1, 'Python', 'py'), (2, 'Ruby', 'rb');

-- PUBLICATION
INSERT INTO publication (id, boardid, userid, content, title)
VALUES (0, 0, 1, 'Thread de Haskell', 'Haskell');

-- REPLY
INSERT INTO reply (id, publicationid, userid, content) 
VALUES (0, 0, 1, 'Reply #1!'), (1, 0, 1, 'Reply #2!');

-- USER_CATEGORY
INSERT INTO User_Category
VALUES (0, 'Usuario'), (1, 'Administrador');

-- USERS
INSERT INTO users (id, email, nickName, password, userCategoryId)
VALUES (0, 'no email', 'root', 'root', 1), (1, 'sem email', 'usuario', 'abc', 0);

--aqui ficam os comandos de insert no banco de dados