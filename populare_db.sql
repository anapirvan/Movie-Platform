-- 1. CATEGORII
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

-- 2. FILME
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Godfather',                          'Șeful îmbătrânit al unui clan mafiot cedează conducerea fiului cel mic, declanșând un război sângeros între familii.',                     DATE '1972-03-24');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Fight Club',                             'Un angajat nemulțumit și un vânzător de săpun charismatic fondează un club de lupte clandestin cu scopuri din ce în ce mai sinistre.',   DATE '1999-10-15');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Lord of the Rings: The Fellowship of the Ring', 'Un hobbit pornește într-o călătorie epică alături de o ceată eterogenă pentru a distruge un inel al răului.',                DATE '2001-12-19');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Goodfellas',                             'Ascensiunea și căderea unui mafiot din New York, văzute din interior de-a lungul a trei decenii.',                                        DATE '1990-09-21');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Se7en',                                  'Doi detectivi cu personalități opuse vânează un ucigaș în serie care-și modelează crimele după cele șapte păcate capitale.',             DATE '1995-09-22');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Saving Private Ryan',                    'Un pluton de soldați americani primește misiunea periculoasă de a găsi și repatria un soldat al cărui frați au murit în luptă.',         DATE '1998-07-24');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Titanic',                                'O poveste de dragoste imposibilă între o fată din înalta societate și un tânăr sărac la bordul celebrului transatlantic condamnat.',      DATE '1997-12-19');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Joker',                                  'Un comedian ratat și marginalizat din Gotham City se transformă treptat în cel mai temut criminal al orașului.',                         DATE '2019-10-04');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Prestige',                           'Doi magicieni rivali se întrec în trucuri din ce în ce mai periculoase, obsesia distrugând totul în jurul lor.',                         DATE '2006-10-20');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Whiplash',                               'Un tânăr baterist ambițios intră sub tutela unui instructor de conservator extrem de sever și imprevizibil.',                            DATE '2014-10-10');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Black Swan',                             'O balerină perfectă se destramă psihologic în timp ce pregătește rolul principal din Lacul Lebedelor.',                                  DATE '2010-12-17');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Revenant',                           'Un explorator lăsat pentru mort de propriii tovarăși luptă pentru supraviețuire și răzbunare în sălbăticia americană.',                  DATE '2015-12-25');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('No Country for Old Men',                 'Un vânător dă peste o sumă uriașă de bani și devine urmărit de un asasin fără milă și fără logică.',                                    DATE '2007-11-09');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Avengers: Endgame',                      'Supereroii supraviețuitori încearcă să inverseze consecințele devastatoare ale acțiunilor lui Thanos.',                                   DATE '2019-04-26');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Everything Everywhere All at Once',      'O femeie descoperă că poate accesa universuri paralele și trebuie să oprească o forță care amenință întreaga existență.',                 DATE '2022-03-25');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('The Green Mile',                         'Un ofițer de penitenciar face cunoștință cu un deținut condamnat la moarte care posedă puteri misterioase de vindecare.',                DATE '1999-12-10');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Braveheart',                             'William Wallace conduce poporul scoțian în lupta pentru independența față de coroana engleză opresivă.',                                 DATE '1995-05-24');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Memento',                                'Un bărbat fără memorie pe termen scurt încearcă să-și găsească soția ucisă folosind notițe și tatuaje.',                                DATE '2000-09-05');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Mad Max: Fury Road',                     'Într-o lume post-apocaliptică, Max și Furiosa fug de un tiran crud printr-un deșert nesfârșit.',                                        DATE '2015-05-15');
INSERT INTO FILME (titlu, descriere, data_lansare) VALUES ('Bohemian Rhapsody',                      'Viața și cariera legendarei trupe Queen, culminând cu spectaculosul concert Live Aid din 1985.',                                        DATE '2018-10-24');

COMMIT;

