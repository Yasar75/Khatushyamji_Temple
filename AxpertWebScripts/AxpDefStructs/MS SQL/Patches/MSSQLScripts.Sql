CREATE TABLE AXP_MAILJOBS
(
  MAILTO             VARCHAR(1000),
  MAILCC             VARCHAR(1000),
  SUBJECT            VARCHAR(1000),
  BODY               VARCHAR(MAX),
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
  JOBID      smallint IDENTITY(1,1)PRIMARY KEY CLUSTERED
)
GO

drop table AXUSRHISTORY
GO

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
)
GO

CREATE TABLE USAGEDTL
(
  EXECUTEDDATE  DATE,
  CODE           VARCHAR(20),
  TITLE          VARCHAR(50),
  CNT           NUMERIC(18)
)
GO

CREATE TABLE AXPEXCEPTION
(
  EXP_DATE       DATE,
  STRUCTNAME      VARCHAR(16),
  SERVICENAME     VARCHAR(50),
  SERVICERESULT   VARCHAR(500),
  [COUNT]          NUMERIC
)
GO

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
GO

DROP TABLE AXCONSTRAINTS
GO

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
)
GO



ALTER TABLE axusergroups ADD axusergroupsid NUMERIC(15)
GO




ALTER TABLE AXP_MAILJOBS ADD  jobdate DATE 
GO

ALTER TABLE AXUSERS ADD cancelremarks  VARCHAR(300)
GO

ALTER TABLE AXUSERS
ADD axusersid numeric(15)
GO

ALTER TABLE AXUSERS
ADD cancel  VARCHAR(10)
GO

ALTER TABLE AXUSERLEVELGROUPS
ADD axusersid NUMERIC(15)
GO

ALTER TABLE AXUSERLEVELGROUPS
ADD axuserlevelgroupsid NUMERIC(15)
GO

ALTER TABLE AXUSERS
ADD sourceid numeric(15)
GO

update  axuserlevelgroups 
set axusersid=1,AXUSERLEVELGROUPSID=12345555  where username='admin' 
go

update axusers set axusersid=1,pusername=username,ppassword=password where username='admin'
go

ALTER TABLE axsms ADD createdon date
GO

alter table axusers ALTER COLUMN pwd varchar(20)
GO



ALTER TABLE AXUSERGROUPS
ADD cancel  VARCHAR(10)
GO

ALTER TABLE AXUSERGROUPS
ADD sourceid  numeric(15)
GO

ALTER TABLE AXUSERGROUPS
ADD cancelremarks  VARCHAR(300)
GO



ALTER TABLE AXPEXCHANGE
ADD axpexchangeid NUMERIC(15)
GO

ALTER TABLE AXINTELLIVIEWDET
ADD axintelliviewdetid NUMERIC(15)
GO

SELECT *
INTO     axpages_bkpaxp97
FROM axpages
GO

drop table axpages
GO

CREATE TABLE AXPAGES
(
  NAME          VARCHAR(15),
  CAPTION       VARCHAR(50),
  PROPS        VARCHAR(MAX),
  BLOBNO       NUMERIC(3),
  IMG           VARCHAR(50),
  VISIBLE      CHAR(1),
  TYPE         CHAR(1),
  PARENT        VARCHAR(15),
  ORDNO        NUMERIC(3),
  LEVELNO      NUMERIC(3),
  UPDATEDON     VARCHAR(25),
  CREATEDON     VARCHAR(25),
  IMPORTEDON    VARCHAR(25),
  CREATEDBY     VARCHAR(25),
  UPDATEDBY     VARCHAR(25),
  IMPORTEDBY    VARCHAR(25),
  READONLY      VARCHAR(1),
  UPDUSERNAME   VARCHAR(25),
  CATEGORY      VARCHAR(30),
  PAGETYPE      VARCHAR(15),
  INTVIEW       VARCHAR(1),
  WEBENABLE     VARCHAR(1)
)
GO


update axpages set UPDATEDON = CONVERT(date,getdate()),CREATEDON= CONVERT(date,getdate())
GO
        
        
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
    GO


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
    GO

ALTER TABLE axusers DROP CONSTRAINT [PK__axusers__F3DBC573164452B1]
GO

ALTER TABLE axusers
ADD UNIQUE (Pusername)
GO

ALTER TABLE AXDSIGNMAIL
ADD AXDSIGNMAILid NUMERic(15)
GO


CREATE TRIGGER t1_axusers
   ON  axusers
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @usr nvarchar(50), @pwd nvarchar(50)
	
	set @usr=(select pusername from inserted)
	set @pwd=(select ppassword from inserted)
	
	update axusers set username=@usr, password=@pwd where pusername=@usr
    
END

GO

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



GO



ALTER TABLE AXDSIGNCONFIG
ADD AXDSIGNCONFIGid NUMERic(15)
GO

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
GO



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
GO




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
GO





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

GO




drop table axsms
GO

CREATE TABLE AXSMS
(
  RECORDID  smallint IDENTITY(1,1)PRIMARY KEY CLUSTERED,
  MOBILENO   VARCHAR(10),
  MSG        VARCHAR(250),
  STATUS     NUMERic(1),
  SENTON     DATE,
  REMARKS    VARCHAR(1000),
  CREATEDON  DATE
)
GO

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

GO

update  axuserlevelgroups 
set axusername='admin',axusergroup='default'  where AXUSERLEVELGROUPSID=12345555
go





