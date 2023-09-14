create table dbgen_version
(
    dv_version                varchar(16)                   ,
    dv_create_date            date                          ,
    dv_create_time            time                          ,
    dv_cmdline_args           varchar(200)
)with(serializer = 'string');

create table customer_address
(
    ca_address_sk             integer               ,
    ca_address_id             varchar(16)              ,
    ca_street_number          varchar(10)                      ,
    ca_street_name            varchar(60)                   ,
    ca_street_type            varchar(15)                      ,
    ca_suite_number           varchar(10)                      ,
    ca_city                   varchar(60)                   ,
    ca_county                 varchar(30)                   ,
    ca_state                  varchar(2)                       ,
    ca_zip                    varchar(10)                      ,
    ca_country                varchar(20)                   ,
    ca_gmt_offset             real                  ,
    ca_location_type          varchar(20)
)with(serializer = 'string');

create table customer_demographics
(
    cd_demo_sk                integer               ,
    cd_gender                 varchar(1)                       ,
    cd_marital_status         varchar(1)                       ,
    cd_education_status       varchar(20)                      ,
    cd_purchase_estimate      integer                       ,
    cd_credit_rating          varchar(10)                      ,
    cd_dep_count              integer                       ,
    cd_dep_employed_count     integer                       ,
    cd_dep_college_count      integer
)with(serializer = 'string');

create table date_dim
(
    d_date_sk                 integer               ,
    d_date_id                 varchar(16)              ,
    d_date                    date                          ,
    d_month_seq               integer                       ,
    d_week_seq                integer                       ,
    d_quarter_seq             integer                       ,
    d_year                    integer                       ,
    d_dow                     integer                       ,
    d_moy                     integer                       ,
    d_dom                     integer                       ,
    d_qoy                     integer                       ,
    d_fy_year                 integer                       ,
    d_fy_quarter_seq          integer                       ,
    d_fy_week_seq             integer                       ,
    d_day_name                varchar(9)                       ,
    d_quarter_name            varchar(6)                       ,
    d_holiday                 varchar(1)                       ,
    d_weekend                 varchar(1)                       ,
    d_following_holiday       varchar(1)                       ,
    d_first_dom               integer                       ,
    d_last_dom                integer                       ,
    d_same_day_ly             integer                       ,
    d_same_day_lq             integer                       ,
    d_current_day             varchar(1)                       ,
    d_current_week            varchar(1)                       ,
    d_current_month           varchar(1)                       ,
    d_current_quarter         varchar(1)                       ,
    d_current_year            varchar(1)
)with(serializer = 'string');

create table warehouse
(
    w_warehouse_sk            integer               ,
    w_warehouse_id            varchar(16)              ,
    w_warehouse_name          varchar(20)                   ,
    w_warehouse_sq_ft         integer                       ,
    w_street_number           varchar(10)                      ,
    w_street_name             varchar(60)                   ,
    w_street_type             varchar(15)                      ,
    w_suite_number            varchar(10)                      ,
    w_city                    varchar(60)                   ,
    w_county                  varchar(30)                   ,
    w_state                   varchar(2)                       ,
    w_zip                     varchar(10)                      ,
    w_country                 varchar(20)                   ,
    w_gmt_offset              real
)with(serializer = 'string');

create table ship_mode
(
    sm_ship_mode_sk           integer               ,
    sm_ship_mode_id           varchar(16)              ,
    sm_type                   varchar(30)                      ,
    sm_code                   varchar(10)                      ,
    sm_carrier                varchar(20)                      ,
    sm_contract               varchar(20)
)with(serializer = 'string');

create table time_dim
(
    t_time_sk                 integer               ,
    t_time_id                 varchar(16)              ,
    t_time                    integer                       ,
    t_hour                    integer                       ,
    t_minute                  integer                       ,
    t_second                  integer                       ,
    t_am_pm                   varchar(2)                       ,
    t_shift                   varchar(20)                      ,
    t_sub_shift               varchar(20)                      ,
    t_meal_time               varchar(20)
)with(serializer = 'string');

