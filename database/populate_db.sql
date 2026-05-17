 --CATEGORII
INSERT INTO CATEGORII (denumire) VALUES ('Suspans');
INSERT INTO CATEGORII (denumire) VALUES ('Dramă');
INSERT INTO CATEGORII (denumire) VALUES ('Sci-Fi');
INSERT INTO CATEGORII (denumire) VALUES ('Acțiune');
INSERT INTO CATEGORII (denumire) VALUES ('Aventură');
INSERT INTO CATEGORII (denumire) VALUES ('Groază');
INSERT INTO CATEGORII (denumire) VALUES ('Romantic');
INSERT INTO CATEGORII (denumire) VALUES ('Comedie');
INSERT INTO CATEGORII (denumire) VALUES ('Animație');
INSERT INTO CATEGORII (denumire) VALUES ('Fantezie');
INSERT INTO CATEGORII (denumire) VALUES ('Muzical');
INSERT INTO CATEGORII (denumire) VALUES ('Biografie');
INSERT INTO CATEGORII (denumire) VALUES ('Documentar');
INSERT INTO CATEGORII (denumire) VALUES ('Mister');
INSERT INTO CATEGORII (denumire) VALUES ('Western');
INSERT INTO CATEGORII (denumire) VALUES ('Istoric');
INSERT INTO CATEGORII (denumire) VALUES ('Război');
INSERT INTO CATEGORII (denumire) VALUES ('Sport');

COMMIT;

-- FILME
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Godfather', 'Șeful îmbătrânit al unui clan mafiot cedează conducerea fiului cel mic, declanșând un război sângeros între familii.', DATE '1972-03-24');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Fight Club', 'Un angajat nemulțumit și un vânzător de săpun charismatic fondează un club de lupte clandestin cu scopuri din ce în ce mai sinistre.', DATE '1999-10-15');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Lord of the Rings: The Fellowship of the Ring', 'Un hobbit pornește într-o călătorie epică alături de o ceată eterogenă pentru a distruge un inel al răului.', DATE '2001-12-19');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Goodfellas', 'Ascensiunea și căderea unui mafiot din New York, văzute din interior de-a lungul a trei decenii.',  DATE '1990-09-21');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Se7en', 'Doi detectivi cu personalități opuse vânează un ucigaș în serie care-și modelează crimele după cele șapte păcate capitale.', DATE '1995-09-22');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Saving Private Ryan', 'Un pluton de soldați americani primește misiunea periculoasă de a găsi și repatria un soldat al cărui frați au murit în luptă.', DATE '1998-07-24');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Titanic', 'O poveste de dragoste imposibilă între o fată din înalta societate și un tânăr sărac la bordul celebrului transatlantic condamnat.', DATE '1997-12-19');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Joker', 'Un comedian ratat și marginalizat din Gotham City se transformă treptat în cel mai temut criminal al orașului.', DATE '2019-10-04');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Prestige', 'Doi magicieni rivali se întrec în trucuri din ce în ce mai periculoase, obsesia distrugând totul în jurul lor.', DATE '2006-10-20');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Whiplash', 'Un tânăr baterist ambițios intră sub tutela unui instructor de conservator extrem de sever și imprevizibil.', DATE '2014-10-10');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Black Swan', 'O balerină perfectă se destramă psihologic în timp ce pregătește rolul principal din Lacul Lebedelor.', DATE '2010-12-17');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Revenant', 'Un explorator lăsat pentru mort de propriii tovarăși luptă pentru supraviețuire și răzbunare în sălbăticia americană.', DATE '2015-12-25');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('No Country for Old Men', 'Un vânător dă peste o sumă uriașă de bani și devine urmărit de un asasin fără milă și fără logică.', DATE '2007-11-09');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Avengers: Endgame', 'Supereroii supraviețuitori încearcă să inverseze consecințele devastatoare ale acțiunilor lui Thanos.', DATE '2019-04-26');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Everything Everywhere All at Once', 'O femeie descoperă că poate accesa universuri paralele și trebuie să oprească o forță care amenință întreaga existență.', DATE '2022-03-25');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Green Mile', 'Un ofițer de penitenciar face cunoștință cu un deținut condamnat la moarte care posedă puteri misterioase de vindecare.', DATE '1999-12-10');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Braveheart', 'William Wallace conduce poporul scoțian în lupta pentru independența față de coroana engleză opresivă.', DATE '1995-05-24');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Memento', 'Un bărbat fără memorie pe termen scurt încearcă să-și găsească soția ucisă folosind notițe și tatuaje.', DATE '2000-09-05');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Mad Max: Fury Road', 'Într-o lume post-apocaliptică, Max și Furiosa fug de un tiran crud printr-un deșert nesfârșit.', DATE '2015-05-15');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Bohemian Rhapsody', 'Viața și cariera legendarei trupe Queen, culminând cu spectaculosul concert Live Aid din 1985.', DATE '2018-10-24');

