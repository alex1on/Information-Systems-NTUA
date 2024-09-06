table_names = [
  "dbgen_version",
  "date_dim",
  "ship_mode",
  "warehouse",
  "web_site",
  "web_page",
  "income_band",
  "call_center",
  "reason",
  "item",
  "promotion",
  "customer_address",
  "customer_demographics",
  "household_demographics",
  "store",
  "time_dim",
  "inventory",
  "catalog_page",
  "customer",
  "web_sales",
  "web_returns",
  "store_sales",
  "store_returns",
  "catalog_sales",
  "catalog_returns"
]

primary_keys = [
  "dv_version",
  "d_date_sk",
  "sm_ship_mode_sk",
  "w_warehouse_sk",
  "web_site_sk",
  "wp_web_page_sk",
  "ib_income_band_sk",
  "cc_call_center_sk",
  "r_reason_sk",
  "i_item_sk",
  "p_promo_sk",    
  "ca_address_sk",
  "cd_demo_sk",
  "hd_demo_sk",
  "s_store_sk",
  "t_time_sk",
  "inv_date_sk, inv_item_sk, inv_warehouse_sk",
  "cp_catalog_page_sk",
  "c_customer_sk",
  "ws_item_sk, ws_order_number",
  "wr_item_sk, wr_order_number",
  "ss_item_sk, ss_ticket_number",
  "sr_item_sk, sr_ticket_number",
  "cs_item_sk, cs_order_number",
  "cr_item_sk, cr_order_number"
]


