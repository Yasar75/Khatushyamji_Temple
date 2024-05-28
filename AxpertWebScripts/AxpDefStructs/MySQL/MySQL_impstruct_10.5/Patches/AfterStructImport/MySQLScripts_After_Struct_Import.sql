<<
create unique index  ui_AXCTX1 on AXCTX1 (axcontext,atype)
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Autosplit')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Disablesplit')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Navigation')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'FetchSize')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'General')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Text')
>>
 <<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Lds')
>>
<<
 Insert into AXCTX1
   (AXCONTEXT, ATYPE)
 Values
   ('GridEdit', 'Property')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
Values
   (1040440000000, 'F', 0, 'admin',
    CURDATE(), 'admin', CURDATE(), 1,
    1, 'Tstruct Grid edit option',
    'GridEdit', 'configtypeTstruct Grid edit option', 'Tstruct', 'F', 'F', 'T', 'F') 
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000003, 'F', 0, 'admin',CURDATE(), 'admin', CURDATE(), 1, 1, 'Load forms along with list', 'configtypeLoad forms along with list', 'Autosplit', 'Tstruct', 'F', 'F', 'T', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000006, 'F', 0, 'admin',CURDATE(), 'admin', CURDATE(), 1, 1, 'Load reports/lists along with form', 'configtypeLoad reports/lists along with form', 'Autosplit', 'Iview', 'F', 'F', 'F', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000009, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Disablesplit', 'configtypeDisablesplit', 'Disablesplit', 'All', 'F', 'F', 'T', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000012, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Open Window mode', 'configtypeOpen Window mode', 'Navigation', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
Values(1000550000015, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Align Text', 'configtypeAlign Text','Text', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
Values(1000550000018, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Main Page Reload', 'configtypeMain Page Reload','General', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
Values(1000550000021, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Change Password', 'configtypeChange Password','General', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
Values(1000550000024, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Landing Structure', 'configtypeLanding Structure','General', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
Values(1000550000027, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'FetchSize', 'configtypeFetchSize', 'FetchSize', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
Values(1000550000030, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Local Dataset', 'configtypeLocal Dataset', 'Lds', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000004, 1000550000003, 1, 'True')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000005, 1000550000003, 2, 'False')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000007, 1000550000006, 1, 'True')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000008, 1000550000006, 2, 'False')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000010, 1000550000009, 1, 'True')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000011, 1000550000009, 2, 'False')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000013, 1000550000012, 1, 'Default')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000014, 1000550000012, 2, 'Popup')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000015, 1000550000012, 3, 'Newpage')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL(AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values(1000550000016, 1000550000012, 4,'Split')
>>
<< insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)  Values (1742550000003, 1742550000002, 1, 'Disable')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)Values  (1742550000004, 1742550000002, 2, 'Enable')
   >>
<< 
 insert into AXPSTRUCTCONFIGPROVAL (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000007, 1742550000005, 2, 'iview')
   >>
<<
insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000006, 1742550000005, 1, 'tstruct')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000010, 1742550000008, 2, '30')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000028, 1742550000008, 20, '5000')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000027, 1742550000008, 19, '2000')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000026, 1742550000008, 18, '1000')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000009, 1742550000008, 1, '25')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000029, 1742550000008, 21, 'ALL')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000011, 1742550000008, 3, '35')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000012, 1742550000008, 4, '40')
   >>
<<
 insert  into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000013, 1742550000008, 5, '45')
   >>
<<
 insert  into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000014, 1742550000008, 6, '50')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000015, 1742550000008, 7, '55')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1742550000016, 1742550000008, 8, '60')
   >>
<< 
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000017, 1742550000008, 9, '65')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000018, 1742550000008, 10, '70')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000019, 1742550000008, 11, '75')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000020, 1742550000008, 12, '80')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000021, 1742550000008, 13, '85')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000022, 1742550000008, 14, '90')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000023, 1742550000008, 15, '95')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000024, 1742550000008, 16, '100')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000025, 1742550000008, 17, '500')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1751880000001, 1751880000000, 1, 'true')
   >>
<< 
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1751880000002, 1751880000000, 2, 'false')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1903990000001, 1903990000000, 1, 'Right')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1903990000002, 1903990000000, 2, 'Left')
   >> 
   << 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1790770000001, 1790770000000, 1, 'true')>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1790770000002, 1790770000000, 2, 'false')
   >>
