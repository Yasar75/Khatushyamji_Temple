<<
alter table axpstructconfig add purpose varchar(1000)
>>
<<
ALTER TABLE AXUSERS ADD axusersid numeric(15)
>>
<<
ALTER TABLE AXUSERS ADD cancelremarks  VARCHAR(300) 
>>
<<
alter table ax_widget add is_public varchar(1) DEFAULT 'N'
>>
<<
ALTER TABLE AXUSERS ADD cancel  VARCHAR(10)
>>
<<
ALTER TABLE AXUSERS ADD sourceid numeric(15)
>>
<<
alter table axusers ALTER COLUMN pwd varchar(20)
>>
<<
DECLARE @SQL VARCHAR(4000)
SET @SQL = 'ALTER TABLE axusers DROP CONSTRAINT |ConstraintName| '
SET @SQL = REPLACE(@SQL, '|ConstraintName|', ( SELECT name FROM sysobjects WHERE xtype = 'PK' AND 
parent_obj = OBJECT_ID('axusers')))
EXEC (@SQL)
>>
<<
ALTER TABLE axusers ADD constraint u1_axusers UNIQUE (pusername)
>>
<<
ALTER TABLE axusergroups ADD axusergroupsid NUMERIC(15)
>>
<<
ALTER TABLE AXUSERGROUPS ADD cancel  VARCHAR(10)
>>
<<
ALTER TABLE AXUSERGROUPS ADD sourceid  numeric(15)
>>
<<
ALTER TABLE AXUSERGROUPS ADD cancelremarks  VARCHAR(300)
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
update  axuserlevelgroups set axusersid=1,AXUSERLEVELGROUPSID=12345555  where username='admin' 
>>
<<
update axusers set axusersid=1,pusername=username,ppassword=password where username='admin'
>>
<<
update  axuserlevelgroups set axusername='admin',axusergroup='default'  where AXUSERLEVELGROUPSID=12345555
>>
<<
CREATE TRIGGER t1_axusers
   ON  axusers
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @usr nvarchar(50), @pwd nvarchar(50)
	
	set @usr=(select pusername from inserted)
	set @pwd=(select ppassword from inserted)
	
	IF EXISTS(SELECT * FROM INSERTED)  AND NOT EXISTS(SELECT * FROM DELETED)
		update axusers set username=@usr, password=@pwd where pusername=@usr
	ELSE
		update axusers set username=@usr where pusername=@usr
    
END
>>
<<
CREATE TRIGGER t1_AXUSERLEVELGROUPS
   ON  axuserlevelgroups
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @usr nvarchar(50), @ugp nvarchar(50),@axid numeric(15)
	set @usr=(select axusername from inserted)
	set @ugp=(select axusergroup from inserted)
	set @axid=(select AXUSERLEVELGROUPSid from inserted)
update AXUSERLEVELGROUPS set username=@usr,usergroup = @ugp  where AXUSERLEVELGROUPSid = @axid
    
