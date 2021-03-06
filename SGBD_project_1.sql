**********************Gestion spectacle*****************************
**************************Annuler Spectacle*************************

*************V?rification exsistance de spectacle*******************

   CREATE OR REPLACE FUNCTION idspec_exist (id_spec spectacle.idspec%TYPE) RETURN BOOLEAN IS
    ids spectacle.idspec%TYPE;
BEGIN
    SELECT idspec INTO ids
    FROM spectacle
    WHERE idspec = id_spec;  
    
    RETURN TRUE ;
EXCEPTION
    WHEN no_data_found THEN
        RETURN false;
END idspec_exist;

*********test************
DECLARE
    tests BOOLEAN;
BEGIN
    tests := idspec_exist(40);
    IF tests THEN
        dbms_output.put_line('Ok!');
    ELSE
        dbms_output.put_line('Not OK!');
    END IF;
END;
**************************Annuler Spectacle*****************

CREATE OR REPLACE PROCEDURE annul_spec (
    id_spec spectacle.idspec%TYPE
) IS
BEGIN
    IF idspec_exist(id_spec) THEN
        UPDATE spectacle SET h_debut = NULL
        WHERE idspec = id_spec;
    dbms_output.put_line('modification effectu? avec succ?e !');

    ELSE
        raise_application_error(-20002, 'Aucun Sp?ctacle avec cet id !');
    END IF;
    commit;
END;
**********Test****************
DECLARE
    t BOOLEAN;
BEGIN
    annul_spec(50);   
END;

DECLARE
    t BOOLEAN;
BEGIN
    annul_spec(41);  
END;
***************ajouter spectacle******************************
***************(1)sectacle valide*******************************   

    CREATE OR REPLACE FUNCTION  spec_valid (
    da   spectacle.dates%TYPE,
    hd   spectacle.h_debut%TYPE,
    d   spectacle.durees%TYPE,
    l    spectacle.idlieu%TYPE
) RETURN BOOLEAN AS
    v_id   spectacle.idspec%TYPE;
    v_hd   spectacle.h_debut%TYPE;
    v_d  spectacle.h_debut%TYPE;
    h_f    spectacle.h_debut%TYPE := hd + d ;
    CURSOR cur_spec  IS 
        SELECT
            idspec,
            h_debut,
            durees            
        FROM
            spectacle
        WHERE
            dateS = da
            AND idlieu = l    
     AND ( hd BETWEEN  h_debut AND   h_debut + durees  AND  hd NOT IN (h_debut+durees) 
            OR            
              h_f BETWEEN  h_debut AND   h_debut + durees  AND  h_f NOT IN (h_debut )       
            OR 
           ( hd<h_debut AND h_f> h_debut + durees ) );
BEGIN
    OPEN cur_spec;
    FETCH cur_spec INTO
        v_id,
        v_hd,
        h_f;
    IF cur_spec%notfound THEN --pas de croisement entre les spectacles
        RETURN true;
    ELSE
        h_f:=v_hd+h_f;
        dbms_output.put_line('le lieu dont l''ID est : '
                             || l
                             || ' est occup? le '
                             || v_hd
                             || ' ? '
                             || h_f
                             || ' heure');
        RETURN false;
    END IF;
END spec_valid;

***************(2)ajouter spectacle******************************
create or replace 
PROCEDURE ajout_spec (
    tit         spectacle.titre%TYPE,
    date_spec   spectacle.dateS%TYPE,
    h_d          spectacle.h_debut%TYPE,
    D          spectacle.dureeS%TYPE,
    nb_S         spectacle.nbrspectateur%TYPE,
    id_l         spectacle.idlieu%TYPE
) IS
BEGIN                 
     IF spec_valid(date_spec, h_d, D, id_l) THEN  
                      
                    INSERT INTO spectacle VALUES (
                         seq.NEXTVAL,
                         tit,
                         date_spec,
                         h_d,
                         D,
                         nb_S,
                         id_l
                );          

        ELSE
            raise_application_error(-20032, 'Lieu n''est pas disponible pendant ? cet horaire!');
        END IF;    
END ajout_spec;

****************test validation n exuiste pas un coisement entre le spectacles***************

SET SERVEROUTPUT ON 
DECLARE
    tests BOOLEAN;
