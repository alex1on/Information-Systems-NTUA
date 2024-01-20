CREATE KEYSPACE IF NOT EXISTS tpcds WITH replication =
  {'class': 'SimpleStrategy', 'replication_factor' : 1};


USE tpcds;

create table dbgen_version
(
    dv_version                varchar                       ,
    dv_create_date            date                          ,
    dv_create_time            time                          ,
    dv_cmdline_args           varchar                       ,    
    primary key (dv_version)         
);

create table customer_address
(
    ca_address_sk             int                           ,
    ca_address_id             varchar                       ,
    ca_street_number          varchar                       ,
    ca_street_name            varchar                       ,
    ca_street_type            varchar                       ,
    ca_suite_number           varchar                       ,
    ca_city                   varchar                       ,
    ca_county                 varchar                       ,
    ca_state                  varchar                       ,
    ca_zip                    varchar                       ,
    ca_country                varchar                       ,
    ca_gmt_offset             decimal                       ,
    ca_location_type          varchar                       ,
    primary key (ca_address_sk)
);

create table customer_demographics
(
    cd_demo_sk                int                           ,
    cd_gender                 varchar                       ,
    cd_marital_status         varchar                       ,
    cd_education_status       varchar                       ,
    cd_purchase_estimate      int                           ,
    cd_credit_rating          varchar                       ,
    cd_dep_count              int                           ,
    cd_dep_employed_count     int                           ,
    cd_dep_college_count      int                           ,
    primary key (cd_demo_sk)
);

create table date_dim
(
    d_date_sk                 int                           ,
    d_date_id                 varchar                       ,
    d_date                    date                          ,
    d_month_seq               int                           ,
    d_week_seq                int                           ,
    d_quarter_seq             int                           ,
    d_year                    int                           ,
    d_dow                     int                           ,
    d_moy                     int                           ,
    d_dom                     int                           ,
    d_qoy                     int                           ,
    d_fy_year                 int                           ,
    d_fy_quarter_seq          int                           ,
    d_fy_week_seq             int                           ,
    d_day_name                varchar                       ,
    d_quarter_name            varchar                       ,
    d_holiday                 varchar                       ,
    d_weekend                 varchar                       ,
    d_following_holiday       varchar                       ,
    d_first_dom               int                           ,
    d_last_dom                int                           ,
    d_same_day_ly             int                           ,
    d_same_day_lq             int                           ,
    d_current_day             varchar                       ,
    d_current_week            varchar                       ,
    d_current_month           varchar                       ,
    d_current_quarter         varchar                       ,
    d_current_year            varchar                       ,
    primary key (d_date_sk)
);

create table warehouse
(
    w_warehouse_sk            int                           ,
    w_warehouse_id            varchar                       ,
    w_warehouse_name          varchar                       ,
    w_warehouse_sq_ft         int                           ,
    w_street_number           varchar                       ,
    w_street_name             varchar                       ,
    w_street_type             varchar                       ,
    w_suite_number            varchar                       ,
    w_city                    varchar                       ,
    w_county                  varchar                       ,
    w_state                   varchar                       ,
    w_zip                     varchar                       ,
    w_country                 varchar                       ,
    w_gmt_offset              decimal                       ,
    primary key (w_warehouse_sk)
);

create table ship_mode
(
    sm_ship_mode_sk           int                           ,
    sm_ship_mode_id           varchar                       ,
    sm_type                   varchar                       ,
    sm_code                   varchar                       ,
    sm_carrier                varchar                       ,
    sm_contract               varchar                       ,
    primary key (sm_ship_mode_sk)
);

create table time_dim
(
    t_time_sk                 int                           ,
    t_time_id                 varchar                       ,
    t_time                    int                           ,
    t_hour                    int                           ,
    t_minute                  int                           ,
    t_second                  int                           ,
    t_am_pm                   varchar                       ,
    t_shift                   varchar                       ,
    t_sub_shift               varchar                       ,
    t_meal_time               varchar                       ,
    primary key (t_time_sk)
);

