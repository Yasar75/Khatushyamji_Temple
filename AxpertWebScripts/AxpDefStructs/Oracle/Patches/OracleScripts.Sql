CREATE TABLE AXP_MAILJOBS
(
  MAILTO             VARCHAR2(1000 BYTE),
  MAILCC             VARCHAR2(1000 BYTE),
  SUBJECT            VARCHAR2(1000 BYTE),
  BODY               CLOB,
  RECIPIENTCATEGORY  VARCHAR2(500 BYTE),
  ENQUIRYNO          VARCHAR2(30 BYTE),
  ATTACHMENTS        VARCHAR2(1000 BYTE),
  IVIEWNAME          VARCHAR2(10 BYTE),
  IVIEWPARAMS        VARCHAR2(500 BYTE),
  TRANSID            VARCHAR2(10 BYTE),
  RECORDID           NUMBER(16),
  STATUS             NUMBER(2),
  ERRORMESSAGE       VARCHAR2(500 BYTE),
  SENTON             DATE,
  JOBID              NUMBER(15)
);

ALTER TABLE AXP_MAILJOBS
ADD ( jobdate DATE);

CREATE SEQUENCE AXP_MAILJOBSID
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;

CREATE OR REPLACE TRIGGER TRG_axpmailjobs
BEFORE INSERT ON AXP_MAILJOBS REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare
v_sid number(15);
BEGIN

select AXP_MAILJOBSID.nextval into v_sid from dual;

:NEW.jobid := v_sid;

END;
/

drop table AXUSRHISTORY;

CREATE TABLE AXUSRHISTORY
(
  RECORDID       NUMBER(16),
  MODIFIEDDATE   DATE,
  USERNAME       VARCHAR2(30 BYTE),
  FIELDNAME      VARCHAR2(30 BYTE),
  OLDVALUE       VARCHAR2(250 BYTE),
  NEWVALUE       VARCHAR2(250 BYTE),
  ROWNO          NUMBER(38),
  DELFLAG        VARCHAR2(1 BYTE),
  MODNO          NUMBER(10),
  FRAMENO        NUMBER(10),
  PARENTROW      NUMBER(10),
  TABLERECID     NUMBER(16),
  IDVALUE        NUMBER(16),
  OLDIDVALUE     NUMBER(16),
  TRANSDELETED   VARCHAR2(5 BYTE),
  NEWTRANS       VARCHAR2(5 BYTE),
  CANCELTRANS    VARCHAR2(1 BYTE),
  CANCELREMARKS  VARCHAR2(250 BYTE)
);


CREATE TABLE USAGEDTL
(
  EXECUTEDDATE  DATE,
  CODE          VARCHAR2(20 BYTE),
  TITLE         VARCHAR2(50 BYTE),
  CNT           NUMBER(18)
);

CREATE TABLE AXPEXCEPTION
(
  EXP_DATE       DATE,
  STRUCTNAME     VARCHAR2(16 BYTE),
  SERVICENAME    VARCHAR2(50 BYTE),
  SERVICERESULT  VARCHAR2(500 BYTE),
  COUNT          NUMBER
);

CREATE TABLE ut_timetaken
(
   executed_date   DATE,
   object_type     VARCHAR2 (10),
   service_name    VARCHAR2 (100),
   object_name     VARCHAR2 (100),
   tot_count       NUMBER (10),
   count_8s        NUMBER (10),
   count_30s       NUMBER (10),
   count_90s       NUMBER (10),
   min_time        NUMBER (10, 2),
   max_time        NUMBER (10, 2),
   avg_time        NUMBER (10, 2)
);

DROP TABLE AXCONSTRAINTS CASCADE CONSTRAINTS;

