CREATE KEYSPACE IF NOT EXISTS tpcds WITH replication =
  {'class': 'SimpleStrategy', 'replication_factor' : 1};


USE tpcds;

create table dbgen_version
(
    dv_version                text                          ,
    dv_create_date            date                          ,
    dv_create_time            time                          ,
    dv_cmdline_args           text                          ,    
    primary key (dv_version)         
);

create table customer_address
(
    ca_address_sk             int                           ,
    ca_address_id             text                          ,
    ca_street_number          text                          ,
    ca_street_name            text                          ,
    ca_street_type            text                          ,
    ca_suite_number           text                          ,
    ca_city                   text                          ,
    ca_county                 text                          ,
    ca_state                  text                          ,
    ca_zip                    text                          ,
    ca_country                text                          ,
    ca_gmt_offset             decimal                       ,
    ca_location_type          text                          ,
    primary key (ca_address_sk)
);

create table customer_demographics
(
    cd_demo_sk                int                           ,
    cd_gender                 text                          ,
    cd_marital_status         text                          ,
    cd_education_status       text                          ,
    cd_purchase_estimate      int                           ,
    cd_credit_rating          text                          ,
    cd_dep_count              int                           ,
    cd_dep_employed_count     int                           ,
    cd_dep_college_count      int                           ,
    primary key (cd_demo_sk)
);

create table date_dim
(
    d_date_sk                 int                           ,
    d_date_id                 text                          ,
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
    d_day_name                text                          ,
    d_quarter_name            text                          ,
    d_holiday                 text                          ,
    d_weekend                 text                          ,
    d_following_holiday       text                          ,
    d_first_dom               int                           ,
    d_last_dom                int                           ,
    d_same_day_ly             int                           ,
    d_same_day_lq             int                           ,
    d_current_day             text                          ,
    d_current_week            text                          ,
    d_current_month           text                          ,
    d_current_quarter         text                          ,
    d_current_year            text                          ,
    primary key (d_date_sk)
);

create table warehouse
(
    w_warehouse_sk            int                           ,
    w_warehouse_id            text                          ,
    w_warehouse_name          text                          ,
    w_warehouse_sq_ft         int                           ,
    w_street_number           text                          ,
    w_street_name             text                          ,
    w_street_type             text                          ,
    w_suite_number            text                          ,
    w_city                    text                          ,
    w_county                  text                          ,
    w_state                   text                          ,
    w_zip                     text                          ,
    w_country                 text                          ,
    w_gmt_offset              decimal                       ,
    primary key (w_warehouse_sk)
);

create table ship_mode
(
    sm_ship_mode_sk           int                           ,
    sm_ship_mode_id           text                          ,
    sm_type                   text                          ,
    sm_code                   text                          ,
    sm_carrier                text                          ,
    sm_contract               text                          ,
    primary key (sm_ship_mode_sk)
);

create table time_dim
(
    t_time_sk                 int                           ,
    t_time_id                 text                          ,
    t_time                    int                           ,
    t_hour                    int                           ,
    t_minute                  int                           ,
    t_second                  int                           ,
    t_am_pm                   text                          ,
    t_shift                   text                          ,
    t_sub_shift               text                          ,
    t_meal_time               text                          ,
    primary key (t_time_sk)
);

create table reason
(
    r_reason_sk               int                           ,
    r_reason_id               text                          ,
    r_reason_desc             text                          ,
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
    i_item_id                 text                          ,
    i_rec_start_date          date                          ,
    i_rec_end_date            date                          ,
    i_item_desc               text                          ,
    i_current_price           decimal                       ,
    i_wholesale_cost          decimal                       ,
    i_brand_id                int                           ,
    i_brand                   text                          ,
    i_class_id                int                           ,
    i_class                   text                          ,
    i_category_id             int                           ,
    i_category                text                          ,
    i_manufact_id             int                           ,
    i_manufact                text                          ,
    i_size                    text                          ,
    i_formulation             text                          ,
    i_color                   text                          ,
    i_units                   text                          ,
    i_container               text                          ,
    i_manager_id              int                           ,
    i_product_name            text                          ,
    primary key (i_item_sk)
);

create table store
(
    s_store_sk                int                           ,
    s_store_id                text                          ,
    s_rec_start_date          date                          ,
    s_rec_end_date            date                          ,
    s_closed_date_sk          int                           ,
    s_store_name              text                          ,
    s_number_employees        int                           ,
    s_floor_space             int                           ,
    s_hours                   text                          ,
    s_manager                 text                          ,
    s_market_id               int                           ,
    s_geography_class         text                          ,
    s_market_desc             text                          ,
    s_market_manager          text                          ,
    s_division_id             int                           ,
    s_division_name           text                          ,
    s_company_id              int                           ,
    s_company_name            text                          ,
    s_street_number           text                          ,
    s_street_name             text                          ,
    s_street_type             text                          ,
    s_suite_number            text                          ,
    s_city                    text                          ,
    s_county                  text                          ,
    s_state                   text                          ,
    s_zip                     text                          ,
    s_country                 text                          ,
    s_gmt_offset              decimal                       ,
    s_tax_precentage          decimal                       ,
    primary key (s_store_sk)
);

