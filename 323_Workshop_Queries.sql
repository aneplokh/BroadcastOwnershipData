USE form323;
FLUSH TABLES;
SET SQL_SAFE_UPDATES=0;

ALTER TABLE `facility` ADD INDEX `facility_id` (`facility_id`);
ALTER TABLE `fac_party` ADD INDEX `facility_id` (`facility_id`);
ALTER TABLE `party` ADD INDEX `party_id` (`party_id`);


/*Find all licensed FP stations in Washington, DC*/
SELECT facility.fac_callsign, facility.facility_id, facility.fac_service, party.party_name, facility.comm_city, facility.comm_state
FROM facility 
INNER JOIN fac_party ON fac_party.facility_id=facility.facility_id 
INNER JOIN party ON party.party_id=fac_party.party_id
WHERE facility.fac_service='dt' AND facility.comm_city LIKE '%washington%' AND facility.comm_state='dc' AND facility.fac_status='licen'
ORDER BY facility.fac_callsign;

/*Find all licensees of FOX using non-biennial ownership tables*/
SELECT facility.fac_callsign, facility.facility_id, facility.fac_service, party.party_name, facility.comm_city, facility.comm_state
FROM facility 
INNER JOIN fac_party ON fac_party.facility_id=facility.facility_id 
INNER JOIN party ON party.party_id=fac_party.party_id
WHERE facility.fac_service='dt'
AND party.party_name LIKE '%Fox Television%' 
AND facility.fac_status='licen'
ORDER BY facility.fac_callsign;


/*Find all FOX stations through 323 ownership reports*/

/*First find the licensee frn for FOX using a well-known station call sign*/
SELECT DISTINCT lic_frn
FROM ownership_report
INNER JOIN ownership_group ON ownership_report.application_id=ownership_group.main_application_id
WHERE ownership_group.fac_callsign='WNYW' AND lic_frn<>'';

/*Then pull all FOX stations and some relevant info using the FRN from above*/
DROP TABLE IF EXISTS fox_owned;
CREATE TABLE IF NOT EXISTS fox_owned AS 
SELECT fac_callsign, facility_id, comm_city, comm_state, fac_service, lic_name
FROM ownership_group
INNER JOIN ownership_report ON ownership_report.application_id=ownership_group.main_application_id
WHERE ownership_report.lic_frn=0005795067 AND app_arn LIKE '2013%' AND (file_prefix='BOA' OR file_prefix='BOR')
GROUP BY fac_callsign;
SELECT * from fox_owned;

/*Find attributable interests of a Louis Wall*/
ALTER TABLE `ownership_structure` ADD INDEX `frn` (`frn`);
ALTER TABLE `ownership_group` ADD INDEX `app_arn` (`app_arn`);
ALTER TABLE `ownership_report` ADD INDEX `lic_frn` (`lic_frn`);
ALTER TABLE `ownership_group` ADD INDEX `main_application_id` (`main_application_id`);

SELECT frn, votes_perc, ownership_group.fac_callsign, ownership_group.facility_id, ownership_group.comm_city, ownership_group.comm_state, ownership_group.fac_service
FROM ownership_structure
INNER JOIN ownership_group ON ownership_structure.application_id=ownership_group.main_application_id
WHERE ownership_structure.frn=0019330562 AND app_arn LIKE '2013%' AND (file_prefix='BOA' OR file_prefix='BOR');

/*Going back to the FOX example, let's pull in some additional data*/

/*Add KML file URL for group of relevant FOX stations*/
ALTER TABLE fox_owned ADD COLUMN kml_url varchar(100);
UPDATE fox_owned SET kml_url = CONCAT('http://data.fcc.gov/mediabureau/v01/tv/contour/facility/',facility_id,'.kml');
SELECT * from fox_owned;

/*Add latitude & longitude for the group of FOX stations*/
DROP TABLE IF EXISTS fox_mapping;
CREATE TABLE IF NOT EXISTS fox_mapping AS 
SELECT fox_owned.*, tv.lat_deg, tv.lat_min, tv.lat_sec, tv.lat_dir, tv.lon_deg, tv.lon_min, tv.lon_sec, tv.lon_dir, tv.last_update_date
FROM fox_owned
INNER JOIN tv_eng_data tv ON fox_owned.facility_id=tv.facility_id
INNER JOIN (
	SELECT fox_owned.facility_id, MAX(ap.application_id) as max_application
    FROM fox_owned
		INNER JOIN application ap ON ap.facility_id=fox_owned.facility_id
		WHERE ap.app_type='L' OR ap.app_type='ML'
			GROUP BY fox_owned.facility_id
	) fm ON fm.facility_id = fox_owned.facility_id AND fm.max_application = tv.application_id;