CREATE TABLE AXCONSTRAINTS
(
  AXCONSTRAINTSID  INTEGER,
  CANCEL           CHAR(1 BYTE),
  SOURCEID         INTEGER,
  MAPNAME          VARCHAR2(20 BYTE),
  USERNAME         VARCHAR2(50 BYTE),
  MODIFIEDON       DATE,
  CREATEDBY        VARCHAR2(50 BYTE),
  CREATEDON        DATE,
  WKID             VARCHAR2(15 BYTE),
  APP_LEVEL        NUMBER(3),
  APP_DESC         NUMBER(1),
  APP_SLEVEL       NUMBER(3),
  CANCELREMARKS    VARCHAR2(150 BYTE),
  WFROLES          VARCHAR2(250 BYTE),
  CONSTRAINT_NAME  VARCHAR2(50 BYTE),
  MSG              VARCHAR2(1000 BYTE)
);

ALTER TABLE axusergroups 
ADD (axusergroupsid NUMBER(15));

ALTER TABLE AXUSERGROUPS
ADD (cancel VARCHAR2(10 BYTE));

ALTER TABLE AXUSERGROUPS
ADD (sourceid number(15));

ALTER TABLE AXUSERGROUPS
ADD (cancelremarks VARCHAR2(150 BYTE));

ALTER TABLE AXUSERLEVELGROUPS
ADD (axusersid NUMBER(15));


ALTER TABLE AXUSERLEVELGROUPS
ADD (axuserlevelgroupsid NUMBER(15));

CREATE OR REPLACE TRIGGER TRG_axuserlevelgroups
BEFORE INSERT OR UPDATE ON  axuserlevelgroups
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
IF INSERTING THEN
:NEW.axUSERNAME := :NEW.USERNAME;
:NEW.axusergroup := :NEW.usergroup;
END IF; 
IF UPDATING THEN
:NEW.axUSERNAME := :NEW.USERNAME;
:NEW.axusergroup := :NEW.usergroup;
END IF;
END;
/


update  axuserlevelgroups 
set axusersid=1,AXUSERLEVELGROUPSID=12345555  where username='admin' ;
commit;

ALTER TABLE AXUSERS
ADD (cancelremarks VARCHAR2(300 BYTE));

ALTER TABLE AXUSERS
ADD (axusersid number(15));

ALTER TABLE AXUSERS
ADD (cancel VARCHAR2(10 BYTE));


ALTER TABLE AXUSERS
ADD (sourceid number(15));

alter table axusers modify pwd varchar(20);

update axusers set axusersid=1,pusername=username,ppassword=password where username='admin';
commit;

CREATE OR REPLACE TRIGGER TRG_AXUSERS
BEFORE INSERT OR UPDATE ON AXUSERS 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
IF INSERTING THEN
:NEW.USERNAME := :NEW.PUSERNAME;
:NEW.PASSWORD := :NEW.PPASSWORD;
END IF; 
IF UPDATING THEN
:NEW.USERNAME := :NEW.PUSERNAME;
END IF;
END;
/


ALTER TABLE axsms ADD (createdon date);

CREATE SEQUENCE AXsmsID
START WITH 1
INCREMENT BY 1
MINVALUE 0
NOCACHE 
NOCYCLE 
NOORDER ;

CREATE OR REPLACE TRIGGER TRG_axsms
BEFORE INSERT ON AXSMS REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare
v_sid number(15);
BEGIN

select AXsmsID.nextval  into v_sid from dual;

:NEW.RECORDID :=  v_sid;

END;
/




CREATE OR REPLACE FORCE VIEW AX_OUTBOUND_STATUS
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
          TO_DATE (a.senton) senton,
          TO_DATE (a.senton) outdate,
          a.transid,
          b.caption tstructname,
          CASE WHEN senton IS NULL THEN 'Pending' ELSE 'Sent' END outstatus
     FROM outbound a, tstructs b
    WHERE a.transid = b.name;

CREATE OR REPLACE FORCE VIEW AX_INBOUND_STATUS
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
          TO_DATE (a.recdon) recdon,
          TO_DATE (recdon) indate,
          transid,
          caption tstructname,
          instatus
     FROM inbound a, tstructs b
    WHERE a.transid = b.name;
CREATE OR REPLACE FUNCTION JOIN_COMMA (p_cursor sys_refcursor, p_del varchar2 := ',' )
return varchar2
is
    l_value   varchar2(32767);
    l_result  varchar2(32767);
