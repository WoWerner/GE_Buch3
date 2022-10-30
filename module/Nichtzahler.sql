select
   ifnull(personen.Nachname, '') || ', ' || ifnull(personen.Vorname, '') as Name 
from
   personen 
where
   personenID not in 
   (
      select
         personenID 
      from
         journal 
      where
         Buchungsjahr = :BJahr
   )
order by
   name