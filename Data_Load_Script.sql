TRUNCATE TABLE form323.application;

LOAD DATA LOCAL INFILE 'c:/323workshop/application.dat' 
INTO TABLE form323.application 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n'  (
app_arn,
app_service,
application_id,
facility_id,
file_prefix,
comm_city,
comm_state,
fac_frequency,
station_channel,
fac_callsign,
general_app_service,
app_type,
paper_filed_ind,
dtv_type,
frn,
shortform_app_arn,
shortform_file_prefix,
corresp_ind,
@assoc_facility_id,
network_affil,
sat_tv_ind,
comm_county,
comm_zip1,
comm_zip2,
app_code,
@last_update_date)
SET last_update_date=nullif(STR_TO_DATE(@last_update_date,'%m/%d/%Y'),"0000-00-00"),
assoc_facility_id=nullif(@assoc_facility_id,0);

TRUNCATE TABLE form323.ownership_report;

LOAD DATA LOCAL INFILE 'c:/323workshop/ownership_report.dat' 
INTO TABLE form323.ownership_report 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n' (
application_id,
@accurate_date,
non_attributable_ind,
attributable_ind,
related_ind,
exemption_ind,
owner_type,
entity_control_ind,
separate_form_ind,
attrib_exemption_ind,
capitalization_na,
contract_info_na,
individuals_related_ind,
lic_frn,
lic_name,
org_chart_na,
respondent_nature_flg,
resp_interests_na,
@last_update_date)
SET last_update_date=nullif(STR_TO_DATE(@last_update_date,'%m/%d/%Y'),"0000-00-00"),
accurate_date=nullif(STR_TO_DATE(@accurate_date,'%m/%d/%Y'),"0000-00-00");

TRUNCATE TABLE form323.ownership_group;

LOAD DATA LOCAL INFILE 'c:/323workshop/ownership_group.dat' 
INTO TABLE form323.ownership_group 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n'  (
ownership_group_id,
main_application_id,
fac_callsign,
facility_id,
fac_service,
comm_city,
comm_state,
fac_service_o,
app_arn,
file_prefix,
@order_number,
@last_update_date)
SET last_update_date=nullif(STR_TO_DATE(@last_update_date,'%m/%d/%Y'),"0000-00-00"),
order_number=nullif(@order_number,0);

TRUNCATE TABLE form323.ownership_structure;

LOAD DATA LOCAL INFILE 'c:/323workshop/ownership_structure.dat' 
INTO TABLE form323.ownership_structure 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n'  (
ownership_structure_id,
application_id,
name_address,
gender_flg,
ethnicity_flg,
race_flg,
citizenship,
positional_int,
@votes_perc,
@equity_perc,
active_ind,
office_held,
@interest_perc,
occupation,
appointed_by,
existing_interests,
@order_number,
@assets_perc,
entity_exemption_ind,
frn,
listing_type_flg,
personal_info_na,
positional_int_crd,
positional_int_dir,
positional_int_gen,
positional_int_inv,
positional_int_lim,
positional_int_llc,
positional_int_off,
positional_int_oth,
positional_int_own,
positional_int_stk,
positional_int_other_info,
relationship_flg,
race_american_indian,
race_asian,
race_black,
race_hawaiian,
race_white,
name,
city,
country,
state,
street_address1,
street_address2,
zip1,
zip2,
@last_update_date)
SET last_update_date=nullif(STR_TO_DATE(@last_update_date,'%m/%d/%Y'),"0000-00-00"),
equity_perc=nullif(@equity_perc,0),
assets_perc=nullif(@assets_perc,0),
interest_perc=nullif(@interest_perc,0),
votes_perc=nullif(@votes_perc,0),
order_number=nullif(@order_number,0);

TRUNCATE TABLE form323.facility;

