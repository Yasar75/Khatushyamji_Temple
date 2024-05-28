CREATE TABLE AXP_MAILJOBS
(
  MAILTO             VARCHAR(1000),
  MAILCC             VARCHAR(1000),
  SUBJECT            VARCHAR(1000),
  BODY               VARCHAR(4000),
  RECIPIENTCATEGORY  VARCHAR(500),
  ENQUIRYNO          VARCHAR(30),
  ATTACHMENTS        VARCHAR(1000),
  IVIEWNAME          VARCHAR(10),
  IVIEWPARAMS        VARCHAR(500),
  TRANSID            VARCHAR(10),
  RECORDID           numeric(16),
  STATUS             numeric(2),
  ERRORMESSAGE       VARCHAR(500),
  SENTON             DATE,
  JOBID     int not null auto_increment PRIMARY KEY
);

ALTER TABLE AXP_MAILJOBS ADD  jobdate DATE;

drop table AXUSRHISTORY;

CREATE TABLE AXUSRHISTORY
(
  RECORDID       NUMERIC(16),
  MODIFIEDDATE   DATE,
  USERNAME        VARCHAR(30),
  FIELDNAME       VARCHAR(30),
  OLDVALUE        VARCHAR(250),
  NEWVALUE        VARCHAR(250),
  ROWNO          NUMERIC(38),
  DELFLAG         VARCHAR(1),
  MODNO          NUMERIC(10),
  FRAMENO        NUMERIC(10),
  PARENTROW      NUMERIC(10),
  TABLERECID     NUMERIC(16),
  IDVALUE        NUMERIC(16),
  OLDIDVALUE     NUMERIC(16),
  TRANSDELETED    VARCHAR(5),
  NEWTRANS        VARCHAR(5),
  CANCELTRANS     VARCHAR(1),
  CANCELREMARKS   VARCHAR(250)
);

CREATE TABLE USAGEDTL
(
  EXECUTEDDATE  DATE,
  CODE           VARCHAR(20),
  TITLE          VARCHAR(50),
  CNT           NUMERIC(18)
);

CREATE TABLE AXPEXCEPTION
(
  EXP_DATE       DATE,
  STRUCTNAME      VARCHAR(16),
  SERVICENAME     VARCHAR(50),
  SERVICERESULT   VARCHAR(500),
  COUNT         NUMERIC(18)
);

CREATE TABLE ut_timetaken
(
   executed_date   DATE,
   object_type      VARCHAR (10),
   service_name     VARCHAR (100),
   object_name      VARCHAR (100),
   tot_count       NUMERIC (10),
   count_8s        NUMERIC (10),
   count_30s       NUMERIC (10),
   count_90s       NUMERIC (10),
   min_time        NUMERIC (10, 2),
   max_time        NUMERIC (10, 2),
   avg_time        NUMERIC (10, 2)
);

DROP TABLE AXCONSTRAINTS;

CREATE TABLE AXCONSTRAINTS
(
  AXCONSTRAINTSID  numeric(15),
  CANCEL           CHAR(1),
  SOURCEID         numeric(15),
  MAPNAME           VARCHAR(20),
  USERNAME          VARCHAR(50),
  MODIFIEDON       DATE,
  CREATEDBY         VARCHAR(50),
  CREATEDON        DATE,
  WKID              VARCHAR(15),
  APP_LEVEL        NUMERIC(3),
  APP_DESC         NUMERIC(1),
  APP_SLEVEL       NUMERIC(3),
  CANCELREMARKS     VARCHAR(150),
  WFROLES           VARCHAR(250),
  CONSTRAINT_NAME   VARCHAR(50),
  MSG               VARCHAR(1000)
);

ALTER TABLE axusergroups ADD axusergroupsid NUMERIC(15);
ALTER TABLE AXUSERS ADD cancelremarks  VARCHAR(300);
ALTER TABLE AXUSERS ADD axusersid numeric(15);
ALTER TABLE AXUSERS ADD cancel  VARCHAR(10);
ALTER TABLE AXUSERLEVELGROUPS ADD axusersid NUMERIC(15);
ALTER TABLE AXUSERS ADD sourceid numeric(15);
ALTER TABLE axsms ADD createdon date;
alter table axusers modify pwd varchar(20);
ALTER TABLE AXUSERLEVELGROUPS ADD axuserlevelgroupsid NUMERIC(15);
ALTER TABLE AXPEXCHANGE ADD axpexchangeid NUMERIC(15);
ALTER TABLE AXINTELLIVIEWDET ADD axintelliviewdetid NUMERIC(15);
ALTER TABLE AXUSERGROUPS ADD cancelremarks  VARCHAR(300);
ALTER TABLE AXUSERGROUPS ADD axusersid numeric(15);
ALTER TABLE AXUSERGROUPS ADD cancel  VARCHAR(10);