BEGIN
    tests := spec_valid(to_date('2021-12-16','YYYY-MM-DD'),18,4,10);

    IF tests THEN
        dbms_output.put_line('spectacle valide');
    ELSE
        dbms_output.put_line('spectacle non valide');
    END IF;
END;
************test ajouter spectacle************************
SET SERVEROUTPUT ON 
DECLARE
BEGIN
ajout_spec('Mahouch Mawjoud',to_date('2022-1-10','YYYY-MM-DD'),10,4,400,4);
END;

*****************Modifier spectacle******************

*************V?rification exsistance de spectacle******

CREATE OR REPLACE FUNCTION idspec_exist (
    id_spec spectacle.idspec%TYPE
) RETURN BOOLEAN IS
    ids spectacle.idspec%TYPE;
BEGIN
    SELECT
        idspec
    INTO ids
    FROM
        spectacle
    WHERE
        idspec = id_spec;

    IF ids = id_spec THEN
        RETURN true;
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        RETURN false;
END idspec_exist; 
**************test**************
SET SERVEROUTPUT ON 
DECLARE
    t BOOLEAN;
BEGIN
    t := idspec_exist(45); /*erreur avec 20*/
    IF t THEN
        dbms_output.put_line('Spectacle existe');
    ELSE
        dbms_output.put_line('Spectacle n''exsiste pas!');
    END IF;
END;

******************Modifier titre du spectacle*********
CREATE OR REPLACE PROCEDURE modif_titre(id spectacle.IDSPEC%TYPE,titre1 spectacle.TITRE%TYPE)
IS
t boolean;
BEGIN 
 t := idspec_exist(id) ;
 if t then 
     update spectacle 
     set titre=titre1
     where idspec = id; 
else
    RAISE_APPLICATION_ERROR(-20115,'cet ID n''existe pas!');
END IF;
commit;          
END modif_titre;

****************test*******************
 SET SERVEROUTPUT ON
  DECLARE
   BEGIN 
     modif_titre(101,'Mahouch Mawjoud_modifie');
   END;
***************Modifier date du spactacle*****************

create or replace 
PROCEDURE modif_date(id in NUMBER,nvdate in date) IS
t boolean;
    BEGIN 
        t := idspec_exist(id) ;
        if t then 
            update spectacle set DATES=to_date(nvdate,'DD-MON-YY') where idspec=id; 
        else
            RAISE_APPLICATION_ERROR(-20115,'cet ID n''existe pas !');
        END IF;
commit;          
END modif_date;
*************test*************
SET SERVEROUTPUT ON
  DECLARE
    BEGIN
    modif_date(101,to_date('2022-09-19','YYYY-MM-DD'));
    END;
    
**************Modifier heure de d?but du spectacle******************

Create or replace PROCEDURE modif_heure_debut(id in NUMBER,heure in NUMBER)
IS
t boolean;
BEGIN 
 t := idspec_exist(id) ;
 if t then 
        update spectacle set H_DEBUT=heure where idspec=id;
        DBMS_OUTPUT.PUT_LINE ('Modification avec success');
else
    RAISE_APPLICATION_ERROR(-20119,'cet ID n''existe pas!');
END IF;
COMMIT;
END modif_heure_debut;

****************trig apr?s la modification d''heur debut spectacle*********

CREATE OR REPLACE TRIGGER TRIGGER_AFTER_MODIF_HDEBUT_S 
AFTER UPDATE OF h_debut ON SPECTACLE 
FOR EACH ROW
DECLARE 
   difference  spectacle.DUREES%TYPE;
   idrubrique rubrique.IDRUB%TYPE;
   nb_rubriques int ;
   heure_d spectacle.DUREES%TYPE;
   CURSOR cur  IS 
        SELECT IDRUB,H_DEBUTR  
        FROM rubrique
        WHERE idspec = :NEW.idspec;
BEGIN  
	difference := :NEW.H_DEBUT - :OLD.H_DEBUT;

   dbms_output.put_line(difference);
    OPEN cur; 
       LOOP
           FETCH cur INTO idrubrique,heure_d;
           EXIT	WHEN	NOT	cur%FOUND;		
              dbms_output.put_line(idrubrique);
           update rubrique set H_DEBUTR = H_DEBUTR + difference  where idspec=:NEW.idspec and IDRUB = idrubrique;
        END	LOOP;
