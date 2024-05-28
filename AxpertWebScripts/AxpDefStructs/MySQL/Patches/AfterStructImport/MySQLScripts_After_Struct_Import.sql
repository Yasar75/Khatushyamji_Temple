<<
alter table axpstructconfig add purpose varchar(1000)
>>
<<
ALTER TABLE AXUSERS ADD axusersid numeric(15);
>>
<<
ALTER TABLE AXUSERS ADD cancelremarks  VARCHAR(300);
>>
<<
alter table ax_widget add is_public varchar(1) DEFAULT 'N';
>>
<<
ALTER TABLE AXUSERS ADD cancel  VARCHAR(10);
>>
<<
ALTER TABLE AXUSERS ADD sourceid numeric(15);
>>
<<
alter table axusers modify pwd varchar(20);
>>
<<
ALTER TABLE axusers ADD constraint u1_axusers UNIQUE (Pusername);
>>
<<
ALTER TABLE axusergroups ADD axusergroupsid NUMERIC(15);
>>
<<
ALTER TABLE axusergroups ADD cancelremarks  VARCHAR(300);
>>
<<
ALTER TABLE axusergroups ADD cancel  VARCHAR(10);
>>
<<
ALTER TABLE axusergroups ADD sourceid numeric(15);
>>
<<
ALTER TABLE AXUSERLEVELGROUPS ADD axusersid NUMERIC(15);
>>
<<
ALTER TABLE AXUSERLEVELGROUPS ADD axuserlevelgroupsid NUMERIC(15);
>>
<<
ALTER TABLE  AXDSIGNCONFIG add rolename varchar(60)
>>
<<
update axuserlevelgroups set axusersid=1,AXUSERLEVELGROUPSID=12345555  where username='admin' ;
>>
<<
update axusers set axusersid=1,pusername=username,ppassword=password where username='admin';
>>
<<
update  axuserlevelgroups set axusername='admin',axusergroup='default'  where AXUSERLEVELGROUPSID=12345555
>>

<<
CREATE TRIGGER t1_axusers
   before INSERT ON axusers for each row
BEGIN
	
	set new.username=new.pusername;
	set new.password=new.ppassword;
	    
END;
>>

<<
CREATE TRIGGER t2_axusers
   before update ON axusers for each row
BEGIN
	
	set new.username=new.pusername;
	    
END;
>>

<<
CREATE TRIGGER trg1_AXUSERLEVELGROUPS
   before INSERT ON AXUSERLEVELGROUPS for each row
BEGIN
	
	set new.username=new.axUSERNAME;
	set new.usergroup=new.axusergroup;
	    
END;
>>

<<
CREATE TRIGGER trg2_AXUSERLEVELGROUPS
   before update ON AXUSERLEVELGROUPS for each row
BEGIN
	
	set new.username=new.axUSERNAME;
	set new.usergroup=new.axusergroup;
	    
END;
>>

<<
DROP TABLE AXP_MAILJOBS;
>>

<<
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
  JOBDATE	     DATE,
  JOBID     int not null auto_increment PRIMARY KEY
);
>>

<<
drop table axsms;
>>
<<
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
>>


<<
CREATE TABLE USAGEDTL
(
  EXECUTEDDATE  DATE,
  CODE           VARCHAR(20),
  TITLE          VARCHAR(50),
  CNT           NUMERIC(18)
);
>>

<<
CREATE TABLE AXPEXCEPTION
(
  EXP_DATE       DATE,
  STRUCTNAME      VARCHAR(16),
  SERVICENAME     VARCHAR(50),
  SERVICERESULT   VARCHAR(500),
  COUNT         NUMERIC(18)
);
>>

<<
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
>>

<<
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
>>

<<
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
>>

<<
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
>>

<<
CREATE TABLE ctrltable (txt varchar(100));
>>

<<
INSERT INTO ctrltable
VALUES ('a,b,c');
>>

<<
CREATE TEMPORARY TABLE numbers AS (
SELECT b.a a FROM (SELECT n0 + n1 + n2 + n3 + n4 + n5 AS a
   FROM (SELECT 0 AS n0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) AS z0
   CROSS JOIN (SELECT 0 AS n1 UNION SELECT 4 UNION SELECT 8 UNION SELECT 12) AS z1
   CROSS JOIN (SELECT 0 AS n2 UNION SELECT 16 UNION SELECT 32 UNION SELECT 48) AS z2
   CROSS JOIN (SELECT 0 AS n3 UNION SELECT 64 UNION SELECT 128 UNION SELECT 192) AS z3
   CROSS JOIN (SELECT 0 AS n4 UNION SELECT 256 UNION SELECT 512 UNION SELECT 768) AS z4
   CROSS JOIN (SELECT 0 AS n5 UNION SELECT 1024 UNION SELECT 2048 UNION SELECT 3072) AS z5) b
   WHERE b.a<>0
   ORDER BY 1);
>>

<<
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
>>


--TRIGGER trg_AXPSCRIPTRUNNER



<<
CREATE TRIGGER TRG_UPDATDSIGN 
   BEFORE INSERT ON  AXDSIGNCONFIG  FOR EACH ROW
BEGIN
	
	set new.username=new.pusername;  
  set new.rolename=new.prolename;
    
END;
>>

<<
CREATE TRIGGER TRG2_UPDATDSIGN 
   BEFORE UPDATE ON  AXDSIGNCONFIG  FOR EACH ROW
BEGIN
	
	set new.username=new.pusername;  
  set new.rolename=new.prolename;
    
END;
>>

<<
delete from axpages
>>

<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Head14','Configuration','<root img="" visible="T" name="Head14" caption="Configuration" createdon="2015-11-06" createdby="admin" importedon="2020-08-24 11:33:27" importedby="admin" updatedon="2015-11-06" updatedby="admin" type="h" ordno="5" levelno="1" parent="Head19" ptype="h" pgtype="" dbtype="mysql"></root>',1,'','T','h','Head19',5,1,'2020-08-24','2020-08-24','2020-08-24 11:33:27','admin','admin','admin',NULL,NULL,NULL,'',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Head16','Data Setup','<root img="" visible="T" name="Head16" caption="Data Setup" createdon="2015-11-06" createdby="admin" importedon="2020-08-24 11:33:27" importedby="admin" updatedon="2015-11-06" updatedby="admin" type="h" ordno="16" levelno="1" parent="Head19" ptype="h" pgtype="" dbtype="mysql"></root>',1,'','T','h','Head19',25,1,'2020-08-24','2020-08-24','2020-08-24 11:33:27','admin','admin','admin',NULL,NULL,NULL,'',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Head17','Admin Utilities','<root img="" visible="T" name="Head17" caption="Admin Utilities" createdon="2015-11-06" createdby="admin" importedon="2020-08-24 11:33:27" importedby="admin" updatedon="2015-11-06" updatedby="admin" type="h" ordno="20" levelno="1" parent="Head19" ptype="h" pgtype="" dbtype="mysql"></root>',1,'','T','h','Head19',30,1,'2020-08-24','2020-08-24','2020-08-24 11:33:27','admin','admin','admin',NULL,NULL,NULL,'',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Head18','Admin Reports','<root img="" visible="T" name="Head18" caption="Admin Reports" createdon="2015-11-06" createdby="admin" importedon="2020-08-24 11:33:27" importedby="admin" updatedon="2015-11-06" updatedby="admin" type="h" ordno="25" levelno="1" parent="Head19" ptype="h" pgtype="" dbtype="mysql"></root>',1,'','T','h','Head19',14,1,'2020-08-24','2020-08-24','2020-08-24 11:33:27','admin','admin','admin',NULL,NULL,NULL,'',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Head19','Admin Setup','<root img="" visible="T" name="Head19" caption="Admin Setup" createdon="2015-11-12" createdby="admin" importedon="2020-08-24 11:33:27" importedby="admin" updatedon="2015-11-12" updatedby="admin" type="h" ordno="1" levelno="0" parent="" ptype="h" pgtype="" dbtype="mysql"></root>',1,'','T','h','',1,0,'2020-08-24','2020-08-24','2020-08-24 11:33:27','admin','admin','admin',NULL,NULL,NULL,'',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Head20','System','<root img="" visible="F" name="Head20" caption="System" createdon="21/12/2018 12:04:39" createdby="admin" importedon="" importedby="" updatedon="21/12/2018 12:09:58" updatedby="admin" type="h" ordno="28" levelno="0" parent="" pgtype="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action=""></root>',1,NULL,'F','p','Head18',23,2,'21/12/2018 12:09:58','21/12/2018 12:04:39',NULL,'admin','admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Head21','Settings','<root img="" visible="T" name="Head21" caption="Settings" createdon="21/12/2018 12:05:50" createdby="admin" importedon="2020-08-24 11:33:26" importedby="admin" updatedon="21/12/2018 12:05:50" updatedby="admin" type="h" ordno="34" levelno="1" parent="" ptype="h" pgtype="" dbtype="mysql"></root>',1,'','T','h','Head19',28,1,'2020-08-24','2020-08-24','2020-08-24 11:33:26','admin','admin','admin',NULL,NULL,NULL,'',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Head22','User Credentials','<root img="" visible="T" name="Head22" caption="User Credentials" createdon="2020-02-14 16:45:26" createdby="admin" importedon="2020-08-24 11:33:26" importedby="admin" updatedon="2020-02-14 16:45:26" updatedby="admin" type="h" ordno="2" levelno="1" parent="" ptype="h" pgtype="" dbtype="mysql"></root>',1,'','T','h','Head19',2,1,'2020-08-24','2020-08-24','2020-08-24 11:33:26','admin','admin','admin',NULL,NULL,NULL,'',NULL,NULL,NULL)
 >>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Head249','Mobile','<root img="" visible="T" name="Head249" caption="Mobile" createdon="12/19/2019 15:00:57" createdby="admin" importedon="" importedby="" updatedon="12/19/2019 15:00:57" updatedby="admin"></root>
