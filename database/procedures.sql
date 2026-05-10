-- Exceptii:
---20001, 'Clientul cu ID-ul specificat nu exista
-- -20002, 'Versiunea de film specificata nu exista.'
-- -20003, parametru incorect
-- -20005, 'Filmul cu ID-ul specificat nu exista.');
---20008, 'Actorul cu ID-ul ' || v_actor_id || ' nu exista.');
--- 20009 - duplicat 
-- 20010 - votul nu exista
-- -20011, 'Optiunea nu exista.');
--vizualizari

--insert

CREATE OR REPLACE PROCEDURE insert_vizualizare(
    p_client_id IN  VIZUALIZARI.client_id%TYPE,
    p_versiune_id IN  VIZUALIZARI.versiune_id%TYPE,
    p_durata IN  VIZUALIZARI.durata_efectiva%TYPE,
    p_stare IN  VIZUALIZARI.stare%TYPE,
    p_vizualizare_id OUT VIZUALIZARI.id%TYPE
) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu ID-ul specificat nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM VERSIUNI_FILME WHERE id = p_versiune_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Versiunea de film specificata nu exista.');
    END IF;
    
    IF p_stare NOT IN ('COMPLET', 'PARTIAL', 'ABANDONAT') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Stare invalida. Valori acceptate: COMPLET, PARTIAL, ABANDONAT.');
    END IF;

    IF p_durata IS NOT NULL AND (p_durata < 0 OR p_durata > 9999) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Durata trebuie sa fie intre 0 si 9999 minute.');
    END IF;

    INSERT INTO VIZUALIZARI (client_id, versiune_id, durata_efectiva, stare)
        VALUES (p_client_id, p_versiune_id, p_durata, p_stare)
        RETURNING id INTO p_vizualizare_id;

    COMMIT;

END insert_vizualizare;
/

--comentarii
--insert

CREATE OR REPLACE PROCEDURE insert_comentariu(
    p_client_id     IN  COMENTARII.client_id%TYPE,
    p_film_id       IN  COMENTARII.film_id%TYPE,
    p_text          IN  COMENTARII.text_comentariu%TYPE,
    p_actor_ids     IN  VARCHAR2 DEFAULT NULL, --lista actori separata prin virgula
    p_comentariu_id OUT COMENTARII.id%TYPE
) IS
    v_count NUMBER;
    v_token VARCHAR2(100);
    v_actor_id NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu ID-ul specificat nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM FILME WHERE id = p_film_id;
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
                RAISE_APPLICATION_ERROR(-20003, 'Valoarea introdusa nu este un ID valid: ' || v_token);
            END IF;
            
            v_actor_id := TO_NUMBER(v_token);
            SELECT COUNT(*) INTO v_count FROM ACTORI WHERE id = v_actor_id;
            
            IF v_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20008, 'Actorul cu ID-ul ' || v_actor_id || ' nu exista.');
            END IF;
        END LOOP;
    END IF;

    INSERT INTO COMENTARII (client_id, film_id, text_comentariu)
        VALUES (p_client_id, p_film_id, TRIM(p_text))
        RETURNING id INTO p_comentariu_id;

    -- actorii
   IF p_actor_ids IS NOT NULL THEN
        FOR i IN 1 .. REGEXP_COUNT(p_actor_ids, '[^,]+') LOOP
            v_token := TRIM(REGEXP_SUBSTR(p_actor_ids, '[^,]+', 1, i));
            v_actor_id := TO_NUMBER(v_token);
            
            BEGIN
                INSERT INTO COMENTARII_ACTORI (comentariu_id, actor_id)
                VALUES (p_comentariu_id, v_actor_id);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN -- Ignorat silențios, exista deja intrarea asta
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
    p_vot_id OUT VOTURI.id%TYPE

) IS
    v_count NUMBER;
BEGIN
    -- validare client
    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu ID-ul specificat nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM FILME WHERE id = p_film_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Filmul cu ID-ul specificat nu exista.');
    END IF;

    IF p_scor < 1 OR p_scor > 10 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Scorul trebuie sa fie un numar intreg intre 1 si 10.');
    END IF;

    --duplicat
    SELECT COUNT(*) INTO v_count
    FROM VOTURI WHERE client_id = p_client_id AND film_id = p_film_id;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Clientul a votat deja acest film.');
    END IF;

    INSERT INTO VOTURI (client_id, film_id, scor) VALUES (p_client_id, p_film_id, p_scor)
            RETURNING id INTO p_vot_id;

    COMMIT;
END insert_vot;
/