create table reason
(
    r_reason_sk               integer               ,
    r_reason_id               varchar(16)              ,
    r_reason_desc             varchar(100)
)with(serializer = 'string');

create table income_band
(
    ib_income_band_sk         integer               ,
    ib_lower_bound            integer                       ,
    ib_upper_bound            integer
)with(serializer = 'string');

create table item
(
    i_item_sk                 integer               ,
    i_item_id                 varchar(16)              ,
    i_rec_start_date          date                          ,
    i_rec_end_date            date                          ,
    i_item_desc               varchar(200)                  ,
    i_current_price           real                  ,
    i_wholesale_cost          real                 ,
    i_brand_id                integer                       ,
    i_brand                   varchar(50)                      ,
    i_class_id                integer                       ,
    i_class                   varchar(50)                      ,
    i_category_id             integer                       ,
    i_category                varchar(50)                      ,
    i_manufact_id             integer                       ,
    i_manufact                varchar(50)                      ,
    i_size                    varchar(20)                      ,
    i_formulation             varchar(20)                      ,
    i_color                   varchar(20)                      ,
    i_units                   varchar(10)                      ,
    i_container               varchar(10)                      ,
    i_manager_id              integer                       ,
    i_product_name            varchar(50)
)with(serializer = 'string');

create table store
(
    s_store_sk                integer               ,
    s_store_id                varchar(16)              ,
    s_rec_start_date          date                          ,
    s_rec_end_date            date                          ,
    s_closed_date_sk          integer                       ,
    s_store_name              varchar(50)                   ,
    s_number_employees        integer                       ,
    s_floor_space             integer                       ,
    s_hours                   varchar(20)                      ,
    s_manager                 varchar(40)                   ,
    s_market_id               integer                       ,
    s_geography_class         varchar(100)                  ,
    s_market_desc             varchar(100)                  ,
    s_market_manager          varchar(40)                   ,
    s_division_id             integer                       ,
    s_division_name           varchar(50)                   ,
    s_company_id              integer                       ,
    s_company_name            varchar(50)                   ,
    s_street_number           varchar(10)                   ,
    s_street_name             varchar(60)                   ,
    s_street_type             varchar(15)                      ,
    s_suite_number            varchar(10)                      ,
    s_city                    varchar(60)                   ,
    s_county                  varchar(30)                   ,
    s_state                   varchar(2)                       ,
    s_zip                     varchar(10)                      ,
    s_country                 varchar(20)                   ,
    s_gmt_offset              real                  ,
    s_tax_precentage          real
)with(serializer = 'string');

create table call_center
(
    cc_call_center_sk         integer                       ,
    cc_call_center_id         varchar(16)                      ,
    cc_rec_start_date         date                          ,
    cc_rec_end_date           date                          ,
    cc_closed_date_sk         integer                       ,
    cc_open_date_sk           integer                       ,
    cc_name                   varchar(50)                   ,
    cc_class                  varchar(50)                   ,
    cc_employees              integer                       ,
    cc_sq_ft                  integer                       ,
    cc_hours                  varchar(20)                      ,
    cc_manager                varchar(40)                   ,
    cc_mkt_id                 integer                       ,
    cc_mkt_class              varchar(50)                      ,
    cc_mkt_desc               varchar(100)                  ,
    cc_market_manager         varchar(40)                   ,
    cc_division               integer                       ,
    cc_division_name          varchar(50)                   ,
    cc_company                integer                       ,
    cc_company_name           varchar(50)                      ,
    cc_street_number          varchar(10)                      ,
    cc_street_name            varchar(60)                   ,
    cc_street_type            varchar(15)                      ,
    cc_suite_number           varchar(10)                      ,
    cc_city                   varchar(60)                   ,
    cc_county                 varchar(30)                   ,
    cc_state                  varchar(2)                       ,
    cc_zip                    varchar(10)                      ,
    cc_country                varchar(20)                       ,
    cc_gmt_offset             real                    ,
    cc_tax_percentage         real
)with(serializer = 'string');