END
>>
<<
DROP TABLE [AXP_MAILJOBS]
>>
<<
CREATE TABLE [AXP_MAILJOBS](
	[MAILTO] [varchar](1000) NULL,
	[MAILCC] [varchar](1000) NULL,
	[SUBJECT] [varchar](1000) NULL,
	[BODY] [varchar](max) NULL,
	[RECIPIENTCATEGORY] [varchar](500) NULL,
	[ENQUIRYNO] [varchar](30) NULL,
	[ATTACHMENTS] [varchar](1000) NULL,
	[IVIEWNAME] [varchar](10) NULL,
	[IVIEWPARAMS] [varchar](500) NULL,
	[TRANSID] [varchar](10) NULL,
	[RECORDID] [numeric](16, 0) NULL,
	[STATUS] [numeric](2, 0) NULL,
	[ERRORMESSAGE] [varchar](500) NULL,
	[SENTON] [date] NULL,
	[JOBID] [smallint] IDENTITY(1,1) NOT NULL,
	[jobdate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
>>
<<
drop table axsms
>>
<<
CREATE TABLE [AXSMS](
	[RECORDID] [smallint] IDENTITY(1,1) NOT NULL,
	[MOBILENO] [varchar](10) NULL,
	[MSG] [varchar](250) NULL,
	[STATUS] [numeric](1, 0) NULL,
	[SENTON] [date] NULL,
	[REMARKS] [varchar](1000) NULL,
	[CREATEDON] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[RECORDID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
>>
<<
CREATE TABLE USAGEDTL
(
  EXECUTEDDATE  DATE,
  CODE           VARCHAR(20),
  TITLE          VARCHAR(50),
  CNT           NUMERIC(18)
)
>>
<<
CREATE TABLE AXPEXCEPTION
(
  EXP_DATE       DATE,
  STRUCTNAME      VARCHAR(16),
  SERVICENAME     VARCHAR(50),
  SERVICERESULT   VARCHAR(500),
  [COUNT]          NUMERIC
)
>>
<<
CREATE TABLE ut_timetaken
(
   executed_date   DATE,
   object_type      VARCHAR (10),
   service_name     VARCHAR (100),
   [object_name]      VARCHAR (100),
   tot_count       NUMERIC (10),
   count_8s        NUMERIC (10),
   count_30s       NUMERIC (10),
   count_90s       NUMERIC (10),
   min_time        NUMERIC (10, 2),
   max_time        NUMERIC (10, 2),
   avg_time        NUMERIC (10, 2)
)
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
         convert (date,a.senton,101) senton,
   convert (date,a.senton,101) outdate,
          a.transid,
          b.caption tstructname,
          CASE WHEN senton IS NULL THEN 'Pending' ELSE 'Sent' END outstatus
     FROM outbound a, tstructs b
    WHERE a.transid = b.name
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
          convert (date,a.recdon,101) recdon,
          convert (date,recdon,101) indate,
          transid,
          caption tstructname,
          instatus
     FROM inbound a, tstructs b
    WHERE a.transid = b.name
>>
<<
CREATE PROCEDURE pro_axplogstatextract (@fdate DATE)
AS
BEGIN
   ------ usage details
   delete from usagedtl  where convert(date,executeddate)=@fdate;
   INSERT INTO usagedtl (executeddate,
                         code,
                         title,
                         cnt)
        SELECT convert(date,calledon) cdate,
               'NOT' CODE,
               'Total No. of Transactions' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE convert(date,calledon) = @fdate
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'NOL' CODE,
               'Total No. of Logins' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE convert(date,calledon) = @fdate AND servicename = 'Login'
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'NOU' CODE,
               'Total No. of Users' title,
               COUNT (DISTINCT username) cnt
          FROM axpertlog
         WHERE convert(date,calledon) = @fdate AND servicename = 'Login'
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'NOD' CODE,
               'Total No. of Deadlock Execptions' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE convert(date,calledon) = @fdate
               AND serviceresult LIKE 'trans%dead%'
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'MTJ' CODE,
               'More time taken Saves (> 8 Sec)' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE     convert(date,calledon) = @fdate
               AND servicename = 'saving data'
               AND serviceresult = 'success'
               AND recordid = 0
               AND (timetaken / 1000) > 8
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'MTL' CODE,
               'More time taken Loads (> 8 Sec)' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE     convert(date,calledon) = @fdate
               AND servicename = 'load data'
               AND serviceresult = 'success'
               AND (timetaken / 1000) > 8
      GROUP BY convert(date,calledon)
      UNION ALL
      SELECT convert(date,calledon) cdate,
             'MTL' CODE,
             'More time taken reports (> 8 Sec)' title,
             COUNT (*) cnt
        FROM axpertlog
       WHERE     convert(date,calledon) = @fdate
             AND servicename = 'Get IView'
             AND serviceresult = 'success'
             AND (timetaken / 1000) > 8
GROUP BY convert(date,calledon);

   ----- exceptions
    delete from axpexception   where convert(date,exp_date)=@fdate;
   INSERT INTO axpexception (EXP_DATE,
                             STRUCTNAME,
                             SERVICENAME,
                             SERVICERESULT,
                             COUNT)
        SELECT convert(date,calledon),
               structname,
               servicename,
               serviceresult,
               COUNT (*)
          FROM axpertlog
         WHERE SERVICERESULT <> 'success' AND convert(date,calledon) = @fdate
      GROUP BY convert(date,calledon),
               structname,
               servicename,
               serviceresult;

   ----- time taken
    delete from ut_timetaken  where convert(date,executed_date)=@fdate;
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
        SELECT convert(date,getdate()) exec_date,
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
               AND convert(date,calledon) = @fdate
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
        SELECT convert(date,getdate()) exec_date,
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
               AND convert(date,calledon) = @fdate
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
        SELECT convert(date,getdate()) exec_date,
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
               AND convert(date,calledon) = @fdate
      GROUP BY b.caption;
END
>>
<<
CREATE FUNCTION fnSplit(
    @sInputList VARCHAR(8000) -- List of delimited items
       ) RETURNS @List TABLE (item VARCHAR(8000))

BEGIN
DECLARE @sItem VARCHAR(8000)
declare  @sDelimiter VARCHAR(8000) = '^'  -- delimiter that separates items
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
 SELECT
  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
 
 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END
>>
<<
CREATE PROCEDURE pro_emailformat(@ptemplate nvarchar(100) ,@pkeyword nvarchar(3000),@ptype nvarchar(100),@psendto nvarchar(1000),@psendcc nvarchar(1000) ) as
	DECLARE 
	@v_subject nvarchar(3500),
	@v_body nvarchar(3500),
	@v_sms  nvarchar(3500),
	@v_count numeric(5),
	@v_keyword nvarchar(350),
	@v_keyvalue nvarchar(1000),
	@vkeyword nvarchar(1000)

	DECLARE cursor_kword CURSOR FOR select item from fnssplit(@pkeyword)

begin

	set @v_count=(select count(*)  from  sendmsg
	 where lower(template) = lower( @ptemplate))
	 
	if @v_count=1 
	begin
		select  @v_subject = MSGSUBJECT, @v_body = MSGCONTENT, @v_sms = SMSMSG  
		from sendmsg
		where lower(template) = lower(@ptemplate)
 
		open cursor_kword 
		FETCH NEXT FROM cursor_kword into @vkeyword
		WHILE @@FETCH_STATUS = 0   
		BEGIN  

			set @v_keyword = SUBSTRing(@vkeyword, 1 ,CHARINDEX('=',@vkeyword,1)-1);
			set @v_keyvalue =  SUBSTRing( @vkeyword,CHARINDEX('=',@vkeyword,1)+1,len(@vkeyword));
			set @v_subject = replace(@v_subject,@v_keyword,@v_keyvalue);

			set @v_body = replace(@v_body,@v_keyword,@v_keyvalue);

			set @v_sms = replace(@v_sms,@v_keyword,@v_keyvalue);
		end

		CLOSE cursor_kword 
		DEALLOCATE cursor_kword 
	end

	if @ptype='S' 

		insert into axsms(createdon,mobileno,msg,status) values (convert(date,getdate()),@psendto,@v_sms,0)
	

	if @ptype='E' 

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
			 VALUES (@psendto,@psendcc,@v_subject,@v_body,null,null,null,0,null,null,convert(date,getdate()));

End
>>
<<
CREATE TRIGGER trg_AXPSCRIPTRUNNER
   ON  AXPSCRIPTRUNNER
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	declare @v_trgdis nvarchar(500),
			@v_trgena nvarchar(500),
			@vpintrg  nvarchar(500),
			@vpintext nvarchar(1000)
	
	set @vpintrg = (select ISNULL(trg_name,'NA')  from inserted)
	set @vpintext  = (select SCRIPT_TEXT  from inserted)
	set @v_trgdis = 'ALTER TRIGGER '+ @vpintrg +'  DISABLE'
	set @v_trgena = 'ALTER TRIGGER '+ @vpintrg +'  ENABLE'
	
	if @vpintrg = 'NA' 
		EXECUTE sp_executesql @vpintext
		
	if @vpintrg <> 'NA'
	begin
		EXECUTE sp_executesql @v_trgdis
		EXECUTE sp_executesql @vpintext
		EXECUTE sp_executesql @v_trgena
	end
    
END
>>
<<
CREATE TRIGGER TRG_UPDATDSIGN 
   ON  AXDSIGNCONFIG 
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @usr nvarchar(50), @prole nvarchar(50)
	
	set @usr=(select pusername from inserted)
	set @prole=(select prolename from inserted)
	
	update AXDSIGNCONFIG  set username=@usr, rolename=@prole where pusername=@usr
    
END
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
        'iidsco')
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
INSERT INTO axpages (name,caption,props,blobno,img,visible,[type],parent,ordno,levelno,updatedon,CreatedOn,ImportedOn,CreatedBy,UpdatedBy,ImportedBy,readonly,updusername,category,pagetype,INTVIEW,webenable,shortcut) VALUES 
('PageTstemps','Custom UI','<root visible="T" type="p" defpage="T" name="PageTstemps" caption="Custom UI" createdon="04/12/2018 13:36:37" createdby="admin" importedon="04/12/2018 13:36:37" importedby="admin" updatedon="04/12/2018 13:36:37" updatedby="admin" img="" ordno="13" levelno="2" parent="Head14" updusername="" ptype="p" pgtype="ttemps" dbtype="postgre"><Container16 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__temps"/><tstruct__temps cat="tstruct" transid="temps" parent="Container16" align="Client"/></root>
',1,'','T','p','Head14',13,2,'2020-08-24','2020-08-24','08-24-2020 12:20:20','admin','admin','admin',NULL,NULL,NULL,'ttemps',NULL,NULL,NULL)
>>

<<
update axpages set UPDATEDON = CONVERT(date,getdate()),CREATEDON= CONVERT(date,getdate())
>>
<<
CREATE PROCEDURE SP_RAPIDDEFINITION(@ITid varchar(100)) 
AS 

BEGIN

	
SELECT a.context, a.fieldname, c.expression, a.fldsql as fldsql, ISNULL(b.paramname,'') as paramname 
	FROM axp_formload a 
	LEFT JOIN axp_params b on b.tstruct = @ITid and a.fieldname = b.childfield and 
a.context = b.context and b.active = 'T' 
INNER JOIN axpflds c on c.tstruct = @ITid and a.fieldname=c.fname 
WHERE a.tstruct = @ITid and a.active='T' and a.context = 'new';    
   
	
SELECT a.parentfield, a.childfield, a.dependenttype, ISNULL(b.paramname,'') as paramname,    
	ISNULL(b.allrows,'F') as allrows, ISNULL(b.dirparam,'F') as dirparam, c.frmno, c.ordno FROM axp_dependent a 
	LEFT JOIN axp_params b on b.tstruct = @ITid and a.parentfield = b.childfield and b.context = 'dep' and b.active = 'T'
	JOIN axpflds c on c.tstruct = @ITid and a.childfield=c.fname 
WHERE a.tstruct = @ITid
	
UNION
	
SELECT distinct par.paramname parentfield, dep1.childfield, 'g' as dependenttype, ISNULL(b.paramname,'') as paramname, 'F' as allrows, 'F' as dirparam, flds.frmno,flds.ordno  
	FROM axp_dependent dep1
	JOIN (select paramname, childfield from axp_params par where par.tstruct = @ITid and par.context = 'fg') par on par.childfield = dep1.parentfield
	JOIN axp_dependent dep2 on dep2.tstruct = @ITid  and dep2.parentfield = par.paramname and dep2.dependenttype = 'g'
	JOIN axp_params b on b.tstruct = @ITid and par.childfield = b.childfield and b.context = 'fg' and b.active = 'T'
 JOIN axpflds flds on flds.tstruct = @ITid and dep1.childfield = flds.fname
 
WHERE dep1.tstruct = @ITid
	ORDER BY frmno asc, ordno asc;

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
IF EXISTS (SELECT * FROM sysobjects WHERE name='GetIview') 
BEGIN
	DROP PROCEDURE GetIview;
END;
>>
<<
CREATE PROCEDURE GetIview(@ISql VARCHAR(max), @INoofRec INT, @IpageNo INT, @ICountFlag INT) 
AS 
BEGIN 
  DECLARE @pos1 INT, @pos2 INT, @pos3 INT; 
  DECLARE @Qry VARCHAR(max); 
  DECLARE @orderby VARCHAR(1000); 

  SET @pos1 = 0; 
  SET @pos2 = 0; 
  SET @Qry = @ISql; 
  SET @orderby = ''; 

  SELECT @pos1 = Charindex('from', @Qry, 1); 

  SELECT @pos2 = Charindex('order by', Substring(@Qry, @pos1 + 1, Len(@Qry)) 
				 , 
				 1); 

  IF @pos2 > 0 
	BEGIN 
		SET @orderby = Rtrim(Ltrim(Substring(@Qry, @pos1 + @pos2 + 8, Len(@Qry)))) ; 
		SET @Qry = Substring(@Qry, 1, @pos1 + @pos2 - 1); 
	END; 

  SET @orderby = Replace(@orderby, ',', ', '); 
  SET @orderby = Replace(@orderby, '  ', ' '); 
  SET @orderby = ' @' + Replace(@orderby, ', ', '@'); 

  WHILE Charindex('.', @orderby, 1) > 0 
	BEGIN 
		SET @pos1= Charindex('.', @orderby, 1); 
		SET @pos2= Charindex('@', @orderby, 2); 
		SET @pos3= Charindex('@', @orderby, @pos2 + 1); 

		IF @pos1 > 0 
		   AND @pos3 < @pos1 
		   AND @pos2 < @pos1 
		  BEGIN 
			  SET @orderby = Substring(@orderby, 1, @pos2) + 'a.' 
							 + Substring(@orderby, @pos2+1, Len(@orderby)); 
			  SET @pos1= Charindex('.', @orderby, 1); 
			  SET @pos2= Charindex('@', @orderby, 2); 
		  END; 

		SET @orderby= Replace(@orderby, Substring(@orderby, @pos2, @pos1 - @pos2 + 1), ','); 
		SET @orderby=Ltrim(@orderby); 
	END; 

  SET @orderby = Replace(Substring(@orderby, 2, Len(@orderby)), '@', ','); 

  WHILE Charindex(',,', @orderby, 1) > 0 
	BEGIN 
		SET @orderby = Replace(@orderby, ',,', ','); 
	END; 

  IF Charindex(',', @orderby, 1) = 1 
	BEGIN 
		SET @orderby = Substring(@orderby, 2, Len(@orderby)); 
	END; 

  IF ( @INoofRec > 0 AND @IpageNo > 0 ) 
	BEGIN 
		SELECT @ISql = 'select * from (select row_number() over ( ORDER BY ' 
					   + @orderby 
					   + ' ) as rowno, '''' as axrowtype, a.* from ( ' 
					   + @Qry + ') as a ) xy where rowno between ' 
					   + Cast(((@INoofRec * (@IpageNo-1))+1) AS VARCHAR(50)) 
					   + ' and ' 
					   + Cast((@INoofRec * (@IpageNo)) AS VARCHAR(50) ) 
					   + ' order by rowno '; 
	END 
  ELSE 
	SELECT @ISql = 'select row_number() over ( ORDER BY ' 
				   + @orderby 
				   + ' ) as rowno, '''' as axrowtype, a.* from ( ' 
				   + @Qry + ') as a ORDER by ' + @orderby; 

  EXECUTE (@ISql); 

  IF ( @ICountFlag = 1 
	   AND @IpageNo <= 1 ) 
	BEGIN 
		SET @Qry = 'select count(*) as IviewCount from (' 
				   + @Qry + ')a'; 

		EXECUTE (@Qry); 
	END; 
END; 
>>
<<
CREATE TABLE AX_NOTIFY(
    NOTIFICATION_ID INT IDENTITY(1,1) PRIMARY KEY,
    TITLE VARCHAR(255),
    MESSAGE text,
    ACTIONS text,
    FROMUSER VARCHAR(255),
    BROADCAST VARCHAR(1) DEFAULT 'N',
    STATUS VARCHAR(255),
    CREATED_BY VARCHAR(255),
    CREATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    PURGE_ON_FIRST_ACTION VARCHAR(1) DEFAULT 'N',
    NOTIFICATION_SENT_DATETIME datetime DEFAULT CURRENT_TIMESTAMP,
    RECORDID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
)
>>
<<
CREATE TABLE AX_MOBILE_RESPONSE(
    NOTIFICATION_ID INT REFERENCES AX_NOTIFY(NOTIFICATION_ID) ON DELETE CASCADE,
    USER_ID VARCHAR(255),
    RESPONSE TEXT, 
    PROJECT_ID VARCHAR(255)
)
>>
<<
CREATE TABLE AX_NOTIFY_WORKFLOW(
    NOTIFICATION_ID INT,
    RECORDID VARCHAR(255),
    APP_LEVEL VARCHAR(2),
    APP_DESC VARCHAR(2),
    CREATED_ON datetime  DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
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
    NOTIFICATION_ID INT REFERENCES AX_NOTIFY(NOTIFICATION_ID) ON DELETE CASCADE,
    USER_ID VARCHAR(255),
    STATUS VARCHAR(255),
    PROJECT_ID VARCHAR(255)
)
>>
<<
CREATE TABLE AX_LAYOUTDESIGN(
    DESIGN_ID INT IDENTITY(1,1) PRIMARY KEY,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT text,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON datetime DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
)
>>
<<
CREATE TABLE AX_LAYOUTDESIGN_SAVED(
    DESIGN_ID INT IDENTITY(1,1) PRIMARY KEY,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT text,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    PARENT_DESIGN_ID INT,
    RESPONSIBILITY text,
    ORDER_BY INT
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
<<
CREATE TABLE AX_PAGES(
    PAGE_ID INT IDENTITY(1,1) PRIMARY KEY,
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
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,  
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    ORDER_BY INT
)
>>
<<
CREATE TABLE AX_PAGE_SAVED(
    PAGE_ID INT IDENTITY(1,1) PRIMARY KEY,
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
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,  
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    PARENT_PAGE_ID INT,
    RESPONSIBILITY TEXT,
    ORDER_BY INT
)
>>
<<
CREATE TABLE AX_PAGE_RESPONSIBILITY(     
    PAGE_ID INT REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,
    RESPONSIBILITY VARCHAR(255),
    RESPONSIBILITY_ID INT
)
>>
<<
CREATE TABLE AX_PAGE_SD_RESPONSIBILITY(  
    PAGE_ID INT REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE,
    RESPONSIBILITY VARCHAR(255),
    RESPONSIBILITY_ID INT
)
>>
<<
CREATE TABLE AX_WIDGET_SAVED (
    WIDGET_ID INT IDENTITY(1,1) PRIMARY KEY,
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
    PAGE_ID INT REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE,
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
)
>>
<<
CREATE TABLE AX_WIDGET_PUBLISHED (
    WIDGET_ID INT IDENTITY(1,1) PRIMARY KEY,
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
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
)
>>
<<
CREATE TABLE AX_HP_USER_LEVEL_WIDGET(
    PAGE_ID INT REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,    
    WIDGETS  TEXT,
    USERNAME VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
)
>>
<<
CREATE TABLE AX_PAGE_TEMPLATES(
    TEMPLATE_ID INT IDENTITY(1,1) PRIMARY KEY,
    TITLE VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP
)
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

/* =============================================  
Name            : axp_pr_page_creation
Author      : Abhishek 
Create date : 27-09-2018  
Description : To create or delete a page  

Example     :
page creation:
    exec axp_pr_page_creation 'PageTest7','Test13','w3test1','Head16','before', 'page.aspx?transid=page'
    Result      :
        success - 'Page created'
        failure - 'Page not found'

 page deletion:
    exec axp_pr_page_creation 'PageTest5', null, null, null,'delete', null
    Result      :
            success - 'Page deleted'
            failure - 'Page not found'
===============================================  */
<<
DROP PROCEDURE [axp_pr_page_creation]
>>
<<
CREATE PROCEDURE [axp_pr_page_creation](
        @pname VARCHAR(100),            -- New Page Name/Delete Page Name
        @pcaption VARCHAR(100),     -- New Page Caption
        @ppagetype VARCHAR(100),    -- New Page Type
        @pparentname VARCHAR(100),  -- Parent Name
        @paction VARCHAR(100),      -- Before/After inserting or delete
        @props varchar(100)         -- props
          ) 
AS
BEGIN
        DECLARE @orderno as int 
        DECLARE @level   as int
        DECLARE @sysdate as VARCHAR(100) 
        
        IF @paction <> 'delete'
            BEGIN
                SELECT @pparentname=parent, @orderno= ordno, @level=levelno FROM 
                (
                SELECT 
                        parent, 
                         CASE 
                                WHEN LOWER (@paction) = 'before' THEN ordno 
                                ELSE ordno + 1 
                        END ordno,
                          levelno
                FROM axpages
                WHERE name = @pparentname AND TYPE = 'p'
                
                UNION ALL
                
                SELECT A.NAME, 
                       MAX(B.ORDNO) + 1 AS ORDNO, 
                       A.LEVELNO + 1 AS LEVELNO
                FROM AXPAGES AS A
                        LEFT OUTER JOIN AXPAGES AS B ON A.NAME = B.PARENT
                        WHERE A.NAME = @pparentname AND A.TYPE = 'h'
                        GROUP BY A.NAME, A.LEVELNO
                ) AS s
              
              IF @orderno is null
                 SELECT 'Page not found' as Result
                ELSE
                  BEGIN
                      -- date format 'dd/mm/yyyy hh24:mi:ss'
                    SET @sysdate = convert(varchar, getdate(), 103) +' '+ convert(VARCHAR(10), GETDATE(), 108) 
                                     
                    UPDATE axpages SET ordno = ordno + 1 WHERE ordno >= @orderno;
                    
                    INSERT INTO axpages (name, caption, blobno, visible, TYPE, parent, ordno, levelno, pagetype, props, createdon, updatedon, importedon) 
                     VALUES (@pname, @pcaption, 1, 'T', 'p', @pparentname, @orderno, @level, @ppagetype, @props, @sysdate, @sysdate, @sysdate);
                        
                      SELECT 'Page created' as Result
                  END        
            END
        ELSE
            BEGIN
                SELECT @orderno= ordno FROM axpages WHERE name=@pname AND TYPE='p';
                
                IF @orderno is null
                 SELECT 'Page not found' as Result
                ELSE
                 BEGIN
                    DELETE FROM axpages WHERE name = @pname;
                
                    UPDATE axpages SET ordno = ordno - 1 WHERE ordno >= @orderno;
                
                    SELECT 'Page deleted' as Result
                 END
            END  
END
>>
<<
CREATE PROCEDURE PR_BULK_PAGE_DELETE
AS
BEGIN
    DECLARE @I$NAME varchar(max)
    DECLARE DB_IMPLICIT_CURSOR_FOR_I CURSOR LOCAL FORWARD_ONLY FOR
    
    SELECT AXPAGES.NAME
        FROM AXPAGES
        WHERE AXPAGES.PAGETYPE = 'web' AND AXPAGES.BLOBNO = 1

    OPEN DB_IMPLICIT_CURSOR_FOR_I
    WHILE 1 = 1
        BEGIN
            FETCH DB_IMPLICIT_CURSOR_FOR_I
            INTO @I$NAME

            IF @@FETCH_STATUS = -1
            BREAK

            BEGIN
                BEGIN TRY
                    EXECUTE AXP_PR_PAGE_CREATION
                        @PNAME = @I$NAME,
                        @PCAPTION = NULL,
                        @PPAGETYPE = NULL,
                        @PPARENTNAME = NULL,
                        @PACTION = 'delete',
                        @PROPS = NULL
                END TRY
                BEGIN CATCH
                    BEGIN
                        DECLARE
                        @db_null_statement int
                    END
                END CATCH
            END
        END
    CLOSE DB_IMPLICIT_CURSOR_FOR_I
    DEALLOCATE DB_IMPLICIT_CURSOR_FOR_I
END
>>
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
 create unique index  ui_AXCTX1 on AXCTX1 (axcontext,atype)
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
    GETDATE(), 'admin',  GETDATE(), 1,
    1, 'Tstruct Grid edit option',
    'GridEdit', 'configtypeTstruct Grid edit option', 'Tstruct', 'F', 'F', 'T', 'F') 
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
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000003, 'F', 0, 'admin',GETDATE(), 'admin', GETDATE(), 1, 1, 'Load forms along with list', 'configtypeLoad forms along with list', 'Autosplit', 'Tstruct', 'F', 'F', 'T', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000006, 'F', 0, 'admin', GETDATE(), 'admin', GETDATE(), 1, 1, 'Load reports/lists along with form', 'configtypeLoad reports/lists along with form', 'Autosplit', 'Iview', 'F', 'F', 'F', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000009, 'F', 0, 'admin', GETDATE(), 'admin', GETDATE(), 1, 1, 'Disablesplit', 'configtypeDisablesplit', 'Disablesplit', 'All', 'F', 'F', 'T', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000012, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Open Window mode', 'configtypeOpen Window mode', 'Navigation', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000015, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Align Text', 'configtypeText', 'Text', 'All', 'T', 'T', 'F', 'F')
  >>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000018, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Main Page Reload', 'configtypeMain Page Reload', 'General', 'All', 'T', 'T', 'F', 'F')
  >>  
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000021, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Change Password', 'configtypeChange Password', 'General', 'All', 'T', 'T', 'F', 'F')
  >>  
  <<
  Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000024, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Landing Structure', 'configtypeLanding Structure', 'General', 'All', 'T', 'T', 'F', 'F')
  >>
  <<
  Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000027, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'FetchSize', 'configtypeFetchSize', 'FetchSize', 'All', 'T', 'T', 'F', 'F')
  >>
  <<
  Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000030, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Local Dataset', 'configtypeLocal Dataset', 'Lds', 'All', 'T', 'T', 'F', 'F')
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
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000003, 1742550000002, 1, 'Disable')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000004, 1742550000002, 2, 'Enable')
   >>
