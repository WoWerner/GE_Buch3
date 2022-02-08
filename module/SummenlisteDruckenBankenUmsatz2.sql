select Konto_nach,
       sum(Betrag)*-1 as Summe
from journal
left join konten on konten.KontoNr = journal.Konto_nach
where (konten.Kontotype = "B") and (BuchungsJahr = :BJAHR) and (Datum <= :DAT)
group by Konto_nach
order by Konto_nach