-- 2b. FILM_CATEGORII
DECLARE
    PROCEDURE fc(p_titlu VARCHAR2, p_cat VARCHAR2) IS
        v_fid NUMBER; v_cid NUMBER;
    BEGIN
        SELECT film_id      INTO v_fid FROM FILME     WHERE titlu    = p_titlu;
        SELECT categorie_id INTO v_cid FROM CATEGORII WHERE denumire = p_cat;
        INSERT INTO FILM_CATEGORII (film_id, categorie_id) VALUES (v_fid, v_cid);
    END;
BEGIN
    fc('The Godfather', 'Dramă');                fc('The Godfather', 'Suspans');              fc('The Godfather', 'Mister');

    fc('Fight Club', 'Dramă');                   fc('Fight Club', 'Suspans');                 fc('Fight Club', 'Acțiune');
    
    fc('The Lord of the Rings: The Fellowship of the Ring', 'Aventură');
    fc('The Lord of the Rings: The Fellowship of the Ring', 'Fantezie');
    fc('The Lord of the Rings: The Fellowship of the Ring', 'Acțiune');
   
    fc('Goodfellas', 'Dramă');                   fc('Goodfellas', 'Suspans');                 fc('Goodfellas', 'Mister');
    
    fc('Se7en', 'Suspans');                      fc('Se7en', 'Groază');                       fc('Se7en', 'Mister');
   
    fc('Saving Private Ryan', 'Război');         fc('Saving Private Ryan', 'Dramă');          fc('Saving Private Ryan', 'Acțiune');
    
    fc('Titanic', 'Romantic');                   fc('Titanic', 'Dramă');
    
    fc('Joker', 'Dramă');                        fc('Joker', 'Suspans');                      fc('Joker', 'Groază');
    
    fc('The Prestige', 'Dramă');                 fc('The Prestige', 'Mister');                fc('The Prestige', 'Suspans');
   
    fc('Whiplash', 'Dramă');                     fc('Whiplash', 'Muzical');
    
    fc('Black Swan', 'Dramă');                   fc('Black Swan', 'Suspans');                 fc('Black Swan', 'Groază');
    
    fc('The Revenant', 'Aventură');              fc('The Revenant', 'Dramă');                 fc('The Revenant', 'Acțiune');
    
    fc('No Country for Old Men', 'Suspans');     fc('No Country for Old Men', 'Dramă');       fc('No Country for Old Men', 'Western');
    
    fc('Avengers: Endgame', 'Acțiune');          fc('Avengers: Endgame', 'Sci-Fi');           fc('Avengers: Endgame', 'Aventură');
    
    fc('Everything Everywhere All at Once', 'Sci-Fi');
    fc('Everything Everywhere All at Once', 'Comedie');
    fc('Everything Everywhere All at Once', 'Acțiune');
    
    fc('The Green Mile', 'Dramă');               fc('The Green Mile', 'Mister');
    
    fc('Braveheart', 'Război');                  fc('Braveheart', 'Dramă');                   fc('Braveheart', 'Istoric');
   
    fc('Memento', 'Mister');                     fc('Memento', 'Suspans');                    fc('Memento', 'Dramă');
    
    fc('Mad Max: Fury Road', 'Acțiune');         fc('Mad Max: Fury Road', 'Sci-Fi');          fc('Mad Max: Fury Road', 'Aventură');
    
    fc('Bohemian Rhapsody', 'Biografie');        fc('Bohemian Rhapsody', 'Dramă');            fc('Bohemian Rhapsody', 'Muzical');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[info]: FILM_CATEGORII populat: ' || SQL%ROWCOUNT || ' asocieri.');
END;
/

-- 3. VERSIUNI_FILM
DECLARE
    PROCEDURE add_versiune(p_titlu VARCHAR2, p_format VARCHAR2, p_limba VARCHAR2, p_rez VARCHAR2, p_dur NUMBER) IS
        v_film_id NUMBER;
    BEGIN
        SELECT film_id INTO v_film_id FROM FILME WHERE titlu = p_titlu;
        INSERT INTO VERSIUNI_FILM (film_id, format, limba, rezolutie, durata_minute)
        VALUES (v_film_id, p_format, p_limba, p_rez, p_dur);
    END;
