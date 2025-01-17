<<
alter table axpstructconfig add purpose varchar(1000)
>>
<<
ALTER TABLE AXUSERS ADD cancelremarks VARCHAR(300)
>>
<<
ALTER TABLE AXUSERS ADD axusersid numeric(15)
>>
<<
ALTER TABLE AXUSERS ADD cancel VARCHAR(10)
>>
<<
alter table ax_widget add is_public varchar(1) DEFAULT 'N'
>>
<<
ALTER TABLE AXUSERS ADD sourceid numeric(15)
>>
<<
alter table axusers alter column pwd type varchar(20)
>>
<<
ALTER TABLE axusergroups ADD axusergroupsid NUMERIC(15)
>>
<<
ALTER TABLE AXUSERGROUPS ADD cancel VARCHAR(10)
>>
<<
ALTER TABLE AXUSERGROUPS ADD sourceid numeric(15)
>>
<<
ALTER TABLE AXUSERGROUPS ADD cancelremarks VARCHAR(150)
>>
<<
ALTER TABLE AXUSERLEVELGROUPS ADD axusersid NUMERIC(15)
>>
<<
ALTER TABLE AXUSERLEVELGROUPS ADD axuserlevelgroupsid NUMERIC(15)
>>
<<
ALTER TABLE  AXDSIGNCONFIG add rolename varchar(60)
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
CREATE OR REPLACE FUNCTION fn_axuserlevelgroups() RETURNS TRIGGER
AS $axuserlevelgroups$
    
    BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN
		
		NEW.USERNAME  = NEW.axUSERNAME ;
		NEW.usergroup = NEW.axusergroup ;
		
		return new;
	end if;
		
	IF (TG_OP = 'UPDATE') THEN
		
		NEW.USERNAME  = NEW.axUSERNAME ;
		NEW.usergroup = NEW.axusergroup ;
		
		return new;
	end if;
end; 
$axuserlevelgroups$ LANGUAGE plpgsql;
>>
<<
create trigger TRG_axuserlevelgroups 
Before insert or update on axuserlevelgroups  
for each row

execute procedure fn_axuserlevelgroups();

end;
>>
<<
CREATE OR REPLACE FUNCTION fn_axusers() RETURNS TRIGGER
AS $axusers$
    
    BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN
		
		NEW.USERNAME  = NEW.PUSERNAME ;
		NEW.PASSWORD = NEW.PPASSWORD ;
		
		return new;
	end if;
		
		IF (TG_OP = 'UPDATE') THEN
		
		NEW.USERNAME  = NEW.PUSERNAME ;
		
		return new;
	end if;
end; 
$axusers$ LANGUAGE plpgsql;
>>
<<
create trigger TRG_AXUSERS 
before insert or update on axusers  
for each row

execute procedure fn_axusers();

end;
>>
<<
DROP TABLE AXP_MAILJOBS CASCADE
>>
<<
CREATE TABLE AXP_MAILJOBS
(
  MAILTO             VARCHAR(1000),
  MAILCC             VARCHAR(1000),
  SUBJECT            VARCHAR(1000),
  BODY               TEXT,
  RECIPIENTCATEGORY  VARCHAR(500),
  ENQUIRYNO          VARCHAR(30),
  ATTACHMENTS        VARCHAR(1000),
  IVIEWNAME          VARCHAR(10),
  IVIEWPARAMS        VARCHAR(500),
  TRANSID            VARCHAR(10),
  RECORDID           NUMERIC(16),
  STATUS             NUMERIC(2),
  ERRORMESSAGE       VARCHAR(500),
  SENTON             DATE,
  JOBID              NUMERIC(15),
  JOBDATE            DATE
)
>>
<<
ALTER TABLE AXP_MAILJOBS ADD column jobdate DATE 
>>
<<
CREATE SEQUENCE AXP_MAILJOBSID
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;
>>
<<
CREATE OR REPLACE FUNCTION fn_AXP_MAILJOBS() RETURNS TRIGGER
AS $AXP_MAILJOBS$
	declare 
	v_sid numeric(15);
    
    BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN 
		
		select nextval('AXP_MAILJOBSID') into v_sid; 
		
		NEW.jobid = v_sid;
		
		return new;
	end if;
		
end; 
$AXP_MAILJOBS$ LANGUAGE plpgsql;
>>
<<
CREATE OR REPLACE FUNCTION fn_axpmailjobs() RETURNS TRIGGER
AS $AXP_MAILJOBS$
	declare 
	v_sid numeric(15);
    
    BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN 
		
		select nextval('AXP_MAILJOBSID') into v_sid; 
		
		NEW.jobid = v_sid;
		
		return new;
	end if;
		
end; 
$AXP_MAILJOBS$ LANGUAGE plpgsql;
>>
<<
drop table AXUSRHISTORY
>>
<<
CREATE TABLE AXUSRHISTORY
(
  RECORDID       NUMERIC(16),
  MODIFIEDDATE   DATE,
  USERNAME       VARCHAR(30),
  FIELDNAME      VARCHAR(30),
  OLDVALUE       VARCHAR(250),
  NEWVALUE       VARCHAR(250),
  ROWNO          NUMERIC(38),
  DELFLAG        VARCHAR(1),
  MODNO          NUMERIC(10),
  FRAMENO        NUMERIC(10),
  PARENTROW      NUMERIC(10),
  TABLERECID     NUMERIC(16),
  IDVALUE        NUMERIC(16),
  OLDIDVALUE     NUMERIC(16),
  TRANSDELETED   VARCHAR(5),
  NEWTRANS       VARCHAR(5),
  CANCELTRANS    VARCHAR(1),
  CANCELREMARKS  VARCHAR(250)
)
>>
<<
CREATE TABLE USAGEDTL
(
  EXECUTEDDATE  DATE,
  CODE          VARCHAR(20),
  TITLE         VARCHAR(50),
  CNT           NUMBER(18)
)
<<
create trigger TRG_axpmailjobs 
before insert on AXP_MAILJOBS   
for each row

execute procedure fn_axpmailjobs();

end;
>>
<<
ALTER TABLE axsms ADD createdon date
>>
<<
CREATE SEQUENCE AXsmsID
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;
>>
<<
CREATE OR REPLACE FUNCTION fn_axsms() RETURNS TRIGGER
AS $axsms$
	declare 
	v_sid numeric(15);
    
    BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN 
		
		select nextval('AXsmsID') into v_sid; 
		
		NEW.RECORDID = v_sid;
		
		return new;
	end if;
end; 
$axsms$ LANGUAGE plpgsql;
>>
<<
create trigger TRG_axsms 
before insert on axsms   
for each row

execute procedure fn_axsms();

end;
>>
<<
CREATE TABLE USAGEDTL
(
  EXECUTEDDATE  DATE,
  CODE          VARCHAR(20),
  TITLE         VARCHAR(50),
  CNT           NUMERIC(18)
)
>>
<<
CREATE TABLE AXPEXCEPTION
(
  EXP_DATE       DATE,
  STRUCTNAME     VARCHAR(16),
  SERVICENAME    VARCHAR(50),
  SERVICERESULT  VARCHAR(500),
  COUNT          NUMERIC
)
>>
<<
CREATE TABLE ut_timetaken
(
   executed_date   DATE,
   object_type     VARCHAR(10),
   service_name    VARCHAR(100),
   object_name     VARCHAR(100),
   tot_count       NUMERIC(10),
   count_8s        NUMERIC(10),
   count_30s       NUMERIC(10),
   count_90s       NUMERIC(10),
   min_time        NUMERIC(10, 2),
   max_time        NUMERIC(10, 2),
   avg_time        NUMERIC(10, 2)
)
>>
<<
DROP TABLE AXCONSTRAINTS CASCADE
>>
<<
CREATE TABLE AXCONSTRAINTS
(
  AXCONSTRAINTSID  numeric,
  CANCEL           VARCHAR(1),
  SOURCEID         numeric,
  MAPNAME          VARCHAR(20),
  USERNAME         VARCHAR(50),
  MODIFIEDON       DATE,
  CREATEDBY        VARCHAR(50),
  CREATEDON        DATE,
  WKID             VARCHAR(15),
  APP_LEVEL        NUMERIC(3),
  APP_DESC         NUMERIC(1),
  APP_SLEVEL       NUMERIC(3),
  CANCELREMARKS    VARCHAR(150),
  WFROLES          VARCHAR(250),
  CONSTRAINT_NAME  VARCHAR(50),
  MSG              VARCHAR(1000)
)
>>

<<
CREATE OR REPLACE VIEW AX_OUTBOUND_STATUS
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
          cast(a.senton as date) senton,
          cast(a.senton as date) outdate,
          a.transid,
          b.caption tstructname,
          CASE WHEN senton IS NULL THEN 'Pending' ELSE 'Sent' END outstatus
     FROM outbound a, tstructs b
    WHERE a.transid = b.name
>>
<<
CREATE OR REPLACE  VIEW AX_INBOUND_STATUS
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
          cast(a.recdon as date) recdon,
          cast(recdon as date) indate,
          transid,
          caption tstructname,
          instatus
     FROM inbound a, tstructs b
    WHERE a.transid = b.name
