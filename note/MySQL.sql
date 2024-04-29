
CREATE TABLE holidays (
	contract_code VARCHAR (25) NOT NULL,
	working_day1_days INT2 DEFAULT 48,
	working_day1_grant_date1 INT2 DEFAULT 1,
	working_day1_grant_date2 INT2 DEFAULT 2,
	working_day1_grant_date3 INT2 DEFAULT 2,
	working_day1_grant_date4 INT2 DEFAULT 2,
	working_day1_grant_date5 INT2 DEFAULT 3,
	working_day1_grant_date6 INT2 DEFAULT 3,
	working_day1_grant_date7 INT2 DEFAULT 3,
	work_weekday_flg VARCHAR (3) DEFAULT 't',
	work_holiday_flg VARCHAR (3) DEFAULT 't',
	work_non_holiday_flg VARCHAR (3) DEFAULT 'f',
	PRIMARY KEY (`contract_code`)
) ENGINE=InnoDB DEFAULT CHARSET = utf8 COMMENT = 'abc';

CREATE TABLE salary (
	id INT4 NOT NULL,
	contract_code VARCHAR (25) NOT NULL,
	start_date DATE DEFAULT NULL,
	end_date DATE DEFAULT NULL,
	type VARCHAR (3),
	employee_id varchar(5) DEFAULT NULL,
	department_id INT4 DEFAULT NULL,
	employee_code VARCHAR (20) DEFAULT NULL,
	value INT2,
	PRIMARY KEY (`id`,`contract_code`)
) ENGINE = INNODB DEFAULT CHARSET = utf8 COMMENT = 'abc';


CREATE TABLE serial_number (
	giving_day DATE NOT NULL,
	number INT4 DEFAULT NULL,
	PRIMARY KEY (`giving_day`)
) ENGINE = INNODB DEFAULT CHARSET = utf8 COMMENT = 'abc';