BEGIN
    add_versiune('The Godfather',          '4K',  'Engleza original',  '3840x2160', 175);
    add_versiune('The Godfather',          'HD',  'Subtitrat romana',  '1920x1080', 175);
    add_versiune('Fight Club',             'HD',  'Engleza original',  '1920x1080', 139);
    add_versiune('Fight Club',             'HD',  'Dublat romana',     '1920x1080', 139);
    add_versiune('The Lord of the Rings: The Fellowship of the Ring', '4K', 'Engleza original', '3840x2160', 178);
    add_versiune('The Lord of the Rings: The Fellowship of the Ring', 'HD', 'Subtitrat romana', '1920x1080', 178);
    add_versiune('Goodfellas',             'HD',  'Engleza original',  '1920x1080', 146);
    add_versiune('Goodfellas',             'SD',  'Subtitrat romana',  '720x576',   146);
    add_versiune('Se7en',                  'HD',  'Engleza original',  '1920x1080', 127);
    add_versiune('Se7en',                  'HD',  'Dublat romana',     '1920x1080', 127);
    add_versiune('Saving Private Ryan',    '4K',  'Engleza original',  '3840x2160', 169);
    add_versiune('Saving Private Ryan',    'HD',  'Subtitrat romana',  '1920x1080', 169);
    add_versiune('Titanic',                '4K',  'Engleza original',  '3840x2160', 194);
    add_versiune('Titanic',                'HD',  'Dublat romana',     '1920x1080', 194);
    add_versiune('Joker',                  'HD',  'Engleza original',  '1920x1080', 122);
    add_versiune('Joker',                  'HD',  'Subtitrat romana',  '1920x1080', 122);
    add_versiune('The Prestige',           'HD',  'Engleza original',  '1920x1080', 130);
    add_versiune('Whiplash',               'HD',  'Engleza original',  '1920x1080', 107);
    add_versiune('Whiplash',               'HD',  'Subtitrat romana',  '1920x1080', 107);
    add_versiune('Black Swan',             'HD',  'Engleza original',  '1920x1080', 108);
    add_versiune('The Revenant',           '4K',  'Engleza original',  '3840x2160', 156);
    add_versiune('The Revenant',           'HD',  'Subtitrat romana',  '1920x1080', 156);
    add_versiune('No Country for Old Men', 'HD',  'Engleza original',  '1920x1080', 122);
    add_versiune('Avengers: Endgame',      '4K',  'Engleza original',  '3840x2160', 181);
    add_versiune('Avengers: Endgame',      'HD',  'Dublat romana',     '1920x1080', 181);
    add_versiune('Everything Everywhere All at Once', 'HD', 'Engleza original', '1920x1080', 139);
    add_versiune('The Green Mile',         'HD',  'Engleza original',  '1920x1080', 189);
    add_versiune('The Green Mile',         'SD',  'Dublat romana',     '720x576',   189);
    add_versiune('Braveheart',             '4K',  'Engleza original',  '3840x2160', 178);
    add_versiune('Memento',                'HD',  'Engleza original',  '1920x1080', 113);
    add_versiune('Memento',                'HD',  'Subtitrat romana',  '1920x1080', 113);
    add_versiune('Mad Max: Fury Road',     '4K',  'Engleza original',  '3840x2160', 120);
    add_versiune('Mad Max: Fury Road',     'HD',  'Dublat romana',     '1920x1080', 120);
    add_versiune('Bohemian Rhapsody',      'HD',  'Engleza original',  '1920x1080', 134);
    add_versiune('Bohemian Rhapsody',      'HD',  'Subtitrat romana',  '1920x1080', 134);
    COMMIT;
END;
/

