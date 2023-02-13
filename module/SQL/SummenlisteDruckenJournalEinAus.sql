select
  konten.KontoNr,
  konten.Name,
  konten.PlanSumme,
  ifnull((Select sum(journal.Betrag) from Journal where (journal.konto_nach = konten.KontoNr) and (journal.BuchungsJahr = :BJAHR)    :AddWhereAnd1) , 0) as Summe_dieses_Jahr,
  ifnull((Select sum(journal.Betrag) from Journal where (journal.konto_nach = konten.KontoNr) and (journal.BuchungsJahr = :BJAHR - 1)             ) , 0) as Summe_letztes_Jahr
from konten
left join journal on konten.KontoNr = journal.konto_nach
where (konten.kontotype = :TYP) and 
      (konten.Statistik <> 99) :AddWhereAnd2 and 	  
	  ((journal.BuchungsJahr = :BJAHR-1) or (journal.BuchungsJahr = :BJAHR) :AddWhereOr)
Group by konten.KontoNr
order by konten.SortPos   