begin
    loop
        fetch p_cursor into l_value;
        exit when p_cursor%notfound;
        if l_result is not null then
            l_result := l_result || p_del;
        end if;
        l_result := l_result || l_value;
    end loop;
    return l_result;
end;
/

CREATE OR REPLACE FUNCTION is_number(p_value VARCHAR2)
RETURN NUMBER
AS
v_num NUMBER;
BEGIN
v_num:=TO_NUMBER(p_value);
RETURN 1;
EXCEPTION
WHEN OTHERS THEN
RETURN 0;
END;
/

CREATE OR REPLACE FUNCTION random_number
   RETURN NUMBER
IS
   v_num   NUMBER (15);
BEGIN
   SELECT ROUND (DBMS_RANDOM.VALUE (1111111, 9999999))
          || TO_CHAR (SYSDATE, 'DDDSSSSS')
             AS rno
     INTO v_num
     FROM DUAL;

   RETURN v_num;
END;
/


------ axpertlog analysis report
CREATE OR REPLACE PROCEDURE pro_axplogstatextract (fdate DATE)
AS
BEGIN
   ------ usage details
   delete from usagedtl  where trunc(executeddate)=trunc(fdate);
   INSERT INTO usagedtl (executeddate,
                         code,
                         title,
                         cnt)
        SELECT TO_DATE (calledon) cdate,
               'NOT' CODE,
               'Total No. of Transactions' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE TO_DATE (calledon) = TRUNC (fdate)
      GROUP BY TO_DATE (calledon)
      UNION ALL
        SELECT TO_DATE (calledon) cdate,
               'NOL' CODE,
               'Total No. of Logins' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE TO_DATE (calledon) = TRUNC (fdate) AND servicename = 'Login'
      GROUP BY TO_DATE (calledon)
      UNION ALL
        SELECT TO_DATE (calledon) cdate,
               'NOU' CODE,
               'Total No. of Users' title,
               COUNT (DISTINCT username) cnt
          FROM axpertlog
         WHERE TO_DATE (calledon) = TRUNC (fdate) AND servicename = 'Login'
      GROUP BY TO_DATE (calledon)
      UNION ALL
        SELECT TO_DATE (calledon) cdate,
               'NOD' CODE,
               'Total No. of Deadlock Execptions' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE TO_DATE (calledon) = TRUNC (fdate)
               AND serviceresult LIKE 'trans%dead%'
      GROUP BY TO_DATE (calledon)
      UNION ALL
        SELECT TO_DATE (calledon) cdate,
               'MTJ' CODE,
               'More time taken Saves (> 8 Sec)' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE     TO_DATE (calledon) = TRUNC (fdate)
               AND servicename = 'saving data'
               AND serviceresult = 'success'
               AND recordid = 0
               AND (timetaken / 1000) > 8
      GROUP BY TO_DATE (calledon)
      UNION ALL
        SELECT TO_DATE (calledon) cdate,
               'MTL' CODE,
               'More time taken Loads (> 8 Sec)' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE     TO_DATE (calledon) = TRUNC (fdate)
               AND servicename = 'load data'
               AND serviceresult = 'success'
               AND (timetaken / 1000) > 8
      GROUP BY TO_DATE (calledon)
      UNION ALL
      SELECT TO_DATE (calledon) cdate,
             'MTL' CODE,
             'More time taken reports (> 8 Sec)' title,
             COUNT (*) cnt
        FROM axpertlog
       WHERE     TO_DATE (calledon) = TRUNC (fdate)
             AND servicename = 'Get IView'
             AND serviceresult = 'success'
             AND (timetaken / 1000) > 8
