DROP TABLE CLIENT_FILM_OPTIUNI CASCADE CONSTRAINTS
/
DROP TABLE COMENTARIU_ACTOR CASCADE CONSTRAINTS
/
DROP TABLE COMENTARII CASCADE CONSTRAINTS
/
DROP TABLE VOTURI CASCADE CONSTRAINTS 
/
DROP TABLE VIZUALIZARI CASCADE CONSTRAINTS
/
DROP TABLE OPTIUNI_PREDEFINITE CASCADE CONSTRAINTS
/
DROP TABLE DISTRIBUTIE CASCADE CONSTRAINTS
/
DROP TABLE FILM_CATEGORII CASCADE CONSTRAINTS
/
DROP TABLE VERSIUNI_FILM CASCADE CONSTRAINTS
/
DROP TABLE ACTORI CASCADE CONSTRAINTS
/
DROP TABLE CLIENTI CASCADE CONSTRAINTS
/
DROP TABLE FILME CASCADE CONSTRAINTS
/
DROP TABLE CATEGORII CASCADE CONSTRAINTS
/

DROP SEQUENCE SEQ_CATEGORII
/
DROP SEQUENCE SEQ_FILME
/
DROP SEQUENCE SEQ_VERSIUNI_FILM
/
DROP SEQUENCE SEQ_ACTORI
/
DROP SEQUENCE SEQ_CLIENTI
/
DROP SEQUENCE SEQ_VIZUALIZARI
/
DROP SEQUENCE SEQ_VOTURI
/
DROP SEQUENCE SEQ_COMENTARII
/
DROP SEQUENCE SEQ_OPTIUNI
/


CREATE TABLE CATEGORII (
    categorie_id    NUMBER           CONSTRAINT pk_categorii PRIMARY KEY,
    denumire        VARCHAR2(100)    NOT NULL,
    CONSTRAINT uq_categorii_denumire UNIQUE (denumire)
);


CREATE TABLE FILME (
    film_id         NUMBER          CONSTRAINT pk_filme PRIMARY KEY,
    titlu           VARCHAR2(200)   NOT NULL,
    descriere       VARCHAR2(2000),
    data_lansare    DATE,
    -- Rating calculat automat; DEFAULT 0, actualizat de trigger
    rating          NUMBER(4,2)     DEFAULT 0,
    -- Constrângere de domeniu: ratingul trebuie să fie între 0 și 10
    CONSTRAINT chk_filme_rating     CHECK (rating BETWEEN 0 AND 10)
);


CREATE TABLE FILM_CATEGORII (
    film_id         NUMBER          NOT NULL,
    categorie_id    NUMBER          NOT NULL,
    -- PK compusă din cele două FK-uri
    CONSTRAINT pk_film_categorii    PRIMARY KEY (film_id, categorie_id),
    CONSTRAINT fk_fc_film           FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id) ON DELETE CASCADE,
    CONSTRAINT fk_fc_categorie      FOREIGN KEY (categorie_id)
                                    REFERENCES CATEGORII(categorie_id) ON DELETE CASCADE
);


CREATE TABLE VERSIUNI_FILM (
    versiune_id     NUMBER          CONSTRAINT pk_versiuni PRIMARY KEY,
    film_id         NUMBER          NOT NULL,
    -- Format: SD / HD / 4K / 8K
    format          VARCHAR2(10)    NOT NULL,
    rezolutie       VARCHAR2(20),   -- ex: '1920x1080'
    -- Limba versiunii (original, dublat română, subtitrat, etc.)
    limba           VARCHAR2(50)    NOT NULL,
    durata_minute   NUMBER(4)       NOT NULL,
    -- CHECK: format acceptat
    CONSTRAINT chk_versiune_format  CHECK (format IN ('SD', 'HD', '4K', '8K')),
    -- CHECK: durata rezonabilă (minim 1 minut, maxim 600 minute = 10 ore)
    CONSTRAINT chk_versiune_durata  CHECK (durata_minute BETWEEN 1 AND 600),
    -- UNIQUE: aceeași combinație film + format + limbă e unică
    CONSTRAINT uq_versiune          UNIQUE (film_id, format, limba),
    -- FK spre FILME; ON DELETE CASCADE → dacă filmul e șters, versiunile dispar
    CONSTRAINT fk_versiuni_film     FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id)
                                    ON DELETE CASCADE
);


CREATE TABLE ACTORI (
    actor_id        NUMBER          CONSTRAINT pk_actori PRIMARY KEY,
    nume_scena      VARCHAR2(100),  -- pseudonim, opțional
    prenume         VARCHAR2(100)   NOT NULL,
    nume_familie    VARCHAR2(100)   NOT NULL,
    data_nastere    DATE
);