END;
**************test**************
SET SERVEROUTPUT ON
  DECLARE
    BEGIN
    modif_heure_debut(101,11);
    END;
    
**************modifier duree du spectacle**********************

CREATE OR REPLACE PROCEDURE modif_duree(id in NUMBER,duree1 in NUMBER) 
IS
t boolean;
BEGIN 
 t := idspec_exist(id) ;
 if t then 
   update spectacle set DUREES=duree1 where idspec=id;
   DBMS_OUTPUT.PUT_LINE ('Modification avec success'); 
 
else
    RAISE_APPLICATION_ERROR(-20115,'cet id n''existe pas!');
END IF;   
commit;
END modif_duree;

******************trig apr?s modification duree spectacle*********************

CREATE OR REPLACE TRIGGER TRIGGER_APRES_MODIF_DUREE_S 
AFTER UPDATE OF dureeS ON SPECTACLE 
FOR EACH ROW
DECLARE 
   difference  spectacle.DUREES%TYPE;
   idrubrique rubrique.IDRUB%TYPE;
   nb_rubriques int ;
   dur spectacle.DUREES%TYPE;
   CURSOR cur  IS 
        SELECT IDRUB,DUREERUB 
        FROM rubrique
        WHERE idspec=:NEW.idspec;
BEGIN  
	difference := :NEW.DUREES - :old.DUREES;
	select count(IDRUB)
   into nb_rubriques
   from rubrique
   where idspec=:NEW.idspec;
   OPEN cur;
   LOOP
   FETCH cur INTO idrubrique,dur;
   EXIT	WHEN	NOT	cur%FOUND;	
   dbms_output.put_line( idrubrique );
   update rubrique set DUREERUB = :NEW.DUREES / nb_rubriques where idspec=:NEW.idspec and IDRUB = idrubrique;
END LOOP; 
END;

*****************test*************
SET SERVEROUTPUT ON
  DECLARE
    BEGIN
    modif_duree(101,3);
    END;
    
**********************Modifier nombre de spectateurs*******************

create or replace 
PROCEDURE modif_spectateur(id in NUMBER,nbr IN NUMBER )
IS
t boolean;
BEGIN 
    t := idspec_exist(id) ;
    if t then 
        update spectacle set nbrSpectateur=nbr where idspec=id;
        DBMS_OUTPUT.PUT_LINE ('Modification avec success'); 
    else
        RAISE_APPLICATION_ERROR(-20115,'cet ID n''existe pas !');
    END IF; 
commit;
END modif_spectateur;

*****************trig verification nbr spectateur avant modification*******************

CREATE OR REPLACE TRIGGER TRIGGER_VERIF_NBR_SPECTATEURS 
BEFORE UPDATE ON SPECTACLE 
FOR EACH ROW
  DECLARE 
  vid_lieu SPECTACLE.IDLIEU%TYPE ;
  vcap Lieu.capacite%TYPE ;
BEGIN

	select CAPACITE into vcap 
	from  lieu 
	where idlieu=:NEW.IDLIEU;

  IF  :NEW.nbrSpectateur > vcap then 
            RAISE_APPLICATION_ERROR(-20104,'Le nombre des spectateurs est superieur au capacite de lieu !');
  END IF;
  END;
***************test******************
SET SERVEROUTPUT ON
  DECLARE
    BEGIN
    modif_spectateur(101,420);
    END;
*****************Modifier lieu du spectacle**********************

 create or replace 
PROCEDURE modif_lieu(id in NUMBER,id_nvlieu spectacle.IDLIEU%TYPE )
IS
t boolean;
BEGIN 
    t := idspec_exist(id) ;
    if t then 
        update spectacle set IDLIEU=id_nvlieu where idspec=id;
        DBMS_OUTPUT.PUT_LINE ('Modification avec success'); 
    else
        RAISE_APPLICATION_ERROR(-20117,'cet ID n''existe pas !');
    END IF; 
commit;
END modif_lieu;
***************test******************
SET SERVEROUTPUT ON
  DECLARE
    BEGIN
    modif_lieu(101,12);
    END;

