drop table if exists axdsigntrans;<<
SET FOREIGN_KEY_CHECKS = 0;
>>

<<
drop table if exists axpexchange;
>>

<<
drop table if exists AXCONSTRAINTS;
>>

<<
alter table axdsignmail drop constraint FK_AxdSignTrans_AXPMAILID
>>

<<
drop table if exists axdsignconfig;
>>

<<
drop table if exists axdsigntrans;
>>

<<
drop table if exists AXDSIGNMAIL;
>>

<<
drop table if exists AxGloVar;
>>

<<
drop table if exists axintelliviewdet;
>>

<<
SET FOREIGN_KEY_CHECKS = 1;
>>