ALTER TABLE fox_mapping ADD COLUMN latitude varchar(100);
UPDATE fox_mapping SET latitude = CONCAT(lat_deg,'° ',lat_min,"' ",lat_sec,'" ',lat_dir);

ALTER TABLE fox_mapping ADD COLUMN longitude varchar(100);
UPDATE fox_mapping SET longitude = CONCAT(lon_deg,'° ',lon_min,"' ",lon_sec,'" ',lon_dir);
SELECT * from fox_mapping;

/*Pull up the minority-owned station table and add in KML and coordinates*/
ALTER TABLE minority_owned ADD COLUMN kml_url varchar(100);
UPDATE minority_owned SET kml_url = CONCAT('http://data.fcc.gov/mediabureau/v01/tv/contour/facility/',facility_id,'.kml');
SELECT * FROM minority_owned;

DROP TABLE IF EXISTS minority_mapping;
CREATE TABLE IF NOT EXISTS minority_mapping AS
SELECT mo.*, tv.lat_deg, tv.lat_min, tv.lat_sec, tv.lat_dir, tv.lon_deg, tv.lon_min, tv.lon_sec, tv.lon_dir, min(site_number) AS min_site, tv.last_update_date
FROM minority_owned mo
INNER JOIN tv_eng_data tv ON mo.facility_id=tv.facility_id
INNER JOIN (
	SELECT mo.facility_id, MAX(ap.application_id) as max_application
    FROM minority_owned mo
		INNER JOIN application ap ON ap.facility_id=mo.facility_id
		WHERE ap.app_type='L' OR ap.app_type='ML'
			GROUP BY mo.facility_id
	) mm ON mm.facility_id = mo.facility_id AND mm.max_application = tv.application_id
GROUP BY mo.facility_id;

ALTER TABLE minority_mapping ADD COLUMN latitude varchar(100);
UPDATE minority_mapping SET latitude = CONCAT(lat_deg,'° ',lat_min,"' ",lat_sec,'" ',lat_dir);

ALTER TABLE minority_mapping ADD COLUMN longitude varchar(100);
UPDATE minority_mapping SET longitude = CONCAT(lon_deg,'° ',lon_min,"' ",lon_sec,'" ',lon_dir);
SELECT * from minority_mapping;

/*Link minority-owned station coordinates to MSA using the crosswalk table, and then pull in demographics*/
ALTER TABLE `minority_mapping` ADD INDEX `facility_id` (`facility_id`);

SELECT fac_callsign, minority_mapping.facility_id, facility_msa.facility_id, facility_msa.msa, comm_city, comm_state, race_category, latitude, longitude, msa_demographics.*
FROM minority_mapping 
LEFT JOIN facility_msa ON facility_msa.facility_id=minority_mapping.facility_id
LEFT JOIN msa_demographics ON msa_demographics.msa=facility_msa.msa;

/*Link minority-owned station coordinates to FIPS using the crosswalk table, and then pull in demographics*/
SELECT fac_callsign, minority_mapping.facility_id, facility_fips.facility_id, facility_fips.fips, comm_city, comm_state, race_category, latitude, longitude, fips_demographics.*
FROM minority_mapping 
LEFT JOIN facility_fips ON facility_fips.facility_id=minority_mapping.facility_id
LEFT JOIN fips_demographics ON fips_demographics.fips=facility_fips.fips;

/*Basic arithmetic operations*/
SELECT fac_callsign, minority_mapping.facility_id, facility_fips.facility_id, facility_fips.fips, comm_city, comm_state, race_category, latitude, longitude, fips_demographics.*, white_pop/total_pop AS white_pct
FROM minority_mapping
LEFT JOIN facility_fips ON facility_fips.facility_id=minority_mapping.facility_id
LEFT JOIN fips_demographics ON fips_demographics.fips=facility_fips.fips