# List of tables structure
table_structure =[
  "dv_version, dv_create_date, dv_create_time, dv_cmdline_args",
  "d_date_sk, d_date_id, d_date, d_month_seq, d_week_seq, d_quarter_seq, d_year, d_dow, d_moy, d_dom, d_qoy, d_fy_year, d_fy_quarter_seq, d_fy_week_seq, d_day_name, d_quarter_name, d_holiday, d_weekend, d_following_holiday, d_first_dom, d_last_dom, d_same_day_ly, d_same_day_lq, d_current_day, d_current_week, d_current_month, d_current_quarter, d_current_year",
  "sm_ship_mode_sk, sm_ship_mode_id, sm_type, sm_code, sm_carrier, sm_contract",
  "w_warehouse_sk, w_warehouse_id, w_warehouse_name, w_warehouse_sq_ft, w_street_number, w_street_name, w_street_type, w_suite_number, w_city, w_county, w_state, w_zip, w_country, w_gmt_offset",
  "web_site_sk, web_site_id, web_rec_start_date, web_rec_end_date, web_name, web_open_date_sk, web_close_date_sk, web_class, web_manager, web_mkt_id, web_mkt_class, web_mkt_desc, web_market_manager, web_company_id, web_company_name, web_street_number, web_street_name, web_street_type, web_suite_number, web_city, web_county, web_state, web_zip, web_country, web_gmt_offset, web_tax_percentage",
  "wp_web_page_sk, wp_web_page_id, wp_rec_start_date, wp_rec_end_date, wp_creation_date_sk, wp_access_date_sk, wp_autogen_flag, wp_customer_sk, wp_url, wp_type, wp_char_count, wp_link_count, wp_image_count, wp_max_ad_count",
  "ib_income_band_sk, ib_lower_bound, ib_upper_bound",
  "cc_call_center_sk, cc_call_center_id, cc_rec_start_date, cc_rec_end_date, cc_closed_date_sk, cc_open_date_sk, cc_name, cc_class, cc_employees, cc_sq_ft, cc_hours, cc_manager, cc_mkt_id, cc_mkt_class, cc_mkt_desc, cc_market_manager, cc_division, cc_division_name, cc_company, cc_company_name, cc_street_number, cc_street_name, cc_street_type, cc_suite_number, cc_city, cc_county, cc_state, cc_zip, cc_country, cc_gmt_offset, cc_tax_percentage",
  "r_reason_sk, r_reason_id, r_reason_desc",
  "i_item_sk, i_item_id, i_rec_start_date, i_rec_end_date, i_item_desc, i_current_price, i_wholesale_cost, i_brand_id, i_brand, i_class_id, i_class, i_category_id, i_category, i_manufact_id, i_manufact, i_size, i_formulation, i_color, i_units, i_container, i_manager_id, i_product_name",
  "p_promo_sk, p_promo_id, p_start_date_sk, p_end_date_sk, p_item_sk, p_cost, p_response_target, p_promo_name, p_channel_dmail, p_channel_email, p_channel_catalog, p_channel_tv, p_channel_radio, p_channel_press, p_channel_event, p_channel_demo, p_channel_details, p_purpose, p_discount_active",
  "ca_address_sk, ca_address_id, ca_street_number, ca_street_name, ca_street_type, ca_suite_number, ca_city, ca_county, ca_state, ca_zip, ca_country, ca_gmt_offset, ca_location_type",
  "cd_demo_sk, cd_gender, cd_marital_status, cd_education_status, cd_purchase_estimate, cd_credit_rating, cd_dep_count, cd_dep_employed_count, cd_dep_college_count",
  "hd_demo_sk, hd_income_band_sk, hd_buy_potential, hd_dep_count, hd_vehicle_count",
  "s_store_sk, s_store_id, s_rec_start_date, s_rec_end_date, s_closed_date_sk, s_store_name, s_number_employees, s_floor_space, s_hours, s_manager, s_market_id, s_geography_class, s_market_desc, s_market_manager, s_division_id, s_division_name, s_company_id, s_company_name, s_street_number, s_street_name, s_street_type, s_suite_number, s_city, s_county, s_state, s_zip, s_country, s_gmt_offset, s_tax_precentage",
  "t_time_sk, t_time_id, t_time, t_hour, t_minute, t_second, t_am_pm, t_shift, t_sub_shift, t_meal_time",
  "inv_date_sk, inv_item_sk, inv_warehouse_sk, inv_quantity_on_hand",
  "cp_catalog_page_sk, cp_catalog_page_id, cp_start_date_sk, cp_end_date_sk, cp_department, cp_catalog_number, cp_catalog_page_number, cp_description, cp_type",
  "c_customer_sk, c_customer_id, c_current_cdemo_sk, c_current_hdemo_sk, c_current_addr_sk, c_first_shipto_date_sk, c_first_sales_date_sk, c_salutation, c_first_name, c_last_name, c_preferred_cust_flag, c_birth_day, c_birth_month, c_birth_year, c_birth_country, c_login, c_email_address, c_last_review_date",
  "ws_sold_date_sk, ws_sold_time_sk, ws_ship_date_sk, ws_item_sk, ws_bill_customer_sk, ws_bill_cdemo_sk, ws_bill_hdemo_sk, ws_bill_addr_sk, ws_ship_customer_sk, ws_ship_cdemo_sk, ws_ship_hdemo_sk, ws_ship_addr_sk, ws_web_page_sk, ws_web_site_sk, ws_ship_mode_sk, ws_warehouse_sk, ws_promo_sk, ws_order_number, ws_quantity, ws_wholesale_cost, ws_list_price, ws_sales_price, ws_ext_discount_amt, ws_ext_sales_price, ws_ext_wholesale_cost, ws_ext_list_price, ws_ext_tax, ws_coupon_amt, ws_ext_ship_cost, ws_net_paid, ws_net_paid_inc_tax, ws_net_paid_inc_ship, ws_net_paid_inc_ship_tax, ws_net_profit",
  "wr_returned_date_sk, wr_returned_time_sk, wr_item_sk, wr_refunded_customer_sk, wr_refunded_cdemo_sk, wr_refunded_hdemo_sk, wr_refunded_addr_sk, wr_returning_customer_sk, wr_returning_cdemo_sk, wr_returning_hdemo_sk, wr_returning_addr_sk, wr_web_page_sk, wr_reason_sk, wr_order_number, wr_return_quantity, wr_return_amt, wr_return_tax, wr_return_amt_inc_tax, wr_fee, wr_return_ship_cost, wr_refunded_cash, wr_reversed_charge, wr_account_credit, wr_net_loss",
  "ss_sold_date_sk, ss_sold_time_sk, ss_item_sk, ss_customer_sk, ss_cdemo_sk, ss_hdemo_sk, ss_addr_sk, ss_store_sk, ss_promo_sk, ss_ticket_number, ss_quantity, ss_wholesale_cost, ss_list_price, ss_sales_price, ss_ext_discount_amt, ss_ext_sales_price, ss_ext_wholesale_cost, ss_ext_list_price, ss_ext_tax, ss_coupon_amt, ss_net_paid, ss_net_paid_inc_tax, ss_net_profit",
  "sr_returned_date_sk, sr_return_time_sk, sr_item_sk, sr_customer_sk, sr_cdemo_sk, sr_hdemo_sk,  sr_addr_sk, sr_store_sk, sr_reason_sk, sr_ticket_number, sr_return_quantity, sr_return_amt, sr_return_tax, sr_return_amt_inc_tax, sr_fee, sr_return_ship_cost, sr_refunded_cash, sr_reversed_charge, sr_store_credit, sr_net_loss",
  " cs_sold_date_sk, cs_sold_time_sk, cs_ship_date_sk, cs_bill_customer_sk, cs_bill_cdemo_sk, cs_bill_hdemo_sk, cs_bill_addr_sk, cs_ship_customer_sk, cs_ship_cdemo_sk, cs_ship_hdemo_sk, cs_ship_addr_sk, cs_call_center_sk, cs_catalog_page_sk, cs_ship_mode_sk, cs_warehouse_sk, cs_item_sk, cs_promo_sk, cs_order_number, cs_quantity, cs_wholesale_cost, cs_list_price, cs_sales_price, cs_ext_discount_amt, cs_ext_sales_price, cs_ext_wholesale_cost, cs_ext_list_price, cs_ext_tax, cs_coupon_amt, cs_ext_ship_cost, cs_net_paid, cs_net_paid_inc_tax, cs_net_paid_inc_ship, cs_net_paid_inc_ship_tax, cs_net_profit",
  " cr_returned_date_sk, cr_returned_time_sk, cr_item_sk, cr_refunded_customer_sk, cr_refunded_cdemo_sk, cr_refunded_hdemo_sk, cr_refunded_addr_sk, cr_returning_customer_sk, cr_returning_cdemo_sk, cr_returning_hdemo_sk, cr_returning_addr_sk, cr_call_center_sk, cr_catalog_page_sk, cr_ship_mode_sk, cr_warehouse_sk, cr_reason_sk, cr_order_number, cr_return_quantity, cr_return_amount, cr_return_tax, cr_return_amt_inc_tax, cr_fee, cr_return_ship_cost, cr_refunded_cash, cr_reversed_charge, cr_store_credit, cr_net_loss"
]