create table customer
(
    c_customer_sk             integer               ,
    c_customer_id             varchar(16)              ,
    c_current_cdemo_sk        integer                       ,
    c_current_hdemo_sk        integer                       ,
    c_current_addr_sk         integer                       ,
    c_first_shipto_date_sk    integer                       ,
    c_first_sales_date_sk     integer                       ,
    c_salutation              varchar(10)                      ,
    c_first_name              varchar(20)                      ,
    c_last_name               varchar(30)                      ,
    c_preferred_cust_flag     varchar(1)                       ,
    c_birth_day               integer                       ,
    c_birth_month             integer                       ,
    c_birth_year              integer                       ,
    c_birth_country           varchar(20)                   ,
    c_login                   varchar(13)                      ,
    c_email_address           varchar(50)                      ,
    c_last_review_date        varchar(10)
)with(serializer = 'string');

create table web_site
(
    web_site_sk               integer               ,
    web_site_id               varchar(16)              ,
    web_rec_start_date        date                          ,
    web_rec_end_date          date                          ,
    web_name                  varchar(50)                   ,
    web_open_date_sk          integer                       ,
    web_close_date_sk         integer                       ,
    web_class                 varchar(50)                   ,
    web_manager               varchar(40)                   ,
    web_mkt_id                integer                       ,
    web_mkt_class             varchar(50)                   ,
    web_mkt_desc              varchar(100)                  ,
    web_market_manager        varchar(40)                   ,
    web_company_id            integer                       ,
    web_company_name          varchar(50)                      ,
    web_street_number         varchar(10)                      ,
    web_street_name           varchar(60)                   ,
    web_street_type           varchar(15)                      ,
    web_suite_number          varchar(10)                      ,
    web_city                  varchar(60)                   ,
    web_county                varchar(30)                   ,
    web_state                 varchar(2)                       ,
    web_zip                   varchar(10)                      ,
    web_country               varchar(20)                   ,
    web_gmt_offset            real                  ,
    web_tax_percentage        real
)with(serializer = 'string');

create table store_returns
(
    sr_returned_date_sk       integer                       ,
    sr_return_time_sk         integer                       ,
    sr_item_sk                integer               ,
    sr_customer_sk            integer                       ,
    sr_cdemo_sk               integer                       ,
    sr_hdemo_sk               integer                       ,
    sr_addr_sk                integer                       ,
    sr_store_sk               integer                       ,
    sr_reason_sk              integer                       ,
    sr_ticket_number          integer               ,
    sr_return_quantity        integer                       ,
    sr_return_amt             real                  ,
    sr_return_tax             real                  ,
    sr_return_amt_inc_tax     real                  ,
    sr_fee                    real                  ,
    sr_return_ship_cost       real                  ,
    sr_refunded_cash          real                  ,
    sr_reversed_charge        real                  ,
    sr_store_credit           real                  ,
    sr_net_loss               real
)with(serializer = 'string');

create table household_demographics
(
    hd_demo_sk                integer               ,
    hd_income_band_sk         integer                       ,
    hd_buy_potential          varchar(15)                      ,
    hd_dep_count              integer                       ,
    hd_vehicle_count          integer
)with(serializer = 'string');

create table web_page
(
    wp_web_page_sk            integer               ,
    wp_web_page_id            varchar(16)              ,
    wp_rec_start_date         date                          ,
    wp_rec_end_date           date                          ,
    wp_creation_date_sk       integer                       ,
    wp_access_date_sk         integer                       ,
    wp_autogen_flag           varchar(1)                       ,
    wp_customer_sk            integer                       ,
    wp_url                    varchar(100)                  ,
    wp_type                   varchar(50)                      ,
    wp_char_count             integer                       ,
    wp_link_count             integer                       ,
    wp_image_count            integer                       ,
    wp_max_ad_count           integer
)with(serializer = 'string');