create table reason
(
    r_reason_sk               int                           ,
    r_reason_id               varchar                       ,
    r_reason_desc             varchar                       ,
    primary key (r_reason_sk)
);

create table income_band
(
    ib_income_band_sk         int                           ,
    ib_lower_bound            int                           ,
    ib_upper_bound            int                           ,
    primary key (ib_income_band_sk)
);

create table item
(
    i_item_sk                 int                           ,
    i_item_id                 varchar                       ,
    i_rec_start_date          date                          ,
    i_rec_end_date            date                          ,
    i_item_desc               varchar                       ,
    i_current_price           decimal                       ,
    i_wholesale_cost          decimal                       ,
    i_brand_id                int                           ,
    i_brand                   varchar                       ,
    i_class_id                int                           ,
    i_class                   varchar                       ,
    i_category_id             int                           ,
    i_category                varchar                       ,
    i_manufact_id             int                           ,
    i_manufact                varchar                       ,
    i_size                    varchar                       ,
    i_formulation             varchar                       ,
    i_color                   varchar                       ,
    i_units                   varchar                       ,
    i_container               varchar                       ,
    i_manager_id              int                           ,
    i_product_name            varchar                       ,
    primary key (i_item_sk)
);

create table store
(
    s_store_sk                int                           ,
    s_store_id                varchar                       ,
    s_rec_start_date          date                          ,
    s_rec_end_date            date                          ,
    s_closed_date_sk          int                           ,
    s_store_name              varchar                       ,
    s_number_employees        int                           ,
    s_floor_space             int                           ,
    s_hours                   varchar                       ,
    s_manager                 varchar                       ,
    s_market_id               int                           ,
    s_geography_class         varchar                       ,
    s_market_desc             varchar                       ,
    s_market_manager          varchar                       ,
    s_division_id             int                           ,
    s_division_name           varchar                       ,
    s_company_id              int                           ,
    s_company_name            varchar                       ,
    s_street_number           varchar                       ,
    s_street_name             varchar                       ,
    s_street_type             varchar                       ,
    s_suite_number            varchar                       ,
    s_city                    varchar                       ,
    s_county                  varchar                       ,
    s_state                   varchar                       ,
    s_zip                     varchar                       ,
    s_country                 varchar                       ,
    s_gmt_offset              decimal                       ,
    s_tax_precentage          decimal                       ,
    primary key (s_store_sk)
);

create table call_center
(
    cc_call_center_sk         int                           ,
    cc_call_center_id         varchar                       ,
    cc_rec_start_date         date                          ,
    cc_rec_end_date           date                          ,
    cc_closed_date_sk         int                           ,
    cc_open_date_sk           int                           ,
    cc_name                   varchar                       ,
    cc_class                  varchar                       ,
    cc_employees              int                           ,
    cc_sq_ft                  int                           ,
    cc_hours                  varchar                       ,
    cc_manager                varchar                       ,
    cc_mkt_id                 int                           ,
    cc_mkt_class              varchar                       ,
    cc_mkt_desc               varchar                       ,
    cc_market_manager         varchar                       ,
    cc_division               int                           ,
    cc_division_name          varchar                       ,
    cc_company                int                           ,
    cc_company_name           varchar                       ,
    cc_street_number          varchar                       ,
    cc_street_name            varchar                       ,
    cc_street_type            varchar                       ,
    cc_suite_number           varchar                       ,
    cc_city                   varchar                       ,
    cc_county                 varchar                       ,
    cc_state                  varchar                       ,
    cc_zip                    varchar                       ,
    cc_country                varchar                       ,
    cc_gmt_offset             decimal                       ,
    cc_tax_percentage         decimal                       ,
    primary key (cc_call_center_sk)
);

