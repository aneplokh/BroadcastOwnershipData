
DROP SCHEMA if exists form323;
CREATE SCHEMA form323 ;

CREATE TABLE form323.ownership_group
(
    ownership_group_id  int         NOT NULL,
    main_application_id int         NOT NULL,
    fac_callsign        varchar(12) NULL,
    facility_id         int         NOT NULL,
    fac_service         varchar(2)  NULL,
    comm_city           varchar(20) NULL,
    comm_state          varchar(2)  NULL,
    fac_service_o       varchar(2)  NULL,
    app_arn             varchar(12) NULL,
    file_prefix         char(10)    NULL,
    order_number        smallint    NULL,
    last_update_date    datetime    NULL
);

CREATE TABLE form323.ownership_report
(
    application_id          int         NOT NULL,
    accurate_date           datetime    NULL,
    non_attributable_ind    char(1)     NULL,
    attributable_ind        char(1)     NULL,
    related_ind             char(1)     NULL,
    exemption_ind           char(1)     NULL,
    owner_type              varchar(5)  NULL,
    entity_control_ind      char(1)     NULL,
    separate_form_ind       char(1)     NULL,
    attrib_exemption_ind    char(1)     NULL,
    capitalization_na       char(1)     NULL,
    contract_info_na        char(1)     NULL,
    individuals_related_ind char(1)     NULL,
    lic_frn                 varchar(10) NULL,
    lic_name                varchar(60) NULL,
    org_chart_na            char(1)     NULL,
    respondent_nature_flg   char(3)     NULL,
    resp_interests_na       char(1)     NULL,
    last_update_date        datetime    NULL    
);

CREATE TABLE form323.ownership_structure
(
    ownership_structure_id    int          NOT NULL,
    application_id            int          NOT NULL,
    name_address              varchar(255) NULL,
    gender_flg                char(1)      NULL,
    ethnicity_flg             varchar(5)   NULL,
    race_flg                  varchar(5)   NULL,
    citizenship               char(2)      NULL,
    positional_int            varchar(60)  NULL,
    votes_perc                decimal(5,2) NULL,
    equity_perc               decimal(5,2) NULL,
    active_ind                char(1)      NULL,
    office_held               varchar(60)  NULL,
    interest_perc             decimal(5,2) NULL,
    occupation                varchar(60)  NULL,
    appointed_by              varchar(60)  NULL,
    existing_interests        varchar(255) NULL,
    order_number              smallint     NULL,
    assets_perc               decimal(5,2) NULL,
    entity_exemption_ind      char(1)      NULL,
    frn                       varchar(10)  NULL,
    listing_type_flg          char(1)      NULL,
    personal_info_na          char(1)      NULL,
    positional_int_crd        char(1)      NULL,
    positional_int_dir        char(1)      NULL,
    positional_int_gen        char(1)      NULL,
    positional_int_inv        char(1)      NULL,
    positional_int_lim        char(1)      NULL,
    positional_int_llc        char(1)      NULL,
    positional_int_off        char(1)      NULL,
    positional_int_oth        char(1)      NULL,
    positional_int_own        char(1)      NULL,
    positional_int_stk        char(1)      NULL,
    positional_int_other_info varchar(20)  NULL,
    relationship_flg          char(1)      NULL,
    race_american_indian      char(1)      NULL,
    race_asian                char(1)      NULL,
    race_black                char(1)      NULL,
    race_hawaiian             char(1)      NULL,
    race_white                char(1)      NULL,
    name                      varchar(150) NULL,
    city                      varchar(20)  NULL,
    country                   varchar(20)  NULL,
    state                     char(2)      NULL,
    street_address1           varchar(60)  NULL,
    street_address2           varchar(60)  NULL,
    zip1                      char(5)      NULL,
    zip2                      char(4)      NULL,
    last_update_date          datetime     NULL
);    

CREATE TABLE form323.facility
(
    comm_city           varchar(20)  NULL,
    comm_state          varchar(2)   NULL,
    eeo_rpt_ind         varchar(1)   NULL,
    fac_address1        varchar(40)  NULL,
    fac_address2        varchar(40)  NULL,
    fac_callsign        varchar(12)  NULL,
    fac_channel         int          NULL,
    fac_city            varchar(20)  NULL,
    fac_country         varchar(2)   NULL,
    fac_frequency       float        NULL,
    fac_service         char(2)      NULL,
    fac_state           varchar(2)   NULL,
    fac_status_date     datetime     NULL,
    fac_type            varchar(3)   NULL,
    facility_id         int          NOT NULL,
    lic_expiration_date datetime     NULL,
    fac_status          varchar(5)   NULL,
    fac_zip1            char(5)      NULL,
    fac_zip2            char(4)      NULL,
    station_type        char(1)      NULL,
    assoc_facility_id   int          NULL,
    callsign_eff_date   datetime     NULL,
    tsid_ntsc           int          NULL,
    tsid_dtv            int          NULL,
    digital_status      char(1)      NULL,
    sat_tv              char(1)      NULL,
    network_affil       varchar(100) NULL,
    nielsen_dma         varchar(60)  NULL,
    tv_virtual_channel  int          NULL,
    last_update_date	  datetime     NULL
);

