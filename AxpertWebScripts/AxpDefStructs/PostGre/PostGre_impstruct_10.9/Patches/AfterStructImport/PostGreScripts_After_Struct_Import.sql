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
CREATE OR REPLACE function pro_emailformat(ptemplate varchar ,pkeyword varchar,ptype varchar,psendto varchar,psendcc varchar ) 
	RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS
 $BODY$
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

insert into axsms(createdon,mobileno,msg,status) values ( CREATE OR REPLACE function pro_emailformat(ptemplate varchar ,pkeyword varchar,ptype varchar,psendto varchar,psendcc varchar ) 
	RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
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
$BODY$;,psendto,v_sms,0);

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
     VALUES (psendto,psendcc,v_subject ,v_body,null,null,null,0,null,null,CREATE OR REPLACE function pro_emailformat(ptemplate varchar ,pkeyword varchar,ptype varchar,psendto varchar,psendcc varchar ) 
	RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
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
$BODY$;
);



end if;
end if;
end ;
 $BODY$;
 
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
   v_trg varchar(100) := coalesce( :new.trg_name, 'NA');
    
    BEGIN

        -- Work out the increment/decrement amount(s).
        execute procedure pr_bulkexecute( new.SCRIPT_TEXT,v_trg);
		
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
INSERT INTO ax_page_templates VALUES (4, 'topaz', NULL, '{"cc":5,"img":"topaz.png","name":"topaz","cf":[{"ht":"225px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m8 l8","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m8 l8","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}', 'admin', NULL, 'N', '2019-03-06 14:38:38.075', '2019-03-06 14:38:38.075')
>>
<<
INSERT INTO ax_page_templates VALUES (5, 'list', NULL, '{"cc":1,"img":"list.png","name":"list","cf":[{"ht":"225px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}', 'admin', NULL, 'N', '2019-03-06 14:38:38.247', '2019-03-06 14:38:38.247')
>>
<<
INSERT INTO ax_page_templates VALUES (6, 'flow', NULL, '{"cc":3,"img":"flow.png","name":"flow","repeatLastWidget":true,"cf":[{"ht":"500px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"500px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}', 'admin', NULL, 'N', '2019-03-06 14:38:38.434', '2019-03-06 14:38:38.434')
>>
<<
INSERT INTO ax_page_templates VALUES (7, 'checkered', NULL, '{"cc":1,"img":"checkered.png","name":"checkered","cf":[{"ht":"300px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}', 'admin', NULL, 'N', '2019-03-06 14:38:38.591', '2019-03-06 14:38:38.591')
>>
<<
INSERT INTO ax_page_templates VALUES (9, 'random', NULL, '{"cc":7,"img":"random.png","name":"random","cf":[{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"300px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"300px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"200px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}', 'admin', NULL, 'N', '2019-03-06 14:38:38.903', '2019-03-06 14:38:38.903')
>>
<<
INSERT INTO ax_page_templates VALUES (8, 'flow main', NULL, '{"cc":3,"img":"flow_main.png","name":"flow main","repeatLastWidget":true,"cf":[{"ht":"300px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"300px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}', 'admin', NULL, 'N', '2019-03-06 14:38:38.747', '2019-03-06 14:38:38.747')
>>
<<
INSERT INTO ax_page_templates VALUES (1, 'basic', NULL, '{"cc":1,"img":"basic.png","name":"basic","cf":[{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}', 'admin', NULL, 'N', '2019-03-06 14:38:37.559', '2019-03-06 14:38:37.559')
>>
<<
INSERT INTO ax_page_templates VALUES (2, 'modern', NULL, '{"cc":1,"img":"modern.png","name":"modern","cf":[{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","br":"14px","tr":{"p":"top","h":"70px","html":"<span style=\"float:left;font-size:45px;\">#TITLE_ICON#</span><span style=\"text-align: right;padding-top: 14px;position: relative;top: 16px;right: 5px;\">#TITLE_NAME#</span>"}}]}', 'admin', NULL, 'N', '2019-03-06 14:38:37.731', '2019-03-06 14:38:37.731')
>>
<<
INSERT INTO ax_page_templates VALUES (3, 'mainCard', NULL, '{"cc":7,"img":"mainCard.png","name":"mainCard","cf":[{"ht":"225px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}', 'admin', NULL, 'N', '2019-03-06 14:38:37.903', '2019-03-06 14:38:37.903')
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
<<
ALTER table AX_PAGE_SAVED add IS_DEFAULT VARCHAR(1) DEFAULT 'N'
>>
<<
ALTER table AX_PAGES add IS_DEFAULT VARCHAR(1) DEFAULT 'N'
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
Insert into AXCTX1
   (AXCONTEXT, ATYPE)
 Values
   ('SaveImage', 'Property')
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
INSERT INTO axpstructconfigprops VALUES (1000220000000, 'F', 0, NULL, 'admin', '2019-11-15 15:17:24', 'admin', '2019-11-15 15:17:24', NULL, 1, 1, NULL, NULL, NULL,
 'ExportVerticalAlign', 'ExportVerticalAlign', 'configtypeExportVerticalAlign', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F')
>>
<<
INSERT INTO axpstructconfigprops VALUES (1000220000004, 'F', 0, NULL, 'admin', '2019-11-15 15:17:43', 'admin', '2019-11-15 15:17:43',
 NULL, 1, 1, NULL, NULL, NULL, 'Excel Export', 'Excel Export', 'configtypeExcel Export', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F')
>>
<<
INSERT INTO axpstructconfigprops VALUES (1000220000007, 'F', 0, NULL, 'admin', '2019-11-15 15:17:58', 'admin', '2019-11-15 15:17:58', NULL, 
1, 1, NULL, NULL, NULL, 'Trim IView Data', 'Trim IView Data', 'configtypeTrim IView Data', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F')
>>
<<
INSERT INTO axpstructconfigprops VALUES (1000220000012, 'F', 0, NULL, 'admin', '2019-11-15 15:18:35', 'admin', '2019-11-15 15:18:35', NULL, 1, 
1, NULL, NULL, NULL, 'ApplicationCompressedMode', 'General', 'configtypeApplicationCompressedMode', NULL, 'All', 'F', 'F', 'F', 'F', 'F', 'F')
>>
<<
INSERT INTO axpstructconfigprops VALUES (1000220000015, 'F', 0, NULL, 'admin', '2019-11-15 15:18:53', 'admin', '2019-11-15 15:18:53', NULL, 
1, 1, NULL, NULL, NULL, 'ApplicationTemplate', 'General', 'configtypeApplicationTemplate', NULL, 'All', 
'F', 'F', 'F', 'F', 'F', 'F')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000001, 1000220000000, 1, 'middle')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000002, 1000220000000, 2, 'top')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000003, 1000220000000, 3, 'bottom')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000005, 1000220000004, 1, 'false')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000006, 1000220000004, 2, 'true')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000008, 1000220000007, 1, 'true')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000009, 1000220000007, 2, 'false')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000013, 1000220000012, 1, 'false')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000014, 1000220000012, 2, 'true')
>>
<<
INSERT INTO axpstructconfigproval VALUES (1000220000016, 1000220000015, 1, 'mainPageTemplate.html')
>>

 

