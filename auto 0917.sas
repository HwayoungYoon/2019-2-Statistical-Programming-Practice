LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN:);
DATA sh.company ;
	INFILE 'C:\DATA\company_201909.txt' ;
	/* 순서 :  id age type q01~q12 */
	INPUT	id $     1-2
			    age    4-4 /* 4 */
			    type $ 6 @8
			    (q01-q12) (1.)	; /* 문자형으로 바꾸고 싶다면 ( $ 1.) */
	m_item =MEAN(OF q01-q12) ;
RUN;
PROC PRINT DATA=sh.company ;
		VAR id age type q01-q12 m_item ;
RUN;
/* PROC PRINT ; RUN; 만 써도 가능 */
PROC FREQ ;
		TABLES age type q01-q12 ;
RUN;
PROC MEANS ;
		VAR q01-q12 ;
RUN;
PROC MEANS MEAN STD maxdec=2  ;
		VAR q01-q12 ;
RUN;
PROC MEANS MEAN STD maxdec=2  ;
		CLASS type ;
		VAR q01-q12 ;
RUN;