GROUP BY TO_DATE (calledon);

   ----- exceptions
    delete from axpexception   where trunc(exp_date)=trunc(fdate);
   INSERT INTO axpexception (EXP_DATE,
                             STRUCTNAME,
                             SERVICENAME,
                             SERVICERESULT,
                             COUNT)
        SELECT TRUNC (calledon),
               structname,
               servicename,
               serviceresult,
               COUNT (*)
          FROM axpertlog
         WHERE SERVICERESULT <> 'success' AND TRUNC (calledon) = TRUNC (fdate)
      GROUP BY TRUNC (calledon),
               structname,
               servicename,
               serviceresult;

   ----- time taken
    delete from ut_timetaken  where trunc(executed_date)=trunc(fdate);
   INSERT INTO ut_timetaken (executed_date,
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
        SELECT TO_DATE (SYSDATE) exec_date,
               'tstruct' obj_type,
               'Saving Data' service_name,
               b.caption,
               COUNT (*) cnt,
               SUM (CASE WHEN timetaken > 8000 THEN 1 ELSE 0 END) cnt8,
               SUM (CASE WHEN timetaken > 30000 THEN 1 ELSE 0 END) cnt30,
               SUM (CASE WHEN timetaken > 90000 THEN 1 ELSE 0 END) cnt90,
               MIN (timetaken) / 1000 mintime,
               MAX (timetaken) / 1000 maxtime,
               AVG (timetaken) / 1000 avgtime
          FROM    axpertlog a
               JOIN
                  (  SELECT name, caption
                       FROM tstructs
                   GROUP BY name, caption) b
               ON a.structname = b.name
         WHERE     LOWER (servicename) = 'saving data'
               AND serviceresult = 'success'
               AND a.recordid = 0
               AND TO_DATE (calledon) = TO_DATE (fdate)
      GROUP BY b.caption;

   INSERT INTO ut_timetaken (executed_date,
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
        SELECT TO_DATE (SYSDATE) exec_date,
               'tstruct' obj_type,
               'Load Data' service_name,
               b.caption,
               COUNT (*) cnt,
               SUM (CASE WHEN timetaken > 8000 THEN 1 ELSE 0 END) cnt8,
               SUM (CASE WHEN timetaken > 30000 THEN 1 ELSE 0 END) cnt30,
               SUM (CASE WHEN timetaken > 90000 THEN 1 ELSE 0 END) cnt90,
               MIN (timetaken) / 1000 mintime,
               MAX (timetaken) / 1000 maxtime,
               AVG (timetaken) / 1000 avgtime
          FROM    axpertlog a
               JOIN
                  (  SELECT name, caption
                       FROM tstructs
                   GROUP BY name, caption) b
               ON a.structname = b.name
         WHERE     LOWER (servicename) = 'load data'
               AND serviceresult = 'success'
               AND TO_DATE (calledon) = TO_DATE (fdate)
      GROUP BY b.caption;

   INSERT INTO ut_timetaken (executed_date,
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
        SELECT TO_DATE (SYSDATE) exec_date,
               'tstruct' obj_type,
               'Load Report' service_name,
               b.caption,
               COUNT (*) cnt,
               SUM (CASE WHEN timetaken > 8000 THEN 1 ELSE 0 END) cnt8,
               SUM (CASE WHEN timetaken > 30000 THEN 1 ELSE 0 END) cnt30,
               SUM (CASE WHEN timetaken > 90000 THEN 1 ELSE 0 END) cnt90,
               MIN (timetaken) / 1000 mintime,
               MAX (timetaken) / 1000 maxtime,
               AVG (timetaken) / 1000 avgtime
          FROM    axpertlog a
               JOIN
                  (  SELECT name, caption
                       FROM iviews
                   GROUP BY name, caption) b
               ON a.structname = b.name
         WHERE     LOWER (servicename) = 'get iview'
               AND serviceresult = 'success'
               AND TO_DATE (calledon) = TO_DATE (fdate)
      GROUP BY b.caption;

   COMMIT;
END;
/

---- email format

/* Formatted on 17/11/2015 6:20:22 PM (QP5 v5.139.911.3011) */
CREATE OR REPLACE PROCEDURE pro_emailformat(ptemplate varchar ,pkeyword varchar,ptype varchar,psendto varchar,psendcc varchar ) is
/*
Parameters
Ptemplate- this is email configuration table ( sendmsg) template name
pkeyword- keywords should be matched with the equalant value, keywords and value should be delimitted with ',' (comma) and keywords are case sensitive for eg., '<username>=Ashok,<pwd>=12345'
ptype-E for email and S for SMS
*/
v_subject varchar2(3500);
v_body varchar2(3500);
v_sms  varchar2(3500);
v_count number(5);
v_keyword varchar2(350);
v_keyvalue varchar2(1000);

begin

select count(*) into v_count from  sendmsg
 where lower(template) = lower( ptemplate);
 
if v_count=1 then
 
 select MSGSUBJECT,MSGCONTENT,SMSMSG into v_subject,v_body,v_sms from sendmsg
 where lower(template) = lower( ptemplate);
 
for i in ( select regexp_substr(pkeyword,'[^,]+', 1, level) as vkeyword from dual
    connect by regexp_substr(pkeyword, '[^,]+', 1, level) is not null )
loop

v_keyword := SUBSTR(i.vkeyword, 1 ,INSTR(i.vkeyword, '=', 1, 1)-1);

v_keyvalue :=  SUBSTR( i.vkeyword, INSTR( i.vkeyword,'=', 1, 1)+1);

v_subject := replace(v_subject,v_keyword,v_keyvalue);

v_body := replace(v_body,v_keyword,v_keyvalue);

v_sms := replace(v_sms,v_keyword,v_keyvalue);
end loop;

if ptype='S' then

insert into axsms(createdon,mobileno,msg,status) values ( sysdate,psendto,v_sms,0);

elsif ptype='E' then

INSERT INTO AXP_MAILJOBS (MAILTO,
                          MAILCC,
                          SUBJECT,
                          BODY,
                          ATTACHMENTS,
                          IVIEWNAME,
                          IVIEWPARAMS,
                          STATUS,
                          ERRORMESSAGE,
                          SENTON,JOBDATE)
     VALUES (psendto,psendcc,v_subject ,v_body,null,null,null,0,null,null,sysdate);



end if;
end if;
end ;
/

-- script runner

CREATE OR REPLACE procedure pr_bulkexecute(pintext  varchar,pintrg varchar)
AUTHID CURRENT_USER IS
v_rowcount number(15) :=0;
v_trgdis varchar2(500)  := 'ALTER TRIGGER '||pintrg||'  DISABLE';
v_trgena varchar2(500) := 'ALTER TRIGGER '||pintrg||'  ENABLE';
begin

if pintrg = 'NA' then
  EXECUTE immediate pintext;
else
  EXECUTE immediate v_trgdis;
  EXECUTE immediate pintext;
  EXECUTE immediate v_trgena;
end if;
  Commit;
end;
/


ALTER TABLE AXPEXCHANGE
ADD (axpexchangeid NUMBER(15));


ALTER TABLE AXINTELLIVIEWDET
ADD (axintelliviewdetid NUMBER(15));

SET DEFINE OFF;

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

COMMIT;


CREATE OR REPLACE TRIGGER trg_AXPSCRIPTRUNNER
  after INSERT
   ON AXPSCRIPTRUNNER    FOR EACH ROW
DECLARE
   v_trg varchar2(100) := nvl( :new.trg_name, 'NA');
   PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
pr_bulkexecute( :new.SCRIPT_TEXT,v_trg);
   COMMIT;
END;
/

CREATE OR REPLACE TRIGGER TRG_UPDATDSIGN 
BEFORE INSERT OR UPDATE ON AXDSIGNCONFIG REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
IF INSERTING THEN
:NEW.USERNAME := :NEW.PUSERNAME; 
 :new.rolename := :new.prolename;
END IF;
IF UPDATING THEN
:NEW.USERNAME := :NEW.PUSERNAME;
:new.rolename := :new.prolename;
END IF;
END;
/


DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'PRO_AXPLOGSTATEXTRACT
  (trunc(sysdate) /* DATE */  );'
   ,next_date =>TRUNC(SYSDATE)+22/24
   ,interval  => 'TRUNC(SYSDATE+1)+22/24'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/






