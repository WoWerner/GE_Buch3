select
   journal.konto_nach,
   '(' || ifnull(journal.konto_nach, '') || ') ' || ifnull(konten.Name, '') as Name,
   sum(Betrag) as Betrag 
from
   journal 
   left join
      konten 
      on journal.konto_nach = konten.KontoNr 
where
   (
      konten.Kontotype <> "B"
   )
   and 
   (
      Buchungsjahr = :BJahr
   )
group by
   journal.konto_nach 
order by
   konten.sortpos