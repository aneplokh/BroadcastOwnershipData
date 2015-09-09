/*THIS MAIN PROCEDURE CALLS THE OTHER PROCEUDURES, WHICH ARE DEDICATED TO SPECIFIC TASKS WITHIN THE METHODOLOGY*/ 

DROP PROCEDURE IF EXISTS proc_DoOwnershipAanalysis;
DELIMITER *doownershipanalysis*
CREATE PROCEDURE proc_DoOwnershipAanalysis()

BEGIN

/*DECLARE VARIABLES AND CREATE INITIAL TABLES NEEDED FOR ANALYSIS*/ 

CALL proc_SetUp; 

/*DETERMINE NUMBER OF FACILITIES REMAINING TO ANALYZE*/

CALL proc_CountRemainingFacilities; 

/*GO THROUGH THE FACILITIES UNTIL THERE ARE NO MORE LEFT TO ANALYZE*/

WHILE @var_facilities_remaining > 0 DO 

	/*FIND NEXT FACILITY TO ANALYZE*/
	
    CALL proc_GetNextFacility; 
   
	/*ADD RECORD FOR LICENSEE REPORT TO TABLE_ANALYSIS*/
    
    CALL proc_AddLicenseeReport; 
        
    /*DETERMINE IF THERE ARE MORE REPORTS TO ANALYZE*/
    
    CALL proc_CountRemainingReports; 
    
	/*GO THROUGH REPORTS AND INTEREST HOLDERS UNTIL THERE ARE NO MORE*/
	
    WHILE @var_reports_remaining > 0 DO  
    
		/*FIND NEXT REPORT TO ANALYZE*/
        
        CALL proc_GetNextReport;  
        
        /*GET INTEREST HOLDERS ON THAT REPORT*/
        
        CALL proc_GetInterestHolders;  

		/*ADD RECORDS FOR INTEREST HOLDERS TO TABLE_ANALYSIS*/
        
        CALL proc_AddInterestHolders;  
        
        /*DETERMINE NUMBER OF REPORTS REMAINING TO ANALYZE*/
        
        CALL proc_CountRemainingReports;       
   
   END WHILE;    

/*ADD STATION'S OWNERSHIP CATEGORY TO TABLE OF STATIONS*/

CALL proc_CategorizeOwnership; 

/*DETERMINE NUMBER OF FACILITIES REMAINING TO ANALYZE*/   

CALL proc_CountRemainingFacilities; 

END WHILE;

END *doownershipanalysis*
DELIMITER ;

/*THIS PROCEDURE DECLARES VARIABLES THE CODE WILL USE AND THEN SETS UP THE INITIAL TABLES NEEDED FOR THE ANALYSIS*/

DROP PROCEDURE IF EXISTS proc_SetUp;
DELIMITER *setup*
CREATE PROCEDURE proc_SetUp()

BEGIN 

/*DECLARE VARIABLES*/

/*THESE VARIABLES ARE USED WHILE GOING THROUGH THE STATIONS AND CATEGORIZING OWNERSHIP*/

DECLARE var_facilities_remaining int;
DECLARE var_current_facility int;

/*THESE VARIABLES ARE USED WHILE GOING THROUGH THE REPORTS*/

DECLARE var_reports_remaining int;
DECLARE var_report_id int;
DECLARE var_frn varchar(10);
DECLARE var_application_id int;
DECLARE var_main_file_no  varchar(20);
DECLARE var_ownership_structure_id int;
DECLARE var_name varchar(255);
DECLARE var_type char(1);
DECLARE var_analyzed char(1);
DECLARE var_race_asian char(1);

/*THESE VARIABLES ARE USED WHILE GOING THROUGH THE INTEREST HOLDERS ON REPORTS*/

DECLARE var_interest_holders_remaining int;
DECLARE var_interest_holder_id int;
DECLARE var_interest_holder_name varchar(255);
DECLARE var_interest_holder_frn varchar(10);
DECLARE var_interest_holder_type char(1);
DECLARE var_interest_holder_race_asian char(1);
DECLARE var_interest_holder_votes_reported decimal(5,2);
DECLARE var_interest_holder_votes_real decimal(5,2);
DECLARE var_interest_holder_report_id int;
DECLARE var_interest_holder_analyzed char(1);
DECLARE var_interest_holder_main_file_no varchar(20);
DECLARE var_interest_holder_application_id int;
DECLARE var_report_votes decimal(5,2);