<< 
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000007, 1742550000005, 2, 'iview')
   >>
<<
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000006, 1742550000005, 1, 'tstruct')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000010, 1742550000008, 2, '30')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000028, 1742550000008, 20, '5000')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000027, 1742550000008, 19, '2000')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000026, 1742550000008, 18, '1000')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000009, 1742550000008, 1, '25')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000029, 1742550000008, 21, 'ALL')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000011, 1742550000008, 3, '35')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000012, 1742550000008, 4, '40')
   >>
<<
 insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000013, 1742550000008, 5, '45')
   >>
<<
 insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000014, 1742550000008, 6, '50')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000015, 1742550000008, 7, '55')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000016, 1742550000008, 8, '60')
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
insert  into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values
   (1903990000002, 1903990000000, 2, 'Left')
   >> 
   << 
Insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1790770000001, 1790770000000, 1, 'true')
   >>
<<
Insert into AXPSTRUCTCONFIGPROVAL    (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1790770000002, 1790770000000, 2, 'false')
   >>
<< 
Insert into axpstructconfigproval (AXPSTRUCTCONFIGPROVALID,AXPSTRUCTCONFIGPROPSID,AXPSTRUCTCONFIGPROVALROW,CONFIGVALUES) values (1040440000001,1040440000000,1,'Inline')
>>
<< 
Insert into axpstructconfigproval (AXPSTRUCTCONFIGPROVALID,AXPSTRUCTCONFIGPROPSID,AXPSTRUCTCONFIGPROVALROW,CONFIGVALUES) values (1040440000002,1040440000000,2,'Popup')
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
   ('PageTsaxstc', 'Advance Settings', '<root visible="T" type="p" defpage="T" name="PageTsaxstc" caption="Advance Settings" createdon="04/12/2018 13:36:37" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="18/12/2018 18:36:55" updatedby="admin" img="" ordno="113" levelno="0" parent="" updusername="" ptype="p" pgtype="taxstc" dbtype="oracle"><Container387 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__axstc"/><tstruct__axstc cat="tstruct" transid="axstc" parent="Container387" align="Client"/></root>', 1, 
    'T', 'p', 'Head21', 32, 2, 
    '18/12/2018 18:36:55', '04/12/2018 13:36:37', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'taxstc')