**************rechercher spectacle par id********************

CREATE OR REPLACE FUNCTION recherche_spec_par_idspec (id_spec spectacle.idspec%TYPE) RETURN BOOLEAN IS
    ids spectacle.idspec%TYPE;
BEGIN
    SELECT
        idspec
    INTO ids
    FROM
        spectacle
    WHERE
        idspec = id_spec;

    IF ids = id_spec THEN
        RETURN true;
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        RETURN false;
END recherche_spec_par_idspec;

***************test******************
SET SERVEROUTPUT ON
  DECLARE
  tests boolean;
  var spectacle%RowType;
    BEGIN
      tests := recherche_spec_par_idspec(101);
        if tests then
          select * INTO var from spectacle where idSpec=101;
        else 
          DBMS_OUTPUT.PUT_LINE ('ce spectacle n''existe pes');
      end if;
    END;
*****************rechercher spectacle par titre**************************
CREATE OR REPLACE FUNCTION recherche_spec_titre (nvtitre spectacle.titre%TYPE) RETURN BOOLEAN IS
    v_titre spectacle.titre%TYPE;
BEGIN
    SELECT
        titre
    INTO v_titre
    FROM spectacle
    WHERE upper(titre) = upper(nvtitre);
    RETURN true;

EXCEPTION
    WHEN no_data_found THEN
        RETURN false;
END recherche_spec_titre;
***************test******************
SET SERVEROUTPUT ON
  DECLARE
  tests boolean;
  var spectacle%RowType;
    BEGIN
      tests := recherche_spec_titre('Mahouch Mawjoud_modifie');
        if tests then
          select * INTO var from spectacle where Titre='Mahouch Mawjoud_modifie';
        else 
          DBMS_OUTPUT.PUT_LINE ('ce spectacle n''existe pes');
      end if;
    END;
*******************Gestion Rubrique************************
****************** Ajouter Rubrique************************
******************Verifi? si artiste disponible*************
create or replace FUNCTION artiste_dispo (
    id_art   artiste.idart%TYPE,
    d        spectacle.dates%TYPE,
    hd       rubrique.h_debutr%TYPE,
    duree    rubrique.dureerub%TYPE,
    typer        rubrique.type%TYPE
) RETURN BOOLEAN IS
    hf     rubrique.h_debutr%TYPE := hd + duree; --heure fin  de la rubrique a ajouter 
    vida   rubrique.idart%TYPE;  
    vs     artiste.specialite%TYPE;
    copie_typer artiste.specialite%TYPE;
    CURSOR cur_rubart IS
    SELECT
            r.idart         
        FROM
            rubrique    r,
            spectacle   s
        WHERE
            r.idspec = s.idspec
            AND s.dates = d    -- la date donn?e pour l'artiste donn?
            AND idart = id_art
            AND ( hd BETWEEN  h_debutr AND   h_debutr + dureerub  AND  hd NOT IN (h_debutr+dureerub) 
            OR            
              hf BETWEEN  h_debutr AND   h_debutr + dureerub  AND  hf NOT IN (h_debutr )       
              OR 
           ( hd<h_debutr AND hf> h_debutr + dureerub ));
BEGIN
        SELECT
            DISTINCT(a.specialite )    
        INTO vs
        FROM
            artiste a ,rubrique r
        WHERE
            a.idArt=r.idArt
            AND
            a.idart = id_art;
copie_typer:=typer ;

IF typer='com?die' THEN 
 copie_typer:= 'humoriste' ;
END IF ;

IF typer='theatre' THEN 
 copie_typer:= 'acteur' ;
END IF ;
IF typer='dance' THEN 
 copie_typer:= 'danseur ' ;
END IF ;
IF typer='imitation' THEN 
 copie_typer:= 'imitateur' ;
END IF ;
IF typer='magie' THEN 
 copie_typer:= 'magicien' ;
END IF ;
IF typer='musique' THEN 
 copie_typer:= 'musicien' ;
END IF ;
IF typer='chant' THEN 
 copie_typer:= 'chanteur' ;