LOAD DATA LOCAL INFILE 'c:/323workshop/facility.dat' 
INTO TABLE form323.facility 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n'  (
comm_city,
comm_state,
eeo_rpt_ind,
fac_address1,
fac_address2,
fac_callsign,
@fac_channel,
fac_city,
fac_country,
@fac_frequency,
fac_service,
fac_state,
@fac_status_date,
fac_type,
facility_id,
@lic_expiration_date,
fac_status,
fac_zip1,
fac_zip2,
station_type,
@assoc_facility_id,
@callsign_eff_date,
@tsid_ntsc,
@tsid_dtv,
digital_status,
sat_tv,
network_affil,
nielsen_dma,
@tv_virtual_channel,
@last_update_date)
SET last_update_date=nullif(STR_TO_DATE(@last_update_date,'%m/%d/%Y'),"0000-00-00"),
fac_status_date=nullif(STR_TO_DATE(@fac_status_date,'%m/%d/%Y'),"0000-00-00"),
lic_expiration_date=nullif(STR_TO_DATE(@lic_expiration_date,'%m/%d/%Y'),"0000-00-00"),
callsign_eff_date=nullif(STR_TO_DATE(@callsign_eff_date,'%m/%d/%Y'),"0000-00-00"),
fac_channel=nullif(@fac_channel,0),
fac_frequency=nullif(@fac_frequency,0),
assoc_facility_id=nullif(@assoc_facility_id,0),
tsid_ntsc=nullif(@tsid_ntsc,0),
tsid_dtv=nullif(@tsid_dtv,0),
tv_virtual_channel=nullif(@tv_virtual_channel,0);


TRUNCATE TABLE form323.tv_eng_data;

