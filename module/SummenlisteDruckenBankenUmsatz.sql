select BankNr,
       sum(Betrag) as Summe
from journal
where (BuchungsJahr = :BJAHR) and (Datum <= :DAT)
group by BankNr
order by BankNr