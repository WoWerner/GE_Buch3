select Journal.SachkontoNr,
       '('||ifnull(Journal.SachkontoNr,'')||') '||ifnull(Sachkonten.Sachkonto,'') as Sachkonto,
       sum(Betrag) as Betrag
	   from journal
left join Sachkonten on Journal.SachkontoNr=Sachkonten.SachkontoNr
where Buchungsjahr=:BJahr
group by journal.SachkontoNr
order by journal.SachkontoNr