<<
CREATE TABLE AXCTX1
(
  
  AXCONTEXT      VARCHAR(75),
  ATYPE          VARCHAR(10)
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
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL,
   APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000440000000, 'F', 0, 'admin', 
   TO_DATE('12/27/2018 12:53:08', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('12/27/2018 12:41:34', 'MM/DD/YYYY HH24:MI:SS'),
   1, 1, 'Autocomplete Search Pattern', 'configtypeAutocomplete Search Pattern', 'Autocomplete Search Pattern', 'Tstruct', 'F', 'F', 'T', 'F')
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
create trigger axp_tr_search_appsearch   
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
CREATE OR REPLACE VIEW axp_appsearch_data_new AS
 SELECT 2 AS slno,
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
  WHERE NOT (EXISTS ( SELECT 'x'::text
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
  WHERE t.blobno = 1::numeric AND (EXISTS ( SELECT 'x'::text
           FROM axp_vw_menu x
          WHERE x.pagetype::text ~~ 't%'::text AND btrim(substr(x.pagetype::text, 2, 20)) = t.name::text AND x.visible !~~ '%F%'::text))
UNION ALL
 SELECT 0 AS slno,
    'iview'::character varying AS hltype,
    i.name AS structname,
    i.caption AS searchtext,
    NULL::character varying AS params
   FROM iviews i
  WHERE i.blobno = 1::numeric AND (EXISTS ( SELECT 'x'::text
           FROM axp_vw_menu x
          WHERE x.pagetype::text ~~ 'i%'::text AND btrim(substr(x.pagetype::text, 2, 20)) = i.name::text AND x.visible !~~ '%F%'::text))
  ORDER BY 1
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
(1540330000000,'F',0,null,'admin',to_date('03-01-2019','DD/MM/YYYY'),'admin',to_date('03-01-2019','DD/MM/YYYY'),null,1,1,null,null,null,'Disablesplit','All','Disablesplit',null,'true',null,'true','Forms(Forms)','Forms',null,null,null,null,null,'Iview','ALL','DisablesplitFormstrueALL')
>>

<<
 Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1540440000000,'F',0,null,'admin',to_date('03-01-2019','DD/MM/YYYY'),'admin',to_date('03-01-2019','DD/MM/YYYY'),null,1,1,null,null,null,'Load reports/lists along with form','Iview','Autosplit',null,'true',null,'true','Form Elements(mainrepo)','mainrepo',null,null,null,null,null,'Iview','ALL','Load reports/lists along with formmainrepotrueALL')
>>
<<
 Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1540770000000,'F',0,null,'admin',to_date('03-01-2019','DD/MM/YYYY'),'admin',to_date('03-01-2019','DD/MM/YYYY'),null,1,1,null,null,null,'Open Window mode','All','Navigation',null,'newpage',null,'newpage','Forms(Forms)','Forms','opentstr',null,null,'opentstr',null,'Iview','ALL','Open Window modeFormsnewpageALL')
>>
<<
 Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1573550000000,'F',0,null,'admin',to_date('10-01-2019','DD/MM/YYYY'),'admin',to_date('10-01-2019','DD/MM/YYYY'),null,1,1,null,null,null,'Disablesplit','All','Disablesplit',null,'true',null,'true','Advance Settings(axstc)','axstc',null,null,null,null,null,'Tstruct','ALL','DisablesplitaxstctrueALL')
