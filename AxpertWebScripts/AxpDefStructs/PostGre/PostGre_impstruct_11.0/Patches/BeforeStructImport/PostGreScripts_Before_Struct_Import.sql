<<
drop table axpexchange cascade
>>
<<
drop table AXCONSTRAINTS cascade
>>
<<
drop table axdsignconfig cascade
>>
<<
drop table AXDSIGNMAIL cascade
>>
<<
drop table axintelliviewdet cascade
>>
<<
CREATE OR REPLACE FUNCTION add_months(
	start date,
	months integer)
    RETURNS date
    LANGUAGE 'sql'

    COST 100
    IMMUTABLE 
AS $BODY$
  SELECT (start + (months || ' months')::INTERVAL)::DATE
$BODY$
>>
<<
CREATE TABLE AX_LAYOUTDESIGN(
    DESIGN_ID NUMERIC(16) primary key,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
)
>>
<<
CREATE OR REPLACE FUNCTION fn_AX_LAYOUTDESIGN() RETURNS TRIGGER
AS $AX_LAYOUTDESIGN$
	declare 
	v_sid numeric(15);
    
    BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN 
		
		select nextval('ax_layoutdesign_seq') into v_sid; 
		
		NEW.DESIGN_ID = v_sid;
		
		return new;
	end if;
		
end; 
$AX_LAYOUTDESIGN$ LANGUAGE plpgsql;
>>
<<
create trigger AX_LAYOUTDESIGN_bir 
before insert on AX_LAYOUTDESIGN   
for each row

execute procedure fn_AX_LAYOUTDESIGN();

end;
>>
<<
CREATE TABLE AX_LAYOUTDESIGN_SAVED(
    DESIGN_ID NUMERIC(16) primary key,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT TEXT,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    PARENT_DESIGN_ID NUMERIC(16),
    RESPONSIBILITY TEXT,
    ORDER_BY NUMERIC
)
>>
<<
CREATE SEQUENCE ax_layoutdesign_saved_seq increment 1 START WITH 1
>>
<<
CREATE SEQUENCE ax_layoutdesign_seq increment 1 START WITH 1
>>
<<
CREATE OR REPLACE FUNCTION fn_AX_LAYOUTDESIGN_SAVED() RETURNS TRIGGER
AS $AX_LAYOUTDESIGN_SAVED$
	declare 
	v_sid numeric(15);
    
    BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN 
		
		select nextval('ax_layoutdesign_saved_seq') into v_sid; 
		
		NEW.DESIGN_ID = v_sid;
		
		return new;
	end if;
		
end; 
$AX_LAYOUTDESIGN_SAVED$ LANGUAGE plpgsql;
>>
<<
create trigger AX_LAYOUTDESIGN_SAVED_bir 
before insert on AX_LAYOUTDESIGN_SAVED   
for each row

execute procedure fn_AX_LAYOUTDESIGN_SAVED();

end;
>>
<<
CREATE TABLE AXPKEYWORDS
(
  KEYWORD  VARCHAR(100),
  F2       NUMERIC
)
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ADD', 1)
>>
 << 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ALTER', 2) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('AND', 3)
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ANY', 4) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('AS', 5)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ASC', 6)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('AUDIT', 7) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('BETWEEN', 8)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('BY', 9) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('CHAR', 10) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('CHECK', 11) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('CLUSTER', 12) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('COLUMN', 13) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('COMMENT', 14) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('COMPRESS', 15)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('CONNECT', 16)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('CREATE', 17)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('CURRENT', 18)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DATE', 19) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DECIMAL', 20) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DELETE', 22) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DESC', 23) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DISTINCT', 24)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DROP', 25) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ELSE', 26) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('EXCLUSIVE', 27)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('EXISTS', 28) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('FILE', 29)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('FLOAT', 30)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('FOR', 31) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('FROM', 32) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GRANT', 33) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GROUP', 34)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('HAVING', 35) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('IDENTIFIED', 36) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('IMMEDIATE', 37) >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('IN', 38) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('INCREMENT', 39) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('INDEX', 40) 
>>
<<
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('INITIAL', 41) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Insert', 42)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('INTEGER', 43)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('INTERSECT', 44)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('INTO', 45) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('IS', 46) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('LEVEL', 47) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('LIKE', 48) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('LOCK', 49) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('LONG', 50) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('MAXEXTENTS', 51)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('MINUS', 52)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('MODE', 53)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('MODIFY', 54)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('NOAUDIT', 55)
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('NOCOMPRESS', 56) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('NOWAIT', 58) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('NULL', 59)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('NUMBER', 60) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('OF', 61)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('OFFLINE', 62) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('OPTION', 63)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('OR', 64) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ORDER', 65)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('PCTFREE', 66) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('PRIOR', 67) 
>>
<< Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('PRIVILEGES', 68) >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('PUBLIC', 69)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('RAW', 70) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('RENAME', 71) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('RESOURCE', 72) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('REVOKE', 73) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ROW', 74)
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ROWID', 75) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ROWLABEL', 76) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ROWNUM', 77)
 >>
