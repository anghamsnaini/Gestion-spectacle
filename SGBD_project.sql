
CREATE TABLE Lieu
	(idLieu INTEGER PRIMARY KEY,
	NomLieu VARCHAR2 (30) NOT NULL,
	Adresse VARCHAR2 (100) NOT NULL,
      capacite NUMBER NOT NULL);
      
CREATE TABLE Artiste
	(idArt INTEGER PRIMARY KEY,
	NomArt VARCHAR2 (30) NOT NULL,
	PrenomArt VARCHAR2 (30) NOT NULL,
        specialite VARCHAR2 (10) NOT NULL);
        
CREATE TABLE SPECTACLE 
	(idSpec INTEGER PRIMARY KEY,
	Titre VARCHAR2 (40) NOT NULL,
         dateS DATE NOT NULL,
         h_debut NUMBER(4,2) NOT NULL,
	 dureeS NUMBER(4,2) NOT NULL,
         nbrSpectateur INTEGER NOT NULL,
	 idLieu INTEGER,
	CONSTRAINT chk_spect_durees CHECK (dureeS BETWEEN 1 AND 4),
        CONSTRAINT FK_spect_Lieux FOREIGN KEY(idLieu)REFERENCES Lieu (idLieu));
        
CREATE TABLE Rubrique
	(idRub INTEGER PRIMARY KEY, 
	 idSpec INTEGER NOT NULL, 
	 idArt INTEGER NOT NULL, 
	 H_debutR NUMBER(4,2) NOT NULL, 
         dureeRub NUMBER(4,2) NOT NULL, 
         type VARCHAR2(10), 
      CONSTRAINT fk_rub_spect FOREIGN KEY(idSpec) REFERENCES SPECTACLE(idSpec) ON DELETE CASCADE,
CONSTRAINT fk_rub_art FOREIGN KEY(idArt)  REFERENCES Artiste(idArt) ON DELETE CASCADE );

CREATE TABLE BILLET
	(idBillet INTEGER PRIMARY KEY,
	categorie VARCHAR2(10),
	prix NUMBER(5,2) NOT NULL,
	idspec INTEGER NOT NULL ,
	Vendu VARCHAR(3) NOT NULL, 
CONSTRAINT chk_billet_PRIX CHECK(prix BETWEEN 10 AND 300),
CONSTRAINT fk_billet_spec FOREIGN KEY (idspec)REFERENCES spectacle,
CONSTRAINT chk_billet_vendu CHECK(vendu IN ('Oui','Non'))
);

CREATE TABLE Client 
  (idClt INTEGER PRIMARY KEY ,
    nomClt VARCHAR (30) NOT NULL ,
    prenomClt VARCHAR (30) NOT NULL ,
    tel INTEGER ,
    email VARCHAR (30) NOT NULL ,
    motP VARCHAR (30) NOT NULL);
    
    
     *****************Cr?ation de s?quance*********************  