END IF ;
IF vs = copie_typer THEN   
            OPEN cur_rubart;

            FETCH cur_rubart INTO
                vida;                
            IF cur_rubart%notfound THEN   
               dbms_output.put_line('artiste disponible');

                RETURN true;
            ELSE
                dbms_output.put_line('artiste non disponible');

                RETURN false;
            END IF;
    ELSE
        dbms_output.put_line('Probleme de specialit?e ou id inex!!');
        RETURN false;
    END IF;
END artiste_dispo;

*******************verifier la validit? de rubrique******************

create or replace FUNCTION rub_valid (
    ids     rubrique.idspec%TYPE,
    hd      rubrique.h_debutr%TYPE,
    duree   rubrique.dureerub%TYPE
) RETURN BOOLEAN AS

    hf                rubrique.h_debutr%TYPE := hd + duree; 

    vds               spectacle.durees%TYPE; 
    vsdr              rubrique.dureerub%TYPE; 
    vhds              spectacle.h_debut%TYPE;
    vcount            INT;                    
    
    test_duree        BOOLEAN;
    test_commence     BOOLEAN;
    test_croisement   BOOLEAN;

    chd               spectacle.h_debut%TYPE;
    chf               spectacle.h_debut%TYPE;
    CURSOR cur_rub IS 
        SELECT
            h_debutr,
            h_debutr + dureerub h_finr
        FROM
            rubrique
        WHERE
            idspec = ids
            AND((hd BETWEEN h_debutr AND h_debutr +dureerub AND  hd NOT IN (h_debutr+dureerub) 
                OR
                (hf BETWEEN h_debutr AND h_debutr +dureerub AND  hf NOT IN (h_debutr ) )
                OR 
           ( hd<h_debutr AND hf> h_debutr + dureerub )
                ));

    BEGIN
        SELECT 
            durees,
            h_debut
        INTO
            vds,
            vhds
        FROM
            spectacle
        WHERE
            idspec = ids;
        
        IF hd + duree <= vhds + vds AND hd >= vhds THEN                 

                OPEN cur_rub;
                FETCH cur_rub INTO
                    chd,
                    chf;
                IF cur_rub%notfound THEN 
                      

                        SELECT  COUNT(*) INTO vcount                                                
                        FROM rubrique
                        WHERE idspec = ids;

                        IF vcount < 3 THEN   

                        SELECT SUM(dureerub)   
                        INTO vsdr
                        FROM 
                            rubrique r
                        WHERE 
                            idspec = ids;



                        IF vds - vsdr - duree < 0 THEN 
                            dbms_output.put_line('prob durree');

                            RETURN FALSE;

                        ELSE
                            RETURN TRUE;

                        END IF ;

                    ELSE
                        dbms_output.put_line('exist 3');

                        RETURN FALSE;

                    END IF;
                

                ELSE
                    dbms_output.put_line('rubriques croisent');

                    RETURN FALSE ; 


                END IF;

        ELSE
            dbms_output.put_line('prob rubrique spect');

            RETURN FALSE;

        END IF ;

END rub_valid;

****************ajouter rubrique*********************

CREATE OR REPLACE PROCEDURE ajout_rub (
    ids   spectacle.idspec%TYPE,
    idart   artiste.idart%TYPE,
    hd_reb   rubrique.h_debutr%TYPE,
    Duree   rubrique.dureerub%TYPE,
    typer   rubrique.type%TYPE
) IS    
datespectacle spectacle.dates%TYPE;
BEGIN
        SELECT   
            dates
        INTO datespectacle
        FROM
            spectacle
        WHERE
            idspec = ids;
 IF artiste_dispo(idart, datespectacle, hd_reb, Duree,typer ) 
THEN 
              
           IF rub_valid(ids, hd_reb, Duree) 
               THEN   
                            INSERT INTO rubrique VALUES (
                                      seq.NEXTVAL,
                                     ids,
                                     idart,
                                     hd_reb,
                                     Duree,
                                      typer );
                ELSE
                    raise_application_error(-20038, 'Horaire invalide!');
                END IF;
            ELSE
                raise_application_error(-20039, 'verifier la disponibilit? ou le type de l''artiste!');
            END IF;
END ajout_rub;
*******************test******************
BEGIN
        ajout_rub(101,6,11,0.2,'com?die');
END;
***********************verifier l''existance du rebrique********************

