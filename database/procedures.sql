-- Exceptii:
-- -20001, 'Clientul cu ID-ul specificat nu exista'
-- -20002, 'Versiunea de film cu ID-ul specificat nu exista.'
-- -20003, parametru incorect
-- -20004, nu exista client cu acest email
-- -20005, 'Filmul cu ID-ul specificat nu exista.');
---20008, 'Actorul cu ID-ul specificat nu exista.');
--- 20009 - duplicat 
-- 20010 - 'Votul cu ID-ul specificat nu exista.'
-- -20011, 'Optiunea nu exista.'

--login
CREATE OR REPLACE PROCEDURE login_client(
    p_email     IN  CLIENTI.email%TYPE,
    p_client_id OUT CLIENTI.client_id%TYPE
) IS
BEGIN
    SELECT client_id INTO p_client_id
    FROM CLIENTI
    WHERE email = p_email;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'Nu exista niciun cont cu acest email.');
END;
/

--vizualizari
--insert
CREATE OR REPLACE PROCEDURE insert_vizualizare(
    p_client_id IN  VIZUALIZARI.client_id%TYPE,
    p_versiune_id IN  VIZUALIZARI.versiune_id%TYPE,
    p_durata IN  VIZUALIZARI.durata_efectiva%TYPE,
    p_status IN  VIZUALIZARI.status%TYPE,
    p_vizualizare_id OUT VIZUALIZARI.vizualizare_id%TYPE
) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE client_id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu ID-ul specificat nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM VERSIUNI_FILME WHERE versiune_id = p_versiune_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Versiunea de film specificata nu exista.');
    END IF;
    
    IF p_status NOT IN ('COMPLET', 'PARTIAL', 'ABANDONAT') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Stare invalida. Valori acceptate: COMPLET, PARTIAL, ABANDONAT.');
    END IF;

    IF p_durata IS NOT NULL AND (p_durata < 0 OR p_durata > 9999) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Durata trebuie sa fie intre 0 si 9999 minute.');
    END IF;

    INSERT INTO VIZUALIZARI (client_id, versiune_id, durata_efectiva, status)
        VALUES (p_client_id, p_versiune_id, p_durata, p_status)
        RETURNING vizualizare_id INTO p_vizualizare_id;

    COMMIT;

END insert_vizualizare;
/

--comentarii
--insert
CREATE OR REPLACE PROCEDURE insert_comentariu(
    p_client_id     IN  COMENTARII.client_id%TYPE,
    p_film_id       IN  COMENTARII.film_id%TYPE,
    p_text          IN  COMENTARII.text_comentariu%TYPE,
    p_actor_ids     IN  VARCHAR2 DEFAULT NULL,
    p_comentariu_id OUT COMENTARII.comentariu_id%TYPE
) IS
    v_count NUMBER;
    v_token VARCHAR2(100);
    v_actor_id NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE client_id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu ID-ul specificat nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM FILME WHERE film_id = p_film_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Filmul cu ID-ul specificat nu exista.');
    END IF; 

    IF TRIM(p_text) IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'Textul comentariului nu poate fi gol.');
    END IF;
    
    IF p_actor_ids IS NOT NULL THEN
        FOR i IN 1 .. REGEXP_COUNT(p_actor_ids, '[^,]+') LOOP
            v_token := TRIM(REGEXP_SUBSTR(p_actor_ids, '[^,]+', 1, i));
            
            IF NOT REGEXP_LIKE(v_token, '^[0-9]+$') THEN
                RAISE_APPLICATION_ERROR(-20003, 'Valoarea introdusa nu este un ID valid.');
            END IF;
            
            v_actor_id := TO_NUMBER(v_token);
            SELECT COUNT(*) INTO v_count FROM ACTORI WHERE actor_id = v_actor_id;
            
            IF v_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20008, 'Actorul cu ID-ul specificat nu exista.');
            END IF;
        END LOOP;
    END IF;

    INSERT INTO COMENTARII (client_id, film_id, text_comentariu)
        VALUES (p_client_id, p_film_id, TRIM(p_text))
        RETURNING comentariu_id INTO p_comentariu_id;

    -- actorii
   IF p_actor_ids IS NOT NULL THEN
        FOR i IN 1 .. REGEXP_COUNT(p_actor_ids, '[^,]+') LOOP
            v_token := TRIM(REGEXP_SUBSTR(p_actor_ids, '[^,]+', 1, i));
            v_actor_id := TO_NUMBER(v_token);
            
            BEGIN
                INSERT INTO COMENTARII_ACTORI (comentariu_id, actor_id)
                VALUES (p_comentariu_id, v_actor_id);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN 
                    NULL;
            END;
        END LOOP;
    END IF;

    COMMIT;