CREATE SEQUENCE Seq
START WITH 1
MAXVALUE 500;
*****************Insertion Lieu****************************
INSERT INTO LIEU VALUES(1, 'CABARET RESTAURANT SHEHERAZADE','M?dina Mediterranea - Yasmine-Hammamet - Tunisie',100);
INSERT INTO LIEU VALUES(2, 'TH??TRE EL HAMRA','28,rue El Jazira - Tunis - Tunisie',550);
INSERT INTO LIEU VALUES(3, 'Th??tre Municipal de Tunis','Avenue Bourguiba - Tunis - Tunisie',1099);
INSERT INTO LIEU VALUES(4, 'CIN?MA TUNISIA ODYSS?E','Medina Mediterranea - Yasmine-Hammamet - Tunisie',435);
INSERT INTO LIEU VALUES(5, 'L''?TOILE DU NORD','41, avenue Farhat-Hached - Tunis - Tunisie',1067);
INSERT INTO LIEU VALUES(6, 'Path? Tunis City','Cebalet ben ammar, route de bizerte km 17 Ariana, Tunis 2032, Tunisie',425);
INSERT INTO LIEU VALUES(7, 'CENTRE DOUAR EL HASFI','Route du Zoo-Paradis - 2200 - Tozeur - Tunisie',648);
INSERT INTO LIEU VALUES(8, 'EL MAWEL','5, rue Amine-Abbassi - Tunis - Tunisie',354);
INSERT INTO LIEU VALUES(9, 'EL TEATRO','Avenue Ouled Haffouz - Tunis - Tunisie',1619);
INSERT INTO LIEU VALUES(10, 'ZINEBLEDI','route de tunis km12 - 4000 - Sousse - Tunisie',1772);
INSERT INTO LIEU VALUES(11, 'Le Colis?e','Avenue Habib Bourguiba, Tunis, Tunisie',1490);
INSERT INTO LIEU VALUES(12,	'Cine Jamil','Rue du docteur Mohamed Ben Salah, Ariana, Tunisie',897);
INSERT INTO LIEU VALUES(13,	'L?agora','Rue 1 La marsa',603);
INSERT INTO LIEU VALUES(14,	'Alhambra ?z?phyr?','Centre Commercial Z?phyr La Marsa',958);
INSERT INTO LIEU VALUES(15,	'Cin?Madart','Rue Hbib Bourguiba - Monoprix Dermech, Tunisie',866);
INSERT INTO LIEU VALUES(16,	'theatre opera','CITE DE LA CULTURE A TUNIS',1800);
*****************Insertion Client**************************
INSERT INTO CLIENT  VALUES  (SEQ.nextval,'Angham','Touailia','25030659','angham@touailia.com','snaini');
INSERT INTO CLIENT  VALUES  (SEQ.nextval,'Sameh','Amara','92412277','samah@yahoo.com','samouh');
INSERT INTO CLIENT  VALUES  (SEQ.nextval,'Mariem','Slimene','52912337','mIMI@gmail.com','MIMI');
INSERT INTO CLIENT  VALUES  (SEQ.nextval,'Mahmoud','Abidi','22412298','kahla@gmail.com','Khalil');
******************Insertion Artiste************************
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Hamraoui','Bassem','himoriste');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Gharbi','Karim ','imitateur');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Abdelli','lotfi ','himoriste');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Ben Abdallah','Najla ','Acteur');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Ben Aziza','Maram','Acteur');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Bouchnak','Lotfi ','Musicien');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Rostom','Hichem','Acteur');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Belgacem','Rochdi','danceur');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'groupe','de break dance','danceur');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Gharsa','Zied ','Musicien');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Bacha','Shems Eddine ','Musicien');
INSERT INTO ARTISTE (IDART, NOMART, PRENOMART, SPECIALITE) VALUES (SEQ.nextval,'Hamraoui','Bassem','Chanteur');


*************************insertion Spectacle*******************
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'A peine j''ouvre les yeux',to_date('2021-12-15','YYYY-MM-DD'),17,2.5,300,13);
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'El Jaida',to_date('2021-07-15','YYYY-MM-DD'),10,2,300,12);
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'Belly Dance with Rochdi',to_date('2021-12-30','YYYY-MM-DD'),20,3,60,1);
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'A peine j''ouvre les yeux',to_date('2021-12-28','YYYY-MM-DD'),19,2.5,400,11);
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'Papa Hedi',to_date('2021-12-16','YYYY-MM-DD'),18,3,200,13);
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'Break Dance Show',to_date('2021-12-26','YYYY-MM-DD'),15,2,99,1);
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'Tunisian Music Show',to_date('2021-03-12','YYYY-MM-DD'),20,3,300,8);

*********************Insertion Rubrique*********************************
INSERT INTO RUBRIQUE  VALUES (SEQ.nextval,37,10,20,1,'musique');
INSERT INTO RUBRIQUE  VALUES (SEQ.nextval,37,14,17,1,'musique');
INSERT INTO RUBRIQUE  VALUES (SEQ.nextval,38,15,10,1,'musique'); 
INSERT INTO RUBRIQUE  VALUES (SEQ.nextval,41,21,18.30,1,'dance');
INSERT INTO RUBRIQUE  VALUES (SEQ.nextval,41,22,19,0.5,'dance');
INSERT INTO RUBRIQUE  VALUES (SEQ.nextval,41,21,19.50,0.5,'dance');
INSERT INTO RUBRIQUE  VALUES (SEQ.nextval,41,22,19.60,0.1,'dance');

