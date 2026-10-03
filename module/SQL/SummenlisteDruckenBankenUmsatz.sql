select BankNr,
       sum(Betrag) as Summe
from journal
left join konten on konten.KontoNr = journal.BankNr
where (BuchungsJahr = :BJAHR) and 
      (Datum <= :DAT) and 
	  (konten.statistik <> 99)
group by BankNr
order by konten.Sortpos