',1,'','T','h','Head19',34,1,'2020-08-24','2020-08-24',NULL,'admin','admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('Page245','Mobile Configuration','<root cat="page" name="Page245" caption="Mobile Configuration" visible="T" type="p" img="" parent="" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" createdon="2015-11-18" createdby="admin" importedon="2020-08-24 11:33:21" importedby="admin" updatedon="2015-11-18" updatedby="admin" ordno="14" levelno="2" updusername="" ptype="p" pgtype="taxmme" dbtype="mysql"><relations cat="rel"/><Container21 paged="False" align="Client" cat="cntr" parent="ClientPanel" font=",,," tlhw="0,0,647,1131" color="$00FAF7F1" st="tstruct__axmme"/><tstruct__axmme cat="tstruct" transid="axmme" parent="Container21" align="Client" tlhw="0,0,647,1131"/></root>',1,'','T','p','Head249',35,2,'2020-08-24','2020-08-24','2020-08-24 11:33:21','admin','admin','admin',NULL,NULL,NULL,'taxmme',NULL,NULL,NULL)
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvadxconfv','ADX Configuration','<root visible="T" type="p" defpage="T" name="PageIvadxconfv" caption="ADX Configuration" createdon="2015-07-03" createdby="admin" importedon="2020-08-24 11:34:17" importedby="admin" updatedon="2015-08-06" updatedby="admin" img="" ordno="24" levelno="2" parent="Head17" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iadxconfv" dbtype="mysql"><Container21 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,659,1129" st="view__adxconfv" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__adxconfv cat="iview" name="adxconfv" parent="Container21" align="Client"/></root>',1,'','T','p','Head17',33,2,'2020-08-24','2020-08-24','2020-08-24 11:34:17','admin','admin','admin',NULL,NULL,NULL,'iadxconfv',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvadxinlog','ADX Inbound Log','<root visible="T" type="p" defpage="T" name="PageIvadxinlog" caption="ADX Inbound Log" createdon="2015-07-02" createdby="admin" importedon="2020-08-24 11:34:16" importedby="admin" updatedon="2015-07-02" updatedby="admin" img="" ordno="29" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iadxinlog" dbtype="mysql"><Container16 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__adxinlog"/><view__adxinlog cat="iview" name="adxinlog" parent="Container16" align="Client"/></root>',1,'','T','p','Head18',17,2,'2020-08-24','2020-08-24','2020-08-24 11:34:16','admin','admin','admin',NULL,NULL,NULL,'iadxinlog',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvadxoutlo','ADX Outbound Log','<root visible="T" type="p" defpage="T" name="PageIvadxoutlo" caption="ADX Outbound Log" createdon="2015-07-02" createdby="admin" importedon="2020-08-24 11:34:16" importedby="admin" updatedon="2015-07-02" updatedby="admin" img="" ordno="28" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iadxoutlo" dbtype="mysql"><Container15 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__adxoutlo"/><view__adxoutlo cat="iview" name="adxoutlo" parent="Container15" align="Client"/></root>',1,'','T','p','Head18',16,2,'2020-08-24','2020-08-24','2020-08-24 11:34:16','admin','admin','admin',NULL,NULL,NULL,'iadxoutlo',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvapplogsm','Application Usage Statistics','<root visible="T" type="p" defpage="T" updatedon="2015-10-29" name="PageIvapplogsm" caption="Application Usage Statistics" img="" ordno="31" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iapplogsm" importedon="2020-08-24 11:34:16" importedby="admin" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" updatedby="admin" dbtype="mysql" createdon="2020-02-14 16:24:37"><Container187 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__applogsm" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__applogsm cat="iview" name="applogsm" parent="Container187" align="Client"/></root>',1,'','T','p','Head18',19,2,'2020-08-24','2020-08-24','2020-08-24 11:34:16',NULL,'admin','admin',NULL,NULL,NULL,'iapplogsm',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvaxchtdtl','Dashboard Configuration','<root visible="T" type="p" defpage="T" name="PageIvaxchtdtl" caption="Dashboard Configuration" createdon="2015-07-03" createdby="admin" importedon="2020-08-24 11:33:34" importedby="admin" updatedon="2015-11-16" updatedby="admin" img="" ordno="7" levelno="2" parent="Head14" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iaxchtdtl" dbtype="mysql"><Container39 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__axchtdtl" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__axchtdtl cat="iview" name="axchtdtl" parent="Container39" align="Client"/></root>',1,'','T','p','Head14',7,2,'2020-08-24','2020-08-24','2020-08-24 11:33:34','admin','admin','admin',NULL,NULL,NULL,'iaxchtdtl',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvaxemllog','Email Log','<root visible="T" type="p" defpage="T" name="PageIvaxemllog" caption="Email Log" createdon="2015-07-02" createdby="admin" importedon="2020-08-24 11:33:34" importedby="admin" updatedon="2015-07-02" updatedby="admin" img="" ordno="26" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iaxemllog" dbtype="mysql"><Container14 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axemllog"/><view__axemllog cat="iview" name="axemllog" parent="Container14" align="Client"/></root>',1,'','T','p','Head18',15,2,'2020-08-24','2020-08-24','2020-08-24 11:33:34','admin','admin','admin',NULL,NULL,NULL,'iaxemllog',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvaxfinyrs','Year','<root visible="T" type="p" defpage="T" name="PageIvaxfinyrs" caption="Year" createdon="2015-07-22" createdby="admin" importedon="2020-08-24 11:33:34" importedby="admin" updatedon="2015-11-16" updatedby="admin" img="" ordno="18" levelno="2" parent="Head16" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iaxfinyrs" dbtype="mysql"><Container55 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__axfinyrs" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__axfinyrs cat="iview" name="axfinyrs" parent="Container55" align="Client"/></root>',1,'','T','p','Head16',26,2,'2020-08-24','2020-08-24','2020-08-24 11:33:34','admin','admin','admin',NULL,NULL,NULL,'iaxfinyrs',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvaxnxtlst','Intelliview Configuration','<root visible="T" type="p" defpage="T" name="PageIvaxnxtlst" caption="Intelliview Configuration" createdon="2015-07-21" createdby="admin" importedon="2020-08-24 11:33:33" importedby="admin" updatedon="2015-07-21" updatedby="admin" img="" ordno="8" levelno="2" parent="Head14" updusername="" ptype="p" pgtype="iaxnxtlst" dbtype="mysql"><Container47 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axnxtlst"/><view__axnxtlst cat="iview" name="axnxtlst" parent="Container47" align="Client"/></root>',1,'','T','p','Head14',8,2,'2020-08-24','2020-08-24','2020-08-24 11:33:33','admin','admin','admin',NULL,NULL,NULL,'iaxnxtlst',NULL,NULL,NULL) >>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvaxroles','User Roles','<root visible="T" type="p" defpage="T" name="PageIvaxroles" caption="User Roles" createdon="21/07/2015 12:26:56" createdby="admin" importedon="2020-08-24 11:33:33" importedby="admin" updatedon="2018-10-31 17:45:15" updatedby="admin" img="" ordno="3" levelno="2" parent="Head22" updusername="" ptype="p" pgtype="iaxroles" dbtype="mysql"><Container50 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axroles"/><view__axroles cat="iview" name="axroles" parent="Container50" align="Client"/></root>',1,'','T','p','Head22',3,2,'2020-08-24','2020-08-24','2020-08-24 11:33:33','admin','admin','admin',NULL,NULL,NULL,'iaxroles',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvaxusers','User Logins','<root visible="T" type="p" defpage="T" name="PageIvaxusers" caption="User Logins" createdon="21/07/2015 12:32:11" createdby="admin" importedon="2020-08-24 11:33:32" importedby="admin" updatedon="2018-10-31 17:45:43" updatedby="admin" img="" ordno="4" levelno="2" parent="Head22" updusername="" ptype="p" pgtype="iaxusers" dbtype="mysql"><Container51 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__axusers"/><view__axusers cat="iview" name="axusers" parent="Container51" align="Client"/></root>',1,'','T','p','Head22',4,2,'2020-08-24','2020-08-24','2020-08-24 11:33:32','admin','admin','admin',NULL,NULL,NULL,'iaxusers',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvaxusracc','User Access Report','<root visible="T" type="p" defpage="T" name="PageIvaxusracc" caption="User Access Report" createdon="2015-07-29" createdby="admin" importedon="2020-08-24 11:33:31" importedby="admin" updatedon="2015-10-29" updatedby="admin" img="" ordno="30" levelno="2" parent="Head18" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iaxusracc" dbtype="mysql"><Container59 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__axusracc" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__axusracc cat="iview" name="axusracc" parent="Container59" align="Client"/></root>',1,'','T','p','Head18',18,2,'2020-08-24','2020-08-24','2020-08-24 11:33:31','admin','admin','admin',NULL,NULL,NULL,'iaxusracc',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvcerrm','Custom Error Messages','<root visible="T" type="p" defpage="T" name="PageIvcerrm" caption="Custom Error Messages" createdon="2015-11-18" createdby="admin" importedon="2020-08-24 11:33:30" importedby="admin" updatedon="2015-11-18" updatedby="admin" img="" ordno="9" levelno="2" parent="Head14" updusername="" ptype="p" pgtype="icerrm" dbtype="mysql"><Container3 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__cerrm"/><view__cerrm cat="iview" name="cerrm" parent="Container3" align="Client"/></root>',1,'','T','p','Head14',9,2,'2020-08-24','2020-08-24','2020-08-24 11:33:30','admin','admin','admin',NULL,NULL,NULL,'icerrm',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvdmlscrpt','Script Runner','<root visible="T" type="p" defpage="T" updatedon="2015-07-21" name="PageIvdmlscrpt" caption="Script Runner" img="" ordno="21" levelno="2" parent="Head17" updusername="" ptype="p" pgtype="idmlscrpt" importedon="2020-08-24 11:33:30" importedby="admin" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" updatedby="admin" dbtype="mysql" createdon="2020-02-14 16:24:35"><Container538 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,648,1131" st="view__dmlscrpt" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__dmlscrpt cat="iview" name="dmlscrpt" parent="Container538" align="Client"/></root>',1,'','T','p','Head17',31,2,'2020-08-24','2020-08-24','2020-08-24 11:33:30',NULL,'admin','admin',NULL,NULL,NULL,'idmlscrpt',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvesmsco','Email/SMS Configuration','<root visible="T" type="p" defpage="T" name="PageIvesmsco" caption="Email/SMS Configuration" createdon="2015-11-16" createdby="admin" importedon="2020-08-24 11:33:28" importedby="admin" updatedon="2015-11-16" updatedby="admin" img="" ordno="10" levelno="2" parent="Head14" updusername="" ptype="p" pgtype="iesmsco" dbtype="mysql"><Container5 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__esmsco"/><view__esmsco cat="iview" name="esmsco" parent="Container5" align="Client"/></root>',1,'','T','p','Head14',10,2,'2020-08-24','2020-08-24','2020-08-24 11:33:28','admin','admin','admin',NULL,NULL,NULL,'iesmsco',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIviaxex','Application Exceptions','<root visible="T" type="p" defpage="T" name="PageIviaxex" caption="Application Exceptions" createdon="2015-11-17" createdby="admin" importedon="2020-08-24 11:33:28" importedby="admin" updatedon="2015-11-17" updatedby="admin" img="" ordno="33" levelno="2" parent="Head18" updusername="" ptype="p" pgtype="iiaxex" dbtype="mysql"><Container13 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__iaxex"/><view__iaxex cat="iview" name="iaxex" parent="Container13" align="Client"/></root>',1,'','T','p','Head18',24,2,'2020-08-24','2020-08-24','2020-08-24 11:33:28','admin','admin','admin',NULL,NULL,NULL,'iiaxex',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIviaxpscon','Axpstruct Configuration','<root visible="T" type="p" defpage="T" name="PageIviaxpscon" caption="Axpstruct Configuration" createdon="04/12/2018 15:28:54" createdby="admin" importedon="2020-08-24 11:33:28" importedby="admin" updatedon="19/12/2018 15:17:54" updatedby="admin" img="" ordno="11" levelno="2" parent="Head14" pgtype="iiaxpscon" updusername="" ptype="p" dbtype="mysql"><Container388 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__iaxpscon"/><view__iaxpscon cat="iview" name="iaxpscon" parent="Container388" align="Client"/></root>',1,'','T','p','Head14',11,2,'2020-08-24','2020-08-24','2020-08-24 11:33:28','admin','admin','admin',NULL,NULL,NULL,'iiaxpscon',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvidsco','DSign Configuration','<root visible="T" type="p" defpage="T" name="PageIvidsco" caption="DSign Configuration" createdon="2015-11-16" createdby="admin" importedon="2020-08-24 11:33:27" importedby="admin" updatedon="2015-11-16" updatedby="admin" img="" ordno="6" levelno="2" parent="Head14" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iidsco" dbtype="mysql"><Container11 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__idsco" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__idsco cat="iview" name="idsco" parent="Container11" align="Client"/></root>',1,'','T','p','Head14',6,2,'2020-08-24','2020-08-24','2020-08-24 11:33:27','admin','admin','admin',NULL,NULL,NULL,'iidsco',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvikywd','Keyword Template','<root visible="T" type="p" defpage="T" name="PageIvikywd" caption="Keyword Template" createdon="2015-11-16" createdby="admin" importedon="2020-08-24 11:33:21" importedby="admin" updatedon="2015-11-16" updatedby="admin" img="" ordno="22" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iikywd" dbtype="mysql"><Container9 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__ikywd" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__ikywd cat="iview" name="ikywd" parent="Container9" align="Client"/></root>',1,'','T','p','Head18',21,2,'2020-08-24','2020-08-24','2020-08-24 11:33:21','admin','admin','admin',NULL,NULL,NULL,'iikywd',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvimobc','Mobile Configuration','<root visible="T" type="p" defpage="T" name="PageIvimobc" caption="Mobile Configuration" createdon="2015-11-12" createdby="admin" importedon="2020-08-24 11:33:21" importedby="admin" updatedon="2018-06-26" updatedby="admin" img="" ordno="13" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iimobc" dbtype="mysql"><Container2 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__imobc" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__imobc cat="iview" name="imobc" parent="Container2" align="Client"/></root>',1,'','T','p','Head249',36,2,'2020-08-24','2020-08-24','2020-08-24 11:33:21','admin','admin','admin',NULL,NULL,NULL,'iimobc',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvitimtk','Time Taken Analysis','<root visible="T" type="p" defpage="T" name="PageIvitimtk" caption="Time Taken Analysis" createdon="2015-11-17" createdby="admin" importedon="2020-08-24 11:33:21" importedby="admin" updatedon="2015-11-17" updatedby="admin" img="" ordno="32" levelno="2" parent="" updusername="" ptype="p" pgtype="iitimtk" dbtype="mysql"><Container12 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__itimtk"/><view__itimtk cat="iview" name="itimtk" parent="Container12" align="Client"/></root>',1,'','T','p','Head18',20,2,'2020-08-24','2020-08-24','2020-08-24 11:33:21','admin','admin','admin',NULL,NULL,NULL,'iitimtk',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvloview1','List of Values','<root visible="T" type="p" defpage="T" name="PageIvloview1" caption="List of Values" createdon="2015-08-21" createdby="admin" importedon="2020-08-24 11:33:20" importedby="admin" updatedon="2015-08-21" updatedby="admin" img="" ordno="17" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="iloview1" dbtype="mysql"><Container74 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="view__loview1" font="Tahoma,,,clBlack" color="$00FAF7F1"/><view__loview1 cat="iview" name="loview1" parent="Container74" align="Client"/></root>',1,'','T','p','Head16',27,2,'2020-08-24','2020-08-24','2020-08-24 11:33:20','admin','admin','admin',NULL,NULL,NULL,'iloview1',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvsmslog','SMS Log','<root visible="T" type="p" defpage="T" updatedon="05/17/2012 11:04:42" name="PageIvsmslog" caption="SMS Log" img="" ordno="27" levelno="2" parent="" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="ismslog" importedon="2020-08-24 11:33:20" importedby="admin" dbtype="mysql"><Container179 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,676,1045" st="view__smslog" font=",,," color="$00FAF7F1"/><view__smslog cat="iview" name="smslog" parent="Container179" align="Client"/></root>',1,'','T','p','Head18',22,2,'2020-08-24','2020-08-24','2020-08-24 11:33:20',NULL,NULL,'admin',NULL,NULL,NULL,'ismslog',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageIvthint','Transaction Hint','<root visible="T" type="p" defpage="T" name="PageIvthint" caption="Transaction Hint" createdon="2015-11-19" createdby="admin" importedon="2020-08-24 11:33:20" importedby="admin" updatedon="2015-11-19" updatedby="admin" img="" ordno="23" levelno="2" parent="" updusername="" ptype="p" pgtype="ithint" dbtype="mysql"><Container4 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__thint"/><view__thint cat="iview" name="thint" parent="Container4" align="Client"/></root>',1,'','T','p','Head17',32,2,'2020-08-24','2020-08-24','2020-08-24 11:33:20','admin','admin','admin',NULL,NULL,NULL,'ithint',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageTsastcp','Configuration Property','<root visible="T" type="p" defpage="T" name="PageTsastcp" caption="Configuration Property" createdon="04/12/2018 13:19:32" createdby="admin" importedon="2020-08-24 11:31:03" importedby="admin" updatedon="18/12/2018 15:43:36" updatedby="admin" img="" ordno="15" levelno="2" parent="" updusername="" ptype="p" pgtype="tastcp" dbtype="mysql"><Container386 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__astcp"/><tstruct__astcp cat="tstruct" transid="astcp" parent="Container386" align="Client"/></root>',1,'','T','p','Head14',12,2,'2020-08-24','2020-08-24','2020-08-24 11:31:03','admin','admin','admin',NULL,NULL,NULL,'tastcp',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageTsaxstc','Developer Options','<root visible="T" type="p" defpage="T" name="PageTsaxstc" caption="Developer Options" createdon="2020-02-17" createdby="admin" importedon="2020-08-24 11:31:26" importedby="admin" updatedon="2020-05-05" updatedby="superadmin" img="" ordno="35" levelno="0" parent="" updusername="" ptype="p" pgtype="taxstc" dbtype="mysql"><Container387 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__axstc"/><tstruct__axstc cat="tstruct" transid="axstc" parent="Container387" align="Client"/></root>',1,'','T','p','Head21',29,2,'2020-08-24','2020-08-24','2020-08-24 11:31:26','admin','superadmin','admin',NULL,NULL,NULL,'taxstc',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageTsofcon','Offline Table Configuration','<root visible="T" type="p" defpage="T" name="PageTsofcon" caption="Offline Table Configuration" createdon="2015-12-25" createdby="admin" importedon="2020-08-24 11:34:16" importedby="admin" updatedon="2015-12-30" updatedby="admin" img="" ordno="12" levelno="2" parent="Head14" updusername="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action="" ptype="p" pgtype="tofcon" dbtype="mysql"><Container32 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,647,1131" st="tstruct__ofcon" font="Tahoma,,,clBlack" color="$00FAF7F1"/><tstruct__ofcon cat="tstruct" transid="ofcon" parent="Container32" align="Client"/></root>',1,'','T','p','Head249',37,2,'2020-08-24','2020-08-24','2020-08-24 11:34:16','admin','admin','admin',NULL,NULL,NULL,'tofcon',NULL,NULL,NULL) 
>>
<< 
INSERT INTO axpages (name,caption,props,blobno,img,visible,type,parent,ordno,levelno,updatedon,`CreatedOn`,`ImportedOn`,`CreatedBy`,`UpdatedBy`,`ImportedBy`,readonly,updusername,category,pagetype,`INTVIEW`,webenable,shortcut) VALUES ('PageTstemps','Custom UI','<root visible="T" type="p" defpage="T" name="PageTstemps" caption="Custom UI" createdon="2020-08-21" createdby="admin" importedon="2020-08-24 11:31:24" importedby="admin" updatedon="2020-08-21" updatedby="admin" img="" ordno="13" levelno="2" parent="" updusername="" ptype="p" pgtype="ttemps" dbtype="postgre"><Container16 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__temps"/><tstruct__temps cat="tstruct" transid="temps" parent="Container16" align="Client"/></root>',1,'','T','p','Head14',13,2,'2020-08-24','2020-08-24','2020-08-24 11:31:24','admin','admin','admin',NULL,NULL,NULL,'ttemps',NULL,NULL,NULL) 
>>


