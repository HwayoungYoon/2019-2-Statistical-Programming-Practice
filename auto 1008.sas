LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN:);



LIBNAME sh 'C:\DATA' ;
FILENAME company 'C:\DATA\company.txt' ;

DATA sh.company ;
			INFILE  company ;
			INPUT id 2. age 1. type $1. (item1-item3) (1. ) ;
RUN ;

PROC PRINT ; RUN ;
PROC PRINT ; VAR  id item1 item2 item3 ; RUN ;
PROC PRINT ; WHERE type='F' ; RUN ;



/* 위와 동일한 결과이게 SQL로 짠 코드*/
PROC SQL ;
			SELECT *
			FROM sh.company ;
QUIT ;
PROC SQL ;
			SELECT id, item1, item2, item3
			FROM sh.company ;
QUIT ;
PROC SQL ;
			SELECT *
			FROM sh.company
			WHERE type='F' ;
QUIT ;



/*p.22 Report 생성 : 중복행의 제거*/
PROC FREQ ;
			TABLES AGE type*AGE ;
RUN ;
PROC SQL ;
		SELECT DISTINCT age
		FROM sh.company ;
		SELECT DISTINCT type, age
		FROM sh.company ;
QUIT ;



/*P.24  Report 생성 : 새변수 추가 출력*/

PROC SQL ;
	SELECT * ,
		sum(item1,item2,item3)	as s_item ,
		mean(item1,item2,item3)	 as m_item
			LABEL='항목평균' FORMAT=5.2
	FROM sh.company ;
QUIT ;


/*p.25*/
DATA company ; SET sh.company ;
		s_item=sum(of item1-item3) ;
		m_item=mean(of item1-item3) ;
	SELECT(age) ;
		WHEN(1,2) n_age='30대이하' ;
		OTHERWISE n_age='40대이상' ;
	END ;
	LENGTH grp$4 ;
	IF m_item< 1.3 THEN grp='BAD' ;
		ELSE IF m_item< 2.3 THEN grp='SOSO' ;
		ELSE grp='GOOD' ;
RUN ;
PROC PRINT ; RUN ;
/*p.26(p.25와 동일한 결과이게 SQL로 짠 코드*/
PROC SQL ;
		SELECT * ,
				sum(item1, item2, item3) as s_item ,
				mean(item1, item2, item3) as m_item ,
			CASE WHEN age in (1,2) THEN '30대이하'
				ELSE '40대이상'
			END AS n_age ,
			CASE WHEN mean(item1, item2, item3) < 1.3 THEN 'BAD'
				WHEN mean(item1, item2, item3) < 2.3 THEN 'SOSO'
				ELSE 'GOOD'
			END AS grp
		FROM sh.company ;
QUIT;
PROC SQL ;
		SELECT * ,
				sum(item1, item2, item3) as s_item ,
				mean(item1, item2, item3) as m_item ,
			CASE WHEN age in (1,2) THEN '30대이하'
				ELSE '40대이상'
			END AS n_age ,
			CASE WHEN CALCULATED m_item < 1.3 THEN 'BAD'
				WHEN CALCULATED m_item < 2.3 THEN 'SOSO'
				ELSE 'GOOD'
			END AS grp
		FROM sh.company ;
QUIT;



/*p.28*/
PROC SQL ;
			SELECT *
			FROM sh.company
			ORDER BY age ;
QUIT ;

PROC SQL ;
		SELECT age, count(*) "응답자수" ,
					sum(item1) "합(item1)" ,
					sum(item1) "합(item1)" ,
					sum(item1) "합(item1)"
		FROM sh.company
		GROUP BY age ;
QUIT ;