# List of columns' types
data_types = [
  "VARCHAR, VARCHAR, VARCHAR, VARCHAR", # dv
  "INTEGER, VARCHAR(16), VARCHAR, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, VARCHAR(9), VARCHAR(6), VARCHAR(1), VARCHAR(1), VARCHAR(1), INTEGER, INTEGER, INTEGER, INTEGER, VARCHAR(1), VARCHAR(1), VARCHAR(1), VARCHAR(1), VARCHAR(1)", # d 
  "INTEGER, VARCHAR(16), VARCHAR(30), VARCHAR(10), VARCHAR(20), VARCHAR(20)", # sm
  "INTEGER, VARCHAR, VARCHAR, INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, DOUBLE", # w
  "INTEGER, VARCHAR(16), VARCHAR, VARCHAR, VARCHAR(50), INTEGER, INTEGER, VARCHAR(50), VARCHAR(40), INTEGER, VARCHAR(50), VARCHAR(100), VARCHAR(40), INTEGER, VARCHAR(50), VARCHAR(10), VARCHAR(60), VARCHAR(15), VARCHAR(10), VARCHAR(60), VARCHAR(30), VARCHAR(2), VARCHAR(10), VARCHAR(20), DOUBLE, DOUBLE", # web_site
  "INTEGER, VARCHAR(16), VARCHAR, VARCHAR, INTEGER, INTEGER, VARCHAR(1), INTEGER, VARCHAR(100), VARCHAR(50), INTEGER, INTEGER, INTEGER, INTEGER", # wp
  "INTEGER, INTEGER, INTEGER", # ib
  "INTEGER, VARCHAR(16), VARCHAR, VARCHAR, INTEGER, INTEGER, VARCHAR(50), VARCHAR(50), INTEGER, INTEGER, VARCHAR(20), VARCHAR(40), INTEGER, VARCHAR(50), VARCHAR(100), VARCHAR(40), INTEGER, VARCHAR(50), INTEGER, VARCHAR(50), VARCHAR(10), VARCHAR(60), VARCHAR(15), VARCHAR(10), VARCHAR(60), VARCHAR(30), VARCHAR(2), VARCHAR(10), VARCHAR(20), DOUBLE, DOUBLE", ## cc
  "INTEGER, VARCHAR(16), VARCHAR(100)", # r
  "INTEGER, VARCHAR(16), VARCHAR, VARCHAR, VARCHAR(200), DOUBLE, DOUBLE, INTEGER, VARCHAR(50), INTEGER, VARCHAR(50), INTEGER, VARCHAR(50), INTEGER, VARCHAR(50), VARCHAR(20), VARCHAR(20), VARCHAR(20), VARCHAR(10), VARCHAR(10), INTEGER, VARCHAR(50)", # i
  "INTEGER, VARCHAR(16), INTEGER, INTEGER, INTEGER, DOUBLE, INTEGER, VARCHAR(50), VARCHAR(1), VARCHAR(1), VARCHAR(1), VARCHAR(1), VARCHAR(1), VARCHAR(1), VARCHAR(1), VARCHAR(1), VARCHAR(100), VARCHAR(15), VARCHAR(1)", # p
  "INTEGER, VARCHAR(16), VARCHAR(10), VARCHAR(60), VARCHAR(15), VARCHAR(10), VARCHAR(60), VARCHAR(30), VARCHAR(2), VARCHAR(10), VARCHAR(20), DOUBLE, VARCHAR(20)", # ca
  "INTEGER, VARCHAR(1), VARCHAR(1), VARCHAR(20), INTEGER, VARCHAR(10), INTEGER, INTEGER, INTEGER", # cd
  "INTEGER, INTEGER, VARCHAR(15), INTEGER, INTEGER", # hd
  "INTEGER, VARCHAR(16), VARCHAR, VARCHAR, INTEGER, VARCHAR(50), INTEGER, INTEGER, VARCHAR(20), VARCHAR(40), INTEGER, VARCHAR(100), VARCHAR(100), VARCHAR(40), INTEGER, VARCHAR(50), INTEGER, VARCHAR(50), VARCHAR(10), VARCHAR(60), VARCHAR(15), VARCHAR(10), VARCHAR(60), VARCHAR(30), VARCHAR(2), VARCHAR(10), VARCHAR(20), DOUBLE, DOUBLE", # s
  "INTEGER, VARCHAR(16), INTEGER, INTEGER, INTEGER, INTEGER, VARCHAR(2), VARCHAR(20), VARCHAR(20), VARCHAR(20)", # t
  "INTEGER, INTEGER, INTEGER, INTEGER", # inv
  "INTEGER, VARCHAR(16), INTEGER, INTEGER, VARCHAR(50), INTEGER, INTEGER, VARCHAR(100), VARCHAR(100)", # cp
  "INTEGER, VARCHAR(16), INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, VARCHAR(10), VARCHAR(20), VARCHAR(30), VARCHAR(1), INTEGER, INTEGER, INTEGER, VARCHAR(20), VARCHAR(13), VARCHAR(50), VARCHAR(10)", # c
  "INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE", # ws
  "INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE", # wr
  "INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE", # ss
  "INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE", # sr
  "INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE", # cs
  "INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE" # cr
]