<<        
update axpages set UPDATEDON = CAST(NOW() AS DATE),CREATEDON= CAST(NOW() AS DATE);
>>
<<   
CREATE  PROCEDURE GetIview(ISql longtext,INoofRec int,IpageNo int, ICountFlag int)
Begin  
 declare v_pos1 int;  declare v_pos2 int; declare v_pos3 int;    
 declare v_Qry longtext;    
 declare v_orderby varchar(1000); 
 set v_pos1 = 0;    
 set v_pos2 = 0;    
 set v_Qry = ISql;    
 set v_orderby = '';  
 set @row_no:=0; 
 if (INoofRec>0 and IpageNo>0)     
 then    
  set ISql=CONCAT('select * from (select a.*, (@row_no:=@row_no+1) as rowno, '''' as axrowtype from ( ',v_Qry, ') as a  ) xy  where rowno between ' , cast(((INoofRec * (IpageNo-1))+1) as char(50) ) , ' and ' , cast((INoofRec * (IpageNo)) as char(50) ) , ' order by rowno ');      
  else    
  set ISql=CONCAT('select a.*, (@row_no:=@row_no+1) as rowno, '''' as axrowtype from ( ',v_Qry, ') as a ');     
  end if; 
	set @stmt_ISql =  ISql;
	prepare stmt from @stmt_ISql;
	execute stmt;
	deallocate prepare stmt;    
 if (ICountFlag = 1 and IpageNo <= 1)    
 then    
   set v_Qry = CONCAT('select  count(*) as IviewCount from  (', v_Qry ,')a');    
   set @stmt_str =  v_Qry;
   prepare stmt from @stmt_str;
   execute stmt;
   deallocate prepare stmt;    
 end if;   
