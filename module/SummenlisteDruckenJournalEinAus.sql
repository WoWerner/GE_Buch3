select konten.KontoNr as KontoNr,
       journal.konto_nach as konto_nach,
       konten.Name as Name,
       journal.BuchungsJahr as BuchungsJahr,
       sum(journal.Betrag) as Summe
from konten
cross join journal on konten.KontoNr=journal.konto_nach
where (journal.BuchungsJahr=:BJAHR or journal.BuchungsJahr=:BJAHR-1) and (konten.kontotype = :TYP) :AddWhere 
Group by journal.BuchungsJahr, journal.konto_nach
order by konten.SortPos