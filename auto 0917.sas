LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN:);
DATA sh.company ;
	INFILE 'C:\DATA\company_201909.txt' ;
	/* ���� :  id age type q01~q12 */
	INPUT	id $     1-2
			    age    4-4 /* 4 */
			    type $ 6 @8
			    (q01-q12) (1.)	; /* ���������� �ٲٰ� �ʹٸ� ( $ 1.) */
	m_item =MEAN(OF q01-q12) ;
RUN;
PROC PRINT DATA=sh.company ;
		VAR id age type q01-q12 m_item ;
RUN;
/* PROC PRINT ; RUN; �� �ᵵ ���� */
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