End
>>
<<
CREATE  PROCEDURE Get_AxPages_Hierarchy( language VARCHAR(50),responsibility text)
BEGIN
  declare v_Done tinyint unsigned default 0;
  declare v_Name text;
    declare v_Name2 varchar(100);
    declare v_PageType text;
    declare v_Visible text;
    declare v_Caption VARCHAR(200);
  declare leaveLoop int default false;
    DROP TEMPORARY TABLE IF EXISTS tmpAxPages;    
  CREATE TEMPORARY TABLE tmpAxPages(
    NAME varchar(100) NOT NULL,
    CAPTION varchar(200) DEFAULT NULL,
    PAGETYPE varchar(200) DEFAULT NULL,
    VISIBLE varchar(8000) DEFAULT NULL
  ) ENGINE=MEMORY; 
    INSERT INTO tmpAxPages(NAME, CAPTION, PAGETYPE, VISIBLE) 
    SELECT axp.NAME, CASE WHEN IFNULL(axl.compcaption,'') <> '' THEN axl.compcaption ELSE axp.CAPTION END, 
    axp.PAGETYPE, axp.VISIBLE FROM axpages axp
    LEFT OUTER JOIN axlanguage axl on axp.NAME = axl.compname AND axl.lngname =language 
    WHERE (axp.PARENT IS NULL OR IFNULL(axp.PARENT,'') = '');
  BEGIN
    DECLARE v_getpages CURSOR FOR
    Select axp.NAME, CASE WHEN IFNULL(axl.compcaption,'') <> '' THEN axl.compcaption ELSE axp.CAPTION END, axp.PAGETYPE, axp.VISIBLE from axpages axp 
        LEFT OUTER JOIN axlanguage axl on axp.NAME = axl.compname AND axl.lngname =language 
        WHERE (axp.PARENT IS NOT NULL AND IFNULL(axp.PARENT,'') <> '');
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET leaveLoop = TRUE;
    OPEN v_getpages;
    pagesLoop: LOOP
      FETCH v_getpages INTO v_Name, v_Caption, v_PageType, v_Visible; 
      IF leaveLoop THEN
        LEAVE pagesLoop;
      END IF;
            SET v_Name2 = v_Name;
            SET v_Done = 0;
      WHILE NOT v_Done DO
        IF EXISTS(select 1 from axpages a 
              where a.name = v_Name and (a.PARENT IS NOT NULL AND IFNULL(a.PARENT,'') <> '')) then
          BEGIN
            SELECT parent FROM axpages where name = v_Name INTO @parentname;
                                  
            SELECT visible FROM axpages where name = @parentname INTO @visible;
                        
                        SET v_Name = @parentname;
                        
                        SET v_Visible = CONCAT(v_Visible, ','); 
            SET v_Visible = CONCAT(v_Visible, @visible);                        
          END;
        ELSE
          SET v_Done = 1;
        END IF;
      END WHILE;
      INSERT INTO tmpAxPages(NAME, CAPTION, PAGETYPE, VISIBLE) 
            values(v_Name2, v_Caption, v_PageType, v_Visible);
    END LOOP;
    CLOSE v_getpages;
  END;
    SELECT a.* FROM 
    (SELECT CASE WHEN SUBSTRING(tmp.PAGETYPE,1,1) = 'n' THEN 'i' ELSE SUBSTRING(tmp.PAGETYPE,1,1) END as STYPE, 
    SUBSTRING(tmp.PAGETYPE,2) STYPENAME, tmp.CAPTION CAPTION    
    FROM tmpAxPages tmp
    JOIN axpages axp ON axp.name = tmp.NAME
    WHERE IFNULL(tmp.PAGETYPE,'') <> '' AND NOT INSTR(UPPER(tmp.VISIBLE),'F') > 0
    AND (('default' in (responsibility)) or 
    (('default' not in (responsibility) 
    AND axp.parent IN (SELECT SNAME FROM AXUSERACCESS WHERE RNAME IN (responsibility) and SUBSTRING(tmp.PAGETYPE,1,1) = 'p') ))) and SUBSTRING(tmp.PAGETYPE,1,1) is not null) a    
  ORDER BY a.STYPE,a.CAPTION;
    DROP TEMPORARY TABLE IF EXISTS tmpAxPages;  
