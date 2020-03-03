LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN:);

LIBNAME  sh 'C:\DATA' ;
DATA    sh.company ;
    INFILE   'C:\DATA\company_201909.txt'  ; 
    INPUT   id  1-2   age 4    type $ 6 
            item1 8   item2 9  item3 10 ;
			m_item=mean(of item1-item3) ;
    LABEL   id='고객번호' age='나이' type='성별'
            item1='좋은 제품을 만들기 ..'
            item2='소비자를 중요하게 ..'
            item3='신뢰할만한 기업이다'   ;
RUN;

TITLE "원데이터 출력하기" ;

PROC PRINT ;
RUN;

/* 출력 유형 만들기 */

PROC FORMAT lib=sh ;
     VALUE $type 'M'='남자'  'F'='여자' ;
     VALUE age   1='20대' 2='30대'   3='40대'
                 4='50대' 5='60대이상' ;
     VALUE item  1='예'   2='보통'   3='아니오'
                 .='무응답' ;
RUN;

PROC PRINT;  RUN ;

PROC MEANS DATA=sh.company  ;
     CLASS TYPE ;
	 VAR   item1-item3 m_item ;
RUN;




PROC MEANS DATA=sh.company SUM MEAN ;
CLASS type ;
VAR   item1-item3 ;
OUTPUT OUT=compamyS SUM=s1-s3 MEAN=m1-m3 ;
RUN;
PROC PRINT;RUN;

DATA companys2 ;    SET sh.company END=eof ;
    n_t + 1 ;
    sumt1 + item1 ; sum2 + item2 ;  sumt3 + item3 ;
IF type='M' THEN DO ;
    n_m +1 ;    sm1 + item1 ;   sm2 + item2 ;   sm3 + item3 ;
END ;
ELSE DO ;
    n_f +1 ;    sf1 + item1 ;   sf2 + item2 ;   sf3 + item3 ;
END ;

IF eof THEN DO ;
    mt1=sumt1/n_t ; mt2=sumt2/n_t ; mt3=sumt3/n_t ;
    mmt1=sm1/n_m ; mmt2=sm2/n_m ; mmt3=sm3/n_m ;
    mft1=sf1/n_f ; mft2=sf2/n_f ; mft3=sf3/n_f ;
OUTPUT ;
END ;
    DROP id age type item1 item2 item3 ;
RUN;
PROC PRINT ; RUN ;

/* ? 다시 */
DATA companys2_1 ;    SET sh.company END=eof ;
    n_t + 1 ;
    sumt1 + item1 ; sum2 + item2 ;  sumt3 + item3 ;
IF type='M' THEN DO ;
    n_m +1 ;    sm1 + item1 ;   sm2 + item2 ;   sm3 + item3 ;
END ;
ELSE DO ;
    n_f +1 ;    sf1 + item1 ;   sf2 + item2 ;   sf3 + item3 ;
END ;

IF eof THEN DO ;
    type='TOTAL' ; mt1=sumt1/n_t ; mt2=sumt2/n_t ; mt3=sumt3/n_t ;  nobs=n_t ;
    type='M' ; mt1=sm1/n_m ; mt2=sm2/n_m ; mt3=sm3/n_m ;    nobs=n_m ;
    type='F' ; mt1=sf1/n_f ; mt2=sf2/n_f ; mt3=sf3/n_f ;    nobs=n_f ;
END ;
    KEEP type nobs mt1 mt2 mt3 ;
RUN;
PROC PRINT ; RUN ;

/* .. */

PROC SORT DATA=sh.company OUT=companyR ;
    BY type ;
RUN ;

DATA comR ; SET companyR ;  BY type ;
    IF first.type THEN DO ;
        SUM1=0 ;    SUM2=0 ;    SUM3=0 ;    NOBS=0 ;
    END ;
    SUM1+item1 ;    SUM2+item2 ;    SUM3+item3 ;    NOBS+1 ;
    IF last.type THEN DO ;
        m1=sum1/nobs ;  m2=sum2/nobs ;  m3=sum3/nobs ;
        OUTPUT ;
    END ;
    DROP id age item1-item3 ;
RUN ;
PROC PRINT ; RUN ;