CREATE VIEW AX_OUTBOUND_STATUS
(
   FILENAME,
   SENTON,
   OUTDATE,
   TRANSID,
   TSTRUCTNAME,
   OUTSTATUS
)
AS
SELECT a.recordid filename,
         CAST(a.senton AS DATE) senton,
   CAST(a.senton AS DATE) outdate,
          a.transid,
          b.caption tstructname,
          CASE WHEN senton IS NULL THEN 'Pending' ELSE 'Sent' END outstatus
     FROM outbound a, tstructs b
    WHERE a.transid = b.name;


CREATE  VIEW AX_INBOUND_STATUS
(
   FILENAME,
   RECDON,
   INDATE,
   TRANSID,
   TSTRUCTNAME,
   INSTATUS
)
AS
   SELECT filename,
          CAST(a.recdon AS DATE) recdon,
          CAST(a.recdon AS DATE) indate,
          transid,
          caption tstructname,
          instatus
     FROM inbound a, tstructs b
    WHERE a.transid = b.name;

ALTER TABLE axusers ADD UNIQUE (Pusername);
ALTER TABLE AXDSIGNMAIL ADD AXDSIGNMAILid NUMERic(15);


CREATE TRIGGER t1_axusers
   before INSERT ON axusers for each row
BEGIN
	
	set new.username=new.pusername;
	set new.password=new.ppassword;
	    
END;

CREATE TRIGGER t2_axusers
   before update ON axusers for each row
BEGIN
	
	set new.username=new.pusername;
	    
END;



ALTER TABLE AXDSIGNCONFIG ADD AXDSIGNCONFIGid NUMERic(15);

drop table axsms;

CREATE TABLE AXSMS
(
  RECORDID  int auto_increment PRIMARY KEY,
  MOBILENO   VARCHAR(10),
  MSG        VARCHAR(250),
  STATUS     NUMERic(1),
  SENTON     DATE,
  REMARKS    VARCHAR(1000),
  CREATEDON  DATE
);

CREATE TRIGGER TRG_UPDATDSIGN 
   BEFORE INSERT ON  AXDSIGNCONFIG  FOR EACH ROW
BEGIN
	
	set new.username=new.pusername;  
  set new.rolename=new.prolename;
    
END;

CREATE TRIGGER TRG2_UPDATDSIGN 
   BEFORE UPDATE ON  AXDSIGNCONFIG  FOR EACH ROW
BEGIN
	
	set new.username=new.pusername;  
  set new.rolename=new.prolename;
    
