
( SELECT AGG_CSV(DUTY_CLASS_CODE) 
	FROM T_JOB.JOB_DUTY 
	WHERE 
	JOBOFFER_NO = T_JOB.JOBOFFER_NO 
	AND CONTRACT_GEN_NO = T_JOB.CONTRACT_GEN_NO 
	AND DELETE_TSTAMP IS NULL
 ) AS DTY_CLS_CD_CSV;

---------------------------------------------------------------------------------------------------

(SELECT MIN(JOB_TYPE_CODE) KEEP (DENSE_RANK FIRST ORDER BY DISP_SEQ) 
FROM T_JOB.JOB_TYPE 
WHERE T_JOB.JOB_TYPE.JOBOFFER_NO = T_JOB.JOBOFFER_NO 
AND T_JOB.JOB_TYPE.CONTRACT_GEN_NO = T_JOB.CONTRACT_GEN_NO 
AND T_JOB.JOB_TYPE.DELETE_TSTAMP IS NULL) AS JB_TYPE_CD_1
)

---------------------------------------------------------------------------------------------------

ROW_NUMBER() OVER (PARTITION BY CONTRACT_MANAGEMENT_NO ORDER BY REGISTER_TSTAMP DESC) AS RN

---------------------------------------------------------------------------------------------------

INSERT INTO "DB_X"."EMAIL_TEMPLATE" (NAME, BODY_TEMPLATE, SUBJECT_TEMPLATE) VALUES ('TEMPLATE_EINVOICE', '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Thông tin về hóa đơn điện tử</title></head><body>Kính gửi Quý khách,<br></br><br></br>Thông báo về thông tin hóa đơn HĐ ${POLICY_NO}. Chi tiết hóa đơn vui lòng xem trong file đính kèm.<br></br><br></br>Để theo dõi và quản lý lịch sử giao dịch và xem lại các hóa đơn, Quý khách có thể đăng ký/đăng nhập cổng thông tin khách hàng trực tuyến tại https://kh.com.vn.<br></br><br></br>Trong trường hợp Quý khách có bất kỳ thắc mắc nào về Xác nhận giao dịch này, vui lòng:<ul style=”list-style-type:circle;”><li>Liên hệ Tổng đài phục vụ khách hàng <span style="color:red;">1800 999 99</span> (miễn cước).</li><li>Hồi âm lại qua địa chỉ email này (<span style="color:blue;">customer@abc.com.vn</span>).</li></ul>Rất hân hạnh được phục vụ Quý khách.<br></br><br></br>Trân trọng,<br></br><br></br>Công ty TNHH xy</body></html>', 'Thông tin về hóa đơn')

------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE SYNONYM "DB_X"."PAYMENT" FOR "DB_Y"."PAYMENT";
grant select on "DB_Y"."PAYMENT" to DB_X;

CREATE OR REPLACE SYNONYM "DB_X"."PAYMENT_DETAIL" FOR "DB_Y"."PAYMENT_DETAIL";
grant select on "DB_Y"."PAYMENT_DETAIL" to DB_X;

CREATE OR REPLACE SYNONYM DB_X.smspd FOR DB_Y.smspd;
grant select on DB_Y.smspd to DB_X;

--------------------------------------------------------PROJECT TEST-------------------------------------------------------------

CREATE TABLE "DB_TEST"."PUSH_DATA"
(
	"DATA_ID" NUMBER(10,0) NOT NULL ENABLE,
	"CODE" VARCHAR2(10 CHAR),
	"MESSAGE_TYPE" VARCHAR2(10 CHAR),
	"MOBILE_NO" VARCHAR2(20 CHAR),
	"POLICY_NUM" VARCHAR2(8 CHAR),
	"RAW_MESSAGE" VARCHAR2(1024 CHAR),
	"PRIORITY" NUMBER(1,0),
	"USERNAME" VARCHAR2(25 CHAR),
	"RECEIVER_TYPE_ID" NUMBER(10,0),
	"ATTACH_FILE" VARCHAR2(255 CHAR),
	CONSTRAINT "PK_ZNS_PUSH_DATA" PRIMARY KEY ("DATA_ID") 
);

COMMENT ON COLUMN "DB_TEST"."PUSH_DATA"."DATA_ID" IS 'Sequence PUSH_DATA_ID';

CREATE INDEX IDX_PD_HIS_01 ON PUSH_DATA_HISTORY(DATA_ID);
CREATE INDEX IDX_PD_HIS_02 ON PUSH_DATA_HISTORY(CODE, MOBILE_NO, POLICY_NUM);

