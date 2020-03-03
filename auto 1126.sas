LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN;);

DATA sh.kbl0612 ;	SET sh.kbl0612 ;
	LENGTH newtm $ 8 ;
	SELECT(team) ;
		WHEN('대우') newtm='daewoo' ;
		WHEN('기아') newtm='kia' ;
		WHEN('삼성') newtm='samsung' ;
		WHEN('나래') newtm='narae' ;
		WHEN('나산') newtm='nasan' ;
		OTHERWISE    newtm='dongyang' ;
	END ;
RUN ;
PROC PRINT ; RUN ;

DATA sh.kbl0702 ;	SET sh.kbl0702 ;
	LENGTH newtm $ 8 ;
	SELECT(team) ;
		WHEN('대우') newtm='daewoo' ;
		WHEN('기아') newtm='kia' ;
		WHEN('삼성') newtm='samsung' ;
		WHEN('나래') newtm='narae' ;
		WHEN('나산') newtm='nasan' ;
		OTHERWISE    newtm='dongyang' ;
	END ;
RUN ;
PROC PRINT ; RUN ;



PROC SORT DATA=sh.kbl0612 OUT=kbl0612 ;
		BY team ;
RUN ;

/*전체 합산값*/
PROC MEANS DATA=kbl0612 SUM ;
		VAR score ;
		OUTPUT OUT=t0612 SUM=sumT ;
RUN ;

/*팀별 합산값*/
PROC MEANS DATA=kbl0612 SUM	NWAY ;
		CLASS team ;
		VAR score ;
		OUTPUT OUT=s0612 SUM=sumS ;
RUN ;

DATA kbl0612 ; MERGE kbl0612 t0612 ;
		scoTot = score / sumT ;
RUN ;
DATA kbl0612 ; MERGE kbl0612 s0612 ;
		BY team ;
		scoTeam = score / sumS ;
RUN ;
PROC PRINT ; RUN ;



/*그룹별 정렬*/
PROC SORT DATA=sh.kbl0612 OUT=kbl0612 ;
		BY newtm ;
RUN ;
DATA kbl0612 ; SET kbl0612 ; FLAG=1 ; RUN ;
PROC PRINT ; RUN ;

/*전체 합산값과 병합*/
PROC MEANS DATA=kbl0612 SUM ;
		VAR score ;
		OUTPUT OUT=t0612 SUM=sumT ;
RUN ;
DATA t0612 ; SET t0612 ; FLAG=1 ; RUN ;
DATA kbl0612 ; MERGE kbl0612 t0612 ;
		BY flag ;
		scoTot = score / sumT ;
RUN ;
PROC PRINT ; RUN ;

/*팀별 합산값과 병합*/
PROC MEANS DATA=kbl0612 SUM	NWAY ;
		CLASS newtm ;
		VAR score ;
		OUTPUT OUT=s0612 SUM=sumS ;
RUN ;
PROC PRINT ; RUN ;

DATA kbl0612 ; MERGE kbl0612 s0612 ;
		BY newtm ;
		scoTeam = score / sumS ;
RUN ;
PROC PRINT ; RUN ;



PROC SORT DATA=sh.kbl0612 OUT=k0612 ;
		BY newtm ;
RUN ;
PROC PRINT ; RUN ;

PROC MEANS DATA=kbl0612 SUM ;
		CLASS newtm ;
		VAR score ;
		OUTPUT OUT=ts0612 SUM=sumS ;
RUN ;
PROC PRINT ; RUN ;

DATA _NULL_ ; SET ts0612 ;
	IF newtm=' ' THEN CALL SYMPUT('tot' , sumS) ;
						ELSE CALL SYMPUT(newtm, sumS) ;
RUN ;
%PUT &tot &kia ;

DATA k0612 ; SET k0612 ;
		scoTot = score / symget('tot') ;
		scoTeam = score / symget(newtm) ;
RUN ;
PROC PRINT ; RUN ;



PROC MEANS DATA=sh.kbl0612 ;
		VAR score ;
RUN ;

/*0612*/
PROC MEANS DATA=sh.kbl0612 ;
		CLASS team ;
		VAR score ;
RUN ;
/*0702*/
PROC MEANS DATA=sh.kbl0702 ;
		CLASS team ;
		VAR score ;
RUN ;

/*매크로*/
%MACRO bstat (dsn) ;
	PROC MEANS DATA=&dsn. ;
			CLASS team ;
			VAR score ;
	RUN ;
%MEND ;
%bstat (dsn=sh.kbl0702) ;

%MACRO bstat (dsn, stat) ;
	PROC MEANS DATA=&dsn. ;
			CLASS team ;
			VAR &stat. ;
	RUN ;
%MEND ;
%bstat (dsn=sh.kbl0702, stat=reb) ;

%MACRO bstat (dsn, grp, stat) ;
	PROC MEANS DATA=&dsn. ;
			CLASS &grp. ;
			VAR &stat. ;
	RUN ;
%MEND ;
%bstat (sh.kbl0702, newtm, score) ;
%bstat (dsn=sh.kbl0612, grp=newtm, stat=score) ;

%MACRO bchk (dsn, stat) ;
	PROC MEANS DATA=&dsn. ;
			VAR &stat. ;
	RUN ;
%MEND ;
%bchk (dsn=sh.kbl0702, stat=_NUMERIC_) ;
%bchk (dsn=sh.company, stat=item1-item3) ;



%MACRO meanc (dsn, grp, stat) ;
	PROC MEANS DATA=&dsn. NOPRINT NWAY ;
			CLASS &grp. ;
			VAR &stat. ;
			OUTPUT OUT=&dsn.out
									N=N  SUM=SUM MEAN=MEAN
									STD=STD MIN=MIN MAX=MAX ;
	RUN ;
	PROC PRINT ; RUN ;
%MEND ;
%meanc (sh.kbl0612, team, score) ;
%meanc (sh.kbl0702, team, score) ;

DATA new ; SET sh.kbl0612out (IN=INA)
							sh.kbl0702out ;
		BY team ;
		IF INA THEN dsn="sh.kbl0612out" ;
					ELSE dsn="sh.kbl0702out" ;
RUN ;
PROC PRINT ; RUN ;

%MACRO setdsn (dsn1, dsn2, grp, newdsn) ;
	DATA &newdsn ; SET &dsn1. (IN=INA)
										&dsn2. ;
			BY &grp. ;
			IF INA THEN dsn="&dsn1." ;
						ELSE dsn="&dsn2." ;
	RUN ;
PROC PRINT ; RUN ;
%MEND ;
%setdsn (sh.kbl0612out, sh.kbl0702out, team, sh.dsntotal) ;

%MACRO setd (dsn1, dsn2, grp, newdsn) ;
%meanc (&dsn1, &grp, score) ;
%meanc (&dsn2, &grp, score) ;
	DATA &newdsn ; SET &dsn1.out (IN=INA)
										&dsn2.out ;
			BY &grp. ;
			IF INA THEN dsn="&dsn1." ;
						ELSE dsn="&dsn2." ;
	RUN ;
PROC PRINT ; RUN ;
%MEND ;
%setd (sh.kbl0612, sh.kbl0702, team, sh.dsntotal2) ;
