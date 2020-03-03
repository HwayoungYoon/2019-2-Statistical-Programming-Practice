/* �� �������� ������ ���� */
LIBNAME OUT 'C:\DATA\' ;
DATA out.dis1 ;
	INFILE 'C:\DATA\discount_1.txt' ;
	INPUT name $ birth 8-13  type $ call 11.  mem 5. @34 bar @44 num ;
	FORMAT birth z6. call z11. mem z5. ;
RUN ;
PROC PRINT ; RUN ;
DATA out.pnt1 ;
	INFILE 'C:\DATA\point_1.txt' ;
	INPUT  name $ birth 8-13  type $ call 11.  mem 5. @34 bar ;
	FORMAT birth z6. call z11. mem z5. ;
RUN ;
PROC PRINT ; RUN ;

/* �м� ��  ���ȭ */
PROC SQL ;
	CREATE TABLE out.bum AS
	SELECT b.name, b.birth, b.type, b.call
	FROM out.pnt1 as A, out.dis1 as B
	WHERE A.bar = B.bar
	AND   b.num=10 ;
	SELECT  *, name||" �� ���������� �ҹ��Դϴ�"
	FROM out.bum ; 
QUIT ;
DATA _NULL_ ;
	SET out.bum		END=last ;
	N + 1 ;
	IF last ;
		call symput('name',name) ;
		call symput('no', n-1 ) ;
RUN;
FOOTNOTE  " &name. (�� &no.��)�� ���������� �ҹ��Դϴ�. " ;
PROC PRINT DATA=out.bum ;  RUN ;
FOOTNOTE ;

/*MACRO*/
%MACRO ill(dsn1,dsn2) ;

PROC SQL ;
	CREATE TABLE &dsn1.out AS
	SELECT b.name, b.birth, b.type, b.call
	FROM &dsn1. as A, &dsn2. as B
	WHERE A.bar = B.bar
	AND   b.num=10 ;
	SELECT  *, name||" �� ���������� �ҹ��Դϴ�"
	FROM &dsn1.out ; 
QUIT ;
DATA _NULL_ ;
SET &dsn1.out		END=last ;
	N + 1 ;
	IF last ;
		call symput('name',name) ;
		call symput('no', n-1 ) ;
RUN ;
FOOTNOTE  " &name. (�� &no.��)�� ���������� �ҹ��Դϴ�. " ;
PROC PRINT DATA=&dsn1.out ; RUN ;
FOOTNOTE ;

%MEND ill ;

%ill(out.pnt1,out.dis1) ;
