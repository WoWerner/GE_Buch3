select  konten.Name,
        konten.KontoNr,
        konten.Kontostand,
        bankenabschluss.Anfangssaldo,
        bankenabschluss.Abschlusssaldo 
from konten
left join bankenabschluss on konten.KontoNr=bankenabschluss.KontoNr
where (bankenabschluss.BuchungsJahr=:BJAHR) and (konten.kontotype = "B")
order by konten.KontoNr