COMMIT;

-- FILME_CATEGORII
DECLARE
    PROCEDURE film_categorii(p_titlu VARCHAR2, p_categorie VARCHAR2) IS
        v_film_id NUMBER; 
        v_categorie_id NUMBER;
    BEGIN
        SELECT film_id      INTO v_film_id FROM FILME  WHERE titlu = p_titlu;
        SELECT categorie_id INTO v_categorie_id FROM CATEGORII WHERE denumire = p_categorie;
        INSERT INTO FILME_CATEGORII (film_id, categorie_id) VALUES (v_film_id, v_categorie_id);
    END;
BEGIN
    film_categorii('The Godfather', 'Dramă'); film_categorii('The Godfather', 'Suspans'); film_categorii('The Godfather', 'Mister');

    film_categorii('Fight Club', 'Dramă'); film_categorii('Fight Club', 'Suspans'); film_categorii('Fight Club', 'Acțiune');
    
    film_categorii('The Lord of the Rings: The Fellowship of the Ring', 'Aventură');
    film_categorii('The Lord of the Rings: The Fellowship of the Ring', 'Fantezie');
    film_categorii('The Lord of the Rings: The Fellowship of the Ring', 'Acțiune');
   
    film_categorii('Goodfellas', 'Dramă'); film_categorii('Goodfellas', 'Suspans'); film_categorii('Goodfellas', 'Mister');
    
    film_categorii('Se7en', 'Suspans'); film_categorii('Se7en', 'Groază'); film_categorii('Se7en', 'Mister');
   
    film_categorii('Saving Private Ryan', 'Război'); film_categorii('Saving Private Ryan', 'Dramă'); film_categorii('Saving Private Ryan', 'Acțiune');
    
    film_categorii('Titanic', 'Romantic'); film_categorii('Titanic', 'Dramă');
    
    film_categorii('Joker', 'Dramă'); film_categorii('Joker', 'Suspans');  film_categorii('Joker', 'Groază');
    
    film_categorii('The Prestige', 'Dramă'); film_categorii('The Prestige', 'Mister'); film_categorii('The Prestige', 'Suspans');
   
    film_categorii('Whiplash', 'Dramă'); film_categorii('Whiplash', 'Muzical');
    
    film_categorii('Black Swan', 'Dramă'); film_categorii('Black Swan', 'Suspans'); film_categorii('Black Swan', 'Groază');
    
    film_categorii('The Revenant', 'Aventură'); film_categorii('The Revenant', 'Dramă'); film_categorii('The Revenant', 'Acțiune');
    
    film_categorii('No Country for Old Men', 'Suspans'); film_categorii('No Country for Old Men', 'Dramă');  film_categorii('No Country for Old Men', 'Western');
    
    film_categorii('Avengers: Endgame', 'Acțiune'); film_categorii('Avengers: Endgame', 'Sci-Fi'); film_categorii('Avengers: Endgame', 'Aventură');
    
    film_categorii('Everything Everywhere All at Once', 'Sci-Fi');
    film_categorii('Everything Everywhere All at Once', 'Comedie');
    film_categorii('Everything Everywhere All at Once', 'Acțiune');
    
    film_categorii('The Green Mile', 'Dramă'); film_categorii('The Green Mile', 'Mister');
    
    film_categorii('Braveheart', 'Război'); film_categorii('Braveheart', 'Dramă'); film_categorii('Braveheart', 'Istoric');
   
    film_categorii('Memento', 'Mister');  film_categorii('Memento', 'Suspans'); film_categorii('Memento', 'Dramă');
    
    film_categorii('Mad Max: Fury Road', 'Acțiune'); film_categorii('Mad Max: Fury Road', 'Sci-Fi'); film_categorii('Mad Max: Fury Road', 'Aventură');
    
    film_categorii('Bohemian Rhapsody', 'Biografie'); film_categorii('Bohemian Rhapsody', 'Dramă'); film_categorii('Bohemian Rhapsody', 'Muzical');
    COMMIT;
