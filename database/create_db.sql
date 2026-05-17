DROP TABLE CLIENTI_FILME_OPTIUNI CASCADE CONSTRAINTS
/
DROP TABLE COMENTARII_ACTORI CASCADE CONSTRAINTS
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
DROP TABLE FILME_CATEGORII CASCADE CONSTRAINTS
/
DROP TABLE VERSIUNI_FILME CASCADE CONSTRAINTS
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
    -- actualizat de trigger
    rating          NUMBER(4,2)     DEFAULT 0,
    CONSTRAINT chk_filme_rating     CHECK (rating BETWEEN 0 AND 10)
);


CREATE TABLE FILME_CATEGORII (
    film_id         NUMBER          NOT NULL,
    categorie_id    NUMBER          NOT NULL,
    
    CONSTRAINT pk_film_categorii    PRIMARY KEY (film_id, categorie_id),
    CONSTRAINT fk_fc_film           FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id) ON DELETE CASCADE,
    CONSTRAINT fk_fc_categorie      FOREIGN KEY (categorie_id)
                                    REFERENCES CATEGORII(categorie_id) ON DELETE CASCADE
);


CREATE TABLE VERSIUNI_FILME (
    versiune_id     NUMBER          CONSTRAINT pk_versiuni PRIMARY KEY,
    film_id         NUMBER          NOT NULL,
    format          VARCHAR2(10)    NOT NULL,
    rezolutie       VARCHAR2(20),   
    limba           VARCHAR2(50)    NOT NULL,
    durata_minute   NUMBER(4)       NOT NULL,
    
    CONSTRAINT chk_versiune_format  CHECK (format IN ('SD', 'HD', '4K', '8K')),
    CONSTRAINT chk_versiune_durata  CHECK (durata_minute BETWEEN 1 AND 600),
    CONSTRAINT uq_versiune          UNIQUE (film_id, format, limba),
    CONSTRAINT fk_versiuni_film     FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id)
                                    ON DELETE CASCADE
);


CREATE TABLE ACTORI (
    actor_id        NUMBER          CONSTRAINT pk_actori PRIMARY KEY,
    nume_scena      VARCHAR2(100), 
    prenume         VARCHAR2(100)   NOT NULL,
    nume_familie    VARCHAR2(100)   NOT NULL,
    data_nastere    DATE
);


CREATE TABLE DISTRIBUTIE (
    film_id         NUMBER          NOT NULL,
    actor_id        NUMBER          NOT NULL,
    nume_personaj   VARCHAR2(200),             
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
    email               VARCHAR2(150),
    adresa              VARCHAR2(300),
    oras                VARCHAR2(100),
    data_inregistrare   DATE            DEFAULT SYSDATE NOT NULL,
    
    CONSTRAINT chk_clienti_email    CHECK (email IS NULL OR email LIKE '%@%.%'),
    CONSTRAINT uq_clienti_email     UNIQUE (email)
);


CREATE TABLE VIZUALIZARI (
    vizualizare_id      NUMBER          CONSTRAINT pk_vizualizari PRIMARY KEY,
    client_id           NUMBER          NOT NULL,
    versiune_id         NUMBER          NOT NULL,
    data_vizualizare    DATE            DEFAULT SYSDATE NOT NULL,
    -- cat a urmarit efectiv
    durata_efectiva     NUMBER(4),
    status              VARCHAR2(20)    DEFAULT 'COMPLET',

    CONSTRAINT chk_viz_status       CHECK (status IN ('COMPLET', 'PARTIAL', 'ABANDONAT')),

    CONSTRAINT chk_viz_durata       CHECK (durata_efectiva IS NULL OR durata_efectiva >= 0),
    CONSTRAINT fk_viz_client        FOREIGN KEY (client_id)
                                    REFERENCES CLIENTI(client_id),
    CONSTRAINT fk_viz_versiune      FOREIGN KEY (versiune_id)
                                    REFERENCES VERSIUNI_FILME(versiune_id)
);


