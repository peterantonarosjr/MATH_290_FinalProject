/*Creating the tables*/
create table postgres.public.schools (
"CDSCode" varchar
,"NCESDist" varchar
,"NCESSchool" varchar
,"StatusType" varchar
,"County" varchar
,"Distrinct" varchar
,"School" varchar
,"Street" varchar
,"StreetAbr" varchar
,"City" varchar
,"Zip" varchar
,"State" varchar
,"MailStreet" varchar
,"MailStrAbr" varchar
,"MailCity" varchar
,"MailZip" varchar
,"MailState" varchar
,"Phone" varchar
,"Ext" varchar
,"Website" varchar
,"OpenDate" date
,"ClosedDate" date
,"Charter" smallint
,"CharterNum" varchar
,"FundingType" varchar
,"DOC" varchar
,"DOCType" varchar
,"SOC" varchar
,"SOCType" varchar
,"EdOpsCode" varchar
,"EdOpsName" varchar
,"EILCode" varchar
,"EILName" varchar
,"GSoffered" varchar
,"GSserved" varchar
,"Virtual" varchar
,"Magnet" smallint
,"Latitude" double precision
,"Longitude" double precision
,"AdmFName1" varchar
,"AdmLName1" varchar
,"AdmEmail1" varchar
,"AdmFName2" varchar
,"AdmLName2" varchar
,"AdmEmail2" varchar
,"AdmFName3" varchar
,"AdmLName3" varchar
,"AdmEmail3" varchar
,"LastUpdate" date
);
create table postgres.public.sat_scores (
"cds" varchar,
"rtype" varchar,
"sname" varchar,
"dname" varchar,
"cname" varchar,
"enroll12" int,
"NumTstTakr" int,
"AvgScrRead" int,
"AvgScrMath" int,
"AvgScrWrite" int,
"NumGE1500" int,
"PctGE1500" double precision
);

create table postgres.public.frpm (
 "CDSCode" varchar
,"Academic Year" varchar
,"County Code" varchar
,"District Code" int
,"School Code" varchar
,"County Name" varchar
,"District Name" varchar
,"School Name" varchar
,"District Type" varchar
,"School Type" varchar
,"Educational Option Type" varchar
,"NSLP Provision Status" varchar
,"Charter School (Y/N)" smallint
,"Charter School Number" varchar
,"Charter Funding Type" varchar
,"IRC" smallint
,"Low Grade" varchar
,"High Grade" varchar
,"Enrollment (K-12)" double precision
,"Free Meal Count (K-12)" double precision
,"Percent (%) Eligible Free (K-12)" double precision
,"FRPM Count (K-12)" double precision
,"Percent (%) Eligible FRPM (K-12)" double precision
,"Enrollment (Ages 5-17)" double precision
,"Free Meal Count (Ages 5-17)" double precision
,"Percent (%) Eligible Free (Ages 5-17)" double precision
,"FRPM Count (Ages 5-17)" double precision
,"Percent (%) Eligible FRPM (Ages 5-17)" double precision
,"2013-14 CALPADS Fall 1 Certification Status" smallint
);

/*Checking if our idea of column concat works*/
select ("County Code" || "District Code" || "School Code") as cds
from postgres.public.frpm

/*Fixng fprm table to have 1 concat column for CDS*/
update postgres.public.frpm set "CDSCode" = ("County Code" || "District Code" || "School Code")
/*Fixing column names*/

/*Changing column name to match that of the other two tables*/
alter table postgres.public.sat_scores
rename column "cds" to "CDSCode"

/*Investigating for primary key*/
select count (*) from postgres.public.frpm; -- 10,395
select count (*) from postgres.public.sat_scores; -- 2331
select count (*) from postgres.public.schools; --- 5000

select count (distinct "CDSCode") from postgres.public.frpm; -- 10,393
select count (distinct "CDSCode") from postgres.public.sat_scores; -- 2,331
select count (distinct "CDSCode") from postgres.public.schools; -- 5000

/*Adding primary keys to the table*/
ALTER TABLE postgres.public.frpm ADD PRIMARY KEY ("CDSCode");
ALTER TABLE postgres.public.sat_scores ADD PRIMARY KEY ("CDSCode");
ALTER TABLE postgres.public.schools ADD PRIMARY KEY ("CDSCode");