END;
/

-- VERSIUNI_FILME
DECLARE
    PROCEDURE insert_versiune(p_titlu VARCHAR2, p_format VARCHAR2, p_limba VARCHAR2, p_rezolutie VARCHAR2, p_durata NUMBER) IS
        v_film_id NUMBER;
    BEGIN
        SELECT film_id INTO v_film_id FROM FILME WHERE titlu = p_titlu;
        INSERT INTO VERSIUNI_FILME (film_id, format, limba, rezolutie, durata_minute)
        VALUES (v_film_id, p_format, p_limba, p_rezolutie, p_durata);
    END;
BEGIN
    insert_versiune('The Godfather', '4K', 'Engleza original', '3840x2160', 175);
    insert_versiune('The Godfather', 'HD', 'Subtitrat romana', '1920x1080', 175);
    insert_versiune('Fight Club', 'HD', 'Engleza original', '1920x1080', 139);
    insert_versiune('Fight Club', 'HD', 'Dublat romana', '1920x1080', 139);
    insert_versiune('The Lord of the Rings: The Fellowship of the Ring', '4K', 'Engleza original', '3840x2160', 178);
    insert_versiune('The Lord of the Rings: The Fellowship of the Ring', 'HD', 'Subtitrat romana', '1920x1080', 178);
    insert_versiune('Goodfellas', 'HD', 'Engleza original', '1920x1080', 146);
    insert_versiune('Goodfellas', 'SD', 'Subtitrat romana', '720x576', 146);
    insert_versiune('Se7en', 'HD', 'Engleza original', '1920x1080', 127);
    insert_versiune('Se7en', 'HD',  'Dublat romana', '1920x1080', 127);
    insert_versiune('Saving Private Ryan', '4K', 'Engleza original', '3840x2160', 169);
    insert_versiune('Saving Private Ryan', 'HD', 'Subtitrat romana', '1920x1080', 169);
    insert_versiune('Titanic', '4K', 'Engleza original', '3840x2160', 194);
    insert_versiune('Titanic', 'HD', 'Dublat romana', '1920x1080', 194);
    insert_versiune('Joker', 'HD', 'Engleza original', '1920x1080', 122);
    insert_versiune('Joker', 'HD', 'Subtitrat romana', '1920x1080', 122);
    insert_versiune('The Prestige', 'HD', 'Engleza original', '1920x1080', 130);
    insert_versiune('Whiplash', 'HD', 'Engleza original', '1920x1080', 107);
    insert_versiune('Whiplash', 'HD', 'Subtitrat romana', '1920x1080', 107);
    insert_versiune('Black Swan','HD', 'Engleza original', '1920x1080', 108);
    insert_versiune('The Revenant', '4K', 'Engleza original', '3840x2160', 156);
    insert_versiune('The Revenant', 'HD', 'Subtitrat romana', '1920x1080', 156);
    insert_versiune('No Country for Old Men', 'HD', 'Engleza original', '1920x1080', 122);
    insert_versiune('Avengers: Endgame','4K', 'Engleza original', '3840x2160', 181);
    insert_versiune('Avengers: Endgame', 'HD',  'Dublat romana', '1920x1080', 181);
    insert_versiune('Everything Everywhere All at Once', 'HD', 'Engleza original', '1920x1080', 139);
    insert_versiune('The Green Mile', 'HD', 'Engleza original', '1920x1080', 189);
    insert_versiune('The Green Mile', 'SD',  'Dublat romana',  '720x576', 189);
    insert_versiune('Braveheart', '4K',  'Engleza original',  '3840x2160', 178);
    insert_versiune('Memento', 'HD',  'Engleza original',  '1920x1080', 113);
    insert_versiune('Memento', 'HD',  'Subtitrat romana',  '1920x1080', 113);
    insert_versiune('Mad Max: Fury Road','4K',   'Engleza original', '3840x2160', 120);
    insert_versiune('Mad Max: Fury Road', 'HD',  'Dublat romana',  '1920x1080', 120);
    insert_versiune('Bohemian Rhapsody', 'HD',  'Engleza original', '1920x1080', 134);
    insert_versiune('Bohemian Rhapsody', 'HD',  'Subtitrat romana', '1920x1080', 134);
    COMMIT;
