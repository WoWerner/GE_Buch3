select sum(Betrag) as Betrag,
       ifnull(Vorname,'')||' '||ifnull(Nachname,'') as Name,
       '('||ifnull(journal.konto_nach,'')||') '||ifnull(konten.Name,'') as Sachkonto,
       BuchungsJahr,
	   Journal.PersonenID
from Journal
left join personen on personen.PersonenID=Journal.PersonenID
left join konten   on journal.konto_nach=konten.KontoNr
where ((Journal.BuchungsJahr = :BJAHR-1) or (Journal.BuchungsJahr = :BJAHR)) and
      (Journal.PersonenID>0) and
      (konten.Kontotype <> "B") :AddWhere
group by Journal.PersonenID, journal.konto_nach, Journal.BuchungsJahr
order by Nachname, Vorname, konten.sortpos, Journal.BuchungsJahr