create table customer
(
    c_customer_sk             int                           ,
    c_customer_id             varchar                       ,
    c_current_cdemo_sk        int                           ,
    c_current_hdemo_sk        int                           ,
    c_current_addr_sk         int                           ,
    c_first_shipto_date_sk    int                           ,
    c_first_sales_date_sk     int                           ,
    c_salutation              varchar                       ,
    c_first_name              varchar                       ,
    c_last_name               varchar                       ,
    c_preferred_cust_flag     varchar                       ,
    c_birth_day               int                           ,
    c_birth_month             int                           ,
    c_birth_year              int                           ,
    c_birth_country           varchar                       ,
    c_login                   varchar                       ,
    c_email_address           varchar                       ,
    c_last_review_date        varchar                       ,
    primary key (c_customer_sk)
);

create table web_site
(
    web_site_sk               int                           ,
    web_site_id               varchar                       ,
    web_rec_start_date        date                          ,
    web_rec_end_date          date                          ,
    web_name                  varchar                       ,
    web_open_date_sk          int                           ,
    web_close_date_sk         int                           ,
    web_class                 varchar                       ,
    web_manager               varchar                       ,
    web_mkt_id                int                           ,
    web_mkt_class             varchar                       ,
    web_mkt_desc              varchar                       ,
    web_market_manager        varchar                       ,
    web_company_id            int                           ,
    web_company_name          varchar                       ,
    web_street_number         varchar                       ,
    web_street_name           varchar                       ,
    web_street_type           varchar                       ,
    web_suite_number          varchar                       ,
    web_city                  varchar                       ,
    web_county                varchar                       ,
    web_state                 varchar                       ,
    web_zip                   varchar                       ,
    web_country               varchar                       ,
    web_gmt_offset            decimal                       ,
    web_tax_percentage        decimal                       ,
    primary key (web_site_sk)   
);

create table store_returns
(
    sr_returned_date_sk       int                           ,
    sr_return_time_sk         int                           ,
    sr_item_sk                int                           ,
    sr_customer_sk            int                           ,
    sr_cdemo_sk               int                           ,
    sr_hdemo_sk               int                           ,
    sr_addr_sk                int                           ,
    sr_store_sk               int                           ,
    sr_reason_sk              int                           ,
    sr_ticket_number          int                           ,
    sr_return_quantity        int                           ,
    sr_return_amt             decimal                       ,
    sr_return_tax             decimal                       ,
    sr_return_amt_inc_tax     decimal                       ,
    sr_fee                    decimal                       ,
    sr_return_ship_cost       decimal                       ,
    sr_refunded_cash          decimal                       ,
    sr_reversed_charge        decimal                       ,
    sr_store_credit           decimal                       ,
    sr_net_loss               decimal                       ,
    primary key (sr_item_sk, sr_ticket_number)
);

create table household_demographics
(
    hd_demo_sk                int                           ,
    hd_income_band_sk         int                           ,
    hd_buy_potential          varchar                       ,
    hd_dep_count              int                           ,
    hd_vehicle_count          int                           ,
    primary key (hd_demo_sk)
);

create table web_page
(
    wp_web_page_sk            int                           ,
    wp_web_page_id            varchar                       ,
    wp_rec_start_date         date                          ,
    wp_rec_end_date           date                          ,
    wp_creation_date_sk       int                           ,
    wp_access_date_sk         int                           ,
    wp_autogen_flag           varchar                       ,
    wp_customer_sk            int                           ,
    wp_url                    varchar                       ,
    wp_type                   varchar                       ,
    wp_char_count             int                           ,
    wp_link_count             int                           ,
    wp_image_count            int                           ,
    wp_max_ad_count           int                           ,
    primary key (wp_web_page_sk)
);

create table promotion
(
    p_promo_sk                int                           ,
    p_promo_id                varchar                       ,
    p_start_date_sk           int                           ,
    p_end_date_sk             int                           ,
    p_item_sk                 int                           ,
    p_cost                    decimal                       ,
    p_response_target         int                           ,
    p_promo_name              varchar                       ,
    p_channel_dmail           varchar                       ,
    p_channel_email           varchar                       ,
    p_channel_catalog         varchar                       ,
    p_channel_tv              varchar                       ,
    p_channel_radio           varchar                       ,
    p_channel_press           varchar                       ,
    p_channel_event           varchar                       ,
    p_channel_demo            varchar                       ,
    p_channel_details         varchar                       ,
    p_purpose                 varchar                       ,
    p_discount_active         varchar                       ,
    primary key (p_promo_sk)
);