END;
/

-- ACTORI
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Marlon Brando', 'Marlon', 'Brando', DATE '1924-04-03');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Brad Pitt', 'Brad', 'Pitt', DATE '1963-12-18');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Viggo Mortensen', 'Viggo', 'Mortensen', DATE '1958-10-20');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Robert De Niro', 'Robert', 'De Niro', DATE '1943-08-17');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Kevin Spacey', 'Kevin', 'Spacey', DATE '1959-07-26');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Tom Hanks', 'Tom', 'Hanks',  DATE '1956-07-09');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Leonardo DiCaprio', 'Leonardo', 'DiCaprio', DATE '1974-11-11');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Joaquin Phoenix', 'Joaquin',  'Phoenix', DATE '1974-10-28');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Hugh Jackman','Hugh', 'Jackman', DATE '1968-10-12');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Miles Teller', 'Miles', 'Teller', DATE '1987-02-20');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Natalie Portman', 'Natalie', 'Portman', DATE '1981-06-09');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Tom Hardy', 'Tom', 'Hardy', DATE '1977-09-15');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Javier Bardem', 'Javier', 'Bardem', DATE '1969-03-01');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Robert Downey Jr.', 'Robert', 'Downey Jr.', DATE '1965-04-04');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Michelle Yeoh', 'Michelle', 'Yeoh', DATE '1962-08-06');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Michael Clarke Duncan', 'Michael', 'Clarke Duncan', DATE '1957-12-10');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Mel Gibson', 'Mel', 'Gibson', DATE '1956-01-03');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Guy Pearce', 'Guy', 'Pearce', DATE '1967-10-05');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Charlize Theron', 'Charlize', 'Theron', DATE '1975-08-07');
INSERT INTO ACTORI (nume_scena, prenume, nume_familie, data_nastere) VALUES ('Rami Malek', 'Rami', 'Malek', DATE '1981-05-12');

COMMIT;

-- DISTRIBUTIE
DECLARE
    PROCEDURE insert_distributie(p_titlu VARCHAR2, p_prenume VARCHAR2, p_familie VARCHAR2, p_personaj VARCHAR2, p_tip VARCHAR2) IS
        v_film_id  NUMBER;
        v_actor_id NUMBER;
    BEGIN
        SELECT film_id  INTO v_film_id  FROM FILME  WHERE titlu = p_titlu;
        SELECT actor_id INTO v_actor_id FROM ACTORI WHERE prenume = p_prenume AND nume_familie = p_familie;
        INSERT INTO DISTRIBUTIE (film_id, actor_id, nume_personaj, tip_rol)
        VALUES (v_film_id, v_actor_id, p_personaj, p_tip);
    END;
