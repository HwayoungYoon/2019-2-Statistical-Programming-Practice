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
FOOTNOTE1 "Note : 응답자중 &n_f. 명은 여자임. " ;
FOOTNOTE2 "Note : 남자의 비율은 &r_m. 임." ;
FOOTNOTE3 ;
PROC PRINT; RUN;

%PUT &n_F &n_M ;

DATA company ; SET sh.company ; LENGTH om $ 100 ;
	IF type='M' THEN DO ;
		nM +1 ;
		om="남자"|| SYMGET('n_M')||" 명 중에 "||left(nM)||"번째" ;
	END ;
	ELSE DO ;
		nF +1 ;
		om="여자 "|| SYMGET('n_F')||" 명 중에 "||left(nF)||"번째" ;
	END ;
RUN ;
PROC PRINT ; RUN ;