create table call_center
(
    cc_call_center_sk         int                           ,
    cc_call_center_id         text                          ,
    cc_rec_start_date         date                          ,
    cc_rec_end_date           date                          ,
    cc_closed_date_sk         int                           ,
    cc_open_date_sk           int                           ,
    cc_name                   text                          ,
    cc_class                  text                          ,
    cc_employees              int                           ,
    cc_sq_ft                  int                           ,
    cc_hours                  text                          ,
    cc_manager                text                          ,
    cc_mkt_id                 int                           ,
    cc_mkt_class              text                          ,
    cc_mkt_desc               text                          ,
    cc_market_manager         text                          ,
    cc_division               int                           ,
    cc_division_name          text                          ,
    cc_company                int                           ,
    cc_company_name           text                          ,
    cc_street_number          text                          ,
    cc_street_name            text                          ,
    cc_street_type            text                          ,
    cc_suite_number           text                          ,
    cc_city                   text                          ,
    cc_county                 text                          ,
    cc_state                  text                          ,
    cc_zip                    text                          ,
    cc_country                text                          ,
    cc_gmt_offset             decimal                       ,
    cc_tax_percentage         decimal                       ,
    primary key (cc_call_center_sk)
);

create table customer
(
    c_customer_sk             int                           ,
    c_customer_id             text                          ,
    c_current_cdemo_sk        int                           ,
    c_current_hdemo_sk        int                           ,
    c_current_addr_sk         int                           ,
    c_first_shipto_date_sk    int                           ,
    c_first_sales_date_sk     int                           ,
    c_salutation              text                          ,
    c_first_name              text                          ,
    c_last_name               text                          ,
    c_preferred_cust_flag     text                          ,
    c_birth_day               int                           ,
    c_birth_month             int                           ,
    c_birth_year              int                           ,
    c_birth_country           text                          ,
    c_login                   text                          ,
    c_email_address           text                          ,
    c_last_review_date        text                          ,
    primary key (c_customer_sk)
);

create table web_site
(
    web_site_sk               int                           ,
    web_site_id               text                          ,
    web_rec_start_date        date                          ,
    web_rec_end_date          date                          ,
    web_name                  text                          ,
    web_open_date_sk          int                           ,
    web_close_date_sk         int                           ,
    web_class                 text                          ,
    web_manager               text                          ,
    web_mkt_id                int                           ,
    web_mkt_class             text                          ,
    web_mkt_desc              text                          ,
    web_market_manager        text                          ,
    web_company_id            int                           ,
    web_company_name          text                          ,
    web_street_number         text                          ,
    web_street_name           text                          ,
    web_street_type           text                          ,
    web_suite_number          text                          ,
    web_city                  text                          ,
    web_county                text                          ,
    web_state                 text                          ,
    web_zip                   text                          ,
    web_country               text                          ,
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
    hd_buy_potential          text                          ,
    hd_dep_count              int                           ,
    hd_vehicle_count          int                           ,
    primary key (hd_demo_sk)
);

create table web_page
(
    wp_web_page_sk            int                           ,
    wp_web_page_id            text                          ,
    wp_rec_start_date         date                          ,
    wp_rec_end_date           date                          ,
    wp_creation_date_sk       int                           ,
    wp_access_date_sk         int                           ,
    wp_autogen_flag           text                          ,
    wp_customer_sk            int                           ,
    wp_url                    text                          ,
    wp_type                   text                          ,
    wp_char_count             int                           ,
    wp_link_count             int                           ,
    wp_image_count            int                           ,
    wp_max_ad_count           int                           ,
    primary key (wp_web_page_sk)
);

create table promotion
(
    p_promo_sk                int                           ,
    p_promo_id                text                          ,
    p_start_date_sk           int                           ,
    p_end_date_sk             int                           ,
    p_item_sk                 int                           ,
    p_cost                    decimal                       ,
    p_response_target         int                           ,
    p_promo_name              text                          ,
    p_channel_dmail           text                          ,
    p_channel_email           text                          ,
    p_channel_catalog         text                          ,
    p_channel_tv              text                          ,
    p_channel_radio           text                          ,
    p_channel_press           text                          ,
    p_channel_event           text                          ,
    p_channel_demo            text                          ,
    p_channel_details         text                          ,
    p_purpose                 text                          ,
    p_discount_active         text                          ,
    primary key (p_promo_sk)
);

create table catalog_page
(
    cp_catalog_page_sk        int                           ,
    cp_catalog_page_id        text                          ,
    cp_start_date_sk          int                           ,
    cp_end_date_sk            int                           ,
    cp_department             text                          ,
    cp_catalog_number         int                           ,
    cp_catalog_page_number    int                           ,
    cp_description            text                          ,
    cp_type                   text                          ,
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

