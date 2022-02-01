select
	(select '('||ifnull(journal.konto_nach,'')||') '||ifnull(konten.Name,'') from konten where journal.konto_nach = konten.KontoNr) || 
	' nach ' || 
	(select '('||ifnull(journal.BankNr,'')||') '||ifnull(konten.Name,'') from konten where journal.BankNr = konten.KontoNr) as Name,
	(sum(journal.Betrag) * -1) as Summe
from journal
where (journal.BuchungsJahr=:BJAHR) and (journal.Konto_nach in (select konten.KontoNr from konten where konten.Kontotype = 'B')) :AddWhere
group by journal.konto_nach, journal.BankNr
order by journal.konto_nach