CREATE TABLE DISTRIBUTIE (
    film_id         NUMBER          NOT NULL,
    actor_id        NUMBER          NOT NULL,
    nume_personaj   VARCHAR2(200),              -- ex: 'Dom Cobb', 'Bruce Wayne'
    tip_rol         VARCHAR2(20)    DEFAULT 'SECUNDAR',
    CONSTRAINT pk_distributie       PRIMARY KEY (film_id, actor_id),
    CONSTRAINT chk_distributie_tip  CHECK (tip_rol IN ('PRINCIPAL', 'SECUNDAR', 'FIGURATIE')),
    CONSTRAINT fk_dist_film         FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id) ON DELETE CASCADE,
    CONSTRAINT fk_dist_actor        FOREIGN KEY (actor_id)
                                    REFERENCES ACTORI(actor_id) ON DELETE CASCADE
);


CREATE TABLE CLIENTI (
    client_id           NUMBER          CONSTRAINT pk_clienti PRIMARY KEY,
    prenume             VARCHAR2(100)   NOT NULL,
    nume                VARCHAR2(100)   NOT NULL,
    telefon             VARCHAR2(20)    NOT NULL,
    -- UNIQUE: o adresă de e-mail nu poate fi asociată a doi clienți
    email               VARCHAR2(150),
    adresa              VARCHAR2(300),
    oras                VARCHAR2(100),
    data_inregistrare   DATE            DEFAULT SYSDATE NOT NULL,
    -- CHECK: email trebuie să conțină '@' dacă e furnizat
    CONSTRAINT chk_clienti_email    CHECK (email IS NULL OR email LIKE '%@%.%'),
    CONSTRAINT uq_clienti_email     UNIQUE (email)
);


CREATE TABLE VIZUALIZARI (
    vizualizare_id      NUMBER          CONSTRAINT pk_vizualizari PRIMARY KEY,
    client_id           NUMBER          NOT NULL,
    versiune_id         NUMBER          NOT NULL,
    data_vizualizare    DATE            DEFAULT SYSDATE NOT NULL,
    -- Cât a urmărit efectiv (poate fi mai mic decât durata versiunii)
    durata_efectiva     NUMBER(4),
    status              VARCHAR2(20)    DEFAULT 'COMPLETA',
    -- CHECK: stări permise
    CONSTRAINT chk_viz_status       CHECK (status IN ('COMPLETA', 'PARTIALA', 'ABANDONATA')),
    -- CHECK: durata efectivă nu poate fi negativă
    CONSTRAINT chk_viz_durata       CHECK (durata_efectiva IS NULL OR durata_efectiva >= 0),
    CONSTRAINT fk_viz_client        FOREIGN KEY (client_id)
                                    REFERENCES CLIENTI(client_id),
    CONSTRAINT fk_viz_versiune      FOREIGN KEY (versiune_id)
                                    REFERENCES VERSIUNI_FILM(versiune_id)
);


CREATE TABLE VOTURI (
    vot_id          NUMBER          CONSTRAINT pk_voturi PRIMARY KEY,
    client_id       NUMBER          NOT NULL,
    film_id         NUMBER          NOT NULL,
    scor            NUMBER(2)       NOT NULL,
    data_vot        DATE            DEFAULT SYSDATE NOT NULL,
    -- UNIQUE: un client poate vota un film o singură dată
    CONSTRAINT uq_vot               UNIQUE (client_id, film_id),
    -- CHECK: scor valid
    CONSTRAINT chk_vot_scor         CHECK (scor BETWEEN 1 AND 10),
    CONSTRAINT fk_vot_client        FOREIGN KEY (client_id)
                                    REFERENCES CLIENTI(client_id),
    CONSTRAINT fk_vot_film          FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id)
);


CREATE TABLE OPTIUNI_PREDEFINITE (
    optiune_id      NUMBER          CONSTRAINT pk_optiuni PRIMARY KEY,
    denumire        VARCHAR2(100)   NOT NULL,
    -- Clasificare sentiment (pentru analiza automată)
    tip             VARCHAR2(10)    NOT NULL,
    -- CHECK: tipuri permise
    CONSTRAINT chk_optiune_tip      CHECK (tip IN ('POZITIV', 'NEGATIV', 'NEUTRU')),
    CONSTRAINT uq_optiune_denumire  UNIQUE (denumire)
);