END;

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY)
     VALUES (
        'Head14',
        'Configuration',
        '<root img="" visible="T" name="Head14" caption="Configuration" createdon="06/11/2015 17:04:24" createdby="admin" importedon="17/11/2015 19:32:12" importedby="admin" updatedon="06/11/2015 17:04:24" updatedby="admin" type="h" ordno="2" levelno="1" parent="" ptype="h" pgtype="" dbtype="oracle"></root>',
        1,
        'T',
        'h',
        'Head19',
        2,
        1,
        '18/11/2015 12:16:42',
        '06/11/2015 17:04:24',
        '17/11/2015 19:32:12',
        'admin',
        'admin',
        'admin');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY)
     VALUES (
        'Head16',
        'Data Setup',
        '<root img="" visible="T" name="Head16" caption="Data Setup" createdon="06/11/2015 17:08:07" createdby="admin" importedon="17/11/2015 19:32:12" importedby="admin" updatedon="06/11/2015 17:08:07" updatedby="admin" type="h" ordno="12" levelno="1" parent="" ptype="h" pgtype="" dbtype="oracle"></root>',
        1,
        'T',
        'h',
        'Head19',
        14,
        1,
        '18/11/2015 12:16:42',
        '06/11/2015 17:08:07',
        '17/11/2015 19:32:12',
        'admin',
        'admin',
        'admin');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY)
     VALUES (
        'Head17',
        'Admin Utilities',
        '<root img="" visible="T" name="Head17" caption="Admin Utilities" createdon="06/11/2015 17:09:27" createdby="admin" importedon="17/11/2015 19:32:12" importedby="admin" updatedon="06/11/2015 17:09:27" updatedby="admin" type="h" ordno="15" levelno="1" parent="" ptype="h" pgtype="" dbtype="oracle"></root>',
        1,
        'T',
        'h',
        'Head19',
        17,
        1,
        '18/11/2015 12:16:42',
        '06/11/2015 17:09:27',
        '17/11/2015 19:32:12',
        'admin',
        'admin',
        'admin');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY)
     VALUES (
        'Head18',
        'Admin Reports',
        '<root img="" visible="T" name="Head18" caption="Admin Reports" createdon="06/11/2015 17:10:03" createdby="admin" importedon="17/11/2015 19:32:12" importedby="admin" updatedon="06/11/2015 17:10:03" updatedby="admin" type="h" ordno="17" levelno="1" parent="" ptype="h" pgtype="" dbtype="oracle"></root>',
        1,
        'T',
        'h',
        'Head19',
        19,
        1,
        '18/11/2015 12:16:42',
        '06/11/2015 17:10:03',
        '17/11/2015 19:32:12',
        'admin',
        'admin',
        'admin');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY)
     VALUES (
        'Head19',
        'Admin Setup',
        '<root img="" visible="T" name="Head19" caption="Admin Setup" createdon="12/11/2015 15:56:31" createdby="admin" importedon="17/11/2015 19:32:13" importedby="admin" updatedon="12/11/2015 15:56:31" updatedby="admin" type="h" ordno="1" levelno="0" parent="" ptype="h" pgtype="" dbtype="oracle"></root>',
        1,
        'T',
        'h',
        1,
        0,
        '18/11/2015 12:16:42',
        '12/11/2015 15:56:31',
        '17/11/2015 19:32:13',
        'admin',
        'admin',
        'admin');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvadxconfv',
        'ADX Configuration',
        '<root visible="T" type="p" defpage="T" name="PageIvadxconfv" caption="ADX Configuration" createdon="03/07/2015 14:42:41" createdby="admin" importedon="17/11/2015 19:32:15" importedby="admin" updatedon="06/08/2015 06:59:30" updatedby="admin" img="" ordno="6" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iadxconfv" dbtype="oracle"><Container21 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,659,1129" st="view__adxconfv" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__adxconfv cat="iview" name="adxconfv" parent="Container21" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        5,
        2,
        '18/11/2015 12:16:42',
        '03/07/2015 14:42:41',
        '17/11/2015 19:32:15',
        'admin',
        'admin',
        'admin',
        'iadxconfv');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvadxinlog',
        'ADX Inbound Log',
        '<root visible="T" type="p" defpage="T" name="PageIvadxinlog" caption="ADX Inbound Log" createdon="02/07/2015 17:51:06" createdby="admin" importedon="17/11/2015 19:32:15" importedby="admin" updatedon="02/07/2015 17:51:06" updatedby="admin" img="" ordno="21" levelno="2" parent="" updusername="" ptype="p" pgtype="iadxinlog" dbtype="oracle"><Container16 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__adxinlog"/><view__adxinlog cat="iview" name="adxinlog" parent="Container16" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head18',
        23,
        2,
        '18/11/2015 12:16:42',
        '02/07/2015 17:51:06',
        '17/11/2015 19:32:15',
        'admin',
        'admin',
        'admin',
        'iadxinlog');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvadxoutlo',
        'ADX Outbound Log',
        '<root visible="T" type="p" defpage="T" name="PageIvadxoutlo" caption="ADX Outbound Log" createdon="02/07/2015 17:39:09" createdby="admin" importedon="17/11/2015 19:32:15" importedby="admin" updatedon="02/07/2015 17:39:09" updatedby="admin" img="" ordno="20" levelno="2" parent="" updusername="" ptype="p" pgtype="iadxoutlo" dbtype="oracle"><Container15 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__adxoutlo"/><view__adxoutlo cat="iview" name="adxoutlo" parent="Container15" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head18',
        22,
        2,
        '18/11/2015 12:16:42',
        '02/07/2015 17:39:09',
        '17/11/2015 19:32:15',
        'admin',
        'admin',
        'admin',
        'iadxoutlo');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     IMPORTEDON,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvapplogsm',
        'Application Usage Statistics',
        '<root visible="T" type="p" defpage="T" updatedon="29/10/2015 18:55:08" name="PageIvapplogsm" caption="Application Usage Statistics" img="" ordno="23" levelno="2" parent="" updusername="" ptype="p" pgtype="iapplogsm" importedon="17/11/2015 19:32:16" importedby="admin" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" updatedby="admin" dbtype="oracle"><Container187 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__applogsm" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__applogsm cat="iview" name="applogsm" parent="Container187" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head18',
        25,
        2,
        '18/11/2015 12:16:42',
        '17/11/2015 19:32:16',
        'admin',
        'admin',
        'iapplogsm');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvaxchtdtl',
        'Dashboard Configuration',
        '<root visible="T" type="p" defpage="T" name="PageIvaxchtdtl" caption="Dashboard Configuration" createdon="03/07/2015 17:09:28" createdby="admin" importedon="17/11/2015 19:32:16" importedby="admin" updatedon="16/11/2015 16:57:09" updatedby="admin" img="" ordno="10" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iaxchtdtl" dbtype="oracle"><Container39 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__axchtdtl" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__axchtdtl cat="iview" name="axchtdtl" parent="Container39" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        11,
        2,
        '18/11/2015 12:16:42',
        '03/07/2015 17:09:28',
        '17/11/2015 19:32:16',
        'admin',
        'admin',
        'admin',
        'iaxchtdtl');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvaxemllog',
        'Email Log',
        '<root visible="T" type="p" defpage="T" name="PageIvaxemllog" caption="Email Log" createdon="02/07/2015 12:38:42" createdby="admin" importedon="17/11/2015 19:32:16" importedby="admin" updatedon="02/07/2015 12:38:42" updatedby="admin" img="" ordno="19" levelno="2" parent="" updusername="" ptype="p" pgtype="iaxemllog" dbtype="oracle"><Container14 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axemllog"/><view__axemllog cat="iview" name="axemllog" parent="Container14" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head18',
        20,
        2,
        '18/11/2015 12:16:42',
        '02/07/2015 12:38:42',
        '17/11/2015 19:32:16',
        'admin',
        'admin',
        'admin',
        'iaxemllog');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvaxfinyrs',
        'Year',
        '<root visible="T" type="p" defpage="T" name="PageIvaxfinyrs" caption="Year" createdon="22/07/2015 17:54:11" createdby="admin" importedon="17/11/2015 19:32:16" importedby="admin" updatedon="16/11/2015 18:32:58" updatedby="admin" img="" ordno="14" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iaxfinyrs" dbtype="oracle"><Container55 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__axfinyrs" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__axfinyrs cat="iview" name="axfinyrs" parent="Container55" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head16',
        16,
        2,
        '18/11/2015 12:16:42',
        '22/07/2015 17:54:11',
        '17/11/2015 19:32:16',
        'admin',
        'admin',
        'admin',
        'iaxfinyrs');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvitimtk',
        'Time Taken Analysis',
        '<root visible="T" type="p" defpage="T" name="PageIvitimtk" caption="Time Taken Analysis" createdon="17/11/2015 11:27:11" createdby="admin" importedon="17/11/2015 19:32:18" importedby="admin" updatedon="17/11/2015 11:27:11" updatedby="admin" img="" ordno="24" levelno="2" parent="" updusername="" ptype="p" pgtype="iitimtk" dbtype="oracle"><Container12 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__itimtk"/><view__itimtk cat="iview" name="itimtk" parent="Container12" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head18',
        26,
        2,
        '18/11/2015 12:16:42',
        '17/11/2015 11:27:11',
        '17/11/2015 19:32:18',
        'admin',
        'admin',
        'admin',
        'iitimtk');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvloview1',
        'List of Values',
        '<root visible="T" type="p" defpage="T" name="PageIvloview1" caption="List of Values" createdon="21/08/2015 16:14:45" createdby="admin" importedon="17/11/2015 19:32:18" importedby="admin" updatedon="21/08/2015 17:57:50" updatedby="admin" img="" ordno="13" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iloview1" dbtype="oracle"><Container74 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__loview1" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__loview1 cat="iview" name="loview1" parent="Container74" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head16',
        15,
        2,
        '18/11/2015 12:16:42',
        '21/08/2015 16:14:45',
        '17/11/2015 19:32:18',
        'admin',
        'admin',
        'admin',
        'iloview1');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     IMPORTEDON,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvsmslog',
        'SMS Log',
        '<root visible="T" type="p" defpage="T" updatedon="05/17/2012 11:04:42" name="PageIvsmslog" caption="SMS Log" img="" ordno="18" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="ismslog" importedon="17/11/2015 19:32:18" importedby="admin" dbtype="oracle"><Container179 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,676,1045" st="view__smslog" font=",,," color="$00FAF7F1"/><view__smslog cat="iview" name="smslog" parent="Container179" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head18',
        21,
        2,
        '18/11/2015 12:16:42',
        '17/11/2015 19:32:18',
        'admin',
        'ismslog');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvthint',
        'Transaction Hint',
        '<root visible="T" type="p" defpage="T" name="PageIvthint" caption="Transaction Hint" createdon="19/11/2015 11:21:45" createdby="admin" importedon="" importedby="" updatedon="19/11/2015 11:21:45" updatedby="admin"><Container4 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__thint"/><view__thint cat="iview" name="thint" parent="Container4" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        13,
        2,
        '19/11/2015 11:21:45',
        '19/11/2015 11:21:45',
        'admin',
        'admin',
        'ithint');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvcerrm',
        'Custom Error Messages',
        '<root visible="T" type="p" defpage="T" name="PageIvcerrm" caption="Custom Error Messages" createdon="18/11/2015 11:20:57" createdby="admin" importedon="" importedby="" updatedon="18/11/2015 11:20:57" updatedby="admin"><Container3 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__cerrm"/><view__cerrm cat="iview" name="cerrm" parent="Container3" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        9,
        2,
        '18/11/2015 11:20:57',
        '18/11/2015 11:20:57',
        'admin',
        'admin',
        'icerrm');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvaxnxtlst',
        'Intelliview Configuration',
        '<root visible="T" type="p" defpage="T" name="PageIvaxnxtlst" caption="Intelliview Configuration" createdon="21/07/2015 12:16:42" createdby="admin" importedon="17/11/2015 19:32:16" importedby="admin" updatedon="21/07/2015 12:16:42" updatedby="admin" img="" ordno="9" levelno="2" parent="" updusername="" ptype="p" pgtype="iaxnxtlst" dbtype="oracle"><Container47 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axnxtlst"/><view__axnxtlst cat="iview" name="axnxtlst" parent="Container47" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        10,
        2,
        '18/11/2015 12:16:42',
        '21/07/2015 12:16:42',
        '17/11/2015 19:32:16',
        'admin',
        'admin',
        'admin',
        'iaxnxtlst');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvaxroles',
        'User Roles',
        '<root visible="T" type="p" defpage="T" name="PageIvaxroles" caption="User Roles" createdon="21/07/2015 12:26:56" createdby="admin" importedon="17/11/2015 19:32:16" importedby="admin" updatedon="21/07/2015 12:26:56" updatedby="admin" img="" ordno="3" levelno="2" parent="" updusername="" ptype="p" pgtype="iaxroles" dbtype="oracle"><Container50 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axroles"/><view__axroles cat="iview" name="axroles" parent="Container50" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        3,
        2,
        '18/11/2015 12:16:42',
        '21/07/2015 12:26:56',
        '17/11/2015 19:32:16',
        'admin',
        'admin',
        'admin',
        'iaxroles');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvaxusers',
        'User Logins',
        '<root visible="T" type="p" defpage="T" name="PageIvaxusers" caption="User Logins" createdon="21/07/2015 12:32:11" createdby="admin" importedon="17/11/2015 19:32:17" importedby="admin" updatedon="21/07/2015 12:32:11" updatedby="admin" img="" ordno="4" levelno="2" parent="" updusername="" ptype="p" pgtype="iaxusers" dbtype="oracle"><Container51 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axusers"/><view__axusers cat="iview" name="axusers" parent="Container51" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        4,
        2,
        '18/11/2015 12:16:42',
        '21/07/2015 12:32:11',
        '17/11/2015 19:32:17',
        'admin',
        'admin',
        'admin',
        'iaxusers');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvaxusracc',
        'User Access Report',
        '<root visible="T" type="p" defpage="T" name="PageIvaxusracc" caption="User Access Report" createdon="29/07/2015 12:53:09" createdby="admin" importedon="17/11/2015 19:32:17" importedby="admin" updatedon="29/10/2015 18:41:39" updatedby="admin" img="" ordno="22" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iaxusracc" dbtype="oracle"><Container59 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__axusracc" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__axusracc cat="iview" name="axusracc" parent="Container59" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head18',
        24,
        2,
        '18/11/2015 12:16:42',
        '29/07/2015 12:53:09',
        '17/11/2015 19:32:17',
        'admin',
        'admin',
        'admin',
        'iaxusracc');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     IMPORTEDON,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvdmlscrpt',
        'Script Runner',
        '<root visible="T" type="p" defpage="T" updatedon="21/07/2015 13:01:51" name="PageIvdmlscrpt" caption="Script Runner" img="" ordno="16" levelno="2" parent="" updusername="" ptype="p" pgtype="idmlscrpt" importedon="17/11/2015 19:32:17" importedby="admin" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" updatedby="admin" dbtype="oracle"><Container538 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,648,1131" st="view__dmlscrpt" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__dmlscrpt cat="iview" name="dmlscrpt" parent="Container538" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head17',
        18,
        2,
        '18/11/2015 12:16:42',
        '17/11/2015 19:32:17',
        'admin',
        'admin',
        'idmlscrpt');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvesmsco',
        'Email/SMS Configuration',
        '<root visible="T" type="p" defpage="T" name="PageIvesmsco" caption="Email/SMS Configuration" createdon="16/11/2015 12:54:29" createdby="admin" importedon="17/11/2015 19:32:17" importedby="admin" updatedon="16/11/2015 12:54:29" updatedby="admin" img="" ordno="8" levelno="2" parent="" updusername="" ptype="p" pgtype="iesmsco" dbtype="oracle"><Container5 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__esmsco"/><view__esmsco cat="iview" name="esmsco" parent="Container5" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        8,
        2,
        '18/11/2015 12:16:42',
        '16/11/2015 12:54:29',
        '17/11/2015 19:32:17',
        'admin',
        'admin',
        'admin',
        'iesmsco');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIviaxex',
        'Application Exceptions',
        '<root visible="T" type="p" defpage="T" name="PageIviaxex" caption="Application Exceptions" createdon="17/11/2015 12:18:45" createdby="admin" importedon="17/11/2015 19:32:17" importedby="admin" updatedon="17/11/2015 12:18:45" updatedby="admin" img="" ordno="25" levelno="2" parent="" updusername="" ptype="p" pgtype="iiaxex" dbtype="oracle"><Container13 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__iaxex"/><view__iaxex cat="iview" name="iaxex" parent="Container13" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head18',
        27,
        2,
        '18/11/2015 12:16:42',
        '17/11/2015 12:18:45',
        '17/11/2015 19:32:17',
        'admin',
        'admin',
        'admin',
        'iiaxex');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvidsco',
        'DSign Configuration',
        '<root visible="T" type="p" defpage="T" name="PageIvidsco" caption="DSign Configuration" createdon="16/11/2015 18:12:24" createdby="admin" importedon="17/11/2015 19:32:18" importedby="admin" updatedon="16/11/2015 18:15:54" updatedby="admin" img="" ordno="11" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iidsco" dbtype="oracle"><Container11 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__idsco" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__idsco cat="iview" name="idsco" parent="Container11" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        12,
        2,
        '18/11/2015 12:16:42',
        '16/11/2015 18:12:24',
        '17/11/2015 19:32:18',
        'admin',
        'admin',
        'admin',
        'iidsco');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvikywd',
        'Keyword Template',
        '<root visible="T" type="p" defpage="T" name="PageIvikywd" caption="Keyword Template" createdon="16/11/2015 16:51:37" createdby="admin" importedon="17/11/2015 19:32:18" importedby="admin" updatedon="16/11/2015 16:55:05" updatedby="admin" img="" ordno="7" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iikywd" dbtype="oracle"><Container9 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__ikywd" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__ikywd cat="iview" name="ikywd" parent="Container9" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        7,
        2,
        '18/11/2015 12:16:42',
        '16/11/2015 16:51:37',
        '17/11/2015 19:32:18',
        'admin',
        'admin',
        'admin',
        'iikywd');

