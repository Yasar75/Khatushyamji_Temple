<<
alter table axpstructconfig add purpose varchar2(1000)
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
Insert into AXPSTRUCTCONFIG
   (AXPSTRUCTCONFIGID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON,
	APP_LEVEL, APP_DESC, ASPROPS, SETYPE, PROPS, PROPVALUE1, PROPSVAL, STRUCTCAPTION, 
	STRUCTNAME, STYPE, USERROLES, DUPCHK)
 Values
   (1386770000002, 'F', 0, 'admin', TO_DATE('05-06-2019', 'DD/MM/YYYY'), 
	'admin', TO_DATE('05-06-2019', 'DD/MM/YYYY'), 1, 1, 'Save Image in DB', 
	'Tstruct', 'SaveImage', 
	'true', 'true', 'My Profile(dprof)', 'dprof', 'Tstruct', 'ALL', 'Save Image in DBdproftrueALL')
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,
dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235660000010,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Custom CSS','Custom CSS',
'configtypeCustom CSS','','Tstruct','F','F','T','F','F','F','Use this property to attach custom CSS to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.CSS. In case this property is set to true for all forms instead of a selected form, the file name should be custom.CSS.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,
dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235440000043,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Custom JavaScript','Custom JavaScript',
'configtypeCustom JavaScript',NULL,'Tstruct','F','F','T','F','F','F','Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.')
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
INSERT INTO axctx1 (axcontext,atype) values ('WebService Timeout','Property') 
>>
<<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES, CFIELDS, DESCRIPTION)
 Values
   (1000330000005, 'F', 0, 'admin', 
    sysdate, 'admin', sysdate, 1, 
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1000330000005,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'WebService Timeout','WebService Timeout','WebService Timeout','configtypeWebService Timeout',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1226220000004,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'Iview Button Style','Iview Button Style','New Iview buttons UI can be switched as Modern(Google like UI) / Classic(Classic Bootstrap like UI) . Product default Iview Button UI is  "Modern" Style.','configtypeIview Button Style','','Iview','F','F','F','F','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235440000043,'F',0,NULL,'superadmin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Custom JavaScript','Custom JavaScript','configtypeCustom JavaScript','','All','F','F','T','T','F','F','Reports:
Use this property to attach custom javascript to Reports/forms. Set this property value to "true" for a selected report. If this property is set to true, the custom javascript file for Reposts should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.js. In case this property is set to true for all reports instead of a selected report, the file name should be custom.js

Tstructs:
Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235660000010,'F',0,NULL,'superadmin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Custom CSS','Custom CSS','configtypeCustom CSS','','All','F','F','T','T','F','F','Reports:
Use this property to attach custom CSS to Reports. Set this property value to "True" for a selected report. If for report this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.CSS. In case this property is set to true for all reports instead of a selected report, the file name should be custom.CSS.

Tstructs:
Use this property to attach custom CSS to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.CSS. In case this property is set to true for all forms instead of a selected form, the file name should be custom.CSS.
')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1355440000003,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Show keyboard in Hybrid App','Show keyboard in Hybrid App','An enhancement to make an intuitive UI in Axpert Hybrid App i.e., 
-- based on the "Show keyboard in Hybrid App" key value, user can enable or disable the keyboard for autocomplete fields in tstruct level.
-- By default, value is set as true which makes no difference in the existing feature/functionality.
-- If set false,  keyboard is hidden/disabled along with the drop-down and clear icons. On single click of the field, drop down appears to choose the desired value.
','configtypeShow keyboard in Hybrid App',NULL,'Tstruct','F','F','F','T','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1355440000006,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Auto Save Draft','Auto Save Draft','If key is set to true and time in millisecs(for ex for 60 secs give 60000 . Note: default time will be 120 seconds/2 minutes if no time is set) then on loading tstruct,it will check if unsaved data is there, if unsaved data  exists it will throw a popup with yes /no buttons.If yes, it will load the unsaved data else it will load a new tstruct.If new tstruct is opened for which key exists,then only if any field is changed,it will push data in redis after the mentioned time  in developer options at regular intervals.','configtypeAuto Save Draft',NULL,'Tstruct','F','F','F','T','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1355440000009,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Grid Scrollbar','Grid Scrollbar','If key is set to true,then if grid dc is there for the tstruct,then horizontal scroll bar will be fixed at the bottom of the page.','configtypeGrid Scrollbar',NULL,'Tstruct','F','F','F','T','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1635440000037,'F',0,NULL,'admin',sysdate,'admin',sysdate,NULL,1,1,NULL,NULL,NULL,'Enforced Strong Password Policy','General','If key is set to true,Strong Password Policy will work.Details for Enforced Strong Password Policy: Password should be alphanumeric, contains one UpperCharacter, one LowerCharacter with atleast one special character.It will check the following condition if key set to true and if password entered is not matching the condition,then it will throw error.','configtypeEnforced Strong Password Policy',NULL,'Common','F','F','F','F','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1984220000001,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'Mobile Reports as Table','Mobile Reports as Table','Administrator can enable tabular view in mobile instead of cards view','configtypeMobile Reports as Table',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1984440000004,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'User Manual','General','User can able to access the files through web application which is saved in local folder through User Manual option (located in right sidebar menu)','configtypeUser Manual',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1984880000036,'F',0,NULL,'superadmin',sysdate,'superadmin',sysdate,NULL,1,1,NULL,NULL,NULL,'Notification Time Interval','General','Notification feature can be enabled at Application level by adding Developer Option "Notification Time Interval" , with values in minutes for time intervals as 1, 2, 3 , 4 etc. Once this key is added, long running web services/backend scheduled jobs completion can be notified to the user with given time intervals, so that user would be able to do other operations during long running web services/backend jobs.','configtypeNotification Time Interval',NULL,'All','F','F','F','T','T','F')
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