CREATE TABLE CLIENT_FILM_OPTIUNI (
    client_id       NUMBER          NOT NULL,
    film_id         NUMBER          NOT NULL,
    optiune_id      NUMBER          NOT NULL,
    data_selectie   DATE            DEFAULT SYSDATE NOT NULL,
    -- PK compusă
    CONSTRAINT pk_cfo               PRIMARY KEY (client_id, film_id, optiune_id),
    CONSTRAINT fk_cfo_client        FOREIGN KEY (client_id)
                                    REFERENCES CLIENTI(client_id),
    CONSTRAINT fk_cfo_film          FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id),
    CONSTRAINT fk_cfo_optiune       FOREIGN KEY (optiune_id)
                                    REFERENCES OPTIUNI_PREDEFINITE(optiune_id)
);


CREATE TABLE COMENTARII (
    comentariu_id       NUMBER          CONSTRAINT pk_comentarii PRIMARY KEY,
    client_id           NUMBER          NOT NULL,
    film_id             NUMBER          NOT NULL,
    text_comentariu     VARCHAR2(2000)  NOT NULL,
    sentiment           VARCHAR2(10)    DEFAULT 'NEUTRU',
    data_comentariu     DATE            DEFAULT SYSDATE NOT NULL,
    CONSTRAINT chk_com_sentiment    CHECK (sentiment IN ('POZITIV', 'NEGATIV', 'NEUTRU')),
    CONSTRAINT fk_com_client        FOREIGN KEY (client_id)
                                    REFERENCES CLIENTI(client_id),
    CONSTRAINT fk_com_film          FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id)
);


CREATE TABLE COMENTARIU_ACTOR (
    comentariu_id   NUMBER  NOT NULL,
    actor_id        NUMBER  NOT NULL,
    CONSTRAINT pk_comentariu_actor  PRIMARY KEY (comentariu_id, actor_id),
    CONSTRAINT fk_ca_comentariu     FOREIGN KEY (comentariu_id)
                                    REFERENCES COMENTARII(comentariu_id) ON DELETE CASCADE,
    CONSTRAINT fk_ca_actor          FOREIGN KEY (actor_id)
                                    REFERENCES ACTORI(actor_id) ON DELETE CASCADE
);




CREATE SEQUENCE SEQ_CATEGORII    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_FILME        START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_VERSIUNI_FILM START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_ACTORI       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_CLIENTI      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_VIZUALIZARI  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_VOTURI       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_COMENTARII   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_OPTIUNI      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

--Triggere pt autoincrement

CREATE OR REPLACE TRIGGER TRG_AI_CATEGORII
BEFORE INSERT ON CATEGORII FOR EACH ROW
BEGIN
    IF :NEW.categorie_id IS NULL THEN
        :NEW.categorie_id := SEQ_CATEGORII.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_AI_FILME
BEFORE INSERT ON FILME FOR EACH ROW
BEGIN
    IF :NEW.film_id IS NULL THEN
        :NEW.film_id := SEQ_FILME.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_AI_VERSIUNI_FILM
BEFORE INSERT ON VERSIUNI_FILM FOR EACH ROW
BEGIN
    IF :NEW.versiune_id IS NULL THEN
        :NEW.versiune_id := SEQ_VERSIUNI_FILM.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_AI_ACTORI
BEFORE INSERT ON ACTORI FOR EACH ROW
BEGIN
    IF :NEW.actor_id IS NULL THEN
        :NEW.actor_id := SEQ_ACTORI.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_AI_CLIENTI
BEFORE INSERT ON CLIENTI FOR EACH ROW
BEGIN
    IF :NEW.client_id IS NULL THEN
        :NEW.client_id := SEQ_CLIENTI.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_AI_VIZUALIZARI
BEFORE INSERT ON VIZUALIZARI FOR EACH ROW
BEGIN
    IF :NEW.vizualizare_id IS NULL THEN
        :NEW.vizualizare_id := SEQ_VIZUALIZARI.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_AI_VOTURI
BEFORE INSERT ON VOTURI FOR EACH ROW
BEGIN
    IF :NEW.vot_id IS NULL THEN
        :NEW.vot_id := SEQ_VOTURI.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_AI_COMENTARII
BEFORE INSERT ON COMENTARII FOR EACH ROW
BEGIN
    IF :NEW.comentariu_id IS NULL THEN
        :NEW.comentariu_id := SEQ_COMENTARII.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_AI_OPTIUNI
BEFORE INSERT ON OPTIUNI_PREDEFINITE FOR EACH ROW
BEGIN
    IF :NEW.optiune_id IS NULL THEN
        :NEW.optiune_id := SEQ_OPTIUNI.NEXTVAL;
    END IF;
