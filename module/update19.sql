BEGIN TRANSACTION;
alter table SachKonten rename to SachKontenOld;
CREATE TABLE [SachKonten] ([SachkontoNr] INTEGER PRIMARY KEY NULL, [Sachkonto] VARCHAR (100) NULL, [LetzterBetrag] INTEGER NULL, [SortPos] INTEGER NULL, [Kontotype] VARCHAR(2) NULL, [Statistik] INTEGER NULL, [Finanzamt] VARCHAR(100) NULL, [FinanzamtVom] VARCHAR(100) NULL, [FinanzamtNr] VARCHAR(100) NULL);
insert into SachKonten select * from SachKontenOld;
DROP TABLE SachKontenOld;
update SachKonten set Kontotype = "DE" where SachkontoNr like "2%";
update SachKonten set Kontotype = "DA" where ((SachkontoNr <> "999") and (SachkontoNr like "9%"));
Update Version set version = "1.9";
COMMIT; 