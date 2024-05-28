<<
alter table axpstructconfig add purpose varchar2(1000)
>>
<<
ALTER TABLE AXUSERS ADD (cancelremarks VARCHAR2(300 BYTE))
>>
<<
ALTER TABLE AXUSERS ADD (axusersid number(15))
>>
<<
ALTER TABLE AXUSERS ADD (cancel VARCHAR2(10 BYTE))
>>
<<
alter table ax_widget add is_public varchar2(1) DEFAULT 'N'
>>
<<
ALTER TABLE AXUSERS ADD (sourceid number(15))
>>
<<
alter table axusers modify pwd varchar(20)
>>
<<
ALTER TABLE axusergroups ADD (axusergroupsid NUMBER(15))
>>
<<
ALTER TABLE AXUSERGROUPS ADD (cancel VARCHAR2(10 BYTE))
>>
<<
ALTER TABLE AXUSERGROUPS ADD (sourceid number(15))
>>
<<
ALTER TABLE AXUSERGROUPS ADD (cancelremarks VARCHAR2(150 BYTE))
>>
<<
ALTER TABLE AXUSERLEVELGROUPS ADD (axusersid NUMBER(15))
>>
<<
ALTER TABLE AXUSERLEVELGROUPS ADD (axuserlevelgroupsid NUMBER(15))
>>
<<
ALTER TABLE  AXDSIGNCONFIG add rolename varchar2(60)
>>
<<
update axuserlevelgroups set axusersid=1,AXUSERLEVELGROUPSID=12345555  where username='admin' 
>>
<<
update axusers set axusersid=1,pusername=username,ppassword=password where username='admin'
>>
<<
update  axuserlevelgroups set axusername='admin',axusergroup='default'  where AXUSERLEVELGROUPSID=12345555
>>
<<
CREATE OR REPLACE TRIGGER TRG_axuserlevelgroups
   BEFORE INSERT OR UPDATE
   ON axuserlevelgroups
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
BEGIN
   IF INSERTING
   THEN
      :NEW.USERNAME  := :NEW.axUSERNAME ;
     :NEW.usergroup :=  :NEW.axusergroup ;
   END IF;

   IF UPDATING
   THEN
    :NEW.USERNAME  := :NEW.axUSERNAME ;
     :NEW.usergroup :=  :NEW.axusergroup ;
   END IF;
END;
>>
<<
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
>>
<<
DROP TABLE AXP_MAILJOBS CASCADE CONSTRAINTS
>>
<<
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
  JOBID              NUMBER(15),
  JOBDATE            DATE
)
>>
<<
CREATE SEQUENCE AXP_MAILJOBSID
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER
>>
<<
CREATE OR REPLACE TRIGGER TRG_axpmailjobs
BEFORE INSERT ON AXP_MAILJOBS REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare
v_sid number(15);
BEGIN

select AXP_MAILJOBSID.nextval into v_sid from dual;

:NEW.jobid := v_sid;

END;
>>

<<
CREATE SEQUENCE AXsmsID
START WITH 1
INCREMENT BY 1
MINVALUE 0
NOCACHE 
NOCYCLE 
NOORDER 
>>
<<
CREATE OR REPLACE TRIGGER TRG_axsms
BEFORE INSERT ON AXSMS REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare
v_sid number(15);
BEGIN

select AXsmsID.nextval  into v_sid from dual;

:NEW.RECORDID :=  v_sid;

END;
>>
<<
CREATE TABLE USAGEDTL
(
  EXECUTEDDATE  DATE,
  CODE          VARCHAR2(20 BYTE),
  TITLE         VARCHAR2(50 BYTE),
  CNT           NUMBER(18)
)
>>
<<
CREATE TABLE AXPEXCEPTION
(
  EXP_DATE       DATE,
  STRUCTNAME     VARCHAR2(16 BYTE),
  SERVICENAME    VARCHAR2(50 BYTE),
  SERVICERESULT  VARCHAR2(500 BYTE),
  COUNT          NUMBER
)
>>
<<
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
)
>>
<<
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
    WHERE a.transid = b.name
>>
<<
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
    WHERE a.transid = b.name
>>
<<
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
>>
<<
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
>>
<<
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
>>
------ axpertlog analysis report
<<
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
>>

---- email format

/* Formatted on 17/11/2015 6:20:22 PM (QP5 v5.139.911.3011) */
/*
Parameters
Ptemplate- this is email configuration table ( sendmsg) template name
pkeyword- keywords should be matched with the equalant value, keywords and value should be delimitted with ',' (comma) and keywords are case sensitive for eg., '<username>=Ashok,<pwd>=12345'
ptype-E for email and S for SMS
*/
<<
CREATE OR REPLACE PROCEDURE pro_emailformat(ptemplate varchar ,pkeyword varchar,ptype varchar,psendto varchar,psendcc varchar ) is
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
>>

-- script runner
<<
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
>>

<<
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
>>

<<
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
>>