/*REDUCE THE DATA SET, WHICH MAKES IT EASIER TO DEAL WITH AND SIMPLIFIES THE STRUCTURE OF QUERIES*/

/*DROP ALL OF THE TABLES WE ARE GOING TO CREATE, JUST IN CASE THEY ALREADY EXIST FROM A PRIOR RUN*/

DROP TABLE IF EXISTS table_stations_reduced;
DROP TABLE IF EXISTS table_ownership_group_reduced;
DROP TABLE IF EXISTS table_ownership_report_reduced;
DROP TABLE IF EXISTS table_ownership_structure_reduced;
DROP TABLE IF EXISTS table_analysis;
DROP TABLE IF EXISTS table_interest_holders;

/*CREATE TABLE_STATIONS_REDUCED, WHICH CONTAINS ALL FACILITY IDS FOR STATIONS THAT FILED AT LEAST ONE 2013 BIENNIAL OWNERSHIP REPORT THAT DISCLOSED AN ASIAN INDIVIDUAL WITH VOTES*/

CREATE TABLE table_stations_reduced 
AS 
(
SELECT DISTINCT
	facility_id 
FROM 
	ownership_group 
INNER JOIN 
	ownership_structure 
ON 
	ownership_group.main_application_id = ownership_structure.application_id
WHERE
	(ownership_structure.votes_perc > 0 AND ownership_structure.race_asian = 'X')
AND
	(ownership_group.file_prefix = 'BOA' OR ownership_group.file_prefix = 'BOR')
AND
	(ownership_group.app_arn LIKE '2013%' OR ownership_group.app_arn LIKE '2014%')
AND
(ownership_group.fac_service = 'TV' OR ownership_group.fac_service = 'DT')
)
ORDER BY
	facility_id;

/*ADD A COLUMN TO TABLE_STATIONS_REDUCED FOR OWNERSHIP CATEGORY*/

ALTER TABLE 
	table_stations_reduced 
ADD 
	ownership_category varchar(50) 
AFTER 
	facility_id; 

/*CREATE TABLE THAT CONTAINS ONLY RECORDS FROM OWNERSHIP_GROUP FOR STATIONS LISTED IN TABLE_STATIONS_REDUCED*/

CREATE TABLE table_ownership_group_reduced
AS 
(
SELECT 
	ownership_group.* 
FROM 
	ownership_group
INNER JOIN 
	table_stations_reduced 
ON 
	ownership_group.facility_id = table_stations_reduced.facility_id
WHERE
	(ownership_group.file_prefix = 'BOA' OR ownership_group.file_prefix = 'BOR')
AND
	(ownership_group.app_arn LIKE '2013%' OR ownership_group.app_arn LIKE '2014%')
);

/*CREATE TABLE THAT CONTAINS ONLY RECORDS FROM OWNERSHIP_REPORT FOR STATIONS LISTED IN TABLE_STATIONS_REDUCED*/

CREATE TABLE table_ownership_report_reduced
AS 
(
SELECT 
	ownership_report.* 
FROM 
	ownership_report 
INNER JOIN 
	table_ownership_group_reduced 
ON 
	table_ownership_group_reduced.main_application_id = ownership_report.application_id 
);

/*CREATE TABLE THAT CONTAINS ONLY RECORDS FROM OWNERSHIP_STRUCTURE FOR STATIONS LISTED IN TABLE_STATIONS_REDUCED*/

CREATE TABLE table_ownership_structure_reduced
AS 
(
SELECT 
	ownership_structure.* FROM ownership_structure 
INNER JOIN 
	table_ownership_group_reduced 
ON table_ownership_group_reduced.main_application_id = ownership_structure.application_id 
);

