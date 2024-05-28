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
alter table AXPSTRUCTCONFIGPROPS add cfields varchar2(1) default 'F'
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