<<
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
>>
<<
delete from axpages 
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvidsco', 'DSign Configuration', '<root visible="T" type="p" defpage="T" name="PageIvidsco" caption="DSign Configuration" createdon="16/11/2015 18:12:24" createdby="admin" importedon="24/04/2019 12:29:49" importedby="admin" updatedon="16/11/2015 18:15:54" updatedby="admin" img="" ordno="23" levelno="2" parent="Head17" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iidsco" dbtype="oracle"><Container11 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__idsco" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__idsco cat="iview" name="idsco" parent="Container11" align="Client"/></root>', 1, 'T', 'p', 'Head14', 6, 2, '16/11/2015 18:15:54', '16/11/2015 18:12:24', '24/04/2019 12:29:49', 'admin', 'admin', 'admin', 'iidsco')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIviaxpscon', 'Axpstruct Configuration', '<root visible="T" type="p" defpage="T" name="PageIviaxpscon" caption="Axpstruct Configuration" createdon="04/12/2018 15:28:54" createdby="admin" importedon="24/04/2019 12:29:49" importedby="admin" updatedon="19/12/2018 15:17:54" updatedby="admin" img="" ordno="6" levelno="2" parent="Head21" pgtype="iiaxpscon" updusername="" ptype="p" dbtype="oracle"><Container388 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__iaxpscon"/><view__iaxpscon cat="iview" name="iaxpscon" parent="Container388" align="Client"/></root>', 1, 'T', 'p', 'Head14', 15, 2, '19/12/2018 15:17:54', '04/12/2018 15:28:54', '24/04/2019 12:29:49', 'admin', 'admin', 'admin', 'iiaxpscon')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIviaxex', 'Application Exceptions', '<root visible="T" type="p" defpage="T" name="PageIviaxex" caption="Application Exceptions" createdon="17/11/2015 12:18:45" createdby="admin" importedon="24/04/2019 12:29:50" importedby="admin" updatedon="17/11/2015 12:18:45" updatedby="admin" img="" ordno="32" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iiaxex" dbtype="oracle"><Container13 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__iaxex"/><view__iaxex cat="iview" name="iaxex" parent="Container13" align="Client"/></root>', 1, 'T', 'p', 'Head18', 33, 2, '17/11/2015 12:18:45', '17/11/2015 12:18:45', '24/04/2019 12:29:50', 'admin', 'admin', 'admin', 'iiaxex')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvesmsco', 'Email/SMS Configuration', '<root visible="T" type="p" defpage="T" name="PageIvesmsco" caption="Email/SMS Configuration" createdon="16/11/2015 12:54:29" createdby="admin" importedon="24/04/2019 12:29:50" importedby="admin" updatedon="16/11/2015 12:54:29" updatedby="admin" img="" ordno="19" levelno="2" parent="Head17" updusername="" ptype="p" pgtype="iesmsco" dbtype="oracle"><Container5 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__esmsco"/><view__esmsco cat="iview" name="esmsco" parent="Container5" align="Client"/></root>', 1, 'T', 'p', 'Head14', 10, 2, '16/11/2015 12:54:29', '16/11/2015 12:54:29', '24/04/2019 12:29:50', 'admin', 'admin', 'admin', 'iesmsco')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, IMPORTEDON, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvdmlscrpt', 'Script Runner', '<root visible="T" type="p" defpage="T" updatedon="21/07/2015 13:01:51" name="PageIvdmlscrpt" caption="Script Runner" img="" ordno="12" levelno="2" parent="Head17" updusername="" ptype="p" pgtype="idmlscrpt" importedon="24/04/2019 12:29:50" importedby="admin" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" updatedby="admin" dbtype="oracle"><Container538 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,648,1131" st="view__dmlscrpt" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__dmlscrpt cat="iview" name="dmlscrpt" parent="Container538" align="Client"/></root>', 1, 'T', 'p', 'Head17', 18, 2, '21/07/2015 13:01:51', '24/04/2019 12:29:50', 'admin', 'admin', 'idmlscrpt')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsiconf', 'Customize Iview', '<root visible="T" type="p" defpage="T" name="PageTsiconf" caption="Customize Iview" createdon="17/01/2017 18:09:56" createdby="admin" importedon="24/04/2019 12:29:39" importedby="admin" updatedon="11/04/2017 15:20:24" updatedby="admin" img="" ordno="19" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="ticonf" dbtype="oracle"><Container390 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,599,1045" st="tstruct__iconf" font="Tahoma,,,clBlack" color="$00FAF7F1"/><tstruct__iconf cat="tstruct" transid="iconf" parent="Container390" align="Client"/></root>', 1, 'T', 'p', 'Head14', 14, 2, '11/04/2017 15:20:24', '17/01/2017 18:09:56', '24/04/2019 12:29:39', 'admin', 'admin', 'admin', 'ticonf')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTstconf', 'Customize Tstruct', '<root visible="T" type="p" defpage="T" name="PageTstconf" caption="Customize Tstruct" createdon="12/01/2017 14:50:56" createdby="manasa" importedon="24/04/2019 12:29:40" importedby="admin" updatedon="19-12-2017 14:38:56" updatedby="admin" img="" ordno="43" levelno="0" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="ttconf" dbtype="oracle"><Container382 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,599,1045" st="tstruct__tconf" font="Tahoma,,,clBlack" color="$00FAF7F1"/><tstruct__tconf cat="tstruct" transid="tconf" parent="Container382" align="Client"/></root>', 1, 'T', 'p', 'Head14', 13, 2, '19/12/2017 14:38:56', '12/01/2017 14:50:56', '24/04/2019 12:29:40', 'manasa', 'admin', 'admin', 'ttconf')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsaxglo', 'Global Parameters', '<root visible="T" type="p" defpage="T" name="PageTsaxglo" caption="Global Parameters" createdon="30/11/2016 10:07:28" createdby="admin" importedon="24/04/2019 12:29:43" importedby="admin" updatedon="22/05/2018 12:13:10" updatedby="admin" img="" ordno="669" levelno="1" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="taxglo" dbtype="oracle"><Container253 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="tstruct__axglo" font="Tahoma,,,clBlack" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><tstruct__axglo cat="tstruct" transid="axglo" parent="Container253" align="Client"/></root>', 1, 'T', 'p', 'Head17', 22, 2, '22/05/2018 12:13:10', '30/11/2016 10:07:28', '24/04/2019 12:29:43', 'admin', 'admin', 'admin', 'taxglo')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY)
 Values
   ('Head22', 'User Credentials', '<root img="" visible="T" name="Head22" caption="User Credentials" createdon="07/03/2019 12:36:10" createdby="admin" importedon="24/04/2019 12:29:45" importedby="admin" updatedon="07/03/2019 12:36:10" updatedby="admin" type="h" ordno="2" levelno="1" parent="" ptype="h" pgtype="" dbtype="oracle"></root>', 1, 'T', 'h', 'Head19', 2, 1, '07/03/2019 12:36:10', '07/03/2019 12:36:10', '24/04/2019 12:29:45', 'admin', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvthint', 'Transaction Hint', '<root visible="T" type="p" defpage="T" name="PageIvthint" caption="Transaction Hint" createdon="19/11/2015 11:21:45" createdby="admin" importedon="24/04/2019 12:29:46" importedby="admin" updatedon="19/11/2015 11:21:45" updatedby="admin" img="" ordno="18" levelno="2" parent="" updusername="" ptype="p" pgtype="ithint" dbtype="oracle"><Container4 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__thint"/><view__thint cat="iview" name="thint" parent="Container4" align="Client"/></root>', 1, 'T', 'p', 'Head17', 23, 2, '19/11/2015 11:21:45', '19/11/2015 11:21:45', '24/04/2019 12:29:46', 'admin', 'admin', 'admin', 'ithint')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY)
 Values
   ('Head21', 'Settings', '<root img="" visible="T" name="Head21" caption="Settings" createdon="21/12/2018 12:05:50" createdby="admin" importedon="24/04/2019 12:29:46" importedby="admin" updatedon="21/12/2018 12:05:50" updatedby="admin" type="h" ordno="5" levelno="1" parent="" ptype="h" pgtype="" dbtype="oracle"></root>', 1, 'T', 'h', 'Head19', 38, 1, '21/12/2018 12:05:50', '21/12/2018 12:05:50', '24/04/2019 12:29:46', 'admin', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY)
 Values
   ('Head19', 'Admin Setup', '<root img="" visible="T" name="Head19" caption="Admin Setup" createdon="12/11/2015 15:56:31" createdby="admin" importedon="24/04/2019 12:29:46" importedby="admin" updatedon="12/11/2015 15:56:31" updatedby="admin" type="h" ordno="1" levelno="0" parent="" ptype="h" pgtype="" dbtype="oracle"></root>', 1, 'T', 'h', 1, 0, '12/11/2015 15:56:31', '12/11/2015 15:56:31', '24/04/2019 12:29:46', 'admin', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY)
 Values
   ('Head18', 'Admin Reports', '<root img="" visible="T" name="Head18" caption="Admin Reports" createdon="06/11/2015 17:10:03" createdby="admin" importedon="24/04/2019 12:29:46" importedby="admin" updatedon="06/11/2015 17:10:03" updatedby="admin" type="h" ordno="24" levelno="1" parent="Head19" ptype="h" pgtype="" dbtype="oracle"></root>', 1, 'T', 'h', 'Head19', 25, 1, '06/11/2015 17:10:03', '06/11/2015 17:10:03', '24/04/2019 12:29:46', 'admin', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, IMPORTEDON, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvsmslog', 'SMS Log', '<root visible="T" type="p" defpage="T" updatedon="05/17/2012 11:04:42" name="PageIvsmslog" caption="SMS Log" img="" ordno="26" levelno="2" parent="Head18" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="ismslog" importedon="24/04/2019 12:29:47" importedby="admin" dbtype="oracle"><Container179 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,676,1045" st="view__smslog" font=",,," color="$00FAF7F1"/><view__smslog cat="iview" name="smslog" parent="Container179" align="Client"/></root>', 1, 'T', 'p', 'Head18', 27, 2, '05/17/2012 11:04:42', '24/04/2019 12:29:47', 'admin', 'ismslog')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvloview1', 'List of Values', '<root visible="T" type="p" defpage="T" name="PageIvloview1" caption="List of Values" createdon="21/08/2015 16:14:45" createdby="admin" importedon="24/04/2019 12:29:47" importedby="admin" updatedon="21/08/2015 17:57:50" updatedby="admin" img="" ordno="13" levelno="2" parent="Head17" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iloview1" dbtype="oracle"><Container74 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__loview1" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__loview1 cat="iview" name="loview1" parent="Container74" align="Client"/></root>', 1, 'T', 'p', 'Head16', 36, 2, '21/08/2015 17:57:50', '21/08/2015 16:14:45', '24/04/2019 12:29:47', 'admin', 'admin', 'admin', 'iloview1')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvitimtk', 'Time Taken Analysis', '<root visible="T" type="p" defpage="T" name="PageIvitimtk" caption="Time Taken Analysis" createdon="17/11/2015 11:27:11" createdby="admin" importedon="24/04/2019 12:29:47" importedby="admin" updatedon="17/11/2015 11:27:11" updatedby="admin" img="" ordno="31" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iitimtk" dbtype="oracle"><Container12 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__itimtk"/><view__itimtk cat="iview" name="itimtk" parent="Container12" align="Client"/></root>', 1, 'T', 'p', 'Head18', 32, 2, '17/11/2015 11:27:11', '17/11/2015 11:27:11', '24/04/2019 12:29:47', 'admin', 'admin', 'admin', 'iitimtk')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvimobc', 'Mobile Configuration', '<root visible="T" type="p" defpage="T" name="PageIvimobc" caption="Mobile Configuration" createdon="12/11/2015 15:47:34" createdby="admin" importedon="24/04/2019 12:29:48" importedby="admin" updatedon="12/11/2015 15:50:22" updatedby="admin" img="" ordno="16" levelno="2" parent="Head17" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iimobc" dbtype="oracle"><Container2 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__imobc" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__imobc cat="iview" name="imobc" parent="Container2" align="Client"/></root>', 1, 'T', 'p', 'Head23', 49, 2, '12/11/2015 15:50:22', '12/11/2015 15:47:34', '24/04/2019 12:29:48', 'admin', 'admin', 'admin', 'iimobc')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvikywd', 'Keyword Template', '<root visible="T" type="p" defpage="T" name="PageIvikywd" caption="Keyword Template" createdon="16/11/2015 16:51:37" createdby="admin" importedon="24/04/2019 12:29:48" importedby="admin" updatedon="16/11/2015 16:55:05" updatedby="admin" img="" ordno="17" levelno="2" parent="Head17" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iikywd" dbtype="oracle"><Container9 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__ikywd" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__ikywd cat="iview" name="ikywd" parent="Container9" align="Client"/></root>', 1, 'T', 'p', 'Head17', 20, 2, '16/11/2015 16:55:05', '16/11/2015 16:51:37', '24/04/2019 12:29:48', 'admin', 'admin', 'admin', 'iikywd')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsagspr', 'App Global Search Data/Periodically', '<root visible="T" type="p" defpage="T" name="PageTsagspr" caption="App Global Search Data/Periodically" createdon="22/10/2018 16:51:00" createdby="admin" importedon="24/04/2019 12:30:16" importedby="admin" updatedon="18/02/2019 15:20:35" updatedby="admin" img="" ordno="11" levelno="2" parent="Head17" pgtype="tagspr" updusername="" ptype="p" dbtype="oracle"><Container359 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__agspr"/><tstruct__agspr cat="tstruct" transid="agspr" parent="Container359" align="Client"/></root>', 1, 'T', 'p', 'Head14', 12, 2, '18/02/2019 15:20:35', '22/10/2018 16:51:00', '24/04/2019 12:30:16', 'admin', 'admin', 'admin', 'tagspr')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsaxctx', 'Axpert Context', '<root visible="T" type="p" defpage="T" name="PageTsaxctx" caption="Axpert Context" createdon="21/12/2018 18:47:08" createdby="admin" importedon="24/04/2019 12:30:21" importedby="admin" updatedon="21/12/2018 18:47:08" updatedby="admin" img="" ordno="33" levelno="0" parent="" updusername="" ptype="p" pgtype="taxctx" dbtype="oracle"><Container2 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__axctx"/><tstruct__axctx cat="tstruct" transid="axctx" parent="Container2" align="Client"/></root>', 1, 'T', 'p', 'Head17', 24, 2, '21/12/2018 18:47:08', '21/12/2018 18:47:08', '24/04/2019 12:30:21', 'admin', 'admin', 'admin', 'taxctx')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsofcon', 'Offline Table Configuration', '<root visible="T" type="p" defpage="T" name="PageTsofcon" caption="Offline Table Configuration" createdon="25/12/2015 15:12:58" createdby="admin" importedon="24/04/2019 12:30:21" importedby="admin" updatedon="30/12/2015 13:10:02" updatedby="admin" img="" ordno="16" levelno="0" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="tofcon" dbtype="oracle"><Container32 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="tstruct__ofcon" font="Tahoma,,,clBlack" color="$00FAF7F1"/><tstruct__ofcon cat="tstruct" transid="ofcon" parent="Container32" align="Client"/></root>', 1, 'T', 'p', 'Head23', 51, 2, '30/12/2015 13:10:02', '25/12/2015 15:12:58', '24/04/2019 12:30:21', 'admin', 'admin', 'admin', 'tofcon')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('Page245', 'Mobile Configuration', '<root cat="page" name="Page245" caption="Mobile Configuration" visible="T" type="p" img="" parent="" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" createdon="18/11/2015 12:25:46" createdby="admin" importedon="24/04/2019 12:30:21" importedby="admin" updatedon="18/11/2015 12:26:34" updatedby="admin" ordno="41" levelno="0" updusername="" ptype="p" pgtype="taxmme" dbtype="oracle"><relations cat="rel"/><Container21 paged="False" align="Client" cat="cntr" parent="ClientPanel" font=",,," tlhw="0,0,647,1131" color="$00FAF7F1" st="tstruct__axmme"/><tstruct__axmme cat="tstruct" transid="axmme" parent="Container21" align="Client" tlhw="0,0,647,1131"/></root>', 1, 'T', 'p', 'Head23', 50, 2, '18/11/2015 12:26:34', '18/11/2015 12:25:46', '24/04/2019 12:30:21', 'admin', 'admin', 'admin', 'taxmme')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY)
 Values
   ('Head16', 'Data Setup', '<root img="" visible="T" name="Head16" caption="Data Setup" createdon="06/11/2015 17:08:07" createdby="admin" importedon="24/04/2019 12:30:21" importedby="admin" updatedon="06/11/2015 17:08:07" updatedby="admin" type="h" ordno="14" levelno="1" parent="Head19" ptype="h" pgtype="" dbtype="oracle"></root>', 1, 'T', 'h', 'Head19', 34, 1, '06/11/2015 17:08:07', '06/11/2015 17:08:07', '24/04/2019 12:30:21', 'admin', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY)
 Values
   ('Head14', 'Configuration', '<root img="" visible="T" name="Head14" caption="Configuration" createdon="06/11/2015 17:04:24" createdby="admin" importedon="24/04/2019 12:30:22" importedby="admin" updatedon="06/11/2015 17:04:24" updatedby="admin" type="h" ordno="2" levelno="1" parent="Head19" ptype="h" pgtype="" dbtype="oracle"></root>', 1, 'T', 'h', 'Head19', 5, 1, '06/11/2015 17:04:24', '06/11/2015 17:04:24', '24/04/2019 12:30:22', 'admin', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, CREATEDBY, UPDATEDBY)
 Values
   ('Head20', 'System', '<root img="" visible="F" name="Head20" caption="System" createdon="21/12/2018 12:04:39" createdby="admin" importedon="" importedby="" updatedon="21/12/2018 12:09:58" updatedby="admin" type="h" ordno="28" levelno="0" parent="" pgtype="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action=""></root>', 1, 'F', 'p', 'Head19', 37, 1, '21/12/2018 12:09:58', '21/12/2018 12:04:39', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, CREATEDBY, UPDATEDBY)
 Values
   ('Head23', 'Mobile', '<root img="" visible="T" name="Head246" caption="Mobile" createdon="24/04/2019 13:12:00" createdby="admin" importedon="" importedby="" updatedon="24/04/2019 13:12:00" updatedby="admin"></root>', 1, 'T', 'h', 'Head19', 48, 1, '24/04/2019 13:12:00', '24/04/2019 13:12:00', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsappsr', 'App Global Search', '<root visible="F" type="p" defpage="T" name="PageTsappsr" caption="App Global Search" createdon="06/12/2016 11:21:33" createdby="admin" importedon="24/04/2019 12:30:15" importedby="admin" updatedon="26/04/2019 16:24:58" updatedby="admin" img="" ordno="11" levelno="2" parent="Head14" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="tappsr" dbtype="oracle"><Container314 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="tstruct__appsr" font="Tahoma,,,clBlack" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><tstruct__appsr cat="tstruct" transid="appsr" parent="Container314" align="Client"/></root>', 1, 'F', 'p', 'Head14', 11, 2, '26/04/2019 16:24:58', '06/12/2016 11:21:33', '24/04/2019 12:30:15', 'admin', 'admin', 'admin', 'tappsr')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY)
 Values
   ('Head17', 'Admin Utilities', '<root img="" visible="T" name="Head17" caption="Admin Utilities" createdon="06/11/2015 17:09:27" createdby="admin" importedon="24/04/2019 12:29:46" importedby="admin" updatedon="06/11/2015 17:09:27" updatedby="admin" type="h" ordno="9" levelno="1" parent="Head19" ptype="h" pgtype="" dbtype="oracle"></root>', 1, 'T', 'h', 'Head19', 17, 1, '06/11/2015 17:09:27', '06/11/2015 17:09:27', '24/04/2019 12:29:46', 'admin', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvcerrm', 'Custom Error Messages', '<root visible="T" type="p" defpage="T" name="PageIvcerrm" caption="Custom Error Messages" createdon="18/11/2015 11:20:57" createdby="admin" importedon="24/04/2019 12:29:51" importedby="admin" updatedon="18/11/2015 11:20:57" updatedby="admin" img="" ordno="20" levelno="2" parent="Head17" updusername="" ptype="p" pgtype="icerrm" dbtype="oracle"><Container3 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__cerrm"/><view__cerrm cat="iview" name="cerrm" parent="Container3" align="Client"/></root>', 1, 'T', 'p', 'Head14', 9, 2, '18/11/2015 11:20:57', '18/11/2015 11:20:57', '24/04/2019 12:29:51', 'admin', 'admin', 'admin', 'icerrm')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvaxusracc', 'User Access Report', '<root visible="T" type="p" defpage="T" name="PageIvaxusracc" caption="User Access Report" createdon="29/07/2015 12:53:09" createdby="admin" importedon="24/04/2019 12:29:52" importedby="admin" updatedon="29/10/2015 18:41:39" updatedby="admin" img="" ordno="29" levelno="2" parent="Head18" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iaxusracc" dbtype="oracle"><Container59 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__axusracc" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__axusracc cat="iview" name="axusracc" parent="Container59" align="Client"/></root>', 1, 'T', 'p', 'Head18', 30, 2, '29/10/2015 18:41:39', '29/07/2015 12:53:09', '24/04/2019 12:29:52', 'admin', 'admin', 'admin', 'iaxusracc')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvivhelpto', 'Help Documents', '<root visible="T" type="p" defpage="T" name="PageIvivhelpto" caption="Help Documents" createdon="30/10/2018 10:15:12" createdby="admin" importedon="17/05/2019 17:02:15" importedby="admin" updatedon="17/05/2019 16:15:45" updatedby="admin" img="" ordno="77" levelno="3" parent="Head18" pgtype="iivhelpto" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" dbtype="oracle"><Container387 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="view__ivhelpto" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><view__ivhelpto cat="iview" name="ivhelpto" parent="Container387" align="Client"/></root>', 1, 'T', 'p', 'Head18', 26, 2, '17/05/2019 16:15:45', '30/10/2018 10:15:12', '17/05/2019 17:02:15', 'admin', 'admin', 'admin', 'iivhelpto')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsthelp', 'Help Document', '<root visible="T" type="p" defpage="T" name="PageTsthelp" caption="Help Document" createdon="30/10/2018 09:44:31" createdby="admin" importedon="17/05/2019 17:02:15" importedby="admin" updatedon="30/10/2018 11:42:24" updatedby="admin" img="" ordno="72" levelno="3" parent="Head17" pgtype="tthelp" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" dbtype="oracle"><Container386 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="tstruct__thelp" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><tstruct__thelp cat="tstruct" transid="thelp" parent="Container386" align="Client"/></root>', 1, 'T', 'p', 'Head17', 18, 2, '30/10/2018 11:42:24', '30/10/2018 09:44:31', '17/05/2019 17:02:15', 'admin', 'admin', 'admin', 'tthelp')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvaxusers', 'User Logins', '<root visible="T" type="p" defpage="T" name="PageIvaxusers" caption="User Logins" createdon="21/07/2015 12:32:11" createdby="admin" importedon="24/04/2019 12:29:52" importedby="admin" updatedon="21/07/2015 12:32:11" updatedby="admin" img="" ordno="4" levelno="2" parent="Head22" updusername="" ptype="p" pgtype="iaxusers" dbtype="oracle"><Container51 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axusers"/><view__axusers cat="iview" name="axusers" parent="Container51" align="Client"/></root>', 1, 'T', 'p', 'Head22', 4, 2, '21/07/2015 12:32:11', '21/07/2015 12:32:11', '24/04/2019 12:29:52', 'admin', 'admin', 'admin', 'iaxusers')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvaxroles', 'User Roles', '<root visible="T" type="p" defpage="T" name="PageIvaxroles" caption="User Roles" createdon="21/07/2015 12:26:56" createdby="admin" importedon="24/04/2019 12:29:53" importedby="admin" updatedon="21/07/2015 12:26:56" updatedby="admin" img="" ordno="3" levelno="2" parent="Head22" updusername="" ptype="p" pgtype="iaxroles" dbtype="oracle"><Container50 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axroles"/><view__axroles cat="iview" name="axroles" parent="Container50" align="Client"/></root>', 1, 'T', 'p', 'Head22', 3, 2, '21/07/2015 12:26:56', '21/07/2015 12:26:56', '24/04/2019 12:29:53', 'admin', 'admin', 'admin', 'iaxroles')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvaxnxtlst', 'Intelliview Configuration', '<root visible="T" type="p" defpage="T" name="PageIvaxnxtlst" caption="Intelliview Configuration" createdon="21/07/2015 12:16:42" createdby="admin" importedon="24/04/2019 12:29:53" importedby="admin" updatedon="21/07/2015 12:16:42" updatedby="admin" img="" ordno="21" levelno="2" parent="Head17" updusername="" ptype="p" pgtype="iaxnxtlst" dbtype="oracle"><Container47 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axnxtlst"/><view__axnxtlst cat="iview" name="axnxtlst" parent="Container47" align="Client"/></root>', 1, 'T', 'p', 'Head14', 8, 2, '21/07/2015 12:16:42', '21/07/2015 12:16:42', '24/04/2019 12:29:53', 'admin', 'admin', 'admin', 'iaxnxtlst')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvaxfinyrs', 'Year', '<root visible="T" type="p" defpage="T" name="PageIvaxfinyrs" caption="Year" createdon="22/07/2015 17:54:11" createdby="admin" importedon="24/04/2019 12:29:53" importedby="admin" updatedon="16/11/2015 18:32:58" updatedby="admin" img="" ordno="14" levelno="2" parent="Head17" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iaxfinyrs" dbtype="oracle"><Container55 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__axfinyrs" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__axfinyrs cat="iview" name="axfinyrs" parent="Container55" align="Client"/></root>', 1, 'T', 'p', 'Head16', 35, 2, '16/11/2015 18:32:58', '22/07/2015 17:54:11', '24/04/2019 12:29:53', 'admin', 'admin', 'admin', 'iaxfinyrs')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvaxemllog', 'Email Log', '<root visible="T" type="p" defpage="T" name="PageIvaxemllog" caption="Email Log" createdon="02/07/2015 12:38:42" createdby="admin" importedon="24/04/2019 12:29:55" importedby="admin" updatedon="02/07/2015 12:38:42" updatedby="admin" img="" ordno="25" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iaxemllog" dbtype="oracle"><Container14 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axemllog"/><view__axemllog cat="iview" name="axemllog" parent="Container14" align="Client"/></root>', 1, 'T', 'p', 'Head18', 26, 2, '02/07/2015 12:38:42', '02/07/2015 12:38:42', '24/04/2019 12:29:55', 'admin', 'admin', 'admin', 'iaxemllog')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvaxchtdtl', 'Dashboard Configuration', '<root visible="T" type="p" defpage="T" name="PageIvaxchtdtl" caption="Dashboard Configuration" createdon="03/07/2015 17:09:28" createdby="admin" importedon="24/04/2019 12:29:55" importedby="admin" updatedon="16/11/2015 16:57:09" updatedby="admin" img="" ordno="22" levelno="2" parent="Head17" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iaxchtdtl" dbtype="oracle"><Container39 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__axchtdtl" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__axchtdtl cat="iview" name="axchtdtl" parent="Container39" align="Client"/></root>', 1, 'T', 'p', 'Head14', 7, 2, '16/11/2015 16:57:09', '03/07/2015 17:09:28', '24/04/2019 12:29:55', 'admin', 'admin', 'admin', 'iaxchtdtl')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, IMPORTEDON, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvapplogsm', 'Application Usage Statistics', '<root visible="T" type="p" defpage="T" updatedon="29/10/2015 18:55:08" name="PageIvapplogsm" caption="Application Usage Statistics" img="" ordno="30" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iapplogsm" importedon="24/04/2019 12:29:55" importedby="admin" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" updatedby="admin" dbtype="oracle"><Container187 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__applogsm" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__applogsm cat="iview" name="applogsm" parent="Container187" align="Client"/></root>', 1, 'T', 'p', 'Head18', 31, 2, '29/10/2015 18:55:08', '24/04/2019 12:29:55', 'admin', 'admin', 'iapplogsm')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvadxoutlo', 'ADX Outbound Log', '<root visible="T" type="p" defpage="T" name="PageIvadxoutlo" caption="ADX Outbound Log" createdon="02/07/2015 17:39:09" createdby="admin" importedon="24/04/2019 12:29:55" importedby="admin" updatedon="02/07/2015 17:39:09" updatedby="admin" img="" ordno="27" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iadxoutlo" dbtype="oracle"><Container15 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__adxoutlo"/><view__adxoutlo cat="iview" name="adxoutlo" parent="Container15" align="Client"/></root>', 1, 'T', 'p', 'Head18', 28, 2, '02/07/2015 17:39:09', '02/07/2015 17:39:09', '24/04/2019 12:29:55', 'admin', 'admin', 'admin', 'iadxoutlo')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvadxinlog', 'ADX Inbound Log', '<root visible="T" type="p" defpage="T" name="PageIvadxinlog" caption="ADX Inbound Log" createdon="02/07/2015 17:51:06" createdby="admin" importedon="24/04/2019 12:29:58" importedby="admin" updatedon="02/07/2015 17:51:06" updatedby="admin" img="" ordno="28" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iadxinlog" dbtype="oracle"><Container16 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__adxinlog"/><view__adxinlog cat="iview" name="adxinlog" parent="Container16" align="Client"/></root>', 1, 'T', 'p', 'Head18', 29, 2, '02/07/2015 17:51:06', '02/07/2015 17:51:06', '24/04/2019 12:29:58', 'admin', 'admin', 'admin', 'iadxinlog')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvadxconfv', 'ADX Configuration', '<root visible="T" type="p" defpage="T" name="PageIvadxconfv" caption="ADX Configuration" createdon="03/07/2015 14:42:41" createdby="admin" importedon="24/04/2019 12:29:58" importedby="admin" updatedon="06/08/2015 06:59:30" updatedby="admin" img="" ordno="15" levelno="2" parent="Head17" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iadxconfv" dbtype="oracle"><Container21 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,659,1129" st="view__adxconfv" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__adxconfv cat="iview" name="adxconfv" parent="Container21" align="Client"/></root>', 1, 'T', 'p', 'Head17', 19, 2, '06/08/2015 06:59:30', '03/07/2015 14:42:41', '24/04/2019 12:29:58', 'admin', 'admin', 'admin', 'iadxconfv')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsaxstc', 'Developer Options', '<root visible="T" type="p" defpage="T" name="PageTsaxstc" caption="Developer Options" createdon="04/12/2018 13:36:37" createdby="admin" importedon="24/04/2019 12:30:06" importedby="admin" updatedon="18/12/2018 18:36:55" updatedby="admin" img="" ordno="8" levelno="2" parent="Head21" updusername="" ptype="p" pgtype="taxstc" dbtype="oracle"><Container387 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__axstc"/><tstruct__axstc cat="tstruct" transid="axstc" parent="Container387" align="Client"/></root>', 1, 'T', 'p', 'Head21', 39, 2, '18/12/2018 18:36:55', '04/12/2018 13:36:37', '24/04/2019 12:30:06', 'admin', 'admin', 'admin', 'taxstc')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsastcp', 'Configuration Property', '<root visible="T" type="p" defpage="T" name="PageTsastcp" caption="Configuration Property" createdon="04/12/2018 13:19:32" createdby="admin" importedon="24/04/2019 12:30:15" importedby="admin" updatedon="18/12/2018 15:43:36" updatedby="admin" img="" ordno="7" levelno="2" parent="Head21" updusername="" ptype="p" pgtype="tastcp" dbtype="oracle"><Container386 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__astcp"/><tstruct__astcp cat="tstruct" transid="astcp" parent="Container386" align="Client"/></root>', 1, 'T', 'p', 'Head14', 16, 2, '18/12/2018 15:43:36', '04/12/2018 13:19:32', '24/04/2019 12:30:15', 'admin', 'admin', 'admin', 'tastcp')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvForms', 'Forms', '<root visible="T" type="p" defpage="T" name="PageIvForms" caption="Forms" createdon="31/05/2018 13:10:04" createdby="admin" importedon="24/04/2019 12:29:38" importedby="admin" updatedon="21-02-2019 10:58:42" updatedby="admin" img="" ordno="39" levelno="0" parent="" pgtype="iForms" updusername="" ptype="p" dbtype="oracle"><Container83 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__Forms"/><view__Forms cat="iview" name="Forms" parent="Container83" align="Client"/></root>', 1, 'T', 'p', 'Head21', 40, 2, '21/02/2019 10:58:42', '31/05/2018 13:10:04', '24/04/2019 12:29:38', 'admin', 'admin', 'admin', 'iForms')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIvmainrepo', 'Form Elements', '<root visible="F" type="p" defpage="T" name="PageIvmainrepo" caption="Form Elements" createdon="19/07/2018 17:07:28" createdby="admin" importedon="24/04/2019 12:29:39" importedby="admin" updatedon="24/04/2019 13:13:39" updatedby="admin" img="" ordno="46" levelno="1" parent="Head21" pgtype="imainrepo" updusername="" ptype="p" dbtype="oracle" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action=""><Container182 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="view__mainrepo" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><view__mainrepo cat="iview" name="mainrepo" parent="Container182" align="Client"/></root>', 1, 'F', 'p', 'Head21', 42, 2, '24/04/2019 13:13:39', '19/07/2018 17:07:28', '24/04/2019 12:29:39', 'admin', 'admin', 'admin', 'imainrepo')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsad_fg', 'Fill Grid', '<root visible="F" type="p" defpage="T" name="PageTsad_fg" caption="Fill Grid" createdon="29/03/2018 15:45:16" createdby="bibin" importedon="24/04/2019 12:29:39" importedby="admin" updatedon="10/05/2018 11:22:55" updatedby="admin" img="" ordno="37" levelno="1" parent="" pgtype="tad_fg" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" dbtype="oracle"><Container4 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="tstruct__ad_fg" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><tstruct__ad_fg cat="tstruct" transid="ad_fg" parent="Container4" align="Client"/></root>', 1, 'F', 'p', 'Head21', 45, 2, '10/05/2018 11:22:55', '29/03/2018 15:45:16', '24/04/2019 12:29:39', 'bibin', 'admin', 'admin', 'tad_fg')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsad_ge', 'Gen Maps', '<root visible="F" type="p" defpage="T" name="PageTsad_ge" caption="Gen Maps" createdon="29-03-2018 16:12:39" createdby="manasa" importedon="24/04/2019 12:29:39" importedby="admin" updatedon="24/04/2019 13:15:19" updatedby="admin" img="" ordno="51" levelno="1" parent="Head21" pgtype="tad_ge" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" dbtype="oracle"><Container7 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="tstruct__ad_ge" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><tstruct__ad_ge cat="tstruct" transid="ad_ge" parent="Container7" align="Client"/></root>', 1, 'F', 'p', 'Head21', 47, 2, '24/04/2019 13:15:19', '29-03-2018 16:12:39', '24/04/2019 12:29:39', 'manasa', 'admin', 'admin', 'tad_ge')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsad_md', 'MD Maps', '<root visible="F" type="p" defpage="T" name="PageTsad_md" caption="MD Maps" createdon="29-03-2018 16:43:49" createdby="manasa" importedon="24/04/2019 12:29:39" importedby="admin" updatedon="10/05/2018 11:23:35" updatedby="admin" img="" ordno="34" levelno="1" parent="" pgtype="tad_md" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" dbtype="oracle"><Container11 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="tstruct__ad_md" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><tstruct__ad_md cat="tstruct" transid="ad_md" parent="Container11" align="Client"/></root>', 1, 'F', 'p', 'Head21', 46, 2, '10/05/2018 11:23:35', '29-03-2018 16:43:49', '24/04/2019 12:29:39', 'manasa', 'admin', 'admin', 'tad_md')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsad__d', 'DC Properties', '<root visible="F" type="p" defpage="T" name="PageTsad__d" caption="DC Properties" createdon="29-03-2018 14:49:38" createdby="manasa" importedon="24/04/2019 12:29:39" importedby="admin" updatedon="24/04/2019 13:14:01" updatedby="admin" img="" ordno="47" levelno="1" parent="Head21" pgtype="tad__d" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" dbtype="oracle"><Container2 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="tstruct__ad__d" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><tstruct__ad__d cat="tstruct" transid="ad__d" parent="Container2" align="Client"/></root>', 1, 'F', 'p', 'Head21', 43, 2, '24/04/2019 13:14:01', '29-03-2018 14:49:38', '24/04/2019 12:29:39', 'manasa', 'admin', 'admin', 'tad__d')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsad__t', 'Form Properties', '<root visible="F" type="p" defpage="T" name="PageTsad__t" caption="Form Properties" createdon="29/03/2018 14:41:06" createdby="bibin" importedon="24/04/2019 12:29:39" importedby="admin" updatedon="24/04/2019 13:13:19" updatedby="admin" img="" ordno="45" levelno="1" parent="Head21" pgtype="tad__t" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" dbtype="oracle"><Container4 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="tstruct__ad__t" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><tstruct__ad__t cat="tstruct" transid="ad__t" parent="Container4" align="Client"/></root>', 1, 'F', 'p', 'Head21', 41, 2, '24/04/2019 13:13:19', '29/03/2018 14:41:06', '24/04/2019 12:29:39', 'bibin', 'admin', 'admin', 'tad__t')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsmntst', 'New Field', '<root visible="F" type="p" defpage="T" name="PageTsmntst" caption="New Field" createdon="21/08/2018 12:29:18" createdby="admin" importedon="24/04/2019 12:29:40" importedby="admin" updatedon="24/04/2019 13:14:26" updatedby="admin" img="" ordno="48" levelno="1" parent="Head21" pgtype="tmntst" updusername="" ptype="p" dbtype="oracle" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action=""><Container268 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,598,1103" st="tstruct__mntst" color="$00FAF7F1" ptlhw="0,0,100,100" awmgn="False" margin="3,3,3,3"/><tstruct__mntst cat="tstruct" transid="mntst" parent="Container268" align="Client"/></root>', 1, 'F', 'p', 'Head21', 44, 2, '24/04/2019 13:14:26', '21/08/2018 12:29:18', '24/04/2019 12:29:40', 'admin', 'admin', 'admin', 'tmntst')