/*CREATE TABLE THAT WILL BE USED FOR ANALYSIS OF REPORTS*/
/*THIS CORRESPONDS TO THE CHART IN THE METHODOLOGY*/

CREATE TABLE table_analysis
(
sequencer mediumint NOT NULL AUTO_INCREMENT,
facility_id int,
report_id int,
application_id int,
interest_holder_id 	int,
main_file_no varchar(12),
frn varchar(10),
name varchar(255),
type char(1),
appears_id int,
race_asian char(1),
votes_reported decimal(5,2),
votes_real decimal(5,2),
analyzed char(1),
PRIMARY KEY (sequencer)
);

/*CREATE TABLE_INTEREST_HOLDERS, WHICH IS USED WHEN WE ARE ADDING INTEREST HOLDER RECORDS TO REPORTS*/

CREATE TABLE
table_interest_holders 
(
frn varchar(10), 
interest_holder_id int, 
name varchar(255), 
type char(1), 
race_asian char(1), 
votes_reported decimal (5,2), 
analyzed char(1)
);

END *setup*
DELIMITER ;

/*THIS SHORT PROCEDURE COUNTS THE NUMBER OF STATIONS THAT STILL NEED TO BE ANALYZED*/

DROP PROCEDURE IF EXISTS proc_CountRemainingFacilities;
DELIMITER *countremainingfacilities*
CREATE PROCEDURE proc_CountRemainingFacilities()

BEGIN

SET @var_facilities_remaining = (SELECT COUNT(*) FROM table_stations_reduced WHERE ownership_category IS NULL);

END *countremainingfacilities*
DELIMITER ;

/*THIS SHORT PROCEDURE FINDS THE NEXT STATION THAT NEEDS TO BE ANALYZED*/

DROP PROCEDURE IF EXISTS proc_GetNextFacility;
DELIMITER *getnextfacility*
CREATE PROCEDURE proc_GetNextFacility()

BEGIN

SET @var_current_facility = (SELECT facility_id FROM table_stations_reduced WHERE ownership_category IS NULL LIMIT 1);

END *getnextfacility*
DELIMITER ;
  
/*THIS PROCEDURE ADDS THE LICENSEE REPORT TO TABLE_ANALYSIS*/

DROP PROCEDURE IF EXISTS proc_AddLicenseeReport;
DELIMITER *addlicenseereport*
CREATE PROCEDURE proc_AddLicenseeReport()

BEGIN

/*SET VARIABLES NEEDED TO WRITE THE RECORD*/

SET @var_application_id =
(
SELECT 
	table_ownership_report_reduced.application_id
FROM
	table_ownership_report_reduced INNER JOIN table_ownership_group_reduced
WHERE
	table_ownership_group_reduced.facility_id = @var_current_facility
AND
	table_ownership_report_reduced.respondent_nature_flg = 'LIC'
AND
	table_ownership_group_reduced.main_application_id = table_ownership_report_reduced.application_id
LIMIT
		1
);

SET @var_main_file_no = 
(
SELECT
	MIN(table_ownership_group_reduced.app_arn)
FROM 
	table_ownership_group_reduced
WHERE 
	table_ownership_group_reduced.main_application_id = @var_application_id
);

SET @var_ownership_structure_id =
(
SELECT
	table_ownership_structure_reduced.ownership_structure_id
FROM	
	table_ownership_structure_reduced
WHERE
	table_ownership_structure_reduced.application_id = @var_application_id
AND
	table_ownership_structure_reduced.listing_type_flg = 'R'
LIMIT
		1
);

SET @var_name =
(
SELECT 
	table_ownership_structure_reduced.name 
FROM 
	table_ownership_structure_reduced
WHERE 
	table_ownership_structure_reduced.ownership_structure_id= @var_ownership_structure_id
LIMIT
	1
);

SET @var_frn =
(
SELECT 
	table_ownership_structure_reduced.frn 
FROM 
	table_ownership_structure_reduced
WHERE 
	table_ownership_structure_reduced.ownership_structure_id= @var_ownership_structure_id
LIMIT
	1
);