mappings = [
  ([(25, 32)], "date_dim"),                    # date_dim                  --> tpcds.date_dim.d_date_sk:2488070
  ([(32, 34)], "ship_mode"),                   # ship_mode                 --> tpcds.ship_mode.sm_ship_mode_sk:20
  ([(32, 33)], "warehouse"),                   # warehouse                 --> tpcds.warehouse.w_warehouse_sk:8
  ([(27, 29)], "web_site"),                    # web_site                  --> tpcds.web_site.web_site_sk:38
  ([(30, 33)], "web_page"),                    # web_page                  --> tpcds.web_page.wp_web_page_sk:168
  ([(36, 38)], "income_band"),                 # income_band               --> tpcds.income_band.ib_income_band_sk:20
  ([(36, 38)], "call_center"),                 # call_center               --> tpcds.call_center.cc_call_center_sk:20
  ([(25, 27)], "reason"),                      # reason                    --> tpcds.reason.r_reason_sk:42
  ([(21, 26)], "item"),                        # item                      --> tpcds.item.i_item_sk:82000
  ([(27, 30)], "promotion"),                   # promotion                 --> tpcds.promotion.p_promo_sk:455
  ([(37, 43)], "customer_address"),            # customer_address          --> tpcds.customer_address.ca_address_sk:205000
  ([(39, 46)], "customer_demographics"),       # customer_demographics     --> tpcds.customer_demographics.cd_demo_sk:1920800
  ([(40, 44)], "household_demographics"),      # household_demographics    --> tpcds.household_demographics.hd_demo_sk:7200
  ([(23, 25)], "store"),                       # store                     --> tpcds.store.s_store_sk:82
  ([(25, 30)], "time_dim"),                    # time_dim                  --> tpcds.time_dim.t_time_sk:86399
  ([(38, 43)], "catalog_page"),                # catalog_page              --> tpcds.catalog_page.cp_catalog_page_sk:11718
  ([(29, 35)], "customer"),                    # customer                  --> tpcds.customer.c_customer_sk:411000
  ([(27, 32), (49, 56)], "web_sales"),         # web_sales                 --> tpcds.web_sales.ws_item_sk:82000:ws_order_number:1919999:
  ([(29, 34), (51, 56)], "web_returns"),       # web_returns               --> tpcds.web_returns.wr_item_sk:12391:wr_order_number:18213
  ([(31, 36), (54, 61)], "store_returns"),     # store_returns             --> tpcds.store_returns.sr_item_sk:82000:sr_ticket_number:1919999
  ([(33, 38), (55, 62)], "catalog_returns")    # catalog_returns           --> tpcds.catalog_returns.cr_item_sk:82000:cr_order_number:1279999
]