>>
<<
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,CreatedOn,ImportedOn,CreatedBy,UpdatedBy,ImportedBy,readonly,updusername,category,pagetype,INTVIEW,webenable,shortcut) VALUES 
('PageTstemps','Custom UI','<root visible="T" type="p" defpage="T" name="PageTstemps" caption="Custom UI" createdon="08-21-2020" createdby="admin" importedon="08-24-2020 12:20:20" importedby="admin" updatedon="08-21-2020" updatedby="admin" img="" ordno="13" levelno="2" parent="Head14" updusername="" ptype="p" pgtype="ttemps" dbtype="postgre"><Container16 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__temps"/><tstruct__temps cat="tstruct" transid="temps" parent="Container16" align="Client"/></root>
',1,'','T','p','Head14',14,2,'08-21-2020','08-21-2020','08-24-2020 12:20:20','admin','admin','admin',NULL,NULL,NULL,'ttemps',NULL,NULL,NULL)
>>
<<        
update axpages set UPDATEDON = trunc(sysdate),CREATEDON= trunc(sysdate);
>>


<<
CREATE OR REPLACE
PROCEDURE SP_RAPIDDEFINITION (
    ITid VARCHAR2,
    ORes1 OUT Sys_refCursor,
    ORes2 OUT Sys_refCursor
) IS
    Qry1 VARCHAR2(2000);
    Qry2 VARCHAR2(2000);
BEGIN
	-- Qry1 will fetch the 'Form Load' fields and their params.
    Qry1 := 'SELECT a.context, a.fieldname, c.expression, a.fldsql as fldsql, nvl(b.paramname,'''') as paramname 
              FROM axp_formload a 
              LEFT JOIN axp_params b on b.tstruct = '''||ITid||''' and a.fieldname = b.childfield and b.context = ''new'' and b.active = ''T'' 
              INNER JOIN  axpflds c on c.tstruct = '''||ITid||''' and a.fieldname=c.fname 
              WHERE a.tstruct = '''||ITid||''' and a.active=''T'' and a.context = ''new'' ';
			  
	-- Qry2 will fetch all dependents and all parents of fields and fillgrids. (Includes the parents of all dependents and parents of all parents)
    Qry2 := 'SELECT a.parentfield, a.childfield, a.dependenttype, nvl(b.paramname,'''') as paramname,    
              nvl(b.allrows,''F'') as allrows, nvl(b.dirparam,''F'') as dirparam, c.frmno, c.ordno FROM axp_dependent a 
              LEFT JOIN axp_params b on b.tstruct = '''||ITid||''' and a.parentfield = b.childfield and b.context = ''dep'' and b.active = ''T''
              JOIN axpflds c on c.tstruct = '''||ITid||''' and a.childfield=c.fname 
              WHERE a.tstruct = '''||ITid||'''
              UNION
              SELECT distinct par.paramname parentfield, dep1.childfield, ''g'' as dependenttype, nvl(b.paramname,'''') as paramname, ''F'' as allrows, ''F'' as dirparam, flds.frmno,flds.ordno  
              FROM axp_dependent dep1
              JOIN (select paramname, childfield from axp_params par where par.tstruct = '''||ITid||''' and par.context = ''fg'') par on par.childfield = dep1.parentfield
              JOIN axp_dependent dep2 on dep2.tstruct = '''||ITid||'''  and dep2.parentfield = par.paramname and dep2.dependenttype = ''g''
              JOIN axp_params b on b.tstruct = '''||ITid||''' and par.childfield = b.childfield and b.context = ''fg'' and b.active = ''T''
              JOIN axpflds flds on flds.tstruct = '''||ITid||''' and dep1.childfield = flds.fname
              WHERE dep1.tstruct = '''||ITid||'''
              ORDER BY frmno asc, ordno asc ';   
			  
    OPEN ORes1 for Qry1;
    OPEN ORes2 FOR QRY2;   
END;
>>
<<
CREATE OR REPLACE TRIGGER AX_HOMEBUILD_SAVED_bir 
BEFORE INSERT ON AX_HOMEBUILD_SAVED FOR EACH ROW 
BEGIN 
    :new.HOMEBUILD_ID := ax_homebuild_saved_seq.nextval; 
END;
>>
<<
CREATE OR REPLACE TRIGGER AX_HOMEBUILD_MASTER_bir 
BEFORE INSERT ON AX_HOMEBUILD_MASTER FOR EACH ROW 
BEGIN 
    :new.HOMEBUILD_ID := ax_homebuild_master_seq.nextval; 
END;
>>
<<
CREATE OR REPLACE TRIGGER ax_widget_bir    
BEFORE INSERT ON AX_WIDGET FOR EACH ROW 
BEGIN 
:new.widget_id := ax_widg_seq.nextval; 
END;
>>
<<
CREATE TABLE AX_HOMEBUILD_RESPONSIBILITY
(
HOMEBUILD_ID NUMBER REFERENCES AX_HOMEBUILD_MASTER(HOMEBUILD_ID) ON DELETE CASCADE,
RESPONSIBILITY VARCHAR2(255),
RESPONSIBILITY_ID NUMBER
)
>>
<<
CREATE TABLE AX_HOMEBUILD_SD_RESPONSIBILITY
(
HOMEBUILD_ID NUMBER REFERENCES AX_HOMEBUILD_SAVED(HOMEBUILD_ID) ON DELETE CASCADE,
RESPONSIBILITY VARCHAR2(255),
RESPONSIBILITY_ID NUMBER
)
>>
<<
CREATE TABLE AX_WIDGET_RESPONSIBILITY
(
WIDGET_ID NUMBER REFERENCES AX_WIDGET(WIDGET_ID) ON DELETE CASCADE,
RESPONSIBILITY VARCHAR2(255),
RESPONSIBILITY_ID NUMBER 
)
>>
<< 
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2009,50,2500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2009,70,3500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2009,30,1500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2010,10,500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2010,50,2500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2010,60,3000)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2010,80,4000)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2010,20,1000)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2012,99,4500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2012,88,4000)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2011,40,4000)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2011,88,1234)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2011,60,5678)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2011,40,4789)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2011,20,4500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2012,7,8745)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2012,89,8908)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2013,98,1200)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2013,56,4578)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2014,66,1299)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2013,77,9987)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2013,90,1234)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2014,100,8790)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2015,10,3241)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('John Doe', 'Singapore',2016,80,1355)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2009,50,1500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2009,20,5500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2009,30,21300)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2010,20,500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2010,20,2500)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2010,34,3000)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2012,99,2000)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2012,88,4000)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2011,54,3000)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2011,88,1234)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2011,60,7689)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2012,7,2345)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2012,66,8908)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2013,98,6781)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2013,89,1236)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2014,66,1299)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2013,34,1245)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2013,90,7645)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2014,32,8790)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2015,10,6754)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Harry', 'Japan',2016,11,3456)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2009,30,1265)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2010,35,1300)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2010,36,1250)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2011,38,1366)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2012,45,1560)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2013,33,1300)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2013,50,1378)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2014,42,1460)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2015,52,1270)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Rahul', 'India',2016,67,1330)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2009,60,1150)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2009,65,1250)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2010,72,1300)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2010,30,1600)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2011,40,1750)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2012,66,1150)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2013,85,1950)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2014,62,2150)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2015,68,1290)
>>
<<
INSERT INTO axp_sales_data (first_name, country,sales_year,sales_qty,sales_amount) VALUES ('Johnson', 'Africa',2016,40,1170)
>>
<<
COMMIT
>>
// 10.2.1 Notification for workFlow & Tstruct Designer
<<
CREATE TABLE AX_NOTIFY(
    NOTIFICATION_ID NUMBER(10,0) primary key,
    TITLE VARCHAR2(255),
    MESSAGE NCLOB,
    ACTIONS NCLOB,
    FROMUSER VARCHAR2(255),
    BROADCAST VARCHAR2(1) DEFAULT 'N',
    STATUS VARCHAR2(255),
    CREATED_BY VARCHAR2(255),
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR2(255),
    PROJECT_ID VARCHAR2(255),
    PURGE_ON_FIRST_ACTION VARCHAR2(1) DEFAULT 'N',
    NOTIFICATION_SENT_DATETIME TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    RECORDID VARCHAR2(255),
    lno VARCHAR2(255),
    elno VARCHAR2(255)
)
>>
<<
CREATE SEQUENCE ax_notify_seq START WITH 1
>>
<<
CREATE OR REPLACE TRIGGER AX_NOTIFY_bir 
BEFORE INSERT ON AX_NOTIFY FOR EACH ROW 
BEGIN 
    :new.NOTIFICATION_ID := ax_notify_seq.nextval; 
END;
>>
<<
CREATE TABLE AX_NOTIFY_WORKFLOW(
    NOTIFICATION_ID NUMBER(10,0),
    RECORDID VARCHAR2(255),
    APP_LEVEL VARCHAR2(2),
    APP_DESC VARCHAR2(2),
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR2(255),
    PROJECT_ID VARCHAR2(255),
    lno VARCHAR2(255),
    elno VARCHAR2(255)
)
>>
<<
CREATE TABLE AX_MOBILE_RESPONSE(
    NOTIFICATION_ID NUMBER(10,0),
    USER_ID VARCHAR2(255),
    RESPONSE NCLOB, 
    PROJECT_ID VARCHAR2(255)
)
>>
<<
CREATE TABLE AX_MOBILE_USER(
    IMEI VARCHAR2(255),
    USER_ID VARCHAR2(255),
    PROJECT_ID VARCHAR2(255),
    FIREBASE_ID VARCHAR2(255),
    GROUPNAME VARCHAR2(255),
    ACTIVE VARCHAR2(1)
)
>>
<<
CREATE TABLE AX_NOTIFY_USERS(    
    NOTIFICATION_ID NUMBER(10,0),
    USER_ID VARCHAR2(255),
    STATUS VARCHAR2(255),
    PROJECT_ID VARCHAR2(255)
)
>>
<<
alter table axtasks add notify_status VARCHAR2(1) DEFAULT 'N'
>>
<<
update ax_homebuild_saved set target = replace(target,'Wrapper','')
>>
<<
update ax_widget set widget_type='kpi' where widget_type='table'
>>
// 10.3 Page design script
<<
CREATE TABLE AX_PAGES(
	PAGE_ID NUMBER(10,0) primary key,
	TITLE VARCHAR2(255),
    TYPE VARCHAR2(255),
    MODULE VARCHAR2(255),
	TEMPLATE VARCHAR2(255),
    PAGE_MENU VARCHAR2(255),
	CONTENT NCLOB,
	CREATED_BY VARCHAR2(255),
	UPDATED_BY VARCHAR2(255),
	IS_DELETED VARCHAR2(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR2(1) DEFAULT 'N',
	CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
	UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,	
	IS_MIGRATED VARCHAR2(1) DEFAULT 'N',
  IS_DEFAULT VARCHAR2(1) DEFAULT 'N',
	ORDER_BY NUMBER
)
>>
<<
CREATE SEQUENCE ax_pages_seq START WITH 1
>>
<<
CREATE OR REPLACE TRIGGER AX_PAGES_bir 
BEFORE INSERT ON AX_PAGES FOR EACH ROW 
BEGIN 
    :new.PAGE_ID := ax_pages_seq.nextval; 
END;
>>
<<
CREATE TABLE AX_PAGE_SAVED(
	PAGE_ID NUMBER(10,0) primary key,
	TITLE VARCHAR2(255),
    TYPE VARCHAR2(255),
    MODULE VARCHAR2(255),
	TEMPLATE VARCHAR2(255),
    PAGE_MENU VARCHAR2(255),
	CONTENT NCLOB,
	CREATED_BY VARCHAR2(255),
	UPDATED_BY VARCHAR2(255),
	IS_DELETED VARCHAR2(1) DEFAULT 'N',
	CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
	UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,	
	IS_MIGRATED VARCHAR2(1) DEFAULT 'N',
    IS_LOCK VARCHAR2(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR2(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR2(1) DEFAULT 'N',
    IS_DEFAULT VARCHAR2(1) DEFAULT 'N',
	PARENT_PAGE_ID NUMBER(10,0),
	RESPONSIBILITY NCLOB,
	ORDER_BY NUMBER
)
>>
<<
CREATE SEQUENCE ax_page_saved_seq START WITH 1
>>
<<
CREATE OR REPLACE TRIGGER AX_PAGE_SAVED_bir 
BEFORE INSERT ON AX_PAGE_SAVED FOR EACH ROW 
BEGIN 
    :new.PAGE_ID := ax_page_saved_seq.nextval; 
END;
>>
<<
CREATE TABLE AX_PAGE_RESPONSIBILITY(	 
	PAGE_ID NUMBER REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,
	RESPONSIBILITY VARCHAR2(255),
  	RESPONSIBILITY_ID NUMBER
)
>>
<<
CREATE TABLE AX_PAGE_SD_RESPONSIBILITY(	 
	PAGE_ID NUMBER REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE,
	RESPONSIBILITY VARCHAR2(255),
  	RESPONSIBILITY_ID NUMBER
)
>>
<<
CREATE TABLE AX_WIDGET_SAVED (
    WIDGET_ID NUMBER(10,0) primary key,
    TITLE VARCHAR2(255),
    WIDGET_TYPE VARCHAR2(255),
    CONTENT NCLOB,
    TARGET VARCHAR2(255),
    IS_PRIVATE VARCHAR2(1) DEFAULT 'N',
    CREATED_BY VARCHAR2(255),
    UPDATED_BY VARCHAR2(255),
    IS_DELETED VARCHAR2(1) DEFAULT 'N',
    IS_LOCK VARCHAR2(1) DEFAULT 'N',
    ORDER_BY NUMBER,
    is_publish varchar2(1) DEFAULT 'N',
    PARENT_WIDGET_ID NUMBER,
    PAGE_ID REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE,
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR2(1) DEFAULT 'N'
)
>>
<<
CREATE SEQUENCE ax_widget_saved_seq START WITH 1
>>
<<
CREATE OR REPLACE TRIGGER AX_WIDGET_SAVED_bir 
BEFORE INSERT ON AX_WIDGET_SAVED FOR EACH ROW 
BEGIN 
    :new.WIDGET_ID := ax_widget_saved_seq.nextval; 
END;
>>
<<
CREATE TABLE AX_WIDGET_PUBLISHED (
    WIDGET_ID NUMBER(10,0) primary key,
    TITLE VARCHAR2(255),
    WIDGET_TYPE VARCHAR2(255),
    CONTENT NCLOB,
    TARGET VARCHAR2(255),
    IS_PRIVATE VARCHAR2(1) DEFAULT 'N',
    CREATED_BY VARCHAR2(255),
    UPDATED_BY VARCHAR2(255),
    IS_DELETED VARCHAR2(1) DEFAULT 'N',
    IS_LOCK VARCHAR2(1) DEFAULT 'N',
    ORDER_BY NUMBER,
    is_publish varchar2(1) DEFAULT 'N',
    PARENT_WIDGET_ID REFERENCES AX_WIDGET_SAVED(WIDGET_ID) ON DELETE CASCADE,
    PAGE_ID REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR2(1) DEFAULT 'N'
)
>>
<<
CREATE SEQUENCE ax_widget_publish_seq START WITH 1
>>
<<
CREATE OR REPLACE TRIGGER AX_WIDGET_PUBLISH_bir 
BEFORE INSERT ON AX_WIDGET_PUBLISHED FOR EACH ROW 
BEGIN 
    :new.WIDGET_ID := ax_widget_publish_seq.nextval; 
END;
>>
<<
CREATE TABLE AX_HP_USER_LEVEL_WIDGET(
    PAGE_ID NUMBER REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,    
    WIDGETS  NCLOB,
    USERNAME VARCHAR2(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
>>
<<
CREATE TABLE AX_PAGE_TEMPLATES(
    TEMPLATE_ID NUMBER(10,0) primary key,
    TITLE VARCHAR2(255),
	MODULE VARCHAR2(255),
    CONTENT NCLOB,
    CREATED_BY VARCHAR2(255),
    UPDATED_BY VARCHAR2(255),
    IS_DELETED VARCHAR2(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP
)
>>
<<
CREATE SEQUENCE ax_page_template_seq START WITH 1
>>
<<
CREATE OR REPLACE TRIGGER AX_PAGE_TEMPLATE_bir 
BEFORE INSERT ON AX_PAGE_TEMPLATES FOR EACH ROW 
BEGIN 
    :new.TEMPLATE_ID := ax_page_template_seq.nextval; 
END;
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('basic','{"cc":1,"img":"basic.png","name":"basic","cf":[{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin')
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('modern','{"cc":1,"img":"modern.png","name":"modern","cf":[{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","br":"14px","tr":{"p":"top","h":"70px","html":"<span style=\"float:left;font-size:45px;\">#TITLE_ICON#</span><span style=\"text-align: right;padding-top: 14px;position: relative;top: 16px;right: 5px;\">#TITLE_NAME#</span>"}}]}','admin')
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('mainCard','{"cc":7,"img":"mainCard.png","name":"mainCard","cf":[{"ht":"225px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin')
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('topaz','{"cc":5,"img":"topaz.png","name":"topaz","cf":[{"ht":"225px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m8 l8","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m8 l8","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin')
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('list','{"cc":1,"img":"list.png","name":"list","cf":[{"ht":"225px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin')
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('flow','{"cc":3,"img":"flow.png","name":"flow","repeatLastWidget":true,"cf":[{"ht":"500px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"500px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin')
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('checkered','{"cc":1,"img":"checkered.png","name":"checkered","cf":[{"ht":"300px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin')
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('flow main','{"cc":3,"img":"flow_main.png","name":"flow main","repeatLastWidget":true,"cf":[{"ht":"300px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"300px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin')
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('random','{"cc":7,"img":"random.png","name":"random","cf":[{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"300px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"300px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"200px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin')
>>
<<
commit
>>

<<
CREATE OR REPLACE VIEW axp_vw_menulist AS 
     SELECT menupath,
            name,
            ordno,
            levelno,
            parent,
            TYPE,
            pagetype
       FROM (    SELECT caption,
                        DECODE (LEVEL,
                                2, caption,
                                LPAD (' ', (LEVEL + levelno * 2) - 1) || caption)
                           AS menu_tree,
                        levelno,
                        TYPE,
                        pagetype,
                        SYS_CONNECT_BY_PATH (caption, '\') || '\' AS menupath,
                        ordno,
                        parent,
                        name
                   FROM axpages
                  WHERE blobno = 1
             START WITH parent IS NULL
             CONNECT BY PRIOR name = parent)
   ORDER BY ordno, menupath
>>
<<
CREATE OR REPLACE PROCEDURE axp_pr_page_creation (pname          VARCHAR2, --New Page Name/Delete Page Name

                                                  pcaption       VARCHAR2, --New Page Caption

                                                  ppagetype      VARCHAR2, --New Page Type

                                                  pparentname    VARCHAR2, --Parent Name

                                                  paction        VARCHAR2, -- Before/After inserting or delete

                                                  props          VARCHAR2  -- Webpage info string

                                                                         )

AS

   pparent    VARCHAR2 (50);

   pordno     NUMBER (15);

   plevelno   NUMBER (15);

   psysdate   VARCHAR2 (30);

BEGIN

   IF LOWER (paction) <> 'delete'

   THEN

      --Page Creation before or after

      SELECT parent, ordno, levelno

        INTO pparent, pordno, plevelno

        FROM (SELECT parent,

                     CASE

                        WHEN LOWER (paction) = 'before' THEN ordno

                        ELSE ordno + 1

                     END

                        ordno,

                     levelno

                FROM axp_vw_menulist

               WHERE name = pparentname AND TYPE = 'p'

              UNION ALL

                SELECT a.name,

                       MAX (b.ordno) + 1 AS ordno,

                       a.levelno + 1 AS levelno

                  FROM axp_vw_menulist a, axp_vw_menulist b

                 WHERE     a.name = pparentname

                       AND b.menupath LIKE a.menupath || '%'

                       AND a.TYPE = 'h'

              GROUP BY a.name, a.levelno);

 

      psysdate := TRIM (TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));

 

      UPDATE axpages

         SET ordno = ordno + 1

       WHERE ordno >= pordno;

 

      INSERT INTO axpages (name,

                           caption,

                           blobno,

                           visible,

                           TYPE,

                           parent,

                           props,

                           ordno,

                           levelno,

                           pagetype,

                           createdon,

                           updatedon,

                           importedon)

           VALUES (pname,

                   pcaption,

                   1,

                   'T',

                   'p',

                   pparent,

                   props,

                   pordno,

                   plevelno,

                   ppagetype,

                   psysdate,

                   psysdate,

                   psysdate);

 

      COMMIT;

   ELSE

      --Page Deleting

      SELECT ordno

        INTO pordno

        FROM axp_vw_menulist

       WHERE name = pname AND TYPE = 'p';

 

 

      DELETE FROM axpages

            WHERE name = pname;

 

      UPDATE axpages

         SET ordno = ordno - 1

       WHERE ordno >= pordno;

      

       commit;

      

   END IF;

END;
>>
<<
create or replace procedure pr_bulk_page_delete as

begin

for i in (Select name from axpages where pagetype='web' and blobno=1) 

loop

begin

axp_pr_page_creation( i.name,null,null,null,'delete',null);

exception when others then

null;

end ;

end loop;

end;
>>
-- Delete the All web pages from Page Menu.
<<
exec PR_BULK_PAGE_DELETE
>>
<<
delete from axpages where pagetype='web'
>>
--AxpertWebDev13-10.3.0.0
<<
ALTER TABLE axusers DROP COLUMN homepage
>>
<<
ALTER table axusers add homepage varchar2(255) DEFAULT null
>>
<<
ALTER TABLE axusergroups DROP COLUMN homepage
>>
<<
ALTER table axusergroups add homepage varchar2(255) DEFAULT null
>>
<<
ALTER table AX_PAGE_SAVED add IS_DEFAULT VARCHAR2(1) DEFAULT 'N'
>>
<<
ALTER table AX_PAGES add IS_DEFAULT VARCHAR2(1) DEFAULT 'N'
>>
--AxpertWebDev14-10.3.0.0
<<
INSERT INTO ax_page_saved (title,TEMPLATE,module,page_menu,IS_DEFAULT) values('Homepage',1,'PAGE','Head19','Y')
>>
<<
INSERT INTO ax_widget_saved (title,widget_type,content,target,order_by) select title,widget_type,content,target,order_by from ax_homebuild_master
>>
<<
update ax_widget_saved set created_by ='admin', page_id=1
>>
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
insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property','FetchSize')
>>
<<
insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property','General')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'SaveImage')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'ApplicationTemplate')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'mainPageTemplate')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'WebService Timeout')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Trim IView Data')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Excel Export')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'ExportVerticalAlign')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Autocomplete Search Pattern')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000003, 'F', 0, 'admin', TO_DATE('12/27/2018 12:53:08', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:41:34', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Load forms along with list', 'configtypeLoad forms along with list', 'Autosplit', 'Tstruct', 'F', 'F', 'T', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000006, 'F', 0, 'admin', TO_DATE('12/27/2018 12:53:02', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:41:56', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Load reports/lists along with form', 'configtypeLoad reports/lists along with form', 'Autosplit', 'Iview', 'F', 'F', 'F', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000009, 'F', 0, 'admin', TO_DATE('12/27/2018 12:42:23', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:42:23', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Disablesplit', 'configtypeDisablesplit', 'Disablesplit', 'All', 'F', 'F', 'T', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000012, 'F', 0, 'admin', TO_DATE('12/27/2018 12:48:34', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:43:19', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Open Window mode', 'configtypeOpen Window mode', 'Navigation', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000440000000, 'F', 0, 'admin', TO_DATE('11/27/2019 12:15:42', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('11/27/2019 12:15:42', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Autocomplete Search Pattern', 'Autocomplete Search Pattern', 'configtypeAutocomplete Search Pattern', 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'F')
>>
<<
   Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000440000001, 1000440000000, 1, 'starts with')
   >>   
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000440000002, 1000440000000, 2, 'contains')
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
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000013, 'F', 0, 'admin', TO_DATE('11/15/2019 14:45:59', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('11/15/2019 14:45:59', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'ExportVerticalAlign', 'ExportVerticalAlign', 'configtypeExportVerticalAlign', 'All', 'F', 'F', 'F', 'T', 'T', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000010, 'F', 0, 'admin', TO_DATE('11/15/2019 14:44:44', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('11/15/2019 14:44:44', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Excel Export', 'Excel Export', 'configtypeExcel Export', 'All', 'F', 'F', 'F', 'T', 'T', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000007, 'F', 0, 'admin', TO_DATE('11/15/2019 14:44:19', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('11/15/2019 14:44:19', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Trim IView Data', 'Trim IView Data', 'configtypeTrim IView Data', 'All', 'F', 'F', 'F', 'T', 'T', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000005, 'F', 0, 'admin', TO_DATE('11/15/2019 14:43:30', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('11/15/2019 14:43:30', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'WebService Timeout', 'WebService Timeout', 'configtypeWebService Timeout', 'All', 'F', 'F', 'F', 'T', 'T', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000002, 'F', 0, 'admin', TO_DATE('11/15/2019 14:41:30', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('11/15/2019 14:41:30', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'ApplicationCompressedMode', 'General', 'configtypeApplicationCompressedMode', 'All', 'F', 'F', 'F', 'F', 'F', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000000, 'F', 0, 'admin', TO_DATE('11/15/2019 14:40:32', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('11/15/2019 14:40:32', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'ApplicationTemplate', 'General', 'configtypeApplicationTemplate', 'All', 'F', 'F', 'F', 'F', 'F', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000001, 1000330000000, 1, 'mainPageTemplate.html')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000003, 1000330000002, 1, 'false')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000004, 1000330000002, 2, 'true')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000006, 1000330000005, 1, '100000')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000008, 1000330000007, 1, 'true')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000009, 1000330000007, 2, 'false')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000011, 1000330000010, 1, 'false')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000012, 1000330000010, 2, 'true')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000014, 1000330000013, 1, 'middle')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000015, 1000330000013, 2, 'top')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000330000016, 1000330000013, 3, 'bottom')
   >>
   <<
COMMIT
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, ORDNO, LEVELNO, UPDATEDON, CREATEDON, CREATEDBY, UPDATEDBY)
 Values
   ('Head20', 'System', '<root img="" visible="F" name="Head20" caption="System" createdon="21/12/2018 12:04:39" createdby="admin" importedon="" importedby="" updatedon="21/12/2018 12:09:58" updatedby="admin" type="h" ordno="28" levelno="0" parent="" pgtype="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action=""></root>', 1, 
    'F', 'h', 28, 0, 
    '21/12/2018 12:09:58', '21/12/2018 12:04:39', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, CREATEDBY, UPDATEDBY)
 Values
   ('Head21', 'Settings', '<root img="" visible="T" name="Head21" caption="Settings" createdon="21/12/2018 12:05:50" createdby="admin" importedon="" importedby="" updatedon="21/12/2018 12:05:50" updatedby="admin"></root>', 1, 
    'T', 'h', 'Head20', 29, 1, 
    '21/12/2018 12:05:50', '21/12/2018 12:05:50', 'admin', 'admin')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIviaxpscon', 'Axpstruct Configuration', '<root visible="T" type="p" defpage="T" name="PageIviaxpscon" caption="Axpstruct Configuration" createdon="04/12/2018 15:28:54" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="19/12/2018 15:17:54" updatedby="admin" img="" ordno="114" levelno="0" parent="" pgtype="iiaxpscon" updusername="" ptype="p" dbtype="oracle"><Container388 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__iaxpscon"/><view__iaxpscon cat="iview" name="iaxpscon" parent="Container388" align="Client"/></root>', 1, 
    'T', 'p', 'Head21', 30, 2, 
    '19/12/2018 15:17:54', '04/12/2018 15:28:54', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'iiaxpscon')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsastcp', 'Configuration Property', '<root visible="T" type="p" defpage="T" name="PageTsastcp" caption="Configuration Property" createdon="04/12/2018 13:19:32" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="18/12/2018 15:43:36" updatedby="admin" img="" ordno="112" levelno="0" parent="" updusername="" ptype="p" pgtype="tastcp" dbtype="oracle"><Container386 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__astcp"/><tstruct__astcp cat="tstruct" transid="astcp" parent="Container386" align="Client"/></root>', 1, 
    'T', 'p', 'Head21', 31, 2, 
    '18/12/2018 15:43:36', '04/12/2018 13:19:32', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'tastcp')
>>
<<
Insert into AXPAGES
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsaxstc', 'Developer Options', '<root visible="T" type="p" defpage="T" name="PageTsaxstc" caption="Developer Options" createdon="04/12/2018 13:36:37" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="18/12/2018 18:36:55" updatedby="admin" img="" ordno="113" levelno="0" parent="" updusername="" ptype="p" pgtype="taxstc" dbtype="oracle"><Container387 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__axstc"/><tstruct__axstc cat="tstruct" transid="axstc" parent="Container387" align="Client"/></root>', 1, 
    'T', 'p', 'Head21', 32, 2, 
    '18/12/2018 18:36:55', '04/12/2018 13:36:37', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'taxstc')
>>

<<
CREATE TABLE AXCTX1
(
  
  AXCONTEXT      VARCHAR2(75 BYTE),
  ATYPE          VARCHAR2(10 BYTE)
)
>>
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
    TO_DATE('04/10/2019 14:34:39', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/10/2019 13:01:39', 'MM/DD/YYYY HH24:MI:SS'), 1,
    1, 'Tstruct Grid edit option',
    'GridEdit', 'configtypeTstruct Grid edit option', 'Tstruct', 'F', 'F', 'T', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000003, 'F', 0, 'admin', TO_DATE('12/27/2018 12:53:08', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:41:34', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Load forms along with list', 'configtypeLoad forms along with list', 'Autosplit', 'Tstruct', 'F', 'F', 'T', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000006, 'F', 0, 'admin', TO_DATE('12/27/2018 12:53:02', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:41:56', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Load reports/lists along with form', 'configtypeLoad reports/lists along with form', 'Autosplit', 'Iview', 'F', 'F', 'F', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000009, 'F', 0, 'admin', TO_DATE('12/27/2018 12:42:23', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:42:23', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Disablesplit', 'configtypeDisablesplit', 'Disablesplit', 'All', 'F', 'F', 'T', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000012, 'F', 0, 'admin', TO_DATE('12/27/2018 12:48:34', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:43:19', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Open Window mode', 'configtypeOpen Window mode', 'Navigation', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1903990000000, 'F', 0, 'admin', 
    TO_DATE('01/23/2019 12:24:30', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('01/23/2019 12:24:30', 'MM/DD/YYYY HH24:MI:SS'), 1, 
    1, 'Align Text', 
    'Text', 'configtypeAlign Text', 'Tstruct', 'F', 'F', 'T', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1751880000000, 'F', 0, 'admin', 
    TO_DATE('04/05/2019 11:31:42', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/05/2019 11:31:42', 'MM/DD/YYYY HH24:MI:SS'), 1, 
    1, 'Main Page Reload', 
    'General', 'configtypeMain Page Reload', 'Tstruct', 'F', 'F', 'T', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1742550000002, 'F', 0, 'admin', 
    TO_DATE('04/03/2019 18:31:43', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/03/2019 18:31:43', 'MM/DD/YYYY HH24:MI:SS'), 1, 
    1, 'Change Password', 
    'General', 'configtypeChange Password', 'All', 'F', 'F', 'T', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1742550000005, 'F', 0, 'admin', 
    TO_DATE('04/03/2019 18:32:27', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/03/2019 18:32:27', 'MM/DD/YYYY HH24:MI:SS'), 1, 
    1, 'Landing Structure', 
    'General', 'configtypeLanding Structure', 'All', 'F', 'F', 'T', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1742550000008, 'F', 0, 'admin', 
    TO_DATE('04/03/2019 18:34:26', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/03/2019 18:34:26', 'MM/DD/YYYY HH24:MI:SS'), 1, 
    1, 'FetchSize', 
    'FetchSize', 'configtypeFetchSize', 'All', 'F', 'F', 'T', 'T')
>> 
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1790770000000, 'F', 0, 'pandi', 
    TO_DATE('04/12/2019 17:38:13', 'MM/DD/YYYY HH24:MI:SS'), 'pandi', TO_DATE('04/12/2019 17:38:13', 'MM/DD/YYYY HH24:MI:SS'), 1, 
    1, 'Local Dataset', 
    'Lds', 'configtypeLocal Dataset', 'Tstruct', 'F', 'F', 'T', 'T')
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
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000003, 1742550000002, 1, 'Disable')
   >>
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000004, 1742550000002, 2, 'Enable')
   >>
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000007, 1742550000005, 2, 'iview')
   >>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000006, 1742550000005, 1, 'tstruct')
   >>
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000010, 1742550000008, 2, '30')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000028, 1742550000008, 20, '5000')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000027, 1742550000008, 19, '2000')
   >>
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000026, 1742550000008, 18, '1000')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000009, 1742550000008, 1, '25')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000029, 1742550000008, 21, 'ALL')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000011, 1742550000008, 3, '35')
   >>
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000012, 1742550000008, 4, '40')
   >>
<<
 Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000013, 1742550000008, 5, '45')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000014, 1742550000008, 6, '50')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000015, 1742550000008, 7, '55')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000016, 1742550000008, 8, '60')
   >>
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000017, 1742550000008, 9, '65')
   >>
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000018, 1742550000008, 10, '70')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000019, 1742550000008, 11, '75')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000020, 1742550000008, 12, '80')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000021, 1742550000008, 13, '85')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000022, 1742550000008, 14, '90')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000023, 1742550000008, 15, '95')
   >>
<<
 Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000024, 1742550000008, 16, '100')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000025, 1742550000008, 17, '500')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1751880000001, 1751880000000, 1, 'true')
   >>
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1751880000002, 1751880000000, 2, 'false')
   >>
<< 
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1903990000001, 1903990000000, 1, 'Right')
   >>
<<
Insert  into AXPSTRUCTCONFIGPROVAL
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
 drop view AXP_APPSEARCH_DATA 
 >>
 <<
CREATE TABLE AXP_APPSEARCH_DATA
(
  CANCEL                CHAR(1 BYTE),
  SOURCEID              INTEGER,
  MAPNAME               VARCHAR2(20 BYTE),
  USERNAME              VARCHAR2(50 BYTE),
  MODIFIEDON            DATE,
  CREATEDBY             VARCHAR2(50 BYTE),
  CREATEDON             DATE,
  WKID                  VARCHAR2(15 BYTE),
  APP_LEVEL             NUMBER(3),
  APP_DESC              NUMBER(1),
  APP_SLEVEL            NUMBER(3),
  CANCELREMARKS         VARCHAR2(150 BYTE),
  WFROLES               VARCHAR2(250 BYTE),
  HLTYPE                VARCHAR2(10 BYTE),
  STRUCTNAME            VARCHAR2(50 BYTE),
  SEARCHTEXT            VARCHAR2(500 BYTE),
  PARAMS                VARCHAR2(500 BYTE),
  AXP_APPSEARCH_DATAID  NUMBER(16)
)
>>
<<  
CREATE TABLE AXP_APPSEARCH_DATA_V2
(
  HLTYPE      VARCHAR2(10 BYTE),
  STRUCTNAME  VARCHAR2(25 BYTE),
  SEARCHTEXT  VARCHAR2(200 BYTE),
  PARAMS      VARCHAR2(150 BYTE),
  CREATEDON   DATE                              DEFAULT sysdate,
  DOCID       VARCHAR2(50 BYTE)
) 
>>
<<
CREATE UNIQUE INDEX UI_AXP_APPSEARCH_DATA_V2 ON AXP_APPSEARCH_DATA_V2
(HLTYPE, STRUCTNAME, PARAMS) 
>>


<<
CREATE OR REPLACE procedure pr_source_trigger ( phltype in varchar2, pstructname in varchar2, psearchtext in varchar2, psrctable in varchar2,psrcfield in varchar2 , pparams in varchar2,pdocid in varchar2,psrcmultipletransid in varchar2,pparamchange varchar2 )
  AUTHID CURRENT_USER
  is
  pscripts varchar2(3000);
  pcnt number(15);
begin



--To insert  or update dynamic param value from the source table
if psrctable is not null and psrcfield is not null then

--To drop existing trigger if any source field or source table has been changed
if pparamchange ='T' THEN 
select count(1) into pcnt from user_objects where object_type='TRIGGER' and trim(upper(object_name))=trim(upper('axp_sch_'|| pdocid) ) ;
if pcnt >0 then 
execute immediate 'drop trigger axp_sch_'|| trim(pdocid);
end if;
delete  axp_appsearch_data_v2 where docid= pdocid ;
commit;
end if;

--To create the source table trigger
pscripts :=  ' create or replace trigger axp_sch_'||pdocid ||' 
before insert or update or delete on '||psrctable ||' 
for each row ' || 
case when psrcmultipletransid is not null then ' when ( new.transid='''||psrcmultipletransid||''' or  old.transid='''||psrcmultipletransid||''')' else null end ||'
begin 
if inserting  then 
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values('''|| phltype || ''','''||pstructname||''',:'||'new.'||psrcfield||'||  '''||psearchtext||''','''||replace( replace( pparams ,'@','''||:'||'new.') ,'&','&''||''')||','''||pdocid||''');
else if  updating then
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values('''|| phltype || ''','''||pstructname||''',:'||'new.'||psrcfield||'||  '''||psearchtext||''','''||replace( replace( pparams ,'@','''||:'||'old.') ,'&','&''||''')||','''||pdocid||''');
else  delete  axp_appsearch_data_v2 where hltype='''||phltype||''' and params='''||replace( replace( pparams ,'@','''||:'||'old.') ,'&','&''||''')||';
 end if;
 end if;
exception
      when DUP_VAL_ON_INDEX then
      update axp_appsearch_data_v2 set searchtext=:'||'new.'||psrcfield||'||  '''||psearchtext||''',params='''||replace( replace( pparams ,'@','''||:'||'new.') ,'&','&''||''')||' where hltype='''||phltype||''' and params='''||replace( replace( pparams ,'@','''||:'||'old.') ,'&','&''||''')||' and docid='''||pdocid||''';
   when others then 
 null ;

 end ;  ' ;

execute immediate pscripts  ;

--Rebuild the exsting recordid from source table to appsearch data table
execute immediate 'update  '||psrctable ||' set cancel=cancel' ;

 commit;

 end if;

 EXCEPTION WHEN OTHERS THEN 
 --to check invalid trigger
 pcnt := 0;
  select count(1) into pcnt from user_objects where object_type='TRIGGER' and trim(upper(object_name))=trim(upper('AXP_SCH_'|| pdocid )) and status='INVALID';

 if pcnt >0 then 
 execute immediate 'ALTER TRIGGER '||TRIM(UPPER('AXP_SCH_'|| pdocid ))|| ' DISABLE';
 end if;

 end ;
>>
<< 
 CREATE OR REPLACE TRIGGER AXP_TR_SEARCH_APPSEARCH
before insert or update or delete ON AXP_APPSEARCH_DATA_PERIOD for each row
declare 
cnt number;
begin 
if :new.periodically ='T' or :new.srctable is  null or :new.srcfield is  null then
begin
if inserting  then 
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(:new.hltype,:new.structname, case when :new.periodically ='T' then :new.searchtext else  :new.caption end ,:new.params,:new.docid);
else if updating then
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(:old.hltype,:old.structname, case when :old.periodically ='T' then :old.searchtext else  :old.caption end ,:old.params,:old.docid);
 end if;
  end if;
  
if deleting then 
   delete  axp_appsearch_data_v2 where docid = :old.docid;
   select count(1) into cnt from user_triggers where lower(trigger_name)= lower ( 'axp_sch_'||:old.docid );
   if cnt >0 then
   execute immediate 'drop trigger '||'axp_sch_'||:old.docid;
   end if;
end if;

exception
      when DUP_VAL_ON_INDEX then
      update axp_appsearch_data_v2 set  hltype= :new.hltype , structname = :new.structname,searchtext = case when :new.periodically ='T' then :new.searchtext else  :new.caption end  ,params=:new.params where docid= :new.docid;
   when others then 
 null ;

end ;

end if;

 end ;

>>
<<
CREATE OR REPLACE FORCE VIEW AXP_VW_MENU
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
     SELECT menupath,
            caption,
            name,
            ordno,
            levelno,
            parent,
            TYPE,
            pagetype,
            visible
       FROM (    SELECT caption,
                        DECODE (LEVEL,
                                2, caption,
                                LPAD (' ', (LEVEL + levelno * 2) - 1) || caption)
                           AS menu_tree,
                        levelno,
                        TYPE,
                        pagetype,
                        SYS_CONNECT_BY_PATH (caption, '\') || '\' AS menupath,
                        ordno,
                        parent,
                        name,
                        SYS_CONNECT_BY_PATH (visible, '\') || '\' AS visible
                   FROM axpages
                  WHERE blobno = 1
             START WITH parent IS NULL
             CONNECT BY PRIOR name = parent)
   ORDER BY ordno, menupath
  >> 
  <<
 CREATE OR REPLACE FORCE VIEW AXP_APPSEARCH_DATA_NEW
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
          TRIM (REPLACE (searchtext, 'View', ' ')) AS searchtext,
          params
     FROM axp_appsearch_data_v2
    WHERE LOWER (PARAMS) NOT LIKE '%sysdate%'
   UNION ALL
   SELECT 1.9 AS slno,
          hltype,
          structname,
          TRIM (REPLACE (searchtext, 'View', ' ')) AS searchtext,
          params
     FROM axp_appsearch_data a
    WHERE  not exists (Select 'x'  from   axp_appsearch_data_v2 b where a.structname=b.structname and a.params=b.params)
   UNION ALL
   SELECT 2,
          hltype,
          structname,
          TRIM (REPLACE (searchtext, 'View', ' ')) AS searchtext,
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
                                     TRIM (
                                        TO_CHAR (
                                           TRUNC (
                                              ADD_MONTHS (SYSDATE, 0 - 1),
                                              'MM'),
                                           'dd/mm/yyyy'))),
                                  'last_day(add_months(trunc(sysdate),0-1))',
                                  TRIM (
                                     TO_CHAR (
                                        LAST_DAY (
                                           ADD_MONTHS (TRUNC (SYSDATE),
                                                       0 - 1)),
                                        'dd/mm/yyyy'))),
                               'trunc(sysdate)-1',
                               TRIM (
                                  TO_CHAR (TRUNC (SYSDATE) - 1, 'dd/mm/yyyy'))),
                            'trunc(sysdate)',
                            TRIM (TO_CHAR (TRUNC (SYSDATE), 'dd/mm/yyyy'))),
                         'trunc(sysdate,''IW'')',
                         TRIM (TO_CHAR (TRUNC (SYSDATE, 'IW'), 'dd/mm/yyyy'))),
                      'trunc(sysdate-7,''IW'')+6',
                      TRIM (
                         TO_CHAR (TRUNC (SYSDATE - 7, 'IW') + 6,
                                  'dd/mm/yyyy'))),
                   'trunc(sysdate-7,''IW'')',
                   TRIM (TO_CHAR (TRUNC (SYSDATE - 7, 'IW'), 'dd/mm/yyyy'))),
                'trunc(sysdate,''MM'')',
                TRIM (TO_CHAR (TRUNC (SYSDATE, 'MM'), 'dd/mm/yyyy'))),
             ' &',
             '&')
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
                         AND TRIM (SUBSTR (x.pagetype, 2, 20)) = t.name
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
                         AND TRIM (SUBSTR (x.pagetype, 2, 20)) = i.name
                         AND x.visible NOT LIKE '%F%')
   ORDER BY 1
   >>
<<
 DROP VIEW AXP_APPSEARCH
 >>
<<
CREATE OR REPLACE FORCE VIEW AXP_APPSEARCH
(
   SEARCHTEXT,
   PARAMS,
   HLTYPE,
   STRUCTNAME,
   USERNAME
)
AS
   SELECT UNIQUE
          SEARCHTEXT,
          PARAMS
          || CASE WHEN PARAMS IS NOT NULL AND LOWER(PARAMS) not LIKE '%~act%'THEN  '~act=load' ELSE NULL END
             AS PARAMS,
          HLTYPE,
          STRUCTNAME,
          USERNAME
     FROM (  SELECT s.slno,
                    s.searchtext,
                    s.params,
                    s.hltype,
                    s.structname,
                    lg.username
               FROM axp_appsearch_data_NEW s,
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
                                   NULL slno
                     FROM axp_appsearch_data_NEW s, axuseraccess a
                    WHERE a.sname(+) = s.structname AND a.stype(+) IN ('t', 'i')) b
            WHERE lg.usergroup = 'default'
           ORDER BY slno, username)
 >>
<<
update axp_appsearch_data set params=replace(params,'&','~')
>>
<<
update axp_appsearch_data_v2 set params=replace(params,'&','~')
>> 
<<
Insert into AXCTX1
   (AXCONTEXT, ATYPE)
 Values
   ('FormLoad', 'Property')
>>
<<
alter table AXPSTRUCTCONFIGPROPS add ALLUSERROLES varchar2(100) 
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1104220000000, 'F', 0, 'admin', 
    TO_DATE('02/25/2019 15:35:10', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('02/25/2019 14:56:19', 'MM/DD/YYYY HH24:MI:SS'), 1, 
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
<< 
Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1540330000000,'F',0,null,'admin',to_date('03-01-19','DD-MM-RR'),'admin',to_date('03-01-19','DD-MM-RR'),null,1,1,null,null,null,'Disablesplit','All','Disablesplit',null,'true',null,'true','Forms(Forms)','Forms',null,null,null,null,null,'Iview','ALL','DisablesplitFormstrueALL')
>>

<<
 Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1540440000000,'F',0,null,'admin',to_date('03-01-19','DD-MM-RR'),'admin',to_date('03-01-19','DD-MM-RR'),null,1,1,null,null,null,'Load reports/lists along with form','Iview','Autosplit',null,'true',null,'true','Form Elements(mainrepo)','mainrepo',null,null,null,null,null,'Iview','ALL','Load reports/lists along with formmainrepotrueALL')
>>
<<
 Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1540770000000,'F',0,null,'admin',to_date('03-01-19','DD-MM-RR'),'admin',to_date('03-01-19','DD-MM-RR'),null,1,1,null,null,null,'Open Window mode','All','Navigation',null,'newpage',null,'newpage','Forms(Forms)','Forms','opentstr',null,null,'opentstr',null,'Iview','ALL','Open Window modeFormsnewpageALL')
>>
<<
 Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1573550000000,'F',0,null,'admin',to_date('10-01-19','DD-MM-RR'),'admin',to_date('10-01-19','DD-MM-RR'),null,1,1,null,null,null,'Disablesplit','All','Disablesplit',null,'true',null,'true','Advance Settings(axstc)','axstc',null,null,null,null,null,'Tstruct','ALL','DisablesplitaxstctrueALL')
>>
<<
 Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1108880000000,'F',0,null,'admin',to_date('26-03-19','DD-MM-RR'),'admin',to_date('26-03-19','DD-MM-RR'),null,1,1,null,null,null,'Open Window mode','All','Navigation',null,'newpage',null,'newpage','Form Elements(mainrepo)','mainrepo','deletesc',null,null,'deletesc',null,'Iview','ALL','Open Window modemainreponewpageALL')
>>
<< 
Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1109010000000,'F',0,null,'admin',to_date('26-03-19','DD-MM-RR'),'admin',to_date('26-03-19','DD-MM-RR'),null,1,1,null,null,null,'Open Window mode','All','Navigation',null,'newpage',null,'newpage','Form Elements(mainrepo)','mainrepo','callws',null,null,'callws',null,'Iview','ALL','Open Window modemainreponewpageALL')
>>
<<
CREATE OR REPLACE procedure pr_axcnfgiv_tab_create ( structtransid in varchar2 ) as
pragma autonomous_transaction;
v_cnt number(2) ;
v_sql varchar2(4000);
begin
      select nvl(count(tname),0) into v_cnt from tab where lower(tname) = lower( 'axpconfigsiv'||chr(95)||structtransid );
      if v_cnt = 0
      then
        v_sql := 'create table axpconfigsiv'||chr(95)||structtransid||' ( configname varchar2(30),cvalue varchar2(240),condition varchar2(240))' ;
        execute immediate v_sql;
        commit;
      end if;
end;
>>
<<
CREATE OR REPLACE procedure pr_axcnfg_tab_create ( structtransid in varchar2 ) as
pragma autonomous_transaction;
v_cnt number(2) ;
v_sql varchar2(4000);
begin
      select nvl(count(tname),0) into v_cnt from tab where lower(tname) = lower( 'axpconfigs'||chr(95)||structtransid );
      if v_cnt = 0
      then
      v_sql := 'create table axpconfigs'||chr(95)||structtransid||' ( configname varchar2(30),cvalue varchar2(2000),condition varchar2(240))' ;
        execute immediate v_sql;
commit;
        end if;
end;
>>
<<
CREATE OR REPLACE TRIGGER TR_AXPCONFIGS_IVIEWS
after insert or update or delete on iconfiguration 
referencing new as new old as old
for each row
declare
v_cnt number(2);
v_sql varchar2(4000);
begin 
    if INSERTING 
    then
      --pr_axcnfgiv_tab_create ( :new.structtransid ) ;
      GOTO CvaluesInsert;
    elsif UPDATING 
    then
        v_sql := 'delete axpconfigsiv'||chr(95)||:old.structtransid;
        execute immediate v_sql;        
        GOTO CvaluesInsert;
    elsif DELETING 
    then
        v_sql := 'delete axpconfigsiv'||chr(95)||:old.structtransid;
        execute immediate v_sql;   
        GOTO NIL;
    end if;
    
    <<CvaluesInsert>>
      if :new.cv_groupbuttons is not null
      then
        v_sql := 'insert into axpconfigsiv'||chr(95)||:new.structtransid||' ( configname,cvalue,condition ) values ('''||:new.configname2||''','''||:new.cv_groupbuttons||''',null)';
        execute immediate v_sql;
      end if;
      
    <<NIL>>
        v_cnt := 2 ;
end;
>>
<<
CREATE OR REPLACE TRIGGER TR_AXPCONFIGS_TSTRUCTS
after insert or update or delete on tconfiguration 
referencing new as new old as old
for each row
declare
v_cnt number(2);
v_sql varchar2(4000);

begin 
    if INSERTING 
    then 
            pr_axcnfg_tab_create ( :new.structtransid ) ;
      GOTO CvaluesInsert;
    elsif UPDATING 
    then
        v_sql := 'delete axpconfigs'||chr(95)||:old.structtransid;
        execute immediate v_sql;        
        GOTO CvaluesInsert;
    elsif DELETING 
    then
        v_sql := 'delete axpconfigs'||chr(95)||:old.structtransid;
        execute immediate v_sql;   
        GOTO NIL;
    end if;
    
    <<CvaluesInsert>>
      if :new.cv_searchflds is not null
      then
        v_sql := 'insert into axpconfigs'||chr(95)||:new.structtransid||' ( configname,cvalue,condition ) values ('''||:new.configname1||''','''||:new.cv_searchflds||''',null)';
        execute immediate v_sql;
      end if;
      
      if :new.cv_groupbuttons is not null
      then
        v_sql := 'insert into axpconfigs'||chr(95)||:new.structtransid||' ( configname,cvalue,condition ) values ('''||:new.configname2||''','''||:new.cv_groupbuttons||''',null)';
        execute immediate v_sql;
      end if;
      
      if :new.cv_htmlprints is not null
      then
        v_sql := 'insert into axpconfigs'||chr(95)||:new.structtransid||' ( configname,cvalue,condition ) values ('''||:new.configname3||''','''||:new.cv_htmlprints||''',null)';
        execute immediate v_sql;
      end if;     
              
      if :new.cv_masterflds is not null
      then
        v_sql := 'insert into axpconfigs'||chr(95)||:new.structtransid||' ( configname,cvalue,condition ) values ('''||:new.configname4||''','''||:new.cv_masterflds||''',null)';
        execute immediate v_sql;
      end if;
      
    <<NIL>>
    v_cnt := 2 ;
end;
>>
<<
CREATE TABLE AXPCONFIGSIV_MAINREPO
(
  CONFIGNAME  VARCHAR2(30 BYTE),
  CVALUE      VARCHAR2(240 BYTE),
  CONDITION   VARCHAR2(240 BYTE)
)
>>
<<
Insert into AXPCONFIGSIV_MAINREPO
   (CONFIGNAME, CVALUE)
 Values
   ('groupbtns', 'Custom Actions-adddc,act1,fillg,genmap,mdmaps,callws,deletesc')
>>
<<
Insert into ICONFIGURATION
   (ICONFIGURATIONID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, STRUCTNAME, STRUCTTRANSID, CONFIGNAME2, CNTVAL, CV_GROUPBUTTONS)
 Values
   (1002110000000, 'F', 0, 'admin', TO_DATE('03/01/2019 16:12:00', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('03/01/2019 15:50:48', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Form Elements', 'mainrepo', 'groupbtns', '0', 'Custom Actions-adddc,act1,fillg,genmap,mdmaps,callws,deletesc')
>>
<<
Insert into ICONFIGURATIONDTL
   (ICONFIGURATIONDTLID, ICONFIGURATIONID, ICONFIGURATIONDTLROW, GROUPBTNNAME, GROUPBUTTONS, TMPGROUP)
 Values
   (1002110000001, 1002110000000, 1, 'Custom Actions', 'adddc,act1,fillg,genmap,mdmaps,callws,deletesc', 'Custom Actions-adddc,act1,fillg,genmap,mdmaps,callws,deletesc~')
>>
<<
COMMIT
>>


<<
CREATE OR REPLACE FUNCTION count_dcs (p_transid varchar2) return VARCHAR2
is
    l_result varchar2(15);
begin
select listagg(b.name,', ') within group(order by stransid) dcs into l_result
  from axpdef_dc b
  where b.stransid =p_transid  ;
    return l_result;
end;
>>
<<
CREATE OR REPLACE FUNCTION GET_COLUMNS_NAME(p_selectQuery IN VARCHAR2) RETURN varchar IS
    v_cursor_id integer;
    v_col_cnt integer;
    v_column_new varchar2(1000);
    v_columns dbms_sql.desc_tab;
begin
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, p_selectQuery, dbms_sql.native);
    dbms_sql.describe_columns(v_cursor_id, v_col_cnt, v_columns);

    for i in 1 .. v_columns.count loop
    
    if i=1 then 
    v_column_new :=  v_columns(i).col_name;
    else
     v_column_new :=  v_column_new||','||v_columns(i).col_name;
    end if;
    
     --   pipe row(v_columns(i).col_name);
    end loop;

    dbms_sql.close_cursor(v_cursor_id);
    return  v_column_new;
exception when others then
    dbms_sql.close_cursor(v_cursor_id);
    raise;
end;
>>
<<
CREATE OR REPLACE FUNCTION GET_COLUMNS_NAMES(p_selectQuery IN VARCHAR2) RETURN varchar IS
    v_cursor_id integer;
    v_col_cnt integer;
    v_column_new varchar2(1000);
    v_columns dbms_sql.desc_tab;
    --p_selectQuery clob :=substr( p_selectQuery1,1, instr( p_selectQuery1, '{' ) -1 );
  
begin
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, p_selectQuery, dbms_sql.native);
    dbms_sql.describe_columns(v_cursor_id, v_col_cnt, v_columns);

    for i in 1 .. v_columns.count loop
    
    if i=1 then 
    v_column_new :=  v_columns(i).col_name;
    else
     v_column_new :=  v_column_new||','||v_columns(i).col_name;
    end if;
    
     --   pipe row(v_columns(i).col_name);
    end loop;

    dbms_sql.close_cursor(v_cursor_id);
    return  v_column_new;
exception when others then
    dbms_sql.close_cursor(v_cursor_id);
    raise;
end;
>>
<<
CREATE OR REPLACE FORCE VIEW axp_vw_menulist (menupath,
                                                        NAME,
                                                        ordno,
                                                        levelno,
                                                        PARENT,
                                                        TYPE,
                                                        pagetype
                                                       )
AS
   SELECT   menupath, NAME, ordno, levelno, PARENT, TYPE, pagetype
       FROM (SELECT     caption,
                        DECODE (LEVEL,
                                2, caption,
                                LPAD (' ', (LEVEL + levelno * 2) - 1)
                                || caption
                               ) AS menu_tree,
                        levelno, TYPE, pagetype,
                        SYS_CONNECT_BY_PATH (caption, '\') || '\' AS menupath,
                        ordno, PARENT, NAME
                   FROM axpages
                  WHERE blobno = 1
             START WITH PARENT IS NULL
             CONNECT BY PRIOR NAME = PARENT)
   ORDER BY ordno, menupath
>>
<<
CREATE OR REPLACE FORCE VIEW V_FILLGRID
(STRANSID, NAME, CAPTION, SQL_EDITOR_SQL, TARGETDC, 
 MULTISELECT, AUTOSHOW, SOURCEDC, VVALIDATE, EXECUTEONSAVE, 
 FIRMBIND, SELECTON, FOOTERSTRING, VALIDATEEXPRESSION, ADDROWS, 
 COLUMNPROPERTY, PURPOSE, MAPPINGDETAILS, GROUPFIELD, DCNAME, 
 AUTOSELECTALLROWS)
AS 
select a.STRANSID, a.NAME,a.CAPTION,a.SQL_EDITOR_SQL,a.TARGETDC,
 DECODE (a.multiselect, 'T', 'TRUE', 'FALSE') multiselect,
            DECODE (a.autoshow, 'T', 'TRUE', 'FALSE') autoshow,
            a.sourcedc sourcedc,
            DECODE (a.vvalidate, 'T', 'TRUE', 'FALSE') vvalidate,
            DECODE (a.executeonsave, 'T', 'TRUE', 'FALSE') executeonsave,
            DECODE (a.firmbind, 'T', 'TRUE', 'FALSE') firmbind,
a.SELECTON,a.FOOTERSTRING,a.exp_editor_validateexpression as validateexpression,a.ADDROWS,a.COLUMNPROPERTY,a.PURPOSE, 
listagg(b.sourcefield||','||b.sourcecaption||','||b.targetfield,'$') within group (order by 1)
 as mappingdetails,
a.GRPFIELD as groupfield,a.DCNAME, DECODE (a.AUTOSELECTALLROWS,'T', 'TRUE', 'FALSE') AUTOSELECTALLROWS
from axpdef_fillgrid a,axpdef_fillgriddtl b 
where a.AXPDEF_FILLGRIDID=b.AXPDEF_FILLGRIDID
--and a.STRANSID = :stransid
group by  a.NAME,a.CAPTION,a.SQL_EDITOR_SQL,a.TARGETDC,a.MULTISELECT,a.AUTOSHOW,a.VVALIDATE,a.EXECUTEONSAVE,a.FIRMBIND
,a.SOURCEDC,a.SELECTON,a.FOOTERSTRING,a.exp_editor_validateexpression,a.ADDROWS,a.COLUMNPROPERTY,a.PURPOSE,a.STRANSID,a.GRPFIELD,a.DCNAME,a.AUTOSELECTALLROWS
>>
<<
CREATE OR REPLACE FORCE VIEW V_GENMAP
(STRANSID, NAME, CAPTION, DCNAME, TARGETTSTRUCT, 
 BASEDONDC, CONTROLFIELDNAME, SCHEMAOFTARGET, ONPOST, PURPOSE, 
 ACTIVE, ONAPPROVE, ONREJECT, MAPPING, ROWCONTROL, 
 TARGETTRASID, GROUPFIELD)
AS 
select a.STRANSID,  a.name,a.caption,a.dcname,a.targettstruct,a.basedondc,
a.controlfieldname,a.schemaoftarget,a.onpost,a.purpose,DECODE (a.active,'T', 'TRUE','FALSE') active,DECODE (a.onapprove, 'T', 'TRUE', 'FALSE') onapprove,
 DECODE (a.onreject, 'T', 'TRUE', 'FALSE') onreject,
 listagg(b.sourcefrom|| ',' ||b.source||','||b.fsource||',' ||b.sourcedcasgrid||',' ||b.targetfield||','||b.targetrow,'$') within group (order by 1) as mapping,
 c.rtargetrow ||','||c.ROWCONTROLFIELD  rowcontrol ,a.TARGETTRASID,a.groupfield
 from axpdef_genmap a,axpdef_genmapdtl b,axpdef_genmaprowctrl c
where a.axpdef_genmapid = b.axpdef_genmapid(+)
and a.AXPDEF_GENMAPID = c.AXPDEF_GENMAPID(+)
group by a.name,a.caption,a.dcname,a.targettstruct,a.basedondc,a.STRANSID,
a.controlfieldname,a.schemaoftarget,a.onpost,a.purpose,a.active,a.onapprove,a.onreject,c.RTARGETROW,c.ROWCONTROLFIELD,a.TARGETTRASID,a.GROUPFIELD
>>
<<
CREATE OR REPLACE FORCE VIEW vw_dc (transid,
                                              NAME,
                                              caption,
                                              tablename,
                                              asgrid,
                                              allowchange,
                                              allowempty,
                                              adddcrows,
                                              deletedcrows,
                                              popup,
                                              purpose
                                             )
AS
   SELECT a.stransid transid, a.NAME, a.caption, a.tablename,
          DECODE (a.asgrid, 'F', 'FALSE', 'TRUE') asgrid,
          DECODE (a.allowchange, 'F', 'FALSE', 'TRUE') allowchange,
          DECODE (a.allowempty, 'F', 'FALSE', 'TRUE') allowempty,
          DECODE (a.adddcrows, 'F', 'FALSE', 'TRUE') adddcrows,
          DECODE (deletedcrows, 'F', 'FALSE', 'TRUE') deletedcrows,
          DECODE (popup, 'F', 'FALSE', 'TRUE') popup, a.purpose
     FROM axpdef_dc a
>>
<<
CREATE OR REPLACE FORCE VIEW VW_FIELD_INFORMATIONS
(SNO, TRANSID, DCNAME, NAME, CAPTION, 
 DATATYPE, CUSTOMDATATYPE, DATAWIDTH, FDECIMAL, MODEOFENTRY, 
 DETAIL, HIDDEN, ALLOWEMPTY, READONLY, SETCARRY, 
 SAVEVALUE, EXPRESSION, VALIDATEEXPRESSION, ALLOWDUPLICATE, ONLYPOSITIVE, 
 SOURCEKEY, CARRYFIELD, DISPLAYTOTAL, WINDOWWIDTH, WINDOWHEIGHT, 
 SQL, AUTOSELECT, REFRESH, LISTVALUES, PREFIX, 
 PREFIX_FIELDS, DESCRIPTION, START_NO, SACTIVE, NO_OF_DIGITS, 
 SAVENORMALIZED, SUGGESTIVE, SOURCEFIELD, SOURCE_TABLE, DATASOURCE, 
 SEQUENCE, TNAME, FROMTRANSID, SELECTFIELD, PARENT, 
 GUI, APPLYCOMMA, MASK, PATTERN, PASSWORD_CHARACTER, 
 HINT, CLIENTVALIDATION, SEARCH_SQL, DISPLAYDETAIL, TABSTOP, 
 SLEVENO, SORDNO, SOURCE, PURPOSE, CWIDTH, 
 LIST, SELECTFORM, FLDORDNO, TRACKCHANGES, TRACKCHANGESMADEBY, 
 SELECTEDUSERS, SELECTEDFIELDS, MASTER, COMBOBOX,COMPONENTTYPE,SEPERATOR)
AS 
SELECT DISTINCT                                /* Accept/Calculate Field */
          1 AS sno,
          a.stransid transid,
          a.DCNAME,
          a.NAME,
          a.CAPTION,
          a.DATATYPE,
          a.CUSTOMDATATYPE,
          a.DATAWIDTH,
          a.FDECIMAL,
          a.MODEOFENTRY,
          a.SQL_EDITOR_DETAIL detail,
          DECODE (a.hidden, 'T', 'TRUE', 'FALSE') hidden,
          DECODE (a.allowempty, 'T', 'TRUE', 'FALSE') allowempty,
          DECODE (a.readonly, 'T', 'TRUE', 'FALSE') readonly,
          DECODE (a.setcarry, 'T', 'TRUE', 'FALSE') setcarry,
          DECODE (a.savevale, 'T', 'TRUE', 'FALSE') savevalue,
          a.exp_editor_expression AS expression,
          a.exp_editor_validateexpression AS validateexpression,
          DECODE (a.allowduplicate, 'T', 'TRUE', 'FALSE') allowduplicate,
          DECODE (a.onlypositive, 'T', 'TRUE', 'FALSE') onlypositive,
          NULL AS sourcekey,
          NULL AS carryfield,
          NULL AS displaytotal,
          NULL AS windowwidth,
          NULL AS windowheight,
          NULL AS sql,
         DECODE ( a.AUTOSELECT, 'T', 'TRUE', 'FALSE') AUTOSELECT,
          DECODE (a.REFRESHONSAVE, 'F', 'FALSE','TRUE') refresh,
          NULL AS listvalues,
          NULL AS PREFIX,
          NULL AS PREFIX_FIELDS,
          NULL AS DESCRIPTION,
          NULL AS START_NO,
          'FALSE' AS sactive,
          NULL AS no_of_digits,
          'FALSE' AS savenormalized,
         DECODE ( a.SUGGESTIVE, 'T', 'TRUE', 'FALSE') SUGGESTIVE,
          NULL AS SOURCEFIELD,
          NULL AS source_table,
          NULL AS datasource,
          NULL AS SEQUENCE,
          NULL AS TNAME,
          NULL AS FROMTRANSID,
          NULL AS SELECTFIELD,
          NULL AS PARENT,
          NULL AS gui,
          DECODE (a.APPLYCOMMA, 'T', 'TRUE', 'FALSE') APPLYCOMMA,
          a.MASK,
          a.PATTERN,
          a.pwdchar AS password_character,
          a.hint,
          DECODE (a.CLIENVALIDATION, 'T', 'TRUE', 'FALSE') CLIENTVALIDATION,
          a.searchsql AS search_sql,
          a.DISPLAYDETAILS AS displaydetail,
          DECODE (a.TABSTOP, 'T', 'TRUE', 'FALSE') TABSTOP,
          m.SLEVENO,
          m.SORDNO,
          NULL AS source,
          a.PURPOSE,
          NULL AS cwidth,
          NULL AS LIST,
          NULL AS selectfrom,
          a.FLDORDNO,
          m.TRACKCHANGES,
          m.TRACKCHANGESMADEBY,
          m.SELECTEDUSERS,
          m.SELECTEDFIELDS,null as MASTER,
          'FALSE' as combobox,a.COMPONENTTYPE,a.separator
     FROM coretstructhdr a, tstruct_mst_details m
    WHERE a.CORETSTRUCTHDRID = m.sourceid
          AND a.MODEOFENTRY IN ('Accept', 'Calculate')
   UNION
   SELECT DISTINCT                                    /* AutoGenerate Field */
          2 AS sno,
          a.stransid transid,
          a.DCNAME,
          a.NAME,
          a.CAPTION,
          a.DATATYPE,
          a.CUSTOMDATATYPE,
          a.DATAWIDTH,
          a.FDECIMAL,
          a.MODEOFENTRY,
          a.SQL_EDITOR_DETAIL detail,
          DECODE (a.hidden, 'T', 'TRUE', 'FALSE') hidden,
          DECODE (a.allowempty, 'T', 'TRUE', 'FALSE') allowempty,
          DECODE (a.readonly, 'T', 'TRUE', 'FALSE') readonly,
          DECODE (a.setcarry, 'T', 'TRUE', 'FALSE') setcarry,
          DECODE (a.savevale, 'T', 'TRUE', 'FALSE') savevalue,
          a.exp_editor_expression AS expression,
          a.exp_editor_validateexpression AS validateexpression,
          DECODE (a.allowduplicate, 'T', 'TRUE', 'FALSE') allowduplicate,
          DECODE (a.onlypositive, 'T', 'TRUE', 'FALSE') onlypositive,
          NULL AS sourcekey,
          NULL AS carryfield,
          NULL AS displaytotal,
          NULL AS windowwidth,
          NULL AS windowheight,
          NULL AS sql,
          'FALSE' AS autoselect,
         'FALSE' refresh,
          NULL AS listvalues,
          ag.PREFIX,
          ag.PREFIXFIELD AS PREFIX_FIELDS,
          ag.DESCRIPTION,
          ag.STARTINGNO START_NO,
          DECODE (ag.ACTIVE, 'F', 'FALSE','TRUE')  AS sactive,
          ag.noofdigits no_of_digits,
          'FALSE' AS savenormalized,
          'FALSE' AS suggestive,
          NULL AS SOURCEFIELD,
          NULL AS source_table,
          NULL AS datasource,
          NULL AS SEQUENCE,
          NULL AS TNAME,
          NULL AS FROMTRANSID,
          NULL AS SELECTFIELD,
          NULL AS PARENT,
          NULL AS gui,
          DECODE (a.APPLYCOMMA, 'T', 'TRUE', 'FALSE') APPLYCOMMA,
          a.MASK,
          a.PATTERN,
          a.pwdchar AS password_character,
          a.hint,
          DECODE (a.CLIENVALIDATION, 'T', 'TRUE', 'FALSE') CLIENTVALIDATION,
          a.searchsql AS search_sql,
          a.DISPLAYDETAILS AS displaydetail,
          DECODE (a.TABSTOP, 'T', 'TRUE', 'FALSE') TABSTOP,
          m.SLEVENO,
          m.SORDNO,
          NULL AS source,
          a.PURPOSE,
          NULL AS cwidth,
          NULL AS LIST,
          NULL AS selectfrom,
          a.FLDORDNO,
          m.TRACKCHANGES,
          m.TRACKCHANGESMADEBY,
          m.SELECTEDUSERS,
          m.SELECTEDFIELDS,null as MASTER,
          'FALSE' as combobox,a.COMPONENTTYPE,a.separator
     FROM coretstructhdr a, coretstructdtlsauto ag, tstruct_mst_details m
    WHERE     a.CORETSTRUCTHDRID = m.SOURCEID
          AND a.CORETSTRUCTHDRID = ag.CORETSTRUCTHDRID
          AND a.MODEOFENTRY = 'AutoGenerate'
   UNION
     SELECT DISTINCT                              /* Select From List Field */
            3 AS sno,
            a.stransid transid,
            a.DCNAME,
            a.NAME,
            a.CAPTION,
            a.DATATYPE,
            a.CUSTOMDATATYPE,
            a.DATAWIDTH,
            a.FDECIMAL,
            a.MODEOFENTRY,
            a.SQL_EDITOR_DETAIL detail,
            DECODE (a.hidden, 'T', 'TRUE', 'FALSE') hidden,
            DECODE (a.allowempty, 'T', 'TRUE', 'FALSE') allowempty,
            DECODE (a.readonly, 'T', 'TRUE', 'FALSE') readonly,
            DECODE (a.setcarry, 'T', 'TRUE', 'FALSE') setcarry,
            DECODE (a.savevale, 'T', 'TRUE', 'FALSE') savevalue,
            a.exp_editor_expression AS expression,
            a.exp_editor_validateexpression AS validateexpression,
            DECODE (a.allowduplicate, 'T', 'TRUE', 'FALSE') allowduplicate,
            DECODE (a.onlypositive, 'T', 'TRUE', 'FALSE') onlypositive,
            NULL AS sourcekey,
            NULL AS carryfield,
            NULL AS displaytotal,
            NULL AS windowwidth,
            NULL AS windowheight,
            NULL AS sql,
            'FALSE' AS AUTOSELECT,
            'FALSE' refresh,
            listagg (l.listofvalues, ',')
               WITHIN GROUP (order by case when   l.listofvalues  IN ('YES' ,'T','TRUE','yes','t','true') THEN '01' WHEN  l.listofvalues IN ('NO','F','FALSE','no','f','false') THEN '02' ELSE l.listofvalues  END) 
               AS listvalues,
            NULL AS PREFIX,
            NULL AS PREFIX_FIELDS,
            NULL AS DESCRIPTION,
            NULL AS START_NO,
            'FALSE' AS sactive,
            NULL AS no_of_digits,
            'FALSE' AS savenormalized,
            'FALSE' AS suggestive,
            NULL AS SOURCEFIELD,
            NULL AS source_table,
            NULL AS datasource,
            NULL AS SEQUENCE,
            NULL AS TNAME,
            NULL AS FROMTRANSID,
            NULL AS SELECTFIELD,
            NULL AS PARENT,
            NULL AS gui,
            DECODE (a.APPLYCOMMA, 'T', 'TRUE', 'FALSE') APPLYCOMMA,
            a.MASK,
            a.PATTERN,
            a.pwdchar AS password_character,
            a.hint,
            DECODE (a.CLIENVALIDATION, 'T', 'TRUE', 'FALSE') CLIENTVALIDATION,
            a.searchsql AS search_sql,
            a.DISPLAYDETAILS AS displaydetail,
            DECODE (a.TABSTOP, 'T', 'TRUE', 'FALSE') TABSTOP,
            m.SLEVENO,
            m.SORDNO,
            NULL AS source,
            a.PURPOSE,
            NULL AS cwidth,
            NULL AS LIST,
            NULL AS selectfrom,
            a.FLDORDNO,
            m.TRACKCHANGES,
            m.TRACKCHANGESMADEBY,
            m.SELECTEDUSERS,
            m.SELECTEDFIELDS,null as MASTER,
            'FALSE' as combobox,a.COMPONENTTYPE,a.separator
       FROM coretstructhdr a, coretstructdtls l, tstruct_mst_details m
      WHERE     a.CORETSTRUCTHDRID = m.sourceid
            AND a.CORETSTRUCTHDRID = l.CORETSTRUCTHDRID
            AND a.MODEOFENTRY = 'Select From List'
   GROUP BY a.stransid,m.SORDNO,
            a.DCNAME,
            a.NAME,
            a.CAPTION,
            a.DATATYPE,
            a.CUSTOMDATATYPE,
            a.DATAWIDTH,
            a.FDECIMAL,
            a.MODEOFENTRY,
            a.SQL_EDITOR_DETAIL,
            a.HIDDEN,
            a.ALLOWEMPTY,
            a.ALLOWDUPLICATE,
            a.READONLY,
            a.exp_editor_expression,
            a.exp_editor_validateexpression,
            a.SETCARRY,
            a.SAVEVALE,
            a.ONLYPOSITIVE,
            APPLYCOMMA,
            mask,
            pattern,
            hint,
            pwdchar,
            a.CLIENVALIDATION,
            a.searchsql,
            a.DISPLAYDETAILS,
            a.TABSTOP,
            sleveno,
            a.purpose,
            a.FLDORDNO,
            m.TRACKCHANGES,
            m.TRACKCHANGESMADEBY,
            m.SELECTEDUSERS,
            m.SELECTEDFIELDS,
            a.COMPONENTTYPE,a.separator
   UNION
   SELECT DISTINCT                                /* Select From Form Field */
          4 AS sno,
          a.stransid transid,
          a.DCNAME,
          a.NAME,
          a.CAPTION,
          a.DATATYPE,
          a.CUSTOMDATATYPE,
          a.DATAWIDTH,
          a.FDECIMAL,
          a.MODEOFENTRY,
          a.SQL_EDITOR_DETAIL detail,
          DECODE (a.hidden, 'T', 'TRUE', 'FALSE') hidden,
          DECODE (a.allowempty, 'T', 'TRUE', 'FALSE') allowempty,
          DECODE (a.readonly, 'T', 'TRUE', 'FALSE') readonly,
          DECODE (a.setcarry, 'T', 'TRUE', 'FALSE') setcarry,
          DECODE (a.savevale, 'T', 'TRUE', 'FALSE') savevalue,
          a.exp_editor_expression AS expression,
          a.exp_editor_validateexpression AS validateexpression,
          DECODE (a.allowduplicate, 'T', 'TRUE', 'FALSE') allowduplicate,
          DECODE (a.onlypositive, 'T', 'TRUE', 'FALSE') onlypositive,
          'TRUE' AS sourcekey,
          NULL AS carryfield,
          NULL AS displaytotal,
          a.WINDOWWIDTH_FORM windowwidth,
          a.WINDOWHEIGHT_FORM windowheight,
          a.sql_editor_sqltextform AS sql,
          DECODE (a.AUTOSELECT_FORM, 'T', 'TRUE', 'FALSE')  AS autoselect,
          DECODE (a.REFRESHONSAVE_FORM, 'F',  'FALSE','TRUE')  refresh,
          NULL AS listvalues,
          NULL AS PREFIX,
          NULL AS PREFIX_FIELDS,
          NULL AS DESCRIPTION,
          NULL AS START_NO,
          'FALSE' AS sactive,
          NULL AS no_of_digits,
          DECODE (a.SAVENORMALIZED_FORM, 'T', 'TRUE', 'FALSE')  AS savenormalized,
          'FALSE' AS SUGGESTIVE,
          NULL AS SOURCEFIELD,
          a.tname  AS source_table,
          a.DATASOURCE_FORM AS datasource,
          NULL AS SEQUENCE,
          NULL AS TNAME,
          a.FROMTRANSID FROMTRANSID,
          a.SELECTFIELD,
          NULL AS PARENT,
          NULL AS gui,
          DECODE (a.APPLYCOMMA, 'T', 'TRUE', 'FALSE') APPLYCOMMA,
          a.MASK,
          a.PATTERN,
          a.pwdchar AS password_character,
          a.hint,
          DECODE (a.CLIENVALIDATION, 'T', 'TRUE', 'FALSE') CLIENTVALIDATION,
          a.searchsql AS search_sql,
          a.DISPLAYDETAILS AS displaydetail,
          DECODE (a.TABSTOP, 'T', 'TRUE', 'FALSE') TABSTOP,
          m.SLEVENO,
          m.SORDNO,
          NULL AS source,
          a.PURPOSE,
          NULL AS cwidth,
          NULL AS LIST,
          NULL AS selectfrom,
          a.FLDORDNO,
          m.TRACKCHANGES,
          m.TRACKCHANGESMADEBY,
          m.SELECTEDUSERS,
          m.SELECTEDFIELDS,null as MASTER,
          DECODE (a.COMBOBOX_FORM, 'T', 'TRUE', 'FALSE')  as combobox,a.COMPONENTTYPE,a.separator
     FROM coretstructhdr a, tstruct_mst_details m
    WHERE a.CORETSTRUCTHDRID = m.sourceid
          AND a.MODEOFENTRY = 'Select From Form'
   UNION
      SELECT DISTINCT                                 /* Select From Sql Field */
          5 AS sno,
          a.stransid transid,
          a.DCNAME,
          a.NAME,
          a.CAPTION,
          a.DATATYPE,
          a.CUSTOMDATATYPE,
          a.DATAWIDTH,
          a.FDECIMAL,
          a.MODEOFENTRY,
          a.SQL_EDITOR_DETAIL detail,
          DECODE (a.hidden, 'T', 'TRUE', 'FALSE') hidden,
          DECODE (a.allowempty, 'T', 'TRUE', 'FALSE') allowempty,
          DECODE (a.readonly, 'T', 'TRUE', 'FALSE') readonly,
          DECODE (a.setcarry, 'T', 'TRUE', 'FALSE') setcarry,
          DECODE (a.savevale, 'T', 'TRUE', 'FALSE') savevalue,
          a.exp_editor_expression AS expression,
          a.exp_editor_validateexpression AS validateexpression,
          DECODE (a.allowduplicate, 'T', 'TRUE', 'FALSE') allowduplicate,
          DECODE (a.onlypositive, 'T', 'TRUE', 'FALSE') onlypositive,
          case when a.SAVENORMALIZED = 'T' Then 'TRUE' Else 'FALSE' END AS sourcekey,
           NULL AS carryfield,
          NULL AS displaytotal,
          a.WINDOWWIDTH windowwidth,
          a.WINDOWHEIGHT windowheight,
          a.sql_editor_test AS sql,
           DECODE (a.AUTOSELECT_SQL, 'T', 'TRUE', 'FALSE')   AS autoselect,
           DECODE (a.REFRESHONSAV ,'T', 'TRUE', 'FALSE')   refresh,
          NULL AS listvalues,
          NULL AS PREFIX,
          NULL AS PREFIX_FIELDS,
          NULL AS DESCRIPTION,
          NULL AS START_NO,
          'FALSE' AS sactive,
          NULL AS no_of_digits,
          DECODE (a.SAVENORMALIZED, 'T', 'TRUE', 'FALSE')  AS savenormalized,
          'FALSE' AS SUGGESTIVE,
          a.SOURCEFIELD,
          a.sourcetable AS source_table,
          a.DATASOURCE,
          NULL AS SEQUENCE,
          NULL AS TNAME,
          NULL AS FROMTRANSID,
          NULL AS selectfield,
          NULL AS PARENT,
          NULL AS gui,
          DECODE (a.APPLYCOMMA, 'T', 'TRUE', 'FALSE') APPLYCOMMA,
          a.MASK,
          a.PATTERN,
          a.pwdchar AS password_character,
          a.hint,
          DECODE (a.CLIENVALIDATION, 'T', 'TRUE', 'FALSE') CLIENTVALIDATION,
          a.searchsql AS search_sql,
          a.DISPLAYDETAILS AS displaydetail,
          DECODE (a.TABSTOP, 'T', 'TRUE', 'FALSE') TABSTOP,
          m.SLEVENO,
          m.SORDNO,
          NULL AS source,
          a.PURPOSE,
          NULL AS cwidth,
          NULL AS LIST,
          a.SELECTFORM_ AS selectfrom,
          a.FLDORDNO,
          m.TRACKCHANGES,
          m.TRACKCHANGESMADEBY,
          m.SELECTEDUSERS,
          m.SELECTEDFIELDS,null as MASTER,
          DECODE (a.COMBOBOX_SQL, 'T', 'TRUE', 'FALSE')  as combobox,a.COMPONENTTYPE,a.separator
     FROM coretstructhdr a, tstruct_mst_details m
    WHERE a.CORETSTRUCTHDRID = m.sourceid
          AND a.MODEOFENTRY = 'Select From Sql'
             UNION
   SELECT                                         /* Select From Fill Field */
         6 AS sno,
          a.stransid transid,
          a.DCNAME,
          a.NAME,
          a.CAPTION,
          a.DATATYPE,
          a.CUSTOMDATATYPE,
          a.DATAWIDTH,
          a.FDECIMAL,
          a.MODEOFENTRY,
          a.SQL_EDITOR_DETAIL detail,
          DECODE (a.hidden, 'T', 'TRUE', 'FALSE') hidden,
          DECODE (a.allowempty, 'T', 'TRUE', 'FALSE') allowempty,
          DECODE (a.readonly, 'T', 'TRUE', 'FALSE') readonly,
          DECODE (a.setcarry, 'T', 'TRUE', 'FALSE') setcarry,
          DECODE (a.savevale, 'T', 'TRUE', 'FALSE') savevalue,
          a.exp_editor_expression AS expression,
          a.exp_editor_validateexpression AS validateexpression,
          DECODE (a.allowduplicate, 'T', 'TRUE', 'FALSE') allowduplicate,
          DECODE (a.onlypositive, 'T', 'TRUE', 'FALSE') onlypositive,
          NULL AS sourcekey,
          NULL AS carryfield,
          NULL AS displaytotal,
          NULL AS windowwidth,
          NULL AS WINDOWHEIGHT,
          NULL AS sql,
          'FALSE' AS autoselect,
          'FALSE' refresh,
          NULL AS listvalues,
          NULL AS PREFIX,
          NULL AS PREFIX_FIELDS,
          NULL AS DESCRIPTION,
          NULL AS START_NO,
          'FALSE' AS sactive,
          NULL AS no_of_digits,
          'FALSE' AS savenormalized,
           DECODE ( a.SUGGESTIVE_FILL, 'T', 'TRUE', 'FALSE')   AS SUGGESTIVE,
          NULL AS SOURCEFIELD,
          NULL AS source_table,
          NULL AS DATASOURCE,
          NULL AS SEQUENCE,
          NULL AS TNAME,
          NULL AS FROMTRANSID,
          NULL AS selectfield,
          NULL AS PARENT,
          NULL AS gui,
          DECODE (a.APPLYCOMMA, 'T', 'TRUE', 'FALSE') APPLYCOMMA,
          a.MASK,
          a.PATTERN,
          a.pwdchar AS password_character,
          a.hint,
          DECODE (a.CLIENVALIDATION, 'T', 'TRUE', 'FALSE') CLIENTVALIDATION,
          a.searchsql AS search_sql,
          a.DISPLAYDETAILS AS displaydetail,
          DECODE (a.TABSTOP, 'T', 'TRUE', 'FALSE') TABSTOP,
          m.SLEVENO,
          m.SORDNO,
          a.source AS source,
          a.PURPOSE,
          NULL AS cwidth,
          NULL AS LIST,
          NULL AS selectfrom,
          a.FLDORDNO,
          m.TRACKCHANGES,
          m.TRACKCHANGESMADEBY,
          m.SELECTEDUSERS,
          m.SELECTEDFIELDS,a.MASTER,
          'FALSE' as combobox,a.COMPONENTTYPE,a.separator
     FROM coretstructhdr a, tstruct_mst_details m
    WHERE a.CORETSTRUCTHDRID = m.sourceid AND a.MODEOFENTRY = 'Fill'
>>
<<
CREATE OR REPLACE FORCE VIEW vw_mdmap (stransid,
                                                 NAME,
                                                 caption,
                                                 extended,
                                                 mastertransaction,
                                                 masterfield,
                                                 mastersearchfield,
                                                 detailsearchfield,
                                                 mastertable,
                                                 updatetype,
                                                 controlfield,
                                                 append,
                                                 initondel,
                                                 maptext,
                                                 detailfield,
                                                 onapprove,
                                                 onreject,
                                                 purpose,
                                                 dcname,
                                                 ctdc,
                                                 ctmd
                                                )
AS
   SELECT   a.stransid, a.NAME, a.caption,
            DECODE (a.extended, 'T', 'TRUE', 'FALSE') extended,
            a.mastertransaction, a.masterfield, a.mastersearchfield,
            a.detailsearchfield, a.mastertable, a.updatetype, a.controlfield,
            DECODE (a.append, 'T', 'TRUE', 'FALSE') append,
            DECODE (a.initondel, 'T', 'TRUE', 'FALSE') initondel, a.maptext,
            a.detailfield,
            DECODE (a.onapprove, 'T', 'TRUE', 'FALSE') onapprove,
            DECODE (a.onreject, 'T', 'TRUE', 'FALSE') onreject, a.purpose,
            a.dcname, a.ctdc, a.ctmd
       FROM axpdef_mdmap a
      WHERE a.ctdc IS NOT NULL
   ORDER BY a.NAME
>>
<<
CREATE OR REPLACE FORCE VIEW vw_tstruct_mst_details (ord,
                                                               sourcetype,
                                                               mastertransid,
                                                               soucecaption,
                                                               sourcedetails,
                                                               sourcerules,
                                                               sleveno,
                                                               sordno,
                                                               tstruct_mst_detailsid,
                                                               sourceid,
                                                               sourcetransid,
                                                               sourcename,
                                                               ptransid,
                                                               linkurl,
                                                               dcname
                                                              )
AS
   SELECT 1 AS ord, s.sourcetype, s.mastertransid, s.soucecaption,
          s.sourcedetails, s.sourcerules, s.sleveno, s.sordno,
          s.tstruct_mst_detailsid, s.sourceid, s.sourcetransid, s.sourcename,
          't' || s.sourcetransid ptransid,
/*--'<a target= "axpiframe" href= ivtstload.aspx?tstname='||sourcetransid||CHR (38)||'recordid='||sourceid||CHR (38)||'hltype=load'||CHR (38)||'torecid=false >View Detail</a> '||
case when s.sourcetype='Tstruct' then '<a target= "axpiframe"   href= ivtstload.aspx?tstname=mntst'||CHR (38)||'stransid='||MASTERTRANSID||''||CHR (38)||'hltype=open'||CHR (38)||'torecid=false> Add Field</a><br>'  end
||case when s.sourcetype='Tstruct' then '<a target= "axpiframe" href= ivtstload.aspx?tstname=ad__d'||CHR (38)||'stransid='||MASTERTRANSID||''||CHR (38)||'hltype=open'||CHR (38)||'torecid=false > Add Frame</a><br>'  end
||case when s.sourcetype='Tstruct' then '<a target= "axpiframe" href= ivtstload.aspx?tstname=ad_fg'||CHR (38)||'stransid='||MASTERTRANSID||''||CHR (38)||'hltype=open'||CHR (38)||'torecid=false > Add Fillgrid</a><br>'  end
||case when s.sourcetype='Tstruct' then '<a target= "axpiframe" href= ivtstload.aspx?tstname=ad_ge'||CHR (38)||'stransid='||MASTERTRANSID||''||CHR (38)||'hltype=open'||CHR (38)||'torecid=false > Add Genmap</a><br>'  end
||case when s.sourcetype='Tstruct' then '<a target= "axpiframe" href= ivtstload.aspx?tstname=ad_md'||CHR (38)||'stransid='||MASTERTRANSID||''||CHR (38)||'hltype=open'||CHR (38)||'torecid=false > Add MDmap</a>'  end
--||'<a target= "axpiframe" href= tstruct.aspx?act=open'||CHR (38)||'transid=mntst'||chr(38)||'stransid='||MASTERTRANSID||''||' > Add Field</a>'
--||'<a  target= "axpiframe"  onclick="ActButtonClick(''btn_act1'','''',''Current Row'');" id="btn_act1" title="Add Field2 " class="action handCur l2" href="javascript:__doPostBack(''btn_act1'','''')">Add Field2 </a>'
--||'<a  target= "axpiframe"  href="javascript:callHLaction(''prvpdf'',''1'',''mainrepo'');" > View PDF</a>'
*/
          NULL AS linkurl, s.dcname
     FROM tstruct_mst_details s
>>
<<
CREATE OR REPLACE FORCE VIEW  vw_tstructs (transid,
                                                       caption,
                                                       purpose,
                                                       savecontrol,
                                                       deletecontrol,
                                                       trackchanges,
                                                       attachment,
                                                       listview,
                                                       workflow,
                                                       "SCHEMA",
                                                       isacoretrans,
                                                       menuposition,
                                                       menulist,
                                                       selectfieldlist,
                                                       selectuserlist,
                                                       trackchangesmadeby,
                                                       trackchangesfield,
                                                       layouttype
                                                      )
AS
   SELECT a.ntransid transid, a.caption, a.purpose,
          a.savecontrolfield savecontrol, a.deletecontrolfield deletecontrol,
          a.trackchanges, a.attachment, a.listview, a.workflow, a."SCHEMA",
          DECODE (a.isacoretrans, 'Yes', 'No', 'Yes') isacoretrans,
          a.menuposition, a.menulist, a.selectfieldlist, a.selectuserlist,
          a.trackchangesmadeby, a.trackchangesfield,a.LAYOUTTYPE
     FROM axpdef_tstruct a
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, 
    CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, 
    PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, 
    ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS)
 Values
   (1657440000021, 'F', 0, 'admin', TO_DATE('03/06/2019 03:38:23 PM', 'DD/MM/YYYY HH:MI:SS AM'), 
    'admin', TO_DATE('03/06/2019 03:36:12 PM', 'DD/MM/YYYY HH:MI:SS AM'), 1, 1, 'Save Image in DB', 
    'SaveImage', 'configtypeSave Image in DB', 'Tstruct', 'F', 'F', 
    'T', 'F', 'F', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1657440000022, 1657440000021, 1, 'true')
>>
<<
COMMIT
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
     insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property','FetchSize')
	>>
  <<
     insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property','General')
	>>
  <<
   Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'SaveImage')
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
   ('File Upload Limit', 'Property')
>>
<<
Insert into AXCTX1
   (AXCONTEXT, ATYPE)
 Values
   ('camera option', 'Property')
>>
<<
 Insert into AXCTX1
   (AXCONTEXT, ATYPE)
 Values ('Date format','Property')
>>
<<
commit
>>

----Advance Settings
<<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (1540330000000, 'F', 0, 'admin', TO_DATE('01/03/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('01/03/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Disablesplit', 'All', 'Disablesplit', 'true', 'true', 'Forms(Forms)', 'Forms', 'Iview', 'ALL', 'DisablesplitFormstrueALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (1540440000000, 'F', 0, 'admin', TO_DATE('01/03/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('01/03/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Load reports/lists along with form', 'Iview', 'Autosplit', 'true', 'true', 'Form Elements(mainrepo)', 'mainrepo', 'Iview', 'ALL', 'Load reports/lists along with formmainrepotrueALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STRUCTELEMENTS, SBUTTON, STYPE, USERROLES, DUPCHK)
 Values
   (1540770000000, 'F', 0, 'admin', TO_DATE('01/03/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('01/03/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Open Window mode', 'All', 'Navigation', 'newpage', 'newpage', 'Forms(Forms)', 'Forms', 'opentstr', 'opentstr', 'Iview', 'ALL', 'Open Window modeFormsnewpageALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (1573550000000, 'F', 0, 'admin', TO_DATE('01/10/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('01/10/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Disablesplit', 'All', 'Disablesplit', 'true', 'true', 'Advance Settings(axstc)', 'axstc', 'Tstruct', 'ALL', 'DisablesplitaxstctrueALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STRUCTELEMENTS, SBUTTON, STYPE, USERROLES, DUPCHK)
 Values
   (1108880000000, 'F', 0, 'admin', TO_DATE('03/26/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('03/26/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Open Window mode', 'All', 'Navigation', 'newpage', 'newpage', 'Form Elements(mainrepo)', 'mainrepo', 'deletesc', 'deletesc', 'Iview', 'ALL', 'Open Window modemainreponewpageALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STRUCTELEMENTS, SBUTTON, STYPE, USERROLES, DUPCHK)
 Values
   (1109010000000, 'F', 0, 'admin', TO_DATE('03/26/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('03/26/2019 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Open Window mode', 'All', 'Navigation', 'newpage', 'newpage', 'Form Elements(mainrepo)', 'mainrepo', 'callws', 'callws', 'Iview', 'ALL', 'Open Window modemainreponewpageALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (1058330000000, 'F', 0, 'admin', TO_DATE('05/17/2019 08:14:58', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('05/17/2019 08:14:58', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Tstruct Grid edit option', 'Tstruct', 'GridEdit', 'inline', 'inline', 'ALL Forms', 'ALL Forms', 'Tstruct', 'ALL', 'Tstruct Grid edit optionALL FormsinlineALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPVALUE2, PROPSVAL, STRUCTNAME, USERROLES, DUPCHK)
 Values
   (1237660000000, 'F', 0, 'admin', TO_DATE('06/07/2019 21:00:43', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('05/28/2019 16:47:19', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Landing Structure', 'All', 'General', 'general', 'Leixirnew.aspx', 'general', 'Leixir.aspx', 'Doctor', 'Landing StructureLeixir.aspxgeneralDoctor')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (1799550000000, 'F', 0, 'admin', TO_DATE('06/08/2019 00:00:28', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('06/08/2019 00:00:28', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'FetchSize', 'All', 'FetchSize', '25', '25', 'ALL Reports', 'ALL Reports', 'Iview', 'ALL', 'FetchSizeALL Reports25ALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (1386770000002, 'F', 0, 'admin', TO_DATE('06/05/2019 07:33:56', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('06/05/2019 07:33:41', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Save Image in DB', 'Tstruct', 'SaveImage', 'true', 'true', 'My Profile(dprof)', 'dprof', 'Tstruct', 'ALL', 'Save Image in DBdproftrueALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (2038330000000, 'F', 0, 'admin', TO_DATE('07/05/2019 08:28:05', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('07/05/2019 08:28:05', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'File upload limit', 'Tstruct', 'File Upload Limit', '1', '1', 'ALL Forms', 'ALL Forms', 'Tstruct', 'ALL', 'File upload limitALL Forms1ALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (2176010000000, 'F', 0, 'admin', TO_DATE('07/04/2019 02:37:12', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('06/29/2019 12:40:28', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Hide Camera Option', 'Tstruct', 'camera option', 'true', 'true', 'ALL Forms', 'ALL Forms', 'Tstruct', 'ALL', 'Hide Camera OptionALL FormstrueALL')
   >>
   <<
COMMIT
>>

---Configuration Property

   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1000550000003, 'F', 0, 'admin', TO_DATE('12/27/2018 12:53:08', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:41:34', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Load forms along with list', 'Autosplit', 'configtypeLoad forms along with list', 'Tstruct', 'F', 'F', 'T', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1000550000006, 'F', 0, 'admin', TO_DATE('12/27/2018 12:53:02', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:41:56', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Load reports/lists along with form', 'Autosplit', 'configtypeLoad reports/lists along with form', 'Iview', 'F', 'F', 'F', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1000550000009, 'F', 0, 'admin', TO_DATE('12/27/2018 12:42:23', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:42:23', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Disablesplit', 'Disablesplit', 'configtypeDisablesplit', 'All', 'F', 'F', 'T', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1000550000012, 'F', 0, 'admin', TO_DATE('12/27/2018 12:48:34', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:43:19', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Open Window mode', 'Navigation', 'configtypeOpen Window mode', 'All', 'T', 'T', 'F', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1040440000000, 'F', 0, 'admin', TO_DATE('04/10/2019 14:34:39', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/10/2019 13:01:39', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Tstruct Grid edit option', 'GridEdit', 'configtypeTstruct Grid edit option', 'Tstruct', 'F', 'F', 'T', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1903990000000, 'F', 0, 'admin', TO_DATE('01/23/2019 12:24:30', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('01/23/2019 12:24:30', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Align Text', 'Text', 'configtypeAlign Text', 'Tstruct', 'F', 'F', 'T', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1751880000000, 'F', 0, 'admin', TO_DATE('04/05/2019 11:31:42', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/05/2019 11:31:42', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Main Page Reload', 'General', 'configtypeMain Page Reload', 'Tstruct', 'F', 'F', 'T', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1742550000002, 'F', 0, 'admin', TO_DATE('04/03/2019 18:31:43', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/03/2019 18:31:43', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Change Password', 'General', 'configtypeChange Password', 'All', 'F', 'F', 'T', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1742550000005, 'F', 0, 'admin', TO_DATE('05/28/2019 16:46:25', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/03/2019 18:32:27', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Landing Structure', 'General', 'configtypeLanding Structure', 'All', 'F', 'F', 'F', 'T', 'T', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1742550000008, 'F', 0, 'admin', TO_DATE('06/07/2019 22:22:44', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('04/03/2019 18:34:26', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'FetchSize', 'FetchSize', 'configtypeFetchSize', 'All', 'F', 'F', 'F', 'T', 'T', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1790770000000, 'F', 0, 'pandi', TO_DATE('04/12/2019 17:38:13', 'MM/DD/YYYY HH24:MI:SS'), 'pandi', TO_DATE('04/12/2019 17:38:13', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Local Dataset', 'Lds', 'configtypeLocal Dataset', 'Tstruct', 'F', 'F', 'T', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1104220000000, 'F', 0, 'admin', TO_DATE('02/25/2019 15:35:10', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('02/25/2019 14:56:19', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'FormLoad Cache', 'FormLoad', 'configtypeFormLoad Cache', 'Tstruct', 'F', 'F', 'T', 'F', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (2680010000000, 'F', 0, 'admin', TO_DATE('06/13/2019 14:32:57', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('06/13/2019 14:32:57', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Date Format', 'General', 'configtypeDate Format', 'All', 'F', 'F', 'F', 'T', 'T', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (2175770000001, 'F', 0, 'admin', TO_DATE('07/04/2019 02:36:20', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('06/29/2019 12:39:56', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Hide Camera Option', 'camera option', 'configtypeHide Camera Option', 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (2037880000001, 'F', 0, 'admin', TO_DATE('07/05/2019 08:27:42', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('07/05/2019 08:27:42', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'File upload limit', 'File Upload Limit', 'configtypeFile upload limit', 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'T')
   >>
   <<

   COMMIT
   >>
--SET DEFINE OFF;
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000004, 1000550000003, 1, 'True')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000005, 1000550000003, 2, 'False')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000007, 1000550000006, 1, 'True')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000008, 1000550000006, 2, 'False')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000010, 1000550000009, 1, 'True')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000011, 1000550000009, 2, 'False')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000013, 1000550000012, 1, 'Default')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000014, 1000550000012, 2, 'Popup')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000015, 1000550000012, 3, 'Newpage')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1000550000016, 1000550000012, 4, 'Split')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000003, 1742550000002, 1, 'Disable')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000004, 1742550000002, 2, 'Enable')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000007, 1742550000005, 2, 'iview')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000006, 1742550000005, 1, 'tstruct')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000010, 1742550000008, 2, '30')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000028, 1742550000008, 20, '5000')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000027, 1742550000008, 19, '2000')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000026, 1742550000008, 18, '1000')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000009, 1742550000008, 1, '25')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000029, 1742550000008, 21, 'ALL')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000011, 1742550000008, 3, '35')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000012, 1742550000008, 4, '40')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000013, 1742550000008, 5, '45')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000014, 1742550000008, 6, '50')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000015, 1742550000008, 7, '55')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000016, 1742550000008, 8, '60')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000017, 1742550000008, 9, '65')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000018, 1742550000008, 10, '70')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000019, 1742550000008, 11, '75')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000020, 1742550000008, 12, '80')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000021, 1742550000008, 13, '85')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000022, 1742550000008, 14, '90')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000023, 1742550000008, 15, '95')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000024, 1742550000008, 16, '100')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000025, 1742550000008, 17, '500')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1751880000001, 1751880000000, 1, 'true')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1751880000002, 1751880000000, 2, 'false')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1903990000001, 1903990000000, 1, 'Right')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1903990000002, 1903990000000, 2, 'Left')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1790770000002, 1790770000000, 2, 'false')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1040440000001, 1040440000000, 1, 'Inline')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1040440000002, 1040440000000, 2, 'Popup')
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
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1237550000000, 1742550000005, 3, 'general')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1657440000022, 1657440000021, 1, 'true')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1386770000001, 1386770000000, 1, 'true')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1787880000005, 1742550000008, 22, '10')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (2680010000001, 2680010000000, 1, 'en-US')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (2175770000002, 2175770000001, 1, 'true')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (2037880000002, 2037880000001, 1, '1')
   >>

<<
   insert into axctx1(axcontext,atype) values ('Multi Select','Property')
   >>
   <<
   INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,
app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields) VALUES 
(1008440000004,'F',0,NULL,'admin',TO_DATE('12/27/2018 12:53:08','MM/DD/YYYY HH24:MI:SS'),'admin',TO_DATE('12/27/2018 12:41:34', 'MM/DD/YYYY HH24:MI:SS'),
NULL,1,1,NULL,NULL,NULL,'Multi Select Field',
'Multi Select','configtypeMulti Select Field',NULL,'Tstruct','F','F','T','F','T','T')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES 
(1008440000005,1008440000004,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES 
(1008440000006,1008440000004,2,'false')
>>
<<
update axpstructconfig set purpose='Enable/Disable to trim spaces in iview data' where asprops ='Trim IView Data'
>>
<<
update axpstructconfig set purpose='Page Size number of Iview data to be loaded' where asprops ='FetchSize'
>>
<<
update axpstructconfig set purpose='.html templete to customize AxpertWeb Application UI' where asprops ='ApplicationTemplate'
>>
<<
update axpstructconfig set purpose='Google Maps registered API key created by particular project' where asprops ='Google Maps Api Key'
>>
<<
update axpstructconfig set purpose='Enable split on tstruct and load along with listview' where asprops ='Load forms along with list'
>>
<<
update axpstructconfig set purpose='Load template to customize home page widgets' where asprops ='HomePageTemplate'
>>
<<
update axpstructconfig set purpose='Enable/Disable to inline grid or popup grid' where asprops ='Tstruct Grid edit option'
>>
<<
update axpstructconfig set purpose='Enable/Disable change password option for cloud application' where asprops ='Change Password'
>>
<<
update axpstructconfig set purpose='To avoid tstruct formload service call' where asprops ='FormLoad Cache'
>>
<<
update axpstructconfig set purpose='Cloud application can customize tstruct/iview to load the first time and can set the parameters' where asprops ='Main Page Reload'
>>
<<
update axpstructconfig set purpose='Enable split on iview and open/load the tstruct on the first hyperlink' where asprops ='Load reports/lists along with form'
>>
<<
update axpstructconfig set purpose='To disable split to the application or page wise' where asprops ='Disablesplit'
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Resolve Attachment Path')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS)
 Values
   (1072550000003, 'F', 0, 'superadmin', 
    TO_DATE('01/31/2020 10:39:14', 'MM/DD/YYYY HH24:MI:SS'), 'superadmin', TO_DATE('01/31/2020 10:39:14', 'MM/DD/YYYY HH24:MI:SS'), 1, 
    1, 'Resolve Attachment Path', 
    'Resolve Attachment Path', 'configtypeResolve Attachment Path', 'Iview', 'F', 'F', 'F', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS)
 Values
   (1072550000000, 'F', 0, 'superadmin', 
    TO_DATE('01/31/2020 10:19:35', 'MM/DD/YYYY HH24:MI:SS'), 'superadmin', TO_DATE('01/31/2020 10:19:35', 'MM/DD/YYYY HH24:MI:SS'), 1, 
    1, 'Global Parameter Form', 
    'General', 'configtypeGlobal Parameter Form', 'Tstruct', 'F', 'F', 'T', 'F', 'T', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS)
 Values
   (1072550000006, 'F', 0, 'superadmin', 
    TO_DATE('01/31/2020 10:54:25', 'MM/DD/YYYY HH24:MI:SS'), 'superadmin', TO_DATE('01/31/2020 10:54:24', 'MM/DD/YYYY HH24:MI:SS'), 1, 
    1, 'Google Maps Api Key', 
    'General', 'configtypeGoogle Maps Api Key', 'Tstruct', 'F', 'F', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1072550000001, 1072550000000, 1, 'hide')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1072550000002, 1072550000000, 2, 'show')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1072550000004, 1072550000003, 1, 'false')
>>
<<
Insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1072550000005, 1072550000003, 2, 'true')
>>
<<
ALTER TABLE AXUSERS ADD (singleloginkey VARCHAR2(50))
>>
<<
ALTER TABLE AX_PAGE_SAVED ADD WIDGET_GROUPS Varchar2(1)
>>
<<
ALTER TABLE AX_PAGES ADD WIDGET_GROUPS Varchar2(1)
>>
<<
 update axpstructconfigprops set description= configprops where description is null
>>
<<
 insert into axctx1 (axcontext,atype) values ('Custom JavaScript','Property');
>>
<<
 insert into axctx1 (axcontext,atype) values ('Custom CSS','Property')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235660000010,'F',0,NULL,'superadmin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Custom CSS','Custom CSS','configtypeCustom CSS','','All','F','F','T','T','F','F','Reports:
Use this property to attach custom CSS to Reports. Set this property value to "True" for a selected report. If for report this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.CSS. In case this property is set to true for all reports instead of a selected report, the file name should be custom.CSS.

Tstructs:
Use this property to attach custom CSS to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.CSS. In case this property is set to true for all forms instead of a selected form, the file name should be custom.CSS.
')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235440000043,'F',0,NULL,'superadmin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Custom JavaScript','Custom JavaScript','configtypeCustom JavaScript','','All','F','F','T','T','F','F','Reports:
Use this property to attach custom javascript to Reports/forms. Set this property value to "true" for a selected report. If this property is set to true, the custom javascript file for Reposts should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.js. In case this property is set to true for all reports instead of a selected report, the file name should be custom.js

Tstructs:
Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1235440000044,1235440000043,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1235440000045,1235440000043,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1235660000011,1235660000010,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1235660000012,1235660000010,2,'false')
>>
<<
insert into axctx1 (axcontext,atype) values('Auto Save Draft','Property')
>>
<<
insert into axctx1 (axcontext,atype) values('Grid Scrollbar','Property')
>>
<<
insert into axctx1 (axcontext,atype) values('Show keyboard in Hybrid App','Property')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000009,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Grid Scrollbar','Grid Scrollbar','configtypeGrid Scrollbar',NULL,'Tstruct','F','F','T','F','F','F','If key is set to true,then if grid dc is there for the tstruct,then horizontal scroll bar will be fixed at the bottom of the page.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000006,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Auto Save Draft','Auto Save Draft','configtypeAuto Save Draft',NULL,'Tstruct','F','F','T','F','F','F','If key is set to true and time in millisecs(for ex for 60 secs give 60000 . Note: default time will be 120 seconds/2 minutes if no time is set) then on loading tstruct,it will check if unsaved data is there, if unsaved data  exists it will throw a popup with yes /no buttons.If yes, it will load the unsaved data else it will load a new tstruct.If new tstruct is opened for which key exists,then only if any field is changed,it will push data in redis after the mentioned time  in developer options at regular intervals.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000003,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Show keyboard in Hybrid App','Show keyboard in Hybrid App','configtypeShow keyboard in Hybrid App',NULL,'Tstruct','F','F','T','F','F','F','An enhancement to make an intuitive UI in Axpert Hybrid App i.e., 
-- based on the "Show keyboard in Hybrid App" key value, user can enable or disable the keyboard for autocomplete fields in tstruct level.
-- By default, value is set as true which makes no difference in the existing feature/functionality.
-- If set false,  keyboard is hidden/disabled along with the drop-down and clear icons. On single click of the field, drop down appears to choose the desired value.
')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1355440000004,1355440000003,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1355440000005,1355440000003,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1355440000007,1355440000006,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1355440000008,1355440000006,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1355440000010,1355440000009,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1355440000011,1355440000009,2,'false')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES 
(1635440000037,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Enforced Strong Password Policy','General','configtypeEnforced Strong Password Policy',NULL,'Common','F','F','F','F','F','F','If key is set to true,Strong Password Policy will work.Details for Enforced Strong Password Policy: Password should be alphanumeric, contains one UpperCharacter, one LowerCharacter with atleast one special character.It will check the following condition if key set to true and if password entered is not matching the condition,then it will throw error.')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES 
(1635440000038,1635440000037,1,'true')
>>
<<
commit
>>
<< 
INSERT INTO axctx1 (axcontext,atype) values ('Mobile Reports as Table','Property') 
>>
<< 
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984880000036,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'Notification Time Interval','General','configtypeNotification Time Interval',NULL,'All','F','F','T','T','F','F','Notification feature can be enabled at Application level by adding Developer Option "Notification Time Interval" , with values in minutes for time intervals as 1, 2, 3 , 4 etc. Once this key is added, long running web services/backend scheduled jobs completion can be notified to the user with given time intervals, so that user would be able to do other operations during long running web services/backend jobs.') 
>>
<< 
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984440000004,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'User Manual','General','configtypeUser Manual',NULL,'All','F','F','T','T','F','F','User can able to access the files through web application which is saved in local folder through User Manual option (located in right sidebar menu)') 
>>
<<
 INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984220000001,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'Mobile Reports as Table','Mobile Reports as Table','configtypeMobile Reports as Table',NULL,'All','F','F','T','T','F','F','Administrator can enable tabular view in mobile instead of cards view') 
>>


<< 
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1984220000002,1984220000001,1,'true') 
>>
<< 
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1984220000003,1984220000001,2,'false') 
>>
<< 
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1984440000005,1984440000004,1,'true') 
>>
<< 
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1984440000006,1984440000004,2,'false') 
>>
<< 
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1984880000037,1984880000036,1,'1') 
>>
<< 
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1984880000038,1984880000036,2,'3') 
>>
<< 
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1984880000039,1984880000036,3,'5') 
>>
<< 
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1984880000040,1984880000036,4,'10') 
>>
<< 
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1984880000041,1984880000036,5,'30') 
>>
<<
create table Axp_TransCheck(sessionid varchar2(50))
>>
<<
INSERT INTO axctx1 (axcontext,atype) values ('Iview Button Style','Property') 
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES 
(1226220000004,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'Iview Button Style','Iview Button Style','configtypeIview Button Style','','Iview','F','F','F','T','F','F','New Iview buttons UI can be switched as Modern(Google like UI) / Classic(Classic Bootstrap like UI) . Product default Iview Button UI is  "Modern" Style.')
>>
<<
INSERT INTO AXPSTRUCTCONFIGPROVAL (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) 
VALUES (1226220000005,1226220000004,1,'Modern')
>>
<<
INSERT INTO AXPSTRUCTCONFIGPROVAL (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) 
VALUES (1226220000006,1226220000004,2,'Classic')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) 
VALUES (1251990000026,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'Show Image Widget Action Button','General','configtypeShow Image Widget Action Button',NULL,'Common','F','F','T','T','T','F','The SmartView''s columns template can be changed to achieve desired UI and Actions')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1251990000027,1251990000026,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1251990000028,1251990000026,2,'false')
>> 
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1420440000004,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'Show Application Menu on Login','General','configtypeShow Application Menu on Login',NULL,'All','F','F','T','T','F','F','Application menu can be shown/hidden by setting this Developer Option.')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1420440000005,1420440000004,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1420440000006,1420440000004,2,'false')
>>
<<
update axpstructconfigprops set ptype='All',alltstructs='T',alliviews='T' WHERE PTYPE='Iview' and configprops<>'Load reports/lists along with form'
>>
<<
CREATE OR REPLACE VIEW VW_CARDS_CALENDAR_DATA
(UNAME,AXCALENDARID,EVENTNAME,SENDERNAME,MESSAGETEXT,EVENTTYPE,STARTDATE,AXPTM_STARTTIME,ENDDATE,AXPTM_ENDTIME,LOCATION,STATUS)
AS
SELECT DISTINCT a.uname,
a.axcalendarid,
a.eventname,
a.sendername,
CAST(a.messagetext AS varchar2(4000)) messagetext,
a.eventtype,
a.startdate,
nvl(a.axptm_starttime, '00:00') AS axptm_starttime,
a.enddate,
CASE
WHEN nvl(a.axptm_endtime, '00:00') = '00:00' THEN '23:59'
ELSE a.axptm_endtime
END AS axptm_endtime,
a.location,
a.status
FROM axcalendar a
WHERE a.cancel = 'F' AND a.parenteventid > 0
UNION ALL
SELECT DISTINCT a.sendername AS uname,
a.axcalendarid,
a.eventname,
a.sendername,
CAST(a.messagetext AS varchar2(4000)) messagetext,
a.eventtype,
a.startdate,
nvl(a.axptm_starttime, '00:00') AS axptm_starttime,
CASE
WHEN a.recurring IS NULL THEN a.enddate
ELSE a.startdate
END AS enddate,
CASE
WHEN nvl(a.axptm_endtime, '00:00') = '00:00'THEN '23:59'
ELSE a.axptm_endtime
END AS axptm_endtime,
a.location,
a.status
FROM axcalendar a
WHERE a.cancel= 'F' AND a.parenteventid = 0
ORDER BY 7;
>>
<<
INSERT INTO AXPDEF_AXPERTPROPS 
(AXPDEF_AXPERTPROPSID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,SMTPHOST,SMTPPORT,SMTPUSER,SMTPPWD,AXPSITENO,AMTINMILLIONS,CURRSEPERATOR,LASTLOGIN,AUTOGEN,CUSTOMFROM,
CUSTOMTO,LOGINATTEMPT,PWDEXP,PWDCHANGE,PWDMINCHAR,PWDREUSE,PWDALPHANUM,PWDENCRYPT)
VALUES(1,'F',0,NULL,'admin',TIMESTAMP '2022-01-14 11:05:15.000000','admin',TIMESTAMP '2022-01-14 11:05:15.000000',
NULL,1,1,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'F','F','T','F',NULL,NULL,0,0,0,0,0,'F','F');
>>