/*THIS IF-THEN BLOCK CHECKS TO SEE IF THE LICENSEE IS A SOLE*/
/* PROPRIETORSHIP AND THEN SETS VARIOUS VARIABLE ACCORDINGLY*/

IF
(
SELECT 
	table_ownership_report_reduced.owner_type
FROM 
	table_ownership_report_reduced
WHERE 
	table_ownership_report_reduced.application_id = @var_application_id
LIMIT
		1
	)
= 'S'
THEN
	SET @var_type = 'P';
    SET @var_analyzed = 'Y';
    SET @var_report_id = NULL;
ELSE
	SET @var_type = 'E';
    SET @var_analyzed = 'N';
    SET @var_report_id = 1;
END IF;

IF 
	@var_type = 'P' 
AND 
	(
	SELECT 
		table_ownership_structure_reduced.race_asian 
	FROM 
		table_ownership_structure_reduced
	WHERE 
		table_ownership_structure_reduced.ownership_structure_id= @var_ownership_structure_id
	LIMIT
		1
		)
	= 'X'
THEN
	SET @var_race_asian = 'Y';
ELSE
	SET @var_race_asian = 'N';
END IF;
	
/*ADD THE RECORD TO TABLE_ANALYSIS*/

INSERT INTO
table_analysis
	(
	facility_id,
	report_id,
	application_id,
	interest_holder_id,
	main_file_no,
	frn,
	name,
	type,
	appears_id,
	race_asian,
	votes_reported,
	votes_real,
	analyzed
	)
VALUES
	(
	@var_current_facility,
	@var_report_id,
	@var_application_id,
	@var_ownership_structure_id,
	@var_main_file_no,
	@var_frn,
	@var_name,
	@var_type,
	0,
	@var_race_asian,
	100.0,
	100.0,
	@var_analyzed
	);
    
END *addlicenseereport*
DELIMITER ;

/*THIS SHORT PROCEDURE COUNTS THE NUMBER OF REPORTS THAT STILL NEED TO BE ANALYZED*/

DROP PROCEDURE IF EXISTS proc_CountRemainingReports;
DELIMITER *countremainingreports*
CREATE PROCEDURE proc_CountRemainingReports()

BEGIN

SET @var_reports_remaining = (SELECT COUNT(*) FROM table_analysis WHERE facility_id = @var_current_facility AND type = 'E' AND analyzed = 'N');

END *countremainingreports*
DELIMITER ;

/*THIS PROCEDURE FINDS THE NEXT REPORT THAT NEEDS TO BE ANALYZED*/

DROP PROCEDURE IF EXISTS proc_GetNextReport;
DELIMITER *getnextreport*
CREATE PROCEDURE proc_GetNextReport()

BEGIN

SET 
	@var_report_id = 
	(
	SELECT
		report_id
	FROM
		table_analysis
	WHERE
		table_analysis.facility_id = @var_current_facility AND
        table_analysis.type = 'E' AND
        table_analysis.analyzed = 'N'
	LIMIT
		1
	);

SET
	@var_application_id = 
	(
	SELECT 
		application_id 
	FROM 
		table_analysis 
	WHERE 
		(
        report_id = @var_report_id
	AND
		facility_id = @var_current_facility
        )
	LIMIT 
		1
	);

SET @var_report_votes = 
	(
	SELECT 
		votes_real 
	FROM 
		table_analysis 
	WHERE 
		(
        report_id = @var_report_id
	AND
		facility_id = @var_current_facility)
	LIMIT 
		1
	);

END *getnextreport*
DELIMITER ;

/*THIS PROCEDURE CREATES A TEMPORARY TABLE OF INTEREST HOLDERS, WHICH WE WILL*/
/*LATER USE TO ADD INTEREST HOLDER RECORDS TO TABLE_ANALYSYS*/

DROP PROCEDURE IF EXISTS proc_GetInterestHolders;
DELIMITER *getinterestholders*
CREATE PROCEDURE proc_GetInterestHolders()

BEGIN

/*TRUNCATE TABLE_INTEREST_HOLDERS, JUST IN CASE IT CONTAINS ROWS FROM A PRIOR ITERATION*/

