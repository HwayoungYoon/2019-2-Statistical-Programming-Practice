LIBNAME sh 'C:\DATA' ;
%LET pr = %STR(PROC PRINT; RUN;);

PROC SQL ;
	SELECT * FROM sh.kbl0612 ;
	SELECT * FROM sh.kbl0702 ;
	SELECT * FROM sh.player0607 ;
QUIT ;
PROC SQL ;
	SELECT a.team, a.name, a.score ,
				b.suc2p / b.try2p AS p2rate
	FROM sh.kbl0612 AS a , sh.player0607 AS b
	WHERE a.score > (SELECT MEAN(score) FROM sh.kbl0612)
		AND a.name=b.name ;
QUIT ; /*실습문제1*/
PROC SQL ;
	SELECT a.team, a.name, a.score ,
				(SELECT MEAN(score) FROM sh.kbl0612) ,
				b.suc2p / b.try2p AS p2rate
	FROM sh.kbl0612 AS a , sh.player0607 AS b
	WHERE a.score > (SELECT MEAN(score) FROM sh.kbl0612)
		AND a.name=b.name ;
QUIT ; /*실습문제1-스칼라 서브쿼리*/

PROC SQL ;
	SELECT a.team, a.name, a.score, b.suc3p/b.try3p AS p3rate
	FROM sh.kbl0612 AS a, sh.player0607 AS b
	WHERE a.team in
				(SELECT DISTINCT team FROM sh.kbl0612 WHERE score GE 30)
		AND a.name=b.name ;
QUIT ; /*실습문제3*/


PROC SQL ;
	SELECT a.team, a.name, a.score, a.score - MEAN(score) AS m_diff,
					b.t_score, a.score - b.t_score AS t_diff
	FROM sh.kbl0612 AS a, 
		(SELECT team, MEAN(score) AS t_score FROM sh.kbl0612 GROUP BY team) AS b
	WHERE a.team=b.team ;
QUIT ; /*인라인뷰*/

PROC SQL ;
	SELECT a.team, a.name, a.score, a.score - MEAN(score) AS m_diff,
					(SELECT MEAN(score) AS t_score FROM sh.kbl0612 WHERE a.team=team GROUP BY team),
					a.score - (SELECT MEAN(score) AS t_score FROM sh.kbl0612 WHERE a.team=team GROUP BY team) AS t_diff
	FROM sh.kbl0612 AS a ;
QUIT ; /*전체 아닌 필요한 값만 가져옴*/

/*실습문제5 각자 풀래 난 못해 안해 졸려*/
PROC SQL ;
CREATE TABLE player0612 AS
	SELECT a.name, b.team, a.suc2p, a.try2p, a.suc2p/a.try2p AS suc2r FORMAT=percent5.
	FROM sh.player0607 AS a, sh.kbl0612 AS b
	WHERE a.name=b.name ;
CREATE TABLE team0612 AS
	SELECT b.team, sum(a.suc2p) AS ssuc2p, sum(a.try2p) AS stry2p, sum(a.suc2p)/sum(a.try2p) AS ssuc2r FORMAT=percent5.
	FROM sh.player0607 AS a, sh.kbl0612 AS b
	WHERE a.name=b.name
	GROUP BY team ;
CREATE TABLE team0612 AS
	SELECT team, sum(suc2p) AS ssuc2p, sum(try2p) AS stry2p, sum(suc2p)/sum(try2p) AS ssuc2r FORMAT=percent5.
	FROM player0612
	GROUP BY team ;
CREATE TABLE t_diff_p AS
	SELECT a.name, a.team, a.suc2r, b.ssuc2r, a.suc2r-b.ssuc2r AS diff
	FROM player0612 AS a, team0612 AS b
	WHERE a.team=b.team ;
SELECT * FROM t_diff_p ;
QUIT ;
PROC SQL ;
SELECT x.name, x.team, x.suc2r, y.ssuc2r, x.suc2r - y.ssuc2r AS diff
FROM (SELECT a.name, b.team, a.suc2p, a.try2p, a.suc2p/a.try2p AS suc2r FORMAT=percent5.
			FROM sh.player0607 AS a, sh.kbl0612 AS b
			WHERE a.name=b.name) AS x,
			(SELECT b.team, sum(a.suc2p) AS ssuc2p, sum(a.try2p) AS stry2p, sum(a.suc2p)/sum(a.try2p) AS ssuc2r FORMAT=percent5.
			FROM sh.player0607 AS a, sh.kbl0612 AS b
			WHERE a.name=b.name
			GROUP BY team) AS y
WHERE x.team=y.team ;
QUIT ;



/*sas macro*/
%LET char = 테스트 ;
%LET num = 12345  ;
%LET sum =  4+3  ;
DATA mactest ;
	char1= '&char'  ;
	char2= "&char"  ;
	num1 = &num + 1 ;
	num2 = &sum + 1 ;
RUN ;
PROC PRINT; RUN ;
