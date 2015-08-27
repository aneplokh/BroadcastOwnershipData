USE form323;

create table facility_msa
(
facility_id					int NOT NULL,
msa							int NULL
);

create table msa_demographics
(
msa_name					varchar(50),
msa							int,
total_pop					int,
white_pop					int,
black_pop					int,
native_american_pop			int,
asian_pop					int,
pacific_islander_pop		int,
two_plus_pop				int,
hispanic_pop				int,
white_pct					float(10),
black_pct					float(10),
native_american_pct			float(10),
asian_pct					float(10),
pacific_islander_pct		float(10),
two_plus_pct				float(10),
hispanic_pct				float(10)
);

create table facility_fips
(
facility_id					int NOT NULL,
fips						int
);

create table fips_demographics
(
fips						int,
fips_name					varchar(50),
total_pop					int,
white_pop					int,
black_pop					int,
native_american_pop			int,
asian_pop					int,
pacific_islander_pop		int,
other_pop					int,
two_plus_pop				int,
hispanic_pop				int
);


load data local infile 'C:/323workshop/facility_msa.txt' into table facility_msa fields terminated by ',' enclosed by '"' lines terminated by '\n'; 
load data local infile 'C:/323workshop/msa_demographics.txt' into table msa_demographics fields terminated by ',' enclosed by '"' lines terminated by '\n'; 
load data local infile 'C:/323workshop/facility_fips.txt' into table facility_fips fields terminated by ',' enclosed by '"' lines terminated by '\n'; 
load data local infile 'C:/323workshop/fips_demographics.txt' into table fips_demographics fields terminated by ',' enclosed by '"' lines terminated by '\n'; 