>>
<<
 Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1108880000000,'F',0,null,'admin',to_date('26-03-2019','DD/MM/YYYY'),'admin',to_date('26-03-2019','DD/MM/YYYY'),null,1,1,null,null,null,'Open Window mode','All','Navigation',null,'newpage',null,'newpage','Form Elements(mainrepo)','mainrepo','deletesc',null,null,'deletesc',null,'Iview','ALL','Open Window modemainreponewpageALL')
>>
<< 
Insert into AXPSTRUCTCONFIG (AXPSTRUCTCONFIGID,CANCEL,SOURCEID,MAPNAME,USERNAME,MODIFIEDON,CREATEDBY,CREATEDON,WKID,APP_LEVEL,APP_DESC,APP_SLEVEL,CANCELREMARKS,WFROLES,ASPROPS,SETYPE,PROPS,CONTEXT,PROPVALUE1,PROPVALUE2,PROPSVAL,STRUCTCAPTION,STRUCTNAME,STRUCTELEMENTS,SFIELD,ICOLUMN,SBUTTON,HLINK,STYPE,USERROLES,DUPCHK) 
values 
(1109010000000,'F',0,null,'admin',to_date('26-03-2019','DD/MM/YYYY'),'admin',to_date('26-03-2019','DD/MM/YYYY'),null,1,1,null,null,null,'Open Window mode','All','Navigation',null,'newpage',null,'newpage','Form Elements(mainrepo)','mainrepo','callws',null,null,'callws',null,'Iview','ALL','Open Window modemainreponewpageALL')
>>
<<
Insert into AXPSTRUCTCONFIG(AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON,
 APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, 
							STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (2038330000000, 'F', 0, 'admin', TO_DATE('05-07-2019', 'DD/MM/YYYY'), 
	'admin', TO_DATE('05-07-2019', 'DD/MM/YYYY'), 1, 1, 'File upload limit',
	'Tstruct', 'File Upload Limit', 
	'1', '1', 'ALL Forms', 'ALL Forms', 'Tstruct', 'ALL', 'File upload limitALL Forms1ALL')

>>
<<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, 
	APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, 
	STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (2176010000000, 'F', 0, 'admin', TO_DATE('04-07-2019', 'DD/MM/YYYY'), 
	'admin', TO_DATE('29-06-2019', 'DD/MM/YYYY'), 1, 1, 'Hide Camera Option', 
	'Tstruct', 'camera option', 'true', 
	'true', 'ALL Forms', 'ALL Forms', 'Tstruct', 'ALL', 'Hide Camera OptionALL FormstrueALL')
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
ALTER TABLE AXPEXCHANGE ADD axpexchangeid NUMERIC(15)
>>
<<
ALTER TABLE AXINTELLIVIEWDET ADD axintelliviewdetid NUMERIC(15);
>>
<<
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
        'admin')