END;
/

--Triggere pt logica de bussines

-- ------------------------------------------------------------
-- TRIGGER BL-1: TRG_RECALCUL_RATING
-- Scop: La fiecare INSERT sau UPDATE în VOTURI, recalculează
-- automat rating-ul filmului ca medie aritmetică a tuturor
-- scorurilor primite. Astfel, câmpul FILME.rating este mereu
-- sincronizat fără intervenție manuală din aplicație.
-- Tip: AFTER INSERT OR UPDATE OR DELETE ON VOTURI
-- (DELETE: dacă cineva șterge un vot, ratingul se recalculează)
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRG_RECALCUL_RATING
AFTER INSERT OR UPDATE OR DELETE ON VOTURI
BEGIN
    -- recalculeaza ratingul pentru toate filmele care au voturi
    UPDATE FILME f
    SET rating = (
        SELECT ROUND(NVL(AVG(v.scor), 0), 2)
        FROM VOTURI v
        WHERE v.film_id = f.film_id
    )
    WHERE EXISTS (
        SELECT 1 FROM VOTURI v WHERE v.film_id = f.film_id
    );
END;
/

-- ------------------------------------------------------------
-- TRIGGER BL-2: TRG_ANALIZA_SENTIMENT_COMENTARIU
-- Scop: La INSERT sau UPDATE pe COMENTARII, analizează automat
-- textul comentariului prin identificarea de cuvinte-cheie
-- și setează câmpul sentiment (POZITIV / NEGATIV / NEUTRU).
-- Logica: număr cuvinte pozitive vs. negative; dacă diferența
-- e semnificativă → POZITIV/NEGATIV, altfel NEUTRU.
-- Aceasta este o implementare simplificată; poate fi extinsă
-- printr-un dicționar de cuvinte stocat în BD.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRG_ANALIZA_SENTIMENT
BEFORE INSERT OR UPDATE OF text_comentariu ON COMENTARII
FOR EACH ROW
DECLARE
    v_text      VARCHAR2(2000);
    v_pozitiv   NUMBER := 0;
    v_negativ   NUMBER := 0;
    -- Cuvinte cheie pozitive
    TYPE t_cuvinte IS TABLE OF VARCHAR2(50);
    v_cuvinte_poz t_cuvinte := t_cuvinte(
        'minunat','excelent','superb','fantastic','genial','impresionant',
        'placut','recomandat','emotionant','captivant','spectaculos',
        'apreciat','bun','frumos','iubesc','admir','bravo','perfect'
    );
    -- Cuvinte cheie negative
    v_cuvinte_neg t_cuvinte := t_cuvinte(
        'slab','plictisitor','dezamagitor','oribil','groaznic','urat',
        'prost','stupid','enervant','banal','previzibil','scenariu slab',
        'dezamagit','nerealist','rau','insuportabil','plictisit'
    );
BEGIN
    v_text := LOWER(:NEW.text_comentariu);

    -- Numără aparițiile cuvintelor pozitive
    FOR i IN 1..v_cuvinte_poz.COUNT LOOP
        IF INSTR(v_text, v_cuvinte_poz(i)) > 0 THEN
            v_pozitiv := v_pozitiv + 1;
        END IF;
    END LOOP;

    -- Numără aparițiile cuvintelor negative
    FOR i IN 1..v_cuvinte_neg.COUNT LOOP
        IF INSTR(v_text, v_cuvinte_neg(i)) > 0 THEN
            v_negativ := v_negativ + 1;
        END IF;
    END LOOP;

    -- Clasificare: diferența trebuie să fie de cel puțin 1
    IF v_pozitiv > v_negativ THEN
        :NEW.sentiment := 'POZITIV';
    ELSIF v_negativ > v_pozitiv THEN
        :NEW.sentiment := 'NEGATIV';
    ELSE
        :NEW.sentiment := 'NEUTRU';
    END IF;
END;
/


-- ============================================================
-- SECȚIUNEA 5: EXCEPȚII APLICATIVE DEFINITE GLOBAL
-- Definim excepțiile ca proceduri de validare standalone
-- care pot fi apelate din proceduri/funcții PL/SQL.
-- Clientul (Java, Python, .NET etc.) le va prinde prin
-- codul de eroare ORA-20xxx.
-- ============================================================

-- Excepție 2: -20002 vot duplicat (definit în procedura de vot din scriptul de business)
-- Excepție 3: -20003 scor invalid
-- Excepție 4: -20004 film inexistent
-- Excepție 5: -20005 client inexistent