INSERT INTO AXPAGES (NAME,
                     CAPTION,
                     PROPS,
                     BLOBNO,
                     VISIBLE,
                     TYPE,
                     PARENT,
                     ORDNO,
                     LEVELNO,
                     UPDATEDON,
                     CREATEDON,
                     IMPORTEDON,
                     CREATEDBY,
                     UPDATEDBY,
                     IMPORTEDBY,
                     PAGETYPE)
     VALUES (
        'PageIvimobc',
        'Mobile Configuration',
        '<root visible="T" type="p" defpage="T" name="PageIvimobc" caption="Mobile Configuration" createdon="12/11/2015 15:47:34" createdby="admin" importedon="17/11/2015 19:32:18" importedby="admin" updatedon="12/11/2015 15:50:22" updatedby="admin" img="" ordno="5" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iimobc" dbtype="oracle"><Container2 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__imobc" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__imobc cat="iview" name="imobc" parent="Container2" align="Client"/></root>',
        1,
        'T',
        'p',
        'Head14',
        6,
        2,
        '18/11/2015 12:16:42',
        '12/11/2015 15:47:34',
        '17/11/2015 19:32:18',
        'admin',
        'admin',
        'admin',
        'iimobc');
        
update axpages set UPDATEDON = CAST(NOW() AS DATE),CREATEDON= CAST(NOW() AS DATE);
        