END insert_comentariu;
/

--voturi
--insert 
CREATE OR REPLACE PROCEDURE insert_vot(
    p_client_id IN VOTURI.client_id%TYPE,
    p_film_id IN VOTURI.film_id%TYPE,
    p_scor IN VOTURI.scor%TYPE,
    p_vot_id OUT VOTURI.vot_id%TYPE

) IS
    v_count NUMBER;
BEGIN

    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE client_id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu ID-ul specificat nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM FILME WHERE film_id = p_film_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Filmul cu ID-ul specificat nu exista.');
    END IF;

    IF p_scor < 1 OR p_scor > 10 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Scorul trebuie sa fie un numar intreg intre 1 si 10.');
    END IF;

    --un client nu poate vota de 2 ori acelasi film
    SELECT COUNT(*) INTO v_count
    FROM VOTURI WHERE client_id = p_client_id AND film_id = p_film_id;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Clientul a votat deja acest film.');
    END IF;

    INSERT INTO VOTURI (client_id, film_id, scor) VALUES (p_client_id, p_film_id, p_scor)
            RETURNING vot_id INTO p_vot_id;

    COMMIT;
END insert_vot;
/

--update
CREATE OR REPLACE PROCEDURE update_vot(
    p_vot_id IN VOTURI.vot_id%TYPE,
    p_scor_nou  IN VOTURI.scor%TYPE
) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM VOTURI WHERE vot_id=p_vot_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Nu exista acest votul cu ID-ul specificat');
    END IF;
    
    IF p_scor_nou < 1 OR p_scor_nou > 10 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Scorul trebuie sa fie un numar intreg intre 1 si 10.');
    END IF;


    UPDATE VOTURI SET scor = p_scor_nou
    WHERE vot_id=p_vot_id;

    COMMIT;
END update_vot;
/