CREATE OR REPLACE FUNCTION idrub_exist ( id_rub rubrique.idrub%TYPE
) RETURN BOOLEAN IS
    idr rubrique.idrub%TYPE;
BEGIN
    SELECT idrub INTO idr
    FROM rubrique
    WHERE
        idrub = id_rub;
    IF idr = id_rub THEN
        RETURN true;
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        RETURN false;
END idrub_exist;

*******************valider artiste************************
CREATE OR REPLACE FUNCTION validation_artiste (
v_idartiste rubrique.idart%TYPE
) RETURN BOOLEAN AS
v_id artiste.idart%TYPE;
CURSOR cur_art IS SELECT idart
FROM artiste
WHERE IDART=v_idartiste ; 
BEGIN
OPEN cur_art;
    FETCH cur_art INTO
                v_id;                
            IF cur_art%notfound THEN  
                 dbms_output.put_line('l''artiste dont I"ID est :'||v_idartiste||'n''existe pas');
                RETURN FALSE ;               
            ELSE 
                return TRUE;
         END IF ;
end validation_artiste;

*****************trig modifier duree de rubrique*********************************

CREATE OR REPLACE TRIGGER TRIGGER_MODIF_DUREE_RUB 
BEFORE UPDATE OF dureeRub,  H_debutR ON RUBRIQUE 
FOR EACH ROW        
        DECLARE
         pragma autonomous_transaction;

            chd               spectacle.h_debut%TYPE;
    chf               spectacle.h_debut%TYPE;
        V_DUREES spectacle.DUREES%TYPE ;
        V_debut spectacle.DUREES%TYPE ;
        CURSOR cur_rub IS
        SELECT
            h_debutr,
            h_debutr + dureerub 
        FROM
            rubrique
        WHERE
            idspec =  :NEW.IDSPEC
            AND 
            idRub !=:NEW.idRub
            AND((:NEW.H_debutR BETWEEN h_debutr AND h_debutr +dureerub AND  :NEW.H_debutR NOT IN (h_debutr+dureerub) 
                OR
                :NEW.H_debutR + :NEW.dureeRub BETWEEN h_debutr AND h_debutr +dureerub AND  :NEW.H_debutR + :NEW.dureeRub NOT IN (h_debutr ) )
                OR 
           ( :NEW.H_debutR<h_debutr AND :NEW.H_debutR + :NEW.dureeRub > h_debutr + dureerub )
                );        
        BEGIN
        SELECT DUREES,h_debut INTO V_DUREES,V_debut  FROM spectacle WHERE IDSPEC = :NEW.IDSPEC;
    
        IF  :NEW.DUREERUB+:NEW.H_debutR <= V_DUREES+V_debut  AND  V_debut<=:NEW.H_debutR THEN
            OPEN cur_rub;
                FETCH cur_rub INTO
                    chd,
                    chf;
                IF cur_rub%notfound THEN               
                                dbms_output.put_line('dur?e de rubrique  par rapport a celle du spectacle verifi?e !');

                ELSE 
                    RAISE_APPLICATION_ERROR(-20500,'la dure? de rubrique croise avec une autre');                 
                END IF ;
        ELSE
            RAISE_APPLICATION_ERROR(-20500,'la rubrique croise avec un spectacle');
        END IF ;   
END TRIGGER_MODIF_DUREE_RUB;



CREATE OR REPLACE PROCEDURE modif_heure_debut(id in NUMBER,heure in number)
IS
lv_stmt VARCHAR2 (1000);
BEGIN  
     if  idrub_exist(id) then
           update rubrique set h_debutR=heure where idrub=id; 
    else 
      raise_application_error(-20031,' id n''existe pas'||id);
  END IF;        
END modif_heure_debut;


CREATE OR REPLACE  PROCEDURE modif_duree(id in NUMBER,duree1 in number)
IS
BEGIN  
 if  idrub_exist(id) then
     update rubrique set dureerub=duree1 where idrub=id; 
Else 
      raise_application_error(-20032,' id n''existe pas'||id);
  END IF;
          
END modif_duree;