<< 
Insert into axpstructconfigproval (AXPSTRUCTCONFIGPROVALID,AXPSTRUCTCONFIGPROPSID,AXPSTRUCTCONFIGPROVALROW,CONFIGVALUES) values (1040440000001,1040440000000,1,'Inline')
>>
<< 
Insert into axpstructconfigproval (AXPSTRUCTCONFIGPROVALID,AXPSTRUCTCONFIGPROPSID,AXPSTRUCTCONFIGPROVALROW,CONFIGVALUES) values (1040440000002,1040440000000,2,'Popup')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIviaxpscon', 'Axpstruct Configuration', '<root visible="T" type="p" defpage="T" name="PageIviaxpscon" caption="Axpstruct Configuration" createdon="04/12/2018 15:28:54" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="19/12/2018 15:17:54" updatedby="admin" img="" ordno="114" levelno="0" parent="" pgtype="iiaxpscon" updusername="" ptype="p" dbtype="oracle"><Container388 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__iaxpscon"/><view__iaxpscon cat="iview" name="iaxpscon" parent="Container388" align="Client"/></root>', 1, 
    'F', 'p', '', 30, 2, 
    '19/12/2018 15:17:54', '04/12/2018 15:28:54', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'iiaxpscon')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsastcp', 'Configuration Property', '<root visible="T" type="p" defpage="T" name="PageTsastcp" caption="Configuration Property" createdon="04/12/2018 13:19:32" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="18/12/2018 15:43:36" updatedby="admin" img="" ordno="112" levelno="0" parent="" updusername="" ptype="p" pgtype="tastcp" dbtype="oracle"><Container386 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__astcp"/><tstruct__astcp cat="tstruct" transid="astcp" parent="Container386" align="Client"/></root>', 1, 
    'F', 'p', '', 31, 2, 
    '18/12/2018 15:43:36', '04/12/2018 13:19:32', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'tastcp')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsaxstc', 'Advance Settings', '<root visible="T" type="p" defpage="T" name="PageTsaxstc" caption="Advance Settings" createdon="04/12/2018 13:36:37" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="18/12/2018 18:36:55" updatedby="admin" img="" ordno="113" levelno="0" parent="" updusername="" ptype="p" pgtype="taxstc" dbtype="oracle"><Container387 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__axstc"/><tstruct__axstc cat="tstruct" transid="axstc" parent="Container387" align="Client"/></root>', 1, 
    'F', 'p', '', 32, 2, 
    '18/12/2018 18:36:55', '04/12/2018 13:36:37', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'taxstc')
>>
 <<
 CREATE TABLE AXP_APPSEARCH_DATA_V2
(
  HLTYPE      VARCHAR(10),
  STRUCTNAME  VARCHAR(25),
  SEARCHTEXT  VARCHAR(200),
  PARAMS      VARCHAR(150),
  CREATEDON   datetime Default Now(),
  DOCID       VARCHAR(50)
)  
>>
<<
CREATE UNIQUE INDEX UI_AXP_APPSEARCH_DATA_V2 ON AXP_APPSEARCH_DATA_V2 (HLTYPE, STRUCTNAME, PARAMS) 
>>
<<
CREATE TRIGGER axp_tr_search_appsearch1
before insert ON AXP_APPSEARCH_DATA_PERIOD for each row
begin 
Declare SERR  int(1) ;
DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET SERR = 1;
   
if new.periodically ='T' or new.srctable is  null or new.srcfield is  null then

insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(new.hltype,new.structname, case when new.periodically ='T' then new.searchtext else  new.caption end ,new.params,new.docid);

if SERR =1 then       
      update axp_appsearch_data_v2 set  hltype= new.hltype , structname = new.structname,searchtext = case when new.periodically ='T' then new.searchtext else  new.caption end  ,params= new.params where docid= new.docid;
 End If;
 
 End If;

End;
>>
<<
CREATE TRIGGER axp_tr_search_appsearch2
before update ON AXP_APPSEARCH_DATA_PERIOD for each row
begin 
Declare SERR  int(1) ;
DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET SERR = 1;
   
if new.periodically ='T' or new.srctable is  null or new.srcfield is  null then

insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(old.hltype,old.structname, case when old.periodically ='T' then old.searchtext else  old.caption end ,old.params,old.docid);

if SERR =1 then       
      update axp_appsearch_data_v2 set  hltype= new.hltype , structname = new.structname,searchtext = case when new.periodically ='T' then new.searchtext else  new.caption end  ,params= new.params where docid= old.docid;
 End If;
 
 End If;
End;
>>
<<
CREATE TRIGGER axp_tr_search_appsearch3
before delete ON AXP_APPSEARCH_DATA_PERIOD for each row
begin 
   
if old.periodically ='T' or old.srctable is  null or old.srcfield is  null then

delete from axp_appsearch_data_v2 where docid = old.docid;
 
 End If;

End;
>>
<<
CREATE VIEW AXP_VW_MENU
(
   MENUPATH,
   CAPTION,
   NAME,
   ORDNO,
   LEVELNO,
   PARENT,
   TYPE,
   PAGETYPE,
   VISIBLE
)
AS
     SELECT '' menupath,
            caption,
            name,
            ordno,
            levelno,
            parent,
            TYPE,
            pagetype,
            visible
       FROM axpages
                  WHERE blobno = 1
   ORDER BY ordno
>>
<<
drop view AXP_APPSEARCH_DATA
>>
<<
CREATE TABLE AXP_APPSEARCH_DATA
(
  CANCEL                CHAR(1),
  SOURCEID              INTEGER,
  MAPNAME               VARCHAR(20),
  USERNAME              VARCHAR(50),
  MODIFIEDON            DATE,
  CREATEDBY             VARCHAR(50),
  CREATEDON             DATE,
  WKID                  VARCHAR(15),
  APP_LEVEL             NUMERIC(3),
  APP_DESC              NUMERIC(1),
  APP_SLEVEL            NUMERIC(3),
  CANCELREMARKS         VARCHAR(150),
  WFROLES               VARCHAR(250),
  HLTYPE                VARCHAR(10),
  STRUCTNAME            VARCHAR(50),
  SEARCHTEXT            VARCHAR(500),
  PARAMS                VARCHAR(500),
  AXP_APPSEARCH_DATAID  NUMERIC(16)
)
>>
<<
CREATE VIEW AXP_APPSEARCH_DATA_NEW
(
   SLNO,
   HLTYPE,
   STRUCTNAME,
   SEARCHTEXT,
   PARAMS
)
AS
SELECT 2 AS slno,
          hltype,
          structname,
          REPLACE (searchtext, 'View', ' ') AS searchtext,
          params
     FROM axp_appsearch_data_v2
    WHERE LOWER (PARAMS) NOT LIKE '%sysdate%'  
   UNION ALL
   SELECT 2,
          hltype,
          structname,
          TRIM(REPLACE (searchtext, 'View', ' ')) AS searchtext,
          REPLACE (
             REPLACE (
                REPLACE (
                   REPLACE (
                      REPLACE (
                         REPLACE (
                            REPLACE (
                               REPLACE (
                                  REPLACE (
                                     PARAMS,
                                     'trunc(add_months(sysdate,0-1),''MM'')',
                                     trim(DATE_FORMAT((date(date_add(now(),INTERVAL 0-1 month)) - interval day(date_add(now(),INTERVAL 0-1 month)) day + interval 1 day), '%d/%m/%Y'))),
                                  'last_day(add_months(trunc(sysdate),0-1))',
                                 trim(DATE_FORMAT(last_day(date(date_add(now(),INTERVAL 0-1 month)) - interval day(date_add(now(),INTERVAL 0-1 month)) day + interval 1 day),'%d/%m/%Y'))),
                               'trunc(sysdate)-1',
                               Trim(DATE_FORMAT(date(DATE_SUB(now(),INTERVAL 1 day)),'%d/%m/%Y'))),
                            'trunc(sysdate)',
                            Trim(DATE_FORMAT(date(now()),'%d/%m/%Y'))),
                         'trunc(sysdate,''IW'')',
                         Trim(DATE_FORMAT(date((now() - INTERVAL WEEKDAY(now())Day)),'%d/%m/%Y'))),
                      'trunc(sysdate-7,''IW'')+6',
                      TRIM(DATE_FORMAT(date(date_add(date_sub(now(),INTERVAL 7 day) - INTERVAL WEEKDAY(now())Day ,INTERVAL 6 day)),'%d/%m/%Y'))),
                   'trunc(sysdate-7,''IW'')',
                   TRIM(DATE_FORMAT(date(date_sub(now(),INTERVAL 7 day) - INTERVAL WEEKDAY(now())Day),'%d/%m/%Y'))),
                'trunc(sysdate,''MM'')',
                Trim(DATE_FORMAT(date(DATE_ADD(DATE_ADD(LAST_DAY(now()),INTERVAL 1 DAY),INTERVAL - 1 MONTH)),'%d/%m/%Y'))),
                ' &','&')
             AS params
     FROM axp_appsearch_data_v2
    WHERE LOWER (PARAMS) LIKE '%sysdate%'
    UNION ALL   
   SELECT 1 AS ord,
          'tstruct' AS hltype,
          t.name AS structname,
          t.caption AS searchtext,
          NULL params
     FROM tstructs t
    WHERE t.blobno = 1
          AND EXISTS
                 (SELECT 'x'
                    FROM axp_vw_menu x
                   WHERE     x.pagetype LIKE 't%'
                         AND  (SUBSTRING(trim(x.pagetype), 2, 20)) = t.name
                         AND x.visible NOT LIKE '%F%')                                    
   UNION ALL      
   SELECT 0 AS ord,
          'iview' AS hltype,
          i.name AS structname,
          i.caption AS searchtext,
          NULL params
     FROM iviews i
    WHERE i.blobno = 1
          AND EXISTS
                 (SELECT 'x'
                    FROM axp_vw_menu x
                   WHERE     x.pagetype LIKE 'i%'
                         AND  (SUBSTRING(trim(x.pagetype), 2, 20)) = i.name
                         AND x.visible NOT LIKE '%F%')
                         
   ORDER BY 1
   >>
   <<
