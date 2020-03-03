LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN:);

PROC SQL ;
	CREATE TABLE sumitem1 AS
	SELECT *,
			SUM(item1, item2, item3) as s_item ,
			MEAN(item1, item2, item3) as m_item
					LABEL='�׸����' FORMAT=5.2
	FROM sh.company
	WHERE age>1 AND MEAN(item1, item2, item3)>1.0 ;
	SELECT * FROM sumitem1 ;
QUIT ;

PROC SQL ;
	CREATE TABLE sumitem2 AS
	SELECT type, COUNT(*) AS resp LABEL='�����ڼ�',
			AVG(item1) AS m_item1 LABEL='1���׸�' FORMAT=5.2,
			AVG(item2) AS m_item2 LABEL='2���׸�' FORMAT=5.2,
			AVG(item3) AS m_item3 LABEL='3���׸�' FORMAT=5.2
	FROM sh.company
	GROUP BY type ;
	SELECT * FROM sumitem2 ;
QUIT ;

PROC SQL ;
	CREATE TABLE sh.kbl0702N AS
	SELECT posi, COUNT(*) AS player LABEL='������',
				AVG(freeth/freetry) AS freelr LABEL='������������' FORMAT=5.2
	FROM sh.kbl0702
	GROUP BY posi ;
	SELECT * FROM sh.kbl0702N ;
QUIT ;

PROC SQL ;
	CREATE TABLE player AS
		SELECT *,
				suc2p/try2p AS suc2r LABEL='2����������' FORMAT=5.2,
				suc3p/try3p AS suc3r LABEL='3����������' FORMAT=5.2
		FROM sh.player0607 ;
		SELECT * FROM player ;
QUIT ;

PROC SQL ;
	CREATE VIEW vplayer AS
		SELECT *,
				suc2p/try2p AS suc2r LABEL='2��������' FORMAT=5.2,
				suc3p/try3p AS suc3r LABEL='3��������' FORMAT=5.2
		FROM sh.player0607 ;
		SELECT * FROM vplayer ;
QUIT ;

DATA tA ;
		INPUT id price ;
	CARDS ;
1 100
2 200
; RUN ;
PROC PRINT ; RUN ;
DATA tB ;
		INPUT id name $ price ;
	CARDS ;
1 ���� 100
2 ���찳 200
3 �� 300
; RUN ;
PROC PRINT ; RUN ;

/*cross join*/
PROC SQL ;
CREATE TABLE tAB AS
	SELECT a.id AS aid, a.price AS apr, b.id AS bid, name, b.price AS bpr
	FROM tA a, tB b ;
SELECT * FROM tAB ;
QUIT ;

/*inner join*/
PROC SQL ;
CREATE TABLE iAB1 AS
	SELECT a.id AS aid, a.price AS apr, b.id AS bid, name, b.price AS bpr
	FROM tA a, tB b
	WHERE a.id=b.id ;
SELECT * FROM iAB1 ;

CREATE TABLE iAB2 AS
	SELECT a.id AS aid, a.price AS apr, b.id AS bid, name, b.price AS bpr
	FROM tA a INNER JOIN tB b
	ON a.id=b.id ;
SELECT * FROM iAB2 ;
QUIT ;