CREATE OR REPLACE PROCEDURE modif_artiste(id in NUMBER,idartiste in NUMBER)
is
date_spec spectacle.dates%TYPE;
h_d rubrique.h_debutr%TYPE;
duree_rub rubrique.dureerub%TYPE;
tpye_rub rubrique.type%TYPE ;
begin
   if validation_artiste(idartiste) and idrub_exist(id) THEN 
                
        SELECT s.dateS,H_debutR,dureeRub,r.type INTO date_spec ,h_d,duree_rub,tpye_rub 
        FROM RUBRIQUE r ,spectacle s 
        where s.idspec=r.idspec and r.idrub=id ;
        
        IF artiste_dispo(idartiste,date_spec,h_d,duree_rub,tpye_rub) THEN 
            
            update rubrique set idart=idartiste where idrub=id;
        ELSE 
           dbms_output.put_line('artiste non dispo');
        END IF ;
    
   else 
      raise_application_error(-20031,' artiste ou rubrique n''existe pas');
   end if;
end modif_artiste;




******************package*****************

CREATE PACKAGE BODY gestio_rubrique AS
       
    FUNCTION rechercher_rub_idspec (ids rubrique.idspec%TYPE) 
    RETURN BOOLEAN IS
        vid  rubrique.idspec%TYPE;
    BEGIN
                SELECT COUNT(idspec) 
                into vid 
                FROM rubrique
                WHERE
                    idspec = ids;
                if vid = 0 then
                     RETURN false;
                else 
                RETURN true;
                END IF;
    END rechercher_rub_idspec;


   /******************recherche  rubrique avec idratiste donn?e (fonc intermediaire) **************/  
  
   
FUNCTION rechercher_rub_par_idart (ida rubrique.idart%TYPE) 
RETURN BOOLEAN IS
    vid  rubrique.idart%TYPE;
BEGIN
            SELECT COUNT(idart)
            into vid 
            FROM rubrique
            WHERE
                idart = ida;
            if vid = 0 then
                RETURN false;
            else 
            
            RETURN true;
            END IF;
END rechercher_rub_par_idart;

function rechercher_rub_par_nomartiste ( noma artiste.nomart%TYPE) 
RETURN BOOLEAN IS
                          t BOOLEAN;
                          vida_artiste artiste.idart%TYPE;
                        BEGIN
                        select IDART
                        into vida_artiste
                        from artiste 
                        where upper(NOMART) like upper(noma) ;
                        t := rechercher_rub_par_idart (vida_artiste);
                        if t then 
                        return true;
                        else 
                        return false;
                        end if;
                        END rechercher_rub_par_nomartiste;
                    
PROCEDURE supprimer_rub (idr rubrique.idrub%TYPE) IS
    vids   rubrique.idspec%TYPE;
    vds    spectacle.dates%TYPE;
BEGIN
            DELETE FROM rubrique
            WHERE
                idrub = idr;

            dbms_output.put_line('1 Row was dropped successfuly');
        exception 
        When no_data_found then
            dbms_output.put_line('pas de suppression ! verifiez id rub');
END supprimer_rub;
 END gestio_rubrique;
 
 CREATE PACKAGE gestio_rubrique AS
FUNCTION rechercher_rub_idspec (ids rubrique.idspec%TYPE) RETURN BOOLEAN ;
FUNCTION rechercher_rub_par_idart (ida rubrique.idart%TYPE) RETURN BOOLEAN ;
function rechercher_rub_par_nomartiste ( noma artiste.nomart%TYPE) RETURN BOOLEAN;
PROCEDURE supprimer_rub (idr rubrique.idrub%TYPE);
END gestio_rubrique;



ALTER TABLE RUBRIQUE 
ADD CONSTRAINT CHK_TYPE 
CHECK(type in('com?die','theatre','dance',' imitation','magie', 'musique','chant'));



CREATE OR REPLACE TRIGGER TRIGGER_DUREE_RUB 
BEFORE INSERT ON RUBRIQUE 
FOR EACH ROW 
        
        DECLARE
        V_DUREES spectacle.DUREES%TYPE ;
        
   BEGIN
        SELECT DUREES INTO V_DUREES  FROM spectacle WHERE IDSPEC = :NEW.IDSPEC;
        
        IF  :NEW.DUREERUB <= V_DUREES then 
            dbms_output.put_line('dur?e de rubrique  par rapport a celle du spectacle verifi?e !');
        ELSE 
            RAISE_APPLICATION_ERROR(-20101,'la dure? de rubrique ne peut pas d?passer celle du spectacle');
        END IF;
   END;
   
   
   CREATE OR REPLACE TRIGGER TRIGGER_HEURE_RUB 
