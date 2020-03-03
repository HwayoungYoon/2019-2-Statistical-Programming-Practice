LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN;);

DATA test ;
		DATE="&sysdate" ;
		TIME="&systime" ;
		DAY="&SYSday" ;
RUN ;
TITLE "&SYSDATE &SYSTIME &SYSDAY" ;
PROC PRINT ; RUN ;

TITLE ;
DATA sh.company (DROP= rM nM nF) ;
	INFILE 'C:\DATA\company.txt' END=LAST ;
	INPUT id 1-2 age 3 type $ 4 item1 5 item2 6 item3 7 ;
	IF type='F' THEN nF + 1 ; ELSE nM +1 ;
	IF LAST THEN DO ;
		rM = PUT(nM / _N_, PERCENT5. ) ;
		CALL SYMPUT('r_m',rM) ;
		CALL SYMPUT('n_m',nM) ;
		CALL SYMPUT('n_f',nF) ;
	END ;
RUN ;
FOOTNOTE1 "Note : �������� &n_f. ���� ������. " ;
FOOTNOTE2 "Note : ������ ������ &r_m. ��." ;
FOOTNOTE3 ;
PROC PRINT; RUN;

%PUT &n_F &n_M ;

DATA company ; SET sh.company ; LENGTH om $ 100 ;
	IF type='M' THEN DO ;
		nM +1 ;
		om="����"|| SYMGET('n_M')||" �� �߿� "||left(nM)||"��°" ;
	END ;
	ELSE DO ;
		nF +1 ;
		om="���� "|| SYMGET('n_F')||" �� �߿� "||left(nF)||"��°" ;
	END ;
RUN ;
PROC PRINT ; RUN ;