>>
<<
Insert into AXCTX1
   (AXCONTEXT, ATYPE)
 Values
   ('FormLoad', 'Property')
>>
<<
alter table AXPSTRUCTCONFIGPROPS add ALLUSERROLES char(100) 
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1104220000000, 'F', 0, 'admin', 
    GETDATE(), 'admin',GETDATE(), 1, 
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
ALTER TABLE AXUSERS ADD axusersid numeric(15)
>>
<<
ALTER TABLE AXUSERS ADD cancelremarks  VARCHAR(300) 
>>
<<
alter table ax_widget add is_public varchar(1) DEFAULT 'N'
>>
<<
ALTER TABLE AXUSERS ADD cancel  VARCHAR(10)
>>
<<
ALTER TABLE AXUSERS ADD sourceid numeric(15)
>>
<<
alter table axusers ALTER COLUMN pwd varchar(20)
>>
<<
DECLARE @SQL VARCHAR(4000)
SET @SQL = 'ALTER TABLE axusers DROP CONSTRAINT |ConstraintName| '
SET @SQL = REPLACE(@SQL, '|ConstraintName|', ( SELECT name FROM sysobjects WHERE xtype = 'PK' AND 
parent_obj = OBJECT_ID('axusers')))
EXEC (@SQL)
>>
<<
ALTER TABLE axusers ADD constraint u1_axusers UNIQUE (pusername)
>>
<<
ALTER TABLE axusergroups ADD axusergroupsid NUMERIC(15)
>>
<<
ALTER TABLE AXUSERGROUPS ADD cancel  VARCHAR(10)
>>
<<
ALTER TABLE AXUSERGROUPS ADD sourceid  numeric(15)
>>
<<
ALTER TABLE AXUSERGROUPS ADD cancelremarks  VARCHAR(300)
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
update  axuserlevelgroups set axusersid=1,AXUSERLEVELGROUPSID=12345555  where username='admin' 
>>
<<
update axusers set axusersid=1,pusername=username,ppassword=password where username='admin'
>>
<<
update  axuserlevelgroups set axusername='admin',axusergroup='default'  where AXUSERLEVELGROUPSID=12345555
>>
<<
CREATE TRIGGER t1_axusers
   ON  axusers
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @usr nvarchar(50), @pwd nvarchar(50)
	
	set @usr=(select pusername from inserted)
	set @pwd=(select ppassword from inserted)
	
	IF EXISTS(SELECT * FROM INSERTED)  AND NOT EXISTS(SELECT * FROM DELETED)
		update axusers set username=@usr, password=@pwd where pusername=@usr
	ELSE
		update axusers set username=@usr where pusername=@usr
    
END
>>
<<
CREATE TRIGGER t1_AXUSERLEVELGROUPS
   ON  axuserlevelgroups
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @usr nvarchar(50), @ugp nvarchar(50),@axid numeric(15)
	set @usr=(select axusername from inserted)
	set @ugp=(select axusergroup from inserted)
	set @axid=(select AXUSERLEVELGROUPSid from inserted)
update AXUSERLEVELGROUPS set username=@usr,usergroup = @ugp  where AXUSERLEVELGROUPSid = @axid
    
