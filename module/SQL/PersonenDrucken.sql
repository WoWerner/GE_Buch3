select
   PersonenID,
   ifnull(Nachname, '') || ', ' || ifnull(Vorname, '') || ' ' || ifnull(Vorname2, '') as Name,
   Strasse,
   ifnull(PLZ, '') || ' ' || ifnull(Ort, '') as Adr,
   TelPrivat,
   TelDienst,
   Telmobil 
from
   Personen 
order by
   Name COLLATE NOCASE,
   PLZ,
   Ort COLLATE NOCASE,
   Strasse COLLATE NOCASE