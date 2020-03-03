LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN;);

/*���� ������(N)�̸� �⺻��跮�� ����ϰ�, ������(C)�̸� ����ǥ�� ����ϴ� ��ũ�� ���α׷��� �ۼ��Ͻÿ�.

���� : �����ͼ¸�, ��������Ʈ, ����
���õ����� : 
  ��1) sh.company item1-item3 N
  ��2) sh.company age*type C*/
%MACRO sel_n_c (dsn, var, tp) ;

	%IF &tp = N %THEN %DO ;
		PROC MEANS DATA= &dsn. ;
				VAR &var. ;
		RUN ;
	%END ;
	%ELSE %DO ;
		PROC FREQ DATA= &dsn. ;
				TABLES &var. ;
		RUN ;
	%END ;

%MEND sel_n_c ;
%sel_n_c (sh.company, item1-item3, N) ;
%sel_n_c (sh.company, age*type, C) ;

%MACRO make_dsn (name, cnt) ;
	%DO i=1 %TO &cnt. ;
	DATA &name.&i. ;
		DO i = 1 TO &cnt. ;
			Rand = INT (ranuni( &cnt. +i) * 5) + 1  ;
			OUTPUT ;
		END ;
	RUN ;
	PROC PRINT ; RUN ;
	%END ;
%MEND make_dsn ;
%make_dsn (RANDOM,5) ;

%MACRO dsn(n) ;
	%DO k=1 %TO &n. ;
		NAME&k.
	%END ;
%MEND dsn ;

DATA %dsn(10) ;
	DO i = 1 TO 100 ;
		x = INT(RANUNI(i)*7) +1 ;
		y = INT(RANUNI(i)*7) +1 ;
		OUTPUT ;
	END ;
RUN ;