TRUNCATE table_interest_holders;

/*INSERT RECORDS INTO TABLE_INTEREST_HOLDERS FOR EACH INTEREST HOLDER LISTED ON THE REPORT THAT HAS VOTES AND IS NOT THE RESPONDENT*/

INSERT INTO table_interest_holders 
	(frn, interest_holder_id, name, type, race_asian, votes_reported) 
SELECT DISTINCT
	table_ownership_structure_reduced.frn, 
	table_ownership_structure_reduced.ownership_structure_id, 
	table_ownership_structure_reduced.name, 
	table_ownership_structure_reduced.personal_info_na, 
	table_ownership_structure_reduced.race_asian, 
	table_ownership_structure_reduced.votes_perc 
FROM 
	table_ownership_structure_reduced
WHERE 
	table_ownership_structure_reduced.application_id =  @var_application_id AND
    table_ownership_structure_reduced.votes_perc > 0 AND
    table_ownership_structure_reduced.listing_type_flg <> 'R';
    
END *getinterestholders*
DELIMITER ;

DROP PROCEDURE IF EXISTS proc_AddInterestHolders;
DELIMITER *addinterestholders*
CREATE PROCEDURE proc_AddInterestHolders()

BEGIN

/*COUNT HOW MANY INTEREST HOLDERS NEED TO BE ADDED TO TABLE ANALYLSIS.*/

SET @var_interest_holders_remaining = (SELECT COUNT(*) FROM table_interest_holders);
  
WHILE @var_interest_holders_remaining > 0 DO

	/*SET VARIABLES THAT WILL BE USED TO ADD RECORDS FOR INTEREST HOLDERS TO TABLE ANALYSIS.*/
    
    SET @var_interest_holder_id = 
		(
		SELECT
			table_interest_holders.interest_holder_id
		FROM
			table_interest_holders
		WHERE
			table_interest_holders.analyzed IS NULL
		LIMIT
			1
		);
       
	SET @var_interest_holder_frn = 
		(
		SELECT
			table_interest_holders.frn
		FROM
			table_interest_holders
		WHERE
			table_interest_holders.interest_holder_id = @var_interest_holder_id
            
		);
    
	SET @var_interest_holder_name = 
		(
		SELECT
			table_interest_holders.name
		FROM
			table_interest_holders
		WHERE
			table_interest_holders.interest_holder_id = @var_interest_holder_id
		);    

	SET @var_interest_holder_votes_reported = 
		(
		SELECT
			table_interest_holders.votes_reported
		FROM
			table_interest_holders
		WHERE
			table_interest_holders.interest_holder_id = @var_interest_holder_id
		);
    
	SET @var_interest_holder_votes_real = (@var_report_votes * @var_interest_holder_votes_reported) / 100;
	      
	IF 
		(
		SELECT
			table_interest_holders.type
		FROM
			table_interest_holders
		WHERE
			table_interest_holders.interest_holder_id = @var_interest_holder_id
		)
		= 'X'
	THEN
		SET @var_interest_holder_type = 'E';
	ELSE
		SET @var_interest_holder_type = 'P';
    
	END IF;

	IF 
		@var_interest_holder_type = 'P' 
	AND 
		(
		SELECT
			table_interest_holders.race_asian
		FROM
			table_interest_holders
		WHERE
			table_interest_holders.interest_holder_id = @var_interest_holder_id
		)
		= 'X'      
	THEN
		SET @var_interest_holder_race_asian = 'Y';
	ELSE
		SET @var_interest_holder_race_asian = 'N';

	END IF;

	IF @var_interest_holder_type = 'E' THEN 
		SET @var_interest_holder_report_id =  
		(
		SELECT
			MAX(report_id)
		FROM 
			table_analysis 
		WHERE    
			table_analysis.facility_id = @var_current_facility)
		+ 1;
	ELSE
		SET @var_interest_holder_report_id = NULL;
	END IF;

	IF 
		@var_interest_holder_type = 'P' 
	THEN 
		SET @var_interest_holder_analyzed = 'Y';
	ELSE 
		SET @var_interest_holder_analyzed = 'N';
	END IF;

	IF 
		@var_interest_holder_type = 'P' 
	THEN 
		SET @var_interest_holder_application_id = NULL;
	ELSE 
		SET @var_interest_holder_application_id = 
        (
        SELECT
			table_ownership_structure_reduced.application_id
		FROM
			table_ownership_structure_reduced
		INNER JOIN
			table_ownership_group_reduced
		ON
			table_ownership_structure_reduced.application_id = table_ownership_group_reduced.main_application_id
		WHERE
			(
            table_ownership_structure_reduced.frn = @var_interest_holder_frn
            AND
            table_ownership_structure_reduced.listing_type_flg = 'R'
            AND
            table_ownership_group_reduced.facility_id = @var_current_facility
            )
		LIMIT
			1
		);
	END IF;

	IF
		@var_interest_holder_type = 'P'
	THEN
		SET @var_interest_holder_main_file_no = NULL;
	ELSE
		SET @var_interest_holder_main_file_no = 
		(
        SELECT
			MIN(table_ownership_group_reduced.app_arn)
		FROM 
			table_ownership_group_reduced
		WHERE 
			table_ownership_group_reduced.main_application_id = @var_interest_holder_application_id
        );
	END IF;

	/*ADD THE RECORD TO TABLE_ANALYSIS*/
    
    INSERT INTO 
		table_analysis
			(
			facility_id,
			report_id,
            application_id,
			interest_holder_id,
            main_file_no,
			frn,
			name,
			type,
			appears_id,
			race_asian,
			votes_reported,
            votes_real,
			analyzed
			)
		VALUES
			(
			@var_current_facility,
			@var_interest_holder_report_id,
            @var_interest_holder_application_id,
			@var_interest_holder_id,
            @var_interest_holder_main_file_no,
			@var_interest_holder_frn,
			@var_interest_holder_name,
			@var_interest_holder_type,
			@var_report_id,
			@var_interest_holder_race_asian,
			@var_interest_holder_votes_reported,
            @var_interest_holder_votes_real,
			@var_interest_holder_analyzed
			);

	/*MARK THE INTEREST HOLDER AS ANALYZED IN TABLE_INTEREST_HOLDERS*/
    UPDATE table_interest_holders SET analyzed = 'Y' WHERE interest_holder_id = @var_interest_holder_id;

	/*SUBTRACT 1 FROM OUR COUNT OF INTEREST HOLDERS REMAINING*/
    SET @var_interest_holders_remaining = @var_interest_holders_remaining - 1;