END
>>
<<
CREATE  PROCEDURE SP_CreateLog(ISessionid varchar(4000),Iservicename varchar(4000),
                                        Icalledon datetime(3),Istructname VARCHAR(4000),
                                        Irecordid VARCHAR(4000),Iserviceresult VARCHAR(4000),
                                        Idbtimetaken varchar(4000))
BEGIN
    declare v_IUsername varchar(1000);
    declare v_Icallfinished datetime(3);
    declare v_Itimetaken varchar(1000);
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
  GET DIAGNOSTICS condition 1
    @SQLState = RETURNED_SQLSTATE, @SQLMessage = MESSAGE_TEXT;      
    ROLLBACK;
    
END;
    set v_Itimetaken=v_Icallfinished - Icalledon;
      select username into v_IUsername from  connections where sessionid =ISessionid; 
        
    insert into  axpertlog(sessionid,username,calledon,callfinished,structname,recordid,servicename,
    serviceresult,timetaken,dbtimetaken) values 
      (ISessionid,v_IUsername,Icalledon,v_Icallfinished,Istructname,Irecordid,
      Iservicename,Iserviceresult,v_Itimetaken,Idbtimetaken);
END
>>
<<
CREATE  PROCEDURE SP_GetChoices(Isql nvarchar(5000), IsessionID varchar(30))
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      GET DIAGNOSTICS condition 1
      @SQLState = RETURNED_SQLSTATE, @SQLMessage = MESSAGE_TEXT; 
            SELECT CONCAT('<error>', @SQLMessage,'</error>') As errorString; 
        END;
  DECLARE EXIT HANDLER FOR 1062 
    BEGIN
      GET DIAGNOSTICS condition 1
      @SQLState = RETURNED_SQLSTATE, @SQLMessage = MESSAGE_TEXT;  
            SELECT CONCAT('<error>', @SQLMessage,'</error>') As errorString; 
        END;
  DECLARE EXIT HANDLER FOR SQLSTATE '23000'
      BEGIN
      GET DIAGNOSTICS condition 1
      @SQLState = RETURNED_SQLSTATE, @SQLMessage = MESSAGE_TEXT;  
            SELECT CONCAT('<error>', @SQLMessage,'</error>') As errorString; 
        END;
    IF ( lower(substring(ltrim(Isql),1,6))= 'select' ) then
        begin  
           set @stmt_ISql =  Isql;
           prepare stmt from @stmt_ISql;
           execute stmt;
           deallocate prepare stmt; 
        end;
    else  
        begin  
           set @stmt_ISql =  Isql;
           prepare stmt from @stmt_ISql;
           execute stmt;
           deallocate prepare stmt; 
           select 'done' as result;  
        end;
    end IF;
END
>>
<<
CREATE PROCEDURE sp_GetIviewStructure(IN Iiviewname VARCHAR(10), IN ILanguage VARCHAR(50))
BEGIN
  declare v_xml text; 
  declare v_props text; 
  declare leaveLoop int default false;  
    set v_props = '';
  set v_xml = '';
  BEGIN
    DECLARE v_getprops CURSOR FOR
    select props from iviews where name = Iiviewname order by blobno;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET leaveLoop = TRUE;
    OPEN v_getprops;
    xmlLoop: LOOP
      FETCH v_getprops INTO v_props;    
      IF leaveLoop THEN
        LEAVE xmlLoop;
      END IF;
      set v_xml = CONCAT(v_xml, v_props); 
    END LOOP;
    CLOSE v_getprops;
    END;
    select v_xml as Result;
    select b.compname, b.compcaption, b.comphint from axlanguage b
  where lower(b.sname)= 'i' + lower(Iiviewname) and lower(b.dispname) = lower(ILanguage);