CREATE VIEW AXP_APPSEARCH
(
   SEARCHTEXT,
   PARAMS,
   HLTYPE,
   STRUCTNAME,
   USERNAME
)
AS
   SELECT distinct SEARCHTEXT,
                 concat(a.params,(case when ((a.params is not null) and (not((lower(a.params) like '%~act%')))) then '~act=load' else NULL end)) AS PARAMS,
                 HLTYPE,
                 STRUCTNAME,
                 USERNAME
     FROM (  SELECT s.slno,
                    s.searchtext,
                    s.params,
                    s.hltype,
                    s.structname,
                    lg.username
               FROM axp_appsearch_data_new s,
                    axuseraccess a,
                    axusergroups g,
                    axuserlevelgroups lg
              WHERE     a.sname = s.structname
                    AND a.rname = g.userroles
                    AND g.groupname = lg.usergroup
                    AND a.stype IN ('t', 'i')
           GROUP BY s.searchtext,
                    s.params,
                    s.hltype,
                    s.structname,
                    lg.username,
                    s.slno
           UNION
           SELECT b.slno,
                  b.searchtext,
                  b.params,
                  b.hltype,
                  b.structname,
                  lg.username
             FROM axuserlevelgroups lg,
                  (SELECT DISTINCT s.searchtext,
                                   s.params,
                                   s.hltype,
                                   s.structname,
                                   s.slno
                     FROM axp_appsearch_data_new s left join axuseraccess a on a.sname = s.structname AND a.stype IN ('t', 'i')) b
            WHERE lg.usergroup = 'default'
           ORDER BY slno, username) a
 >>
<<
Insert into AXCTX1
   (AXCONTEXT, ATYPE)
 Values
   ('FormLoad', 'Property')
>>
<<
alter table AXPSTRUCTCONFIGPROPS add ALLUSERROLES varchar(100) 
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1104220000000, 'F', 0, 'admin', 
    CURDATE(), 'admin', CURDATE(), 1, 
    1, 'FormLoad Cache', 
    'FormLoad', 'configtypeFormLoad Cache', 'Tstruct', 'F', 'F', 'T', 'F', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1104220000001, 1104220000000, 1, '30 min')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1104220000002, 1104220000000, 2, '1 hour')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1104220000003, 1104220000000, 3, '2 hour')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1104220000004, 1104220000000, 4, '5 hour')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1104220000005, 1104220000000, 5, '10 hour')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1104220000006, 1104220000000, 6, 'None')
>>