>>
<<
CREATE OR REPLACE FUNCTION join_comma(
	p_cursor refcursor,
	p_del character varying DEFAULT ','::character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare
    l_value   varchar(32767);
    l_result  varchar(32767);
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
$BODY$;

>>
<<
create or replace FUNCTION         is_number(p_value VARCHAR)
RETURNS numeric 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
Declare 
v_num NUMERIC;
BEGIN
v_num:=cast(p_value as numeric);
RETURN 1;
EXCEPTION
WHEN OTHERS THEN
RETURN 0;
END; $BODY$;
>>
<<
CREATE OR REPLACE FUNCTION random_number(
	)
    RETURNS numeric
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
   v_num   numeric (20);
BEGIN
   SELECT ROUND (random() * (9999999-1111111) + 1111111)
          || TO_CHAR (now(), 'DDDSSSS')
             AS rno
     INTO v_num
     FROM DUAL;
   RETURN v_num;
END;
$BODY$;
>>
------ axpertlog analysis report
<<
CREATE OR REPLACE Function pro_axplogstatextract (fdate DATE)
RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
   ------ usage details
   delete from usagedtl  where executeddate=fdate;
   INSERT INTO usagedtl (executeddate,
                         code,
                         title,
                         cnt)
        SELECT cast(calledon as date) cdate,
               'NOT' CODE,
               'Total No. of Transactions' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE cast(calledon as date) = fdate 
      GROUP BY cast(calledon as date)
      UNION ALL
        SELECT cast(calledon as date) cdate,
               'NOL' CODE,
               'Total No. of Logins' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE cast(calledon as date) = fdate AND servicename = 'Login'
      GROUP BY cast(calledon as date)
      UNION ALL
        SELECT cast(calledon as date) cdate,
               'NOU' CODE,
               'Total No. of Users' title,
               COUNT (DISTINCT username) cnt
          FROM axpertlog
         WHERE cast(calledon as date) = fdate AND servicename = 'Login'
      GROUP BY cast(calledon as date)
      UNION ALL
        SELECT cast(calledon as date) cdate,
               'NOD' CODE,
               'Total No. of Deadlock Execptions' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE cast(calledon as date) = fdate
               AND serviceresult LIKE 'trans%dead%'
      GROUP BY cast(calledon as date)
      UNION ALL
        SELECT cast(calledon as date) cdate,
               'MTJ' CODE,
               'More time taken Saves (> 8 Sec)' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE     cast(calledon as date) = fdate
               AND servicename = 'saving data'
               AND serviceresult = 'success'
               AND recordid = 0
               AND (timetaken / 1000) > 8
      GROUP BY cast(calledon as date)
      UNION ALL
        SELECT cast(calledon as date) cdate,
               'MTL' CODE,
               'More time taken Loads (> 8 Sec)' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE     cast(calledon as date) = fdate 
               AND servicename = 'load data'
               AND serviceresult = 'success'
               AND (timetaken / 1000) > 8
      GROUP BY cast(calledon as date)
      UNION ALL
      SELECT cast(calledon as date) cdate,
             'MTL' CODE,
             'More time taken reports (> 8 Sec)' title,
             COUNT (*) cnt
        FROM axpertlog
       WHERE     cast(calledon as date) = fdate 
             AND servicename = 'Get IView'
             AND serviceresult = 'success'
             AND (timetaken / 1000) > 8
GROUP BY cast(calledon as date);

   ----- exceptions
    delete from axpexception   where exp_date = fdate;
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
         WHERE SERVICERESULT <> 'success' AND calledon = fdate
      GROUP BY calledon,
               structname,
               servicename,
               serviceresult;

   ----- time taken
    delete from ut_timetaken  where executed_date=fdate;
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
        SELECT cast(SYSDATE as date) exec_date,
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
               AND cast(calledon as date) = cast(fdate as date)
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
        SELECT cast(SYSDATE as date) exec_date,
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
               AND cast(calledon as date) = cast(fdate as date)
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
        SELECT cast(SYSDATE as date) exec_date,
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
               AND cast(calledon as date) = cast(fdate as date)
      GROUP BY b.caption;

END;$BODY$; 
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
CREATE OR REPLACE FUNCTION pro_emailformat(ptemplate character varying, pkeyword character varying, ptype character varying, psendto character varying, psendcc character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 
v_subject varchar(3500);
v_body varchar(3500);
v_sms  varchar(3500);
v_count numeric(5);
v_keyword varchar(350);
v_keyvalue varchar(1000);
i varchar(3500);
begin

select count(*) into v_count from  sendmsg
 where lower(template) = lower( ptemplate);
 
if v_count=1 then
 
 select MSGSUBJECT,MSGCONTENT,SMSMSG into v_subject,v_body,v_sms from sendmsg
 where lower(template) = lower( ptemplate);
 
for i in (select regexp_split_to_table(pkeyword,',') as vkeyword from dual)
loop

v_keyword := SUBSTR(i.vkeyword, 1 ,INSTR(i.vkeyword, '=', 1, 1)-1);

v_keyvalue :=  SUBSTR( i.vkeyword, INSTR( i.vkeyword,'=', 1, 1)+1);

v_subject := replace(v_subject,v_keyword,v_keyvalue);

v_body := replace(v_body,v_keyword,v_keyvalue);

v_sms := replace(v_sms,v_keyword,v_keyvalue);
end loop;

if ptype='S' then

insert into axsms(createdon,mobileno,msg,status) values ( now() :: timestamp without time zone,psendto,v_sms,0);

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
     VALUES (psendto,psendcc,v_subject ,v_body,null,null,null,0,null,null,now() :: timestamp without time zone );



end if;
end if;
end ; 
$function$
; 
>>
-- script runner
<<
CREATE OR REPLACE Function pr_bulkexecute(pintext  varchar,pintrg varchar) 
RETURNS void
    LANGUAGE 'plpgsql'

AS $BODY$
Declare 
v_rowcount numeric(15) :=0;
v_trgdis varchar(500)  := 'ALTER TRIGGER '||pintrg||'  DISABLE';
v_trgena varchar(500) := 'ALTER TRIGGER '||pintrg||'  ENABLE';
begin

if pintrg = 'NA' then
  EXECUTE  pintext;
else
  EXECUTE v_trgdis;
  EXECUTE pintext;
  EXECUTE v_trgena;
end if;

end; $BODY$;
>>

<<
CREATE OR REPLACE FUNCTION fn_AXPSCRIPTRUNNER() RETURNS TRIGGER
AS $AXPSCRIPTRUNNER$
	DECLARE
   v_trg varchar(100) := coalesce( new.trg_name, 'NA');
    
    BEGIN

        -- Work out the increment/decrement amount(s).
        select pr_bulkexecute(new.SCRIPT_TEXT,v_trg);
		
end; 
$AXPSCRIPTRUNNER$ LANGUAGE plpgsql;
>>

<<
create trigger trg_AXPSCRIPTRUNNER 
after insert on AXPSCRIPTRUNNER   
for each row

execute procedure fn_AXPSCRIPTRUNNER();

end;
>>

<<
CREATE OR REPLACE FUNCTION fn_UPDATDSIGN() RETURNS TRIGGER
AS $AXDSIGNCONFIG$
	BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN 
		
		NEW.USERNAME = NEW.PUSERNAME; 
		new.rolename = new.prolename;
		
		return new;
	end if;
		
	IF (TG_OP = 'UPDATE') THEN 
		
		NEW.USERNAME = NEW.PUSERNAME; 
		new.rolename = new.prolename;
		
		return new;
	end if;
		
end; 
$AXDSIGNCONFIG$ LANGUAGE plpgsql;
>>
<<
create trigger TRG_UPDATDSIGN  
before insert or update on AXDSIGNCONFIG    
for each row

execute procedure fn_UPDATDSIGN();

end;
>>
<<
DECLARE
  X NUMERIC;
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
INSERT INTO axpages VALUES ('PageIvauditlog', 'Audit Log', '<root visible="T" type="p" defpage="T" name="PageIvauditlog" caption="Audit Log"
 createdon="26/08/2019 10:14:38" createdby="admin" importedon="" importedby="" updatedon="26/08/2019 10:48:53" updatedby="admin" img="" ordno="33" levelno="2" 
 parent="Head18" pgtype="iauditlog" updusername=""><Container6 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" 
 st="view__auditlog"/><view__auditlog cat="iview" name="auditlog" parent="Container6" align="Client"/></root>', 1, NULL, 'T', 'p', 
'Head18', 33, 2, '26/08/2019 10:48:53', '26/08/2019 10:14:38', NULL, 'admin', 'admin', NULL, NULL, NULL, NULL, 'iauditlog', NULL, NULL, NULL)
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
update axpages set UPDATEDON = cast( now() as date ) ,CREATEDON= cast( now() as date ) ;
>>

<<
CREATE OR REPLACE Function SP_RAPIDDEFINITION (ITid VARCHAR) 
	RETURNS refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare 
	ORes1 refcursor;
	ORes2 refcursor;
    Qry1 VARCHAR(2000);
    Qry2 VARCHAR(2000);
BEGIN
	-- Qry1 will fetch the 'Form Load' fields and their params.
    Qry1 := 'SELECT a.context, a.fieldname, c.expression, a.fldsql as fldsql, coalesce(b.paramname,'''') as paramname 
              FROM axp_formload a 
              LEFT JOIN axp_params b on b.tstruct = '''||ITid||''' and a.fieldname = b.childfield and b.context = ''new'' and b.active = ''T'' 
              INNER JOIN  axpflds c on c.tstruct = '''||ITid||''' and a.fieldname=c.fname 
              WHERE a.tstruct = '''||ITid||''' and a.active=''T'' and a.context = ''new'' ';
			  
	-- Qry2 will fetch all dependents and all parents of fields and fillgrids. (Includes the parents of all dependents and parents of all parents)
    Qry2 := 'SELECT a.parentfield, a.childfield, a.dependenttype, coalesce(b.paramname,'''') as paramname,    
              coalesce(b.allrows,''F'') as allrows, coalesce(b.dirparam,''F'') as dirparam, c.frmno, c.ordno FROM axp_dependent a 
              LEFT JOIN axp_params b on b.tstruct = '''||ITid||''' and a.parentfield = b.childfield and b.context = ''dep'' and b.active = ''T''
              JOIN axpflds c on c.tstruct = '''||ITid||''' and a.childfield=c.fname 
              WHERE a.tstruct = '''||ITid||'''
              UNION
              SELECT distinct par.paramname parentfield, dep1.childfield, ''g'' as dependenttype, coalesce(b.paramname,'''') as paramname, ''F'' as allrows, ''F'' as dirparam, flds.frmno,flds.ordno  
              FROM axp_dependent dep1
              JOIN (select paramname, childfield from axp_params par where par.tstruct = '''||ITid||''' and par.context = ''fg'') par on par.childfield = dep1.parentfield
              JOIN axp_dependent dep2 on dep2.tstruct = '''||ITid||'''  and dep2.parentfield = par.paramname and dep2.dependenttype = ''g''
              JOIN axp_params b on b.tstruct = '''||ITid||''' and par.childfield = b.childfield and b.context = ''fg'' and b.active = ''T''
              JOIN axpflds flds on flds.tstruct = '''||ITid||''' and dep1.childfield = flds.fname
              WHERE dep1.tstruct = '''||ITid||'''
              ORDER BY frmno asc, ordno asc ';   
			  
    Return ORes1;
	Return ORes2;
END;
$BODY$;
>>
<<
CREATE SEQUENCE ax_homebuild_saved_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;
>>
<<
CREATE OR REPLACE FUNCTION fn_HOMEBUILD_SAVED_bir() RETURNS TRIGGER
AS $AX_HOMEBUILD_SAVED$
declare 
v_sid numeric(15);

	BEGIN
	select nextval('ax_homebuild_saved_seq') into v_sid ; 

        IF (TG_OP = 'INSERT') THEN 
		
		NEW.HOMEBUILD_ID = v_sid;
		
		return new;
	end if;
end; 
$AX_HOMEBUILD_SAVED$ LANGUAGE plpgsql;
>>
<<
create trigger AX_HOMEBUILD_SAVED_bir   
before insert on AX_HOMEBUILD_SAVED    
for each row

execute procedure fn_HOMEBUILD_SAVED_bir();

end;
>>
<<
CREATE OR REPLACE FUNCTION fn_AX_HOMEBUILD_MASTER() RETURNS TRIGGER
AS $AX_HOMEBUILD_MASTER$
declare 
v_sid numeric(15);

	BEGIN
	select nextval('ax_homebuild_master_seq') into v_sid ; 

        IF (TG_OP = 'INSERT') THEN 
		
		NEW.HOMEBUILD_ID = v_sid;
		
		return new;
	end if;
end; 
$AX_HOMEBUILD_MASTER$ LANGUAGE plpgsql;
>>
<<
create trigger AX_HOMEBUILD_MASTER_bir   
before insert on AX_HOMEBUILD_MASTER    
for each row

execute procedure fn_AX_HOMEBUILD_MASTER();

end;
>>
<<
CREATE SEQUENCE ax_widg_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;
>>
<<

CREATE OR REPLACE FUNCTION fn_AX_WIDGET() RETURNS TRIGGER
AS $AX_WIDGET$
declare 
v_sid numeric(15);

	BEGIN
	select nextval('ax_widg_seq') into v_sid ; 

        IF (TG_OP = 'INSERT') THEN 
		
		NEW.widget_id = v_sid;
		
		return new;
	end if;
end; 
$AX_WIDGET$ LANGUAGE plpgsql;
>>
<<
create trigger ax_widget_bir   
before insert on AX_WIDGET    
for each row

execute procedure fn_AX_WIDGET();

end;
>>
<<
CREATE TABLE AX_HOMEBUILD_RESPONSIBILITY
(
HOMEBUILD_ID numeric REFERENCES AX_HOMEBUILD_MASTER(HOMEBUILD_ID) ON DELETE CASCADE,
RESPONSIBILITY VARCHAR(255),
RESPONSIBILITY_ID numeric
)
>>
<<
CREATE TABLE AX_HOMEBUILD_SD_RESPONSIBILITY
(
HOMEBUILD_ID numeric REFERENCES AX_HOMEBUILD_SAVED(HOMEBUILD_ID) ON DELETE CASCADE,
RESPONSIBILITY VARCHAR(255),
RESPONSIBILITY_ID numeric
)
>>
<<
CREATE TABLE AX_WIDGET_RESPONSIBILITY
(
WIDGET_ID numeric REFERENCES AX_WIDGET(WIDGET_ID) ON DELETE CASCADE,
RESPONSIBILITY VARCHAR(255),
RESPONSIBILITY_ID numeric 
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
// 10.2.1 Notification for workFlow & Tstruct Designer
<<
CREATE TABLE AX_NOTIFY(
    NOTIFICATION_ID NUMERIC(10,0) primary key,
    TITLE VARCHAR(255),
    MESSAGE TEXT,
    ACTIONS TEXT,
    FROMUSER VARCHAR(255),
    BROADCAST VARCHAR(1) DEFAULT 'N',
    STATUS VARCHAR(255),
    CREATED_BY VARCHAR(255),
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    PURGE_ON_FIRST_ACTION VARCHAR(1) DEFAULT 'N',
    NOTIFICATION_SENT_DATETIME TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    RECORDID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
)
>>
<<
CREATE SEQUENCE ax_notify_seq 
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1
>>
<<
CREATE OR REPLACE FUNCTION fn_AX_NOTIFY() RETURNS TRIGGER
AS $AX_NOTIFY$
declare 
v_sid numeric(15);

	BEGIN
		select nextval('ax_notify_seq') into v_sid ; 

        IF (TG_OP = 'INSERT') THEN 
		
		NEW.NOTIFICATION_ID = v_sid;
		
		return new;
	end if;
end; 
$AX_NOTIFY$ LANGUAGE plpgsql;
>>
<<
create trigger AX_NOTIFY_bir   
before insert on AX_NOTIFY     
for each row

execute procedure fn_AX_NOTIFY();

end;
>>
<<
CREATE TABLE AX_NOTIFY_WORKFLOW(
    NOTIFICATION_ID NUMERIC(10),
    RECORDID VARCHAR(255),
    APP_LEVEL VARCHAR(2),
    APP_DESC VARCHAR(2),
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
)
>>
<<
CREATE TABLE AX_MOBILE_RESPONSE(
    NOTIFICATION_ID NUMERIC(10,0),
    USER_ID VARCHAR(255),
    RESPONSE TEXT, 
    PROJECT_ID VARCHAR(255)
)
>>
<<
CREATE TABLE AX_MOBILE_USER(
    IMEI VARCHAR(255),
    USER_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    FIREBASE_ID VARCHAR(255),
    GROUPNAME VARCHAR(255),
    ACTIVE VARCHAR(1)
)
>>
<<
CREATE TABLE AX_NOTIFY_USERS(    
    NOTIFICATION_ID NUMERIC(10),
    USER_ID VARCHAR(255),
    STATUS VARCHAR(255),
    PROJECT_ID VARCHAR(255)
)
>>
<<
alter table axtasks add notify_status VARCHAR(1) DEFAULT 'N'
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
	PAGE_ID NUMERIC(10) primary key,
	TITLE VARCHAR(255),
    TYPE VARCHAR(255),
    MODULE VARCHAR(255),
	TEMPLATE VARCHAR(255),
    PAGE_MENU VARCHAR(255),
	CONTENT TEXT,
	CREATED_BY VARCHAR(255),
	UPDATED_BY VARCHAR(255),
	IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
	CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
	UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,	
	IS_MIGRATED VARCHAR(1) DEFAULT 'N',
  IS_DEFAULT VARCHAR(1) DEFAULT 'N',
	ORDER_BY NUMERIC
)
>>
<<
CREATE SEQUENCE ax_pages_seq INCREMENT 1 START 10
>>
<<
CREATE OR REPLACE FUNCTION fn_AX_PAGES() RETURNS TRIGGER
AS $AX_PAGES$
declare 
v_sid numeric(15);

	BEGIN
		select nextval('ax_pages_seq') into v_sid ; 

        IF (TG_OP = 'INSERT') THEN 
		
		NEW.PAGE_ID = v_sid;
		
		return new;
	end if;
end; 
$AX_PAGES$ LANGUAGE plpgsql;
>>
<<
create trigger AX_PAGES_bir   
before insert on AX_PAGES     
for each row

execute procedure fn_AX_PAGES();

end;
>>
<<
CREATE TABLE AX_PAGE_SAVED(
	PAGE_ID NUMERIC(10) primary key,
	TITLE VARCHAR(255),
    TYPE VARCHAR(255),
    MODULE VARCHAR(255),
	TEMPLATE VARCHAR(255),
    PAGE_MENU VARCHAR(255),
	CONTENT TEXT,
	CREATED_BY VARCHAR(255),
	UPDATED_BY VARCHAR(255),
	IS_DELETED VARCHAR(1) DEFAULT 'N',
	CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
	UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,	
	IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    IS_LOCK VARCHAR(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    IS_DEFAULT VARCHAR(1) DEFAULT 'N',
	PARENT_PAGE_ID NUMERIC(10),
	RESPONSIBILITY TEXT,
	ORDER_BY NUMERIC
)
>>
<<
CREATE SEQUENCE ax_page_saved_seq INCREMENT 1 START WITH 1
>>
<<
CREATE OR REPLACE FUNCTION fn_AX_PAGE_SAVED() RETURNS TRIGGER
AS $AX_PAGE_SAVED$
declare 
v_sid numeric(15);

	BEGIN
		select nextval('ax_page_saved_seq') into v_sid ; 

        IF (TG_OP = 'INSERT') THEN 
		
		NEW.PAGE_ID = v_sid;
		
		return new;
	end if;
end; 
$AX_PAGE_SAVED$ LANGUAGE plpgsql;
>>
<<
create trigger AX_PAGE_SAVED_bir   
before insert on AX_PAGE_SAVED     
for each row

execute procedure fn_AX_PAGE_SAVED();

end;
>>
<<
CREATE TABLE AX_PAGE_RESPONSIBILITY(	 
	PAGE_ID NUMERIC REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,
	RESPONSIBILITY VARCHAR(255),
  	RESPONSIBILITY_ID NUMERIC
)
>>
<<
CREATE TABLE AX_PAGE_SD_RESPONSIBILITY(	 
	PAGE_ID NUMERIC REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE,
	RESPONSIBILITY VARCHAR(255),
  	RESPONSIBILITY_ID NUMERIC
)
>>
<<
CREATE TABLE AX_WIDGET_SAVED (
    WIDGET_ID NUMERIC(10) primary key,
    TITLE VARCHAR(255),
    WIDGET_TYPE VARCHAR(255),
    CONTENT TEXT,
    TARGET VARCHAR(255),
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_LOCK VARCHAR(1) DEFAULT 'N',
    ORDER_BY NUMERIC,
    is_publish varchar(1) DEFAULT 'N',
    PARENT_WIDGET_ID NUMERIC,
    PAGE_ID Numeric REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE,
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
)
>>
<<
CREATE SEQUENCE ax_widget_saved_seq Increment 1 START WITH 1
>>
<<
CREATE OR REPLACE FUNCTION fn_AX_WIDGET_SAVED() RETURNS TRIGGER
AS $AX_WIDGET_SAVED$
declare 
v_sid numeric(15);

	BEGIN
		select nextval('ax_widget_saved_seq') into v_sid ; 

        IF (TG_OP = 'INSERT') THEN 
		
		NEW.WIDGET_ID = v_sid;
		
		return new;
	end if;
end; 
$AX_WIDGET_SAVED$ LANGUAGE plpgsql;
>>
<<
create trigger AX_WIDGET_SAVED_bir   
before insert on AX_WIDGET_SAVED     
for each row

execute procedure fn_AX_WIDGET_SAVED();

end;
>>
<<
CREATE TABLE AX_WIDGET_PUBLISHED (
    WIDGET_ID NUMERIC(16) primary key,
    TITLE VARCHAR(255),
    WIDGET_TYPE VARCHAR(255),
    CONTENT TEXT,
    TARGET VARCHAR(255),
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_LOCK VARCHAR(1) DEFAULT 'N',
    ORDER_BY NUMERIC,
    is_publish varchar(1) DEFAULT 'N',
    PARENT_WIDGET_ID Numeric REFERENCES AX_WIDGET_SAVED(WIDGET_ID) ON DELETE CASCADE,
    PAGE_ID Numeric REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
)
>>
<<
CREATE SEQUENCE ax_widget_publish_seq START WITH 1
>>
<<
CREATE OR REPLACE FUNCTION fn_AX_WIDGET_PUBLISHED() RETURNS TRIGGER
AS $AX_WIDGET_PUBLISHED$
declare 
v_sid numeric(15);

	BEGIN
		select nextval('ax_widget_publish_seq') into v_sid ; 

        IF (TG_OP = 'INSERT') THEN 
		
		NEW.WIDGET_ID = v_sid;
		
		return new;
	end if;
end; 
$AX_WIDGET_PUBLISHED$ LANGUAGE plpgsql;
>>
<<
create trigger AX_WIDGET_PUBLISH_bir   
before insert on AX_WIDGET_PUBLISHED     
for each row

execute procedure fn_AX_WIDGET_PUBLISHED();

end;
>>
<<
CREATE TABLE AX_HP_USER_LEVEL_WIDGET(
    PAGE_ID NUMERIC REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,    
    WIDGETS  TEXT,
    USERNAME VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
>>
<<
CREATE TABLE AX_PAGE_TEMPLATES(
    TEMPLATE_ID NUMERIC(16) primary key,
    TITLE VARCHAR(255),
	MODULE VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP
)
>>
<<
CREATE SEQUENCE ax_page_template_seq Increment 1 START WITH 1
>>
<<
CREATE OR REPLACE FUNCTION fn_AX_PAGE_TEMPLATES() RETURNS TRIGGER
AS $AX_PAGE_TEMPLATES$
declare 
v_sid numeric(15);

	BEGIN
		select nextval('ax_page_template_seq') into v_sid ; 

        IF (TG_OP = 'INSERT') THEN 
		
		NEW.TEMPLATE_ID = v_sid;
		
		return new;
	end if;
end; 
$AX_PAGE_TEMPLATES$ LANGUAGE plpgsql;
>>
<<
create trigger AX_PAGE_TEMPLATE_bir   
before insert on AX_PAGE_TEMPLATES     
for each row

execute procedure fn_AX_PAGE_TEMPLATES();

end;
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
CREATE OR REPLACE VIEW axp_vw_menu
AS SELECT replace(replace(COALESCE(h.caption, ''::text) || COALESCE('\'::text || g.caption::text, ''::text), '\\\'::text, '\'::text), '\\'::text, '\'::text) AS menupath,
    g.caption,
    g.name,
    g.ordno,
    g.levelno,
    g.parent,
    g.type,
    g.pagetype,
    replace(replace((COALESCE('\'::text || g.visible::text, 'F'::text) || COALESCE('\'::text || h.visible, ''::text)) || '\'::text, '\\\'::text, '\'::text), '\\'::text, '\'::text) AS visible
   FROM axpages g
     LEFT JOIN ( SELECT COALESCE(f.caption, ''::text) || COALESCE('\'::text || e.caption::text, ''::text) AS caption,
            e.parent,
            e.name,
            (COALESCE('\'::text || f.visible, ''::text) || COALESCE('\'::text || e.visible::text, ''::text)) || '\'::text AS visible
           FROM axpages e
             LEFT JOIN ( SELECT (COALESCE(d.caption, ''::character varying)::text || '\'::text) || COALESCE(c.caption, ''::character varying)::text AS caption,
                    c.name,
                    (COALESCE('\'::text || d.visible, ''::text) || COALESCE('\'::text || c.visible::text, ''::text)) || '\'::text AS visible
                   FROM axpages c
                     LEFT JOIN ( SELECT a.name,
                            a.parent,
                            a.caption,
                            a.levelno,
                            a.ordno,
                            1 AS levlno,
                            ('\'::text || a.visible::text) || '\'::text AS visible
                           FROM axpages a
                          WHERE a.levelno = 0::numeric
                          ORDER BY a.levelno, a.ordno) d ON c.parent::text = d.name::text
                  WHERE c.levelno = ANY (ARRAY[1::numeric, 0::numeric])) f ON e.parent::text = f.name::text
          WHERE e.levelno = ANY (ARRAY[1::numeric, 0::numeric, 2::numeric])) h ON g.parent::text = h.name::text
  WHERE g.levelno <= 3::numeric
  ORDER BY g.ordno, g.levelno;
>>
<<
CREATE OR REPLACE FUNCTION axp_pr_page_creation(
	pname character varying,
	pcaption character varying,
	ppagetype character varying,
	pparentname character varying,
	paction character varying,
	props character varying)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare 
   pparent    VARCHAR (50);
   pordno     NUMERIC (15);
   plevelno   NUMERIC (15);
   psysdate   VARCHAR (30);

BEGIN

    IF LOWER (paction) <> 'delete' THEN
      --Page Creation before or after

      SELECT parent, ordno, levelno INTO pparent, pordno, plevelno
        FROM (SELECT parent,CASE WHEN LOWER (paction) = 'before' THEN ordno ELSE ordno + 1 END ordno, levelno
                FROM axp_vw_menulist
               WHERE name = pparentname AND TYPE = 'p'
              UNION ALL
               SELECT a.name,MAX (b.ordno) + 1 AS ordno,a.levelno + 1 AS levelno
                  FROM axp_vw_menulist a, axp_vw_menulist b
                 WHERE a.name = pparentname AND b.menupath LIKE replace(a.menupath,'\','\\') || '%'  AND a.TYPE = 'h'
              GROUP BY a.name, a.levelno) a;

      psysdate := TRIM (TO_CHAR (SYSDATE(), 'dd/mm/yyyy hh24:mi:ss'));

      UPDATE axpages SET ordno = ordno + 1 WHERE ordno >= pordno;

      INSERT INTO axpages (name,caption,blobno,visible,TYPE,parent,props,ordno,levelno,pagetype,createdon,
							updatedon,importedon)
           VALUES (pname,pcaption,1,'T','p',pparent,props,pordno,plevelno,ppagetype,psysdate,psysdate,psysdate);

     
   ELSE
      --Page Deleting
      SELECT ordno INTO pordno FROM axp_vw_menulist WHERE name = pname AND TYPE = 'p';

      DELETE FROM axpages WHERE name = pname; 

      UPDATE axpages SET ordno = ordno - 1 WHERE ordno >= pordno and pordno>0 ;

	

   END IF;

END;
$BODY$;
>>
<<
create or replace function pr_bulk_page_delete()  
RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$ 
declare 
i varchar(3000);
begin
for i in (Select name from axpages where pagetype='web' and blobno=1) 
loop
begin
execute axp_pr_page_creation( i.name,null,null,null,'delete',null);
exception when others then
null;
end ;
end loop;
end; $BODY$;
>>
-- Delete the All web pages from Page Menu.
<<
select * from pr_bulk_page_delete()
>>
<<
delete from axpages where pagetype='web'
>>
--AxpertWebDev13-10.3.0.0
<<
ALTER TABLE axusers DROP COLUMN homepage
>>
<<
ALTER table axusers add homepage varchar(255) DEFAULT null
>>
<<
ALTER TABLE axusergroups DROP COLUMN homepage
>>
<<
ALTER table axusergroups add homepage varchar(255) DEFAULT null
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
drop table axctx1
 >>
<<
create table axctx1 (
atype varchar(10),
axcontext varchar(75) )
>>
<<
create unique index  ui_AXCTX1 on AXCTX1 (axcontext,atype)
>>
 <<
 drop view AXP_APPSEARCH_DATA 
 >>
 <<
CREATE TABLE AXP_APPSEARCH_DATA
(
  CANCEL                VARCHAR(1),
  SOURCEID              numeric,
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
CREATE TABLE AXP_APPSEARCH_DATA_V2
(
  HLTYPE      VARCHAR(10),
  STRUCTNAME  VARCHAR(25),
  SEARCHTEXT  VARCHAR(200),
  PARAMS      VARCHAR(150),
  CREATEDON   DATE                              DEFAULT current_date,
  DOCID       VARCHAR(50)
) 
>>
<<
CREATE UNIQUE INDEX UI_AXP_APPSEARCH_DATA_V2 ON AXP_APPSEARCH_DATA_V2
(HLTYPE, STRUCTNAME, PARAMS) 
>>
<<
  CREATE OR REPLACE FUNCTION pr_source_trigger(phltype character varying, pstructname character varying, psearchtext character varying, psrctable character varying, psrcfield character varying, pparams character varying, pdocid character varying, psrcmultipletransid character varying, pparamchange character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
   pscripts   VARCHAR (3000);
   pcnt       NUMERIC (15);
    BEGIN     
    --To insert  or update dynamic param value from the source table

   IF psrctable IS NOT NULL AND psrcfield IS NOT NULL
   THEN
      --To drop existing trigger if any source field or source table has been changed

      IF pparamchange = 'T'
      THEN
         SELECT COUNT (1)
           INTO pcnt
         FROM information_schema.triggers where trigger_schema=current_user
                AND TRIM (UPPER (TRIGGER_name)) =
                       TRIM (UPPER ('axp_sch_' || pdocid));

         IF pcnt > 0
         THEN
            EXECUTE  'drop trigger if exists axp_sch_' || TRIM (pdocid)||' on '||psrctable||';';
             EXECUTE  'drop trigger if exists axp_sch_' || TRIM (pdocid)||'_delete on '||psrctable||';';
         END IF;

         DELETE FROM axp_appsearch_data_v2
          WHERE docid = pdocid;

      END IF;

      --To create the source table trigger

      pscripts :=
            ' create or replace function axp_sch_'|| pdocid|| '() 
RETURNS trigger
    LANGUAGE ''plpgsql''
    COST 100
    VOLATILE AS 
	$$
begin 
if tg_op=''INSERT''  then 

insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values('''
         || phltype
         || ''','''
         || pstructname
         || ''','
         || 'new.'
         || psrcfield
         || '||  '''
         || psearchtext
         || ''','''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'new.'),
                     '&',
                     '&''||''')
         || ','''
         || pdocid
         || ''');

else if  tg_op=''UPDATE''   then

insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values('''
         || phltype
         || ''','''
         || pstructname
         || ''','
         || 'new.'
         || psrcfield
         || '||  '''
         || psearchtext
         || ''','''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'old.'),
                     '&',
                     '&''||''')
         || ','''
         || pdocid
         || ''');

else  delete  FROM axp_appsearch_data_v2 where hltype='''
         || phltype
         || ''' and params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'old.'),
                     '&',
                     '&''||''')
         || ';

 end if;

 end if;