--optiuni predefinite
CREATE OR REPLACE PROCEDURE select_optiuni_predefinite(
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT optiune_id, denumire, tip FROM OPTIUNI_PREDEFINITE ORDER BY tip;
END;
/

--optiuni de la client pt sg film

CREATE OR REPLACE PROCEDURE select_optiuni_p_client_film(
    p_client_id IN NUMBER,
    p_film_id   IN NUMBER,
    p_cursor    OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT op.optiune_id, op.denumire, op.tip, cfo.data_selectie
        FROM CLIENTI_FILME_OPTIUNI cfo
        JOIN OPTIUNI_PREDEFINITE op ON op.optiune_id = cfo.optiune_id
        WHERE cfo.client_id = p_client_id AND cfo.film_id   = p_film_id;
END;
/

--insert

CREATE OR REPLACE PROCEDURE insert_optiune_p_client_film(
    p_client_id  IN NUMBER,
    p_film_id    IN NUMBER,
    p_optiune_id IN NUMBER
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE client_id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu ID-ul specificat nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM FILME WHERE film_id = p_film_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Filmul cu ID-ul specificat nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM OPTIUNI_PREDEFINITE WHERE optiune_id = p_optiune_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Optiunea cu ID-ul specificat nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM CLIENTI_FILME_OPTIUNI
    WHERE client_id = p_client_id AND film_id = p_film_id AND optiune_id = p_optiune_id;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Optiunea a fost deja selectata.');
    END IF;

    INSERT INTO CLIENTI_FILME_OPTIUNI (client_id, film_id, optiune_id, data_selectie)
    VALUES (p_client_id, p_film_id, p_optiune_id, SYSDATE);

    COMMIT;
END;
/

--delete

CREATE OR REPLACE PROCEDURE delete_optiune_p_client_film(
    p_client_id  IN NUMBER,
    p_film_id    IN NUMBER,
    p_optiune_id IN NUMBER
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CLIENTI_FILME_OPTIUNI
    WHERE client_id  = p_client_id
    AND   film_id    = p_film_id
    AND   optiune_id = p_optiune_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Optiunea cu parametrii specificati nu exista.');
    END IF;

    DELETE FROM CLIENTI_FILME_OPTIUNI
    WHERE client_id  = p_client_id
    AND   film_id    = p_film_id
    AND   optiune_id = p_optiune_id;

    COMMIT;
END;
/

--filme
--get

CREATE OR REPLACE PROCEDURE get_filme(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT 
            f.film_id,
            f.titlu,
            f.descriere,
            f.data_lansare,
            ROUND(f.rating, 2) AS rating,
            cat.categorii_film AS categorii,
            COUNT(DISTINCT v.vizualizare_id) AS nr_vizualizari,
            AVG(vf.durata_minute) AS durata_medie
        FROM FILME f
        LEFT JOIN (
            SELECT 
                fc.film_id, 
                LISTAGG(c.denumire, ', ') WITHIN GROUP (ORDER BY c.denumire) AS categorii_film
            FROM FILME_CATEGORII fc
            JOIN CATEGORII c ON c.categorie_id = fc.categorie_id
            GROUP BY fc.film_id
        ) cat ON cat.film_id = f.film_id
        
        LEFT JOIN VERSIUNI_FILME vf ON vf.film_id = f.film_id
        LEFT JOIN VIZUALIZARI v ON v.versiune_id = vf.versiune_id
        GROUP BY 
            f.film_id, 
            f.titlu, 
            f.descriere, 
            f.data_lansare, 
            f.rating, 
            cat.categorii_film
        ORDER BY f.rating DESC NULLS LAST;
END get_filme;
/

--detalii film by id
CREATE OR REPLACE PROCEDURE select_film_by_id(
    p_film_id IN FILME.film_id%TYPE,
    p_film_general OUT SYS_REFCURSOR,
    p_versiuni OUT SYS_REFCURSOR,
    p_actori OUT SYS_REFCURSOR,
    p_comentarii OUT SYS_REFCURSOR
) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM FILME WHERE film_id = p_film_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Filmul cu ID-ul specificat nu exista.');
    END IF;
    -- informatii generale
    OPEN p_film_general FOR
        SELECT
            f.film_id, f.titlu, f.descriere, f.data_lansare,
            ROUND(f.rating, 2) AS rating,
            LISTAGG(c.denumire, ', ') WITHIN GROUP (ORDER BY c.denumire) AS categorii
        FROM FILME f
        LEFT JOIN FILME_CATEGORII fc ON fc.film_id = f.film_id
        LEFT JOIN CATEGORII c ON c.categorie_id = fc.categorie_id
        WHERE f.film_id = p_film_id
        GROUP BY f.film_id, f.titlu, f.descriere, f.data_lansare, f.rating;

    -- versiunile disponibile
    OPEN p_versiuni FOR
        SELECT versiune_id, format, limba, rezolutie, durata_minute
        FROM VERSIUNI_FILME
        WHERE film_id = p_film_id;

    -- distributia
    OPEN p_actori FOR
        SELECT
            a.actor_id,
            a.prenume || ' ' || a.nume_familie AS nume_complet,
            NVL(a.nume_scena, '-') AS nume_scena,
            d.nume_personaj,
            d.tip_rol
        FROM DISTRIBUTIE d
        JOIN ACTORI a ON a.actor_id = d.actor_id
        WHERE d.film_id = p_film_id
        ORDER BY DECODE(d.tip_rol, 'PRINCIPAL', 1, 'SECUNDAR', 2, 3);

    -- comentarii
    OPEN p_comentarii FOR
        SELECT
            co.comentariu_id,
            cl.prenume || ' ' || cl.nume AS client,
            co.text_comentariu,
            co.sentiment,
            co.data_comentariu,
            LISTAGG(a.prenume || ' ' || a.nume_familie, ', ')
                WITHIN GROUP (ORDER BY a.nume_familie, a.prenume) AS actori_mentionati
        FROM COMENTARII co
        JOIN CLIENTI cl ON cl.client_id = co.client_id
        LEFT JOIN COMENTARII_ACTORI ca ON ca.comentariu_id = co.comentariu_id
        LEFT JOIN ACTORI a ON a.actor_id = ca.actor_id
        WHERE co.film_id = p_film_id
        GROUP BY co.comentariu_id, cl.prenume, cl.nume,
                 co.text_comentariu, co.sentiment, co.data_comentariu
        ORDER BY co.data_comentariu DESC;
END select_film_by_id;
/

--clienti
--get clienti

CREATE OR REPLACE PROCEDURE get_clienti(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            cl.client_id,
            cl.prenume || ' ' || cl.nume AS nume_complet,
            cl.email,
            cl.telefon,
            cl.oras,
            cl.data_inregistrare,
            COUNT(DISTINCT v.vizualizare_id) AS nr_vizualizari,
            COUNT(DISTINCT vt.vot_id) AS nr_voturi,
            COUNT(DISTINCT co.comentariu_id) AS nr_comentarii
        FROM CLIENTI cl
        LEFT JOIN VIZUALIZARI v  ON v.client_id = cl.client_id
        LEFT JOIN VOTURI vt      ON vt.client_id = cl.client_id
        LEFT JOIN COMENTARII co  ON co.client_id = cl.client_id
        GROUP BY cl.client_id, cl.prenume, cl.nume, cl.email, cl.telefon, cl.oras, cl.data_inregistrare
        ORDER BY cl.nume, cl.prenume;
END get_clienti;
/

-- actori
-- get
CREATE OR REPLACE PROCEDURE get_actori(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            a.actor_id,
            a.prenume || ' ' || a.nume_familie  AS nume_complet,
            NVL(a.nume_scena, '-') AS nume_scena,
            a.data_nastere,
            COUNT(DISTINCT d.film_id) AS nr_filme
        FROM ACTORI a
        LEFT JOIN DISTRIBUTIE d ON d.actor_id = a.actor_id
        GROUP BY a.actor_id, a.prenume, a.nume_familie, a.nume_scena, a.data_nastere
        ORDER BY a.nume_familie, a.prenume;
END get_actori;
/

--profil client

CREATE OR REPLACE PROCEDURE get_profil_client(
    p_client_id IN  CLIENTI.client_id%TYPE,
    p_categorii_preferate OUT SYS_REFCURSOR,
    p_actori_preferati OUT SYS_REFCURSOR,
    p_istoric OUT SYS_REFCURSOR,
    p_sentiment_dominant OUT VARCHAR2
) IS
    v_count NUMBER;
    v_pozitiv NUMBER := 0;
    v_negativ NUMBER := 0;
    v_neutru NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE client_id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu ID-ul dat nu exista.');
    END IF;
    
    -- actori preferati
    OPEN p_actori_preferati FOR
        SELECT
            a.actor_id,
            a.prenume || ' ' || a.nume_familie  AS nume_complet,
            COUNT(DISTINCT vf.versiune_id) AS nr_filme_vazute
        FROM VIZUALIZARI viz
        JOIN VERSIUNI_FILME vf  ON vf.versiune_id = viz.versiune_id
        JOIN DISTRIBUTIE d  ON d.film_id = vf.film_id
        JOIN ACTORI a  ON a.actor_id = d.actor_id
        WHERE viz.client_id = p_client_id
        GROUP BY a.actor_id, a.prenume, a.nume_familie
        ORDER BY nr_filme_vazute DESC;

    -- categorii preferate
    OPEN p_categorii_preferate FOR
        SELECT
            c.categorie_id,
            c.denumire,
            COUNT(DISTINCT viz.vizualizare_id) AS nr_vizualizari
        FROM VIZUALIZARI viz 
        JOIN VERSIUNI_FILME vf ON vf.versiune_id = viz.versiune_id
        JOIN FILME_CATEGORII fc ON fc.film_id = vf.film_id
        JOIN CATEGORII c ON c.categorie_id = fc.categorie_id
        WHERE viz.client_id = p_client_id
        GROUP BY c.categorie_id, c.denumire
        ORDER BY nr_vizualizari DESC;


    -- istoric
    OPEN p_istoric FOR
        SELECT *
        FROM (
            SELECT
                viz.vizualizare_id,
                f.titlu,
                vf.format,
                vf.limba,
                viz.data_vizualizare,
                viz.durata_efectiva,
                viz.status
            FROM VIZUALIZARI viz
            JOIN VERSIUNI_FILME vf ON vf.versiune_id = viz.versiune_id
            JOIN FILME f ON f.film_id = vf.film_id
            WHERE viz.client_id = p_client_id
            ORDER BY viz.data_vizualizare DESC
        )
        WHERE ROWNUM <= 20;

    -- sentiment
    SELECT
        SUM(CASE WHEN sentiment = 'POZITIV' THEN 1 ELSE 0 END),
        SUM(CASE WHEN sentiment = 'NEGATIV' THEN 1 ELSE 0 END),
        SUM(CASE WHEN sentiment = 'NEUTRU'  THEN 1 ELSE 0 END)
    INTO v_pozitiv, v_negativ, v_neutru
    FROM COMENTARII
    WHERE client_id = p_client_id;

    IF v_pozitiv >= v_negativ AND v_pozitiv >= v_neutru THEN
        p_sentiment_dominant := 'POZITIV';
    ELSIF v_negativ >= v_pozitiv AND v_negativ >= v_neutru THEN
        p_sentiment_dominant := 'NEGATIV';
    ELSE
        p_sentiment_dominant := 'NEUTRU';
    END IF;

END get_profil_client;
/

--sentiment actor

CREATE OR REPLACE PROCEDURE get_sentiment_pred_actor(
    p_actor_id  IN  ACTORI.actor_id%TYPE,
    p_concluzie OUT VARCHAR2,
    p_cursor    OUT SYS_REFCURSOR
) IS
    v_count NUMBER;
    v_pozitiv NUMBER := 0;
    v_negativ NUMBER := 0;
    v_neutru NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count FROM ACTORI WHERE actor_id = p_actor_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Actorul cu ID-ul specificat nu exista.');
    END IF;

    OPEN p_cursor FOR
        SELECT
            com.comentariu_id,
            cl.prenume || ' ' || cl.nume AS client,
            f.titlu AS film,
            com.text_comentariu,
            com.data_comentariu,
            com.sentiment
        FROM COMENTARII_ACTORI ca
        JOIN COMENTARII com ON com.comentariu_id = ca.comentariu_id
        JOIN CLIENTI cl ON cl.client_id = com.client_id
        JOIN FILME f ON f.film_id = com.film_id
        WHERE ca.actor_id = p_actor_id
        ORDER BY com.data_comentariu DESC;

    SELECT
        SUM(CASE WHEN com.sentiment = 'POZITIV' THEN 1 ELSE 0 END),
        SUM(CASE WHEN com.sentiment = 'NEGATIV' THEN 1 ELSE 0 END),
        SUM(CASE WHEN com.sentiment = 'NEUTRU'  THEN 1 ELSE 0 END)
    INTO v_pozitiv, v_negativ, v_neutru
    FROM COMENTARII_ACTORI ca
    JOIN COMENTARII com ON com.comentariu_id = ca.comentariu_id
    WHERE ca.actor_id = p_actor_id;

    IF v_pozitiv >= v_negativ AND v_pozitiv >= v_neutru THEN
        p_concluzie := 'POZITIV';
    ELSIF v_negativ >= v_pozitiv AND v_negativ >= v_neutru THEN
        p_concluzie := 'NEGATIV';
    ELSE
        p_concluzie := 'NEUTRU';
    END IF;

END get_sentiment_pred_actor;
/

--client
--recomandari

CREATE OR REPLACE PROCEDURE get_recomandari_client(
    p_client_id IN  CLIENTI.client_id%TYPE,
    p_cursor    OUT SYS_REFCURSOR
) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE client_id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu ID-ul specificat nu exista.');
    END IF;

    OPEN p_cursor FOR
        SELECT *
        FROM (
            SELECT
                f.film_id,
                f.titlu,
                ROUND(f.rating, 2) AS rating,
                f.data_lansare,
                LISTAGG(c.denumire, ', ')
                    WITHIN GROUP (ORDER BY c.denumire) AS categorii,
                SUM(cat_pref.nr_viz) AS scor_relevanta
            FROM FILME f
            JOIN FILME_CATEGORII fc ON fc.film_id = f.film_id
            JOIN CATEGORII c ON c.categorie_id = fc.categorie_id
            -- categoriile preferate
            JOIN (
                SELECT fc2.categorie_id, COUNT(viz.vizualizare_id) AS nr_viz
                FROM VIZUALIZARI viz
                JOIN VERSIUNI_FILME vf2   ON vf2.versiune_id = viz.versiune_id
                JOIN FILME_CATEGORII fc2  ON fc2.film_id = vf2.film_id
                WHERE viz.client_id = p_client_id
                GROUP BY fc2.categorie_id
            ) cat_pref ON cat_pref.categorie_id = fc.categorie_id
            -- excludem filmele deja vizualizate 
            WHERE f.film_id NOT IN (
                SELECT DISTINCT vf3.film_id
                FROM VIZUALIZARI viz2
                JOIN VERSIUNI_FILME vf3 ON vf3.versiune_id = viz2.versiune_id
                WHERE viz2.client_id = p_client_id
            )
            GROUP BY f.film_id, f.titlu, f.rating, f.data_lansare
            ORDER BY scor_relevanta DESC, f.rating DESC
        )
        WHERE ROWNUM <= 10;

END get_recomandari_client;
/

--filme
--sentiment

CREATE OR REPLACE PROCEDURE get_sentiment_pred_film(
    p_film_id       IN  FILME.film_id%TYPE,
    p_cursor        OUT SYS_REFCURSOR,
    p_concluzie     OUT VARCHAR2
) IS
    v_count         NUMBER;
    v_total_poz     NUMBER := 0;
    v_total_neg     NUMBER := 0;
    v_total_neu     NUMBER := 0;
    v_rating        NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM FILME WHERE film_id = p_film_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Filmul cu ID-ul specificat nu exista.');
    END IF;

    OPEN p_cursor FOR
        SELECT 'COMENTARII' AS sursa,
               SUM(CASE WHEN sentiment = 'POZITIV' THEN 1 ELSE 0 END) AS pozitiv,
               SUM(CASE WHEN sentiment = 'NEGATIV' THEN 1 ELSE 0 END) AS negativ,
               SUM(CASE WHEN sentiment = 'NEUTRU'  THEN 1 ELSE 0 END) AS neutru,
               COUNT(*)                                                AS total
        FROM COMENTARII WHERE film_id = p_film_id
        UNION ALL
        SELECT 'OPTIUNI_BIFATE' AS sursa,
               SUM(CASE WHEN op.tip = 'POZITIV' THEN 1 ELSE 0 END) AS pozitiv,
               SUM(CASE WHEN op.tip = 'NEGATIV' THEN 1 ELSE 0 END) AS negativ,
               SUM(CASE WHEN op.tip = 'NEUTRU'  THEN 1 ELSE 0 END) AS neutru,
               COUNT(*)                                              AS total
        FROM CLIENTI_FILME_OPTIUNI cfo
        JOIN OPTIUNI_PREDEFINITE op ON op.optiune_id = cfo.optiune_id
        WHERE cfo.film_id = p_film_id;

    SELECT
        SUM(CASE WHEN sentiment = 'POZITIV' THEN 1 ELSE 0 END),
        SUM(CASE WHEN sentiment = 'NEGATIV' THEN 1 ELSE 0 END),
        SUM(CASE WHEN sentiment = 'NEUTRU'  THEN 1 ELSE 0 END)
    INTO v_total_poz, v_total_neg, v_total_neu
    FROM COMENTARII WHERE film_id = p_film_id;

    -- optiuni bifate
    SELECT
        v_total_poz + SUM(CASE WHEN op.tip = 'POZITIV' THEN 1 ELSE 0 END),
        v_total_neg + SUM(CASE WHEN op.tip = 'NEGATIV' THEN 1 ELSE 0 END),
        v_total_neu + SUM(CASE WHEN op.tip = 'NEUTRU'  THEN 1 ELSE 0 END)
    INTO v_total_poz, v_total_neg, v_total_neu
    FROM CLIENTI_FILME_OPTIUNI cfo
    JOIN OPTIUNI_PREDEFINITE op ON op.optiune_id = cfo.optiune_id
    WHERE cfo.film_id = p_film_id;

    -- rating
    SELECT NVL(rating, 0) INTO v_rating FROM FILME WHERE film_id = p_film_id;
    IF    v_rating >= 7 THEN v_total_poz := v_total_poz + 2;
    ELSIF v_rating <= 4 THEN v_total_neg := v_total_neg + 2;
    ELSE                     v_total_neu := v_total_neu + 2;
    END IF;

    IF v_total_poz >= v_total_neg AND v_total_poz >= v_total_neu THEN
        p_concluzie := 'POZITIV';
    ELSIF v_total_neg >= v_total_poz AND v_total_neg >= v_total_neu THEN
        p_concluzie := 'NEGATIV';
    ELSE
        p_concluzie := 'NEUTRU';
    END IF;

END get_sentiment_pred_film;
/

--statistici sezoniere

CREATE OR REPLACE PROCEDURE get_statistici_sezoniere(
    p_top_filme     OUT SYS_REFCURSOR,
    p_top_categorii OUT SYS_REFCURSOR
) IS
BEGIN
    -- top filme per sezon
    OPEN p_top_filme FOR
        SELECT *
        FROM (
            SELECT
                CASE
                    WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (12, 1, 2) THEN 'IARNA'
                    WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (3, 4, 5)  THEN 'PRIMAVARA'
                    WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (6, 7, 8)  THEN 'VARA'
                    ELSE 'TOAMNA'
                END AS sezon,
                f.film_id,
                f.titlu,
                ROUND(f.rating, 2) AS rating,
                COUNT(viz.vizualizare_id) AS nr_vizualizari,
                -- rank per sezon dupa nr vizualizari
                RANK() OVER (
                    PARTITION BY
                        CASE
                            WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (12, 1, 2) THEN 'IARNA'
                            WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (3, 4, 5)  THEN 'PRIMAVARA'
                            WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (6, 7, 8)  THEN 'VARA'
                            ELSE 'TOAMNA'
                        END
                    ORDER BY COUNT(viz.vizualizare_id) DESC
                )  AS loc_in_sezon
            FROM VIZUALIZARI viz
            JOIN VERSIUNI_FILME vf ON vf.versiune_id = viz.versiune_id
            JOIN FILME f ON f.film_id = vf.film_id
            GROUP BY
                CASE
                    WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (12, 1, 2) THEN 'IARNA'
                    WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (3, 4, 5)  THEN 'PRIMAVARA'
                    WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (6, 7, 8)  THEN 'VARA'
                    ELSE 'TOAMNA'
                END,
                f.film_id, f.titlu, f.rating
        )
        WHERE loc_in_sezon <= 5
        ORDER BY sezon, loc_in_sezon;

    -- top categorii per sezon
    OPEN p_top_categorii FOR
        SELECT
            CASE
                WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (12, 1, 2) THEN 'IARNA'
                WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (3, 4, 5)  THEN 'PRIMAVARA'
                WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (6, 7, 8)  THEN 'VARA'
                ELSE 'TOAMNA'
            END AS sezon,
            c.denumire AS categorie,
            COUNT(viz.vizualizare_id) AS nr_vizualizari
        FROM VIZUALIZARI viz
        JOIN VERSIUNI_FILME vf ON vf.versiune_id = viz.versiune_id
        JOIN FILME_CATEGORII fc ON fc.film_id = vf.film_id
        JOIN CATEGORII c  ON c.categorie_id = fc.categorie_id
        GROUP BY
            CASE
                WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (12, 1, 2) THEN 'IARNA'
                WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (3, 4, 5)  THEN 'PRIMAVARA'
                WHEN EXTRACT(MONTH FROM viz.data_vizualizare) IN (6, 7, 8)  THEN 'VARA'
                ELSE 'TOAMNA'
            END,
            c.denumire
        ORDER BY sezon, nr_vizualizari DESC;

END get_statistici_sezoniere;
/