CREATE TABLE form323.tv_eng_data
(
    ant_input_pwr            float        NULL,
    ant_max_pwr_gain         float        NULL,
    ant_polarization         char(1)      NULL,
    antenna_id               int          NULL,
    antenna_type             char(1)      NULL,
    application_id           int          NOT NULL,
    asrn_na_ind              varchar(1)   NULL,
    asrn                     int          NULL,
    aural_freq               float        NULL,
    avg_horiz_pwr_gain       float        NULL,
    biased_lat               float        NULL,
    biased_long              float        NULL,
    border_code              char(1)      NULL,
    carrier_freq             float        NULL,
    docket_num               varchar(20)  NULL,
    effective_erp            float        NULL,
    electrical_deg           float        NULL,
    elev_amsl                float        NULL,
    Z_elev_bldg_ag           float        NULL,
    eng_record_type          char(1)      NULL,
    fac_zone                 varchar(3)   NULL,
    facility_id              int          NOT NULL,
    freq_offset              char(1)      NULL,
    Z_gain_area              float        NULL,
    haat_rc_mtr              float        NULL,
    hag_overall_mtr          float        NULL,
    hag_rc_mtr               float        NULL,
    horiz_bt_erp             float        NULL,
    lat_deg                  int          NULL,
    lat_dir                  char(1)      NULL,
    lat_min                  int          NULL,
    lat_sec                  float        NULL,
    lon_deg                  int          NULL,
    lon_dir                  char(1)      NULL,
    lon_min                  int          NULL,
    lon_sec                  float        NULL,
    Z_loss_area              float        NULL,
    Z_max_ant_pwr_gain       float        NULL,
    max_erp_dbk              float        NULL,
    max_erp_kw               float        NULL,
    max_haat                 float        NULL,
    mechanical_deg           float        NULL,
    multiplexor_loss         float        NULL,
    power_output_vis_dbk     float        NULL,
    power_output_vis_kw      float        NULL,
    Z_predict_coverage_area  float        NULL,
    Z_predict_pop            int          NULL,
    Z_terrain_data_src_other varchar(255) NULL,
    Z_terrain_data_src       char(3)      NULL,
    tilt_towards_azimuth     float        NULL,
    true_deg                 float        NULL,
    tv_dom_status            varchar(6)   NULL,
    upperband_freq           float        NULL,
    vert_bt_erp              float        NULL,
    visual_freq              float        NULL,
    vsd_service              char(2)      NULL,
    rcamsl_horiz_mtr         float        NULL,
    ant_rotation             float        NULL,
    input_trans_line         float        NULL,
    Z_max_erp_to_hor         float        NULL,
    trans_line_loss          float        NULL,
    lottery_group            int          NULL,
    analog_channel           int          NULL,
    Z_lat_whole_secs         int          NULL,
    Z_lon_whole_secs         int          NULL,
    max_erp_any_angle        float        NULL,
    station_channel          int          NULL,
    lic_ant_make             varchar(3)   NULL,
    lic_ant_model_num        varchar(60)  NULL,
    dt_emission_mask         char(1)      NULL,
    site_number              tinyint      NOT NULL,
    elevation_antenna_id     int          NULL,
    last_update_date         datetime     NULL
);

CREATE TABLE form323.party 
(
 party_id           int	NOT NULL,
 party_address1     varchar(50)	NULL,
 party_address2     varchar(50)	NULL,
 party_citizenship  varchar(2)	NULL,
 party_city         varchar(20)	NULL,
 party_company      varchar(60)	NULL,
 party_country      varchar(2)	NULL,
 party_email        varchar(60)	NULL,
 party_fax          varchar(10)	NULL,
 party_legal_name   varchar(255) NULL,
 party_name         varchar(60)	NULL,
 party_phone        varchar(10)	NULL,
 party_state        varchar(2)	NULL,
 party_zip1         char(5)	NULL,
 party_zip2         char(4)	NULL,
 last_update_date         datetime     NULL
 );
 
 CREATE TABLE form323.fac_party 
 (
  facility_id        	int	NOT NULL,
  party_id		int NULL,
  party_type		char(5)	NULL,
  last_update_date      datetime     NULL
 );


CREATE TABLE form323.application
(
    app_arn               char(12)     NULL,
    app_service           char(2)      NOT NULL,
    application_id        int          NOT NULL,
    facility_id           int          NOT NULL,
    file_prefix           varchar(10)  NOT NULL,
    comm_city             char(20)     NULL,
    comm_state            char(2)      NULL,
    fac_frequency         float        NULL,
    station_channel       int          NULL,
    fac_callsign          char(12)     NULL,
    general_app_service   varchar(2)   NULL,
    app_type              varchar(4)   NULL,
    paper_filed_ind       char(1)      NULL,
    dtv_type              varchar(8)   NULL,
    frn                   varchar(10)  NULL,
    shortform_app_arn     varchar(12)  NULL,
    shortform_file_prefix varchar(10)  NULL,
    corresp_ind           char(1)      NULL,
    assoc_facility_id     int          NULL,
    network_affil         varchar(100) NULL,
    sat_tv_ind            char(1)      NULL,
    comm_county           char(20)     NULL,
    comm_zip1             char(5)      NULL,
    comm_zip2             char(4)      NULL,
    app_code              varchar(10)  NULL,
    last_update_date	  datetime     NULL
);

create table form323.minority_owned
(
fac_callsign				varchar(12),
facility_id					int NOT NULL,
comm_city					varchar(20),
comm_state					varchar(2),
race_category				varchar(50)
);