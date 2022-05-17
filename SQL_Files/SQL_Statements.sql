/*Creating the tables*/
create table fproject.public.schools (
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
create table fproject.public.sat_scores (
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
create table fproject.public.frpm (
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
from fproject.public.frpm

/*Fixng fprm table to have 1 concat column for CDS*/
update fproject.public.frpm set "CDSCode" = ("County Code" || "District Code" || "School Code")
/*Fixing column names*/

/*Changing column name to match that of the other two tables*/
alter table fproject.public.sat_scores
rename column "cds" to "CDSCode"

/*Investigating for primary key*/
select count (*) from fproject.public.frpm; -- 10,393
select count (*) from fproject.public.sat_scores; -- 2331
select count (*) from fproject.public.schools; --- 5000

/*Cardinality of tables with respect to prospective primary key*/
select count (distinct "CDSCode") from fproject.public.frpm; -- 10,393
select count (distinct "CDSCode") from fproject.public.sat_scores; -- 2,331
select count (distinct "CDSCode") from fproject.public.schools; -- 5000

/*Adding primary keys to the table*/
ALTER TABLE fproject.public.frpm ADD PRIMARY KEY ("CDSCode");
ALTER TABLE fproject.public.sat_scores ADD PRIMARY KEY ("CDSCode");
ALTER TABLE fproject.public.schools ADD PRIMARY KEY ("CDSCode");

/*Checking cardinality of the relationship between tables*/
select count(*) from (select "CDSCode" from fproject.public.frpm except select "CDSCode" from fproject.public.sat_scores) as result;
--- 9,293
select count(*) from (select "CDSCode" from fproject.public.frpm except select "CDSCode" from fproject.public.schools) as result;
--- 9,097


select count(*) from (select "CDSCode" from fproject.public.sat_scores except select "CDSCode" from fproject.public.schools) as result;
--- 1,675
select count(*) from (select "CDSCode" from fproject.public.sat_scores except select "CDSCode" from fproject.public.frpm) as result;
---1,231


select count(*) from (select "CDSCode" from fproject.public.schools except select "CDSCode" from fproject.public.frpm) as result;
---3,704
select count(*) from (select "CDSCode" from fproject.public.schools except select "CDSCode" from fproject.public.sat_scores) as result;
---4,344

select count(*) from(
	select "CDSCode" from fproject.public.frpm
	intersect
	select "CDSCode" from fproject.public.schools
) as CDSCodetIntersec;
---1,296

select count(*) from(
	select "CDSCode" from fproject.public.frpm
	intersect
	select "CDSCode" from fproject.public.sat_scores
) as CDSCodetIntersec;
---1,100

select count(*) from(
	select "CDSCode" from fproject.public.sat_scores
	intersect
	select "CDSCode" from fproject.public.schools
) as CDSCodetIntersec;
---656


-- Copyright (c) 2018 Chucky Ellison <cme at freefour.com>
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
-- WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
-- COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- based on code from John D. Cook's https://www.johndcook.com/blog/skewness_kurtosis/ with permission

-- Notes:
-- All the math is done at double precision; can easily be changed to work with numeric or single, or whatever.
-- Kurtosis and skewness are NOT corrected for statistical bias

--------------------------------------------------
-- MAKE SURE you're not using any of these names!

-- drop aggregate if exists stats_agg(double precision);
-- drop function if exists _stats_agg_accumulator(_stats_agg_accum_type, double precision);
-- drop function if exists _stats_agg_finalizer(_stats_agg_accum_type);
-- drop type if exists _stats_agg_result_type;
-- drop type if exists _stats_agg_accum_type;

create type _stats_agg_accum_type AS (
	n bigint,
	min double precision,
	max double precision,
	m1 double precision,
	m2 double precision,
	m3 double precision,
	m4 double precision
);

create type _stats_agg_result_type AS (
	count bigint,
	min double precision,
	max double precision,
	mean double precision,
	variance double precision,
	skewness double precision,
	kurtosis double precision
);

create or replace function _stats_agg_accumulator(_stats_agg_accum_type, double precision)
returns _stats_agg_accum_type AS '
DECLARE
	a ALIAS FOR $1;
	x alias for $2;
	n1 bigint;
	delta double precision;
	delta_n double precision;
	delta_n2 double precision;
	term1 double precision;
BEGIN
	if x IS NOT NULL then
		n1 = a.n;
		a.n = a.n + 1;
		delta = x - a.m1;
		delta_n = delta / a.n;
		delta_n2 = delta_n * delta_n;
		term1 = delta * delta_n * n1;
		a.m1 = a.m1 + delta_n;
		a.m4 = a.m4 + term1 * delta_n2 * (a.n*a.n - 3*a.n + 3) + 6 * delta_n2 * a.m2 - 4 * delta_n * a.m3;
		a.m3 = a.m3 + term1 * delta_n * (a.n - 2) - 3 * delta_n * a.m2;
		a.m2 = a.m2 + term1;
		a.min = least(a.min, x);
		a.max = greatest(a.max, x);
	end if;

	RETURN a;
END;
'
language plpgsql;

create or replace function _stats_agg_finalizer(_stats_agg_accum_type)
returns _stats_agg_result_type AS '
BEGIN
	RETURN row(
		$1.n,
		$1.min,
		$1.max,
		case when $1.n = 0 then null else $1.m1 end,
		case when $1.n = 0 then null else $1.m2 / nullif(($1.n - 1.0), 0) end,
		case when $1.m2 = 0 then null else sqrt($1.n) * $1.m3 / nullif(($1.m2 ^ 1.5), 0) end,
		case when $1.m2 = 0 then null else $1.n * $1.m4 / nullif(($1.m2 * $1.m2) - 3.0, 0) end
	);
END;
'
language plpgsql;

create aggregate stats_agg(double precision) (
	sfunc = _stats_agg_accumulator,
	stype = _stats_agg_accum_type,
	finalfunc = _stats_agg_finalizer,
	initcond = '(0,,, 0, 0, 0, 0)'
);


/*calculates count, min, max, mean, variance, skewness and kurtosis*/

/*schools column stats*/
select stats_agg("Latitude") from fproject.public.schools s
--- count: 3,413  min: 32.671   max: 41.982  mean: 36.551  variance: 4.658  skewness: 0.186  kurtosis: 2.118

select stats_agg("Longitude") from fproject.public.schools s
--- count: 3,413  min: -124.284   max: -114.599  mean: 120.106  variance: 3.936  skewness: -0.055  kurtosis: 2.317


/*sat_scores column stats*/
select stats_agg("NumTstTakr") from fproject.public.sat_scores ss
--- count: 2,331  min: 0   max: 210,706  mean: 360.759  variance: 21,459,286.578  skewness: 41.231  kurtosis: 1,837.395

select stats_agg("AvgScrRead") from fproject.public.sat_scores ss
--- count: 1,733  min: 308   max: 653  mean: 480.242  variance: 3,268.219  skewness: 0.046  kurtosis: 2.818

select stats_agg("AvgScrMath") from fproject.public.sat_scores ss
--- count: 1,733  min: 289   max: 699  mean: 484.990  variance: 3,831.683  skewness: 0.231  kurtosis: 3.229

select stats_agg("AvgScrWrite") from fproject.public.sat_scores ss
--- count: 1,733  min: 312   max: 671  mean: 472.956  variance: 3,047.113  skewness: 0.306  kurtosis: 3.221

select stats_agg("NumGE1500") from fproject.public.sat_scores ss
--- count: 1,733  min: 0   max: 93,334  mean: 214.905  variance: 5,522,851.746  skewness: 36.476  kurtosis: 1,428.323

select stats_agg("PctGE1500") from fproject.public.sat_scores ss
--- count: 1,733  min: 0   max: 98.2  mean: 40.272  variance: 504.007  skewness: 0.264  kurtosis: 2.261


/*frpm column stats*/
select stats_agg("Enrollment (K-12)") from fproject.public.frpm f
--- count: 10,393  min: 1   max: 5,333  mean: 600.061  variance: 291,964.882  skewness: 2.256  kurtosis: 10.636

select stats_agg("Free Meal Count (K-12)") from fproject.public.frpm f
--- count: 10,199  min: 1   max: 3,927  mean: 305.850  variance: 98,122.251  skewness: 2.251  kurtosis: 11.736

select stats_agg("Percent (%) Eligible Free (K-12)") from fproject.public.frpm f
--- count: 10,199  min: 0.002   max: 1  mean: 0.526  variance: 0.075  skewness: -0.218  kurtosis: 1.862

select stats_agg("FRPM Count (K-12)") from fproject.public.frpm f
--- count: 10,205  min: 1   max: 4,419  mean: 358.219  variance: 129,140.176  skewness: 2.266  kurtosis: 11.659

select stats_agg("Percent (%) Eligible FRPM (K-12)") from fproject.public.frpm f
--- count: 10,205  min: 0.002   max: 1  mean: 0.607  variance: 0.081  skewness: -0.487  kurtosis: 1.985

select stats_agg("Enrollment (Ages 5-17)") from fproject.public.frpm f
--- count: 10,372  min: 1   max: 5,271  mean: 585.310  variance: 277,101.781  skewness: 2.206  kurtosis: 10.457

select stats_agg("Free Meal Count (Ages 5-17)") from fprojeselect stats_agg("AvgScrRead") from fproject.public.sat_scores ss ct.public.frpm f
--- count: 10,172  min: 1   max: 3864  mean: 298.161  variance: 92,498.479  skewness: 2.196  kurtosis: 11.488

select stats_agg("Percent (%) Eligible Free (Ages 5-17)") from fproject.public.frpm f
--- count: 10,172  min: 0.002   max: 1  mean: 0.528  variance: 0.075  skewness: -0.224  kurtosis: 1.864

select stats_agg("FRPM Count (Ages 5-17)") from fproject.public.frpm f
--- count: 10,178  min: 1   max: 4,347  mean: 349.576  variance: 121,966.665  skewness: 2.211  kurtosis: 11.432

select stats_agg("Percent (%) Eligible FRPM (Ages 5-17)") from fproject.public.frpm f
--- count: 10,178  min: 0.002   max: 1  mean: 0.610  variance: 0.081  skewness: -0.496  kurtosis: 1.993

/*Cleaning up our tables*/
select count(*) from fproject.public.frpm f where "Low Grade" not like '9' --8654
delete from fproject.public.frpm f where "Low Grade" not like '9';

select count(*) from fproject.public.frpm f where "High Grade" not like '12' --1739
delete from fproject.public.frpm f where "High Grade" not like '12';

select count (*) from fproject.public.frpm f where "Low Grade" like '9'; --1732
select count (*) from fproject.public.frpm f where "High Grade" like '12'; --1732



select count(*) from fproject.public.sat_scores ss where "sname" = '' -- 578
delete from sat_scores ss where sname = ''
select count(*) from fproject.public.sat_scores ss2 where "sname" = ''--0
select count(*) from fproject.public.sat_scores ss where "cname" = '' --0
select count(*) from fproject.public.sat_scores ss where "dname" = '' --0

select count(*) from fproject.public.sat_scores ss  where "AvgScrMath" is null -- 499
select count(*) from fproject.public.sat_scores ss  where "AvgScrRead" is null -- 499
select count(*) from fproject.public.sat_scores ss  where "AvgScrWrite" is null -- 499

delete from fproject.public.sat_scores where "AvgScrMath" is null
select count(*) from fproject.public.sat_scores ss  where "AvgScrMath" is null --0
select count(*) from fproject.public.sat_scores ss  where "AvgScrRead" is null --0
select count(*) from fproject.public.sat_scores ss  where "AvgScrWrite" is null --0


select count (*) from postgres.public.frpm; -- 10,393 to 1732
select count (*) from postgres.public.sat_scores; -- 2331 to 1254



