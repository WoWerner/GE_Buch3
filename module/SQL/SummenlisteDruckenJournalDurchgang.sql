select
   journal.konto_nach as konto_nach,
   konten.name as name,
   konten.Kontotype as Kontotype,
   journal.BuchungsJahr as BuchungsJahr,
   journal.Betrag as Betrag 
from
   konten 
   join
      journal 
      on konten.kontoNr = journal.konto_nach 
where
   (
      journal.BuchungsJahr = :BJAHR 
      or journal.BuchungsJahr = :BJAHR - 1
   )
   and 
   (
      konten.kontotype = 'D'
   )
   :AddWhere 
order by
   konten.SortPos