END
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
CREATE TABLE AX_NOTIFY(
    NOTIFICATION_ID INT(10) AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(255),
    MESSAGE TEXT,
    ACTIONS TEXT,
    FROMUSER VARCHAR(255),
    BROADCAST VARCHAR(1) DEFAULT 'N',
    STATUS VARCHAR(255),
    CREATED_BY VARCHAR(255),
    CREATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    PURGE_ON_FIRST_ACTION VARCHAR(1) DEFAULT 'N',
    NOTIFICATION_SENT_DATETIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    RECORDID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
);
>>
<<
CREATE TABLE AX_NOTIFY_WORKFLOW(
    NOTIFICATION_ID INT(10),
    RECORDID VARCHAR(255),
    APP_LEVEL VARCHAR(2),
    APP_DESC VARCHAR(2),
    CREATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
);
>>
<<
CREATE TABLE AX_MOBILE_RESPONSE(
    NOTIFICATION_ID INT(10), 
    FOREIGN KEY (NOTIFICATION_ID) REFERENCES AX_NOTIFY(NOTIFICATION_ID) ON DELETE CASCADE,
    USER_ID VARCHAR(255),
    RESPONSE TEXT, 
    PROJECT_ID VARCHAR(255)
);
>>
<<
CREATE TABLE AX_MOBILE_USER(
    IMEI VARCHAR(255),
    USER_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    FIREBASE_ID VARCHAR(255),
    GROUPNAME VARCHAR(255),
    ACTIVE VARCHAR(1)
);
>>
<<
CREATE TABLE AX_NOTIFY_USERS(    
    NOTIFICATION_ID INT(10), 
    FOREIGN KEY (NOTIFICATION_ID) REFERENCES AX_NOTIFY(NOTIFICATION_ID) ON DELETE CASCADE,
    USER_ID VARCHAR(255),
    STATUS VARCHAR(255),
    PROJECT_ID VARCHAR(255)
);
>>
<<
CREATE TABLE AX_LAYOUTDESIGN(
    DESIGN_ID INT(10) AUTO_INCREMENT PRIMARY KEY,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
);
>>
<<
CREATE TABLE AX_LAYOUTDESIGN_SAVED(
    DESIGN_ID INT(10) AUTO_INCREMENT PRIMARY KEY,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    PARENT_DESIGN_ID INT(10),
    RESPONSIBILITY TEXT,
    ORDER_BY INT(10)
);
>>
<<
alter table axtasks add notify_status VARCHAR(1) DEFAULT 'N';
>>
<<
update ax_homebuild_saved set target = replace(target,'Wrapper','');
>>
<<
update ax_widget set widget_type='kpi' where widget_type='table';
>>
<<
CREATE TABLE AX_PAGES(
    PAGE_ID INT(10) AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(255),
    TYPE VARCHAR(255),
    MODULE VARCHAR(255),
    TEMPLATE VARCHAR(255),
    PAGE_MENU VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_DEFAULT VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,    
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    ORDER_BY INT
);
>>
<<
CREATE TABLE AX_PAGE_SAVED(
    PAGE_ID INT(10) AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(255),
    TYPE VARCHAR(255),
    MODULE VARCHAR(255),
    TEMPLATE VARCHAR(255),
    PAGE_MENU VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_DEFAULT VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,    
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    PARENT_PAGE_ID INT(10),
    RESPONSIBILITY TEXT,
    ORDER_BY INT
);
>>
<<
CREATE TABLE AX_PAGE_RESPONSIBILITY(     
    PAGE_ID INT(10),
    FOREIGN KEY (PAGE_ID) REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,
    RESPONSIBILITY VARCHAR(255),
    RESPONSIBILITY_ID INT
);
>>
<<
CREATE TABLE AX_PAGE_SD_RESPONSIBILITY(  
    PAGE_ID INT(10),
    FOREIGN KEY (PAGE_ID) REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE,
    RESPONSIBILITY VARCHAR(255),
    RESPONSIBILITY_ID INT
);
>>
<<
CREATE TABLE AX_WIDGET_SAVED (
    WIDGET_ID INT(10) AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(255),
    WIDGET_TYPE VARCHAR(255),
    CONTENT TEXT,
    TARGET VARCHAR(255),
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_LOCK VARCHAR(1) DEFAULT 'N',
    ORDER_BY INT,
    is_publish VARCHAR(1) DEFAULT 'N',
    PARENT_WIDGET_ID INT,
    PAGE_ID INT,
    CREATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    FOREIGN KEY (PAGE_ID) REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE
);
>>
<<
CREATE TABLE AX_WIDGET_PUBLISHED (
    WIDGET_ID INT(10) AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(255),
    WIDGET_TYPE VARCHAR(255),
    CONTENT TEXT,
    TARGET VARCHAR(255),
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_LOCK VARCHAR(1) DEFAULT 'N',
    ORDER_BY INT,
    is_publish VARCHAR(1) DEFAULT 'N',
    PARENT_WIDGET_ID INT REFERENCES AX_WIDGET_SAVED(WIDGET_ID) ON DELETE CASCADE,
    PAGE_ID INT REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,
    CREATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    FOREIGN KEY (PARENT_WIDGET_ID) REFERENCES AX_WIDGET_SAVED(WIDGET_ID) ON DELETE CASCADE,
    FOREIGN KEY (PAGE_ID) REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE
);
>>
<<
CREATE TABLE AX_HP_USER_LEVEL_WIDGET(
    PAGE_ID INT(10),
    FOREIGN KEY (PAGE_ID) REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,
    WIDGETS  TEXT,
    USERNAME VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
>>
<<
CREATE TABLE AX_PAGE_TEMPLATES(
    TEMPLATE_ID INT(10) AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('basic','{"cc":1,"img":"basic.png","name":"basic","cf":[{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin');
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('modern','{"cc":1,"img":"modern.png","name":"modern","cf":[{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","br":"14px","tr":{"p":"top","h":"70px","html":"<span style=\\"float:left;font-size:45px;\\">#TITLE_ICON#</span><span style=\\"text-align: right;padding-top: 14px;position: relative;top: 16px;right: 5px;\\">#TITLE_NAME#</span>"}}]}','admin');
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('mainCard','{"cc":7,"img":"mainCard.png","name":"mainCard","cf":[{"ht":"225px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin');
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('topaz','{"cc":5,"img":"topaz.png","name":"topaz","cf":[{"ht":"225px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m8 l8","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m8 l8","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m4 l4","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin');
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('list','{"cc":1,"img":"list.png","name":"list","cf":[{"ht":"225px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin');
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('flow','{"cc":3,"img":"flow.png","name":"flow","repeatLastWidget":true,"cf":[{"ht":"500px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"500px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin');
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('checkered','{"cc":1,"img":"checkered.png","name":"checkered","cf":[{"ht":"300px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin');
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('flow main','{"cc":3,"img":"flow_main.png","name":"flow main","repeatLastWidget":true,"cf":[{"ht":"300px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"300px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"225px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin');
>>
<<
INSERT INTO AX_PAGE_TEMPLATES (TITLE,CONTENT,CREATED_BY) values ('random','{"cc":7,"img":"random.png","name":"random","cf":[{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"130px","isResp":true,"wd":"m3 l3","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"300px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"300px","isResp":true,"wd":"m6 l6","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}},{"ht":"200px","isResp":true,"wd":"m12 l12","ms":"classic","tr":{"p":"top","h":"35px","html":"#TITLE_ICON# #TITLE_NAME#"}}]}','admin');
>>
/*=============================================  
Database    : MY SQL
Name        : axp_pr_page_creation
Author      : Abhishek 
Create date : 27-09-2018  
Description : To create or delete a page  

Example     :
page creation:
    CALL axp_pr_page_creation('PageTest7','Test13','w3test1','Head16','before', 'page.aspx?transid=page')
    Result      :
      success - 'Page created'
          failure - 'Page not found'

 page deletion:
    CALL axp_pr_page_creation('PageTest7', null, null, null,'delete', null)
    Result      :
      success - 'Page deleted'
      failure - 'Page not found'
===============================================  */
<<
DROP PROCEDURE IF EXISTS axp_pr_page_creation;
>>

Delimiter //
<<
 CREATE PROCEDURE axp_pr_page_creation(
        p_pname VARCHAR(100),       -- New Page Name/Delete Page Name
        p_pcaption VARCHAR(100),        -- New Page Caption
        p_ppagetype VARCHAR(100),   -- New Page Type
        p_pparentname VARCHAR(100),     -- Parent Name
        p_paction VARCHAR(100),         -- Before/After inserting or delete
        p_props varchar(100)        -- props
          ) 
BEGIN
     DECLARE v_orderno int; 
     DECLARE v_level   int;
     
     IF p_paction <> 'delete' THEN
            SELECT parent,  ordno, levelno INTO p_pparentname, v_orderno, v_level FROM 
            (
             SELECT 
                     parent, 
                      CASE 
                             WHEN LOWER (p_paction) = 'before' THEN ordno 
                             ELSE ordno + 1 
                     END ordno,
                       levelno
             FROM axpages
             WHERE name = p_pparentname AND TYPE = 'p'
             
             UNION ALL
             
             SELECT A.NAME, 
                    MAX(B.ORDNO) + 1 AS ORDNO, 
                    A.LEVELNO + 1 AS LEVELNO
             FROM AXPAGES AS A
                     LEFT OUTER JOIN AXPAGES AS B ON A.NAME = B.PARENT
                     WHERE A.NAME = p_pparentname AND A.TYPE = 'h'
                     GROUP BY A.NAME, A.LEVELNO
            ) AS s;
          
          IF v_orderno is null THEN
             SELECT 'Page not found' as Result;         
          ELSE
                  -- date format 'dd/mm/yyyy hh24:mi:ss'
                                 
                UPDATE axpages SET ordno = ordno + 1 WHERE ordno >= v_orderno;
                
                INSERT INTO AXPAGESdisable (name, caption, blobno, visible, TYPE, parent, ordno, levelno, pagetype, props, createdon, updatedon, importedon) 
                 VALUES (p_pname, p_pcaption, 1, 'T', 'p', p_pparentname, v_orderno, v_level, p_ppagetype, p_props, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
                    
                  SELECT 'Page created' as Result;
            END IF;
                    
     ELSE
            SELECT  ordno INTO v_orderno FROM axpages WHERE name=p_pname AND TYPE='p';
            
            IF v_orderno is null THEN
             SELECT 'Page not found' as Result;
             -- END IF;
            ELSE
                DELETE FROM axpages WHERE name = p_pname;
            
                UPDATE axpages SET ordno = ordno - 1 WHERE ordno >= v_orderno;
            
                SELECT 'Page deleted' as Result;
             END IF;
        END IF;  
END;
>>
//

DELIMITER ;
<<
DROP PROCEDURE IF EXISTS Get_AxPages_Hierarchy;
>>
Delimiter //
<<
 CREATE PROCEDURE Get_AxPages_Hierarchy(
       language VARCHAR(50),responsibility text
        ) 
BEGIN
  declare v_Done tinyint unsigned default 0;
  declare v_Name text;
    declare v_Name2 varchar(100);
    declare v_PageType text;
    declare v_Visible text;
    declare v_Caption VARCHAR(200);
  declare leaveLoop int default false;
    DROP TEMPORARY TABLE IF EXISTS tmpAxPages;    
  CREATE TEMPORARY TABLE tmpAxPages(
    NAME varchar(100) NOT NULL,
    CAPTION varchar(200) DEFAULT NULL,
    PAGETYPE varchar(200) DEFAULT NULL,
    VISIBLE varchar(8000) DEFAULT NULL
  ) ENGINE=MEMORY; 
    INSERT INTO tmpAxPages(NAME, CAPTION, PAGETYPE, VISIBLE) 
    SELECT axp.NAME, CASE WHEN IFNULL(axl.compcaption,'') <> '' THEN axl.compcaption ELSE axp.CAPTION END, 
    axp.PAGETYPE, axp.VISIBLE FROM axpages axp
    LEFT OUTER JOIN axlanguage axl on axp.NAME = axl.compname AND axl.lngname =language 
    WHERE (axp.PARENT IS NULL OR IFNULL(axp.PARENT,'') = '');
  BEGIN
    DECLARE v_getpages CURSOR FOR
    Select axp.NAME, CASE WHEN IFNULL(axl.compcaption,'') <> '' THEN axl.compcaption ELSE axp.CAPTION END, axp.PAGETYPE, axp.VISIBLE from axpages axp 
        LEFT OUTER JOIN axlanguage axl on axp.NAME = axl.compname AND axl.lngname =language 
        WHERE (axp.PARENT IS NOT NULL AND IFNULL(axp.PARENT,'') <> '');
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET leaveLoop = TRUE;
    OPEN v_getpages;
    pagesLoop: LOOP
      FETCH v_getpages INTO v_Name, v_Caption, v_PageType, v_Visible; 
      IF leaveLoop THEN
        LEAVE pagesLoop;
      END IF;
            SET v_Name2 = v_Name;
            SET v_Done = 0;
      WHILE NOT v_Done DO
        IF EXISTS(select 1 from axpages a 
              where a.name = v_Name and (a.PARENT IS NOT NULL AND IFNULL(a.PARENT,'') <> '')) then
          BEGIN
            SELECT parent FROM axpages where name = v_Name INTO @parentname;
                                  
            SELECT visible FROM axpages where name = @parentname INTO @visible;
                        
                        SET v_Name = @parentname;
                        
                        SET v_Visible = CONCAT(v_Visible, ','); 
            SET v_Visible = CONCAT(v_Visible, @visible);                        
          END;
        ELSE
          SET v_Done = 1;
        END IF;
      END WHILE;
      INSERT INTO tmpAxPages(NAME, CAPTION, PAGETYPE, VISIBLE) 
            values(v_Name2, v_Caption, v_PageType, v_Visible);
    END LOOP;
    CLOSE v_getpages;
  END;
    SELECT a.* FROM 
    (SELECT CASE WHEN SUBSTRING(tmp.PAGETYPE,1,1) = 'n' THEN 'i' ELSE SUBSTRING(tmp.PAGETYPE,1,1) END as STYPE, 
    SUBSTRING(tmp.PAGETYPE,2) STYPENAME, tmp.CAPTION CAPTION    
    FROM tmpAxPages tmp
    JOIN axpages axp ON axp.name = tmp.NAME
    WHERE IFNULL(tmp.PAGETYPE,'') <> '' AND NOT INSTR(UPPER(tmp.VISIBLE),'F') > 0
    AND (('default' in (responsibility)) or 
    (('default' not in (responsibility) 
    AND axp.parent IN (SELECT SNAME FROM AXUSERACCESS WHERE RNAME IN (responsibility) and SUBSTRING(tmp.PAGETYPE,1,1) = 'p') ))) and SUBSTRING(tmp.PAGETYPE,1,1) is not null and LOWER(SUBSTRING(tmp.PAGETYPE,1,1)) != 'w') a    
  ORDER BY a.STYPE,a.CAPTION;
    DROP TEMPORARY TABLE IF EXISTS tmpAxPages;  
END
>>
//

DELIMITER ;

<<
delete from axpages where pagetype='web';
>>
--AxpertWebDev13-10.3.0.0
<<
ALTER TABLE axusers DROP COLUMN homepage;
>>
<<
ALTER table axusers add homepage varchar(255) DEFAULT null;
>>
<<
ALTER TABLE axusergroups DROP COLUMN homepage;
>>
<<
ALTER table axusergroups add homepage varchar(255) DEFAULT null;
>>
<<
ALTER table AX_PAGE_SAVED add IS_DEFAULT VARCHAR(1) DEFAULT 'N';
>>
<<
ALTER table AX_PAGES add IS_DEFAULT VARCHAR(1) DEFAULT 'N';
>>
--AxpertWebDev14-10.3.0.0
<<
INSERT INTO ax_page_saved (title,TEMPLATE,module,page_menu,IS_DEFAULT) values('Homepage',1,'PAGE','Head19','Y');
>>
<<
INSERT INTO ax_widget_saved (title,widget_type,content,target,order_by) select title,widget_type,content,target,order_by from ax_homebuild_master;
update ax_widget_saved set created_by ='admin', page_id=1;
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
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK,
 PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
Values(1000440000000, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Autocomplete Search Pattern', 'configtypeAutocomplete Search Pattern',
'Autocomplete Search Pattern', 'All', 'T', 'T', 'F', 'F')
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
INSERT INTO AXPAGESdisable
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, ORDNO, LEVELNO, UPDATEDON, CREATEDON, CREATEDBY, UPDATEDBY)
 Values
   ('Head20', 'System', '<root img="" visible="F" name="Head20" caption="System" createdon="21/12/2018 12:04:39" createdby="admin" importedon="" importedby="" updatedon="21/12/2018 12:09:58" updatedby="admin" type="h" ordno="28" levelno="0" parent="" pgtype="" cat="page" pagetype="Normal" serpath="" defpath="" fileext="" fileopt="" variables="" action=""></root>', 1, 
    'F', 'h', 28, 0, 
    '21/12/2018 12:09:58', '21/12/2018 12:04:39', 'admin', 'admin')
>>
<<
INSERT INTO AXPAGESdisable
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, CREATEDBY, UPDATEDBY)
 Values
   ('Head21', 'Settings', '<root img="" visible="T" name="Head21" caption="Settings" createdon="21/12/2018 12:05:50" createdby="admin" importedon="" importedby="" updatedon="21/12/2018 12:05:50" updatedby="admin"></root>', 1, 
    'T', 'h', 'Head20', 29, 1, 
    '21/12/2018 12:05:50', '21/12/2018 12:05:50', 'admin', 'admin')
>>
<<
INSERT INTO AXPAGESdisable
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageIviaxpscon', 'Axpstruct Configuration', '<root visible="T" type="p" defpage="T" name="PageIviaxpscon" caption="Axpstruct Configuration" createdon="04/12/2018 15:28:54" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="19/12/2018 15:17:54" updatedby="admin" img="" ordno="114" levelno="0" parent="" pgtype="iiaxpscon" updusername="" ptype="p" dbtype="oracle"><Container388 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="view__iaxpscon"/><view__iaxpscon cat="iview" name="iaxpscon" parent="Container388" align="Client"/></root>', 1, 
    'T', 'p', 'Head21', 30, 2, 
    '19/12/2018 15:17:54', '04/12/2018 15:28:54', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'iiaxpscon')