---------------------------------

CREATE TRIGGER trg1_AXUSERLEVELGROUPS
   before INSERT ON AXUSERLEVELGROUPS for each row
BEGIN
	
	set new.username=new.axUSERNAME;
	set new.usergroup=:NEW.axusergroup;
	    
END;

CREATE TRIGGER trg2_AXUSERLEVELGROUPS
   before update ON AXUSERLEVELGROUPS for each row
BEGIN
	
	set new.username=new.axUSERNAME;
	set new.usergroup=:NEW.axusergroup;
	    
END;

CREATE PROCEDURE pro_axplogstatextract(fdate DATE)
BEGIN
   DELETE FROM usagedtl  WHERE date(executeddate)=fdate;

INSERT INTO usagedtl(executeddate,
                     code,
                     title,
                     cnt)
   SELECT date(calledon) cdate,
               'NOT' CODE,
               'Total No. of Transactions' title,
               COUNT(*) cnt
          FROM axpertlog
         WHERE date(calledon) = fdate
      GROUP BY date(calledon)
      UNION ALL
        SELECT date(calledon) cdate,
               'NOL' CODE,
               'Total No. of Logins' title,
               COUNT(*) cnt
          FROM axpertlog
         WHERE date(calledon) = fdate AND servicename = 'Login'
      GROUP BY date(calledon)
      UNION ALL
        SELECT date(calledon) cdate,
               'NOU' CODE,
               'Total No. of Users' title,
               COUNT(DISTINCT username) cnt
          FROM axpertlog
         WHERE date(calledon) = fdate AND servicename = 'Login'
      GROUP BY date(calledon)
      UNION ALL
        SELECT date(calledon) cdate,
               'NOD' CODE,
               'Total No. of Deadlock Execptions' title,
               COUNT(*) cnt
          FROM axpertlog
         WHERE date(calledon) = fdate
               AND serviceresult LIKE 'trans%dead%'
      GROUP BY date(calledon)
      UNION ALL
        SELECT date(calledon) cdate,
               'MTJ' CODE,
               'More time taken Saves (> 8 Sec)' title,
               COUNT(*) cnt
          FROM axpertlog
         WHERE     date(calledon) = fdate
               AND servicename = 'saving data'
               AND serviceresult = 'success'
               AND recordid = 0
               AND (timetaken / 1000) > 8
      GROUP BY date(calledon)
      UNION ALL
        SELECT date(calledon) cdate,
               'MTL' CODE,
               'More time taken Loads (> 8 Sec)' title,
               COUNT(*) cnt
          FROM axpertlog
         WHERE     date(calledon) = fdate
               AND servicename = 'load data'
               AND serviceresult = 'success'
               AND (timetaken / 1000) > 8
      GROUP BY date(calledon)
      UNION ALL
      SELECT date(calledon) cdate,
             'MTL' CODE,
             'More time taken reports (> 8 Sec)' title,
             COUNT(*) cnt
        FROM axpertlog
       WHERE     date(calledon) = fdate
             AND servicename = 'Get IView'
             AND serviceresult = 'success'
             AND (timetaken / 1000) > 8