create table promotion
(
    p_promo_sk                integer               ,
    p_promo_id                varchar(16)              ,
    p_start_date_sk           integer                       ,
    p_end_date_sk             integer                       ,
    p_item_sk                 integer                       ,
    p_cost                    real                 ,
    p_response_target         integer                       ,
    p_promo_name              varchar(50)                      ,
    p_channel_dmail           varchar(1)                       ,
    p_channel_email           varchar(1)                       ,
    p_channel_catalog         varchar(1)                       ,
    p_channel_tv              varchar(1)                       ,
    p_channel_radio           varchar(1)                       ,
    p_channel_press           varchar(1)                       ,
    p_channel_event           varchar(1)                       ,
    p_channel_demo            varchar(1)                       ,
    p_channel_details         varchar(100)                  ,
    p_purpose                 varchar(15)                      ,
    p_discount_active         varchar(1)
)with(serializer = 'string');

create table catalog_page
(
    cp_catalog_page_sk        integer               ,
    cp_catalog_page_id        varchar(16)              ,
    cp_start_date_sk          integer                       ,
    cp_end_date_sk            integer                       ,
    cp_department             varchar(50)                   ,
    cp_catalog_number         integer                       ,
    cp_catalog_page_number    integer                       ,
    cp_description            varchar(100)                  ,
    cp_type                   varchar(100)
)with(serializer = 'string');

create table inventory
(
    inv_date_sk               integer               ,
    inv_item_sk               integer               ,
    inv_warehouse_sk          integer               ,
    inv_quantity_on_hand      integer
)with(serializer = 'string');

create table catalog_returns
(
    cr_returned_date_sk       integer                       ,
    cr_returned_time_sk       integer                       ,
    cr_item_sk                integer               ,
    cr_refunded_customer_sk   integer                       ,
    cr_refunded_cdemo_sk      integer                       ,
    cr_refunded_hdemo_sk      integer                       ,
    cr_refunded_addr_sk       integer                       ,
    cr_returning_customer_sk  integer                       ,
    cr_returning_cdemo_sk     integer                       ,
    cr_returning_hdemo_sk     integer                       ,
    cr_returning_addr_sk      integer                       ,
    cr_call_center_sk         integer                       ,
    cr_catalog_page_sk        integer                       ,
    cr_ship_mode_sk           integer                       ,
    cr_warehouse_sk           integer                       ,
    cr_reason_sk              integer                       ,
    cr_order_number           integer               ,
    cr_return_quantity        integer                       ,
    cr_return_amount          real                  ,
    cr_return_tax             real                  ,
    cr_return_amt_inc_tax     real                  ,
    cr_fee                    real                  ,
    cr_return_ship_cost       real                  ,
    cr_refunded_cash          real                  ,
    cr_reversed_charge        real                  ,
    cr_store_credit           real                  ,
    cr_net_loss               real
)with(serializer = 'string');

create table web_returns
(
    wr_returned_date_sk       integer                       ,
    wr_returned_time_sk       integer                       ,
    wr_item_sk                integer               ,
    wr_refunded_customer_sk   integer                       ,
    wr_refunded_cdemo_sk      integer                       ,
    wr_refunded_hdemo_sk      integer                       ,
    wr_refunded_addr_sk       integer                       ,
    wr_returning_customer_sk  integer                       ,
    wr_returning_cdemo_sk     integer                       ,
    wr_returning_hdemo_sk     integer                       ,
    wr_returning_addr_sk      integer                       ,
    wr_web_page_sk            integer                       ,
    wr_reason_sk              integer                       ,
    wr_order_number           integer               ,
    wr_return_quantity        integer                       ,
    wr_return_amt             real                  ,
    wr_return_tax             real                  ,
    wr_return_amt_inc_tax     real                  ,
    wr_fee                    real                  ,
    wr_return_ship_cost       real                  ,
    wr_refunded_cash          real                  ,
    wr_reversed_charge        real                  ,
    wr_account_credit         real                  ,
    wr_net_loss               real
)with(serializer = 'string');

