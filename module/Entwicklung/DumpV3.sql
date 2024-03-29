BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "Personen" (
	"PersonenID"	INTEGER,
	"BriefAnrede"	VARCHAR(20),
	"Titel"	VARCHAR(20),
	"Vorname"	VARCHAR(100),
	"Vorname2"	VARCHAR(100),
	"Nachname"	VARCHAR(100),
	"Strasse"	VARCHAR(100),
	"Land"	VARCHAR(3),
	"PLZ"	VARCHAR(5),
	"Ort"	VARCHAR(100),
	"Ortsteil"	VARCHAR(100),
	"TelPrivat"	VARCHAR(20),
	"TelDienst"	VARCHAR(20),
	"TelMobil"	VARCHAR(20),
	"eMail"	VARCHAR(100),
	"GE_KartID"	INTEGER,
	"Geburtstag"	DATE,
	"Abgang"	BOOLEAN,
	"Notiz"	VARCHAR(100),
	"Gemeindeglied"	BOOLEAN DEFAULT 'TRUE',
	PRIMARY KEY("PersonenID"));
CREATE TABLE IF NOT EXISTS "konten" (
	"KontoNr"	INTEGER NOT NULL,
	"Sortpos"	INTEGER,
	"Statistik"	INTEGER,
	"Name"	VARCHAR(100),
	"Kontotype"	VARCHAR(2),
	"Kontostand"	INTEGER,
	"Finanzamt"	VARCHAR(100),
	"Finanzamtvom"	VARCHAR(100),
	"Finanzamtnr"	VARCHAR(100),
	PRIMARY KEY("KontoNr")
);
CREATE TABLE IF NOT EXISTS "BankenAbschluss" (
	"KontoNr"	INTEGER,
	"Buchungsjahr"	INTEGER,
	"Anfangssaldo"	INTEGER,
	"Abschlusssaldo"	INTEGER
);
CREATE TABLE IF NOT EXISTS "journal" (
	"LaufendeNr"	INTEGER DEFAULT '''''''''''''''1''''''''''''''',
	"Belegnummer"	VARCHAR(100),
	"Datum"	DATE,
	"BankNr"	INTEGER,
	"Konto_nach"	INTEGER,
	"PersonenID"	INTEGER,
	"Betrag"	INTEGER,
	"Buchungstext"	VARCHAR(200),
	"Bemerkung"	VARCHAR(200),
	"BuchungsJahr"	INTEGER,
	"Aufwandsspende"	VARCHAR(10),
	PRIMARY KEY("LaufendeNr" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "Init" (
	"Passwort"	VARCHAR(25),
	"Buchungsjahr"	INTEGER,
	"Version"	VARCHAR(10),
	"GemeindeName"	VARCHAR(100),
	"GemeindeStrasse"	VARCHAR(100),
	"GemeindePLZ"	VARCHAR(5),
	"GemeindeOrt"	VARCHAR(100),
	"GemeindeTel"	VARCHAR(30),
	"RendantName"	VARCHAR(100),
	"RendantStrasse"	VARCHAR(100),
	"RendantPLZ"	VARCHAR(5),
	"RendantOrt"	VARCHAR(100),
	"RendantTel"	VARCHAR(30),
	"RendantEMail"	VARCHAR(100),
	"Finanzamt"	VARCHAR(100),
	"FinanzamtVom"	VARCHAR(100),
	"FinanzamtNr"	VARCHAR(100)
);

INSERT INTO "Personen" ("PersonenID","BriefAnrede","Titel","Vorname","Vorname2","Nachname","Strasse","Land","PLZ","Ort","Ortsteil","TelPrivat","TelDienst","TelMobil","eMail","GE_KartID","Geburtstag","Abgang","Notiz","Gemeindeglied") VALUES 
 (2,'Frau','','Hilde','Auguste','Adomat','Bahnhofstraße 26','','35753','Greifenstein','Allendorf','06478/2176','','','',2,'1936-02-13',0,NULL,1),
 (3,'Herrn','','Jürgen','Bernd','Adomat','Am Hain 13','','35638','Leun','Biskirchen','06473/92920','','','',3,'1964-07-20',0,NULL,1),
 (407,'Frau','','Heike','Angelika','Arndt','Herrenacker 5','','35753','Greifenstein','Allendorf','06478/1298','','','heike.ar@arcor.de',5,'1960-07-15','False','','true');
INSERT INTO "konten" ("KontoNr","Sortpos","Statistik","Name","Kontotype","Kontostand","Finanzamt","Finanzamtvom","Finanzamtnr") VALUES 
 (23,230,23,'Gesamtkirchliche Kollekten','D',0,NULL,NULL,NULL),
 (24,240,24,'Kollekten und Spenden für Ämter und Werke der SELK','D',0,NULL,NULL,NULL),
 (25,250,25,'Kollekten und Spenden für Ämter und Werke außerhalb der SELK','D',0,'','',''),
 (39,390,3,'Andere Personalaufwendungen','A',0,NULL,NULL,NULL),
 (41,410,41,'Reise- und Sitzungskosten','A',0,NULL,NULL,NULL),
 (42,420,42,'Kraftfahrzeug-Unterhaltung','A',0,NULL,NULL,NULL),
 (43,430,43,'Postgebühren (Porto, Telefon)','A',0,NULL,NULL,NULL),
 (44,440,44,'allg. Verwaltungskosten','A',0,NULL,NULL,NULL),
 (45,450,45,'Aufwendungen für Grundstücke und Gebäude','A',0,NULL,NULL,NULL),
 (46,460,46,'sonstige Sachaufwendungen','A',0,NULL,NULL,NULL),
 (47,470,47,'Aufwendungen, die auf Erstattung angelegt sind (z.B. Gemeindefahrten, Kalender)','A',0,NULL,NULL,NULL),
 (51,510,51,'Publizistik','A',0,NULL,NULL,NULL),
 (52,520,52,'Gottesdienstbedarf','A',0,NULL,NULL,NULL),
 (53,530,53,'Kinder- und Jugendarbeit','A',0,NULL,NULL,NULL),
 (54,540,54,'Alten- und Krankenbetreuung','A',0,NULL,NULL,NULL),
 (55,550,55,'Chöre','A',0,NULL,NULL,NULL),
 (56,560,56,'Sonstige Gemeindekreise, Veranstaltungen der Gemeinde','A',0,NULL,NULL,NULL),
 (57,570,57,'Druckschriften, Gesangbücher','A',0,NULL,NULL,NULL),
 (58,580,58,'Verborgene Not','A',0,NULL,NULL,NULL),
 (59,590,59,'Außerordentliche Aufwendungen','A',0,NULL,NULL,NULL),
 (61,610,61,'Lutherische Theologische Hochschule','A',0,NULL,NULL,NULL),
 (62,620,62,'Projekthilfe','A',0,NULL,NULL,NULL),
 (63,630,63,'Amt für Gemeindedienst','A',0,NULL,NULL,NULL),
 (64,640,64,'Jugendwerk','A',0,'Keins','',''),
 (65,650,65,'Amt für Kirchenmusik','A',0,NULL,NULL,NULL),
 (66,660,66,'Sonstige Zuschüsse (aus dem Gemeindeetat)','A',0,NULL,NULL,NULL),
 (67,670,67,'Umlagebeiträge an die Kirchenbezirkskasse / Allgemeine Kirchenkasse (AKK)','A',0,NULL,NULL,NULL),
 (68,680,68,'Sonstige Zahlungen an die Kirchenbezirkskasse, an die Sprengelkasse oder an die AKK','A',0,NULL,NULL,NULL),
 (71,710,71,'Zinsen','A',NULL,'','',''),
 (72,720,72,'Gebühren der Kreditinstitute','A',NULL,'','',''),
 (73,730,73,'Sonstige Kosten des Finanzverkehrs','A',NULL,'','',''),
 (81,810,81,'Erlöse aus Vermögen (Miete, Pacht, Zinsen, Dividende)','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576'),
 (82,820,82,'Zuschüsse und allgemeine Erstattungen','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576'),
 (84,840,84,'Allgemeine Kirchenbeiträge','E',0,'','',''),
 (85,850,85,'Spenden für gemeindeeigene Zwecke','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576'),
 (86,860,86,'Kollekten für gemeindeeigene Zwecke','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576'),
 (87,860,87,'Sonstige Einnahmen','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576'),
 (88,880,88,'Einnahmen für gemeindeeigene Zwecke','E',0,'Dillenburg','21.12.2021','1526-ttd-9687576'),
 (110,110,11,'Barkasse','B',6600,NULL,NULL,NULL),
 (120,120,12,'Sparkasse Giro','B',119500,NULL,NULL,NULL),
 (121,121,12,'Volksbank Giro','B',200500,NULL,NULL,NULL),
 (130,130,13,'Sparkasse Sparbuch','B',10000,NULL,NULL,NULL),
 (140,140,14,'Depot bei der Masterbank','B',1200000,NULL,NULL,NULL),
 (150,150,15,'Bausparkasse','B',1800000,NULL,NULL,NULL),
 (160,160,16,'Kredit an Gemeinde A','B',370000,NULL,NULL,NULL),
 (170,170,17,'Kredit von Gemeinde B','B',-560000,NULL,NULL,NULL),
 (231,231,231,'Lutherische Kirchenmission','D',0,'Fin.Amt Celle','24.02.2015','17/204/00145'),
 (232,232,232,'Diakonie','D',0,'Fin.Amt für Körperschaften I, Berlin','23.05.2014','27/630/51049'),
 (234,234,234,'Diasporawerk','D',0,'Dortmund-Ost','29.09.2015','317/5942/0309'),
 (237,237,237,'Personalkosten der SELK','D',0,'','',''),
 (241,241,241,'Lutherische Kirchenmission','D',0,'Fin.Amt Celle','24.02.2015','17/204/00145'),
 (242,242,242,'Jugendarbeit','D',0,'','',''),
 (243,243,243,'Lutherische Theologische Hochschule','D',0,'','',''),
 (244,244,244,'Kirchenmusik','D',0,'','',''),
 (245,245,245,'Bausteinsammlung','D',0,'','',''),
 (246,246,246,'Sonstige','D',0,NULL,NULL,NULL),
 (247,247,247,'Diasporawerk','D',0,'Dortmund-Ost','29.09.2015','317/5942/0309'),
 (248,248,248,'Lutherische Stunde','D',0,'Fin.Amt Rotenburg/Wü.','17.09.2012','40/201/05110'),
 (249,249,249,'Mission unter Israel','D',0,'','',''),
 (251,251,251,'Kirche und Judentum','D',0,'Stuttgart-Körperschaften','07.02.2014','99015/03670'),
 (253,253,253,'Sonstige','D',0,'','',''),
 (254,254,254,'Weltbibelhilfe','D',0,'Fin.Amt Stuttgart-Körperschaften','08.10.2012','99153/09016'),
 (451,451,45,'Stromkosten','A',0,'','',''),
 (452,452,45,'Müll','A',0,'','','');
INSERT INTO "BankenAbschluss" ("KontoNr","Buchungsjahr","Anfangssaldo","Abschlusssaldo") VALUES 
 (110,2022,1000,0),
 (120,2022,11000,0),
 (130,2022,10000,0),
 (121,2022,200000,0),
 (140,2022,1200000,0),
 (150,2022,1800000,0),
 (160,2022,400000,0),
 (170,2022,-600000,0);
INSERT INTO "journal" ("LaufendeNr","Belegnummer","Datum","BankNr","Konto_nach","PersonenID","Betrag","Buchungstext","Bemerkung","BuchungsJahr","Aufwandsspende") VALUES 
 (1,'1','2022-01-10',110,231,100,4000,'Spende Mission','keine',2022,'Ja'),
 (2,'2','2022-01-10',120,85,111,5000,'Spende Gesangbücher','',2022,'Nein'),
 (3,'3','2022-01-10',120,121,0,-1000,'Umbuchung','',2022,'Nein'),
 (4,'4','2022-01-10',110,23,0,2400,'Einzahlung Kollekte','',2022,'Nein'),
 (5,'5','2022-01-10',120,84,110,2000,'Spende','',2022,'Nein'),
 (6,'6','2022-01-11',121,88,100,1500,'Spende Gemeinde','',2022,'Nein'),
 (7,'7','2022-01-11',121,231,0,-2000,'Weiterleitung an Mission','',2022,'Nein'),
 (8,'8','2022-02-24',110,451,0,-800,'Vertr-Kontonr.15474246','',2022,'Nein'),
 (9,'9','2022-02-24',120,231,99,12500,'Spende Mission','',2022,'Nein'),
 (10,'10','2022-02-24',120,84,99,100000,'Gemeindebeitrag','',2022,'Nein'),
 (12,'12','2022-02-24',120,170,0,-40000,'Tilgung Kredit von Gemeinde B','',2022,'Nein'),
 (13,'13','2022-02-24',120,71,0,-10000,'Zinsen Kredit Gemeinde B','',2022,'Nein'),
 (14,'14','2022-02-24',120,160,0,30000,'Rückzahlung (Tilgung) Kredit Gemeinde A','',2022,'Nein'),
 (15,'15','2022-02-24',120,81,0,10000,'Rückzahlung (Zinsen) Kredit Gemeinde A','',2022,'Nein');
INSERT INTO "Init" ("Passwort","Buchungsjahr","Version","GemeindeName","GemeindeStrasse","GemeindePLZ","GemeindeOrt","GemeindeTel","RendantName","RendantStrasse","RendantPLZ","RendantOrt","RendantTel","RendantEMail","Finanzamt","FinanzamtVom","FinanzamtNr") VALUES 
 ('GE_Buch',2022,'3.0','Mustergemeinde','Musterstraße 66','12345','Musterstadt','01234/789','Max Martin Meier','Hauptstr. 12','65432','Irgendwo','01234/88777','a@b.de','Dillenburg','21.12.2021','1526-ttd-9687576');
COMMIT;