GROUP BY date(calledon);


    DELETE FROM axpexception   WHERE date(exp_date)=fdate;

INSERT INTO axpexception(EXP_DATE,
                         STRUCTNAME,
                         SERVICENAME,
                         SERVICERESULT,
                         COUNT)
   SELECT date(calledon),
               structname,
               servicename,
               serviceresult,
               COUNT(*)
          FROM axpertlog
         WHERE SERVICERESULT <> 'success' AND date(calledon) = fdate
      GROUP BY date(calledon),
               structname,
               servicename,
               serviceresult;

  
    DELETE FROM ut_timetaken  WHERE DATE(executed_date)=fdate;

INSERT INTO ut_timetaken(executed_date,
                         object_type,
                         service_name,
                         object_name,
                         tot_count,
                         count_8s,
                         count_30s,
                         count_90s,
                         min_time,
                         max_time,
                         avg_time)
   SELECT curdate() exec_date,
               'tstruct' obj_type,
               'Saving Data' service_name,
               b.caption,
               COUNT(*) cnt,
               SUM(CASE WHEN timetaken > 8000 THEN 1 ELSE 0 END) cnt8,
               SUM(CASE WHEN timetaken > 30000 THEN 1 ELSE 0 END) cnt30,
               SUM(CASE WHEN timetaken > 90000 THEN 1 ELSE 0 END) cnt90,
               MIN(timetaken) / 1000 mintime,
               MAX(timetaken) / 1000 maxtime,
               AVG(timetaken) / 1000 avgtime
          FROM    axpertlog a
               JOIN
                  (  SELECT name, caption
                       FROM tstructs
                   GROUP BY name, caption) b
               ON a.structname = b.name
         WHERE     LOWER(servicename) = 'saving data'
               AND serviceresult = 'success'
               AND a.recordid = 0
               AND date(calledon) = fdate
      GROUP BY b.caption;