---------------------------------------------------------------------------------------------

CREATE TABLE "DB_TEST"."MT_MESSAGE" 
(
	"MESSAGE_ID" NUMBER(10,0) NOT NULL ENABLE, 
	"PUSH_CODE" VARCHAR2(10 CHAR), 
	"MESSAGE" VARCHAR2(500 CHAR), 
	"MESSAGE_TYPE" VARCHAR2(10 CHAR), 
	"MOBILE_NO" VARCHAR2(12 CHAR), 
	"POLICY_NUM" VARCHAR2(8 CHAR), 
	"PRIORITY" NUMBER(1,0), 
	"SERVICE_NO" VARCHAR2(10 CHAR), 
	"REQUEST_ID" NUMBER(10,0), 
	"USERNAME" VARCHAR2(25 CHAR), 
	"UPDATE_DATE" DATE, 
	"TELCO_DESC" VARCHAR2(50 BYTE),
	"CNUM" VARCHAR2(8 CHAR),
	CONSTRAINT "PK_MT_MESSAGE" PRIMARY KEY ("MESSAGE_ID")
);

CREATE INDEX IDX_MT_MESSAGE_01 ON MT_MESSAGE (UPDATE_DATE, DESC, MOBILE_NO);
CREATE INDEX IDX_MT_MESSAGE_02 ON MT_MESSAGE (CODE, POLICY_NUM);

---------------------------------------------------------------------------------------------

CREATE SEQUENCE  "DB_TEST"."SEQ_MT_MESSAGE_ID"  MINVALUE 1 MAXVALUE 999999999 
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;

---------------------------------------------------------------------------------------------

CREATE TABLE "DB_TEST"."CODE" 
( 
	"ID" NUMBER(20,0) NOT NULL,
	"CODE" VARCHAR2(20 CHAR) unique,
	"ENABLE" CHAR(1 CHAR) default 'Y',
	"MESSAGE_TYPE" VARCHAR2(15 CHAR),
	"UPDATE_USERNAME" VARCHAR2(25 CHAR),
    "CREATE_DATE" TIMESTAMP(6),
    "S_DATE" DATE,
	"UPDATE_DATE" DATE default sysdate,,
    "UPDATE_DATE_TIME" DATETIME NOT NULL,
	"CREATE_DATE" DATETIME NOT NULL
    CONSTRAINT "TRACK_PK" PRIMARY KEY ("ID")
);

CREATE TABLE "NOTIFY_TRACK_2" (
	"ID" BIGINT IDENTITY(1,1) PRIMARY KEY,
	"SMS_ID" VARCHAR(40) NOT NULL UNIQUE,
	"ID_NUMBER" VARCHAR(30) NULL DEFAULT (NULL),
	"POLICY_NUMBER" VARCHAR(10) NULL DEFAULT (NULL),
	"STATUS" VARCHAR(20) NULL DEFAULT (NULL),
	"CHANNEL" VARCHAR(50) NULL DEFAULT (NULL),
	"SMS_DATE" DATE NULL DEFAULT (NULL)
);

COMMENT ON COLUMN "DB_TEST"."CODE"."PUSH_ENABLE" IS 'Y: enable, N: disable';
COMMENT ON COLUMN "DB_TEST"."CODE"."MESSAGE_TYPE" IS 'XXX';
COMMENT ON COLUMN "DB_TEST"."MT_SENT_FAILED"."MESSAGE_ID" IS 'Reference MT_MESSAGE';
COMMENT ON COLUMN "DB_TEST"."MT_SENT_FAILED"."ERROR_MESSAGE" IS 'Error sending MT';

---------------------------------------------------------------------------------------------

INSERT INTO "DB_TEST"."PUSH_CODE"(PUSH_CODE, MESSAGE_TYPE) VALUES ('A','B');
commit;

---------------------------------------------------------------------------------------------

ALTER TABLE SMS_1 ADD CNUM VARCHAR2(8 BYTE);
ALTER TABLE SMS_2 ADD CNUM VARCHAR2(8 BYTE);
ALTER TABLE sms_issue_policy ADD CNUM VARCHAR2(8 CHAR);

---------------------------------------------------------------------------------------------

create or replace TRIGGER NOTIFY_TRACK_SEQ
BEFORE INSERT ON NOTIFY_TRACK 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT NOTIFY_TRACK_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;

------------------------------------------------------------------------------------------------------------------------------------
--  DDL for Function FN_GET_AGNAME