********************Insertion Billet*************************************
INSERT INTO BILLET  VALUES (SEQ.nextval,'gold',210,37,'Oui'); 
INSERT INTO BILLET  VALUES (SEQ.nextval,'normale',50,38,'Non');
INSERT INTO BILLET  VALUES (SEQ.nextval,'silver',140,38,'Oui');
INSERT INTO BILLET  VALUES (SEQ.nextval,'silver',170,39,'Oui');
INSERT INTO BILLET  VALUES (SEQ.nextval,'gold',280,40,'Oui');
INSERT INTO BILLET  VALUES (SEQ.nextval,'normale',70,41,'Non');
INSERT INTO BILLET  VALUES (SEQ.nextval,'normale',80,44,'Oui');


**************************Contraintes*********************

******************contrainte Client*********************
ALTER TABLE Client
 ADD CONSTRAINT mailclit
  CHECK (email IS NOT NULL AND email LIKE '%@%');
ALTER TABLE Client 
 ADD CONSTRAINT telclt
  CHECK (tel IS NOT NULL AND LENGTH(tel)=8);
  
******************contrainte Lieu*********************
ALTER TABLE Lieu
 ADD CONSTRAINT caplieu
  CHECK (capacite BETWEEN 100 AND 2000);
******************contrainte Artiste*********************
ALTER TABLE Artiste
 ADD CONSTRAINT specialart
  CHECK (UPPER(specialite) IN ('DANCEUR','ACTEUR','MUSICIEN',
  'MAGICIEN','IMITATEUR','HIMORISTE','CHANTEUR'));
  
 ************************contrainte spectacle************************ 
  CREATE OR REPLACE TRIGGER TRIGGER_NBR_SPECTATEURS 
BEFORE INSERT ON SPECTACLE 
/*REFERENCING OLD AS Ancien NEW AS Nouveau*/
FOR EACH ROW 
DECLARE
vcap Lieu.capacite%type;
BEGIN
  SELECT capacite INTO vcap FROM lieu WHERE idlieu = :NEW.idlieu;
  IF :NEW.nbrSpectateur > vcap THEN
  RAISE_APPLICATION_ERROR(-20100, 'le nombre de spectateurs est superieur au capacit? du lieu');
  END IF;
END;

*************test****************
SET SEVEROUTPUT ON
DECLARE
BEGIN
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'Tunisian Music Show',to_date('2021-03-12','YYYY-MM-DD'),20,3,99,1);
END;

SET SEVEROUTPUT ON
DECLARE
BEGIN
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'Tunisian Music Show',to_date('2021-03-12','YYYY-MM-DD'),20,3,200,1);
END;
************************

 CREATE OR REPLACE TRIGGER TRIGGER_DATE_SPECTACLES 
  BEFORE INSERT ON SPECTACLE 
  /*REFERENCING OLD AS Ancien NEW AS Nouveau*/
  FOR EACH ROW
   BEGIN
     IF :NEW.dateS >= SYSDATE THEN
     raise_application_error(-20101, 'Date invalide !!');
     END IF;
  END; 
****************test*********************
SET SEVEROUTPUT ON
DECLARE
BEGIN
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'aaaaaa',to_date('2019-12-16','YYYY-MM-DD'),18,3,200,13);
END;

SET SEVEROUTPUT ON
DECLARE
BEGIN
INSERT INTO SPECTACLE (IDSPEC, TITRE, DATES, H_DEBUT, DUREES, NBRSPECTATEUR, IDLIEU) VALUES (SEQ.nextval,'aaaaaa',to_date('2022-12-16','YYYY-MM-DD'),18,3,200,13);
END;
******************
  CREATE OR REPLACE FUNCTION  nb_rubrique (id_s spectacle.idspec%TYPE) 
RETURN int IS
    nb int;
BEGIN
    select count(idspec) 
    into nb
    from rubrique 
    where idspec=id_s;

    RETURN(nb);
     IF SQL%FOUND THEN
      raise_application_error (-20001,
                               'Data was found in the vinegar table.');
   END IF;
END nb_rubrique;
    
 CREATE OR REPLACE TRIGGER TRIGGER_AJOUT_RUBRIQUE 
BEFORE INSERT ON RUBRIQUE 
 DECLARE
        V_nb spectacle.IDSPEC%TYPE ;
BEGIN
   V_nb := nb_rubrique(:NEW.IDSPEC);
        
        IF  V_nb >= 3 then 
            RAISE_APPLICATION_ERROR(-20104,'un spectacle a 3 rubriques au max!!');
        END IF;
END;
   
