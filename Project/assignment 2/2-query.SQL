CREATE TABLE `user_train` (
  `reg_date` varchar(255) DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `withdraw_date` varchar(255) DEFAULT NULL,
  `user_reg_pref_name` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `weblog` (
  `reg_date` varchar(255) DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `withdraw_date` varchar(255) DEFAULT NULL,
  `user_reg_pref_name` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `purchase_flag` int(11) DEFAULT NULL,
  `view_date` varchar(255) DEFAULT NULL,
  `page_serial` int(11) DEFAULT NULL,
  `referrer_id` varchar(255) DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `purchase_id` varchar(255) DEFAULT NULL,
  `item_count` int(11) DEFAULT NULL,
  `purchase_date` varchar(255) DEFAULT NULL,
  `user_res_small_area_name` varchar(255) DEFAULT NULL,
  `activity_date` varchar(255) DEFAULT NULL,
  `coupon_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




LOAD DATA INFILE'user_train.csv' INTO TABLE user_train
LOAD DATA INFILE'weblog_train.csv' INTO TABLE weblog


create table no_referrers;
select 
	max(purchase_flag) as purchase_flag,
	wb.age,
	cl.`capsule_text`,
	cl.`price_rate`,
	cl.`shop_large_area_name`,
	if(cl.`usable_date_mon`=0,0,1) as usable_date_mon,
	if(cl.`usable_date_tue`=0,0,1) as usable_date_tue,
	if(cl.`usable_date_wed`=0,0,1) as usable_date_wed,
	if(cl.`usable_date_thu`=0,0,1) as usable_date_thu,	
	if(cl.`usable_date_fri`=0,0,1) as usable_date_fri,	
	if(cl.`usable_date_sat`=0,0,1) as usable_date_sat,		
	if(cl.`usable_date_sun`=0,0,1) as usable_date_sun,
	
	count(distinct(referrer_id)) as unique_referrer,
	count(session_id) as sessions,
	sum(item_count) as item_count
	
from weblog wb
join user_train ut on wb.user_id = ut.user_id
join coupon_list cl on cl.coupon_id = wb.`coupon_id`

group by wb.age, cl.shop_large_area_name, cl.`capsule_text`, cl.`price_rate`, cl.`usable_date_mon`, cl.usable_date_tue, cl.`usable_date_wed`, cl.`usable_date_thu`, cl.usable_date_fri, cl.usable_date_sat, cl.usable_date_sun