>>
<<
INSERT INTO AXPAGESdisable
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsastcp', 'Configuration Property', '<root visible="T" type="p" defpage="T" name="PageTsastcp" caption="Configuration Property" createdon="04/12/2018 13:19:32" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="18/12/2018 15:43:36" updatedby="admin" img="" ordno="112" levelno="0" parent="" updusername="" ptype="p" pgtype="tastcp" dbtype="oracle"><Container386 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__astcp"/><tstruct__astcp cat="tstruct" transid="astcp" parent="Container386" align="Client"/></root>', 1, 
    'T', 'p', 'Head21', 31, 2, 
    '18/12/2018 15:43:36', '04/12/2018 13:19:32', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'tastcp')
>>
<<
INSERT INTO AXPAGESdisable
   (NAME, CAPTION, PROPS, BLOBNO, VISIBLE, TYPE, PARENT, ORDNO, LEVELNO, UPDATEDON, CREATEDON, IMPORTEDON, CREATEDBY, UPDATEDBY, IMPORTEDBY, PAGETYPE)
 Values
   ('PageTsaxstc', 'Advance Settings', '<root visible="T" type="p" defpage="T" name="PageTsaxstc" caption="Advance Settings" createdon="04/12/2018 13:36:37" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="18/12/2018 18:36:55" updatedby="admin" img="" ordno="113" levelno="0" parent="" updusername="" ptype="p" pgtype="taxstc" dbtype="oracle"><Container387 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__axstc"/><tstruct__axstc cat="tstruct" transid="axstc" parent="Container387" align="Client"/></root>', 1, 
    'T', 'p', 'Head21', 32, 2, 
    '18/12/2018 18:36:55', '04/12/2018 13:36:37', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'taxstc')
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