BEGIN
    insert_distributie('The Godfather', 'Marlon', 'Brando', 'Vito Corleone', 'PRINCIPAL');
    insert_distributie('Fight Club', 'Brad', 'Pitt', 'Tyler Durden', 'PRINCIPAL');
    insert_distributie('The Lord of the Rings: The Fellowship of the Ring', 'Viggo', 'Mortensen', 'Aragorn', 'PRINCIPAL');
    insert_distributie('Goodfellas', 'Robert', 'De Niro', 'Jimmy Conway', 'PRINCIPAL');
    insert_distributie('Se7en', 'Brad', 'Pitt', 'Detective Mills', 'PRINCIPAL');
    insert_distributie('Se7en', 'Kevin', 'Spacey', 'John Doe', 'SECUNDAR');
    insert_distributie('Saving Private Ryan', 'Tom', 'Hanks', 'Căpitan Miller', 'PRINCIPAL');
    insert_distributie('Titanic', 'Leonardo', 'DiCaprio', 'Jack Dawson', 'PRINCIPAL');
    insert_distributie('Joker', 'Joaquin',  'Phoenix', 'Arthur Fleck', 'PRINCIPAL');
    insert_distributie('The Prestige', 'Hugh', 'Jackman','Robert Angier', 'PRINCIPAL');
    insert_distributie('Whiplash', 'Miles', 'Teller', 'Andrew Neiman', 'PRINCIPAL');
    insert_distributie('Black Swan', 'Natalie',  'Portman', 'Nina Sayers', 'PRINCIPAL');
    insert_distributie('The Revenant', 'Leonardo', 'DiCaprio', 'Hugh Glass', 'PRINCIPAL');
    insert_distributie('No Country for Old Men', 'Javier', 'Bardem', 'Anton Chigurh', 'PRINCIPAL');
    insert_distributie('Avengers: Endgame', 'Robert', 'Downey Jr.', 'Tony Stark', 'PRINCIPAL');
    insert_distributie('Everything Everywhere All at Once', 'Michelle', 'Yeoh', 'Evelyn Wang', 'PRINCIPAL');
    insert_distributie('The Green Mile','Tom', 'Hanks', 'Paul Edgecomb', 'PRINCIPAL');
    insert_distributie('The Green Mile','Michael',  'Clarke Duncan', 'John Coffey', 'PRINCIPAL');
    insert_distributie('Braveheart', 'Mel', 'Gibson', 'William Wallace', 'PRINCIPAL');
    insert_distributie('Memento', 'Guy', 'Pearce',  'Leonard Shelby', 'PRINCIPAL');
    insert_distributie('Mad Max: Fury Road','Charlize', 'Theron','Imperator Furiosa', 'PRINCIPAL');
    insert_distributie('Mad Max: Fury Road', 'Tom','Hardy', 'Max Rockatansky','PRINCIPAL');
    insert_distributie('Bohemian Rhapsody', 'Rami', 'Malek', 'Freddie Mercury', 'PRINCIPAL');
    COMMIT;
END;
/

-- CLIENTI
DECLARE
    TYPE t_array IS VARRAY(10) OF VARCHAR2(100);
    
    v_prenume t_array := t_array('Cristian', 'Raluca', 'Bogdan', 'Simona', 'Florin', 'Andreea', 'Lucian', 'Roxana', 'Catalin', 'Larisa');
    v_nume t_array := t_array('Constantin', 'Moldovan', 'Nistor', 'Barbu', 'Popa', 'Lungu', 'Draghici', 'Zamfir', 'Olteanu', 'Apostol');
    v_telefon t_array := t_array('0711100200', '0722300400', '0733500600', '0744700800', '0755900100', '0766200300', '0777400500', '0788600700', '0721800900', '0732100200');
    v_email_prefix t_array := t_array('player', 'guest', 'test', 'contact', 'fakeuser', 'account', 'random', 'visitor', 'member', 'online');
    v_adresa t_array := t_array('Str. Lalelelor 7', 'Bd. Revolutiei 3', 'Str. Castanilor 12', 'Aleea Plopilor 9', 'Bd. Republicii 25', 'Str. Nordului 6', 'Calea Mosilor 33', 'Str. Lunii 4', 'Bd. Pacii 11', 'Pta. Unirii 2');
    v_oras t_array := t_array('Sibiu', 'Bacau', 'Pitesti', 'Arad', 'Deva', 'Targu Mures', 'Suceava', 'Buzau', 'Ramnicu Valcea', 'Alba Iulia');
    
    v_nr_clienti NUMBER;
    v_email VARCHAR2(150);
    
    pos_prenume NUMBER;
    pos_nume NUMBER;
    pos_telefon NUMBER;
    pos_email_prefix NUMBER;
    pos_adresa NUMBER;
    pos_oras NUMBER;