END WHILE;

/*MARK THE REPORT AS ANALYZED IN TABLE_ANALYSIS*/

UPDATE table_analysis SET analyzed = 'Y' WHERE (facility_id = @var_current_facility AND report_id = @var_report_id);

END *addinterestholders*
DELIMITER ;

/*THIS PROCEDURE DETERMINE'S THE STATION'S OWNERSHIP CATEGORY*/
/*AND UPDATES THE TABLE OF STATIONS ACCORDINGLY*/

DROP PROCEDURE IF EXISTS proc_CategorizeOwnership;
DELIMITER *categorizeownership*
CREATE PROCEDURE proc_CategorizeOwnership()

BEGIN 

IF
	(
    SELECT SUM(table_analysis.votes_real)
	FROM	
		table_analysis
	WHERE
		table_analysis.type = 'P' AND
        table_analysis.race_asian = 'Y' AND
        table_analysis.facility_id = @var_current_facility	
    )
>
	50
THEN
	UPDATE table_stations_reduced SET ownership_category = 'ASIAN-OWNED' WHERE facility_id = @var_current_facility;
ELSE
	UPDATE table_stations_reduced SET ownership_category = 'NOT ASIAN-OWNED' WHERE facility_id = @var_current_facility;
END IF;

END *categorizeownership*
DELIMITER ;

/*NOW THAT ALL OF THE PROCEDURES ARE DEFINED, THIS CODE STARTS THE ANALYSIS*/

SET SQL_SAFE_UPDATES=0;

CALL proc_DoOwnershipAanalysis();