-- 4. ACTORI
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Marlon',   'Brando',        DATE '1924-04-03');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Brad',     'Pitt',          DATE '1963-12-18');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Viggo',    'Mortensen',     DATE '1958-10-20');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Robert',   'De Niro',       DATE '1943-08-17');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Kevin',    'Spacey',        DATE '1959-07-26');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Tom',      'Hanks',         DATE '1956-07-09');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Leonardo', 'DiCaprio',      DATE '1974-11-11');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Joaquin',  'Phoenix',       DATE '1974-10-28');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Hugh',     'Jackman',       DATE '1968-10-12');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Miles',    'Teller',        DATE '1987-02-20');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Natalie',  'Portman',       DATE '1981-06-09');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Tom',      'Hardy',         DATE '1977-09-15');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Javier',   'Bardem',        DATE '1969-03-01');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Robert',   'Downey Jr.',    DATE '1965-04-04');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Michelle', 'Yeoh',          DATE '1962-08-06');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Michael',  'Clarke Duncan', DATE '1957-12-10');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Mel',      'Gibson',        DATE '1956-01-03');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Guy',      'Pearce',        DATE '1967-10-05');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Charlize', 'Theron',        DATE '1975-08-07');
INSERT INTO ACTORI (prenume, nume_familie, data_nastere) VALUES ('Rami',     'Malek',         DATE '1981-05-12');

COMMIT;

-- 5. DISTRIBUTIE
DECLARE
    PROCEDURE add_dist(p_titlu VARCHAR2, p_prenume VARCHAR2, p_familie VARCHAR2,
                       p_personaj VARCHAR2, p_tip VARCHAR2) IS
        v_film_id  NUMBER;
        v_actor_id NUMBER;
    BEGIN
        SELECT film_id  INTO v_film_id  FROM FILME  WHERE titlu       = p_titlu;
        SELECT actor_id INTO v_actor_id FROM ACTORI WHERE prenume     = p_prenume
                                                     AND nume_familie = p_familie;
        INSERT INTO DISTRIBUTIE (film_id, actor_id, nume_personaj, tip_rol)
        VALUES (v_film_id, v_actor_id, p_personaj, p_tip);
    END;
BEGIN
    add_dist('The Godfather',          'Marlon',   'Brando',        'Vito Corleone',        'PRINCIPAL');
    add_dist('Fight Club',             'Brad',     'Pitt',          'Tyler Durden',         'PRINCIPAL');
    add_dist('The Lord of the Rings: The Fellowship of the Ring',
                                       'Viggo',    'Mortensen',     'Aragorn',              'PRINCIPAL');
    add_dist('Goodfellas',             'Robert',   'De Niro',       'Jimmy Conway',         'PRINCIPAL');
    add_dist('Se7en',                  'Brad',     'Pitt',          'Detective Mills',      'PRINCIPAL');
    add_dist('Se7en',                  'Kevin',    'Spacey',        'John Doe',             'SECUNDAR');
    add_dist('Saving Private Ryan',    'Tom',      'Hanks',         'Căpitan Miller',       'PRINCIPAL');
    add_dist('Titanic',                'Leonardo', 'DiCaprio',      'Jack Dawson',          'PRINCIPAL');
    add_dist('Joker',                  'Joaquin',  'Phoenix',       'Arthur Fleck',         'PRINCIPAL');
    add_dist('The Prestige',           'Hugh',     'Jackman',       'Robert Angier',        'PRINCIPAL');
    add_dist('Whiplash',               'Miles',    'Teller',        'Andrew Neiman',        'PRINCIPAL');
    add_dist('Black Swan',             'Natalie',  'Portman',       'Nina Sayers',          'PRINCIPAL');
    add_dist('The Revenant',           'Leonardo', 'DiCaprio',      'Hugh Glass',           'PRINCIPAL');
    add_dist('No Country for Old Men', 'Javier',   'Bardem',        'Anton Chigurh',        'PRINCIPAL');
    add_dist('Avengers: Endgame',      'Robert',   'Downey Jr.',    'Tony Stark',           'PRINCIPAL');
    add_dist('Everything Everywhere All at Once',
                                       'Michelle', 'Yeoh',          'Evelyn Wang',          'PRINCIPAL');
    add_dist('The Green Mile',         'Tom',      'Hanks',         'Paul Edgecomb',        'PRINCIPAL');
    add_dist('The Green Mile',         'Michael',  'Clarke Duncan', 'John Coffey',          'PRINCIPAL');
    add_dist('Braveheart',             'Mel',      'Gibson',        'William Wallace',      'PRINCIPAL');
    add_dist('Memento',                'Guy',      'Pearce',        'Leonard Shelby',       'PRINCIPAL');
    add_dist('Mad Max: Fury Road',     'Charlize', 'Theron',        'Imperator Furiosa',    'PRINCIPAL');
    add_dist('Mad Max: Fury Road',     'Tom',      'Hardy',         'Max Rockatansky',      'PRINCIPAL');
    add_dist('Bohemian Rhapsody',      'Rami',     'Malek',         'Freddie Mercury',      'PRINCIPAL');
    COMMIT;