return new;
exception

      when unique_violation then

if tg_op=''INSERT''  then 
      update axp_appsearch_data_v2 set searchtext='
         || 'new.'
         || psrcfield
         || '||  '''
         || psearchtext
         || ''',params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'new.'),
                     '&',
                     '&''||''')
         || ' where hltype='''
         || phltype
         || ''' and params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'new.'),
                     '&',
                     '&''||''')
         || ' and docid='''
         || pdocid
         || ''';
else 
  update axp_appsearch_data_v2 set searchtext='
         || 'new.'
         || psrcfield
         || '||  '''
         || psearchtext
         || ''',params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'new.'),
                     '&',
                     '&''||''')
         || ' where hltype='''
         || phltype
         || ''' and params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'old.'),
                     '&',
                     '&''||''')
         || ' and docid='''
         || pdocid
         || ''';
end if;

return new;
   when others then 

return new;

 end ;  
 $$
 ';

      EXECUTE    pscripts;
	  
	  execute  ' drop trigger IF EXISTS axp_sch_'|| pdocid||' on '||psrctable ||';';
	  execute  ' drop trigger IF EXISTS axp_sch_'|| pdocid||'_delete on '||psrctable ||';';
	  
	 --inster and update event
	EXECUTE   'CREATE TRIGGER axp_sch_'|| pdocid||'
    AFTER INSERT OR UPDATE 
    ON '||psrctable ||
	 ' FOR EACH ROW '||
		case when psrcmultipletransid is not null and psrcmultipletransid<>'' 
	then ' when (new.transid='''||psrcmultipletransid||''')' else '' end||'
    EXECUTE PROCEDURE axp_sch_'||pdocid||'();' ;
   
   --delete event
   if psrcmultipletransid is not null and psrcmultipletransid<>'' then
   	EXECUTE   'CREATE TRIGGER axp_sch_'|| pdocid||'_delete
    AFTER delete
    ON '||psrctable ||
	 ' FOR EACH ROW '||
		case when psrcmultipletransid is not null and psrcmultipletransid<>'' 
	then ' when (old.transid='''||psrcmultipletransid||''')' else '' end||'
    EXECUTE PROCEDURE axp_sch_'||pdocid||'();' ;   
   end if;
	
	

      --Rebuild the exsting recordid from source table to appsearch data table

      EXECUTE  'update  ' || psrctable || ' set cancel=cancel';

   END IF;   
  
    
   
    END;
$function$
; 
>>
<< 
CREATE OR REPLACE FUNCTION fn_AXP_APPSEARCH_DATA_PERIOD() RETURNS TRIGGER
AS $AXP_APPSEARCH_DATA_PERIOD$

	BEGIN
		if new.periodically ='T' or new.srctable is  null or new.srcfield is  null then
		Begin 

        IF (TG_OP = 'INSERT') THEN 
		
		insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(new.hltype,new.structname, case when new.periodically ='T' then new.searchtext else  new.caption end ,new.params,new.docid);
		
		return new;
		end if;
		
		IF (TG_OP = 'UPDATE') THEN 
		
		insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(old.hltype,old.structname, case when old.periodically ='T' then old.searchtext else  old.caption end ,old.params,old.docid);
		
		return new;
		
		end if;
		
		IF (TG_OP = 'DELETE') THEN 
		
		delete from axp_appsearch_data_v2 where docid = old.docid;
		
		return new;
		
		end if;
		
		exception
      when unique_violation then
      update axp_appsearch_data_v2 set  hltype= new.hltype , structname = new.structname,searchtext = case when new.periodically ='T' then new.searchtext else  new.caption end  ,params=new.params where docid= new.docid;
   when others then null ;

		end ;
		end if; 
end; 
$AXP_APPSEARCH_DATA_PERIOD$ LANGUAGE plpgsql;
>>
<<
CREATE OR REPLACE FUNCTION axp_tr_search_appsearch()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$
    BEGIN
    if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
    if  new.periodically ='T' or new.srctable is  null or new.srcfield is  null then
if TG_OP = 'INSERT'   then 
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(new.hltype,new.structname, case when new.periodically ='T' then new.searchtext else  new.caption end ,new.params,new.docid);
else if TG_OP = 'UPDATE'  then
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(old.hltype,old.structname, case when old.periodically ='T' then old.searchtext else  old.caption end ,old.params,old.docid);
 end if;
  end if; 
  
  END IF;
  end if;

if TG_OP = 'DELETE'  then 
   delete from axp_appsearch_data_v2 where docid = old.docid;
    execute 'drop trigger IF EXISTS axp_sch_'||old.docid|| ' ON '||OLD.srctable||';';
     execute 'DROP FUNCTION IF EXISTS '||'axp_sch_'||old.docid||';';
end if;

  RETURN NEW;
 exception
      when unique_violation then
      update axp_appsearch_data_v2 set  hltype= new.hltype , structname = new.structname,searchtext = case when new.periodically ='T' then new.searchtext else  new.caption end  ,params=new.params where docid= new.docid;
         RETURN NEW;
    END;
$BODY$;
>>
<<
CREATE TRIGGER axp_tr_search_appsearch
    after INSERT OR UPDATE OR DELETE
    ON axp_appsearch_data_period
    FOR EACH ROW
    EXECUTE PROCEDURE axp_tr_search_appsearch();    
 
>>
<<
create trigger axp_tr_search_appsearch1
before insert or update or delete on AXP_APPSEARCH_DATA_PERIOD      
for each row

execute procedure fn_AXP_APPSEARCH_DATA_PERIOD();

end;
>>
<<
CREATE OR REPLACE VIEW axp_vw_menu AS
 SELECT replace(replace(COALESCE(h.caption, '') || COALESCE('\' || g.caption, ''), '\\\', '\'), '\\', '\') AS menupath,
    g.caption,
    g.name,
    g.ordno,
    g.levelno,
    g.parent,
    g.type,
    g.pagetype,
    replace(replace((COALESCE('\' || g.visible, 'F') || COALESCE('\' || h.visible, '')) || '\', '\\\', '\'), '\\', '\') AS visible
   FROM axpages g
     LEFT JOIN ( SELECT COALESCE(f.caption, '') || COALESCE('\' || e.caption, '') AS caption,
            e.parent,
            e.name,
            (COALESCE('\' || f.visible, '') || COALESCE('\' || e.visible, '')) || '\' AS visible
           FROM axpages e
             LEFT JOIN ( SELECT (COALESCE(d.caption, '') || '\') || COALESCE(c.caption, '') AS caption,
                    c.name,
                    (COALESCE('\' || d.visible, '') || COALESCE('\' || c.visible, '')) || '\' AS visible
                   FROM axpages c
                     LEFT JOIN ( SELECT a.name,
                            a.parent,
                            a.caption,
                            a.levelno,
                            a.ordno,
                            1 AS levlno,
                            ('\' || a.visible) || '\' AS visible
                           FROM axpages a
                          WHERE a.levelno = 0
                          ORDER BY a.levelno, a.ordno) d ON c.parent = d.name
                  WHERE c.levelno = ANY (ARRAY[1, 0])) f ON e.parent = f.name
          WHERE e.levelno = ANY (ARRAY[1, 0, 2])) h ON g.parent = h.name
  WHERE g.levelno <= 3
  ORDER BY g.ordno, g.levelno
  >> 
<<
CREATE OR REPLACE VIEW axp_appsearch_data_new
AS SELECT 2 AS slno,
    axp_appsearch_data_v2.hltype,
    axp_appsearch_data_v2.structname,
    btrim(replace(axp_appsearch_data_v2.searchtext::text, 'View'::text, ' '::text)) AS searchtext,
    axp_appsearch_data_v2.params
   FROM axp_appsearch_data_v2
  WHERE lower(axp_appsearch_data_v2.params::text) !~~ '%current_date%'::text
UNION ALL
 SELECT 1.9 AS slno,
    a.hltype,
    a.structname,
    btrim(replace(a.searchtext::text, 'View'::text, ' '::text)) AS searchtext,
    a.params
   FROM axp_appsearch_data a
  WHERE NOT (EXISTS ( SELECT 'x'::text AS text
           FROM axp_appsearch_data_v2 b
          WHERE a.structname::text = b.structname::text AND a.params::text = b.params::text))
UNION ALL
 SELECT 2 AS slno,
    axp_appsearch_data_v2.hltype,
    axp_appsearch_data_v2.structname,
    btrim(replace(axp_appsearch_data_v2.searchtext::text, 'View'::text, ' '::text)) AS searchtext,
    replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(axp_appsearch_data_v2.params::text, 'date_trunc(''month'',current_date)'::text, btrim(to_char(date_trunc('month'::text, CURRENT_DATE::timestamp with time zone), 'dd/mm/yyyy'::text))), 'date_trunc(''month'',(add_months(current_date,0-1)))'::text, btrim(to_char(date_trunc('month'::text, add_months(CURRENT_DATE, 0 - 1)::timestamp with time zone), 'dd/mm/yyyy'::text))), 'date_trunc(''month'', current_date) + interval ''0 month'' - interval ''1 day'''::text, btrim(to_char(date_trunc('month'::text, CURRENT_DATE::timestamp with time zone) + '00:00:00'::interval - '1 day'::interval, 'dd/mm/yyyy'::text))), 'date_trunc(''week'',current_date)'::text, btrim(to_char(date_trunc('week'::text, CURRENT_DATE::timestamp with time zone), 'dd/mm/yyyy'::text))), 'date_trunc(''week'',current_date-7)+ interval ''6 day'''::text, btrim(to_char(date_trunc('week'::text, (CURRENT_DATE - 7)::timestamp with time zone) + '6 days'::interval, 'dd/mm/yyyy'::text))), 'date_trunc(''week'',current_date-7)'::text, btrim(to_char(date_trunc('week'::text, (CURRENT_DATE - 7)::timestamp with time zone), 'dd/mm/yyyy'::text))), 'date_trunc(''month'',current_date)'::text, btrim(to_char(date_trunc('month'::text, CURRENT_DATE::timestamp with time zone), 'dd/mm/yyyy'::text))), 'current_date-1'::text, btrim(to_char((CURRENT_DATE - 1)::timestamp with time zone, 'dd/mm/yyyy'::text))), 'current_date'::text, btrim(to_char(CURRENT_DATE::timestamp with time zone, 'dd/mm/yyyy'::text))), ' &'::text, '&'::text) AS params
   FROM axp_appsearch_data_v2
  WHERE lower(axp_appsearch_data_v2.params::text) ~~ '%current_date%'::text
UNION ALL
 SELECT 1 AS slno,
    'tstruct'::character varying AS hltype,
    t.name AS structname,
    t.caption AS searchtext,
    NULL::character varying AS params
   FROM tstructs t
  WHERE t.blobno = 1::numeric AND (EXISTS ( SELECT 'x'::text AS text
           FROM axp_vw_menu x
          WHERE x.pagetype::text ~~ 't%'::text AND btrim(substr(x.pagetype::text, 2, 20)) = t.name::text AND x.visible !~~ '%F%'::text))
UNION ALL
 SELECT 0 AS slno,
    'iview'::character varying AS hltype,
    i.name AS structname,
    i.caption AS searchtext,
    NULL::character varying AS params
   FROM iviews i
  WHERE i.blobno = 1::numeric AND (EXISTS ( SELECT 'x'::text AS text
           FROM axp_vw_menu x
          WHERE x.pagetype::text ~~ 'i%'::text AND btrim(substr(x.pagetype::text, 2, 20)) = i.name::text AND x.visible !~~ '%F%'::text))
UNION ALL
 SELECT 3 AS slno,
    'Page'::character varying AS hltype,
    axp_vw_menu.name AS structname,
    axp_vw_menu.caption AS searchtext,
    NULL::character varying AS params
   FROM axp_vw_menu
  WHERE axp_vw_menu.pagetype::text = 'web'::text
  ORDER BY 1;
>>
<<
 DROP VIEW AXP_APPSEARCH
>>
<<
CREATE OR REPLACE VIEW axp_appsearch AS
 SELECT DISTINCT a.searchtext,
    a.params::text ||
        CASE
            WHEN a.params IS NOT NULL AND lower(a.params::text) !~~ '%~act%'::text THEN '~act=load'::text
            ELSE NULL::text
        END AS params,
    a.hltype,
    a.structname,
    a.username
   FROM ( SELECT s.slno,
            s.searchtext,
            s.params,
            s.hltype,
            s.structname,
            lg.username
           FROM axp_appsearch_data_new s,
            axuseraccess a_1,
            axusergroups g,
            axuserlevelgroups lg
          WHERE a_1.sname::text = s.structname::text AND a_1.rname::text = g.userroles::text AND g.groupname::text = lg.usergroup::text AND (a_1.stype::text = ANY (ARRAY['t'::character varying::text, 'i'::character varying::text]))
          GROUP BY s.searchtext, s.params, s.hltype, s.structname, lg.username, s.slno
        UNION
         SELECT b.slno,
            b.searchtext,
            b.params,
            b.hltype,
            b.structname,
            lg.username
           FROM axuserlevelgroups lg,
            ( SELECT DISTINCT s.searchtext,
                    s.params,
                    s.hltype,
                    s.structname,
                    0 AS slno
                   FROM axp_appsearch_data_new s
                     LEFT JOIN axuseraccess a_1 ON s.structname::text = a_1.sname::text AND (a_1.stype::text = ANY (ARRAY['t'::character varying::text, 'i'::character varying::text]))) b
          WHERE lg.usergroup::text = 'default'::text
  ORDER BY 1, 6) a;
 >>
<<
update axp_appsearch_data set params=replace(params,'&','~')
>>
<<
update axp_appsearch_data_v2 set params=replace(params,'&','~')
>> 
<<
CREATE OR REPLACE FUNCTION pr_axcnfgiv_tab_create(
	structtransid character varying)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
v_cnt numeric(2) ;
v_sql varchar(4000);
begin
      select COALESCE(count(table_name),0) into v_cnt from information_schema.tables where lower(table_name) = lower( 'axpconfigsiv'||chr(95)||structtransid );
      if v_cnt = 0
      then
        v_sql := 'create table axpconfigsiv'||chr(95)||structtransid||' ( configname varchar(30),cvalue varchar(240),condition varchar(240))' ;
        execute  v_sql;

      end if;
end;
$BODY$;
>>
<<
CREATE OR REPLACE FUNCTION pr_axcnfg_tab_create(
	structtransid character varying)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
v_cnt numeric(2) ;
v_sql varchar(4000);
begin
      select COALESCE(count(table_name),0) into v_cnt from information_schema.tables where lower(table_name) = lower( 'axpconfigs'||chr(95)||structtransid );
      if v_cnt = 0
      then
      v_sql := 'create table axpconfigs'||chr(95)||structtransid||' ( configname varchar(30),cvalue varchar(2000),condition varchar(240))' ;
        execute v_sql;

        end if;
end;
$BODY$;
>>

