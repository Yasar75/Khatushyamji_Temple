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