CREATE OR REPLACE FUNCTION "DB_TEST"."FN_GET_AGNAME" (v_agntnum varchar2) return varchar2 is
Res varchar2(200):=null;
begin
  BEGIN
     select
        trim(cl.lsurname) || ' ' || trim(cl.lgivname) into res
     from clnt cl
     join agnt ag on ag.clntnum=cl.clntnum
     where cl.validflag='1'
     and ag.agntnum=v_agntnum;
  EXCEPTION
     WHEN others THEN
     NULL;
  END;
return FN_SMS_REMOVE_VIQR_CHARS(res);
end FN_GET_AGNAME;

------------------------------------------------------------------------------------------------------------------------------------
--  DDL for Function FN_GET_MESSAGE

CREATE OR REPLACE FUNCTION "DB_TEST"."FN_GET_MESSAGE" 
(
	  NUM IN VARCHAR2
	, POLNUM IN VARCHAR2
	, TRANDATE IN VARCHAR2
	, STATS IN VARCHAR2
) RETURN VARCHAR2 AS 

--khai bao cac bien
  message_date varchar2(10);
  premium varchar2(20);
  result varchar2(1200);
  bill_freq_text varchar2(20);
BEGIN 
  if(NUM='ZN') then
    message_date:=to_char(to_date(TRANDATE,'yyyymmdd'),'dd/mm/yyyy');
    premium:= trim(replace(to_char(SUBSTR(STATS,11,32)/100 ,'999,999,999,999') ,',','#'));
    result:='PR_NOT,' || POLNUM ||',' || message_date ||',' ||premium;

  elsif(NUM='ZN1') then
    message_date:=to_char(to_date(TRANDATE,'yyyymmdd'),'dd/mm/yyyy');
    premium:= trim(replace(to_char(SUBSTR(STATS,11,32)/100 ,'999,999,999,999') ,',','#'));
    lamount:= trim(replace(to_char(SUBSTR(STATS)/100 ,'999,999,999') ,',','#'));
    result:='PR_NOT1,' || POLNUM ||',' ||message_date ||',' || premium||',' || lamount;

  elsif(NUM='ZMY') then
    message_date := trim(substr(STATS, 22, 10));
    premium := trim(replace(to_char(substr(STATS,34,15) ,'999,999,999,999') ,',','#'));
    if(to_number(substr(STATS,34,15)) > 0) then
        result:='PZMY,' ||  POLNUM || ',' || message_date || ',' || premium;    
    end if;

  end if;
  RETURN result;
  EXCEPtion when others then null;
  RETURN result;

END FN_GET_MESSAGE;

------------------------------------------------------------------------------------------------------------------------------------
--  DDL for Procedure P_INSERT_PUSH_DATA

set define off;
CREATE OR REPLACE PROCEDURE "DB_TEST"."P_INSERT_DATA" (prundate DATE)
AS
BEGIN
  PKG_JOB.SP_GENERATE(prundate);
EXCEPTION 
  WHEN OTHERS THEN
    NULL;
END P_INSERT_PUSH_DATA;

------------------------------------------------------------------------------------------------------------------------------------
--  DDL for View VW_RLE

CREATE OR REPLACE FORCE VIEW "DB_TEST"."VW_RLE" ("USERNAME", "ROL_CODE", "SYSTEM") AS 
  SELECT
	  acctr.username, 
	  role.rol_code, 
	  role.system
  FROM account_roles acctr JOIN roles role ON role.role_id = acctr.role_id;
REM INSERTING into DB_TEST.VW_RLE
SET DEFINE OFF;
Insert into DB_TEST.VW_RLE (USERNAME,ROL_CODE,SYSTEM) values ('A','B','C');

------------------------------------------------------------------------------------------------------------------------------------
--  DDL for Sequence UM_ROL_SEQUENCE

CREATE SEQUENCE  "DB_TEST"."UM_ROL_SEQUENCE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;

------------------------------------------------------------------------------------------------------------------------------------
--  DDL for Trigger AM_SUB_TRIGGER

CREATE OR REPLACE TRIGGER "DB_TEST"."AM_SUB_TRIGGER" 
		            BEFORE INSERT
                    ON AM_SUBSCRIBER
                    REFERENCING NEW AS NEW
                    FOR EACH ROW
                    BEGIN
                    SELECT AM_SUB_SEQUENCE.nextval INTO :NEW.SUBSCRIBER_ID FROM dual;
                    END;

ALTER TRIGGER "DB_TEST"."AM_SUB_TRIGGER" ENABLE;

------------------------------------------------------------------------------------------------------------------------------------

