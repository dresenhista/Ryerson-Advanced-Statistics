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

  cl.`price_rate`,
  count(distinct(referrer_id)) as unique_referrer,  
  count(session_id) as sessions,
  if(cl.`usable_date_mon`=0,0,1) as usable_date_mon,
  if(cl.`usable_date_tue`=0,0,1) as usable_date_tue,
  if(cl.`usable_date_wed`=0,0,1) as usable_date_wed,
  if(cl.`usable_date_thu`=0,0,1) as usable_date_thu,  
  if(cl.`usable_date_fri`=0,0,1) as usable_date_fri,  
  if(cl.`usable_date_sat`=0,0,1) as usable_date_sat,    
  if(cl.`usable_date_sun`=0,0,1) as usable_date_sun,
  if(cl.`shop_large_area_name`='chugoku',1,0) as chugoku,
  if(cl.`shop_large_area_name`='hokkaido',1,0) as hokkaido,
  if(cl.`shop_large_area_name`='hokushinetsu',1,0) as hokushinetsu,
  if(cl.`shop_large_area_name`='kansai',1,0) as kansai,
  if(cl.`shop_large_area_name`='kanto',1,0) as kanto,
  if(cl.`shop_large_area_name`='kyushu_okinawa',1,0) as kyushu_okinawa,
  if(cl.`shop_large_area_name`='tohoku',1,0) as tohoku,
  if(cl.`shop_large_area_name`='tokai',1,0) as tokai,
  if(cl.`shop_large_area_name`='shikoku',1,0) as shikoku,
  if(cl.`shop_large_area_name`='gourmet',1,0) as gourmet,
  if(cl.`shop_large_area_name`='home_delivery_service',1,0) as home_delivery_service,
  if(cl.`shop_large_area_name`='hotel',1,0) as hotel,
  if(cl.`shop_large_area_name`='japanese_hotel',1,0) as japanese_hotel,
  if(cl.`shop_large_area_name`='other',1,0) as other,
  if(cl.`shop_large_area_name`='hair_salon',1,0) as hair_salon,
  if(cl.`shop_large_area_name`='nail_eye_salon',1,0) as nail_eye_salon,
  if(cl.`shop_large_area_name`='gift_card',1,0) as gift_card,
  if(cl.`shop_large_area_name`='relaxation',1,0) as relaxation,
  if(cl.`shop_large_area_name`='spa',1,0) as spa,
  if(cl.`shop_large_area_name`='lesson',1,0) as lesson, 
  if(cl.`shop_large_area_name`='web_service',1,0) as web_service, 
  if(cl.`shop_large_area_name`='leisure',1,0) as leisure, 
  if(cl.`shop_large_area_name`='event',1,0) as event,
  if(cl.`shop_large_area_name`='vacation_rental',1,0) as vacation_rental, 
  if(cl.`shop_large_area_name`='guesthouse',1,0) as guesthouse,   
  if(cl.`shop_large_area_name`='japanese_guesthouse',1,0) as japanese_guesthouse,   
  if(cl.`shop_large_area_name`='beauty',1,0) as beauty, 
  if(cl.`shop_large_area_name`='resort_inn',1,0) as resort_inn, 
  if(cl.`shop_large_area_name`='lodge',1,0) as lodge, 
  if(cl.`shop_large_area_name`='public_hotel',1,0) as public_hotel, 
  if(cl.`shop_large_area_name`='health_and_medical_care',1,0) as health_and_medical_care, 
  if(cl.`shop_large_area_name`='class',1,0) as class, 
  if(cl.`shop_large_area_name`='correspondence_course',1,0) as correspondence_course, 

  sum(item_count) as item_count
from weblog wb
join user_train ut on wb.user_id = ut.user_id
join coupon_list cl on cl.coupon_id = wb.`coupon_id`

group by wb.age, cl.shop_large_area_name, cl.`capsule_text`, cl.`price_rate`, cl.`usable_date_mon`, cl.usable_date_tue, cl.`usable_date_wed`, cl.`usable_date_thu`, cl.usable_date_fri, cl.usable_date_sat, cl.usable_date_sun
