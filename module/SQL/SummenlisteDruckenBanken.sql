select  konten.Name,
        konten.KontoNr,
        konten.Kontostand,
        bankenabschluss.Anfangssaldo,
        bankenabschluss.Abschlusssaldo 
from konten
left join bankenabschluss on konten.KontoNr=bankenabschluss.KontoNr
where (bankenabschluss.BuchungsJahr=:BJAHR) and 
      (konten.kontotype = "B") and 
			(konten.statistik < 99)
order by konten.Sortpos