<<
CREATE TABLE AXPCONFIGSIV_MAINREPO
(
  CONFIGNAME  VARCHAR(30),
  CVALUE      VARCHAR(240),
  CONDITION   VARCHAR(240)
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
CREATE OR REPLACE FUNCTION count_dcs (p_transid varchar) returns VARCHAR
As $BODY$ 
declare 
    l_result varchar(15);
begin
select string_agg(b.name,', ' order by stransid) dcs into l_result
  from axpdef_dc b
  where b.stransid =p_transid  ;
    return l_result;
end; $BODY$ LANGUAGE plpgsql;
>>
<<
CREATE OR REPLACE FUNCTION GET_COLUMNS_NAME(p_selectQuery IN VARCHAR) RETURNS varchar 
AS $BODY$ 
declare 
    l_result  varchar(32767);
begin
	drop table temp_testtable ;
	execute 'Create table temp_testtable as '|| p_selectQuery;
	
	SELECT string_agg(COLUMN_NAME,',') into l_result FROM information_schema.COLUMNS WHERE TABLE_NAME = 'temp_testtable';
	   
    return  l_result;
end; $BODY$ Language plpgsql;
>>
<<
CREATE OR REPLACE FUNCTION GET_COLUMNS_NAMES(p_selectQuery IN VARCHAR) RETURNS varchar 
AS $BODY$ 
declare 
    l_result  varchar(32767);
begin
	drop table temp_testtable ;
	execute 'Create table temp_testtable as '|| p_selectQuery;
	
	SELECT string_agg(COLUMN_NAME,',') into l_result FROM information_schema.COLUMNS 
	WHERE TABLE_NAME = 'temp_testtable';
	   
    return  l_result;
end; $BODY$ Language plpgsql;
>>
<<
CREATE OR REPLACE VIEW axp_vw_menulist
AS SELECT replace(replace(COALESCE('\'::text || h.caption, ''::text) || COALESCE('\'::text || g.caption::text, ''::text), '\\\'::text, '\'::text), '\\'::text, '\'::text) AS menupath,
    g.name,
    g.ordno,
    g.levelno,
    g.parent,
    g.type,
    g.pagetype
   FROM axpages g
     LEFT JOIN ( SELECT COALESCE('\'::text || f.caption, ''::text) || COALESCE('\'::text || e.caption::text, ''::text) AS caption,
            e.parent,
            e.name
           FROM axpages e
             LEFT JOIN ( SELECT (COALESCE('\'::text || d.caption::text, ''::text) || '\'::text) || COALESCE(c.caption, ''::character varying)::text AS caption,
                    c.name
                   FROM axpages c
                     LEFT JOIN ( SELECT a.name,
                            a.parent,
                            a.caption,
                            a.levelno,
                            a.ordno,
                            1 AS levlno
                           FROM axpages a
                          WHERE a.levelno = 0::numeric
                          ORDER BY a.levelno, a.ordno) d ON c.parent::text = d.name::text
                  WHERE c.levelno = ANY (ARRAY[1::numeric, 0::numeric])) f ON e.parent::text = f.name::text
          WHERE e.levelno = ANY (ARRAY[1::numeric, 0::numeric, 2::numeric])) h ON g.parent::text = h.name::text
  WHERE COALESCE(g.levelno, 0::numeric) <= 3::numeric
  ORDER BY g.ordno, g.levelno;
>>
<<
CREATE OR REPLACE VIEW v_fillgrid AS
 SELECT a.stransid,
    a.name,
    a.caption,
    a.sql_editor_sql,
    a.targetdc,
        CASE
            WHEN a.multiselect::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS multiselect,
        CASE
            WHEN a.autoshow::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS autoshow,
    a.sourcedc,
        CASE
            WHEN a.vvalidate::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS vvalidate,
        CASE
            WHEN a.executeonsave::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS executeonsave,
        CASE
            WHEN a.firmbind::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS firmbind,
    a.selecton,
    a.footerstring,
    a.exp_editor_validateexpression AS validateexpression,
    a.addrows,
    a.columnproperty,
    a.purpose,
    string_agg((((b.sourcefield::text || ','::text) || b.sourcecaption::text) || ','::text) || b.targetfield::text, '$'::text ORDER BY 1::integer) AS mappingdetails,
    a.grpfield AS groupfield,
    a.dcname,
        CASE
            WHEN a.autoselectallrows::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS autoselectallrows
   FROM axpdef_fillgrid a,
    axpdef_fillgriddtl b
  WHERE a.axpdef_fillgridid = b.axpdef_fillgridid
  GROUP BY a.name, a.caption, a.sql_editor_sql, a.targetdc, a.multiselect, a.autoshow, a.vvalidate, a.executeonsave, a.firmbind, a.sourcedc, a.selecton, a.footerstring, a.exp_editor_validateexpression, a.addrows, a.columnproperty, a.purpose, a.stransid, a.grpfield, a.dcname, a.autoselectallrows
>>
<<
CREATE OR REPLACE VIEW v_genmap AS
 SELECT a.stransid,
    a.name,
    a.caption,
    a.dcname,
    a.targettstruct,
    a.basedondc,
    a.controlfieldname,
    a.schemaoftarget,
    a.onpost,
    a.purpose,
        CASE
            WHEN a.active::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS active,
        CASE
            WHEN a.onapprove::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onapprove,
        CASE
            WHEN a.onreject::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onreject,
    string_agg((((((((((b.sourcefrom::text || ','::text) || COALESCE(b.source, ''::character varying)::text) || ','::text) || b.fsource::text) || ','::text) || b.sourcedcasgrid::text) || ','::text) || b.targetfield::text) || ','::text) || b.targetrow, '$'::text ORDER BY 1::integer) AS mapping,
    (c.rtargetrow || ','::text) || c.rowcontrolfield::text AS rowcontrol,
    a.targettrasid,
    a.groupfield,
    concat(c.rtargetrow, ',', c.rowcontrolfield) AS jjj
   FROM axpdef_genmap a
     LEFT JOIN axpdef_genmapdtl b ON a.axpdef_genmapid = b.axpdef_genmapid
     LEFT JOIN axpdef_genmaprowctrl c ON a.axpdef_genmapid = c.axpdef_genmapid
  GROUP BY a.name, a.caption, a.dcname, a.targettstruct, a.basedondc, a.stransid, a.controlfieldname, a.schemaoftarget, a.onpost, a.purpose, a.active, a.onapprove, a.onreject, c.rtargetrow, c.rowcontrolfield, a.targettrasid, a.groupfield;
>>
<<
CREATE OR REPLACE VIEW vw_dc AS
 SELECT a.stransid AS transid,
    a.name,
    a.caption,
    a.tablename,
        CASE
            WHEN a.asgrid::text = 'F'::text THEN 'FALSE'::text
            ELSE 'TRUE'::text
        END AS asgrid,
        CASE
            WHEN a.allowchange::text = 'F'::text THEN 'FALSE'::text
            ELSE 'TRUE'::text
        END AS allowchange,
        CASE
            WHEN a.allowempty::text = 'F'::text THEN 'FALSE'::text
            ELSE 'TRUE'::text
        END AS allowempty,
        CASE
            WHEN a.adddcrows::text = 'F'::text THEN 'FALSE'::text
            ELSE 'TRUE'::text
        END AS adddcrows,
        CASE
            WHEN a.deletedcrows::text = 'F'::text THEN 'FALSE'::text
            ELSE 'TRUE'::text
        END AS deletedcrows,
        CASE
            WHEN a.popup::text = 'F'::text THEN 'FALSE'::text
            ELSE 'TRUE'::text
        END AS popup,
    a.purpose
   FROM axpdef_dc a;
>>
<<
CREATE OR REPLACE VIEW vw_field_informations AS
 SELECT DISTINCT 1 AS sno,
    a.stransid AS transid,
    a.dcname,
    a.name,
    a.caption,
    a.datatype,
    a.customdatatype,
    a.datawidth,
    a.fdecimal,
    a.modeofentry,
    a.sql_editor_detail AS detail,
        CASE
            WHEN a.hidden::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS hidden,
        CASE
            WHEN a.allowempty::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowempty,
        CASE
            WHEN a.readonly::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS readonly,
        CASE
            WHEN a.setcarry::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS setcarry,
        CASE
            WHEN a.savevale::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS savevalue,
    a.exp_editor_expression AS expression,
    a.exp_editor_validateexpression AS validateexpression,
        CASE
            WHEN a.allowduplicate::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowduplicate,
        CASE
            WHEN a.onlypositive::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onlypositive,
    NULL::text AS sourcekey,
    NULL::text AS carryfield,
    NULL::text AS displaytotal,
    NULL::text AS windowwidth,
    NULL::text AS windowheight,
    NULL::text AS sql,
        CASE
            WHEN a.autoselect::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS autoselect,
        CASE
            WHEN a.refreshonsave::text = 'F'::text THEN 'FALSE'::text
            ELSE 'TRUE'::text
        END AS refresh1,
    NULL::text AS listvalues,
    NULL::text AS prefix,
    NULL::text AS prefix_fields,
    NULL::text AS description,
    NULL::text AS start_no,
    'FALSE'::text AS sactive,
    NULL::text AS no_of_digits,
    'FALSE'::text AS savenormalized,
        CASE
            WHEN a.suggestive::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS suggestive,
    NULL::text AS sourcefield,
    NULL::text AS source_table,
    NULL::text AS datasource,
    NULL::text AS sequence,
    NULL::text AS tname,
    NULL::text AS fromtransid,
    NULL::text AS selectfield,
    NULL::text AS parent,
    NULL::text AS gui,
        CASE
            WHEN a.applycomma::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS applycomma,
    a.mask,
    a.pattern,
    a.pwdchar AS password_character,
    a.hint,
        CASE
            WHEN a.clienvalidation::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS clientvalidation,
    a.searchsql AS search_sql,
    a.displaydetails AS displaydetail,
        CASE
            WHEN a.tabstop::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS tabstop,
    m.sleveno,
    m.sordno,
    NULL::text AS source,
    a.purpose,
    NULL::text AS cwidth,
    NULL::text AS list,
    NULL::text AS selectfrom,
    a.fldordno,
    m.trackchanges,
    m.trackchangesmadeby,
    m.selectedusers,
    m.selectedfields,
    NULL::text AS master,
    'FALSE'::text AS combobox,
    a.componenttype,
    a.separator
   FROM coretstructhdr a,
    tstruct_mst_details m
  WHERE a.coretstructhdrid = m.sourceid AND (a.modeofentry::text = ANY (ARRAY['Accept'::character varying::text, 'Calculate'::character varying::text]))
UNION
 SELECT DISTINCT 2 AS sno,
    a.stransid AS transid,
    a.dcname,
    a.name,
    a.caption,
    a.datatype,
    a.customdatatype,
    a.datawidth,
    a.fdecimal,
    a.modeofentry,
    a.sql_editor_detail AS detail,
        CASE
            WHEN a.hidden::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS hidden,
        CASE
            WHEN a.allowempty::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowempty,
        CASE
            WHEN a.readonly::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS readonly,
        CASE
            WHEN a.setcarry::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS setcarry,
        CASE
            WHEN a.savevale::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS savevalue,
    a.exp_editor_expression AS expression,
    a.exp_editor_validateexpression AS validateexpression,
        CASE
            WHEN a.allowduplicate::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowduplicate,
        CASE
            WHEN a.onlypositive::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onlypositive,
    NULL::text AS sourcekey,
    NULL::text AS carryfield,
    NULL::text AS displaytotal,
    NULL::text AS windowwidth,
    NULL::text AS windowheight,
    NULL::text AS sql,
    'FALSE'::text AS autoselect,
    'FALSE'::text AS refresh1,
    NULL::text AS listvalues,
    ag.prefix,
    ag.prefixfield AS prefix_fields,
    ag.description,
    ag.startingno::character(1) AS start_no,
        CASE
            WHEN ag.active::text = 'F'::text THEN 'FALSE'::text
            ELSE 'TRUE'::text
        END AS sactive,
    ag.noofdigits::character(1) AS no_of_digits,
    'FALSE'::text AS savenormalized,
    'FALSE'::text AS suggestive,
    NULL::text AS sourcefield,
    NULL::text AS source_table,
    NULL::text AS datasource,
    NULL::text AS sequence,
    NULL::text AS tname,
    NULL::text AS fromtransid,
    NULL::text AS selectfield,
    NULL::text AS parent,
    NULL::text AS gui,
        CASE
            WHEN a.applycomma::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS applycomma,
    a.mask,
    a.pattern,
    a.pwdchar AS password_character,
    a.hint,
        CASE
            WHEN a.clienvalidation::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS clientvalidation,
    a.searchsql AS search_sql,
    a.displaydetails AS displaydetail,
        CASE
            WHEN a.tabstop::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS tabstop,
    m.sleveno,
    m.sordno,
    NULL::text AS source,
    a.purpose,
    NULL::text AS cwidth,
    NULL::text AS list,
    NULL::text AS selectfrom,
    a.fldordno,
    m.trackchanges,
    m.trackchangesmadeby,
    m.selectedusers,
    m.selectedfields,
    NULL::text AS master,
    'FALSE'::text AS combobox,
    a.componenttype,
    a.separator
   FROM coretstructhdr a,
    coretstructdtlsauto ag,
    tstruct_mst_details m
  WHERE a.coretstructhdrid = m.sourceid AND a.coretstructhdrid = ag.coretstructhdrid AND a.modeofentry::text = 'AutoGenerate'::text
UNION
 SELECT DISTINCT 3 AS sno,
    a.stransid AS transid,
    a.dcname,
    a.name,
    a.caption,
    a.datatype,
    a.customdatatype,
    a.datawidth,
    a.fdecimal,
    a.modeofentry,
    a.sql_editor_detail AS detail,
        CASE
            WHEN a.hidden::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS hidden,
        CASE
            WHEN a.allowempty::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowempty,
        CASE
            WHEN a.readonly::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS readonly,
        CASE
            WHEN a.setcarry::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS setcarry,
        CASE
            WHEN a.savevale::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS savevalue,
    a.exp_editor_expression AS expression,
    a.exp_editor_validateexpression AS validateexpression,
        CASE
            WHEN a.allowduplicate::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowduplicate,
        CASE
            WHEN a.onlypositive::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onlypositive,
    NULL::text AS sourcekey,
    NULL::text AS carryfield,
    NULL::text AS displaytotal,
    NULL::text AS windowwidth,
    NULL::text AS windowheight,
    NULL::text AS sql,
    'FALSE'::text AS autoselect,
    'FALSE'::text AS refresh1,
    string_agg(l.listofvalues::text, ','::text ORDER BY (
        CASE
            WHEN l.listofvalues::text = ANY (ARRAY['YES'::character varying::text, 'T'::character varying::text, 'TRUE'::character varying::text, 'yes'::character varying::text, 't'::character varying::text, 'true'::character varying::text]) THEN '01'::character varying
            WHEN l.listofvalues::text = ANY (ARRAY['NO'::character varying::text, 'F'::character varying::text, 'FALSE'::character varying::text, 'no'::character varying::text, 'f'::character varying::text, 'false'::character varying::text]) THEN '02'::character varying
            ELSE l.listofvalues
        END)) AS listvalues,
    NULL::text AS prefix,
    NULL::text AS prefix_fields,
    NULL::text AS description,
    NULL::text AS start_no,
    'FALSE'::text AS sactive,
    NULL::text AS no_of_digits,
    'FALSE'::text AS savenormalized,
    'FALSE'::text AS suggestive,
    NULL::text AS sourcefield,
    NULL::text AS source_table,
    NULL::text AS datasource,
    NULL::text AS sequence,
    NULL::text AS tname,
    NULL::text AS fromtransid,
    NULL::text AS selectfield,
    NULL::text AS parent,
    NULL::text AS gui,
        CASE
            WHEN a.applycomma::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS applycomma,
    a.mask,
    a.pattern,
    a.pwdchar AS password_character,
    a.hint,
        CASE
            WHEN a.clienvalidation::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS clientvalidation,
    a.searchsql AS search_sql,
    a.displaydetails AS displaydetail,
        CASE
            WHEN a.tabstop::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS tabstop,
    m.sleveno,
    m.sordno,
    NULL::text AS source,
    a.purpose,
    NULL::text AS cwidth,
    NULL::text AS list,
    NULL::text AS selectfrom,
    a.fldordno,
    m.trackchanges,
    m.trackchangesmadeby,
    m.selectedusers,
    m.selectedfields,
    NULL::text AS master,
    'FALSE'::text AS combobox,
    a.componenttype,
    a.separator
   FROM coretstructhdr a,
    coretstructdtls l,
    tstruct_mst_details m
  WHERE a.coretstructhdrid = m.sourceid AND a.coretstructhdrid = l.coretstructhdrid AND a.modeofentry::text = 'Select From List'::text
  GROUP BY a.stransid, m.sordno, a.dcname, a.name, a.caption, a.datatype, a.customdatatype, a.datawidth, a.fdecimal, a.modeofentry, a.sql_editor_detail, a.hidden, a.allowempty, a.allowduplicate, a.readonly, a.exp_editor_expression, a.exp_editor_validateexpression, a.setcarry, a.savevale, a.onlypositive, a.applycomma, a.mask, a.pattern, a.hint, a.pwdchar, a.clienvalidation, a.searchsql, a.displaydetails, a.tabstop, m.sleveno, a.purpose, a.fldordno, m.trackchanges, m.trackchangesmadeby, m.selectedusers, m.selectedfields, a.componenttype, a.separator
UNION
 SELECT DISTINCT 4 AS sno,
    a.stransid AS transid,
    a.dcname,
    a.name,
    a.caption,
    a.datatype,
    a.customdatatype,
    a.datawidth,
    a.fdecimal,
    a.modeofentry,
    a.sql_editor_detail AS detail,
        CASE
            WHEN a.hidden::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS hidden,
        CASE
            WHEN a.allowempty::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowempty,
        CASE
            WHEN a.readonly::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS readonly,
        CASE
            WHEN a.setcarry::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS setcarry,
        CASE
            WHEN a.savevale::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS savevalue,
    a.exp_editor_expression AS expression,
    a.exp_editor_validateexpression AS validateexpression,
        CASE
            WHEN a.allowduplicate::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowduplicate,
        CASE
            WHEN a.onlypositive::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onlypositive,
    'TRUE'::text AS sourcekey,
    NULL::text AS carryfield,
    NULL::text AS displaytotal,
    a.windowwidth_form::character(1) AS windowwidth,
    a.windowheight_form::character(1) AS windowheight,
    a.sql_editor_sqltextform AS sql,
        CASE
            WHEN a.autoselect_form::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS autoselect,
        CASE
            WHEN a.refreshonsave_form::text = 'F'::text THEN 'FALSE'::text
            ELSE 'TRUE'::text
        END AS refresh1,
    NULL::text AS listvalues,
    NULL::text AS prefix,
    NULL::text AS prefix_fields,
    NULL::text AS description,
    NULL::text AS start_no,
    'FALSE'::text AS sactive,
    NULL::text AS no_of_digits,
        CASE
            WHEN a.savenormalized_form::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS savenormalized,
    'FALSE'::text AS suggestive,
    NULL::text AS sourcefield,
    a.tname AS source_table,
    a.datasource_form AS datasource,
    NULL::text AS sequence,
    NULL::text AS tname,
    a.fromtransid,
    a.selectfield,
    NULL::text AS parent,
    NULL::text AS gui,
        CASE
            WHEN a.applycomma::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS applycomma,
    a.mask,
    a.pattern,
    a.pwdchar AS password_character,
    a.hint,
        CASE
            WHEN a.clienvalidation::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS clientvalidation,
    a.searchsql AS search_sql,
    a.displaydetails AS displaydetail,
        CASE
            WHEN a.tabstop::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS tabstop,
    m.sleveno,
    m.sordno,
    NULL::text AS source,
    a.purpose,
    NULL::text AS cwidth,
    NULL::text AS list,
    NULL::text AS selectfrom,
    a.fldordno,
    m.trackchanges,
    m.trackchangesmadeby,
    m.selectedusers,
    m.selectedfields,
    NULL::text AS master,
        CASE
            WHEN a.combobox_form::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS combobox,
    a.componenttype,
    a.separator
   FROM coretstructhdr a,
    tstruct_mst_details m
  WHERE a.coretstructhdrid = m.sourceid AND a.modeofentry::text = 'Select From Form'::text
UNION
 SELECT DISTINCT 5 AS sno,
    a.stransid AS transid,
    a.dcname,
    a.name,
    a.caption,
    a.datatype,
    a.customdatatype,
    a.datawidth,
    a.fdecimal,
    a.modeofentry,
    a.sql_editor_detail AS detail,
        CASE
            WHEN a.hidden::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS hidden,
        CASE
            WHEN a.allowempty::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowempty,
        CASE
            WHEN a.readonly::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS readonly,
        CASE
            WHEN a.setcarry::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS setcarry,
        CASE
            WHEN a.savevale::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS savevalue,
    a.exp_editor_expression AS expression,
    a.exp_editor_validateexpression AS validateexpression,
        CASE
            WHEN a.allowduplicate::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowduplicate,
        CASE
            WHEN a.onlypositive::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onlypositive,
        CASE
            WHEN a.savenormalized::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS sourcekey,
    NULL::text AS carryfield,
    NULL::text AS displaytotal,
    a.windowwidth::character(1) AS windowwidth,
    a.windowheight::character(1) AS windowheight,
    a.sql_editor_test AS sql,
        CASE
            WHEN a.autoselect_sql::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS autoselect,
        CASE
            WHEN a.refreshonsav::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS refresh1,
    NULL::text AS listvalues,
    NULL::text AS prefix,
    NULL::text AS prefix_fields,
    NULL::text AS description,
    NULL::text AS start_no,
    'FALSE'::text AS sactive,
    NULL::text AS no_of_digits,
        CASE
            WHEN a.savenormalized::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS savenormalized,
    'FALSE'::text AS suggestive,
    a.sourcefield,
    a.sourcetable AS source_table,
    a.datasource,
    NULL::text AS sequence,
    NULL::text AS tname,
    NULL::text AS fromtransid,
    NULL::text AS selectfield,
    NULL::text AS parent,
    NULL::text AS gui,
        CASE
            WHEN a.applycomma::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS applycomma,
    a.mask,
    a.pattern,
    a.pwdchar AS password_character,
    a.hint,
        CASE
            WHEN a.clienvalidation::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS clientvalidation,
    a.searchsql AS search_sql,
    a.displaydetails AS displaydetail,
        CASE
            WHEN a.tabstop::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS tabstop,
    m.sleveno,
    m.sordno,
    NULL::text AS source,
    a.purpose,
    NULL::text AS cwidth,
    NULL::text AS list,
    a.selectform_ AS selectfrom,
    a.fldordno,
    m.trackchanges,
    m.trackchangesmadeby,
    m.selectedusers,
    m.selectedfields,
    NULL::text AS master,
        CASE
            WHEN a.combobox_sql::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS combobox,
    a.componenttype,
    a.separator
   FROM coretstructhdr a,
    tstruct_mst_details m
  WHERE a.coretstructhdrid = m.sourceid AND a.modeofentry::text = 'Select From Sql'::text
UNION
 SELECT 6 AS sno,
    a.stransid AS transid,
    a.dcname,
    a.name,
    a.caption,
    a.datatype,
    a.customdatatype,
    a.datawidth,
    a.fdecimal,
    a.modeofentry,
    a.sql_editor_detail AS detail,
        CASE
            WHEN a.hidden::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS hidden,
        CASE
            WHEN a.allowempty::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowempty,
        CASE
            WHEN a.readonly::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS readonly,
        CASE
            WHEN a.setcarry::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS setcarry,
        CASE
            WHEN a.savevale::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS savevalue,
    a.exp_editor_expression AS expression,
    a.exp_editor_validateexpression AS validateexpression,
        CASE
            WHEN a.allowduplicate::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS allowduplicate,
        CASE
            WHEN a.onlypositive::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onlypositive,
    NULL::text AS sourcekey,
    NULL::text AS carryfield,
    NULL::text AS displaytotal,
    NULL::text AS windowwidth,
    NULL::text AS windowheight,
    NULL::text AS sql,
    'FALSE'::text AS autoselect,
    'FALSE'::text AS refresh1,
    NULL::text AS listvalues,
    NULL::text AS prefix,
    NULL::text AS prefix_fields,
    NULL::text AS description,
    NULL::text AS start_no,
    'FALSE'::text AS sactive,
    NULL::text AS no_of_digits,
    'FALSE'::text AS savenormalized,
        CASE
            WHEN a.suggestive_fill::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS suggestive,
    NULL::text AS sourcefield,
    NULL::text AS source_table,
    NULL::text AS datasource,
    NULL::text AS sequence,
    NULL::text AS tname,
    NULL::text AS fromtransid,
    NULL::text AS selectfield,
    NULL::text AS parent,
    NULL::text AS gui,
        CASE
            WHEN a.applycomma::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS applycomma,
    a.mask,
    a.pattern,
    a.pwdchar AS password_character,
    a.hint,
        CASE
            WHEN a.clienvalidation::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS clientvalidation,
    a.searchsql AS search_sql,
    a.displaydetails AS displaydetail,
        CASE
            WHEN a.tabstop::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS tabstop,
    m.sleveno,
    m.sordno,
    a.source,
    a.purpose,
    NULL::text AS cwidth,
    NULL::text AS list,
    NULL::text AS selectfrom,
    a.fldordno,
    m.trackchanges,
    m.trackchangesmadeby,
    m.selectedusers,
    m.selectedfields,
    a.master,
    'FALSE'::text AS combobox,
    a.componenttype,
    a.separator
   FROM coretstructhdr a,
    tstruct_mst_details m
  WHERE a.coretstructhdrid = m.sourceid AND a.modeofentry::text = 'Fill'::text
>>
<<
CREATE OR REPLACE VIEW vw_mdmap AS
 SELECT a.stransid,
    a.name,
    a.caption,
        CASE
            WHEN a.extended::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS extended,
    a.mastertransaction,
    a.masterfield,
    a.mastersearchfield,
    a.detailsearchfield,
    a.mastertable,
    a.updatetype,
    a.controlfield,
        CASE
            WHEN a.append::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS append,
        CASE
            WHEN a.initondel::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS initondel,
    a.maptext,
    a.detailfield,
        CASE
            WHEN a.onapprove::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onapprove,
        CASE
            WHEN a.onreject::text = 'T'::text THEN 'TRUE'::text
            ELSE 'FALSE'::text
        END AS onreject,
    a.purpose,
    a.dcname,
    a.ctdc,
    a.ctmd
   FROM axpdef_mdmap a
  WHERE a.ctdc IS NOT NULL
  ORDER BY a.name
>>
<<
CREATE OR REPLACE VIEW vw_tstruct_mst_details AS
 SELECT 1 AS ord,
    s.sourcetype,
    s.mastertransid,
    s.soucecaption,
    s.sourcedetails,
    s.sourcerules,
    s.sleveno,
    s.sordno,
    s.tstruct_mst_detailsid,
    s.sourceid,
    s.sourcetransid,
    s.sourcename,
    't'::text || s.sourcetransid::text AS ptransid,
    NULL::text AS linkurl,
    s.dcname
   FROM tstruct_mst_details s
>>
<<
CREATE OR REPLACE VIEW vw_tstructs AS
 SELECT a.ntransid AS transid,
    a.caption,
    a.purpose,
    a.savecontrolfield AS savecontrol,
    a.deletecontrolfield AS deletecontrol,
    a.trackchanges,
    a.attachment,
    a.listview,
    a.workflow,
    a.schema,
        CASE
            WHEN a.isacoretrans::text = 'Yes'::text THEN 'No'::text
            ELSE 'Yes'::text
        END AS isacoretrans,
    a.menuposition,
    a.menulist,
    a.selectfieldlist,
    a.selectuserlist,
    a.trackchangesmadeby,
    a.trackchangesfield,
    a.layouttype
   FROM axpdef_tstruct a
>>
<<
CREATE OR REPLACE FUNCTION fn_UPDATDSIGN() RETURNS TRIGGER
AS $AXDSIGNCONFIG$
	BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN 
		
		NEW.USERNAME = NEW.PUSERNAME; 
		new.rolename = new.prolename;
		
		return new;
	end if;
		
	IF (TG_OP = 'UPDATE') THEN 
		
		NEW.USERNAME = NEW.PUSERNAME; 
		new.rolename = new.prolename;
		
		return new;
	end if;
		
end; 
$AXDSIGNCONFIG$ LANGUAGE plpgsql;
>>
<<
create trigger TRG_UPDATDSIGN  
before insert or update on AXDSIGNCONFIG    
for each row

execute procedure fn_UPDATDSIGN();

end;


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

END;
>>
<<
ALTER TABLE AXUSERS ADD singleloginkey VARCHAR(50)
>>
<<
ALTER TABLE AX_PAGE_SAVED ADD WIDGET_GROUPS Varchar(1)
>>
<<
ALTER TABLE AX_PAGES ADD WIDGET_GROUPS Varchar(1)
>>
<<
DROP FUNCTION sysdate
>>
<<
CREATE OR REPLACE FUNCTION sysdate()
 RETURNS timestamp without time zone
 LANGUAGE plpgsql
AS $function$
BEGIN
RETURN to_CHAR(CURRENT_TIMESTAMP,'DD/MM/YYYY hh24:mi:ss');
END; $function$
;
>>
<<
DROP VIEW axp_vw_menulist
>>
<<
create or replace view axp_vw_menulist as 
SELECT replace(replace(COALESCE('\'::text || h.caption, ''::text) || COALESCE('\'::text || g.caption::text, ''::text), '\\\'::text, '\'::text), '\\'::text, '\'::text) AS menupath,
    g.name,
    g.ordno,
    g.levelno,
    g.parent,
    g.type,
    g.pagetype
   FROM axpages g
     LEFT JOIN ( SELECT COALESCE('\'::text || f.caption, ''::text) || COALESCE('\'::text || e.caption::text, ''::text) AS caption,
            e.parent,
            e.name
           FROM axpages e
             LEFT JOIN ( SELECT (COALESCE('\'::text || d.caption::text, ''::text) || '\'::text) || COALESCE(c.caption, ''::character varying)::text AS caption,
                    c.name
                   FROM axpages c
                     LEFT JOIN ( SELECT a.name,
                            a.parent,
                            a.caption,
                            a.levelno,
                            a.ordno,
                            1 AS levlno
                           FROM axpages a
                          WHERE a.levelno = 0::numeric
                          ORDER BY a.levelno, a.ordno) d ON c.parent::text = d.name::text
                  WHERE c.levelno = ANY (ARRAY[1::numeric, 0::numeric])) f ON e.parent::text = f.name::text
          WHERE e.levelno = ANY (ARRAY[1::numeric, 0::numeric, 2::numeric])) h ON g.parent::text = h.name::text
  WHERE coalesce(g.levelno,0) <= 3::numeric
  ORDER BY g.ordno, g.levelno;
>>
<<
create table Axp_TransCheck(sessionid varchar(50))
>>
<<
alter table AxTsUserConfig  add PropName varchar(10)
>>
<<
CREATE OR REPLACE FUNCTION getiview(isql character varying, inoofrec numeric, ipageno numeric, icountflag numeric, oresult refcursor, oiviewcount refcursor)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  v_frompos numeric;
 QRY VARCHAR(31000); 
 cnt numeric; 
    BEGIN     
    QRY := ISql; 
 cnt := 0; 
 IF (ICountFlag = 1 AND IPageNo = 1) THEN QRY := 'select count(*) recno from ('|| QRY ||')a';
  EXECUTE  QRY INTO cnt; 
  End If; 
  open OIviewCount for execute 'select '||to_char(cnt)||' as IviewCount from dual';
   QRY := ISql; 
   IF (INoofRec > 0 AND IPageNo > 0) THEN QRY:= 'select a.* from (select row_number()over() AS Rowno, '''' as axrowtype, a.* from (' || QRY||') a )a where a.Rowno > ' || cast( INoofRec * (IpageNo-1.00) as varchar ) || ' and ' || cast( INoofRec * (IpageNo) as varchar)|| ' >= a.Rowno'; 
   else QRY:='select row_number()over() AS Rowno, '''' as axrowtype, a.* from (' || QRY||') a '; 
   END IF; 
   open OResult for execute QRY; 
  exception when others then null;
    END;
$function$
;
>>
<<
 CREATE OR REPLACE FUNCTION fn_tconfiguration()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
	v_cnt numeric(2);

v_sql varchar(4000);

begin 
	

if (TG_OP = 'INSERT') then

select coalesce(count(table_name), 0) into v_cnt
from information_schema.tables
where lower(table_name) = lower( 'axpconfigs' || chr(95)|| new.structtransid )
and lower(table_schema)= current_schema();

if v_cnt = 0 then 
v_sql := 'create table axpconfigs' || chr(95)|| new.structtransid || ' ( configname varchar(30),cvalue varchar(2000),condition varchar(240))' ;

execute v_sql;
end if;

if new.cv_searchflds is not null then 
v_sql = 'insert into axpconfigs' || chr(95)|| new.structtransid || ' ( configname,cvalue,condition ) values (''' || new.configname1 || ''',''' || new.cv_searchflds || ''',null)';
execute v_sql;
end if;

if new.cv_groupbuttons is not null then 
v_sql = 'insert into axpconfigs' || chr(95)|| new.structtransid || ' ( configname,cvalue,condition ) values (''' || new.configname2 || ''',''' || new.cv_groupbuttons || ''',null)';
execute v_sql;
end if;

if new.cv_htmlprints is not null then 
v_sql = 'insert into axpconfigs' || chr(95)|| new.structtransid || ' ( configname,cvalue,condition ) values (''' || new.configname3 || ''',''' || new.cv_htmlprints || ''',null)';
execute v_sql;
end if;

if new.cv_masterflds is not null then 
v_sql = 'insert into axpconfigs' || chr(95)|| new.structtransid || ' ( configname,cvalue,condition ) values (''' || new.configname4 || ''',''' || new.cv_masterflds || ''',null)';
execute v_sql;
end if;

return new;

end if;

if (TG_OP = 'UPDATE') then 

v_sql = 'delete from axpconfigs' || chr(95)|| old.structtransid;
execute v_sql;

if new.cv_searchflds is not null then
v_sql = 'insert into axpconfigs' || chr(95)|| new.structtransid || ' ( configname,cvalue,condition ) values (''' || new.configname1 || ''',''' || new.cv_searchflds || ''',null)';
execute v_sql;
end if;

if new.cv_groupbuttons is not null then 
v_sql = 'insert into axpconfigs' || chr(95)|| new.structtransid || ' ( configname,cvalue,condition ) values (''' || new.configname2 || ''',''' || new.cv_groupbuttons || ''',null)';
execute v_sql;
end if;

if new.cv_htmlprints is not null then 
v_sql = 'insert into axpconfigs' || chr(95)|| new.structtransid || ' ( configname,cvalue,condition ) values (''' || new.configname3 || ''',''' || new.cv_htmlprints || ''',null)';
execute v_sql;
end if;

if new.cv_masterflds is not null then 
v_sql = 'insert into axpconfigs' || chr(95)|| new.structtransid || ' ( configname,cvalue,condition ) values (''' || new.configname4 || ''',''' || new.cv_masterflds || ''',null)';
execute v_sql;
end if;


return new;

end if;

if (TG_OP = 'DELETE') then 
v_sql = 'delete from axpconfigs' || chr(95)|| old.structtransid;
execute v_sql;
v_cnt = 2 ;

return new;

end if;



end;

$function$
;
>>
<<
DROP TRIGGER tr_axpconfigs_tstructs ON tconfiguration
>>
<<
create trigger tr_axpconfigs_tstructs before
insert
    or
delete
    or
update
    on
    tconfiguration for each row execute procedure fn_tconfiguration();
>>
<< 
CREATE OR REPLACE FUNCTION fn_iconfiguration()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
declare
v_cnt numeric(2);
v_sql varchar(4000);

	begin
		
		
		IF (TG_OP = 'INSERT') THEN 
		
		select COALESCE(count(table_name),0) into v_cnt from information_schema.tables where lower(table_name) = lower( 'axpconfigs'||chr(95)||new.structtransid ) and lower(table_schema)=current_schema();
      if v_cnt = 0
      then
      v_sql := 'create table axpconfigsiv'||chr(95)||new.structtransid||' ( configname varchar(30),cvalue varchar(2000),condition varchar(240))' ;
        execute v_sql;
		
        end if;
		

			if new.cv_groupbuttons is not null then
        v_sql = 'insert into axpconfigsiv'||chr(95)||new.structtransid||' ( configname,cvalue,condition ) values ('''||new.configname2||''','''||new.cv_groupbuttons||''',null)';
        execute  v_sql;
      	end if;
		
		return new;
		end if;
		
		IF (TG_OP = 'UPDATE') THEN 
		
		v_sql = 'delete from axpconfigsiv'||chr(95)||old.structtransid;
        execute  v_sql;        
        
		if new.cv_groupbuttons is not null then
        v_sql = 'insert into axpconfigsiv'||chr(95)||new.structtransid||' ( configname,cvalue,condition ) values ('''||new.configname2||''','''||new.cv_groupbuttons||''',null)';
        execute  v_sql;
      	end if;
		
		return new;
		
		end if;
		
		IF (TG_OP = 'DELETE') THEN 
		
		v_sql = 'delete from axpconfigsiv'||chr(95)||old.structtransid;
        execute  v_sql;   
        v_cnt = 2 ;
		
		return new;
		
		end if;
end; 
$function$
;
>>
<<
DROP TRIGGER tr_axpconfigs_iviews ON iconfiguration
>>
<<
create trigger tr_axpconfigs_iviews before
insert
    or
delete
    or
update
    on
    iconfiguration for each row execute procedure fn_iconfiguration();
>>   

<<
Drop view if exists vw_cards_calendar_data;
>>
<<
CREATE OR REPLACE VIEW vw_cards_calendar_data
AS SELECT DISTINCT a.uname,
    a.axcalendarid,
    a.eventname,
    a.sendername,
    a.messagetext,
    a.eventtype,
    a.startdate,
    COALESCE(a.axptm_starttime, '00:00'::character varying) AS axptm_starttime,
    a.enddate,
        CASE
            WHEN COALESCE(a.axptm_endtime, '00:00'::character varying)::text = '00:00'::text THEN '23:59'::character varying
            ELSE a.axptm_endtime
        END AS axptm_endtime,
    a.location,
    a.status,
    b.eventcolor,
        CASE
            WHEN a.sourceid = 0::numeric THEN a.axcalendarid
            ELSE a.sourceid
        END AS recordid,
    a.eventstatus,
    c.eventstatcolor,
    "substring"(a.mapname::text, 1, 5) AS mapname
   FROM axcalendar a
     JOIN axpdef_axcalendar_event b ON a.axpdef_axcalendar_eventid = b.axpdef_axcalendar_eventid
     LEFT JOIN ( SELECT axpdef_axcalendar_eventstatus.axpdef_axcalendar_eventid,
            axpdef_axcalendar_eventstatus.eventstatus,
            axpdef_axcalendar_eventstatus.eventstatcolor
           FROM axpdef_axcalendar_eventstatus) c ON a.axpdef_axcalendar_eventid = c.axpdef_axcalendar_eventid AND a.eventstatus::text = c.eventstatus::text
  WHERE a.cancel::text = 'F'::text AND a.parenteventid > 0::numeric
UNION ALL
 SELECT DISTINCT a.sendername AS uname,
    a.axcalendarid,
    a.eventname,
    a.sendername,
    a.messagetext,
    a.eventtype,
    a.startdate,
    COALESCE(a.axptm_starttime, '00:00'::character varying) AS axptm_starttime,
        CASE
            WHEN a.recurring IS NULL THEN a.enddate
            ELSE a.startdate
        END AS enddate,
        CASE
            WHEN COALESCE(a.axptm_endtime, '00:00'::character varying)::text = '00:00'::text THEN '23:59'::character varying
            ELSE a.axptm_endtime
        END AS axptm_endtime,
    a.location,
    a.status,
    b.eventcolor,
        CASE
            WHEN a.sourceid = 0::numeric THEN a.axcalendarid
            ELSE a.sourceid
        END AS recordid,
    a.eventstatus,
    c.eventstatcolor,
    "substring"(a.mapname::text, 1, 5) AS mapname
   FROM axcalendar a
     JOIN axpdef_axcalendar_event b ON a.axpdef_axcalendar_eventid = b.axpdef_axcalendar_eventid
     LEFT JOIN ( SELECT axpdef_axcalendar_eventstatus.axpdef_axcalendar_eventid,
            axpdef_axcalendar_eventstatus.eventstatus,
            axpdef_axcalendar_eventstatus.eventstatcolor
           FROM axpdef_axcalendar_eventstatus) c ON a.axpdef_axcalendar_eventid = c.axpdef_axcalendar_eventid AND a.eventstatus::text = c.eventstatus::text
  WHERE a.cancel::text = 'F'::text AND a.parenteventid = 0::numeric
  ORDER BY 7;
>>
<<
INSERT INTO axpdef_axpertprops (axpdef_axpertpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, smtphost, smtpport, smtpuser, smtppwd, amtinmillions, currseperator, lastlogin, autogen, customfrom, customto, loginattempt, pwdexp, pwdchange, pwdminchar, pwdreuse, pwdalphanum, pwdencrypt, axpsiteno) VALUES(1, 'F', 0, NULL, 'admin', '2022-01-17 13:28:03.000', 'admin', '2022-01-17 13:28:03.000', NULL, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, 'F', 'F', 'T', 'F', NULL, NULL, 0, 0, 0, 0, 0, 'F', 'F', 0);
>>  
<<
CREATE OR REPLACE FUNCTION tr_axpconfigs_tstructs()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
 V_CNT NUMERIC(2);
V_SQL VARCHAR(4000);
    BEGIN      
     IF TG_OP='INSERT' OR TG_OP='UPDATE'
    THEN 
    

     IF TG_OP='INSERT' THEN
     SELECT COALESCE(COUNT(TABLE_NAME),0) INTO V_CNT FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=CURRENT_SCHEMA AND  LOWER(TABLE_NAME) = LOWER( 'axpconfigs'||CHR(95)||NEW.STRUCTTRANSID );
      IF V_CNT = 0
      THEN
      V_SQL := 'create table axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname varchar(30),cvalue varchar(2000),condition varchar(2000))' ;
        EXECUTE  V_SQL;
        END IF;
    ELSIF TG_OP='UPDATE'
    THEN
	
        V_SQL = 'delete from axpconfigs'||CHR(95)||OLD.STRUCTTRANSID;
		begin
        EXECUTE  V_SQL; 
		exception when others then null;
		end ;
        END IF;
        
     IF NEW.CV_SEARCHFLDS IS NOT NULL and NEW.CV_SEARCHFLDS  <> ''
      THEN
        V_SQL = 'insert into axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname,cvalue,condition ) values ('''||NEW.CONFIGNAME1||''','''||NEW.CV_SEARCHFLDS||''',null)';
        EXECUTE  V_SQL;
      END IF;
      
      IF NEW.CV_GROUPBUTTONS IS NOT NULL and NEW.CV_GROUPBUTTONS <>''
      THEN
        V_SQL = 'insert into axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname,cvalue,condition ) values ('''||NEW.CONFIGNAME2||''','''||NEW.CV_GROUPBUTTONS||''',null)';
        EXECUTE  V_SQL;
      END IF;
      
      IF NEW.CV_HTMLPRINTS IS NOT NULL and NEW.CV_HTMLPRINTS <> ''
      THEN
        V_SQL = 'insert into axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname,cvalue,condition ) values ('''||NEW.CONFIGNAME3||''','''||NEW.CV_HTMLPRINTS||''',null)';
        EXECUTE  V_SQL;
      END IF;     
              
      IF NEW.CV_MASTERFLDS IS NOT NULL and NEW.CV_MASTERFLDS <>''
      THEN
        V_SQL = 'insert into axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname,cvalue,condition ) values ('''||NEW.CONFIGNAME4||''','''||NEW.CV_MASTERFLDS||''',null)';
        EXECUTE  V_SQL;
      END IF;
      
    END IF;
    
    
    IF TG_OP='DELETE'
    THEN
        V_SQL = 'delete from axpconfigs'||CHR(95)||OLD.STRUCTTRANSID;
        EXECUTE  V_SQL;   
        END IF;
       RETURN NEW;
    END;
$function$
;
>>
<<
create trigger tr_axpconfigs_tstructs1 after insert
    or delete
        or update
            on
            tconfiguration for each row execute procedure tr_axpconfigs_tstructs();
>>
<<
CREATE OR REPLACE FUNCTION tr_axpconfigs_iviews()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
 v_cnt NUMERIC(2);
v_sql varchar(4000);
    BEGIN 	 
	  if TG_OP='INSERT'
    then
	 select  count(1)  into v_cnt from information_schema.tables where table_schema=current_schema and lower(table_name) = lower( 'axpconfigsiv'||chr(95)||new.structtransid  );
     
	 if v_cnt = 0
      then
        v_sql := 'create table axpconfigsiv'||chr(95)||new.structtransid ||' ( configname varchar(30),cvalue varchar(240),condition varchar(240))' ;
        execute  v_sql;
		end if;
		
if new.cv_groupbuttons is not null
      then
        v_sql = 'insert into axpconfigsiv'||chr(95)||new.structtransid||' ( configname,cvalue,condition ) values ('''||new.configname2||''','''||new.cv_groupbuttons||''',null)';
        execute  v_sql;
      end if;
	  
end if;	  
	  
    if TG_OP='UPDATE'
    then
        v_sql = 'delete from axpconfigsiv'||chr(95)||old.structtransid;
        execute  v_sql;  
		
      if new.cv_groupbuttons is not null
      then
        v_sql = 'insert into axpconfigsiv'||chr(95)||new.structtransid||' ( configname,cvalue,condition ) values ('''||new.configname2||''','''||new.cv_groupbuttons||''',null)';
        execute  v_sql;
      end if;
	  
	end if;  
     if TG_OP='DELETE' 
    then
        v_sql = 'delete from axpconfigsiv'||chr(95)||old.structtransid;
        execute  v_sql;   
    end if;
  
	
       RETURN NEW;
    END;$function$;
>>
<<
create trigger tr_axpconfigs_iviews1 after insert
    or delete
        or update
            on
            iconfiguration for each row execute procedure tr_axpconfigs_iviews();
>>
-------Developer Option Keys 
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
Insert into AXCTX1(AXCONTEXT, ATYPE) Values ('File Upload Limit', 'Property')
>>
<<
Insert into AXCTX1(AXCONTEXT, ATYPE) Values   ('camera option', 'Property')
>>
<<
 Insert into AXCTX1(AXCONTEXT, ATYPE) Values ('Date format','Property')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Text')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Lds')
>>
<<
Insert into AXCTX1(AXCONTEXT, ATYPE) Values('GridEdit', 'Property')
>>
<<
Insert into AXCTX1   (AXCONTEXT, ATYPE) Values ('FormLoad', 'Property')
>>
<<
insert into axctx1(axcontext,atype) values ('Multi Select','Property')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Resolve Attachment Path')
>>
<<
insert into axctx1 (axcontext,atype) values ('Custom JavaScript','Property')
>>
<<
insert into axctx1 (axcontext,atype) values ('Custom CSS','Property')
>>
<<
insert into axctx1 (axcontext,atype) values('Auto Save Draft','Property')
>>
<<
insert into axctx1 (axcontext,atype) values('Show keyboard in Hybrid App','Property')
>>
<< 
INSERT INTO axctx1 (axcontext,atype) values ('Mobile Reports as Table','Property') 
>>
<<
INSERT INTO axctx1 (axcontext,atype) values ('Iview Button Style','Property') 
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'icon path')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Tstruct Button Style')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Apply Mobile UI')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Split Ratio')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Iview Retain Parameters On Next Load')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Fixed Header for Grid')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Iview Responsive Column Width')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Not Fill Dependent Fields')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Fill Dependent Fields')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Striped Reports UI')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'HomePageTemplate')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'CompressedMode')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Upload file types')
>>
<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Autosplit')
>>
<<
insert into axctx1(atype,axcontext) values('Property','Google Maps Zoom')
>>
<<
insert into axctx1(atype,axcontext) values('Property','Iview Session Caching');
>>
--------------------- Configuration Properties
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000000, 'F', 0, NULL, 'admin', '2022-12-26 14:22:37.000', 'admin', '2019-11-15 15:17:24.000', NULL, 1, 1, NULL, NULL, NULL, 'ExportVerticalAlign', 'ExportVerticalAlign', 'allows you to set excel row data vertical aligned', 'configtypeExportVerticalAlign', '', 'Iview', 'F', 'F', 'T', 'F', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000004, 'F', 0, NULL, 'admin', '2022-12-26 14:24:57.000', 'admin', '2019-11-15 15:17:43.000', NULL, 1, 1, NULL, NULL, NULL, 'Excel Export', 'Excel Export', 'enable Excel button in reports to download the report data into excel format', 'configtypeExcel Export', '', 'Iview', 'F', 'F', 'T', 'F', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000007, 'F', 0, NULL, 'admin', '2022-12-26 14:26:51.000', 'admin', '2019-11-15 15:17:58.000', NULL, 1, 1, NULL, NULL, NULL, 'Trim IView Data', 'Trim IView Data', 'Enable/Disable to trim spaces in iview data', 'configtypeTrim IView Data', '', 'Iview', 'F', 'F', 'T', 'F', 'T', '');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000012, 'F', 0, NULL, 'admin', '2022-12-26 14:28:28.000', 'admin', '2019-11-15 15:18:35.000', NULL, 1, 1, NULL, NULL, NULL, 'ApplicationCompressedMode', 'General', 'This property will allow you to fit the page on screen, it will disable the card layout of the application.', 'configtypeApplicationCompressedMode', '', 'Common', 'F', 'F', 'F', 'F', 'F', '');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000015, 'F', 0, NULL, 'admin', '2022-12-26 14:31:10.000', 'admin', '2019-11-15 15:18:53.000', NULL, 1, 1, NULL, NULL, NULL, 'ApplicationTemplate', 'General', 'Using this property you can change the application layout template.', 'configtypeApplicationTemplate', '', 'All', 'F', 'F', 'F', 'F', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000550000003, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Load forms along with list', 'Autosplit', 'Enable split on tstruct and load along with listview', 'configtypeLoad forms along with list', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'F', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000550000006, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Load reports/lists along with form', 'Autosplit', 'Enable split on iview and open/load the tstruct on the first hyperlink', 'configtypeLoad reports/lists along with form', NULL, 'Iview', 'F', 'F', NULL, 'F', 'T', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000550000009, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Disablesplit', 'Disablesplit', 'To disable split to the application or page wise', 'configtypeDisablesplit', NULL, 'All', 'F', 'F', NULL, 'T', 'T', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000550000012, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Open Window mode', 'Navigation', 'Open Window mode', 'configtypeOpen Window mode', NULL, 'All', 'T', 'T', NULL, 'F', 'F', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1040440000000, 'F', 0, NULL, 'admin', '2019-04-10 00:00:00.000', 'admin', '2019-04-10 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Tstruct Grid edit option', 'GridEdit', 'Enable/Disable to inline grid or popup grid', 'configtypeTstruct Grid edit option', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'F', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1903990000000, 'F', 0, NULL, 'admin', '2019-01-23 00:00:00.000', 'admin', '2019-01-23 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Align Text', 'Text', 'Align Text', 'configtypeAlign Text', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'T', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1751880000000, 'F', 0, NULL, 'admin', '2019-04-05 00:00:00.000', 'admin', '2019-04-05 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Main Page Reload', 'General', 'Main Page Reload', 'configtypeMain Page Reload', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'T', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1742550000002, 'F', 0, NULL, 'admin', '2019-04-03 00:00:00.000', 'admin', '2019-04-03 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Change Password', 'General', 'Enable/Disable change password option for cloud application', 'configtypeChange Password', NULL, 'All', 'F', 'F', NULL, 'T', 'T', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000440000000, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Autocomplete Search Pattern', 'Autocomplete Search Pattern', 'Autocomplete Search Pattern', 'configtypeAutocomplete Search Pattern', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'F', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1742550000005, 'F', 0, NULL, 'admin', '2019-04-03 00:00:00.000', 'admin', '2019-04-03 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Landing Structure', 'General', 'Landing Structure', 'configtypeLanding Structure', NULL, 'All', 'F', 'F', NULL, 'T', 'T', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1742550000008, 'F', 0, NULL, 'admin', '2019-04-03 00:00:00.000', 'admin', '2019-04-03 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'FetchSize', 'FetchSize', 'Page Size number of Iview data to be loaded', 'configtypeFetchSize', NULL, 'All', 'F', 'F', NULL, 'T', 'T', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1790770000000, 'F', 0, NULL, 'pandi', '2019-04-12 00:00:00.000', 'pandi', '2019-04-12 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Local Dataset', 'Lds', 'Local Dataset', 'configtypeLocal Dataset', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'T', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1104220000000, 'F', 0, NULL, 'admin', '2019-02-25 00:00:00.000', 'admin', '2019-02-25 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'FormLoad Cache', 'FormLoad', 'To avoid tstruct formload service call', 'configtypeFormLoad Cache', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'F', 'T');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1657440000021, 'F', 0, NULL, 'admin', '2019-06-03 00:00:00.000', 'admin', '2019-06-03 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Save Image in DB', 'SaveImage', 'Save Image in DB', 'configtypeSave Image in DB', NULL, 'Tstruct', 'F', 'F', 'T', 'T', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(2680010000000, 'F', 0, NULL, 'admin', '2019-06-13 00:00:00.000', 'admin', '2019-06-13 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Date Format', 'General', 'Date Format', 'configtypeDate Format', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'T');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(2175770000001, 'F', 0, NULL, 'admin', '2019-07-04 00:00:00.000', 'admin', '2019-06-29 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Hide Camera Option', 'camera option', 'Hide Camera Option', 'configtypeHide Camera Option', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(2037880000001, 'F', 0, NULL, 'admin', '2019-07-05 00:00:00.000', 'admin', '2019-07-05 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'File upload limit', 'File Upload Limit', 'File upload limit', 'configtypeFile upload limit', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'T');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1008440000004, 'F', 0, NULL, 'admin', '2019-12-27 17:34:22.000', 'admin', '2019-12-27 17:34:22.000', NULL, 1, 1, NULL, NULL, NULL, 'Multi Select Field', 'Multi Select', 'Multi Select Field', 'configtypeMulti Select Field', NULL, 'Tstruct', 'F', 'F', 'T', 'T', 'F', 'T');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1072550000000, 'F', 0, NULL, 'superadmin', '2020-01-31 00:00:00.000', 'superadmin', '2020-01-31 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Global Parameter Form', 'General', 'Global Parameter Form', 'configtypeGlobal Parameter Form', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'T');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1072550000006, 'F', 0, NULL, 'superadmin', '2020-01-31 00:00:00.000', 'superadmin', '2020-01-31 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Google Maps Api Key', 'General', 'Google Maps Api Key', 'configtypeGoogle Maps Api Key', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1235440000043, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.484', 'admin', '2022-12-25 22:29:56.484', NULL, 1, 1, NULL, NULL, NULL, 'Custom JavaScript', 'Custom JavaScript', 'Reports:
Use this property to attach custom javascript to Reports/forms. Set this property value to "true" for a selected report. If this property is set to true, the custom javascript file for Reposts should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.js. In case this property is set to true for all reports instead of a selected report, the file name should be custom.js

Tstructs:
Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.', 'configtypeCustom JavaScript', '', 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1235660000010, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.485', 'admin', '2022-12-25 22:29:56.485', NULL, 1, 1, NULL, NULL, NULL, 'Custom CSS', 'Custom CSS', 'Reports:
Use this property to attach custom CSS to Reports. Set this property value to "True" for a selected report. If for report this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.CSS. In case this property is set to true for all reports instead of a selected report, the file name should be custom.CSS.

Tstructs:
Use this property to attach custom CSS to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.CSS. In case this property is set to true for all forms instead of a selected form, the file name should be custom.CSS.
', 'configtypeCustom CSS', '', 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1355440000006, 'F', 0, NULL, 'admin', '2022-12-25 22:29:56.490', 'admin', '2022-12-25 22:29:56.490', NULL, 1, 1, NULL, NULL, NULL, 'Auto Save Draft', 'Auto Save Draft', 'If key is set to true and time in millisecs(for ex for 60 secs give 60000 . Note: default time will be 120 seconds/2 minutes if no time is set) then on loading tstruct,it will check if unsaved data is there, if unsaved data  exists it will throw a popup with yes /no buttons.If yes, it will load the unsaved data else it will load a new tstruct.If new tstruct is opened for which key exists,then only if any field is changed,it will push data in redis after the mentioned time  in developer options at regular intervals.', 'configtypeAuto Save Draft', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1355440000003, 'F', 0, NULL, 'admin', '2022-12-25 22:29:56.491', 'admin', '2022-12-25 22:29:56.491', NULL, 1, 1, NULL, NULL, NULL, 'Show keyboard in Hybrid App', 'Show keyboard in Hybrid App', 'An enhancement to make an intuitive UI in Axpert Hybrid App i.e., 
-- based on the "Show keyboard in Hybrid App" key value, user can enable or disable the keyboard for autocomplete fields in tstruct level.
-- By default, value is set as true which makes no difference in the existing feature/functionality.
-- If set false,  keyboard is hidden/disabled along with the drop-down and clear icons. On single click of the field, drop down appears to choose the desired value.
', 'configtypeShow keyboard in Hybrid App', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1635440000037, 'F', 0, NULL, 'admin', '2022-12-25 22:29:56.517', 'admin', '2022-12-25 22:29:56.517', NULL, 1, 1, NULL, NULL, NULL, 'Enforced Strong Password Policy', 'General', 'If key is set to true,Strong Password Policy will work.Details for Enforced Strong Password Policy: Password should be alphanumeric, contains one UpperCharacter, one LowerCharacter with atleast one special character.It will check the following condition if key set to true and if password entered is not matching the condition,then it will throw error.', 'configtypeEnforced Strong Password Policy', NULL, 'Common', 'F', 'F', 'F', 'F', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1984880000036, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.519', 'superadmin', '2022-12-25 22:29:56.519', NULL, 1, 1, NULL, NULL, NULL, 'Notification Time Interval', 'General', 'Notification feature can be enabled at Application level by adding Developer Option "Notification Time Interval" , with values in minutes for time intervals as 1, 2, 3 , 4 etc. Once this key is added, long running web services/backend scheduled jobs completion can be notified to the user with given time intervals, so that user would be able to do other operations during long running web services/backend jobs.', 'configtypeNotification Time Interval', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1984440000004, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.520', 'superadmin', '2022-12-25 22:29:56.520', NULL, 1, 1, NULL, NULL, NULL, 'User Manual', 'General', 'User can able to access the files through web application which is saved in local folder through User Manual option (located in right sidebar menu)', 'configtypeUser Manual', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1984220000001, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.521', 'superadmin', '2022-12-25 22:29:56.521', NULL, 1, 1, NULL, NULL, NULL, 'Mobile Reports as Table', 'Mobile Reports as Table', 'Administrator can enable tabular view in mobile instead of cards view', 'configtypeMobile Reports as Table', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000330000005, 'F', 0, NULL, 'admin', '2022-12-25 22:29:56.532', 'admin', '2022-12-25 22:29:56.532', NULL, 1, 1, NULL, NULL, NULL, 'WebService Timeout', 'WebService Timeout', 'WebService Timeout', 'configtypeWebService Timeout', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1251990000026, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.536', 'superadmin', '2022-12-25 22:29:56.536', NULL, 1, 1, NULL, NULL, NULL, 'Show Image Widget Action Button', 'General', 'The SmartView''s columns template can be changed to achieve desired UI and Actions', 'configtypeShow Image Widget Action Button', NULL, 'Common', 'F', 'F', 'F', 'T', 'T', 'T');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1420440000004, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.538', 'superadmin', '2022-12-25 22:29:56.538', NULL, 1, 1, NULL, NULL, NULL, 'Show Application Menu on Login', 'General', 'Application menu can be shown/hidden by setting this Developer Option.', 'configtypeShow Application Menu on Login', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1072550000003, 'F', 0, NULL, 'superadmin', '2020-01-31 00:00:00.000', 'superadmin', '2020-01-31 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Resolve Attachment Path', 'Resolve Attachment Path', 'Resolve Attachment Path', 'configtypeResolve Attachment Path', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1226220000004, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.534', 'superadmin', '2022-12-25 22:29:56.534', NULL, 1, 1, NULL, NULL, NULL, 'Iview Button Style', 'Iview Button Style', 'New Iview buttons UI can be switched as Modern(Google like UI) / Classic(Classic Bootstrap like UI) . Product default Iview Button UI is  "Modern" Style.', 'configtypeIview Button Style', '', 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1314010000000, 'F', 0, NULL, 'admin', '2021-04-14 12:01:12.000', 'admin', '2021-03-31 11:50:59.000', NULL, 1, 1, NULL, NULL, NULL, 'Tstruct Button Style', 'Tstruct Button Style', 'Tstruct Button Style', 'configtypeTstruct Button Style', '', 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'T');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1294220000002, 'F', 0, NULL, 'admin', '2021-04-27 18:22:36.000', 'admin', '2021-04-27 18:22:36.000', NULL, 1, 1, NULL, NULL, NULL, 'Apply Mobile UI', 'Apply Mobile UI', 'Apply Mobile UI', 'configtypeApply Mobile UI', NULL, 'Tstruct', 'T', 'F', 'T', 'T', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(9436330000000, 'F', 0, NULL, 'admin', '2021-07-21 18:40:15.000', 'admin', '2021-07-21 18:25:02.000', NULL, 1, 1, NULL, NULL, NULL, 'Split Ratio', 'Split Ratio', ' Description : Split Ratio format - windowSIze1:windowsize2:splitRatioType(Optional: auto(default)/fixed)
            § Developer Option Key : Split Ratio
        ○ Note: Split Ratio value is in following format 
            § windowSIze1:windowsize2:splitRatioType(Optional: auto(default)/fixed)
            §  Example:
                □ 1:1
                □ 1:2:auto
                □ 2:1
                □ 25:75
                □ 40:60
                □ 1:3:fixed
            § Split Ratio Type
                □ auto(default)
                    ®  If window is not resized manually then given split ratio configuration will be used
                    ® If window is resized manually then configuration is ignored
                □ fixed
                    ® If configuration is applied with fixed then resized window size will be ignored and split ratio configuration will always be applied', 'configtypeSplit Ratio', '', 'All', 'F', 'T', 'T', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1913880000000, 'F', 0, NULL, 'admin', '2021-11-03 20:05:58.000', 'swetha', '2021-10-29 18:23:59.000', NULL, 1, 1, NULL, NULL, NULL, 'Fixed Header for Grid', 'Fixed Header for Grid', 'Fixed Header for Grid', 'configtypeFixed Header for Grid', '', 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1005770000000, 'F', 0, NULL, 'admin', '2021-12-07 13:32:15.000', 'admin', '2021-12-07 13:32:15.000', NULL, 1, 1, NULL, NULL, NULL, 'Not Fill Dependent Fields', 'Not Fill Dependent Fields', 'Not Fill Dependent Fields', 'configtypeNot Fill Dependent Fields', NULL, 'Tstruct', 'F', 'F', 'T', 'T', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1005880000000, 'F', 0, NULL, 'admin', '2021-12-07 13:33:12.000', 'admin', '2021-12-07 13:33:12.000', NULL, 1, 1, NULL, NULL, NULL, 'Fill Dependent Fields', 'Fill Dependent Fields', 'Fill Dependent Fields', 'configtypeFill Dependent Fields', NULL, 'Tstruct', 'F', 'F', 'T', 'T', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1210110000000, 'F', 0, NULL, 'admin', '2022-08-12 10:55:30.000', 'admin', '2022-08-12 10:55:30.000', NULL, 1, 1, NULL, NULL, NULL, 'Listview as default from search', 'General', 'Listview as default from search', 'configtypeListview as default from search', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1373110000000, 'F', 0, NULL, 'admin', '2022-12-02 16:06:01.000', 'admin', '2022-12-02 16:06:01.000', NULL, 1, 1, 0, NULL, NULL, 'Upload file types', 'Upload file types', 'Upload file types', 'configtypeUpload file types', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1913770000000, 'F', 0, NULL, 'admin', '2021-11-03 20:04:40.000', 'swetha', '2021-10-29 18:21:27.000', NULL, 1, 1, NULL, NULL, NULL, 'Iview Retain Parameters On Next Load', 'Iview Retain Parameters On Next Load', 'Iview Retain Parameters On Next Load', 'configtypeIview Retain Parameters On Next Load', '', 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1883880000000, 'F', 0, NULL, 'admin', '2021-11-19 19:27:08.000', 'admin', '2021-11-19 19:23:23.000', NULL, 1, 1, NULL, NULL, NULL, 'Iview Responsive Column Width', 'Iview Responsive Column Width', NULL, 'configtypeIview Responsive Column Width', NULL, 'All', 'F', 'F', NULL, 'T', 'T', NULL);
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1121550000000, 'F', 0, NULL, 'admin', '2022-12-29 08:30:30.000', 'admin', '2022-12-29 08:30:30.000', NULL, 1, 1, NULL, NULL, NULL, 'Google Maps Zoom', 'Google Maps Zoom', 'Google Maps Zoom', 'configtypeGoogle Maps Zoom', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F');
>>
<<
INSERT INTO axpstructconfigprops
(axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, dupchk, context, ptype, caction, chyperlink, alltstructs, alliviews, alluserroles, cfields, description)
VALUES(1518330000000, 'F', 0, NULL, 'admin', '2022-12-29 11:41:12.000', 'admin', '2022-12-29 11:41:12.000', NULL, 1, 1, 0, NULL, NULL, 'Iview Session Caching', 'Iview Session Caching', 'configtypeIview Session Caching', NULL, 'Iview', 'F', 'F', 'F', 'T', 'F', 'F', 'Iview Session Caching');
>>
<<
update axpstructconfigprops set description= configprops where description is null or description=''
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000004, 1000550000003, 1, 'True');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000005, 1000550000003, 2, 'False');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000007, 1000550000006, 1, 'True');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000008, 1000550000006, 2, 'False');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000010, 1000550000009, 1, 'True');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000011, 1000550000009, 2, 'False');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000013, 1000550000012, 1, 'Default');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000014, 1000550000012, 2, 'Popup');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000015, 1000550000012, 3, 'Newpage');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000016, 1000550000012, 4, 'Split');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000001, 1000220000000, 1, 'middle');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000002, 1000220000000, 2, 'top');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000003, 1000220000000, 3, 'bottom');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000005, 1000220000004, 1, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000006, 1000220000004, 2, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000008, 1000220000007, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000009, 1000220000007, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000013, 1000220000012, 1, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000014, 1000220000012, 2, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000016, 1000220000015, 1, 'mainPageTemplate.html');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000440000001, 1000440000000, 1, 'starts with');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000440000002, 1000440000000, 2, 'contains');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1840440000000, 1314010000000, 1, 'old');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1840440000001, 1314010000000, 2, 'modern');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1840440000002, 1314010000000, 3, 'classic');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1294220000003, 1294220000002, 1, 'all');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1294220000004, 1294220000002, 2, 'mobile');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1294220000005, 1294220000002, 3, 'none');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000001, 9436330000000, 1, '1:1');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000002, 9436330000000, 2, '1:2:auto');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000003, 9436330000000, 3, '2:1 ');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000004, 9436330000000, 4, '25:75:fixed');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000003, 1742550000002, 1, 'Disable');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000004, 1742550000002, 2, 'Enable');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000007, 1742550000005, 2, 'iview');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000006, 1742550000005, 1, 'tstruct');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000010, 1742550000008, 2, '30');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000028, 1742550000008, 20, '5000');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000027, 1742550000008, 19, '2000');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000026, 1742550000008, 18, '1000');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000009, 1742550000008, 1, '25');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000029, 1742550000008, 21, 'ALL');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000011, 1742550000008, 3, '35');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000012, 1742550000008, 4, '40');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000013, 1742550000008, 5, '45');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000014, 1742550000008, 6, '50');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000015, 1742550000008, 7, '55');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000016, 1742550000008, 8, '60');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000017, 1742550000008, 9, '65');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000018, 1742550000008, 10, '70');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000019, 1742550000008, 11, '75');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000020, 1742550000008, 12, '80');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000021, 1742550000008, 13, '85');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000022, 1742550000008, 14, '90');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000023, 1742550000008, 15, '95');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000024, 1742550000008, 16, '100');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000025, 1742550000008, 17, '500');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1751880000001, 1751880000000, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1751880000002, 1751880000000, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1903990000001, 1903990000000, 1, 'Right');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1903990000002, 1903990000000, 2, 'Left');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1790770000002, 1790770000000, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1040440000001, 1040440000000, 1, 'Inline');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1040440000002, 1040440000000, 2, 'Popup');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000001, 1104220000000, 1, '30 min');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000002, 1104220000000, 2, '1 hour');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000003, 1104220000000, 3, '2 hour');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000004, 1104220000000, 4, '5 hour');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000005, 1104220000000, 5, '10 hour');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000006, 1104220000000, 6, 'None');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1657440000022, 1657440000021, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000005, 9436330000000, 5, '40:60');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1913770000001, 1913770000000, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1913770000002, 1913770000000, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1913880000001, 1913880000000, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1913880000002, 1913880000000, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1883880000001, 1883880000000, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1883880000002, 1883880000000, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1005770000001, 1005770000000, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1005770000002, 1005770000000, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1005880000001, 1005880000000, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1005880000002, 1005880000000, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1210110000001, 1210110000000, 1, 'True');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1210110000002, 1210110000000, 2, 'False');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1373110000001, 1373110000000, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1373110000002, 1373110000000, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1237550000000, 1742550000005, 3, 'general');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1787880000005, 1742550000008, 22, '10');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(2680010000001, 2680010000000, 1, 'en-US');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(2175770000002, 2175770000001, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(2037880000002, 2037880000001, 1, '1');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1008440000005, 1008440000004, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1008440000006, 1008440000004, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1072550000001, 1072550000000, 1, 'hide');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1072550000002, 1072550000000, 2, 'show');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1072550000004, 1072550000003, 1, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1072550000005, 1072550000003, 2, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1235440000044, 1235440000043, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1235440000045, 1235440000043, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1235660000011, 1235660000010, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1235660000012, 1235660000010, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000004, 1355440000003, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000005, 1355440000003, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000007, 1355440000006, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000008, 1355440000006, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000010, 1355440000009, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000011, 1355440000009, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1635440000038, 1635440000037, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984220000002, 1984220000001, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984220000003, 1984220000001, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984440000005, 1984440000004, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984440000006, 1984440000004, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000037, 1984880000036, 1, '1');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000038, 1984880000036, 2, '3');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000039, 1984880000036, 3, '5');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000040, 1984880000036, 4, '10');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000041, 1984880000036, 5, '30');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000330000006, 1000330000005, 1, '100000');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1525110003964, 1000330000005, 2, '1000000');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1226220000005, 1226220000004, 1, 'Modern');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1226220000006, 1226220000004, 2, 'Classic');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1251990000027, 1251990000026, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1251990000028, 1251990000026, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1420440000005, 1420440000004, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1420440000006, 1420440000004, 2, 'false');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000001, 1121550000000, 1, '1');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000002, 1121550000000, 2, '5');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000003, 1121550000000, 3, '10');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000004, 1121550000000, 4, '11');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000005, 1121550000000, 5, '15');
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000006, 1121550000000, 6, '20');
>>
<<
INSERT INTO axpstructconfigproval(axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues)VALUES(1518330000001, 1518330000000, 1, 'true');
>>
<<
INSERT INTO axpstructconfigproval(axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues)VALUES(1518330000002, 1518330000000, 2, 'false');
>>
-------------------Developer Option
<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(2038330000000, 'F', 0, NULL, 'admin', '2019-07-05 00:00:00.000', 'admin', '2019-07-05 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'File upload limit', 'Tstruct', 'File Upload Limit', NULL, '1', NULL, '1', NULL, 'ALL Forms', 'ALL Forms', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'File upload limitALL Forms1ALL', NULL);
>>
<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(2176010000000, 'F', 0, NULL, 'admin', '2019-07-04 00:00:00.000', 'admin', '2019-06-29 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Hide Camera Option', 'Tstruct', 'camera option', NULL, 'true', NULL, 'true', NULL, 'ALL Forms', 'ALL Forms', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'Hide Camera OptionALL FormstrueALL', NULL);
>>
<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(1386770000002, 'F', 0, NULL, 'admin', '2019-06-05 00:00:00.000', 'admin', '2019-06-05 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Save Image in DB', 'Tstruct', 'SaveImage', NULL, 'true', NULL, 'true', NULL, 'My Profile(dprof)', 'dprof', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'Save Image in DBdproftrueALL', NULL);
>>
<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(1799550000000, 'F', 0, NULL, 'admin', '2019-06-08 00:00:00.000', 'admin', '2019-06-08 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'FetchSize', 'All', 'FetchSize', NULL, '25', NULL, '25', NULL, 'ALL Reports', 'ALL Reports', NULL, NULL, NULL, NULL, NULL, 'Iview', 'ALL', 'FetchSizeALL Reports25ALL', 'Page Size number of Iview data to be loaded');
>>
<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(1058330000000, 'F', 0, NULL, 'admin', '2019-05-17 00:00:00.000', 'admin', '2019-05-17 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Tstruct Grid edit option', 'Tstruct', 'GridEdit', NULL, 'inline', NULL, 'inline', NULL, 'ALL Forms', 'ALL Forms', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'Tstruct Grid edit optionALL FormsinlineALL', 'Enable/Disable to inline grid or popup grid');
>>
<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(1573550000000, 'F', 0, NULL, 'admin', '2019-01-10 00:00:00.000', 'admin', '2019-01-10 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Disablesplit', 'All', 'Disablesplit', NULL, 'true', NULL, 'true', NULL, 'Advance Settings(axstc)', 'axstc', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'DisablesplitaxstctrueALL', 'To disable split to the application or page wise');
>>
-------------11.2
<<
ALTER TABLE tstructs ADD runtimemod varchar(1) NULL
>>
<<
ALTER TABLE tstructs ADD runtimetstruct varchar(1) NULL
>>
<<
ALTER TABLE axpflds ADD runtimefld varchar(1) NULL
>>
<<
ALTER TABLE axpflds ADD applyrule varchar(1) NULL
>>
<<
ALTER TABLE axusers ADD axlang varchar(100) NULL
>>
--------------------------Rule Definition
<<
CREATE OR REPLACE FUNCTION fn_ruledef_formula(formula text, applicability character varying, nexttask character varying, nexttask_true character varying, nexttask_false character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
    v_formula text;

begin

with a as(
select
	regexp_split_to_table(formula, E'~') cols),
b as(select 	string_agg(split_part( cols, '|', 1)||' '||
	case when split_part( cols, '|', 2)='Equal to' then '='
	when split_part( cols, '|', 2)='Not equal to' then '#'
	when split_part( cols, '|', 2)='Greater than' then '>'
	when split_part( cols, '|', 2)='Lesser than' then '<' end||' '||
	case when split_part( cols, '|', 2) in('Equal to','Not equal to') then  '{'||split_part( cols, '|', 3)||'}' 
	when split_part( cols, '|', 2) in('Greater than','Lesser than') then  split_part( cols, '|', 3) end||' '||
	case when split_part( cols, '|', 4)='And' then '&'when split_part( cols, '|', 4)='Or' then '|' else split_part( cols, '|', 4) end,' ') cndtxt from a)
	select 
case when applicability ='T' then 'iif('||cndtxt||',{T},{F})' 
when nexttask='T' then 'iif('||cndtxt||',{'||nexttask_true||'},'||'{'||nexttask_false||'})'
else cndtxt end  

into v_formula from b;

return v_formula;
end;

$function$
;
>>
<<
CREATE OR REPLACE FUNCTION fn_ruledef_table_genaxscript(pcmd character varying, ptbldtls character varying, pcnd numeric)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
    v_formula varchar(2000);

   BEGIN

if pcnd=1 then 	   
	select concat(pcmd,' ',string_agg(concat(substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),
	case split_part(fname, '|', 2) when 'Equal to' then ' = ' when 'Not equal to' then ' # ' when 'Greater than' then ' > ' when 'Lesser than' then ' < ' end,
	split_part(fname, '|', 3),
	case split_part(fname, '|', 4) when 'And' then ' & ' when 'Or' then ' | ' when 'And(' then ' & (' when 'Or(' then ' | (' else split_part(fname, '|', 4) end),'')) into v_formula
	from(select unnest(string_to_array( ptbldtls, '~')) fname)a;

elseif pcnd =2 then 
	select case when pcmd ='Show' then concat('Axunhidecontrols({', fnames ,'})') 
	when pcmd ='Hide' then concat('Axhidecontrols({', fnames ,'})')
	when pcmd ='Enable' then concat('Axenablecontrols({', fnames ,'})')
	when pcmd ='Disable' then concat('Axdisablecontrols({', fnames ,'})')
	when pcmd ='Mandatory' then concat('AxAllowEmpty({', fnames ,'},{F})')
	when pcmd ='Non mandatory' then concat('AxAllowEmpty({', fnames ,'},{T})') end  into v_formula from 
	(select string_agg(substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),',') fnames
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a)b;

elseif pcnd in(3,31) then 
	select case when pcmd='Mask few characters' then concat('AxMask({',substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),'}',
	',{',split_part(fname, '|', 2),'},{',
	split_part(fname, '|', 3),'~',
	split_part(fname, '|', 4),'})') 
	when pcmd ='Mask all characters' then concat('AxMask({',substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),
	'},{',split_part(fname, '|', 2),'},{all})') 
	end  into v_formula
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a;

elseif pcnd=4 then 
	select concat('SetValue({',substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),
	'},1,',split_part(fname, '|', 2),')') into v_formula
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a;

elseif pcnd=5 then  
	select case when pcmd='Show message' then concat('ShowMessage({',split_part(fname, '|', 1),'},{Simple},{})')
	when pcmd='Show error' then concat('ShowMessage({',split_part(fname, '|', 1),'},{Exception},{})') end  into v_formula
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a;

elseif pcnd=6 then 
	v_formula := pcmd;

------------used in PEG for Set value
elseif pcnd=7 then 
	select string_agg(concat('SetValue({',substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),
	'},1,',split_part(fname, '|', 2),')'),chr(10)) into v_formula
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a;

end if;
	
RETURN v_formula;
END;
$function$
;
>>
<<
CREATE OR REPLACE FUNCTION fn_ruledef_tablefield(pcnd numeric)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
v_json varchar;

BEGIN  

/*
1	If,Else if
2	Enable,Show,Hide,Disable,Mandatory,Non mandatory
3	Mask all characters,Mask few characters
4	Set value to field
5	Show message,Show error
6	Else
*/
	
if pcnd = 1 then --If , Else if 	 

select '{"props":{"type":"table","colcount":"4","rowcount":"1","addrow":"t","deleterow":"t","valueseparator":"|","rowseparator":"~"},
"columns":{	"1":{"caption":"Condition field","name":"cfld","value":"","source":"cndfldcaption","exp":"","vexp":""},
			"2":{"caption":"Operator","name":"opr","value":"","source":"formula_opr","exp":"","vexp":""},
			"3":{"caption":"Value","name":"fldvalue","value":"","source":"","exp":"","vexp":""},
			"4":{"caption":"Condition","name":"ccnd","value":"","source":"formula_andor","exp":"","vexp":""}
			}}'  into v_json;
		
		
 
elseif pcnd = 2 then  --Enable,Disable,Show,Hide,Mandatory,Non mandatory

select '{"props":{"type":"table","colcount":"1","rowcount":"1","addrow":"t","deleterow":"t","valueseparator":"|","rowseparator":"~"},
"columns":{"1":{"caption":"Apply rule on","name":"cndfld","value":"","source":"fctlfldcaption","exp":"","vexp":""}}
}' into v_json;


elseif pcnd = 3 then --Mask few characters

select '{"props":{"type":"table","colcount":"4","rowcount":"1","addrow":"f","deleterow":"f","valueseparator":"|","rowseparator":"~"},
"columns":{"1":{"caption":"Apply rule on","name":"cndfld","value":"","source":"fctlfldcaption","exp":"","vexp":""},
			"2":{"caption":"Mask character","name":"maskchr","value":"","source":"maskchar","exp":"","vexp":""},
			"3":{"caption":"No of first few characters to be displayed","name":"mfrchar","value":"","source":"","exp":"","vexp":""},
			"4":{"caption":"No of last few characters to be displayed","name":"mlstchr","value":"","source":"","exp":"","vexp":""}}
}'  into v_json;

elseif pcnd = 31 then --Mask all characters

select '{"props":{"type":"table","colcount":"2","rowcount":"1","addrow":"f","deleterow":"f","valueseparator":"|","rowseparator":"~"},
"columns":{"1":{"caption":"Apply rule on","name":"cndfld","value":"","source":"fctlfldcaption","exp":"","vexp":""},
			"2":{"caption":"Mask character","name":"maskchr","value":"","source":"maskchar","exp":"","vexp":""}}
}'  into v_json;

elseif pcnd = 4 then --Set value to field

select '{"props":{"type":"table","colcount":"2","rowcount":"1","addrow":"f","deleterow":"f","valueseparator":"|","rowseparator":"~"},
"columns":{"1":{"caption":"Set value to field","name":"cndfld","value":"","source":"cndfldcaption","exp":"","vexp":""},
			"2":{"caption":"Value","name":"sval","value":"","source":"","exp":"","vexp":""}}
}'  into v_json;

elseif pcnd=5 then -- Show message,Show error

select '{"props":{"type":"table","colcount":"1","rowcount":"1","addrow":"f","deleterow":"f","valueseparator":"|","rowseparator":"~"},
"columns":{"1":{"caption":"Message",	"name":"cndfld","value":"","source":"","exp":"","vexp":""}}
}'  into v_json;

end if;

  RETURN v_json;
 
END;
$function$
;

>>
-----------------PEG
<<
CREATE TABLE axactivetasks (
	eventdatetime varchar(30) NULL,
	taskid varchar(15) NULL,
	processname varchar(500) NULL,
	tasktype varchar(30) NULL,
	taskname varchar(500) NULL,
	taskdescription varchar(4000) NULL,
	assigntorole varchar(50) NULL,
	transid varchar(8) NULL,
	keyfield varchar(30) NULL,
	execonapprove varchar(5) NULL,
	keyvalue varchar(500) NULL,
	transdata varchar(4000) NULL,
	fromrole varchar(30) NULL,
	fromuser varchar(30) NULL,
	touser varchar(500) NULL,
	priorindex numeric(10) NULL,
	priortaskname varchar(200) NULL,
	corpdimension varchar(10) NULL,
	orgdimension varchar(10) NULL,
	department varchar(30) NULL,
	grade varchar(10) NULL,
	datavalue varchar(4000) NULL,
	displayicon varchar(200) NULL,
	displaytitle varchar(500) NULL,
	displaysubtitle varchar(250) NULL,
	displaycontent text NULL,
	displaybuttons varchar(250) NULL,
	groupfield varchar(4000) NULL,
	groupvalue varchar(4000) NULL,
	priorusername varchar(100) NULL,
	initiator varchar(100) NULL,
	mapfieldvalue varchar(4000) NULL,
	useridentificationfilter varchar(1000) NULL,
	useridentificationfilter_of varchar(1000) NULL,
	mapfield_group varchar(1000) NULL,
	mapfield varchar(1000) NULL,
	grouped varchar(1) NULL,
	indexno numeric(10) NULL,
	subindexno numeric(10) NULL,
	processowner varchar(100) NULL,
	assigntoflg varchar(1) NULL,
	assigntoactor varchar(200) NULL,
	actorfilter text NULL,
	recordid numeric(20) NULL,
	processownerflg numeric(1) NULL,
	pownerfilter varchar(4000) NULL,
	approvereasons varchar(4000) NULL,
	defapptext varchar(4000) NULL,
	returnreasons varchar(4000) NULL,
	defrettext varchar(4000) NULL,
	rejectreasons varchar(4000) NULL,
	defregtext varchar(4000) NULL,
	approvalcomments varchar(1) NULL,
	rejectcomments varchar(1) NULL,
	returncomments varchar(1) NULL,
	escalation varchar(1) NULL,
	reminder varchar(1) NULL
);
>>
<<
CREATE TABLE axactivetaskdata (
	eventdatetime varchar(30) NULL,
	taskid varchar(15) NULL,
	transid varchar(8) NULL,
	keyfield varchar(30) NULL,
	keyvalue varchar(500) NULL,
	datavalues varchar(4000) NULL
);
>>
<<
CREATE TABLE axactivetaskstatus (
	eventdatetime varchar(30) NULL,
	taskid varchar(15) NULL,
	transid varchar(8) NULL,
	keyfield varchar(30) NULL,
	keyvalue varchar(500) NULL,
	taskstatus varchar(15) NULL,
	username varchar(30) NULL,
	tasktype varchar(500) NULL,
	taskname varchar(500) NULL,
	processname varchar(500) NULL,
	priorindex numeric(10) NULL,
	indexno numeric(10) NULL,
	subindexno numeric(10) NULL,
	recordid numeric(20) NULL,
	statusreason varchar(4000) NULL,
	statustext varchar(4000) NULL
);
>>
<<
CREATE TABLE axprocess (
	eventdatetime varchar(30) NULL,
	taskid varchar(15) NULL,
	transid varchar(8) NULL,
	processname varchar(500) NULL,
	taskname varchar(500) NULL,
	keyvalue varchar(500) NULL,
	taskstatus varchar(15) NULL
);
>>
<<
CREATE OR REPLACE FUNCTION fn_peg_assigntoactor(assigntoactor character varying, actorfilter character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
rec record;
ag record;
agc record;
v_grpname varchar[] DEFAULT  ARRAY[]::varchar[];
qry text;
sqlstmt refcursor;
cndresult int;
grpresult int;
truecnt int;
v_totalcnd int;
allusers int;

begin
	grpresult = 0;
truecnt = 0;
cndresult = 0;
allusers=0;


	<<Actor_Groups>>
	for ag in 
	select distinct a.actorname ,b.actgroup,b.axpdef_peg_groupid  from axpdef_peg_actor a,axpdef_peg_actorgrp b
	where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
	and b.actgroup!='All'
	and a.actorname = assigntoactor 
	group by a.actorname ,b.actgroup,b.axpdef_peg_groupid

	loop
		select a.totalcnd into v_totalcnd from axpdef_peg_group a where  axpdef_peg_groupid = ag.axpdef_peg_groupid;

			<<Groups_Condition>>	
			for agc in 
				select  b.actorname,g1.grpname ,g2.cnd,g2.fldname,g2.cndoprsym,g2.fldvalue
				from axpdef_peg_actor b,axpdef_peg_actorgrp g,axpdef_peg_group g1,axpdef_peg_grpfilter g2
				where b.axpdef_peg_actorid = g.axpdef_peg_actorid
				and g1.axpdef_peg_groupid=g2.axpdef_peg_groupid
				and g.axpdef_peg_groupid = g1.axpdef_peg_groupid  
				and g1.grpname=g.actgroup
				and b.actorname =ag.actorname and g1.grpname = ag.actgroup
				group by b.actorname,g1.grpname ,g2.cnd,g2.fldname,g2.cndoprsym,g2.fldvalue,g2.axpdef_peg_grpfilterrow
				order by 1,2,g2.axpdef_peg_grpfilterrow 
	
			loop 
				if agc.cndoprsym  = 'in' or agc.cndoprsym  = 'not in' then
				open sqlstmt for with ud as (select split_part(regexp_split_to_table(actorfilter,'~'),'=',1) cndfld,
						split_part(regexp_split_to_table(actorfilter,'~'),'=',2) cndfldval) 
						select *  from ud;
						fetch next from sqlstmt into rec;						
						<<user_data>>
						while found loop 	   						
			   			qry :='select count(*) from dual where '''||agc.fldname||'''='''||rec.cndfld ||''' and '''|| rec.cndfldval||''''||agc.cndoprsym||'('''||replace(agc.fldvalue,',',''',''')||''')';			   					   			
					   	execute qry into cndresult;					   					  	
 					    if cndresult > 0 then  grpresult := grpresult +1; end if;					  						  				 					   
					  	if cndresult > 0 then truecnt := truecnt + 1; end if;
					  	exit user_data when cndresult > 0;
					  	fetch next from sqlstmt into rec; 			      	
    					end loop;    										  	
					  	if v_totalcnd = truecnt then  
					  	v_grpname := array_append(v_grpname,agc.grpname);  
    					end if;        					    					
    			CLOSE sqlstmt;

				else
				
				open sqlstmt for with ud as (select split_part(regexp_split_to_table(actorfilter,'~'),'=',1) cndfld,
					split_part(regexp_split_to_table(actorfilter,'~'),'=',2) cndfldval) 
					select * from ud;
							fetch next from sqlstmt into rec;						
							<<user_data>>
							while found loop 	   						
			   				qry :='select count(*) from dual where '''||agc.fldname||'''='''||rec.cndfld ||''' and '''||agc.fldvalue||''''||agc.cndoprsym||''''||rec.cndfldval||'''';			   					   			
					   		execute qry into cndresult;					   						
 					    	if cndresult > 0 then  grpresult := grpresult +1; end if;								  				 					   	
					  		if cndresult > 0 then truecnt := truecnt + 1; end if;					  
					  		exit user_data when cndresult > 0;
				       		fetch next from sqlstmt into rec;				      	
    						end loop;    										  	
					  	if v_totalcnd = truecnt then  
					  	v_grpname := array_append(v_grpname,agc.grpname); 					  
    					end if;        				    				
    			CLOSE sqlstmt;
			end if;    		
		end loop;
		grpresult = 0;truecnt = 0;			
end loop;

	select count(*) into allusers  from axpdef_peg_actor a,axpdef_peg_actorgrp b
	where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
	and b.actgroup='All'
	and a.actorname = assigntoactor;

v_grpname := case when allusers > 0 then array_append(v_grpname,'All') else v_grpname end;

return array_to_string(v_grpname,',');

end;
$function$
;
>>
<<
CREATE OR REPLACE FUNCTION fn_peg_assigntorole(useridentificationfilter character varying, useridentificationfilter_of character varying, initiator character varying, priorusername character varying, assigntorole character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
rec record;
qry text;
sqlstmt refcursor;
rowcount int;
userlist varchar;
begin
rowcount = 1;

if useridentificationfilter is not null then
		open sqlstmt for 
		with a as (select regexp_split_to_table(useridentificationfilter, E',')grp)
		select ''''||b.groupname||'''' groupname,string_agg(''''||groupvalue||'''',',') groupvalue from usergroupings b,a --,axuserlevelgroups c
		where b.username=case when useridentificationfilter_of='Initiator' then initiator when useridentificationfilter_of='Prior User' then priorusername end
		and b.groupname = a.grp  
		--and b.username = c.username and c.usergroup = assigntorole
		--and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
		--and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null))
		group by b.groupname  ;

		fetch next from sqlstmt into rec;

		while found 		
    		loop 	
    		
			    if rowcount = 1 then 
				qry :='select string_agg(distinct u.username,'','')   from usergroupings u,axuserlevelgroups l where u.username = l.username and l.usergroup='''||assigntorole ||''' and groupname ='||rec.groupname||' and groupvalue in('||  rec.groupvalue||') and u.username!='||''''||
					   case when useridentificationfilter_of='Initiator' then initiator when useridentificationfilter_of='Prior User' then priorusername end||'''';
				else 
				
				qry :='select string_agg(distinct u.username,'','')   from usergroupings u,axuserlevelgroups l  where u.username = l.username and l.usergroup='''||assigntorole ||''' and groupname ='||rec.groupname||' and groupvalue in('||  rec.groupvalue||')
					   and u.username in('||''''||replace(coalesce(userlist,''),',',''',''')||''''||') 
					   and u.username!='||''''||case when useridentificationfilter_of='Initiator' then initiator when useridentificationfilter_of='Prior User' then priorusername end||''''
					   ;
				end if;
													
			execute qry into userlist;			
   			rowcount := rowcount + 1;
   				
		    fetch next from sqlstmt into rec;
		   		    
    		end loop;			
	end if;

return userlist;
	
		
end;

$function$
;

>>
<<
CREATE OR REPLACE FUNCTION fn_axactivetasks()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare 
v_grpname varchar[] DEFAULT  ARRAY[]::varchar[];
usercount int;
begin
/* assigntoflg=
 * 1 - Reporting manager
 * 2 - Assign to Actor
 * 3 - Assign to Role
 * 4 - From form field
 */
/*processownerflg
 * 1 - Actor
 * 2 - Role
 */	
	
	
-----------------------Assign to Reporting Manager & Form fields - Redirect to delegated users
if new.assigntoflg in('1','4') and new.touser is not null then	

	insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
	fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
	groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
	assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
	approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
	select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
	new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
	new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
	new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
	new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
	new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
	from axprocessdef_delegation c 
	where c.fromusername = new.touser				
	and current_date  >= c.fromdate
	and current_date  <= c.todate;

end if;
	
	
----------------------------Assign to Reporting Manager & Form fields when touser is null | Redirect to Process owners	
if new.assigntoflg in('1','4') and new.touser is null then

	if new.processownerflg=1 then 	
	
		select string_to_array(fn_peg_assigntoactor(new.processowner,new.pownerfilter),',') into v_grpname;
			
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
		fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
		groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
		processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
		pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
		select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
		new.transdata,new.fromrole,new.fromuser,regexp_split_to_table(b.uname,','),new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
		new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
		new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
		new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
		new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
		new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder
		from axpdef_peg_actor a ,axpdef_peg_actorgrp b
		where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
		and a.actorname =new.processowner
		and b.actgroup in(select unnest(v_grpname));	
	
	
		-----------Delegation - (Process Owner | Actor)		
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
		fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
		groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
		processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
		pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
		select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
		new.transdata,new.fromrole,new.fromuser,c.tousername,
		new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
		new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
		new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
		new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
		new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
		new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder from 
		(select regexp_split_to_table(b.uname,',') fuser
		from axpdef_peg_actor a ,axpdef_peg_actorgrp b
		where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
		and a.actorname = new.processowner
		and b.actgroup in (select unnest(v_grpname)))a,axprocessdef_delegation c 
		where a.fuser = c.fromusername
		and current_date  >= c.fromdate
		and current_date  <= c.todate;

	
	elseif new.processownerflg=2 then			
	
		 --- Not Required, User identification filter is removed for Process Owner & Role	
			/*if new.useridentificationfilter is not null then 
			
				select string_to_array(fn_peg_assigntorole(new.useridentificationfilter,new.useridentificationfilter_of,new.initiator,new.priorusername,new.processowner),',') into v_grpname;    					
			
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
				assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
				values
				(new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,unnest(v_grpname),new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
				new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
				new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder);
			
			
				------------------Delegation (Process owner | Role)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
				assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
				new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
				new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
				from (select unnest(v_grpname)fuser)a  ,axprocessdef_delegation c 
				where a.fuser = c.fromusername
				and current_date  >= c.fromdate
				and current_date  <= c.todate;

			elseif new.useridentificationfilter is null then */
				
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
				processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
				new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
				new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext
				from axuserlevelgroups c
				where c.usergroup = new.processowner		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
			
			
				--------Delegation (Process onwer | Role)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
				assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
				new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
				new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
				from axuserlevelgroups a,axprocessdef_delegation c 
				where a.usergroup = new.processowner
				and a.username = c.fromusername
				and current_date  >= c.fromdate
				and current_date  <= c.todate					 		
				and ((a.startdate is not null and current_date  >= a.startdate) or (a.startdate is null)) 
				and ((a.enddate is not null and current_date  <= a.enddate) or (a.enddate is null));				
				
			--end if;
	end if;

end if;


------------------Assign to Role
if new.assigntoflg ='3' then	
	if new.useridentificationfilter is not null then 			
		select string_to_array(fn_peg_assigntorole(new.useridentificationfilter,new.useridentificationfilter_of,new.initiator,new.priorusername,new.assigntorole),',') into v_grpname;
   
 		select array_length(v_grpname,1) into usercount;

			if usercount>0 then
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
				assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
				values
				(new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,unnest(v_grpname),new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
				new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
				new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder	);
			
				-----------------------Delegation (Assign to Role)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
				assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
				new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
				new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
				from (select unnest(v_grpname)fuser)a  ,axprocessdef_delegation c 
				where a.fuser = c.fromusername
				and current_date  >= c.fromdate
				and current_date  <= c.todate;
			
			else 			
				if new.processownerflg=1 then 			
				
					select string_to_array(fn_peg_assigntoactor(new.processowner,new.pownerfilter),',') into v_grpname;
			
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
					processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
					approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,regexp_split_to_table(b.uname,','),new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
					new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
					new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder
					from axpdef_peg_actor a ,axpdef_peg_actorgrp b
					where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
					and a.actorname =new.processowner
					and b.actgroup in(select unnest(v_grpname));	
				
				
					-----------Delegation (Process Owner | Actor)
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
					processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
					pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,c.tousername,
					new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
					new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
					new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder		 from 
					(select regexp_split_to_table(b.uname,',') fuser
					from axpdef_peg_actor a ,axpdef_peg_actorgrp b
					where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
					and a.actorname = new.processowner
					and b.actgroup in (select unnest(v_grpname)))a,axprocessdef_delegation c 
					where a.fuser = c.fromusername
					and current_date  >= c.fromdate
					and current_date  <= c.todate;
				
	
				elseif new.processownerflg=2 then		
				
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
					processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
					approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
					new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
					new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder
					from axuserlevelgroups c
					where c.usergroup = new.processowner 		
					and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
					and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
				
				
					--------------Delegation(Process owner | Role)
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
					assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
					approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
					new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
					new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
					from axuserlevelgroups a,axprocessdef_delegation c 
					where a.usergroup = new.processowner
					and a.username = c.fromusername
					and current_date  >= c.fromdate
					and current_date  <= c.todate					 		
					and ((a.startdate is not null and current_date  >= a.startdate) or (a.startdate is null)) 
					and ((a.enddate is not null and current_date  <= a.enddate) or (a.enddate is null));
					
				/* Not Required, User identification filter is removed for Process Owner & Role
				 * select string_to_array(fn_peg_assigntorole(new.useridentificationfilter,new.useridentificationfilter_of,new.initiator,new.priorusername,new.processowner),',') into v_grpname;    					
				
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
					assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
					approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
					values
					(new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,unnest(v_grpname),new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
					new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
					new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder);
				
					------------------ Delegation (Process Owner | Role)
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
					assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
					approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
					new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
					new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
					from (select unnest(v_grpname)fuser)a  ,axprocessdef_delegation c 
					where a.fuser = c.fromusername
					and current_date  >= c.fromdate
					and current_date  <= c.todate;	*/			
				
				end if;		
			end if;
	end if;

if  new.useridentificationfilter is null then 
		select count(1) into usercount from axuserlevelgroups c
		where c.usergroup = new.assigntorole  
		and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
		and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));

			if usercount > 0 then
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
				processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
				new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
				new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder
				from axuserlevelgroups c
				where c.usergroup = new.assigntorole 		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));

				------------------ Delegation (Assign to Role)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
				assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
				new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
				new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
				from axuserlevelgroups a,axprocessdef_delegation c 
				where a.usergroup = new.assigntorole
				and a.username = c.fromusername
				and current_date  >= c.fromdate
				and current_date  <= c.todate					 		
				and ((a.startdate is not null and current_date  >= a.startdate) or (a.startdate is null)) 
				and ((a.enddate is not null and current_date  <= a.enddate) or (a.enddate is null));
		
			
			else 
				if  new.processownerflg=1 then 		
					select string_to_array(fn_peg_assigntoactor(new.processowner,new.pownerfilter),',') into v_grpname;
			
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
					processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
					approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,regexp_split_to_table(b.uname,','),new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
					new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
					new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder
					from axpdef_peg_actor a ,axpdef_peg_actorgrp b
					where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
					and a.actorname =new.processowner
					and b.actgroup in(select unnest(v_grpname));
				
					-----------Delegation (Process Owner | Actor)
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
					processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
					pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,c.tousername,
					new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
					new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
					new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder		 from 
					(select regexp_split_to_table(b.uname,',') fuser
					from axpdef_peg_actor a ,axpdef_peg_actorgrp b
					where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
					and a.actorname = new.processowner
					and b.actgroup in (select unnest(v_grpname)))a,axprocessdef_delegation c 
					where a.fuser = c.fromusername
					and current_date  >= c.fromdate
					and current_date  <= c.todate;
				
	
				elseif new.processownerflg=2 then					
				
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
					processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
					approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
					new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
					new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder
					from axuserlevelgroups c
					where c.usergroup = new.processowner 		
					and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
					and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
				
				
					--------------Delegation(Process owner | Role)
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
					assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
					approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
					new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
					new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
					from axuserlevelgroups a,axprocessdef_delegation c 
					where a.usergroup = new.processowner
					and a.username = c.fromusername
					and current_date  >= c.fromdate
					and current_date  <= c.todate					 		
					and ((a.startdate is not null and current_date  >= a.startdate) or (a.startdate is null)) 
					and ((a.enddate is not null and current_date  <= a.enddate) or (a.enddate is null));
				
				
				end if;
			end if;
		end if;
end if;




------------------------------- Assign to Actor
if new.assigntoflg ='2' then 
	
	select string_to_array(fn_peg_assigntoactor(new.assigntoactor,new.actorfilter),',') into v_grpname;
	select array_length(v_grpname,1) into usercount;

			if usercount>0 then
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
				processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,regexp_split_to_table(b.uname,','),new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
				new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
				new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder
				from axpdef_peg_actor a ,axpdef_peg_actorgrp b
				where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
				and a.actorname =new.assigntoactor
				and b.actgroup in(select unnest(v_grpname));

				-----------Delegation (Assign to Actor)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
				fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
				groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
				processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
				pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
				new.transdata,new.fromrole,new.fromuser,c.tousername,
				new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
				new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
				new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder		 from 
				(select regexp_split_to_table(b.uname,',') fuser
				from axpdef_peg_actor a ,axpdef_peg_actorgrp b
				where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
				and a.actorname = new.assigntoactor
				and b.actgroup in (select unnest(v_grpname)))a,axprocessdef_delegation c 
				where a.fuser = c.fromusername
				and current_date  >= c.fromdate
				and current_date  <= c.todate;
			
			
			else			
				if new.processownerflg=1 then 	
				
					select string_to_array(fn_peg_assigntoactor(new.processowner,new.pownerfilter),',') into v_grpname;
			
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
					processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
					approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,regexp_split_to_table(b.uname,','),new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
					new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
					new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder
					from axpdef_peg_actor a ,axpdef_peg_actorgrp b
					where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
					and a.actorname =new.processowner
					and b.actgroup in(select unnest(v_grpname));	

					-----------Delegation (Process Owner | Actor)
					insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
					fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
					groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
					processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
					pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
					select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
					new.transdata,new.fromrole,new.fromuser,c.tousername,
					new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
					new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
					new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
					new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
					new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder		 from 
					(select regexp_split_to_table(b.uname,',') fuser
					from axpdef_peg_actor a ,axpdef_peg_actorgrp b
					where a.axpdef_peg_actorid =b.axpdef_peg_actorid 
					and a.actorname = new.processowner
					and b.actgroup in (select unnest(v_grpname)))a,axprocessdef_delegation c 
					where a.fuser = c.fromusername
					and current_date  >= c.fromdate
					and current_date  <= c.todate;				
				
	
				elseif new.processownerflg=2 then			
				
						/*Not Required, User identification filter is removed for Process Owner & Role
						if new.useridentificationfilter is not null then 	
						
							select string_to_array(fn_peg_assigntorole(new.useridentificationfilter,new.useridentificationfilter_of,new.initiator,new.priorusername,new.processowner),',') into v_grpname;    					
						
							insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
							fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
							groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
							assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
							approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
							values
							(new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
							new.transdata,new.fromrole,new.fromuser,unnest(v_grpname),new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
							new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
							new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
							new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
							new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder);

							------------------ Delegation (Process Owner | Role)
							insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
							fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
							groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
							assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
							approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
							select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
							new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
							new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
							new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
							new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
							new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
							from (select unnest(v_grpname)fuser)a  ,axprocessdef_delegation c 
							where a.fuser = c.fromusername
							and current_date  >= c.fromdate
							and current_date  <= c.todate;							
						
						elseif new.useridentificationfilter is null then */
				
							insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
							fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
							groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,
							processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
							approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 
							select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
							new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,
							new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
							new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
							new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
							new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder
							from axuserlevelgroups c
							where c.usergroup = new.processowner		
							and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
							and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
						
							--------------Delegation(Process owner | Role)
							insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,transdata,fromrole,
							fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,
							groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,
							assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
							approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder) 								
							select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,new.keyvalue,
							new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,
							new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
							new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,
							new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
							new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder				
							from axuserlevelgroups a,axprocessdef_delegation c 
							where a.usergroup = new.processowner
							and a.username = c.fromusername
							and current_date  >= c.fromdate
							and current_date  <= c.todate					 		
							and ((a.startdate is not null and current_date  >= a.startdate) or (a.startdate is null)) 
							and ((a.enddate is not null and current_date  <= a.enddate) or (a.enddate is null));	
						
						--end if;
				end if;	
			
		end if;

end if;
  
return new;
end; 
$function$
;
>>
<<
create trigger trg_axactivetasks after insert
    on
    axactivetasks for each row
    when ((((new.grouped is null)
    and ((new.assigntoflg)::text = any (array[('2'::character varying)::text,
    ('3'::character varying)::text])))
    or ((new.grouped is null)
    and ((new.assigntoflg)::text = any (array[('1'::character varying)::text,
    ('4'::character varying)::text]))))) execute procedure fn_axactivetasks();

>>
<<
CREATE TABLE usergroupings (username varchar(100) NULL,groupname varchar(100) NULL,groupvalue varchar(100) NULL)
>>
<<
CREATE TABLE usergroupmaster (groupname varchar(100) NULL)
>>
<<
insert into	axpages ("name",caption,blobno,img,visible,"type",parent,ordno,levelno,updatedon,createdon,importedon,createdby,	updatedby,importedby,readonly,updusername,category,pagetype,intview,webenable,shortcut,icon,websubtype,	workflow)
values('HP100','Active list',1,null,'T','p',null,0,0,current_date,current_date,null,'admin','admin',null,null,null,null,'web',null,null,null,null,'htmlpage',null);
>>
<<
update  axpages set ordno= (select max(ordno)+1 from axpages)  where name='HP100';
>>