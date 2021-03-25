

**************************gestion des lieux*************************
*********************Ajouter lieu***********************************
CREATE OR REPLACE PROCEDURE ajout_lieux(idl LIEU.idLieu%TYPE,
   nomL LIEU.NOMLIEU%TYPE,
    adr LIEU.ADRESSE%TYPE,
    cap LIEU.CAPACITE%TYPE)
IS
BEGIN
    INSERT INTO Lieu VALUES
      ( idl, nomL, adr ,cap );
    COMMIT ;
    SYS.DBMS_OUTPUT.PUT_LINE('insertion effectué avec succée !!');
END ajout_lieux ;
***************Test*******************
DECLARE
BEGIN
    ajout_lieux(18,'theatre municipal','centre ville - Tunis',400);   
END;
select * from lieu;
**********************Modifier Lieux**************************
create or replace PROCEDURE modfier_lieux(nomLieu  LIEU.NOMLIEU%TYPE,Adresse1  LIEU.ADRESSE%TYPE,NewnomLieu  LIEU.NOMLIEU%TYPE,
    newcapacite  LIEU.CAPACITE%TYPE) IS
BEGIN
if ((NewnomLieu='null') and (newcapacite>0)) then
dbms_output.put_line('modofocation capcite?');
update Lieu set capacite = newcapacite where NOMLIEU=nomLieu AND Adresse=Adresse1 ;
commit;
elsif ((NewnomLieu!='null') and (newcapacite=0)) then 
dbms_output.put_line('modofocation nom lieu');
update Lieu set NOMLIEU=NewnomLieu where NOMLIEU=nomLieu AND Adresse=Adresse1 ;
commit;
elsif ((NewnomLieu!='null') and (newcapacite>0)) then 
dbms_output.put_line('modifocation du nom de lieu et capacite?!!');
update Lieu set NOMLIEU=NewnomLieu ,capacite=newcapacite where NOMLIEU=nomLieu AND Adresse=Adresse1 ;
commit;
else dbms_output.put_line('modifocation est impossible');  
END IF ;
END modfier_lieux ;
***************Test*******************
DECLARE
BEGIN
    modfier_lieux('theatre municipal','centre ville - tunis','samah',450);
END;
****************création du table SUPP_LOGIQUE_LIEU*************
create table SUPP_LOGIQUE_LIEU 
(idLieu INTEGER PRIMARY KEY,
	NomLieu VARCHAR2 (30) NOT NULL,
	Adresse VARCHAR2 (100) NOT NULL,
      capacite NUMBER NOT NULL);
alter table SUPP_LOGIQUE_LIEU modify (NomLieu null);
alter table SUPP_LOGIQUE_LIEU modify (Adresse null);
alter table SUPP_LOGIQUE_LIEU modify (capacite null);

******************Supprimer Lieu***************************    
create or replace 
PROCEDURE supp_lieu(
    IDP LIEU.IDLIEU%TYPE)
IS
  i number:=0;
  lieu1 LIEU%rowtype;
BEGIN
declare 
  cursor c1 is select * from lieu where IDLIEU=IDP  ;
  cursor c2 is select * from lieu where IDLIEU=IDP and IDLIEU  IN
      (SELECT IDLIEU FROM spectacle) ;  
begin
  open c1 ;
  fetch c1 into lieu1 ;
  if (c1%rowcount = 0) then 
    DBMS_OUTPUT.PUT_LINE('id introuvable');
  ELSE
   for j in c2 loop
   i:=i+1;
   end loop ;
    if (i=0) then 
      DELETE FROM lieu WHERE IDLIEU=IDP ;
      commit;
      DBMS_OUTPUT.PUT_LINE('suppression effectuer avec succee?');
    
    ELSE DBMS_OUTPUT.PUT_LINE('il existe un spectacle avec ce lieu');
     /*commit ;
      DBMS_OUTPUT.PUT_LINE('suppression logique avec succée');*/
    END IF ;
   END IF;
  close c1 ;
end ;
END supp_lieu;
***************Test*******************
DECLARE 
BEGIN
supp_lieu(17);
END;
SELECT * FROM lieu;

***************chercher lieu par ville********************

create or replace procedure rechercheLieuville (ville in varchar)
is
v Lieu%rowtype;
begin
declare
cursor curv is select * from Lieu where ADRESSE=ville;
begin
open curv;
loop
fetch curv into v;
exit when curv%notfound;
dbms_output.put_line('Les lieux qui se situent dans la ville :'||ville||'sont:'||v.nomLieu||' ');
end loop;
if (curv %rowcount=0) then
dbms_output.put_line('il n existe pas de lieux dans cette ville');
end if;
close curv;
end;
end rechercheLieuville;
***************Test******************
DECLARE 
BEGIN
rechercheLieuville('Rue 1 La marsa');
END;
***************chercher lieu par nom********************
create or replace function recherchelieunom (nom Lieu.NOMLIEU%type)
return boolean
is vnom Lieu.NOMLIEU%type;
BEGIN
    Select NomLieu into vnom 
    from Lieu 
    where upper(NomLieu)=upper(nom);
        return true;
    if vnom=null then 
        return false;
    end if;
end recherchelieunom;

***************Test**************************
SET SERVEROUTPUT ON
DECLARE 
tests boolean;
BEGIN
  tests:=recherchelieunom('Le Colisée');
  IF tests then 
    Select * from lieu where nomlieu='Le Colisée';
  else 
    dbms_output.put_line('lieu n''existe pas');
  end if;
END;

alter table SPECTACLE modify (H_DEBUT null); 