>>
<<
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
        'admin')
>>
<<
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
        'admin')
>>
<<
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
        'admin')
>>
<<
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
        'admin')
>>
<<
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
        'iadxconfv')
>>
<<
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
        'iadxinlog')
>>
<<
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
        'iadxoutlo')
>>
<<
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
        'iapplogsm')
>>
<<
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
        'iaxchtdtl')
>>
<<
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
        'iaxemllog')
>>
<<
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
        'iaxfinyrs')
>>
<<
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
        'iitimtk')
>>
<<
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
        'iloview1')
>>
<<
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
        'ismslog')
>>
<<
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
        'ithint')
>>
<<
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
        'icerrm')
>>
<<
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
        'iaxnxtlst')
>>
<<
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
        'iaxroles')
>>
<<
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
        'iaxusers')
>>
<<
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
        'iaxusracc')
>>
<<
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
        'idmlscrpt')
>>
<<
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
        'iesmsco')
>>
<<
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
        'iiaxex')
>>
<<
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
<<
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
        'iikywd')
>>
<<
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
        'iimobc')
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




--- global ---
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
   (2038330000000, 'F', 0, 'admin', TO_DATE('07/05/2019 08:28:05', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('07/05/2019 08:28:05', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'File upload limit', 'Tstruct', 'File Upload Limit', '1', '1', 'ALL Forms', 'ALL Forms', 'Tstruct', 'ALL', 'File upload limitALL Forms1ALL')
   >>
   <<
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (2176010000000, 'F', 0, 'admin', TO_DATE('07/04/2019 02:37:12', 'MM/DD/YYYY HH24:MI:SS'), 'admin', TO_DATE('06/29/2019 12:40:28', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 'Hide Camera Option', 'Tstruct', 'camera option', 'true', 'true', 'ALL Forms', 'ALL Forms', 'Tstruct', 'ALL', 'Hide Camera OptionALL FormstrueALL')
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields) VALUES 
(1008440000004,'F',0,NULL,'admin','2019-12-27 17:34:22.000','admin','2019-12-27 17:34:22.000',NULL,1,1,NULL,NULL,NULL,'Multi Select Field','Multi Select','configtypeMulti Select Field',NULL,'Tstruct','F','F','T','F','T','T')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES 
(1008440000005,1008440000004,1,'true')
,(1008440000006,1008440000004,2,'false')
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
ALTER TABLE AXUSERS ADD singleloginkey VARCHAR(50)
>>
<<
ALTER TABLE AX_PAGE_SAVED ADD WIDGET_GROUPS Varchar(1)
>>
<<
ALTER TABLE AX_PAGES ADD WIDGET_GROUPS Varchar(1)
>>
<<
update axpstructconfigprops set description= configprops where description is null or description=''
>>
<<
 insert into axctx1 (axcontext,atype) values ('Custom JavaScript','Property')
>>
<<
 insert into axctx1 (axcontext,atype) values ('Custom CSS','Property')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235440000043,'F',0,NULL,'superadmin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Custom JavaScript','Custom JavaScript','configtypeCustom JavaScript','','All','F','F','T','T','F','F','Reports:
Use this property to attach custom javascript to Reports/forms. Set this property value to "true" for a selected report. If this property is set to true, the custom javascript file for Reposts should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.js. In case this property is set to true for all reports instead of a selected report, the file name should be custom.js

Tstructs:
Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235660000010,'F',0,NULL,'superadmin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Custom CSS','Custom CSS','configtypeCustom CSS','','All','F','F','T','T','F','F','Reports:
Use this property to attach custom CSS to Reports. Set this property value to "True" for a selected report. If for report this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.CSS. In case this property is set to true for all reports instead of a selected report, the file name should be custom.CSS.

Tstructs:
Use this property to attach custom CSS to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.CSS. In case this property is set to true for all forms instead of a selected form, the file name should be custom.CSS.
')
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000009,'F',0,NULL,'admin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Grid Scrollbar','Grid Scrollbar','configtypeGrid Scrollbar',NULL,'Tstruct','F','F','T','F','F','F','If key is set to true,then if grid dc is there for the tstruct,then horizontal scroll bar will be fixed at the bottom of the page.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000006,'F',0,NULL,'admin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Auto Save Draft','Auto Save Draft','configtypeAuto Save Draft',NULL,'Tstruct','F','F','T','F','F','F','If key is set to true and time in millisecs(for ex for 60 secs give 60000 . Note: default time will be 120 seconds/2 minutes if no time is set) then on loading tstruct,it will check if unsaved data is there, if unsaved data  exists it will throw a popup with yes /no buttons.If yes, it will load the unsaved data else it will load a new tstruct.If new tstruct is opened for which key exists,then only if any field is changed,it will push data in redis after the mentioned time  in developer options at regular intervals.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000003,'F',0,NULL,'admin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Show keyboard in Hybrid App','Show keyboard in Hybrid App','configtypeShow keyboard in Hybrid App',NULL,'Tstruct','F','F','T','F','F','F','An enhancement to make an intuitive UI in Axpert Hybrid App i.e., 
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
  ORDER BY g.ordno, g.levelno
  >>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES 
(1635440000037,'F',0,NULL,'admin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Enforced Strong Password Policy','General','configtypeEnforced Strong Password Policy',NULL,'Common','F','F','F','F','F','F','If key is set to true,Strong Password Policy will work.Details for Enforced Strong Password Policy: Password should be alphanumeric, contains one UpperCharacter, one LowerCharacter with atleast one special character.It will check the following condition if key set to true and if password entered is not matching the condition,then it will throw error.')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES 
(1635440000038,1635440000037,1,'true')
>>

<< 
INSERT INTO axctx1 (axcontext,atype) values ('Mobile Reports as Table','Property') 
>>
<< 
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984880000036,'F',0,NULL,'superadmin',now(),'superadmin',now(),NULL,1,1,NULL,NULL,NULL,'Notification Time Interval','General','configtypeNotification Time Interval',NULL,'All','F','F','T','T','F','F','Notification feature can be enabled at Application level by adding Developer Option "Notification Time Interval" , with values in minutes for time intervals as 1, 2, 3 , 4 etc. Once this key is added, long running web services/backend scheduled jobs completion can be notified to the user with given time intervals, so that user would be able to do other operations during long running web services/backend jobs.') 
>>
<< 
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984440000004,'F',0,NULL,'superadmin',now(),'superadmin',now(),NULL,1,1,NULL,NULL,NULL,'User Manual','General','configtypeUser Manual',NULL,'All','F','F','T','T','F','F','User can able to access the files through web application which is saved in local folder through User Manual option (located in right sidebar menu)') 
>>
<<
 INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984220000001,'F',0,NULL,'superadmin',now(),'superadmin',now(),NULL,1,1,NULL,NULL,NULL,'Mobile Reports as Table','Mobile Reports as Table','configtypeMobile Reports as Table',NULL,'All','F','F','T','T','F','F','Administrator can enable tabular view in mobile instead of cards view') 
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
create table Axp_TransCheck(sessionid varchar(50))
>>
<<
alter table AxTsUserConfig  add PropName varchar(10)
>>
<<
INSERT INTO axctx1 (axcontext,atype) values ('WebService Timeout','Property') 
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS, DESCRIPTION)
 Values
   (1000330000005, 'F', 0, 'admin', 
    now(), 'admin', now(), 1, 
    1, 'WebService Timeout', 
    'WebService Timeout', 'configtypeWebService Timeout', 'All', 'F', 'F', 'T', 'T', 'F', 'F', 'WebService Timeout')
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
   (1525110003964, 1000330000005, 2, '1000000')
