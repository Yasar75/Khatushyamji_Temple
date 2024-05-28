<<
alter table axpstructconfig add purpose varchar(1000)
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
 Insert into AXCTX1
   (AXCONTEXT, ATYPE)
 Values
   ('GridEdit', 'Property')
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

---

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
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, ALLTSTRUCTS, ALLIVIEWS)
Values
   (1040440000000, 'F', 0, 'admin',
    CURDATE(), 'admin', CURDATE(), 1,
    1, 'Tstruct Grid edit option',
    'GridEdit', 'configtypeTstruct Grid edit option', 'Tstruct', 'F', 'F', 'T', 'F') 
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
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, 
   CFIELDS, ALLTSTRUCTS, ALLIVIEWS)
 Values
   (1000330000013, 'F', 0, 'admin',CURDATE(), 'admin', CURDATE(), 1, 1, 'ExportVerticalAlign', 'ExportVerticalAlign', 'configtypeExportVerticalAlign', 
   'All', 'F', 'F', 'F', 'T', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000010, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Excel Export', 'Excel Export', 'configtypeExcel Export', 'All', 'F', 'F', 'F', 'T', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000007, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'Trim IView Data', 'Trim IView Data', 'configtypeTrim IView Data', 'All', 'F', 'F', 'F', 'T', 'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000005, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'WebService Timeout', 'WebService Timeout', 'configtypeWebService Timeout', 'All', 'F', 'F', 'F', 'T', 'T' )
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000002, 'F', 0, 'admin', CURDATE(), 'admin', CURDATE(), 1, 1, 'ApplicationCompressedMode', 'General', 'configtypeApplicationCompressedMode', 'All', 'F', 'F', 'F', 'F',   'T')
   >>
   <<
Insert into AXPSTRUCTCONFIGPROPS
   (AXPSTRUCTCONFIGPROPSID, CANCEL, SOURCEID, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, APP_LEVEL, APP_DESC, CONFIGPROPS, PROPCODE, DUPCHK, PTYPE, CACTION, CHYPERLINK, CFIELDS, ALLTSTRUCTS, ALLIVIEWS, ALLUSERROLES)
 Values
   (1000330000000, 'F', 0, 'admin',CURDATE(), 'admin',CURDATE(), 1, 1, 'ApplicationTemplate', 'General', 'configtypeApplicationTemplate', 'All', 'F', 'F', 'F', 'F', 'T')
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
commit
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
    'Multi Select', 'configtypeMulti Select Field', 'Tstruct', 'F', 'F', 'T', 'F', 'T')
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,
dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235660000010,'F',0,NULL,'admin',now(),'admin',
now(),NULL,1,1,NULL,NULL,NULL,'Custom CSS','Custom CSS','configtypeCustom CSS','','Tstruct','F','F','T','F','F','F','Use this property to attach custom CSS to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.CSS. In case this property is set to true for all forms instead of a selected form, the file name should be custom.CSS.')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,configprops,propcode,
dupchk,context,ptype,caction,chyperlink,alltstructs,alliviews,alluserroles,cfields,description) VALUES (1235440000043,'F',0,NULL,'admin',now(),'admin',
now(),NULL,1,1,NULL,NULL,NULL,'Custom JavaScript','Custom JavaScript','configtypeCustom JavaScript',NULL,'Tstruct','F','F','T','F','F','F','Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.')
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
INSERT INTO axpages (name,caption,props,blobno,img,visible,[type],parent,ordno,levelno,updatedon,CreatedOn,ImportedOn,CreatedBy,UpdatedBy,ImportedBy,readonly,updusername,category,pagetype,INTVIEW,webenable,shortcut) VALUES 
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1000330000005,'F',0,NULL,'admin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'WebService Timeout','WebService Timeout','WebService Timeout','configtypeWebService Timeout',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1226220000004,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Iview Button Style','Iview Button Style','New Iview buttons UI can be switched as Modern(Google like UI) / Classic(Classic Bootstrap like UI) . Product default Iview Button UI is  "Modern" Style.','configtypeIview Button Style','','Iview','F','F','F','F','T','F')
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
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1355440000003,'F',0,NULL,'admin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Show keyboard in Hybrid App','Show keyboard in Hybrid App','An enhancement to make an intuitive UI in Axpert Hybrid App i.e., 
-- based on the "Show keyboard in Hybrid App" key value, user can enable or disable the keyboard for autocomplete fields in tstruct level.
-- By default, value is set as true which makes no difference in the existing feature/functionality.
-- If set false,  keyboard is hidden/disabled along with the drop-down and clear icons. On single click of the field, drop down appears to choose the desired value.
','configtypeShow keyboard in Hybrid App',NULL,'Tstruct','F','F','F','T','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1355440000006,'F',0,NULL,'admin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Auto Save Draft','Auto Save Draft','If key is set to true and time in millisecs(for ex for 60 secs give 60000 . Note: default time will be 120 seconds/2 minutes if no time is set) then on loading tstruct,it will check if unsaved data is there, if unsaved data  exists it will throw a popup with yes /no buttons.If yes, it will load the unsaved data else it will load a new tstruct.If new tstruct is opened for which key exists,then only if any field is changed,it will push data in redis after the mentioned time  in developer options at regular intervals.','configtypeAuto Save Draft',NULL,'Tstruct','F','F','F','T','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1355440000009,'F',0,NULL,'admin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Grid Scrollbar','Grid Scrollbar','If key is set to true,then if grid dc is there for the tstruct,then horizontal scroll bar will be fixed at the bottom of the page.','configtypeGrid Scrollbar',NULL,'Tstruct','F','F','F','T','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1635440000037,'F',0,NULL,'admin',CURDATE(),'admin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Enforced Strong Password Policy','General','If key is set to true,Strong Password Policy will work.Details for Enforced Strong Password Policy: Password should be alphanumeric, contains one UpperCharacter, one LowerCharacter with atleast one special character.It will check the following condition if key set to true and if password entered is not matching the condition,then it will throw error.','configtypeEnforced Strong Password Policy',NULL,'Common','F','F','F','F','F','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1984220000001,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Mobile Reports as Table','Mobile Reports as Table','Administrator can enable tabular view in mobile instead of cards view','configtypeMobile Reports as Table',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1984440000004,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'User Manual','General','User can able to access the files through web application which is saved in local folder through User Manual option (located in right sidebar menu)','configtypeUser Manual',NULL,'All','F','F','F','T','T','F')
>>
<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid,Cancel,Sourceid,MapName,UserName,Modifiedon,CreatedBy,CreatedOn,Wkid,App_level,App_desc,App_slevel,CancelRemarks,WFRoles,configprops,propcode,description,dupchk,context,ptype,caction,chyperlink,cfields,alltstructs,alliviews,alluserroles) VALUES (1984880000036,'F',0,NULL,'superadmin',CURDATE(),'superadmin',CURDATE(),NULL,1,1,NULL,NULL,NULL,'Notification Time Interval','General','Notification feature can be enabled at Application level by adding Developer Option "Notification Time Interval" , with values in minutes for time intervals as 1, 2, 3 , 4 etc. Once this key is added, long running web services/backend scheduled jobs completion can be notified to the user with given time intervals, so that user would be able to do other operations during long running web services/backend jobs.','configtypeNotification Time Interval',NULL,'All','F','F','F','T','T','F')
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