CREATE TABLE approval_list (
	id INT4 NOT NULL,
	contract_code VARCHAR (25) NOT NULL,
	type_flg VARCHAR (3) DEFAULT NULL,
	employee_code VARCHAR (20) DEFAULT NULL,
	delete_time DATE DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE = INNODB DEFAULT CHARSET = utf8 COMMENT = 'aaa';

---------------------------------------------------------------------------------

CREATE SEQUENCE tbl_use_fee_id_seq;
CREATE TABLE "public"."tbl_use_fee"(
"code" VARCHAR(20) NOT NULL,
"name" VARCHAR(25),
"price" INT4,
"ent_time" DATE,
"delete_time" TIMESTAMP(0),
PRIMARY KEY(code)
)


CREATE TABLE mail_shipping_address(
id INT4 NOT NULL AUTO_INCREMENT COMMENT 'aaa',
contract_code VARCHAR(25) DEFAULT NULL COMMENT 'aaa',
TYPE  VARCHAR(3) DEFAULT NULL COMMENT 'aaa',
employee_code VARCHAR(20) DEFAULT NULL COMMENT 'bb',
delete_time DATE DEFAULT NULL COMMENT 'cc',
PRIMARY KEY(`id`)
) ENGINE = INNODB DEFAULT CHARSET=utf8 COMMENT = 'dd'


CREATE TABLE tbl_file_pdf(
	contract_code VARCHAR(25) NOT NULL COMMENT 'aa',
	k_emp_no VARCHAR(20) NOT NULL COMMENT 'aa',
	k_ymd DATE NOT NULL COMMENT 'aa',
	group_company_id INT(11) NOT NULL DEFAULT '0' COMMENT 'aa',
	employee_type_id VARCHAR(5) NOT NULL DEFAULT '00000' COMMENT 'aa',
	page_int INT(11) NOT NULL DEFAULT '1' COMMENT 'aa',
	pdf_file LONGBLOB COMMENT 'PDF',
	material_pdf_file1 LONGBLOB COMMENT 'a1',
	material_pdf_file2 LONGBLOB COMMENT 'a2',
	PRIMARY KEY(`contract_code`, `k_emp_no`, `k_ymd`, `group_company_id`, `employee_type_id`, `page_int`) USING BTREE
) ENGINE=MYISAM DEFAULT CHARSET=utf8


CREATE TABLE customer_transfer_bank(
  id INT4 NOT NULL AUTO_INCREMENT COMMENT 'ID',
  contract_code VARCHAR(25) NOT NULL COMMENT 'a',
  customer_code VARCHAR(25) NOT NULL COMMENT 'c',
  bank_id INT4 NOT NULL COMMENT 'ce',
  transfer_type VARCHAR(3) DEFAULT NULL COMMENT 'b',
  ent_time TIMESTAMP NULL DEFAULT NULL COMMENT 'd',
  PRIMARY KEY(id)
) ENGINE = INNODB DEFAULT CHARSET = utf8


CREATE TABLE `tbl_payment_layout_customer` (
  `format_name` VARCHAR(50) NOT NULL,
  `contract_code` VARCHAR(25) NOT NULL,
  `customer_name` VARCHAR(50) NOT NULL,
  `format_column` VARCHAR(3) NOT NULL,
  `customer_column` VARCHAR(3) NOT NULL,
  `employee_code` VARCHAR(20) DEFAULT NULL,
  `ent_time` DATETIME DEFAULT NULL,
  PRIMARY KEY (`format_name`,`contract_code`,`customer_name`,`format_column`,`customer_column`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8

--------------------------------------------------------------------------------
ALTER TABLE contract ADD COLUMN salary_flg VARCHAR (3) DEFAULT 'f';
ALTER TABLE contract ADD COLUMN overtime FLOAT4 DEFAULT 0.0;
ALTER TABLE contract ADD COLUMN legal_out_overtime FLOAT4 DEFAULT 25.0;
ALTER TABLE contract ADD COLUMN holiday_overtime FLOAT4 DEFAULT 35.0;
ALTER TABLE contract ADD COLUMN working_time_type VARCHAR (3);
ALTER TABLE contract ADD COLUMN paid_time_type_month INT2;
ALTER TABLE contract ADD COLUMN working_day INT2 DEFAULT 5;
ALTER TABLE employee ADD COLUMN working_day INT2 DEFAULT 5;
ALTER TABLE department ADD COLUMN legal_overtime FLOAT4 DEFAULT 0;
ALTER TABLE contract ADD COLUMN user_info TEXT;
ALTER TABLE contract ADD COLUMN user_info_timestamp TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE ;
ALTER TABLE master_setting ADD COLUMN url VARCHAR(255) DEFAULT NULL;
ALTER TABLE master_setting ADD COLUMN mail_address_from VARCHAR(255) DEFAULT NULL;
ALTER TABLE contract ADD COLUMN template_no INT(11) DEFAULT NULL;
ALTER TABLE contract ADD COLUMN info TEXT;

ALTER TABLE contract ADD COLUMN overtime_value INT(4) DEFAULT '45';
ALTER TABLE contract ADD COLUMN overtime_month INT(2) DEFAULT '6';
ALTER TABLE contract ADD COLUMN overtime_special_year INT(4) DEFAULT '720';
ALTER TABLE contract ADD COLUMN paid_holidays INT(2) DEFAULT '10';
ALTER TABLE contract ADD COLUMN report_approval_flg VARCHAR(3) DEFAULT NULL COMMENT 'xwe'

---------------------------------------------------------------------------------------
ALTER TABLE employee_type_master DROP INDEX employee_type_id
ALTER TABLE department DROP PRIMARY KEY, ADD PRIMARY KEY (ID,CONTRACT_CODE);
ALTER TABLE shift_master DROP INDEX id

------------------------------------------------------------------------------------------------
ALTER TABLE contract MODIFY COLUMN paid_time_val INT2 DEFAULT 8;

ALTER TABLE shift_application_management MODIFY date_acquisition DATE
ALTER TABLE shift_application_management MODIFY ent_time DATE;
ALTER TABLE shift_application_management MODIFY delete_time DATE;
ALTER TABLE shift_application_management ADD COLUMN transfer_function_type INT(2) DEFAULT 0 COMMENT 'z';
ALTER TABLE shift_application_management ADD COLUMN transfer_function_day DATE DEFAULT NULL COMMENT 'z';

------------------------------------------------------------------------------------------------
INSERT INTO `funtion_master`(`funtion_id`,`funtion_name`,`select_pattern`,`is_select_area_department`,`location_funtion`,`start_date`,`end_date`)
VALUES("00610","aaz","002","t","010",NULL,NULL)

INSERT INTO `msg_master`(`msg_id`,`msg`,`color`,`is_bold`)VALUES("18002",'a',"red","f");=

------------------------------------------------------------------------------------------------

WITH OIDS;
COMMENT ON COLUMN "public"."tbl_use_fee"."code" IS 'x';
COMMENT ON COLUMN "public"."tbl_use_fee"."name" IS 'y';
COMMENT ON COLUMN "public"."tbl_use_fee"."price" IS 'z';

------------------------------------------------------------------------------------------------
/*Table structure for table `admin_setting` */

DROP TABLE IF EXISTS `admin_setting`;

CREATE TABLE `admin_setting` (
  `ID` int(4) NOT NULL AUTO_INCREMENT,
  `DEPARTMENT_ID` int(4) DEFAULT NULL,
  `RESPONSIBLE_SETTING` varchar(3) DEFAULT NULL,
  `EMPLOYEE_CODE` varchar(20) DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `INPUT_PERSON` varchar(20) DEFAULT NULL,
  `INPUT_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `ADMIN_SETTING_IBFK_1` (`DEPARTMENT_ID`),
  KEY `ADMIN_SETTING_IBFK_2` (`EMPLOYEE_CODE`),
  KEY `FKB0DFF96018CE9921` (`DEPARTMENT_ID`),
  KEY `FKB0DFF960E25D21F3` (`EMPLOYEE_CODE`),
  CONSTRAINT `ADMIN_SETTING_IBFK_1` FOREIGN KEY (`DEPARTMENT_ID`) REFERENCES `department` (`ID`),
  CONSTRAINT `ADMIN_SETTING_IBFK_2` FOREIGN KEY (`EMPLOYEE_CODE`) REFERENCES `employee` (`EMPLOYEE_CODE`),
  CONSTRAINT `FKB0DFF96018CE9921` FOREIGN KEY (`DEPARTMENT_ID`) REFERENCES `department` (`ID`),
  CONSTRAINT `FKB0DFF960E25D21F3` FOREIGN KEY (`EMPLOYEE_CODE`) REFERENCES `employee` (`EMPLOYEE_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='28. Nguoi quan li';

-----------------------------------------------------------------------------------------------

/*Table structure for table `access_history` */

DROP TABLE IF EXISTS `access_history`;

CREATE TABLE `access_history` (
  `DATES` timestamp NULL DEFAULT NULL,
  `EMPLOYEE_CODE` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `URL` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `HEADER_INFORMATION` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `CONTENT_ACCESS` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Quan ly thong tin access';

------------------------------------------------------------------------------------------