BEGIN
    v_nr_clienti := TRUNC(DBMS_RANDOM.VALUE(15, 31));
    
    FOR i IN 1..v_nr_clienti LOOP
        pos_prenume := TRUNC(DBMS_RANDOM.VALUE(1, v_prenume.count));
        pos_nume := TRUNC(DBMS_RANDOM.VALUE(1, v_nume.count));
        pos_telefon := TRUNC(DBMS_RANDOM.VALUE(1, v_telefon.count));
        pos_email_prefix := TRUNC(DBMS_RANDOM.VALUE(1, v_email_prefix.count));
        pos_adresa := TRUNC(DBMS_RANDOM.VALUE(1, v_adresa.count));
        pos_oras := TRUNC(DBMS_RANDOM.VALUE(1, v_oras.count));
        
        v_email := v_email_prefix(pos_email_prefix) || i || '@gmail.com';
        
        INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
        VALUES (
            v_prenume(pos_prenume), 
            v_nume(pos_nume), 
            v_telefon(pos_telefon), 
            v_email, 
            v_adresa(pos_adresa), 
            v_oras(pos_oras)
        );
    END LOOP;
    
    COMMIT;
END;
/

-- VIZUALIZARI
DECLARE
    TYPE t_id_list IS VARRAY(100) OF NUMBER;
    v_total NUMBER;
    
    v_id_versiuni t_id_list;
    v_id_useri t_id_list;
    
    CURSOR cursor_versiuni IS SELECT versiune_id FROM VERSIUNI_FILME;
    CURSOR cursor_useri IS SELECT client_id FROM CLIENTI;
    
    v_durata_reala NUMBER(4);
    v_durata_ref NUMBER(4);
    v_stare VARCHAR2(20);
    v_stare_nmb NUMBER;
    pos_versiune NUMBER;
    pos_user NUMBER;
BEGIN
    v_total := TRUNC(DBMS_RANDOM.VALUE(15, 31));
    
    OPEN cursor_versiuni;
    FETCH cursor_versiuni BULK COLLECT INTO v_id_versiuni LIMIT 100;
    CLOSE cursor_versiuni;
    
    OPEN cursor_useri;
    FETCH cursor_useri BULK COLLECT INTO v_id_useri LIMIT 100;
    CLOSE cursor_useri;
    
    FOR i IN 1..v_total LOOP
        pos_versiune := TRUNC(DBMS_RANDOM.VALUE(1, v_id_versiuni.count + 1));
        pos_user     := TRUNC(DBMS_RANDOM.VALUE(1, v_id_useri.count + 1));
        v_stare_nmb  := TRUNC(DBMS_RANDOM.VALUE(0, 3));
        
        SELECT durata_minute INTO v_durata_ref
        FROM VERSIUNI_FILME
        WHERE versiune_id = v_id_versiuni(pos_versiune);
        
        CASE v_stare_nmb
            WHEN 0 THEN
                v_stare := 'COMPLET';
                v_durata_reala := v_durata_ref;
            WHEN 1 THEN
                v_stare := 'PARTIAL';
                v_durata_reala := ROUND(v_durata_ref * DBMS_RANDOM.VALUE(0.5, 0.8));
            ELSE
                v_stare := 'ABANDONAT';
                v_durata_reala := ROUND(v_durata_ref * DBMS_RANDOM.VALUE(0.05, 0.5));
        END CASE;
        
        INSERT INTO VIZUALIZARI (client_id, versiune_id, data_vizualizare, durata_efectiva, status)
        VALUES (
            v_id_useri(pos_user),
            v_id_versiuni(pos_versiune),
            SYSDATE - DBMS_RANDOM.VALUE(1, 365),
            v_durata_reala,
            v_stare
        );
    END LOOP;
END;
/

-- VOTURI
DECLARE
    v_inserari_total NUMBER;
    TYPE t_id_list IS VARRAY(100) OF NUMBER;
    v_id_clienti t_id_list;
    v_id_filme t_id_list;
    
    CURSOR cursor_clienti IS SELECT client_id FROM CLIENTI;
    CURSOR cursor_filme IS SELECT film_id FROM FILME;
    
    idx_client NUMBER;
    idx_film NUMBER;
    v_scor NUMBER;
