/*Creating Tables*/
create table schools.public.schools (
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
,"Latitude" double
,"Longitude" double
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

create table schools.public.sat_scores (
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
"PctGE1500" double
);

create table schools.public.frpm (
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
,"Enrollment (K-12)" double
,"Free Meal Count (K-12)" double
,"Percent (%) Eligible Free (K-12)" double
,"FRPM Count (K-12)" double
,"Percent (%) Eligible FRPM (K-12)" double
,"Enrollment (Ages 5-17)" double
,"Free Meal Count (Ages 5-17)" double
,"Percent (%) Eligible Free (Ages 5-17)" double
,"FRPM Count (Ages 5-17)" double
,"Percent (%) Eligible FRPM (Ages 5-17)" double
,"2013-14 CALPADS Fall 1 Certification Status" smallint
);