END
>>
<<
DROP TABLE [AXP_MAILJOBS]
>>
<<
CREATE TABLE [AXP_MAILJOBS](
	[MAILTO] [varchar](1000) NULL,
	[MAILCC] [varchar](1000) NULL,
	[SUBJECT] [varchar](1000) NULL,
	[BODY] [varchar](max) NULL,
	[RECIPIENTCATEGORY] [varchar](500) NULL,
	[ENQUIRYNO] [varchar](30) NULL,
	[ATTACHMENTS] [varchar](1000) NULL,
	[IVIEWNAME] [varchar](10) NULL,
	[IVIEWPARAMS] [varchar](500) NULL,
	[TRANSID] [varchar](10) NULL,
	[RECORDID] [numeric](16, 0) NULL,
	[STATUS] [numeric](2, 0) NULL,
	[ERRORMESSAGE] [varchar](500) NULL,
	[SENTON] [date] NULL,
	[JOBID] [smallint] IDENTITY(1,1) NOT NULL,
	[jobdate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
>>
<<
drop table axsms
>>
<<
CREATE TABLE [AXSMS](
	[RECORDID] [smallint] IDENTITY(1,1) NOT NULL,
	[MOBILENO] [varchar](10) NULL,
	[MSG] [varchar](250) NULL,
	[STATUS] [numeric](1, 0) NULL,
	[SENTON] [date] NULL,
	[REMARKS] [varchar](1000) NULL,
	[CREATEDON] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[RECORDID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
>>
<<
CREATE TABLE USAGEDTL
(
  EXECUTEDDATE  DATE,
  CODE           VARCHAR(20),
  TITLE          VARCHAR(50),
  CNT           NUMERIC(18)
)
>>
<<
CREATE TABLE AXPEXCEPTION
(
  EXP_DATE       DATE,
  STRUCTNAME      VARCHAR(16),
  SERVICENAME     VARCHAR(50),
  SERVICERESULT   VARCHAR(500),
  [COUNT]          NUMERIC
)
>>
<<
CREATE TABLE ut_timetaken
(
   executed_date   DATE,
   object_type      VARCHAR (10),
   service_name     VARCHAR (100),
   [object_name]      VARCHAR (100),
   tot_count       NUMERIC (10),
   count_8s        NUMERIC (10),
   count_30s       NUMERIC (10),
   count_90s       NUMERIC (10),
   min_time        NUMERIC (10, 2),
   max_time        NUMERIC (10, 2),
   avg_time        NUMERIC (10, 2)
)
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
         convert (date,a.senton,101) senton,
   convert (date,a.senton,101) outdate,
          a.transid,
          b.caption tstructname,
          CASE WHEN senton IS NULL THEN 'Pending' ELSE 'Sent' END outstatus
     FROM outbound a, tstructs b
    WHERE a.transid = b.name
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
          convert (date,a.recdon,101) recdon,
          convert (date,recdon,101) indate,
          transid,
          caption tstructname,
          instatus
     FROM inbound a, tstructs b
    WHERE a.transid = b.name
>>
<<
CREATE PROCEDURE pro_axplogstatextract (@fdate DATE)
AS
BEGIN
   ------ usage details
   delete from usagedtl  where convert(date,executeddate)=@fdate;
   INSERT INTO usagedtl (executeddate,
                         code,
                         title,
                         cnt)
        SELECT convert(date,calledon) cdate,
               'NOT' CODE,
               'Total No. of Transactions' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE convert(date,calledon) = @fdate
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'NOL' CODE,
               'Total No. of Logins' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE convert(date,calledon) = @fdate AND servicename = 'Login'
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'NOU' CODE,
               'Total No. of Users' title,
               COUNT (DISTINCT username) cnt
          FROM axpertlog
         WHERE convert(date,calledon) = @fdate AND servicename = 'Login'
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'NOD' CODE,
               'Total No. of Deadlock Execptions' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE convert(date,calledon) = @fdate
               AND serviceresult LIKE 'trans%dead%'
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'MTJ' CODE,
               'More time taken Saves (> 8 Sec)' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE     convert(date,calledon) = @fdate
               AND servicename = 'saving data'
               AND serviceresult = 'success'
               AND recordid = 0
               AND (timetaken / 1000) > 8
      GROUP BY convert(date,calledon)
      UNION ALL
        SELECT convert(date,calledon) cdate,
               'MTL' CODE,
               'More time taken Loads (> 8 Sec)' title,
               COUNT (*) cnt
          FROM axpertlog
         WHERE     convert(date,calledon) = @fdate
               AND servicename = 'load data'
               AND serviceresult = 'success'
               AND (timetaken / 1000) > 8
      GROUP BY convert(date,calledon)
      UNION ALL
      SELECT convert(date,calledon) cdate,
             'MTL' CODE,
             'More time taken reports (> 8 Sec)' title,
             COUNT (*) cnt
        FROM axpertlog
       WHERE     convert(date,calledon) = @fdate
             AND servicename = 'Get IView'
             AND serviceresult = 'success'
             AND (timetaken / 1000) > 8
GROUP BY convert(date,calledon);

   ----- exceptions
    delete from axpexception   where convert(date,exp_date)=@fdate;
   INSERT INTO axpexception (EXP_DATE,
                             STRUCTNAME,
                             SERVICENAME,
                             SERVICERESULT,
                             COUNT)
        SELECT convert(date,calledon),
               structname,
               servicename,
               serviceresult,
               COUNT (*)
          FROM axpertlog
         WHERE SERVICERESULT <> 'success' AND convert(date,calledon) = @fdate
      GROUP BY convert(date,calledon),
               structname,
               servicename,
               serviceresult;

   ----- time taken
    delete from ut_timetaken  where convert(date,executed_date)=@fdate;
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
        SELECT convert(date,getdate()) exec_date,
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
               AND convert(date,calledon) = @fdate
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
        SELECT convert(date,getdate()) exec_date,
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
               AND convert(date,calledon) = @fdate
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
        SELECT convert(date,getdate()) exec_date,
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
               AND convert(date,calledon) = @fdate
      GROUP BY b.caption;
END
>>
<<
CREATE FUNCTION fnSplit(
    @sInputList VARCHAR(8000) -- List of delimited items
       ) RETURNS @List TABLE (item VARCHAR(8000))

BEGIN
DECLARE @sItem VARCHAR(8000)
declare  @sDelimiter VARCHAR(8000) = '^'  -- delimiter that separates items
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
 SELECT
  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
 
 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END
>>
<<
CREATE PROCEDURE pro_emailformat(@ptemplate nvarchar(100) ,@pkeyword nvarchar(3000),@ptype nvarchar(100),@psendto nvarchar(1000),@psendcc nvarchar(1000) ) as
	DECLARE 
	@v_subject nvarchar(3500),
	@v_body nvarchar(3500),
	@v_sms  nvarchar(3500),
	@v_count numeric(5),
	@v_keyword nvarchar(350),
	@v_keyvalue nvarchar(1000),
	@vkeyword nvarchar(1000)

	DECLARE cursor_kword CURSOR FOR select item from fnssplit(@pkeyword)

begin

	set @v_count=(select count(*)  from  sendmsg
	 where lower(template) = lower( @ptemplate))
	 
	if @v_count=1 
	begin
		select  @v_subject = MSGSUBJECT, @v_body = MSGCONTENT, @v_sms = SMSMSG  
		from sendmsg
		where lower(template) = lower(@ptemplate)
 
		open cursor_kword 
		FETCH NEXT FROM cursor_kword into @vkeyword
		WHILE @@FETCH_STATUS = 0   
		BEGIN  

			set @v_keyword = SUBSTRing(@vkeyword, 1 ,CHARINDEX('=',@vkeyword,1)-1);
			set @v_keyvalue =  SUBSTRing( @vkeyword,CHARINDEX('=',@vkeyword,1)+1,len(@vkeyword));
			set @v_subject = replace(@v_subject,@v_keyword,@v_keyvalue);

			set @v_body = replace(@v_body,@v_keyword,@v_keyvalue);

			set @v_sms = replace(@v_sms,@v_keyword,@v_keyvalue);
		end

		CLOSE cursor_kword 
		DEALLOCATE cursor_kword 
	end

	if @ptype='S' 

		insert into axsms(createdon,mobileno,msg,status) values (convert(date,getdate()),@psendto,@v_sms,0)
	

	if @ptype='E' 

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
			 VALUES (@psendto,@psendcc,@v_subject,@v_body,null,null,null,0,null,null,convert(date,getdate()));

End
>>
<<
CREATE TRIGGER trg_AXPSCRIPTRUNNER
   ON  AXPSCRIPTRUNNER
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	declare @v_trgdis nvarchar(500),
			@v_trgena nvarchar(500),
			@vpintrg  nvarchar(500),
			@vpintext nvarchar(1000)
	
	set @vpintrg = (select ISNULL(trg_name,'NA')  from inserted)
	set @vpintext  = (select SCRIPT_TEXT  from inserted)
	set @v_trgdis = 'ALTER TRIGGER '+ @vpintrg +'  DISABLE'
	set @v_trgena = 'ALTER TRIGGER '+ @vpintrg +'  ENABLE'
	
	if @vpintrg = 'NA' 
		EXECUTE sp_executesql @vpintext
		
	if @vpintrg <> 'NA'
	begin
		EXECUTE sp_executesql @v_trgdis
		EXECUTE sp_executesql @vpintext
		EXECUTE sp_executesql @v_trgena
	end
    
END
>>
<<
CREATE TRIGGER TRG_UPDATDSIGN 
   ON  AXDSIGNCONFIG 
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @usr nvarchar(50), @prole nvarchar(50)
	
	set @usr=(select pusername from inserted)
	set @prole=(select prolename from inserted)
	
	update AXDSIGNCONFIG  set username=@usr, rolename=@prole where pusername=@usr
    
END
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
        'iidsco')
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
update axpages set UPDATEDON = CONVERT(date,getdate()),CREATEDON= CONVERT(date,getdate())
>>
<<
CREATE PROCEDURE SP_RAPIDDEFINITION(@ITid varchar(100)) 
AS 

BEGIN

	
SELECT a.context, a.fieldname, c.expression, a.fldsql as fldsql, ISNULL(b.paramname,'') as paramname 
	FROM axp_formload a 
	LEFT JOIN axp_params b on b.tstruct = @ITid and a.fieldname = b.childfield and 
a.context = b.context and b.active = 'T' 
INNER JOIN axpflds c on c.tstruct = @ITid and a.fieldname=c.fname 
WHERE a.tstruct = @ITid and a.active='T' and a.context = 'new';    
   
	
SELECT a.parentfield, a.childfield, a.dependenttype, ISNULL(b.paramname,'') as paramname,    
	ISNULL(b.allrows,'F') as allrows, ISNULL(b.dirparam,'F') as dirparam, c.frmno, c.ordno FROM axp_dependent a 
	LEFT JOIN axp_params b on b.tstruct = @ITid and a.parentfield = b.childfield and b.context = 'dep' and b.active = 'T'
	JOIN axpflds c on c.tstruct = @ITid and a.childfield=c.fname 
WHERE a.tstruct = @ITid
	
UNION
	
SELECT distinct par.paramname parentfield, dep1.childfield, 'g' as dependenttype, ISNULL(b.paramname,'') as paramname, 'F' as allrows, 'F' as dirparam, flds.frmno,flds.ordno  
	FROM axp_dependent dep1
	JOIN (select paramname, childfield from axp_params par where par.tstruct = @ITid and par.context = 'fg') par on par.childfield = dep1.parentfield
	JOIN axp_dependent dep2 on dep2.tstruct = @ITid  and dep2.parentfield = par.paramname and dep2.dependenttype = 'g'
	JOIN axp_params b on b.tstruct = @ITid and par.childfield = b.childfield and b.context = 'fg' and b.active = 'T'
 JOIN axpflds flds on flds.tstruct = @ITid and dep1.childfield = flds.fname
 
WHERE dep1.tstruct = @ITid
	ORDER BY frmno asc, ordno asc;

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
IF EXISTS (SELECT * FROM sysobjects WHERE name='GetIview') 
BEGIN
	DROP PROCEDURE GetIview;
END;
>>
<<
CREATE PROCEDURE GetIview(@ISql VARCHAR(max), @INoofRec INT, @IpageNo INT, @ICountFlag INT) 
AS 
BEGIN 
  DECLARE @pos1 INT, @pos2 INT, @pos3 INT; 
  DECLARE @Qry VARCHAR(max); 
  DECLARE @orderby VARCHAR(1000); 

  SET @pos1 = 0; 
  SET @pos2 = 0; 
  SET @Qry = @ISql; 
  SET @orderby = ''; 

  SELECT @pos1 = Charindex('from', @Qry, 1); 

  SELECT @pos2 = Charindex('order by', Substring(@Qry, @pos1 + 1, Len(@Qry)) 
				 , 
				 1); 

  IF @pos2 > 0 
	BEGIN 
		SET @orderby = Rtrim(Ltrim(Substring(@Qry, @pos1 + @pos2 + 8, Len(@Qry)))) ; 
		SET @Qry = Substring(@Qry, 1, @pos1 + @pos2 - 1); 
	END; 

  SET @orderby = Replace(@orderby, ',', ', '); 
  SET @orderby = Replace(@orderby, '  ', ' '); 
  SET @orderby = ' @' + Replace(@orderby, ', ', '@'); 

  WHILE Charindex('.', @orderby, 1) > 0 
	BEGIN 
		SET @pos1= Charindex('.', @orderby, 1); 
		SET @pos2= Charindex('@', @orderby, 2); 
		SET @pos3= Charindex('@', @orderby, @pos2 + 1); 

		IF @pos1 > 0 
		   AND @pos3 < @pos1 
		   AND @pos2 < @pos1 
		  BEGIN 
			  SET @orderby = Substring(@orderby, 1, @pos2) + 'a.' 
							 + Substring(@orderby, @pos2+1, Len(@orderby)); 
			  SET @pos1= Charindex('.', @orderby, 1); 
			  SET @pos2= Charindex('@', @orderby, 2); 
		  END; 

		SET @orderby= Replace(@orderby, Substring(@orderby, @pos2, @pos1 - @pos2 + 1), ','); 
		SET @orderby=Ltrim(@orderby); 
	END; 

  SET @orderby = Replace(Substring(@orderby, 2, Len(@orderby)), '@', ','); 

  WHILE Charindex(',,', @orderby, 1) > 0 
	BEGIN 
		SET @orderby = Replace(@orderby, ',,', ','); 
	END; 

  IF Charindex(',', @orderby, 1) = 1 
	BEGIN 
		SET @orderby = Substring(@orderby, 2, Len(@orderby)); 
	END; 

  IF ( @INoofRec > 0 AND @IpageNo > 0 ) 
	BEGIN 
		SELECT @ISql = 'select * from (select row_number() over ( ORDER BY ' 
					   + @orderby 
					   + ' ) as rowno, '''' as axrowtype, a.* from ( ' 
					   + @Qry + ') as a ) xy where rowno between ' 
					   + Cast(((@INoofRec * (@IpageNo-1))+1) AS VARCHAR(50)) 
					   + ' and ' 
					   + Cast((@INoofRec * (@IpageNo)) AS VARCHAR(50) ) 
					   + ' order by rowno '; 
	END 
  ELSE 
	SELECT @ISql = 'select row_number() over ( ORDER BY ' 
				   + @orderby 
				   + ' ) as rowno, '''' as axrowtype, a.* from ( ' 
				   + @Qry + ') as a ORDER by ' + @orderby; 

  EXECUTE (@ISql); 

  IF ( @ICountFlag = 1 
	   AND @IpageNo <= 1 ) 
	BEGIN 
		SET @Qry = 'select count(*) as IviewCount from (' 
				   + @Qry + ')a'; 

		EXECUTE (@Qry); 
	END; 
END; 
>>
<<
CREATE TABLE AX_NOTIFY(
    NOTIFICATION_ID INT IDENTITY(1,1) PRIMARY KEY,
    TITLE VARCHAR(255),
    MESSAGE text,
    ACTIONS text,
    FROMUSER VARCHAR(255),
    BROADCAST VARCHAR(1) DEFAULT 'N',
    STATUS VARCHAR(255),
    CREATED_BY VARCHAR(255),
    CREATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    PURGE_ON_FIRST_ACTION VARCHAR(1) DEFAULT 'N',
    NOTIFICATION_SENT_DATETIME datetime DEFAULT CURRENT_TIMESTAMP,
    RECORDID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
)
>>
<<
CREATE TABLE AX_MOBILE_RESPONSE(
    NOTIFICATION_ID INT REFERENCES AX_NOTIFY(NOTIFICATION_ID) ON DELETE CASCADE,
    USER_ID VARCHAR(255),
    RESPONSE TEXT, 
    PROJECT_ID VARCHAR(255)
)
>>
<<
CREATE TABLE AX_NOTIFY_WORKFLOW(
    NOTIFICATION_ID INT,
    RECORDID VARCHAR(255),
    APP_LEVEL VARCHAR(2),
    APP_DESC VARCHAR(2),
    CREATED_ON datetime  DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
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
    NOTIFICATION_ID INT REFERENCES AX_NOTIFY(NOTIFICATION_ID) ON DELETE CASCADE,
    USER_ID VARCHAR(255),
    STATUS VARCHAR(255),
    PROJECT_ID VARCHAR(255)
)
>>
<<
CREATE TABLE AX_LAYOUTDESIGN(
    DESIGN_ID INT IDENTITY(1,1) PRIMARY KEY,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT text,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON datetime DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
)
>>
<<
CREATE TABLE AX_LAYOUTDESIGN_SAVED(
    DESIGN_ID INT IDENTITY(1,1) PRIMARY KEY,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT text,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    PARENT_DESIGN_ID INT,
    RESPONSIBILITY text,
    ORDER_BY INT
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
<<
CREATE TABLE AX_PAGES(
    PAGE_ID INT IDENTITY(1,1) PRIMARY KEY,
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
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,  
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    ORDER_BY INT
)
>>
<<
CREATE TABLE AX_PAGE_SAVED(
    PAGE_ID INT IDENTITY(1,1) PRIMARY KEY,
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
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,  
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    PARENT_PAGE_ID INT,
    RESPONSIBILITY TEXT,
    ORDER_BY INT
)
>>
<<
CREATE TABLE AX_PAGE_RESPONSIBILITY(     
    PAGE_ID INT REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,
    RESPONSIBILITY VARCHAR(255),
    RESPONSIBILITY_ID INT
)
>>
<<
CREATE TABLE AX_PAGE_SD_RESPONSIBILITY(  
    PAGE_ID INT REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE,
    RESPONSIBILITY VARCHAR(255),
    RESPONSIBILITY_ID INT
)
>>
<<
CREATE TABLE AX_WIDGET_SAVED (
    WIDGET_ID INT IDENTITY(1,1) PRIMARY KEY,
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
    PAGE_ID INT REFERENCES AX_PAGE_SAVED(PAGE_ID) ON DELETE CASCADE,
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
)
>>
<<
CREATE TABLE AX_WIDGET_PUBLISHED (
    WIDGET_ID INT IDENTITY(1,1) PRIMARY KEY,
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
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
)
>>
<<
CREATE TABLE AX_HP_USER_LEVEL_WIDGET(
    PAGE_ID INT REFERENCES AX_PAGES(PAGE_ID) ON DELETE CASCADE,    
    WIDGETS  TEXT,
    USERNAME VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
)
>>
<<
CREATE TABLE AX_PAGE_TEMPLATES(
    TEMPLATE_ID INT IDENTITY(1,1) PRIMARY KEY,
    TITLE VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON DATETIME DEFAULT CURRENT_TIMESTAMP
)
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

/* =============================================  
Name            : axp_pr_page_creation
Author      : Abhishek 
Create date : 27-09-2018  
Description : To create or delete a page  

Example     :
page creation:
    exec axp_pr_page_creation 'PageTest7','Test13','w3test1','Head16','before', 'page.aspx?transid=page'
    Result      :
        success - 'Page created'
        failure - 'Page not found'

 page deletion:
    exec axp_pr_page_creation 'PageTest5', null, null, null,'delete', null
    Result      :
            success - 'Page deleted'
            failure - 'Page not found'
===============================================  */
<<
DROP PROCEDURE [axp_pr_page_creation]
>>
<<
CREATE PROCEDURE [axp_pr_page_creation](
        @pname VARCHAR(100),            -- New Page Name/Delete Page Name
        @pcaption VARCHAR(100),     -- New Page Caption
        @ppagetype VARCHAR(100),    -- New Page Type
        @pparentname VARCHAR(100),  -- Parent Name
        @paction VARCHAR(100),      -- Before/After inserting or delete
        @props varchar(100)         -- props
          ) 
AS
BEGIN
        DECLARE @orderno as int 
        DECLARE @level   as int
        DECLARE @sysdate as VARCHAR(100) 
        
        IF @paction <> 'delete'
            BEGIN
                SELECT @pparentname=parent, @orderno= ordno, @level=levelno FROM 
                (
                SELECT 
                        parent, 
                         CASE 
                                WHEN LOWER (@paction) = 'before' THEN ordno 
                                ELSE ordno + 1 
                        END ordno,
                          levelno
                FROM axpages
                WHERE name = @pparentname AND TYPE = 'p'
                
                UNION ALL
                
                SELECT A.NAME, 
                       MAX(B.ORDNO) + 1 AS ORDNO, 
                       A.LEVELNO + 1 AS LEVELNO
                FROM AXPAGES AS A
                        LEFT OUTER JOIN AXPAGES AS B ON A.NAME = B.PARENT
                        WHERE A.NAME = @pparentname AND A.TYPE = 'h'
                        GROUP BY A.NAME, A.LEVELNO
                ) AS s
              
              IF @orderno is null
                 SELECT 'Page not found' as Result
                ELSE
                  BEGIN
                      -- date format 'dd/mm/yyyy hh24:mi:ss'
                    SET @sysdate = convert(varchar, getdate(), 103) +' '+ convert(VARCHAR(10), GETDATE(), 108) 
                                     
                    UPDATE axpages SET ordno = ordno + 1 WHERE ordno >= @orderno;
                    
                    INSERT INTO axpages (name, caption, blobno, visible, TYPE, parent, ordno, levelno, pagetype, props, createdon, updatedon, importedon) 
                     VALUES (@pname, @pcaption, 1, 'T', 'p', @pparentname, @orderno, @level, @ppagetype, @props, @sysdate, @sysdate, @sysdate);
                        
                      SELECT 'Page created' as Result
                  END        
            END
        ELSE
            BEGIN
                SELECT @orderno= ordno FROM axpages WHERE name=@pname AND TYPE='p';
                
                IF @orderno is null
                 SELECT 'Page not found' as Result
                ELSE
                 BEGIN
                    DELETE FROM axpages WHERE name = @pname;
                
                    UPDATE axpages SET ordno = ordno - 1 WHERE ordno >= @orderno;
                
                    SELECT 'Page deleted' as Result
                 END
            END  
END
>>
<<
CREATE PROCEDURE PR_BULK_PAGE_DELETE
AS
BEGIN
    DECLARE @I$NAME varchar(max)
    DECLARE DB_IMPLICIT_CURSOR_FOR_I CURSOR LOCAL FORWARD_ONLY FOR
    
    SELECT AXPAGES.NAME
        FROM AXPAGES
        WHERE AXPAGES.PAGETYPE = 'web' AND AXPAGES.BLOBNO = 1

    OPEN DB_IMPLICIT_CURSOR_FOR_I
    WHILE 1 = 1
        BEGIN
            FETCH DB_IMPLICIT_CURSOR_FOR_I
            INTO @I$NAME

            IF @@FETCH_STATUS = -1
            BREAK

            BEGIN
                BEGIN TRY
                    EXECUTE AXP_PR_PAGE_CREATION
                        @PNAME = @I$NAME,
                        @PCAPTION = NULL,
                        @PPAGETYPE = NULL,
                        @PPARENTNAME = NULL,
                        @PACTION = 'delete',
                        @PROPS = NULL
                END TRY
                BEGIN CATCH
                    BEGIN
                        DECLARE
                        @db_null_statement int
                    END
                END CATCH
            END
        END
    CLOSE DB_IMPLICIT_CURSOR_FOR_I
    DEALLOCATE DB_IMPLICIT_CURSOR_FOR_I
END
>>
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
 create unique index  ui_AXCTX1 on AXCTX1 (axcontext,atype)
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
    GETDATE(), 'admin',  GETDATE(), 1,
    1, 'Tstruct Grid edit option',
    'GridEdit', 'configtypeTstruct Grid edit option', 'Tstruct', 'F', 'F', 'T', 'F') 
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
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000003, 'F', 0, 'admin',GETDATE(), 'admin', GETDATE(), 1, 1, 'Load forms along with list', 'configtypeLoad forms along with list', 'Autosplit', 'Tstruct', 'F', 'F', 'T', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000006, 'F', 0, 'admin', GETDATE(), 'admin', GETDATE(), 1, 1, 'Load reports/lists along with form', 'configtypeLoad reports/lists along with form', 'Autosplit', 'Iview', 'F', 'F', 'F', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000009, 'F', 0, 'admin', GETDATE(), 'admin', GETDATE(), 1, 1, 'Disablesplit', 'configtypeDisablesplit', 'Disablesplit', 'All', 'F', 'F', 'T', 'T')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)Values(1000550000012, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Open Window mode', 'configtypeOpen Window mode', 'Navigation', 'All', 'T', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000015, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Align Text', 'configtypeText', 'Text', 'All', 'T', 'T', 'F', 'F')
  >>
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000018, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Main Page Reload', 'configtypeMain Page Reload', 'General', 'All', 'T', 'T', 'F', 'F')
  >>  
<<
Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000021, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Change Password', 'configtypeChange Password', 'General', 'All', 'T', 'T', 'F', 'F')
  >>  
  <<
  Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000024, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Landing Structure', 'configtypeLanding Structure', 'General', 'All', 'T', 'T', 'F', 'F')
  >>
  <<
  Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000027, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'FetchSize', 'configtypeFetchSize', 'FetchSize', 'All', 'T', 'T', 'F', 'F')
  >>
  <<
  Insert into AXPSTRUCTCONFIGPROPS(AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, DUPCHK, PROPCODE, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS) Values(1000550000030, 'F', 0, 'admin', GETDATE(), 'admin',GETDATE(), 1, 1, 'Local Dataset', 'configtypeLocal Dataset', 'Lds', 'All', 'T', 'T', 'F', 'F')
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
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000003, 1742550000002, 1, 'Disable')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000004, 1742550000002, 2, 'Enable')
   >>