create table catalog_page
(
    cp_catalog_page_sk        int                           ,
    cp_catalog_page_id        varchar                       ,
    cp_start_date_sk          int                           ,
    cp_end_date_sk            int                           ,
    cp_department             varchar                       ,
    cp_catalog_number         int                           ,
    cp_catalog_page_number    int                           ,
    cp_description            varchar                       ,
    cp_type                   varchar                       ,
    primary key (cp_catalog_page_sk)
);

create table inventory
(
    inv_date_sk               int                           ,
    inv_item_sk               int                           ,
    inv_warehouse_sk          int                           ,
    inv_quantity_on_hand      int                           ,
    primary key (inv_date_sk, inv_item_sk, inv_warehouse_sk)
);

create table catalog_returns
(
    cr_returned_date_sk       int                           ,
    cr_returned_time_sk       int                           ,
    cr_item_sk                int                           ,
    cr_refunded_customer_sk   int                           ,
    cr_refunded_cdemo_sk      int                           ,
    cr_refunded_hdemo_sk      int                           ,
    cr_refunded_addr_sk       int                           ,
    cr_returning_customer_sk  int                           ,
    cr_returning_cdemo_sk     int                           ,
    cr_returning_hdemo_sk     int                           ,
    cr_returning_addr_sk      int                           ,
    cr_call_center_sk         int                           ,
    cr_catalog_page_sk        int                           ,
    cr_ship_mode_sk           int                           ,
    cr_warehouse_sk           int                           ,
    cr_reason_sk              int                           ,
    cr_order_number           int                           ,
    cr_return_quantity        int                           ,
    cr_return_amount          decimal                       ,
    cr_return_tax             decimal                       ,
    cr_return_amt_inc_tax     decimal                       ,
    cr_fee                    decimal                       ,
    cr_return_ship_cost       decimal                       ,
    cr_refunded_cash          decimal                       ,
    cr_reversed_charge        decimal                       ,
    cr_store_credit           decimal                       ,
    cr_net_loss               decimal                       ,
    primary key (cr_item_sk, cr_order_number)
);

create table web_returns
(
    wr_returned_date_sk       int                           ,
    wr_returned_time_sk       int                           ,
    wr_item_sk                int                           ,
    wr_refunded_customer_sk   int                           ,
    wr_refunded_cdemo_sk      int                           ,
    wr_refunded_hdemo_sk      int                           ,
    wr_refunded_addr_sk       int                           ,
    wr_returning_customer_sk  int                           ,
    wr_returning_cdemo_sk     int                           ,
    wr_returning_hdemo_sk     int                           ,
    wr_returning_addr_sk      int                           ,
    wr_web_page_sk            int                           ,
    wr_reason_sk              int                           ,
    wr_order_number           int                           ,
    wr_return_quantity        int                           ,
    wr_return_amt             decimal                       ,
    wr_return_tax             decimal                       ,
    wr_return_amt_inc_tax     decimal                       ,
    wr_fee                    decimal                       ,
    wr_return_ship_cost       decimal                       ,
    wr_refunded_cash          decimal                       ,
    wr_reversed_charge        decimal                       ,
    wr_account_credit         decimal                       ,
    wr_net_loss               decimal                       ,
    primary key (wr_item_sk, wr_order_number)
);

