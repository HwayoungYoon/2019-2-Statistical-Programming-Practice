LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN:);

LIBNAME ss 'C:\DATA' ;
DATA		sh.company ;
		INFILE		'C:\DATA\company_201909.txt' ;
		INPUT		id 1-2 age 4 type $ 6
						@8 (item01-item12)(1.) ;
						m_item=mean(of item01-item12) ;
/*		LABEL		id='고객번호'
						age='나이' type='성별'
						 item01='좋은..'
						 item02='소비자..'
						 item03='신뢰..' */
RUN ;
PROC PRINT ; RUN;

DATA company ; SET sh.company ;
		IF item02=. THEN item02=0 ;
		IF item03=. THEN item03=0 ;
		SELECT (item10) ;
			WHEN(4) item10=1 ;
			WHEN(5) item10=2 ;
			WHEN(6) item10=3 ;
			OTHERWISE ;
		END ;
RUN ;
TITLE ' RECORD ' ;
PROC PRINT ; RUN;