BEGIN
    v_inserari_total := TRUNC(DBMS_RANDOM.VALUE(15, 31));
    
    OPEN cursor_filme;
    FETCH cursor_filme BULK COLLECT INTO v_id_filme;
    CLOSE cursor_filme;
    
    OPEN cursor_clienti;
    FETCH cursor_clienti BULK COLLECT INTO v_id_clienti;
    CLOSE cursor_clienti;
    
    FOR i IN 1..v_inserari_total LOOP
        idx_client := TRUNC(DBMS_RANDOM.VALUE(1, v_id_clienti.count + 1));
        idx_film   := TRUNC(DBMS_RANDOM.VALUE(1, v_id_filme.count + 1));
        
        v_scor := TRUNC(DBMS_RANDOM.VALUE(1, 11));
        
        BEGIN
            INSERT INTO VOTURI (client_id, film_id, scor, data_vot)
            VALUES (
                v_id_clienti(idx_client),
                v_id_filme(idx_film),
                v_scor,
                SYSDATE - DBMS_RANDOM.VALUE(1, 365)
            );
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL;
        END;
    END LOOP;
END;
/

-- OPTIUNI_PREDEFINITE
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Cinematografie remarcabila', 'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Scenariu slab', 'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Regie excelenta', 'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Actorie de exceptie', 'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Ritmul naratiunii lent', 'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('As recomanda prietenilor', 'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Personaje bine construite','POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Efecte vizuale spectaculoase','POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Final dezamagitor', 'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Coloana sonora memorabila', 'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Prea multa violenta', 'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Prea lung', 'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Subiect de actualitate', 'NEUTRU');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Final neasteptat', 'NEUTRU');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Dialoguri remarcabile', 'POZITIV');

COMMIT;
/

-- CLIENTI_FILME_OPTIUNI
DECLARE
    TYPE t_id_list IS VARRAY(200) OF NUMBER;
    v_total NUMBER;
    
    v_list_optiuni  t_id_list;
    v_list_filme    t_id_list;
    v_list_clienti  t_id_list;
    
    CURSOR cursor_optiuni IS SELECT optiune_id FROM OPTIUNI_PREDEFINITE;
    CURSOR cursor_filme IS SELECT film_id FROM FILME;
    CURSOR cursor_clienti IS SELECT client_id FROM CLIENTI;
    
    pos_optiune NUMBER;
    pos_film NUMBER;
    pos_client NUMBER;
BEGIN
    v_total := TRUNC(DBMS_RANDOM.VALUE(30, 60));
    
    OPEN cursor_optiuni;
    FETCH cursor_optiuni BULK COLLECT INTO v_list_optiuni LIMIT 200;
    CLOSE cursor_optiuni;
    
    OPEN cursor_filme;
    FETCH cursor_filme BULK COLLECT INTO v_list_filme LIMIT 200;
    CLOSE cursor_filme;
    
    OPEN cursor_clienti;
    FETCH cursor_clienti BULK COLLECT INTO v_list_clienti LIMIT 200;
    CLOSE cursor_clienti;
    
    FOR i IN 1..v_total LOOP
        pos_optiune := TRUNC(DBMS_RANDOM.VALUE(1, v_list_optiuni.count + 1));
        pos_film    := TRUNC(DBMS_RANDOM.VALUE(1, v_list_filme.count + 1));
        pos_client  := TRUNC(DBMS_RANDOM.VALUE(1, v_list_clienti.count + 1));
        
        BEGIN
            INSERT INTO CLIENTI_FILME_OPTIUNI (client_id, film_id, optiune_id, data_selectie)
            VALUES (
                v_list_clienti(pos_client),
                v_list_filme(pos_film),
                v_list_optiuni(pos_optiune),
                SYSDATE - DBMS_RANDOM.VALUE(1, 365)
            );
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL;
        END;
    END LOOP;
    
    COMMIT;
END;
/