create table web_sales
(
    ws_sold_date_sk           int                           ,
    ws_sold_time_sk           int                           ,
    ws_ship_date_sk           int                           ,
    ws_item_sk                int                           ,
    ws_bill_customer_sk       int                           ,
    ws_bill_cdemo_sk          int                           ,
    ws_bill_hdemo_sk          int                           ,
    ws_bill_addr_sk           int                           ,
    ws_ship_customer_sk       int                           ,
    ws_ship_cdemo_sk          int                           ,
    ws_ship_hdemo_sk          int                           ,
    ws_ship_addr_sk           int                           ,
    ws_web_page_sk            int                           ,
    ws_web_site_sk            int                           ,
    ws_ship_mode_sk           int                           ,
    ws_warehouse_sk           int                           ,
    ws_promo_sk               int                           ,
    ws_order_number           int                           ,
    ws_quantity               int                           ,
    ws_wholesale_cost         decimal                       ,
    ws_list_price             decimal                       ,
    ws_sales_price            decimal                       ,
    ws_ext_discount_amt       decimal                       ,
    ws_ext_sales_price        decimal                       ,
    ws_ext_wholesale_cost     decimal                       ,
    ws_ext_list_price         decimal                       ,
    ws_ext_tax                decimal                       ,
    ws_coupon_amt             decimal                       ,
    ws_ext_ship_cost          decimal                       ,
    ws_net_paid               decimal                       ,
    ws_net_paid_inc_tax       decimal                       ,
    ws_net_paid_inc_ship      decimal                       ,
    ws_net_paid_inc_ship_tax  decimal                       ,
    ws_net_profit             decimal                       ,
    primary key (ws_item_sk, ws_order_number)
);

create table catalog_sales
(
    cs_sold_date_sk           int                           ,
    cs_sold_time_sk           int                           ,
    cs_ship_date_sk           int                           ,
    cs_bill_customer_sk       int                           ,
    cs_bill_cdemo_sk          int                           ,
    cs_bill_hdemo_sk          int                           ,
    cs_bill_addr_sk           int                           ,
    cs_ship_customer_sk       int                           ,
    cs_ship_cdemo_sk          int                           ,
    cs_ship_hdemo_sk          int                           ,
    cs_ship_addr_sk           int                           ,
    cs_call_center_sk         int                           ,
    cs_catalog_page_sk        int                           ,
    cs_ship_mode_sk           int                           ,
    cs_warehouse_sk           int                           ,
    cs_item_sk                int                           ,
    cs_promo_sk               int                           ,
    cs_order_number           int                           ,
    cs_quantity               int                           ,
    cs_wholesale_cost         decimal                       ,
    cs_list_price             decimal                       ,
    cs_sales_price            decimal                       ,
    cs_ext_discount_amt       decimal                       ,
    cs_ext_sales_price        decimal                       ,
    cs_ext_wholesale_cost     decimal                       ,
    cs_ext_list_price         decimal                       ,
    cs_ext_tax                decimal                       ,
    cs_coupon_amt             decimal                       ,
    cs_ext_ship_cost          decimal                       ,
    cs_net_paid               decimal                       ,
    cs_net_paid_inc_tax       decimal                       ,
    cs_net_paid_inc_ship      decimal                       ,
    cs_net_paid_inc_ship_tax  decimal                       ,
    cs_net_profit             decimal                       ,
    primary key (cs_item_sk, cs_order_number)
);

create table store_sales
(
    ss_sold_date_sk           int                           ,
    ss_sold_time_sk           int                           ,
    ss_item_sk                int                           ,
    ss_customer_sk            int                           ,
    ss_cdemo_sk               int                           ,
    ss_hdemo_sk               int                           ,
    ss_addr_sk                int                           ,
    ss_store_sk               int                           ,
    ss_promo_sk               int                           ,
    ss_ticket_number          int                           ,
    ss_quantity               int                           ,
    ss_wholesale_cost         decimal                       ,
    ss_list_price             decimal                       ,
    ss_sales_price            decimal                       ,
    ss_ext_discount_amt       decimal                       ,
    ss_ext_sales_price        decimal                       ,
    ss_ext_wholesale_cost     decimal                       ,
    ss_ext_list_price         decimal                       ,
    ss_ext_tax                decimal                       ,
    ss_coupon_amt             decimal                       ,
    ss_net_paid               decimal                       ,
    ss_net_paid_inc_tax       decimal                       ,
    ss_net_profit             decimal                       ,
    primary key (ss_item_sk, ss_ticket_number)
);

