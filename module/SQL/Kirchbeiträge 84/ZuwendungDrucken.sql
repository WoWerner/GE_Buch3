select personen.*, sum(journal.Betrag) as Betrag, CAST(sum(journal.Betrag) AS FLOAT)/100.0 as BetragInEuro
from Personen
left join journal on journal.PersonenID = Personen.PersonenID
left join konten on konten.KontoNr = journal.konto_nach
where (((journal.BuchungsJahr=:BJAHR) and (journal.konto_nach = '84')) :ADDWHERE) 
group by Personen.PersonenID
order by nachname COLLATE NOCASE, vorname COLLATE NOCASE, Ort COLLATE NOCASE, strasse COLLATE NOCASE