>>
<<
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,CreatedOn,ImportedOn,CreatedBy,UpdatedBy,ImportedBy,readonly,updusername,category,pagetype,INTVIEW,webenable,shortcut) VALUES 
('PageTstemps','Custom UI','<root visible="T" type="p" defpage="T" name="PageTstemps" caption="Custom UI" createdon="08-21-2020" createdby="admin" importedon="08-24-2020 12:20:20" importedby="admin" updatedon="08-21-2020" updatedby="admin" img="" ordno="13" levelno="2" parent="Head14" updusername="" ptype="p" pgtype="ttemps" dbtype="postgre"><Container16 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__temps"/><tstruct__temps cat="tstruct" transid="temps" parent="Container16" align="Client"/></root>
',1,'','T','p','Head14',14,2,'08-21-2020','08-21-2020','08-24-2020 12:20:20','admin','admin','admin',NULL,NULL,NULL,'ttemps',NULL,NULL,NULL)
>>
<<
delete from AXCTX1 where AXCONTEXT in (
'WebService Timeout','Custom JavaScript','Custom CSS','Grid Scrollbar','Auto Save Draft','Show keyboard in Hybrid App',
'Enforced Strong Password Policy','Mobile Reports as Table','User Manual','Notification Time Interval','Iview Button Style','Show Image Widget Action Button','Show Application Menu on Login'
)
>>
<< 
delete from axpstructconfigproval where axpstructconfigpropsid in (
select axpstructconfigpropsid from axpstructconfigprops where configprops in (
'WebService Timeout','Custom JavaScript','Custom CSS','Grid Scrollbar','Auto Save Draft','Show keyboard in Hybrid App',
'Enforced Strong Password Policy','Mobile Reports as Table','User Manual','Notification Time Interval','Iview Button Style','Show Image Widget Action Button','Show Application Menu on Login'
))
>>
<<
delete from axpstructconfigprops where configprops in (
'WebService Timeout','Custom JavaScript','Custom CSS','Grid Scrollbar','Auto Save Draft','Show keyboard in Hybrid App',
'Enforced Strong Password Policy','Mobile Reports as Table','User Manual','Notification Time Interval','Iview Button Style','Show Image Widget Action Button','Show Application Menu on Login'
)
>>
<<
INSERT INTO AXCTX1 (AXCONTEXT,ATYPE) VALUES ('Auto Save Draft','Property')
>>
<<
INSERT INTO AXCTX1 (AXCONTEXT,ATYPE) VALUES ('Custom CSS','Property')
>>
<<
INSERT INTO AXCTX1 (AXCONTEXT,ATYPE) VALUES ('Custom JavaScript','Property')
>>
<<
INSERT INTO AXCTX1 (AXCONTEXT,ATYPE) VALUES ('Grid Scrollbar','Property')
>>
<<
INSERT INTO AXCTX1 (AXCONTEXT,ATYPE) VALUES ('Iview Button Style','Property')
>>
<<
INSERT INTO AXCTX1 (AXCONTEXT,ATYPE) VALUES ('Mobile Reports as Table','Property')
>>
<<
INSERT INTO AXCTX1 (AXCONTEXT,ATYPE) VALUES ('Show keyboard in Hybrid App','Property')
>>
<<
INSERT INTO AXCTX1 (AXCONTEXT,ATYPE) VALUES ('WebService Timeout','Property')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1000330000005,'F',0,NULL,'admin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'WebService Timeout','WebService Timeout','WebService Timeout','configtypeWebService Timeout',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1226220000004,'F',0,NULL,'superadmin',now(),'superadmin',now(),NULL,1,1,NULL,NULL,NULL,'Iview Button Style','Iview Button Style','New Iview buttons UI can be switched as Modern(Google like UI) / Classic(Classic Bootstrap like UI) . Product default Iview Button UI is  "Modern" Style.','configtypeIview Button Style','','Iview','F','F','F','F','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235440000043,'F',0,NULL,'superadmin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Custom JavaScript','Custom JavaScript','configtypeCustom JavaScript','','All','F','F','T','T','F','F','Reports:
Use this property to attach custom javascript to Reports/forms. Set this property value to "true" for a selected report. If this property is set to true, the custom javascript file for Reposts should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.js. In case this property is set to true for all reports instead of a selected report, the file name should be custom.js

Tstructs:
Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235660000010,'F',0,NULL,'superadmin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Custom CSS','Custom CSS','configtypeCustom CSS','','All','F','F','T','T','F','F','Reports:
Use this property to attach custom CSS to Reports. Set this property value to "True" for a selected report. If for report this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.CSS. In case this property is set to true for all reports instead of a selected report, the file name should be custom.CSS.

Tstructs:
Use this property to attach custom CSS to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.CSS. In case this property is set to true for all forms instead of a selected form, the file name should be custom.CSS.
')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1355440000003,'F',0,NULL,'admin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Show keyboard in Hybrid App','Show keyboard in Hybrid App','An enhancement to make an intuitive UI in Axpert Hybrid App i.e., 
-- based on the "Show keyboard in Hybrid App" key value, user can enable or disable the keyboard for autocomplete fields in tstruct level.
-- By default, value is set as true which makes no difference in the existing feature/functionality.
-- If set false,  keyboard is hidden/disabled along with the drop-down and clear icons. On single click of the field, drop down appears to choose the desired value.
','configtypeShow keyboard in Hybrid App',NULL,'Tstruct','F','F','F','T','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1355440000006,'F',0,NULL,'admin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Auto Save Draft','Auto Save Draft','If key is set to true and time in millisecs(for ex for 60 secs give 60000 . Note: default time will be 120 seconds/2 minutes if no time is set) then on loading tstruct,it will check if unsaved data is there, if unsaved data  exists it will throw a popup with yes /no buttons.If yes, it will load the unsaved data else it will load a new tstruct.If new tstruct is opened for which key exists,then only if any field is changed,it will push data in redis after the mentioned time  in developer options at regular intervals.','configtypeAuto Save Draft',NULL,'Tstruct','F','F','F','T','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1355440000009,'F',0,NULL,'admin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Grid Scrollbar','Grid Scrollbar','If key is set to true,then if grid dc is there for the tstruct,then horizontal scroll bar will be fixed at the bottom of the page.','configtypeGrid Scrollbar',NULL,'Tstruct','F','F','F','T','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1635440000037,'F',0,NULL,'admin',now(),'admin',now(),NULL,1,1,NULL,NULL,NULL,'Enforced Strong Password Policy','General','If key is set to true,Strong Password Policy will work.Details for Enforced Strong Password Policy: Password should be alphanumeric, contains one UpperCharacter, one LowerCharacter with atleast one special character.It will check the following condition if key set to true and if password entered is not matching the condition,then it will throw error.','configtypeEnforced Strong Password Policy',NULL,'Common','F','F','F','F','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1984220000001,'F',0,NULL,'superadmin',now(),'superadmin',now(),NULL,1,1,NULL,NULL,NULL,'Mobile Reports as Table','Mobile Reports as Table','Administrator can enable tabular view in mobile instead of cards view','configtypeMobile Reports as Table',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1984440000004,'F',0,NULL,'superadmin',now(),'superadmin',now(),NULL,1,1,NULL,NULL,NULL,'User Manual','General','User can able to access the files through web application which is saved in local folder through User Manual option (located in right sidebar menu)','configtypeUser Manual',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1984880000036,'F',0,NULL,'superadmin',now(),'superadmin',now(),NULL,1,1,NULL,NULL,NULL,'Notification Time Interval','General','Notification feature can be enabled at Application level by adding Developer Option "Notification Time Interval" , with values in minutes for time intervals as 1, 2, 3 , 4 etc. Once this key is added, long running web services/backend scheduled jobs completion can be notified to the user with given time intervals, so that user would be able to do other operations during long running web services/backend jobs.','configtypeNotification Time Interval',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1000330000006,1000330000005,1,'100000')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1226220000005,1226220000004,1,'Modern')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1226220000006,1226220000004,2,'Classic')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1235440000044,1235440000043,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1235440000045,1235440000043,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1235660000011,1235660000010,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1235660000012,1235660000010,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1355440000004,1355440000003,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1355440000005,1355440000003,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1355440000007,1355440000006,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1355440000008,1355440000006,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1355440000010,1355440000009,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1355440000011,1355440000009,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1525110003964,1000330000005,2,'1000000')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1635440000038,1635440000037,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1984220000002,1984220000001,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1984220000003,1984220000001,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1984440000005,1984440000004,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1984440000006,1984440000004,2,'false')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1984880000037,1984880000036,1,'1')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1984880000038,1984880000036,2,'3')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1984880000039,1984880000036,3,'5')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1984880000040,1984880000036,4,'10')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsId,axpstructconfigprovalRow,configvalues) VALUES (1984880000041,1984880000036,5,'30')
>>
<<
alter table axusers add poweruser varchar(1)
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) 
VALUES (1251990000026,'F',0,NULL,'superadmin',now(),'superadmin',now(),NULL,1,1,NULL,NULL,NULL,'Show Image Widget Action Button','General','configtypeShow Image Widget Action Button',NULL,'Common','F','F','T','T','T','F','The SmartView''s columns template can be changed to achieve desired UI and Actions')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1251990000027,1251990000026,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1251990000028,1251990000026,2,'false')
>> 
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1420440000004,'F',0,NULL,'superadmin',now(),'superadmin',now(),NULL,1,1,NULL,NULL,NULL,'Show Application Menu on Login','General','configtypeShow Application Menu on Login',NULL,'All','F','F','T','T','F','F','Application menu can be shown/hidden by setting this Developer Option.')
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

    
   
   

  
