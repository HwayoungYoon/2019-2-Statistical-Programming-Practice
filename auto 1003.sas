LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN:);


LIBNAME sh 'C:\DATA' ;

DATA sh.patient ;
		INFILE 'C:\DATA\patient.txt' ;
		INPUT userno 4. type $1. age 2. ;
RUN ;
PROC PRINT ; RUN ;

DATA sh.measure ;
		INFILE 'C:\DATA\measure.txt' ;
		INPUT userno 1-4 weight 6-7 press 9-11 ;
				LABEL weight='몸무게' press='수축기 혈압' ;
RUN ;
PROC PRINT ; RUN ;


DATA p_m ;
		SET sh.patient sh.measure ;
RUN ;
PROC PRINT ; RUN ;

DATA merge_p_m ;
		MERGE sh.patient sh.measure ;
RUN ;
PROC PRINT ; RUN ;


PROC SORT DATA=sh.patient OUT=patientR ;
		BY userno ;
RUN ;
PROC PRINT ; RUN ;

PROC SORT DATA=sh.measure OUT=measureR ;
		BY userno ;
RUN ;
PROC PRINT ; RUN ;


DATA Setby_p_m ;
		SET patientR measureR ;     BY userno ;
RUN ;
PROC PRINT ; RUN ;

DATA Mergeby_p_m ;
		MERGE patientR measureR ;     BY userno ;
RUN ;
PROC PRINT ; RUN ;

/* 다양한 입력문 
1
Last_nm$ first_nm$ ;
2
Last_nm$15. first_nm$ ;
3
Last_nm$13. first_nm$CHAR6. ;
4
Last_nm& $15. first_nm$6. ;
*/
DATA one ;
		INFILE cards ;
		LENGTH last_nm $15 first_nm $8 ;
		INPUT Last_nm $13. first_nm $CHAR6. ;
	CARDS ;
	MC   Allister   Mike
	Longlast    Johnson
	Longlastname     Joanna
	Christopher   Norlan
;
RUN ;
PROC PRINT ; RUN ;


OPTIONS YEARCUTOFF=2000 ;
DATA testdate ;
INFILE CARDS ;
INPUT indatebirth date9. ;
start = 1 ;
end = start + 1 ;
two_date= '13AUG67'D ;
four_date= '13AUG1967'D ;
CARDS ;
0 13AUG67
1 13AUG1967
;
RUN;
PROC PRINT ; RUN ;

PROC PRINT ;
	FORMAT indate birth yymmdd10.
					start end date9.
					two_date four_date mmddyy10. ;
RUN ;