END;
/

-- 6. CLIENTI
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Teodora',   'Manolescu', '0232145678', 'teodora.m@email.ro',      'Str. Independentei 12',   'Iasi');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Victor',    'Petrescu',  '0232256789', 'victor.p@email.ro',       'Bd. Stefan cel Mare 3',   'Iasi');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Madalina',  'Rusu',      '0213367890', 'madalina.r@gmail.com',    'Str. Doamnei 7',          'Bucuresti');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('George',    'Ciobanu',   '0213478901', 'george.c@yahoo.com',      'Calea Mosilor 14',        'Bucuresti');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Andreea',   'Moldovan',  '0264589012', 'andreea.mol@email.ro',    'Str. Memorandumului 9',   'Cluj-Napoca');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Ionut',     'Cristea',   '0264690123', 'ionut.cr@email.ro',       'Str. Observatorului 21',  'Cluj-Napoca');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Roxana',    'Florescu',  '0256701234', 'roxana.fl@gmail.com',     'Str. Mihai Eminescu 5',   'Timisoara');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Lucian',    'Dinu',      '0256812345', 'lucian.dinu@email.ro',    'Bd. Take Ionescu 18',     'Timisoara');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Oana',      'Serban',    '0269923456', 'oana.serban@yahoo.com',   'Str. Castanilor 6',       'Brasov');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Mihnea',    'Dutu',      '0269034567', 'mihnea.d@gmail.com',      'Str. Nicolae Balcescu 2', 'Brasov');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Sorina',    'Blaga',     '0232123123', 'sorina.blaga@email.ro',   'Str. Garii 11',           'Iasi');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Razvan',    'Apostol',   '0213234234', 'razvan.ap@email.ro',      'Str. Academiei 4',        'Bucuresti');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Bianca',    'Toma',      '0264345345', 'bianca.toma@yahoo.com',   'Str. Horea 8',            'Cluj-Napoca');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Dragos',    'Ene',       '0256456456', 'dragos.ene@gmail.com',    'Str. Circumvalatiunii 3', 'Timisoara');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Alina',     'Neagu',     '0232567567', 'alina.neagu@email.ro',    'Str. Lapusneanu 15',      'Iasi');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Catalin',   'Moraru',    '0213678678', 'catalin.mor@email.ro',    'Str. Polona 9',           'Bucuresti');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Petronela', 'Ionita',    '0264789789', 'petronela.i@gmail.com',   'Bd. 21 Decembrie 7',      'Cluj-Napoca');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Silviu',    'Bucur',     '0269890890', 'silviu.bucur@yahoo.com',  'Str. Cuza Voda 13',       'Brasov');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Adriana',   'Chirita',   '0256901901', 'adriana.ch@email.ro',     'Str. Gh. Dima 16',        'Timisoara');
INSERT INTO CLIENTI (prenume, nume, telefon, email, adresa, oras)
VALUES ('Serban',    'Ungureanu', '0232012012', 'serban.ung@email.ro',     'Str. Rozelor 5',          'Iasi');