<< 
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000007, 1742550000005, 2, 'iview')
   >>
<<
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000006, 1742550000005, 1, 'tstruct')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000010, 1742550000008, 2, '30')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000028, 1742550000008, 20, '5000')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000027, 1742550000008, 19, '2000')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000026, 1742550000008, 18, '1000')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000009, 1742550000008, 1, '25')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000029, 1742550000008, 21, 'ALL')
   >>
<<
insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000011, 1742550000008, 3, '35')
   >>
<< 
insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000012, 1742550000008, 4, '40')
   >>
<<
 insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000013, 1742550000008, 5, '45')
   >>
<<
 insert  into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000014, 1742550000008, 6, '50')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000015, 1742550000008, 7, '55')
   >>
<<
 insert into AXPSTRUCTCONFIGPROVAL
   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES)
 Values
   (1742550000016, 1742550000008, 8, '60')
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
insert  into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values
   (1903990000002, 1903990000000, 2, 'Left')
   >> 
   << 
Insert into AXPSTRUCTCONFIGPROVAL   (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1790770000001, 1790770000000, 1, 'true')
   >>
<<
Insert into AXPSTRUCTCONFIGPROVAL    (AXPSTRUCTCONFIGPROVALID, AXPSTRUCTCONFIGPROPSID, AXPSTRUCTCONFIGPROVALROW, CONFIGVALUES) Values   (1790770000002, 1790770000000, 2, 'false')
   >>