<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK,CFIELDS, ALLTSTRUCTS, ALLIVIEWS,ALLUSERROLES)
 Values
   (1000330000013, 'F', 0, 'admin',CURDATE(), 'admin', CURDATE(), 1, 1, 'ExportVerticalAlign', 'ExportVerticalAlign', 'configtypeExportVerticalAlign', 
   'All', 'F', 'F', 'F', 'T', 'T','T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000010, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Excel Export', 'Excel Export', 'configtypeExcel Export', 'All', 'F', 'F', 'F', 'T', 'T','T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000007, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Trim IView Data', 'Trim IView Data', 'configtypeTrim IView Data', 'All', 'F', 'F', 'F', 'T', 'T','T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000005, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'WebService Timeout', 'WebService Timeout', 'configtypeWebService Timeout', 'All', 'F', 'F', 'F', 'T', 'T','T' )
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000002, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'ApplicationCompressedMode', 'General', 'configtypeApplicationCompressedMode', 'All', 'F', 'F', 'F', 'F',   'T','T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000000, 'F', 0, 'admin',CURDATE(), 'admin',CURDATE(), 1, 1, 'ApplicationTemplate', 'General', 'configtypeApplicationTemplate', 'All', 'F', 'F', 'F', 'F', 'T','T')
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
insert into axctx1(axcontext,atype) values ('Multi Select','Property')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, 
   CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1008440000004, 'F', 0, 'admin', 
    CURDATE(), 'admin', CURDATE(), 1, 
    1, 'Multi Select Field', 
    'Multi Select', 'configtypeMulti Select Field', 'Tstruct', 'F', 'F', 'T', 'F', 'T','T')
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
   (1072550000003, 'F', 0, 'admin', 
   CURDATE(), 'admin', CURDATE(), 1, 
    1, 'Resolve Attachment Path', 
    'Resolve Attachment Path', 'configtypeResolve Attachment Path', 'Iview', 'F', 'F', 'F', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS)
 Values
   (1072550000000, 'F', 0, 'admin', 
    CURDATE(), 'admin', CURDATE(), 1, 
    1, 'Global Parameter Form', 
    'General', 'configtypeGlobal Parameter Form', 'Tstruct', 'F', 'F', 'T', 'F', 'T', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS)
 Values
   (1072550000006, 'F', 0, 'admin', 
    CURDATE(), 'admin', CURDATE(), 1, 
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235440000043,'F',0,NULL,'superadmin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Custom JavaScript','Custom JavaScript','configtypeCustom JavaScript','','All','F','F','T','T','F','F','Reports:
Use this property to attach custom javascript to Reports/forms. Set this property value to "true" for a selected report. If this property is set to true, the custom javascript file for Reposts should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.js. In case this property is set to true for all reports instead of a selected report, the file name should be custom.js

Tstructs:
Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235660000010,'F',0,NULL,'superadmin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Custom CSS','Custom CSS','configtypeCustom CSS','','All','F','F','T','T','F','F','Reports:
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000009,'F',0,NULL,'admin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Grid Scrollbar','Grid Scrollbar','configtypeGrid Scrollbar',NULL,'Tstruct','F','F','T','F','F','F','If key is set to true,then if grid dc is there for the tstruct,then horizontal scroll bar will be fixed at the bottom of the page.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000006,'F',0,NULL,'admin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Auto Save Draft','Auto Save Draft','configtypeAuto Save Draft',NULL,'Tstruct','F','F','T','F','F','F','If key is set to true and time in millisecs(for ex for 60 secs give 60000 . Note: default time will be 120 seconds/2 minutes if no time is set) then on loading tstruct,it will check if unsaved data is there, if unsaved data  exists it will throw a popup with yes /no buttons.If yes, it will load the unsaved data else it will load a new tstruct.If new tstruct is opened for which key exists,then only if any field is changed,it will push data in redis after the mentioned time  in developer options at regular intervals.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000003,'F',0,NULL,'admin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Show keyboard in Hybrid App','Show keyboard in Hybrid App','configtypeShow keyboard in Hybrid App',NULL,'Tstruct','F','F','T','F','F','F','An enhancement to make an intuitive UI in Axpert Hybrid App i.e., 
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
(1635440000037,'F',0,NULL,'admin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Enforced Strong Password Policy','General','configtypeEnforced Strong Password Policy',NULL,'Common','F','F','F','F','F','F','If key is set to true,Strong Password Policy will work.Details for Enforced Strong Password Policy: Password should be alphanumeric, contains one UpperCharacter, one LowerCharacter with atleast one special character.It will check the following condition if key set to true and if password entered is not matching the condition,then it will throw error.')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES 
(1635440000038,1635440000037,1,'true')
>>
<< 
INSERT INTO axctx1 (axcontext,atype) values ('Mobile Reports as Table','Property') 
>>
<< 
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984880000036,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Notification Time Interval','General','configtypeNotification Time Interval',NULL,'All','F','F','T','T','F','F','Notification feature can be enabled at Application level by adding Developer Option "Notification Time Interval" , with values in minutes for time intervals as 1, 2, 3 , 4 etc. Once this key is added, long running web services/backend scheduled jobs completion can be notified to the user with given time intervals, so that user would be able to do other operations during long running web services/backend jobs.') 
>>
<< 
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984440000004,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'User Manual','General','configtypeUser Manual',NULL,'All','F','F','T','T','F','F','User can able to access the files through web application which is saved in local folder through User Manual option (located in right sidebar menu)') 
>>
<<
 INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984220000001,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Mobile Reports as Table','Mobile Reports as Table','configtypeMobile Reports as Table',NULL,'All','F','F','T','T','F','F','Administrator can enable tabular view in mobile instead of cards view') 
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
create table Axp_TransCheck(sessionid char(50))
>>
<<
INSERT INTO axctx1 (axcontext,atype) values ('Iview Button Style','Property') 
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES 
(1226220000004,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Iview Button Style','Iview Button Style','configtypeIview Button Style','','Iview','F','F','F','T','F','F','New Iview buttons UI can be switched as Modern(Google like UI) / Classic(Classic Bootstrap like UI) . Product default Iview Button UI is  "Modern" Style.')
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
VALUES (1251990000026,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Show Image Widget Action Button','General','configtypeShow Image Widget Action Button',NULL,'Common','F','F','T','T','T','F','The SmartView''s columns template can be changed to achieve desired UI and Actions')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1251990000027,1251990000026,1,'true')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES (1251990000028,1251990000026,2,'false')
>> 
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1420440000004,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Show Application Menu on Login','General','configtypeShow Application Menu on Login',NULL,'All','F','F','T','T','F','F','Application menu can be shown/hidden by setting this Developer Option.')
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
ALTER TABLE ax_layoutdesign_saved ADD CONSTRAINT ax_layoutdesign_savedid PRIMARY KEY (design_id)
>>
<<
ALTER TABLE ax_layoutdesign_saved MODIFY COLUMN design_id INT auto_increment not null
>>
<<
ALTER TABLE ax_layoutdesign ADD CONSTRAINT ax_layoutdesign PRIMARY KEY (design_id)
>>
<<
ALTER TABLE ax_layoutdesign MODIFY COLUMN design_id INT auto_increment not null
>>
<<
Drop view if exists vw_cards_calendar_data;
>>
<<
create or replace
view vw_cards_calendar_data as
select
    distinct a.uname as uname,
    a.AxCalendarid as axcalendarid,
    a.eventname as eventname,
    a.sendername as sendername,
    a.messagetext as messagetext,
    a.eventtype as eventtype,
    a.startdate as startdate,
    coalesce(a.axptm_starttime,
    '00:00') as axptm_starttime,
    a.enddate as enddate,
    (case
        when (coalesce(a.axptm_endtime,
        '00:00') = '00:00') then '23:59'
        else a.axptm_endtime end) as axptm_endtime,
    a.location as location,
    a.status as status
from
    axcalendar a
where
    ((a.Cancel = 'F')
    and (a.parenteventid > 0))
union all
select
    distinct a.sendername as uname,
    a.AxCalendarid as axcalendarid,
    a.eventname as eventname,
    a.sendername as sendername,
    a.messagetext as messagetext,
    a.eventtype as eventtype,
    a.startdate as startdate,
    coalesce(a.axptm_starttime,
    '00:00') as axptm_starttime,
    (case
        when isnull(a.recurring) then a.enddate
        else a.startdate end) as enddate,
    (case
        when (coalesce(a.axptm_endtime,
        '00:00') = '00:00') then '23:59'
        else a.axptm_endtime end) as axptm_endtime,
    a.location as location,
    a.status as status
from
axcalendar a
where
    ((a.Cancel = 'F')
    and (a.parenteventid = 0));
>>
<<
INSERT INTO axpdef_axpertprops
(axpdef_axpertpropsid, `Cancel`, `Sourceid`, `MapName`, `UserName`, `Modifiedon`, `CreatedBy`, `CreatedOn`, `Wkid`, `App_level`, `App_desc`, `App_slevel`, `CancelRemarks`, `WFRoles`, smtphost, smtpport, smtpuser, smtppwd, axpsiteno, amtinmillions, currseperator, lastlogin, autogen, customfrom, customto, loginattempt, pwdexp, pwdchange, pwdminchar, pwdreuse, pwdalphanum, pwdencrypt)
VALUES(1, 'F', 0, NULL, 'admin', '2022-01-14 11:10:21', 'admin', '2022-01-14 11:10:21', NULL, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, 'F', 'F', 'T', 'F', NULL, NULL, 0, 0, 0, 0, 0, 'F', 'F');
>>