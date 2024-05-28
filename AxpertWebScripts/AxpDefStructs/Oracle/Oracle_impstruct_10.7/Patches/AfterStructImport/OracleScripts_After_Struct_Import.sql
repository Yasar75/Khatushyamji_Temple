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
commit
>>  