--update
CREATE OR REPLACE PROCEDURE update_vot(
    p_client_id IN VOTURI.client_id%TYPE,
    p_film_id   IN VOTURI.film_id%TYPE,
    p_scor_nou  IN VOTURI.scor%TYPE
) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM VOTURI WHERE client_id = p_client_id AND film_id = p_film_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Nu exista un vot al acestui client pentru filmul specificat.');
    END IF;
    
    IF p_scor_nou < 1 OR p_scor_nou > 10 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Scorul trebuie sa fie un numar intreg intre 1 si 10.');
    END IF;


    UPDATE VOTURI SET scor = p_scor_nou
    WHERE client_id = p_client_id AND film_id = p_film_id;

    COMMIT;
END update_vot;
/

--optiuni predefinite
CREATE OR REPLACE PROCEDURE select_optiuni_predefinite(
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT id, denumire, tip FROM OPTIUNI_PREDEFINITE ORDER BY tip;
END;
/

--optiuni de la client pt sg film

CREATE OR REPLACE PROCEDURE select_optiuni_client_film(
    p_client_id IN NUMBER,
    p_film_id   IN NUMBER,
    p_cursor    OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT op.id, op.denumire, op.tip, cfo.data_selectie
        FROM CLIENTI_FILME_OPTIUNI cfo
        JOIN OPTIUNI_PREDEFINITE op ON op.id = cfo.optiune_id
        WHERE cfo.client_id = p_client_id
        AND   cfo.film_id   = p_film_id;
END;
/

--insert

CREATE OR REPLACE PROCEDURE insert_optiune_client_film(
    p_client_id  IN NUMBER,
    p_film_id    IN NUMBER,
    p_optiune_id IN NUMBER
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE id = p_client_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Clientul cu acest ID nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM FILME WHERE id = p_film_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Filmul nu exista.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM OPTIUNI_PREDEFINITE WHERE id = p_optiune_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Optiunea nu exista.');
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

CREATE OR REPLACE PROCEDURE delete_optiune_client_film(
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
        RAISE_APPLICATION_ERROR(-20011, 'Optiunea cu parametrii dati(id client, id film, id optiune) nu exista.');
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

CREATE OR REPLACE PROCEDURE get_toate_filmele(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            f.id,
            f.titlu,
            f.descriere,
            f.data_lansare,
            ROUND(f.rating, 2) AS rating,
            cat.categorii_film AS categorii,
            COUNT(DISTINCT v.id) AS nr_vizualizari,
            AVG(vf.durata_minute) AS durata_medie
        FROM FILME f
        -- Sub-query care aduce exact un rând cu categorii gata concatenate pentru fiecare film
        LEFT JOIN (
            SELECT 
                fc.film_id, 
                LISTAGG(c.denumire, ', ') WITHIN GROUP (ORDER BY c.denumire) AS categorii_film
            FROM FILME_CATEGORII fc
            JOIN CATEGORII c ON c.id = fc.categorie_id
            GROUP BY fc.film_id
        ) cat ON cat.film_id = f.id
        -- Restul join-urilor
        LEFT JOIN VERSIUNI_FILME vf  ON vf.film_id = f.id
        LEFT JOIN VIZUALIZARI v      ON v.versiune_id = vf.id
        GROUP BY 
            f.id, 
            f.titlu, 
            f.descriere, 
            f.data_lansare, 
            f.rating, 
            cat.categorii_film
        ORDER BY f.rating DESC NULLS LAST;
END get_toate_filmele;
/

select * from CLIENTI_FILME_OPTIUNI;
DECLARE
V_NR NUMBER;
begin
delete_optiune_client_film(1, 2, 7);
end;
/

select * from voturi;
select * from comentarii_actori;
/



select * from filme_categorii;
SET SERVEROUTPUT ON;

DECLARE
    v_cursor   SYS_REFCURSOR;
    v_id       OPTIUNI_PREDEFINITE.id%TYPE;
    v_denumire varchar2(2000);
    v_tip      varchar2(2000);
    v_data DATE;
    n1 NUMBER;
    n2 NUMBER;
    n3 NUMBER;
    S VARCHAR2(2000);
BEGIN
    get_toate_filmele(v_cursor);
    LOOP
        FETCH v_cursor INTO v_id, v_denumire, v_tip, V_DATA, N1, S, N2, N3;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' | Denumire: ' || v_denumire || ' | Tip: ' || v_tip || ' DATA: ' || v_data || ' ' || N1 || ' ' || S || ' ' || N2 || ' ' || N3);
    END LOOP;
    CLOSE v_cursor;
END;
/