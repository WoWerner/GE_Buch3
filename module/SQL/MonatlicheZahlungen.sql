SELECT ifnull(Vorname,'')||' '||ifnull(Nachname,'')||' ('||Journal.PersonenID||')' as Name,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '01' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS Januar,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '02' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS Februar,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '03' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS Maerz,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '04' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS April,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '05' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS Mai,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '06' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS Juni,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '07' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS Juli,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '08' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS August,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '09' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS September,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '10' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS Oktober,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '11' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS November,
       replace(printf('%.2f €', SUM(CASE WHEN strftime('%m', datum) = '12' THEN Betrag ELSE 0 END)/100.0), '.', ',') AS Dezember,
       replace(printf('%.2f €', SUM(Betrag)/100.0), '.', ',') AS Summe
FROM Journal
left join personen on personen.PersonenID=Journal.PersonenID
where Journal.PersonenID <> 0 AND BuchungsJahr = :BJAHR
GROUP BY Name
order by Nachname, Vorname