INSERT INTO ut_timetaken(executed_date,
                         object_type,
                         service_name,
                         object_name,
                         tot_count,
                         count_8s,
                         count_30s,
                         count_90s,
                         min_time,
                         max_time,
                         avg_time)
   SELECT curdate() exec_date,
               'tstruct' obj_type,
               'Load Data' service_name,
               b.caption,
               COUNT(*) cnt,
               SUM(CASE WHEN timetaken > 8000 THEN 1 ELSE 0 END) cnt8,
               SUM(CASE WHEN timetaken > 30000 THEN 1 ELSE 0 END) cnt30,
               SUM(CASE WHEN timetaken > 90000 THEN 1 ELSE 0 END) cnt90,
               MIN(timetaken) / 1000 mintime,
               MAX(timetaken) / 1000 maxtime,
               AVG(timetaken) / 1000 avgtime
          FROM    axpertlog a
               JOIN
                  (  SELECT name, caption
                       FROM tstructs
                   GROUP BY name, caption) b
               ON a.structname = b.name
         WHERE     LOWER(servicename) = 'load data'
               AND serviceresult = 'success'
               AND date(calledon) = fdate
      GROUP BY b.caption;

INSERT INTO ut_timetaken(executed_date,
                         object_type,
                         service_name,
                         object_name,
                         tot_count,
                         count_8s,
                         count_30s,
                         count_90s,
                         min_time,
                         max_time,
                         avg_time)
   SELECT curdate() exec_date,
               'tstruct' obj_type,
               'Load Report' service_name,
               b.caption,
               COUNT(*) cnt,
               SUM(CASE WHEN timetaken > 8000 THEN 1 ELSE 0 END) cnt8,
               SUM(CASE WHEN timetaken > 30000 THEN 1 ELSE 0 END) cnt30,
               SUM(CASE WHEN timetaken > 90000 THEN 1 ELSE 0 END) cnt90,
               MIN(timetaken) / 1000 mintime,
               MAX(timetaken) / 1000 maxtime,
               AVG(timetaken) / 1000 avgtime
          FROM    axpertlog a
               JOIN
                  (  SELECT name, caption
                       FROM iviews
                   GROUP BY name, caption) b
               ON a.structname = b.name
         WHERE     LOWER(servicename) = 'get iview'
               AND serviceresult = 'success'
               AND date(calledon) = fdate
      GROUP BY b.caption;