LOAD DATA LOCAL INFILE 'c:/323workshop/tv_eng_data.dat' 
INTO TABLE form323.tv_eng_data 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n'  (
@ant_input_pwr,
@ant_max_pwr_gain,
@ant_polarization,
@antenna_id,
antenna_type,
application_id,
asrn_na_ind,
@asrn,
@aural_freq,
@avg_horiz_pwr_gain,
@biased_lat,
@biased_long,
border_code,
@carrier_freq,
docket_num,
@effective_erp,
@electrical_deg,
@elev_amsl,
@Z_elev_bldg_ag,
eng_record_type,
fac_zone,
facility_id,
freq_offset,
@Z_gain_area,
@haat_rc_mtr,
@hag_overall_mtr,
@hag_rc_mtr,
@horiz_bt_erp,
@lat_deg,
lat_dir,
@lat_min,
@lat_sec,
@lon_deg,
lon_dir,
@lon_min,
@lon_sec,
@Z_loss_area,
@Z_max_ant_pwr_gain,
@max_erp_dbk,
@max_erp_kw,
@max_haat,
@mechanical_deg,
@multiplexor_loss,
@power_output_vis_dbk,
@power_output_vis_kw,
@Z_predict_coverage_area,
@Z_predict_pop,
Z_terrain_data_src_other,
Z_terrain_data_src,
@tilt_towards_azimuth,
@true_deg,
tv_dom_status,
@upperband_freq,
@vert_bt_erp,
@visual_freq,
vsd_service,
@rcamsl_horiz_mtr,
@ant_rotation,
@input_trans_line,
@Z_max_erp_to_hor,
@trans_line_loss,
@lottery_group,
@analog_channel,
@Z_lat_whole_secs,
@Z_lon_whole_secs,
@max_erp_any_angle,
@station_channel,
lic_ant_make,
lic_ant_model_num,
dt_emission_mask,
@site_number,
@elevation_antenna_id,
@last_update_date)
SET last_update_date=nullif(STR_TO_DATE(@last_update_date,'%m/%d/%Y'),"0000-00-00"),
ant_input_pwr=nullif(@ant_input_pwr,0),
ant_max_pwr_gain=nullif(@ant_max_pwr_gain,0),
antenna_id=nullif(@antenna_id,0),
asrn=nullif(@asrn,0),
aural_freq=nullif(@aural_freq,0),
avg_horiz_pwr_gain=nullif(@avg_horiz_pwr_gain,0),
biased_lat=nullif(@biased_lat,0),
biased_long=nullif(@biased_long,0),
carrier_freq=nullif(@carrier_freq,0),
effective_erp=nullif(@effective_erp,0),
electrical_deg=nullif(@electrical_deg,0),
elev_amsl=nullif(@elev_amsl,0),
Z_elev_bldg_ag=nullif(@Z_elev_bldg_ag,0),
Z_gain_area=nullif(@Z_gain_area,0),
haat_rc_mtr=nullif(@haat_rc_mtr,0),
hag_overall_mtr=nullif(@hag_overall_mtr,0),
hag_rc_mtr=nullif(@hag_rc_mtr,0),
horiz_bt_erp=nullif(@horiz_bt_erp,0),
lat_deg=nullif(@lat_deg,0),
lat_min=nullif(@lat_min,0),
lat_sec=nullif(@lat_sec,0),
lon_deg=nullif(@lon_deg,0),
lon_min=nullif(@lon_min,0),
lon_sec=nullif(@lon_sec,0),
Z_loss_area=nullif(@Z_loss_area,0),
Z_max_ant_pwr_gain=nullif(@Z_max_ant_pwr_gain,0),
max_erp_dbk=nullif(@max_erp_dbk,0),
max_erp_kw=nullif(@max_erp_kw,0),
max_haat=nullif(@max_haat,0),
mechanical_deg=nullif(@mechanical_deg,0),
multiplexor_loss=nullif(@multiplexor_loss,0),
power_output_vis_dbk=nullif(@power_output_vis_dbk,0),
power_output_vis_kw=nullif(@power_output_vis_kw,0),
Z_predict_coverage_area=nullif(@Z_predict_coverage_area,0),
Z_predict_pop=nullif(@Z_predict_pop,0),
tilt_towards_azimuth=nullif(@tilt_towards_azimuth,0),
true_deg=nullif(@true_deg,0),
upperband_freq=nullif(@upperband_freq,0),
vert_bt_erp=nullif(@vert_bt_erp,0),
visual_freq=nullif(@visual_freq,0),
rcamsl_horiz_mtr=nullif(@rcamsl_horiz_mtr,0),
ant_rotation=nullif(@ant_rotation,0),
input_trans_line=nullif(@input_trans_line,0),
Z_max_erp_to_hor=nullif(@Z_max_erp_to_hor,0),
trans_line_loss=nullif(@trans_line_loss,0),
lottery_group=nullif(@lottery_group,0),
analog_channel=nullif(@analog_channel,0),
Z_lat_whole_secs=nullif(@Z_lat_whole_secs,0),
Z_lon_whole_secs=nullif(@Z_lon_whole_secs,0),
max_erp_any_angle=nullif(@max_erp_any_angle,0),
station_channel=nullif(@station_channel,0),
site_number=nullif(@site_number,0),
elevation_antenna_id=nullif(@elevation_antenna_id,0)
;

TRUNCATE TABLE form323.party;

LOAD DATA LOCAL INFILE 'c:/323workshop/party.dat' 
INTO TABLE form323.party 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n' (
party_id,         
party_address1,   
party_address2,   
party_citizenship,
party_city,       
party_company,    
party_country,    
party_email,      
party_fax,        
party_legal_name, 
party_name,       
party_phone,      
party_state,      
party_zip1,       
party_zip2,  
@last_update_date)
SET last_update_date=nullif(STR_TO_DATE(@last_update_date,'%m/%d/%Y'),"0000-00-00")
;

TRUNCATE TABLE form323.fac_party;

LOAD DATA LOCAL INFILE 'c:/323workshop/fac_party.dat' 
INTO TABLE form323.fac_party 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n' (
facility_id,
@party_id, 
party_type,
@last_update_date)
SET last_update_date=nullif(STR_TO_DATE(@last_update_date,'%m/%d/%Y'),"0000-00-00"),
party_id=nullif(@party_id,0)
;

TRUNCATE TABLE form323.minority_owned;

LOAD DATA LOCAL INFILE 'c:/323workshop/minority_owned.csv' 
INTO TABLE form323.minority_owned 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'; 