COMMIT;

-- 7. OPTIUNI_PREDEFINITE
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Cinematografie remarcabila',   'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Scenariu slab',                'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Regie excelenta',              'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Actorie de exceptie',          'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Ritmul naratiunii lent',       'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('As recomanda prietenilor',     'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Personaje bine construite',    'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Efecte vizuale spectaculoase', 'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Final dezamagitor',            'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Coloana sonora memorabila',    'POZITIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Prea multa violenta',          'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Prea lung',                    'NEGATIV');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Subiect de actualitate',       'NEUTRU');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Final neasteptat',             'NEUTRU');
INSERT INTO OPTIUNI_PREDEFINITE (denumire, tip) VALUES ('Dialoguri remarcabile',        'POZITIV');

COMMIT;

-- 8. VIZUALIZARI
DECLARE
    TYPE t_num IS TABLE OF NUMBER;
    v_clienti   t_num;
    v_versiuni  t_num;
    v_viz_date  DATE;
    v_status    VARCHAR2(20);
    v_durata    NUMBER;
    v_ver_dur   NUMBER;
    v_idx       NUMBER := 1;
BEGIN
    SELECT client_id   BULK COLLECT INTO v_clienti  FROM CLIENTI      ORDER BY client_id;
    SELECT versiune_id BULK COLLECT INTO v_versiuni FROM VERSIUNI_FILM ORDER BY versiune_id;

    FOR i IN 1..v_clienti.COUNT LOOP
        FOR j IN 1..3 LOOP
            v_idx := MOD((i * 3 + j - 1), v_versiuni.COUNT) + 1;

            v_viz_date := SYSDATE - DBMS_RANDOM.VALUE(1, 365);

            SELECT durata_minute INTO v_ver_dur
            FROM VERSIUNI_FILM WHERE versiune_id = v_versiuni(v_idx);

            CASE MOD(i + j, 3)
                WHEN 0 THEN
                    v_status := 'COMPLETA';
                    v_durata := v_ver_dur;
                WHEN 1 THEN
                    v_status := 'PARTIALA';
                    v_durata := ROUND(v_ver_dur * DBMS_RANDOM.VALUE(0.2, 0.8));
                ELSE
                    v_status := 'ABANDONATA';
                    v_durata := ROUND(v_ver_dur * DBMS_RANDOM.VALUE(0.05, 0.2));
            END CASE;

            INSERT INTO VIZUALIZARI (client_id, versiune_id, data_vizualizare,
                                     durata_efectiva, status)
            VALUES (v_clienti(i), v_versiuni(v_idx), v_viz_date, v_durata, v_status);
        END LOOP;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[info]: Vizualizari inserate: ' || SQL%ROWCOUNT);
END;
/

-- 9. VOTURI
DECLARE
    TYPE t_num IS TABLE OF NUMBER;
    v_clienti   t_num;
    v_filme     t_num;
    v_scor      NUMBER;
    v_film_idx  NUMBER;
BEGIN
    SELECT client_id BULK COLLECT INTO v_clienti FROM CLIENTI ORDER BY client_id;
    SELECT film_id   BULK COLLECT INTO v_filme   FROM FILME   ORDER BY film_id;

    FOR i IN 1..v_clienti.COUNT LOOP
        FOR j IN 1..5 LOOP
            v_film_idx := MOD((i * 5 + j - 1), v_filme.COUNT) + 1;
            v_scor     := ROUND(DBMS_RANDOM.VALUE(6, 10));

            BEGIN
                INSERT INTO VOTURI (client_id, film_id, scor, data_vot)
                VALUES (v_clienti(i), v_filme(v_film_idx), v_scor,
                        SYSDATE - DBMS_RANDOM.VALUE(1, 200));
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[info]: Voturi inserate. Ratingurile filmelor au fost actualizate automat.');
END;
/