create table web_sales
(
    ws_sold_date_sk           integer                       ,
    ws_sold_time_sk           integer                       ,
    ws_ship_date_sk           integer                       ,
    ws_item_sk                integer               ,
    ws_bill_customer_sk       integer                       ,
    ws_bill_cdemo_sk          integer                       ,
    ws_bill_hdemo_sk          integer                       ,
    ws_bill_addr_sk           integer                       ,
    ws_ship_customer_sk       integer                       ,
    ws_ship_cdemo_sk          integer                       ,
    ws_ship_hdemo_sk          integer                       ,
    ws_ship_addr_sk           integer                       ,
    ws_web_page_sk            integer                       ,
    ws_web_site_sk            integer                       ,
    ws_ship_mode_sk           integer                       ,
    ws_warehouse_sk           integer                       ,
    ws_promo_sk               integer                       ,
    ws_order_number           integer               ,
    ws_quantity               integer                       ,
    ws_wholesale_cost         real                  ,
    ws_list_price             real                  ,
    ws_sales_price            real                  ,
    ws_ext_discount_amt       real                  ,
    ws_ext_sales_price        real                  ,
    ws_ext_wholesale_cost     real                  ,
    ws_ext_list_price         real                  ,
    ws_ext_tax                real                  ,
    ws_coupon_amt             real                  ,
    ws_ext_ship_cost          real                  ,
    ws_net_paid               real                  ,
    ws_net_paid_inc_tax       real                  ,
    ws_net_paid_inc_ship      real                  ,
    ws_net_paid_inc_ship_tax  real                  ,
    ws_net_profit             real
)with(serializer = 'string');

create table catalog_sales
(
    cs_sold_date_sk           integer                       ,
    cs_sold_time_sk           integer                       ,
    cs_ship_date_sk           integer                       ,
    cs_bill_customer_sk       integer                       ,
    cs_bill_cdemo_sk          integer                       ,
    cs_bill_hdemo_sk          integer                       ,
    cs_bill_addr_sk           integer                       ,
    cs_ship_customer_sk       integer                       ,
    cs_ship_cdemo_sk          integer                       ,
    cs_ship_hdemo_sk          integer                       ,
    cs_ship_addr_sk           integer                       ,
    cs_call_center_sk         integer                       ,
    cs_catalog_page_sk        integer                       ,
    cs_ship_mode_sk           integer                       ,
    cs_warehouse_sk           integer                       ,
    cs_item_sk                integer               ,
    cs_promo_sk               integer                       ,
    cs_order_number           integer               ,
    cs_quantity               integer                       ,
    cs_wholesale_cost         real                  ,
    cs_list_price             real                  ,
    cs_sales_price            real                  ,
    cs_ext_discount_amt       real                  ,
    cs_ext_sales_price        real                  ,
    cs_ext_wholesale_cost     real                  ,
    cs_ext_list_price         real                  ,
    cs_ext_tax                real                  ,
    cs_coupon_amt             real                  ,
    cs_ext_ship_cost          real                  ,
    cs_net_paid               real                  ,
    cs_net_paid_inc_tax       real                  ,
    cs_net_paid_inc_ship      real                  ,
    cs_net_paid_inc_ship_tax  real                  ,
    cs_net_profit             real
)with(serializer = 'string');

create table store_sales
(
    ss_sold_date_sk           integer                       ,
    ss_sold_time_sk           integer                       ,
    ss_item_sk                integer               ,
    ss_customer_sk            integer                       ,
    ss_cdemo_sk               integer                       ,
    ss_hdemo_sk               integer                       ,
    ss_addr_sk                integer                       ,
    ss_store_sk               integer                       ,
    ss_promo_sk               integer                       ,
    ss_ticket_number          integer               ,
    ss_quantity               integer                       ,
    ss_wholesale_cost         real                  ,
    ss_list_price             real                  ,
    ss_sales_price            real                  ,
    ss_ext_discount_amt       real                  ,
    ss_ext_sales_price        real                  ,
    ss_ext_wholesale_cost     real                  ,
    ss_ext_list_price         real                  ,
    ss_ext_tax                real                  ,
    ss_coupon_amt             real                  ,
    ss_net_paid               real                  ,
    ss_net_paid_inc_tax       real                  ,
    ss_net_profit             real
)with(serializer = 'string');

