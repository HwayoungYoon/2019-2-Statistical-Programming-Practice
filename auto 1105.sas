LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN;);

/*실습1*/
/*테이블 생성*/
DATA tableA ;
	INPUT id price ;
CARDS ;
1 100
2 200
 ; RUN ;
 PROC PRINT ; RUN ;
DATA tableB ;
	INPUT id name $ ;
CARDS ;
1 연필
2 지우개
3 자
 ; RUN ;
PROC PRINT ; RUN ;

/*p.37
a.id*10+b.id as Nid  => compress(a.id)||compress(b.id) */
PROC SQL ;
	SELECT a.id*10+b.id as Nid , a.price, b.name
	FROM tableA a, tableB b ;
QUIT ;

/*실습2*/
/*테이블 생성*/
DATA tableA ;
	INPUT id kind $ price ;
CARDS ;
1 1호 100
2 2호 200
 ; RUN ;
 PROC PRINT ; RUN ;
DATA tableB ;
	INPUT id name $ price ;
CARDS ;
1 연필 100
2 지우개 200
3 자 300
 ; RUN ;
PROC PRINT ; RUN ;
/*p.38*/
PROC SQL ;
	SELECT b.id*10+a.id as newID, b.name||a.kind as newitem, b.price+a.price as price
	FROM tableA as a, tableB as b ;
QUIT ;
PROC SQL ;
CREATE TABLE newtable AS
	SELECT b.id*10+a.id as newID, b.name||a.kind as newitem, b.price+a.price as price
	FROM tableA as a, tableB as b ;
SELECT * FROM newtable ;
QUIT ;

/*실습3*/
/*p.40*/
PROC SQL ;
	SELECT b.id*10+a.id as newID, b.name||a.kind as newitem, b.price+a.price as price
	FROM tableA as a, tableB as b
	WHERE a.id=b.id ;
QUIT ;
PROC SQL ;
	SELECT b.id*10+a.id as newID, b.name||a.kind as newitem, b.price+a.price as price
	FROM tableA as a INNER JOIN tableB as b
	ON a.id=b.id ;
QUIT ;

/*실습4*/
/*테이블 생성*/
DATA tableA ;
	INPUT id kind $ price ;
CARDS ;
1 1호 100
2 2호 200
4 4호 300
 ; RUN ;
 PROC PRINT ; RUN ;
DATA tableB ;
	INPUT id name $ price ;
CARDS ;
1 연필 100
2 지우개 200
3 자 300
5 각도기 500
 ; RUN ;
PROC PRINT ; RUN ;
/*p.42*/
PROC SQL ;
	SELECT a.id, a.kind||b.name as Nname, a.price
	FROM tableA as a LEFT JOIN tableB as b
	ON a.id=b.id ;
QUIT ;
/*p.44*/
PROC SQL ;
	SELECT b.id, b.name||a.kind as Nname, SUM(a.price, b.price) as newp
	FROM tableA as a RIGHT JOIN tableB as b
	ON a.id=b.id ;
QUIT ;
/*p.46*/
PROC SQL ;
	SELECT put(a.id,1.)||put(b.id,2.) as newid, b.name||a.kind as Nname, SUM(a.price, b.price) as newp
	FROM tableA as a FULL JOIN tableB as b
	ON a.id=b.id ;
QUIT ;
PROC SQL ;
	SELECT COALESCE(a.id,b.id) as newid, b.name||a.kind as Nname, SUM(a.price, b.price) as newp
	FROM tableA as a FULL JOIN tableB as b
	ON a.id=b.id ;
QUIT ;
