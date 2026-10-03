select
   Konto_nach,
   sum(Betrag)* -1 as Summe 
from journal 
left join konten on konten.KontoNr = journal.Konto_nach 
where (konten.Kontotype = "B") and 
      (BuchungsJahr = :BJAHR)  and 
	  (Datum <= :DAT)          and 
	  (konten.statistik <> 99)
group by Konto_nach 
order by konten.Sortpos