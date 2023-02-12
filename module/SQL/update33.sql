BEGIN TRANSACTION;
alter table konten add column [Bemerkung] VARCHAR (100) NOT NULL DEFAULT "";
alter table konten add column [PlanSumme] INTEGER NOT NULL DEFAULT 0;
Update init set version = "3.3";
COMMIT;
vacuum;