-- 10. COMENTARII
DECLARE
    TYPE t_str IS TABLE OF VARCHAR2(2000);
    TYPE t_num IS TABLE OF NUMBER;
    v_texte t_str := t_str(
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
    v_clienti   t_num;
    v_filme     t_num;
    v_idx_text  NUMBER;
    v_film_idx  NUMBER;
BEGIN
    SELECT client_id BULK COLLECT INTO v_clienti FROM CLIENTI ORDER BY client_id;
    SELECT film_id   BULK COLLECT INTO v_filme   FROM FILME   ORDER BY film_id;

    FOR i IN 1..v_clienti.COUNT LOOP
        FOR j IN 1..2 LOOP
            v_film_idx := MOD((i * 2 + j), v_filme.COUNT) + 1;
            v_idx_text := MOD((i * 2 + j - 1), v_texte.COUNT) + 1;

            -- sentimentul e inserat de trigger
            INSERT INTO COMENTARII (client_id, film_id, text_comentariu, data_comentariu)
            VALUES (v_clienti(i), v_filme(v_film_idx), v_texte(v_idx_text),
                    SYSDATE - DBMS_RANDOM.VALUE(1, 180));
        END LOOP;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[info]: Comentarii inserate cu sentiment calculat automat de trigger.');
END;
/
--COMENTARII + COMENTARIU_ACTOR
DECLARE
    v_com_id    NUMBER;
    v_film_id   NUMBER;
    v_client_id NUMBER;

    PROCEDURE ins_com(p_email VARCHAR2, p_titlu VARCHAR2, p_text VARCHAR2) IS
    BEGIN
        SELECT client_id INTO v_client_id FROM CLIENTI WHERE email = p_email;
        SELECT film_id   INTO v_film_id   FROM FILME   WHERE titlu = p_titlu;
        INSERT INTO COMENTARII (client_id, film_id, text_comentariu)
        VALUES (v_client_id, v_film_id, p_text)
        RETURNING comentariu_id INTO v_com_id;
    END;

    PROCEDURE link_actor(p_prenume VARCHAR2, p_familie VARCHAR2) IS
        v_aid NUMBER;
    BEGIN
        SELECT actor_id INTO v_aid FROM ACTORI
        WHERE prenume = p_prenume AND nume_familie = p_familie;
        INSERT INTO COMENTARIU_ACTOR (comentariu_id, actor_id)
        VALUES (v_com_id, v_aid);
    END;

BEGIN
    -- comentarii despre un singur actor
    ins_com('teodora.m@email.ro',    'The Godfather',
            'Marlon Brando a redefinit arta actoriei cu acest rol. Impresionant!');
    link_actor('Marlon', 'Brando');

    ins_com('victor.p@email.ro',     'Titanic',
            'Leonardo DiCaprio a jucat cu o intensitate rara. Emotionant pana la lacrimi.');
    link_actor('Leonardo', 'DiCaprio');

    ins_com('madalina.r@gmail.com',  'Joker',
            'Joaquin Phoenix a fost fascinant si infricosator totodata. Magistral!');
    link_actor('Joaquin', 'Phoenix');

    ins_com('george.c@yahoo.com',    'No Country for Old Men',
            'Javier Bardem a creat unul din cei mai memorabili antagonisti din istoria cinematografiei.');
    link_actor('Javier', 'Bardem');

    ins_com('andreea.mol@email.ro',  'Black Swan',
            'Natalie Portman a livrat o prestatie actoriceasca de neuitat. Superba!');
    link_actor('Natalie', 'Portman');

    ins_com('ionut.cr@email.ro',     'Whiplash',
            'Miles Teller a facut un rol incredibil de intens si convingator.');
    link_actor('Miles', 'Teller');

    ins_com('roxana.fl@gmail.com',   'Avengers: Endgame',
            'Robert Downey Jr. a inchis aceasta saga exact asa cum trebuia. Iconic!');
    link_actor('Robert', 'Downey Jr.');

    ins_com('lucian.dinu@email.ro',  'Bohemian Rhapsody',
            'Rami Malek l-a incarnat pe Freddie Mercury cu o fidelitate uimitoare.');
    link_actor('Rami', 'Malek');

    ins_com('bianca.toma@yahoo.com', 'Braveheart',
            'Mel Gibson a transmis perfect determinarea si suferinta lui William Wallace.');
    link_actor('Mel', 'Gibson');

    -- comentarii despre mai multi actori 
    ins_com('oana.serban@yahoo.com', 'Se7en',
            'Atat Pitt cat si Spacey au creat o tensiune palpabila, de neuitat pe ecran!');
    link_actor('Brad',  'Pitt');
    link_actor('Kevin', 'Spacey');

    ins_com('mihnea.d@gmail.com',    'Mad Max: Fury Road',
            'Theron si Hardy s-au completat perfect, o chimie electrizanta intre ei.');
    link_actor('Charlize', 'Theron');
    link_actor('Tom',      'Hardy');

    ins_com('sorina.blaga@email.ro', 'The Green Mile',
            'Hanks si Clarke Duncan au adus lacrimi in ochii tuturor. Un duo de neuitat.');
    link_actor('Tom',     'Hanks');
    link_actor('Michael', 'Clarke Duncan');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[info]: COMENTARIU_ACTOR populat.');
END;
/

-- 11. CLIENT_FILM_OPTIUNI
DECLARE
    TYPE t_num IS TABLE OF NUMBER;
    v_clienti   t_num;
    v_filme     t_num;
    v_optiuni   t_num;
BEGIN
    SELECT client_id  BULK COLLECT INTO v_clienti FROM CLIENTI             ORDER BY client_id;
    SELECT film_id    BULK COLLECT INTO v_filme   FROM FILME               ORDER BY film_id;
    SELECT optiune_id BULK COLLECT INTO v_optiuni FROM OPTIUNI_PREDEFINITE ORDER BY optiune_id;

    FOR i IN 1..v_clienti.COUNT LOOP
        FOR j IN 1..3 LOOP
            DECLARE
                v_film_idx  NUMBER := MOD((i + j),     v_filme.COUNT)   + 1;
                v_opt_idx   NUMBER := MOD((i * 2 + j), v_optiuni.COUNT) + 1;
            BEGIN
                INSERT INTO CLIENT_FILM_OPTIUNI (client_id, film_id, optiune_id)
                VALUES (v_clienti(i), v_filme(v_film_idx), v_optiuni(v_opt_idx));
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[info]: Optiuni predefinite selectate inserate.');
END;
/

-- afisare finala pentru verificare
SELECT 'CATEGORII'          AS tabel, COUNT(*) AS nr_inreg FROM CATEGORII            UNION ALL
SELECT 'FILME',                        COUNT(*)             FROM FILME                UNION ALL
SELECT 'FILM_CATEGORII',               COUNT(*)             FROM FILM_CATEGORII       UNION ALL
SELECT 'VERSIUNI_FILM',                COUNT(*)             FROM VERSIUNI_FILM        UNION ALL
SELECT 'ACTORI',                       COUNT(*)             FROM ACTORI               UNION ALL
SELECT 'DISTRIBUTIE',                  COUNT(*)             FROM DISTRIBUTIE          UNION ALL
SELECT 'CLIENTI',                      COUNT(*)             FROM CLIENTI              UNION ALL
SELECT 'VIZUALIZARI',                  COUNT(*)             FROM VIZUALIZARI          UNION ALL
SELECT 'VOTURI',                       COUNT(*)             FROM VOTURI               UNION ALL
SELECT 'COMENTARII',                   COUNT(*)             FROM COMENTARII           UNION ALL
SELECT 'COMENTARIU_ACTOR',             COUNT(*)             FROM COMENTARIU_ACTOR     UNION ALL
SELECT 'OPTIUNI_PREDEFINITE',          COUNT(*)             FROM OPTIUNI_PREDEFINITE  UNION ALL
SELECT 'CLIENT_FILM_OPTIUNI',          COUNT(*)             FROM CLIENT_FILM_OPTIUNI
ORDER BY 1;