<< 
Insert into axpstructconfigproval (AXPSTRUCTCONFIGPROVALID,AXPSTRUCTCONFIGPROPSID,AXPSTRUCTCONFIGPROVALROW,CONFIGVALUES) values (1040440000001,1040440000000,1,'Inline')
>>
<< 
Insert into axpstructconfigproval (AXPSTRUCTCONFIGPROVALID,AXPSTRUCTCONFIGPROPSID,AXPSTRUCTCONFIGPROVALROW,CONFIGVALUES) values (1040440000002,1040440000000,2,'Popup')
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
   ('PageTsaxstc', 'Advance Settings', '<root visible="T" type="p" defpage="T" name="PageTsaxstc" caption="Advance Settings" createdon="04/12/2018 13:36:37" createdby="admin" importedon="21/12/2018 12:03:28" importedby="admin" updatedon="18/12/2018 18:36:55" updatedby="admin" img="" ordno="113" levelno="0" parent="" updusername="" ptype="p" pgtype="taxstc" dbtype="oracle"><Container387 paged="False" align="Client" cat="cntr" parent="ClientPanel" defpage="T" tlhw="0,0,0,0" st="tstruct__axstc"/><tstruct__axstc cat="tstruct" transid="axstc" parent="Container387" align="Client"/></root>', 1, 
    'T', 'p', 'Head21', 32, 2, 
    '18/12/2018 18:36:55', '04/12/2018 13:36:37', '21/12/2018 12:03:28', 'admin', 'admin', 
    'admin', 'taxstc')
