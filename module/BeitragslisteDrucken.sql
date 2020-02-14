select sum(Betrag) as Betrag,
       ifnull(Vorname,'')||' '||ifnull(Nachname,'') as Name,
       '('||ifnull(Journal.SachkontoNr,'')||') '||ifnull(Sachkonten.Sachkonto,'') as Sachkonto,
       BuchungsJahr
from Journal
left join personen   on personen.PersonenID=Journal.PersonenID
left join Sachkonten on Journal.SachkontoNr=Sachkonten.SachkontoNr
where ((Journal.BuchungsJahr = :BJAHR-1) or (Journal.BuchungsJahr = :BJAHR)) and
       (Journal.PersonenID>0) :AddWhere
group by Journal.SachkontoNr, Journal.PersonenID, Journal.BuchungsJahr
order by cast (Journal.SachkontoNr as text), Journal.PersonenID, Journal.BuchungsJahr