-- COMENTARII
DECLARE
    TYPE t_id_list IS VARRAY(200) OF NUMBER;
    TYPE t_str IS VARRAY(20) OF VARCHAR2(2000);
    
    v_total NUMBER;
    
    v_comentarii t_str := t_str(
        'O capodopera absoluta, unul din cele mai bune filme pe care le-am vazut vreodata.',
        'Total dezamagitor, scenariu predictibil si fara substanta. Nu recomand.',
        'M-a emotionat profund, am plans la final. O experienta cinematografica unica!',
        'Plictisitor si prea lung, nu am putut sa-l termin. Pierdere de timp.',
        'Efecte vizuale uimitoare, o productie de exceptie din toate punctele de vedere.',
        'Unul din filmele care iti schimba perspectiva asupra vietii. Pur si simplu genial!',
        'Banal si previzibil, ma asteptam la mult mai mult. O dezamagire.',
        'Coloana sonora perfecta, actorie superba. M-a impresionat enorm.',
        'Nu mi-a placut deloc, prost filmat si fara sens. Groaznic!',
        'Regie impecabila si interpretare actoriceasca de exceptie. Bravo!',
        'Un concept interesant cu o rasturnare de situatie total neasteptata.',
        'Prea multa violenta pentru gustul meu, nu il recomand.',
        'Am ramas fara cuvinte dupa vizionare. Il voi revedea cu siguranta!',
        'Dialogurile sunt slabe si personajele greu de urmarit. Dezamagitor.',
        'O poveste umana autentica, sincera si profund emotionanta.',
        'Nu am inteles mesajul filmului, m-am simtit confuz la final.',
        'Un film cu adevarat remarcabil. Regizorul a facut o treaba fantastica!',
        'Mediocru, nici bun nici rau. Cateva momente bune izolate.',
        'Cel mai frumos film pe care l-am vazut in ultimii ani. Superb!',
        'Slab realizat si neterminat ca idee. O dezamagire totala.'
    );
    
    v_list_filme    t_id_list;
    v_list_clienti  t_id_list;
    
    CURSOR cursor_filme   IS SELECT film_id   FROM FILME;
    CURSOR cursor_clienti IS SELECT client_id FROM CLIENTI;
    
    pos_film   NUMBER;
    pos_client NUMBER;
    pos_comentariu   NUMBER;
BEGIN
    v_total := TRUNC(DBMS_RANDOM.VALUE(20, 40));
    
    OPEN cursor_filme;
    FETCH cursor_filme BULK COLLECT INTO v_list_filme LIMIT 200;
    CLOSE cursor_filme;
    
    OPEN cursor_clienti;
    FETCH cursor_clienti BULK COLLECT INTO v_list_clienti LIMIT 200;
    CLOSE cursor_clienti;
    
    FOR i IN 1..v_total LOOP
        pos_film   := TRUNC(DBMS_RANDOM.VALUE(1, v_list_filme.count + 1));
        pos_client := TRUNC(DBMS_RANDOM.VALUE(1, v_list_clienti.count + 1));
        pos_comentariu   := TRUNC(DBMS_RANDOM.VALUE(1, v_comentarii.count + 1));
        
        INSERT INTO COMENTARII (client_id, film_id, text_comentariu, data_comentariu)
        VALUES (
            v_list_clienti(pos_client),
            v_list_filme(pos_film),
            v_comentarii(pos_comentariu),
            SYSDATE - DBMS_RANDOM.VALUE(1, 365)
        );
    END LOOP;
    
    COMMIT;
END;
/

-- COMENTARII_ACTORI

DECLARE
    TYPE t_id_list IS VARRAY(200) OF NUMBER;
    v_total NUMBER;
    
    v_list_actori     t_id_list;
    v_list_comentarii t_id_list;
    
    CURSOR cursor_actori IS SELECT actor_id  FROM ACTORI;
    CURSOR cursor_comentarii IS SELECT comentariu_id FROM COMENTARII;
    
    pos_actor      NUMBER;
    pos_comentariu NUMBER;
BEGIN
    v_total := TRUNC(DBMS_RANDOM.VALUE(15, 30));
    
    OPEN cursor_actori;
    FETCH cursor_actori BULK COLLECT INTO v_list_actori LIMIT 200;
    CLOSE cursor_actori;
    
    OPEN cursor_comentarii;
    FETCH cursor_comentarii BULK COLLECT INTO v_list_comentarii LIMIT 200;
    CLOSE cursor_comentarii;
    
    FOR i IN 1..v_total LOOP
        pos_actor := TRUNC(DBMS_RANDOM.VALUE(1, v_list_actori.count + 1));
        pos_comentariu := TRUNC(DBMS_RANDOM.VALUE(1, v_list_comentarii.count + 1));
        
        BEGIN
            INSERT INTO COMENTARII_ACTORI (comentariu_id, actor_id)
            VALUES (
                v_list_comentarii(pos_comentariu),
                v_list_actori(pos_actor)
            );
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                NULL;
        END;
    END LOOP;
    
    COMMIT;
END;
/