>>
<<
Insert into AXCTX1
   (AXCONTEXT, ATYPE)
 Values
   ('FormLoad', 'Property')
>>
<<
alter table AXPSTRUCTCONFIGPROPS add ALLUSERROLES char(100) 
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1104220000000, 'F', 0, 'admin', 
    GETDATE(), 'admin',GETDATE(), 1, 
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
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Resolve Attachment Path')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS)
 Values
   (1072550000003, 'F', 0, 'admin', 
   GETDATE(), 'admin', GETDATE(), 1, 
    1, 'Resolve Attachment Path', 
    'Resolve Attachment Path', 'configtypeResolve Attachment Path', 'Iview', 'F', 'F', 'F', 'T', 'F', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS)
 Values
   (1072550000000, 'F', 0, 'admin', 
    GETDATE(), 'admin', GETDATE(), 1, 
    1, 'Global Parameter Form', 
    'General', 'configtypeGlobal Parameter Form', 'Tstruct', 'F', 'F', 'T', 'F', 'T', 'F')
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS)
 Values
   (1072550000006, 'F', 0, 'admin', 
    GETDATE(), 'admin', GETDATE(), 1, 
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,
dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235660000010,'F',0,NULL,'admin',GETDATE(),'admin',
GETDATE(),NULL,1,1,NULL,NULL,NULL,'Custom CSS','Custom CSS','configtypeCustom CSS','','Tstruct','F','F','T','F','F','F','Use this property to attach custom CSS to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.CSS. In case this property is set to true for all forms instead of a selected form, the file name should be custom.CSS.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,
dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235440000043,'F',0,NULL,'admin',GETDATE(),'admin',
GETDATE(),NULL,1,1,NULL,NULL,NULL,'Custom JavaScript','Custom JavaScript','configtypeCustom JavaScript',NULL,'Tstruct','F','F','T','F','F','F','Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.')
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000009,'F',0,NULL,'admin',GETDATE(),'admin',GETDATE(),NULL,1,1,NULL,NULL,NULL,'Grid Scrollbar','Grid Scrollbar','configtypeGrid Scrollbar',NULL,'Tstruct','F','F','T','F','F','F','If key is set to true,then if grid dc is there for the tstruct,then horizontal scroll bar will be fixed at the bottom of the page.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000006,'F',0,NULL,'admin',GETDATE(),'admin',GETDATE(),NULL,1,1,NULL,NULL,NULL,'Auto Save Draft','Auto Save Draft','configtypeAuto Save Draft',NULL,'Tstruct','F','F','T','F','F','F','If key is set to true and time in millisecs(for ex for 60 secs give 60000 . Note: default time will be 120 seconds/2 minutes if no time is set) then on loading tstruct,it will check if unsaved data is there, if unsaved data  exists it will throw a popup with yes /no buttons.If yes, it will load the unsaved data else it will load a new tstruct.If new tstruct is opened for which key exists,then only if any field is changed,it will push data in redis after the mentioned time  in developer options at regular intervals.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1355440000003,'F',0,NULL,'admin',GETDATE(),'admin',GETDATE(),NULL,1,1,NULL,NULL,NULL,'Show keyboard in Hybrid App','Show keyboard in Hybrid App','configtypeShow keyboard in Hybrid App',NULL,'Tstruct','F','F','T','F','F','F','An enhancement to make an intuitive UI in Axpert Hybrid App i.e., 
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
(1635440000037,'F',0,NULL,'admin',GETDATE(),'admin',GETDATE(),NULL,1,1,NULL,NULL,NULL,'Enforced Strong Password Policy','General','configtypeEnforced Strong Password Policy',NULL,'Common','F','F','F','F','F','F','If key is set to true,Strong Password Policy will work.Details for Enforced Strong Password Policy: Password should be alphanumeric, contains one UpperCharacter, one LowerCharacter with atleast one special character.It will check the following condition if key set to true and if password entered is not matching the condition,then it will throw error.')
>>
<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid,axpstructconfigpropsid,axpstructconfigprovalrow,configvalues) VALUES 
(1635440000038,1635440000037,1,'true')
>>

<< 
INSERT INTO axctx1 (axcontext,atype) values ('Mobile Reports as Table','Property') 
>>
<< 
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984880000036,'F',0,NULL,'superadmin',GETDATE(),'superadmin',GETDATE(),NULL,1,1,NULL,NULL,NULL,'Notification Time Interval','General','configtypeNotification Time Interval',NULL,'All','F','F','T','T','F','F','Notification feature can be enabled at Application level by adding Developer Option "Notification Time Interval" , with values in minutes for time intervals as 1, 2, 3 , 4 etc. Once this key is added, long running web services/backend scheduled jobs completion can be notified to the user with given time intervals, so that user would be able to do other operations during long running web services/backend jobs.') 
>>
<< 
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984440000004,'F',0,NULL,'superadmin',GETDATE(),'superadmin',GETDATE(),NULL,1,1,NULL,NULL,NULL,'User Manual','General','configtypeUser Manual',NULL,'All','F','F','T','T','F','F','User can able to access the files through web application which is saved in local folder through User Manual option (located in right sidebar menu)') 
>>
<<
 INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1984220000001,'F',0,NULL,'superadmin',GETDATE(),'superadmin',GETDATE(),NULL,1,1,NULL,NULL,NULL,'Mobile Reports as Table','Mobile Reports as Table','configtypeMobile Reports as Table',NULL,'All','F','F','T','T','F','F','Administrator can enable tabular view in mobile instead of cards view') 
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
INSERT INTO axctx1 (axcontext,atype) values ('WebService Timeout','Property') 
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS, DESCRIPTION)
 Values
   (1000330000005, 'F', 0, 'admin', 
    GETDATE(), 'admin', GETDATE(), 1, 
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