BEFORE INSERT ON RUBRIQUE 
FOR EACH ROW 
        
        DECLARE
        V_H_DEBUT spectacle.H_DEBUT%TYPE;
        v_fin_spec spectacle.H_DEBUT%TYPE;
        dur int;
        BEGIN
        SELECT H_DEBUT INTO V_H_DEBUT  FROM spectacle WHERE IDSPEC = :NEW.IDSPEC;
        select DUREES into dur FROM spectacle WHERE IDSPEC = :NEW.IDSPEC;
        v_fin_spec := V_H_DEBUT + dur ;

        IF    V_H_DEBUT <= :NEW.H_DEBUTR and  :NEW.H_DEBUTR <= v_fin_spec then 
            dbms_output.put_line('l heure de debut de rubrique  par rapport a celle du spectacle verifi? !');
        ELSE 
            RAISE_APPLICATION_ERROR(-20000,'erreur !! une rubrique ne commence pas avant/apres le spectacle');
        END IF;
        END;
        
        
        
         CREATE OR REPLACE FUNCTION  somme_duree_rubrique (id_s spectacle.idspec%TYPE) 
RETURN int IS
    somme int;
BEGIN
    select sum(dureeRub) 
    into somme
    from rubrique 
    where idspec=id_s;
    dbms_output.put_line(somme);
    RETURN(somme);
     IF SQL%FOUND THEN
      raise_application_error (-20001,
                               'Data was found in the vinegar table.');
   END IF;
END somme_duree_rubrique;



CREATE OR REPLACE TRIGGER TRIGGER_SOMME_DUREE_RUB 
BEFORE INSERT ON RUBRIQUE 
FOR EACH ROW 
        
        DECLARE
        duree_spectacle spectacle.H_DEBUT%TYPE;
        vduree rubrique.dureeRub%TYPE;
        somme int;
        BEGIN
        SELECT dureeS INTO duree_spectacle  FROM spectacle WHERE IDSPEC = :NEW.IDSPEC;
        
        somme:= somme_duree_rubrique(:NEW.IDSPEC);
 

        IF    duree_spectacle = somme  then 
      
RAISE_APPLICATION_ERROR(-20000,'les durees des rubriques depassent le spectacle!!');
        END IF;

        END;
        
        
        
      ALTER TABLE BILLET 
      ADD CONSTRAINT CHK_CATEGORIE 
      CHECK(categorie in('gold','silver','normale'));
      
  ALTER TABLE BILLET ADD CONSTRAINT CHK_prix_categorie
  CHECK( (prix BETWEEN 50 AND 100 AND UPPER(categorie) LIKE 'NORMALE') 
          or (prix BETWEEN 100 AND 200 AND UPPER(categorie) LIKE 'SILVER') 
          OR (prix BETWEEN 200 AND 300 AND UPPER(categorie) LIKE 'GOLD'));
          
 
 CREATE OR REPLACE TRIGGER TRIGGER_SPECTACLE_EXISTE 
BEFORE INSERT ON BILLET 
 FOR EACH ROW 
        
        DECLARE
        v_test int;
        BEGIN
        select count(idspec) 
        into v_test
        from spectacle 
        where idspec= :New.idspec ;

        if v_test=1 then 
        dbms_output.put_line('idspec verifi?e ');

        else 
        RAISE_APPLICATION_ERROR(-20199,'ce idspec est inexistant  !!');
        END IF;
        END;         

DROP TRIGGER TRIGGER_DATE_SPECTACLES;

CREATE OR REPLACE TRIGGER TRIGGER_DATE_SPECTACLES 
BEFORE INSERT ON SPECTACLE 
/*REFERENCING OLD AS Ancien NEW AS Nouveau*/
  FOR EACH ROW
   BEGIN
     IF :NEW.dateS <= SYSDATE THEN
     raise_application_error(-20101, 'Date invalide !!');
     END IF;
  END;



