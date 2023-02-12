BEGIN TRANSACTION;
INSERT OR REPLACE INTO konten (KontoNr, Sortpos, Statistik, Name, Kontotype, Kontostand)  VALUES (999, 999, 99, "Ausgleichskonto für Kredite", "B", 0);
INSERT OR REPLACE INTO BankenAbschluss (KontoNr, Buchungsjahr, Anfangssaldo, Abschlusssaldo) VALUES (999, 9999, 0, 0);
INSERT OR REPLACE INTO konten (KontoNr, Sortpos, Statistik, Name, Kontotype, Kontostand)  VALUES (998, 998, 99, "Ausgleichskonto für Depots", "A", 0);
Update init set version = "3.2";
COMMIT;
vacuum;