CREATE TABLE VOTURI (
    vot_id          NUMBER          CONSTRAINT pk_voturi PRIMARY KEY,
    client_id       NUMBER          NOT NULL,
    film_id         NUMBER          NOT NULL,
    scor            NUMBER(2)       NOT NULL,
    data_vot        DATE            DEFAULT SYSDATE NOT NULL,
    -- clientul poate vota o singura data un film
    CONSTRAINT uq_vot               UNIQUE (client_id, film_id),

    CONSTRAINT chk_vot_scor         CHECK (scor BETWEEN 1 AND 10),
    CONSTRAINT fk_vot_client        FOREIGN KEY (client_id)
                                    REFERENCES CLIENTI(client_id),
    CONSTRAINT fk_vot_film          FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id)
);


CREATE TABLE OPTIUNI_PREDEFINITE (
    optiune_id      NUMBER          CONSTRAINT pk_optiuni PRIMARY KEY,
    denumire        VARCHAR2(100)   NOT NULL,
    tip             VARCHAR2(10)    NOT NULL,

    CONSTRAINT chk_optiune_tip      CHECK (tip IN ('POZITIV', 'NEGATIV', 'NEUTRU')),
    CONSTRAINT uq_optiune_denumire  UNIQUE (denumire)
);


CREATE TABLE CLIENTI_FILME_OPTIUNI (
    client_id       NUMBER          NOT NULL,
    film_id         NUMBER          NOT NULL,
    optiune_id      NUMBER          NOT NULL,
    data_selectie   DATE            DEFAULT SYSDATE NOT NULL,
    
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
    --actualizat de trigger
    sentiment           VARCHAR2(10)    DEFAULT 'NEUTRU',
    data_comentariu     DATE            DEFAULT SYSDATE NOT NULL,
    CONSTRAINT chk_com_sentiment    CHECK (sentiment IN ('POZITIV', 'NEGATIV', 'NEUTRU')),
    CONSTRAINT fk_com_client        FOREIGN KEY (client_id)
                                    REFERENCES CLIENTI(client_id),
    CONSTRAINT fk_com_film          FOREIGN KEY (film_id)
                                    REFERENCES FILME(film_id)
);


CREATE TABLE COMENTARII_ACTORI (
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
BEFORE INSERT ON VERSIUNI_FILME FOR EACH ROW
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

--la fiecare insert, update sau delete in voturi, se recalculeaza rating ul filmului
CREATE OR REPLACE TRIGGER TRG_RECALCUL_RATING
AFTER INSERT OR UPDATE OR DELETE ON VOTURI
BEGIN
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

-- la fiecare insert sau update pe comentarii, se actulalizeaza sentimentul

CREATE OR REPLACE TRIGGER TRG_ANALIZA_SENTIMENT
BEFORE INSERT OR UPDATE OF text_comentariu ON COMENTARII
FOR EACH ROW
DECLARE
    v_text      VARCHAR2(2000);
    v_pozitiv   NUMBER := 0;
    v_negativ   NUMBER := 0;
    -- cuvinte cheie pozitive
    TYPE t_cuvinte IS TABLE OF VARCHAR2(50);
    v_cuvinte_poz t_cuvinte := t_cuvinte(
        'minunat','excelent','superb','fantastic','genial','impresionant',
        'placut','recomandat','emotionant','captivant','spectaculos',
        'apreciat','bun','frumos','iubesc','admir','bravo','perfect'
    );
    -- cuvinte cheie negative
    v_cuvinte_neg t_cuvinte := t_cuvinte(
        'slab','plictisitor','dezamagitor','oribil','groaznic','urat',
        'prost','stupid','enervant','banal','previzibil','scenariu slab',
        'dezamagit','nerealist','rau','insuportabil','plictisit'
    );
BEGIN
    v_text := LOWER(:NEW.text_comentariu);

    -- numaram cuvintele pozitive
    FOR i IN 1..v_cuvinte_poz.COUNT LOOP
        IF INSTR(v_text, v_cuvinte_poz(i)) > 0 THEN
            v_pozitiv := v_pozitiv + 1;
        END IF;
    END LOOP;

    -- numaram cuvintele negative
    FOR i IN 1..v_cuvinte_neg.COUNT LOOP
        IF INSTR(v_text, v_cuvinte_neg(i)) > 0 THEN
            v_negativ := v_negativ + 1;
        END IF;
    END LOOP;

    IF v_pozitiv > v_negativ THEN
        :NEW.sentiment := 'POZITIV';
    ELSIF v_negativ > v_pozitiv THEN
        :NEW.sentiment := 'NEGATIV';
    ELSE
        :NEW.sentiment := 'NEUTRU';
    END IF;
END;
/