END;

CREATE TABLE ctrltable (txt varchar(100));

INSERT INTO ctrltable
VALUES ('a,b,c');

CREATE TEMPORARY TABLE numbers AS (
SELECT b.a a FROM (SELECT n0 + n1 + n2 + n3 + n4 + n5 AS a
   FROM (SELECT 0 AS n0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) AS z0
   CROSS JOIN (SELECT 0 AS n1 UNION SELECT 4 UNION SELECT 8 UNION SELECT 12) AS z1
   CROSS JOIN (SELECT 0 AS n2 UNION SELECT 16 UNION SELECT 32 UNION SELECT 48) AS z2
   CROSS JOIN (SELECT 0 AS n3 UNION SELECT 64 UNION SELECT 128 UNION SELECT 192) AS z3
   CROSS JOIN (SELECT 0 AS n4 UNION SELECT 256 UNION SELECT 512 UNION SELECT 768) AS z4
   CROSS JOIN (SELECT 0 AS n5 UNION SELECT 1024 UNION SELECT 2048 UNION SELECT 3072) AS z5) b
   WHERE b.a<>0
   ORDER BY 1;









CREATE PROCEDURE pro_emailformat(ptemplate    varchar(100),
                                 pkeyword     varchar(2000),
                                 ptype        varchar(1000),
                                 psendto      varchar(1000),
                                 psendcc      varchar(1000))
   BEGIN
      DECLARE v_subject    varchar(3500);
      DECLARE v_body       VARCHAR(3500);
      DECLARE v_sms        VARCHAR(3500);
      DECLARE v_count      INT(5);
      DECLARE v_keyword    VARCHAR(350);
      DECLARE v_keyvalue   VARCHAR(1000);
      DECLARE exit_loop    BOOLEAN;
      DECLARE vkeyword   VARCHAR(1000);
      DECLARE v_delimit    VARCHAR(1) DEFAULT '^';

    DECLARE keyword_cursor CURSOR FOR
   SELECT substring_index(substring_index( pkeyword, v_delimit, a),
    v_delimit,
    -1
  ) AS vval
FROM ctrltable
JOIN numbers
  ON char_length(pkeyword)
    - char_length(replace(pkeyword, v_delimit, ''))
    >= a - 1;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;

      SELECT count(*)
        INTO v_count
        FROM sendmsg
       WHERE lower(template) = lower(ptemplate);

      IF v_count = 1
      THEN
         SELECT MSGSUBJECT, MSGCONTENT, SMSMSG
           INTO v_subject, v_body, v_sms
           FROM sendmsg
          WHERE lower(template) = lower(ptemplate);

         OPEN keyword_cursor;

        keyword_loop:
         LOOP
            FETCH keyword_cursor   INTO vkeyword;

            SET v_keyword := SUBSTRing(vkeyword, 1, INSTR(vkeyword, '=') - 1);
            SET v_keyvalue := SUBSTRing(vkeyword, INSTR(vkeyword, '=') + 1);
            SET v_subject := REPLACE(v_subject, v_keyword, v_keyvalue);
            SET v_body := REPLACE(v_body, v_keyword, v_keyvalue);
            SET v_sms := REPLACE(v_sms, v_keyword, v_keyvalue);

            IF exit_loop
            THEN
               CLOSE keyword_cursor;

               LEAVE keyword_loop;
            END IF;
         END LOOP keyword_loop;

         IF ptype = 'S' AND is_number(psendto) = 1 AND length(psendto) = 10
         THEN
            INSERT INTO axsms(createdon,
                              mobileno,
                              msg,
                              STATUS)
            VALUES (curdate(),
                    psendto,
                    v_sms,
                    0);
         ELSEIF ptype = 'E'
         THEN
            INSERT INTO AXP_MAILJOBS(MAILTO,
                                     MAILCC,
                                     SUBJECT,
                                     BODY,
                                     ATTACHMENTS,
                                     IVIEWNAME,
                                     IVIEWPARAMS,
                                     STATUS,
                                     ERRORMESSAGE,
                                     SENTON,
                                     JOBDATE)
            VALUES (psendto,
                    psendcc,
                    v_subject,
                    v_body,
                    NULL,
                    NULL,
                    NULL,
                    0,
                    NULL,
                    NULL,
                    curdate());
         END IF;
      END IF;
   END;



--TRIGGER trg_AXPSCRIPTRUNNER
