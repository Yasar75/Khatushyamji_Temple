<<
DECLARE @SQL VARCHAR(4000)
SET @SQL = 'ALTER TABLE axusers DROP CONSTRAINT |ConstraintName| '
SET @SQL = REPLACE(@SQL, '|ConstraintName|', ( SELECT name FROM sysobjects WHERE xtype = 'PK' AND 
parent_obj = OBJECT_ID('axusers')))
EXEC (@SQL)
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