<< 

Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ROWS', 78)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SELECT', 79) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SESSION', 80) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SET', 81) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SHARE', 82) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SIZE', 83)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SMALLINT', 84) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('START', 85) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SUCCESSFUL', 86) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SYNONYM', 87) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SYSDATE', 88) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('TABLE', 89)
 >>
<< Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('THEN', 90) >>
<<
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('TO', 91)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('TRIGGER', 92) 
>>
<< Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('UID', 93) >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('UNION', 94) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('UNIQUE', 95) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('USER', 96) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('VALIDATE', 97) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('VALUES', 98) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('VARCHAR', 99)
 >>
<<
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('VARCHAR2', 100)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('VIEW', 101) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('WHENEVER', 102) 
>>
<<
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('WHERE', 103) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('WITH', 104)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('UPDATE', 111) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('FIELD', 113)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('TAB', 118) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DATABASE', 120)
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ORDER BY', 122) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DEFAULT', 123) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('VALUE', 124)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('JOINT', 125) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('PASSWORD', 126)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('NO', 128)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('NOT', 129)
 >>

<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('TO', 130) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('FieldChanged', 131)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GetRCell', 132)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Upper', 133)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Lower', 134) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DTOC', 135) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('CTOD', 136) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('RND', 137)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ROUND', 138)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('STUFF', 139) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('IIF', 140) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('AmtWord', 141)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Val', 142)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('STR', 143)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SUBSTR', 144)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Convert', 145) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('RevConvert', 146)
 >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Encode', 147)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Decode', 148)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('HashChar', 149)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('MandY', 150) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DaysElapsed', 151)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('TimeElapsed', 152)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('AddToTime', 153) 
>>
<< Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('AddToDate', 154) >>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('AddToMonth', 155) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('IsEmptyValue', 156)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('LastDayOfMonth', 157) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('ValidEncodeDate', 158) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Eval', 159)
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('IsEmpty', 160) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Abs', 161) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('MakeDate', 162)
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Date', 163) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('FormatDateTime', 164)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Time', 165) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('DayofDate', 166)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('MonthofDate', 167)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('YearofDate', 168)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Gen_id', 169) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Total', 170) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Sum', 171)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GetMax', 172) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GetValue', 173) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GetId', 174) >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GetRow', 175) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GetRowCount', 176)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GetCostRate', 177)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GetAdjustedAmount', 178) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('SumTill', 179) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GetCell', 180) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('GETINTEGER', 181) 
>>
<<
 Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Power', 182)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('CreatedBy', 183)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('CreatedOn', 184)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('AxpCeil', 185)
 >>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('AxpFloor', 186) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Days360', 187) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('data', 188) 
>>
<< 
Insert into AXPKEYWORDS
   (KEYWORD, F2)
 Values
   ('Rowcount', 189) 
>>

<<
CREATE OR REPLACE FUNCTION fn_get_query_cols(pquery text)
  RETURNS TABLE (column_list varchar) AS
$$
DECLARE
BEGIN
   EXECUTE 'CREATE TEMP TABLE vtmp1 ON COMMIT DROP AS ' ||pquery|| ' limit 1';
   EXECUTE 'CREATE TEMP TABLE vtmp2 ON COMMIT DROP AS select column_name::varchar from INFORMATION_SCHEMA.COLUMNS where table_name =''vtmp1'' ';

     RETURN QUERY TABLE vtmp2;
END
$$ LANGUAGE plpgsql;
>>
------------11.2
<<
ALTER TABLE axpmdmaps ADD onapprove varchar(1) NULL
>>
<<
ALTER TABLE axpmdmaps ADD onreject varchar(1) NULL
>>
<<
ALTER TABLE axpmdmaps ADD masdec numeric(2) NULL
>>
<<
ALTER TABLE axpflds ALTER COLUMN "expression" TYPE varchar(4000) USING "expression"::varchar
>>
<<
ALTER TABLE axpflds ALTER COLUMN valexpr TYPE varchar(4000) USING valexpr::varchar
>>


