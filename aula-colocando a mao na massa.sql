create table Alunos(
	id int primary key identity,
	nome varchar(80) not null,
	cpf char(11) not null,
	cidade varchar(60) not null,
	estado char(2) not null,
	data_nascimento date,
	ativo bit default 1
)

create table Categorias(
	id int primary key identity,
	descricao varchar(80) not null,
	cadastrado_em datetime default getdate()
)

create table Cursos(
	id int primary key identity,
	categoria_id int not null,
	descricao varchar(80) not null,
	total_horas int not null,
	valor decimal(12,2) not null default 0,
	cadastrado_em datetime default getdate(),
	ativo bit default 1,
	constraint fk_categoria_id foreign key(categoria_id) references Categorias(id)
)


/* Tabela associativa */
create table Alunos_Cursos(
	aluno_id int not null,
	curso_id int not null,
	cadastrado_em datetime default getdate(),
	constraint pk_alunos_cursos primary key (aluno_id, curso_id),
	constraint fk_aluno_id foreign key (aluno_id) references Alunos(id),
	constraint fk_curso_id foreign key (curso_id) references Cursos(id)
)

INSERT INTO Alunos(nome, cpf, cidade,estado,data_nascimento) VALUES
('Rafael', '00000000001','Aracaju', 'SE', '2000-01-01'),
('Eduardo', '00000000002','Sao Paulo', 'SP', '2000-02-02'),
('Bruno', '00000000003','Sao Paulo', 'SP', '2000-03-03'),
('Tiago', '00000000004','Rio de Janeiro', 'RJ', '2000-04-04'),
('Heloysa', '00000000005','Aracaju', 'SE', '2000-05-05');



INSERT INTO Categorias (descricao) VALUES 
('Acesso a Dados'),
('Seguranca'),
('Web')

INSERT INTO Cursos(descricao, categoria_id, total_horas, valor) VALUES 
('EF Core', 1, 17, 300),
('SQL Serrver', 1, 5, 200),
('ASP.NET Core Enterprise', 3, 5, 200),
('Fundamentos de IdentityServer4', 2, 5, 200);


INSERT INTO Alunos_Cursos (aluno_id, curso_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 1),
(4, 4),
(5, 1),
(5, 2),
(5, 3);


/* DISTINCT */
SELECT DISTINCT CIDADE, ESTADO 
  FROM ALUNOS;


/* ORDER BY */
SELECT * 
  FROM ALUNOS A
  ORDER BY A.nome ASC;

  SELECT * 
  FROM ALUNOS A
  ORDER BY A.nome ASC, cpf DESC, estado ASC;

  SELECT * 
  FROM ALUNOS A
  ORDER BY 4 ASC; -- posso usar o indice da coluna no lugar do nome da mesma



  /* TOP/FETCH */

  /* TOP(informa a enginee do bd quantidade de registros devem ser retornados) */
  SELECT TOP 3 *
    FROM ALUNOS
   ORDER BY ID;

   SELECT TOP 40 Percent *
    FROM ALUNOS
   ORDER BY ID;

  --SELECT *
  --  FROM ALUNOS
  -- ORDER BY ID Limit 100;  -- forma em outras bases de dados

  /* OFF SET (PULA A QUANTIDADE DE LINHAS INFORMADAS NA CONSULTA )  */
  SELECT *
    FROM ALUNOS
   ORDER BY ID
   OFFSET 2 ROWS;


   /* FETCH (USADA COM PAGINACAO)  */
  SELECT *
    FROM ALUNOS
   ORDER BY ID
   OFFSET  2 ROWS
   FETCH FIRST 2 ROWS ONLY;

   /* WHERE (USADO PARA APLICAR UM FILTRO NOS REGISTROS) */
   SELECT *
     FROM ALUNOS
	WHERE nome = 'RAFAEL';

	 SELECT *
     FROM ALUNOS
	WHERE nome LIKE 'RAFAEL';

   SELECT *
     FROM ALUNOS
	WHERE ID >= 3 ;


	/* AND/OR */

	SELECT * 
	  FROM ALUNOS
	 WHERE ID >= 3 AND (ESTADO = 'SP' or estado = 'RJ')


	 /* LIKE */
	 SELECT *
       FROM ALUNOS
	  WHERE nome LIKE 'RAFAEL';
	
   SELECT *
     FROM ALUNOS
	WHERE nome LIKE 'BR%';


	/* MAX/MIN */
	SELECT MAX(ID)
	  FROM Alunos;

	SELECT MIN(ID)
	  FROM Alunos;

    SELECT *
	  FROM Alunos
	 WHERE ID = (SELECT MAX(ID) FROM ALUNOS);


	 /* 
		COUNT - CONTAR REGISTROS EM UMA TABELA 
		SUM - SOMAR VALORES E DEVOLVER O RESULTADO
	 */

	 SELECT COUNT(*)
	   FROM Cursos
	  WHERE categoria_id = 1;

	 SELECT COUNT(*), SUM(TOTAL_HORAS)
	   FROM Cursos
	  WHERE categoria_id = 1;
	 
	  SELECT COUNT(*), SUM(TOTAL_HORAS), SUM(VALOR)
	   FROM Cursos
	  WHERE categoria_id = 1;
	 

	 /* 
		GROUP BY - AGRUPAMENTO DE INFORMACOES
	 */

	 SELECT CIDADE, ESTADO
	   FROM ALUNOS
	  GROUP BY CIDADE, ESTADO;

	 SELECT CIDADE, ESTADO, COUNT(*) REPETICOES
	   FROM ALUNOS
	  GROUP BY CIDADE, ESTADO;


	 /* 
		HAVING - COMPLEMENTO DO GROUP BY
	 */

	 SELECT CIDADE, ESTADO, COUNT(*) REPETICOES
	   FROM ALUNOS
	  GROUP BY CIDADE, ESTADO
	 HAVING COUNT(*) = 1;



	 /*
		IN - POSSIBILITA PASSAR UM ARRAY OU SUBSELECT PARA REALIZAR UMA CONSULTA
	 */

	 SELECT * 
	   FROM ALUNOS
	  WHERE ID IN (2,4);

	 SELECT * 
	   FROM ALUNOS
	  WHERE ID IN (SELECT ID FROM ALUNOS WHERE  ESTADO = 'SE');


/* BETWEEN */

 SELECT * 
   FROM ALUNOS
  WHERE ID BETWEEN 2 AND 4;



  /*  JOINS    */

  --INEER JOIN

  SELECT *
    FROM CURSOS CR
   INNER JOIN CATEGORIAS CA
      ON CA.ID = CR.CATEGORIA_ID;

  -- LEFT JOIN -- PRIORIDADE A TABELA DO LADO ESQUERDO

  --INSERT INTO CATEGORIAS(DESCRICAO) VALUES ('Categoria Teste');
  
  --SE EXISTIR UM CURSO COM ESSA CATEGORIA VC TRAZ, MAS SE NAO TIVER TRAZ A CATEGORIA
  --MESMO ASSIM
   SELECT CR.DESCRICAO CURSO, CA.DESCRICAO CATEGORIA
    FROM CATEGORIAS CA
    LEFT JOIN  CURSOS CR
      ON CA.ID = CR.CATEGORIA_ID;
	  


  -- RIGHT JOIN -- PRIORIDADE A TABELA DO LADO DIREITO
  --SE EXISTIR UM CURSO COM ESSA CATEGORIA VC TRAZ, MAS SE NAO TIVER TRAZ A CATEGORIA
  --MESMO ASSIM
   SELECT CR.DESCRICAO CURSO, CA.DESCRICAO CATEGORIA
    FROM CATEGORIAS CA
   RIGHT JOIN  CURSOS CR
      ON CA.ID = CR.CATEGORIA_ID;

  SELECT CR.DESCRICAO CURSO, CA.DESCRICAO CATEGORIA
    FROM CURSOS CR
   RIGHT JOIN  CATEGORIAS CA 
      ON CA.ID = CR.CATEGORIA_ID;


  -- FULL JOIN
  
   SELECT CR.DESCRICAO CURSO, CA.DESCRICAO CATEGORIA
    FROM CURSOS CR
   FULL JOIN  CATEGORIAS CA 
      ON CA.ID = (CR.CATEGORIA_ID+4);


  -- UNION / UNION ALL
  SELECT * FROM CURSOS WHERE ID=1
   UNION
  SELECT * FROM CURSOS WHERE ID=2;

  --NO CASO DO UNION COM VALORES DUPLICADOS ELE TRAZ APENAS 1 REGISTRO  
  SELECT DESCRICAO FROM CURSOS WHERE ID=1
   UNION
  SELECT DESCRICAO FROM CURSOS WHERE ID=2
   UNION
  SELECT 'VALOR DINAMICO'
   UNION
  SELECT 'VALOR DINAMICO';


  --NO UNION ALL ELE IGNORA O VALOR REPETIDO E RETORNA TUDO
  SELECT DESCRICAO FROM CURSOS WHERE ID=1
   UNION ALL
  SELECT DESCRICAO FROM CURSOS WHERE ID=2
   UNION ALL
  SELECT 'VALOR DINAMICO'
   UNION ALL
  SELECT 'VALOR DINAMICO';



  -- TRANSACTION
	BEGIN TRANSACTION

	UPDATE CATEGORIAS 
	   SET DESCRICAO = UPPER(DESCRICAO)
	 WHERE ID > 0;
	GO

	DELETE CATEGORIAS
	 WHERE ID = 4

	GO;

	--DESFAZ A TRANSACAO 
	ROLLBACK


	--COMMITA A TRANSACAO
	COMMIT;



	/* SAVE POINT - MARCAMOS UM PONTO PARA DESCARTAR AS ALTERACOES ATE ESTE PONTO */
	BEGIN TRANSACTION
	INSERT INTO CATEGORIAS(DESCRICAO, CADASTRADO_EM) VALUES ('CATEGORIA NOVA 1', GETDATE());
	INSERT INTO CATEGORIAS(DESCRICAO, CADASTRADO_EM) VALUES ('CATEGORIA NOVA 2', GETDATE());

	SAVE TRANSACTION ATUALIZACAO_POINT
	UPDATE CATEGORIAS
	   SET DESCRICAO = 'APLICACAO WEB'
	 WHERE DESCRICAO = 'WEB'

	GO

	ROLLBACK TRANSACTION ATUALIZACAO_POINT
	COMMIT;


	/*  FUNCTIONS  */

	/*
		BUILT-IN FUNCTIONS -> FUNCOES QUE O BD FORNECEM PARA UTILIZARMOS
		UDF(USER-DEFINED FUNCTION) -> FUNCOES CRIADAS PELOS USUARIOS
	*/

	SELECT LEFT(DESCRICAO, 4) FROM CATEGORIAS; -- LEFT()
	SELECT RIGHT(DESCRICAO, 4) FROM CATEGORIAS; --RIGHT()
	SELECT SUBSTRING(DESCRICAO, 2,5) FROM CATEGORIAS;  --SUBSTRING()


	--CONCATENACAO
	SELECT 'KAREN '  + 'MELO'
	SELECT 'KAREN '  + 'MELO' + NULL  -- TODA OPERACAO REALIZADA COM NULL RETORNA NULL
	SELECT CONCAT('KAREN ', 'MELO')
	SELECT CONCAT(DESCRICAO, ' TESTE CONCAT') FROM CATEGORIAS


	--CAMPO NULO RETORNAR DEFAULT
	SELECT ISNULL(NULL, 'DEFAULT')
	SELECT ISNULL(DESCRICAO, 'SEM DESCRICAO') FROM CATEGORIAS
	SELECT COALESCE(NULL, NULL,NULL, NULL, 'DEFAULT') -- RECEBE UM ARRAY E DEVOLTE O PRIMEIRO QUE NAO ESTIVER NULL
	SELECT COALESCE(NULL, NULL,NULL, 'PRIMEIRO', 'SEGUNDO')


	SELECT IIF(1 > 0, 'MAIOR QUE ZERO', 'MENOR QUE ZERO');

	SELECT IIF(VALOR > 200, 'CURSO CARO', 'CURSO BARATO') FROM CURSOS;
	SELECT IIF(LEN(DESCRICAO) > 5, 'MAIOR QUE 5','MENOR QUE 5'), DESCRICAO FROM CATEGORIAS;

	--FUNCTION DE DATA DO T-SQL
	SELECT GETDATE()
	SELECT CAST(GETDATE() AS DATE)
	SELECT CAST(GETDATE() AS TIME)


	--UDF 
	--SCALAR-VALUED FUNCTION
	CREATE FUNCTION MASCARAR(@data VARCHAR(255), @quantidadeCaracteres INT)
	RETURNS VARCHAR(255)
	AS
	BEGIN
		RETURN CONCAT(LEFT(@data, @quantidadeCaracteres), '**** ****')
	END

	--SCALAR-VALUED FUNCTION
	CREATE FUNCTION CONTARREGISTROS()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT COUNT(*) FROM CATEGORIAS);
	END

	--USO DA UDF SCALAR-VALUED FUNCTION
	SELECT DBO.MASCARAR(DESCRICAO, 4) FROM CATEGORIAS

	
	--TABLE-VALUED FUNCTION
	CREATE FUNCTION GETCATEGORIABYID(@id INT)
	RETURNS TABLE
	AS	
	RETURN (SELECT * FROM CATEGORIAS WHERE ID = @id);

	--USO DA TABLE-VALUED FUNCTION
	SELECT * FROM GETCATEGORIABYID(1)




	/*  STORE PROCEDURE  */
	CREATE PROCEDURE PesquisarCategoriaPorId(@id INT)
	AS 
	BEGIN
		SELECT * FROM CATEGORIAS WHERE ID = @id;

	END

	--FORMAS DE EXECUCAO
	EXEC DBO.PesquisarCategoriaPorId 1
	EXECUTE DBO.PesquisarCategoriaPorId @id = 2


	CREATE PROCEDURE PersistirDadosEmCategorias(@descricao VARCHAR(255))
	AS 
	BEGIN
		INSERT INTO Categorias(descricao, cadastrado_em) VALUES (@descricao, GETDATE());
	END

	EXEC dbo.PersistirDadosEmCategorias 'Categoria Teste Procedure'

	-- APAGANDO UMA PROCEDURE
	DROP PROCEDURE PersistirDadosEmCategorias

	CREATE PROCEDURE PersistirDadosEmCategorias(@descricao VARCHAR(255))
	AS 
	BEGIN 
		IF (@descricao IS NULL OR LEN(@descricao) <= 0)		
		BEGIN		
			RAISERROR('DESCRICAO NAO E VALIDA', 16, 1)
			RETURN
		END
		INSERT INTO Categorias(descricao, cadastrado_em) VALUES (@descricao, GETDATE());
	END

	EXEC dbo.PersistirDadosEmCategorias NULL




	/*  VIEW  */
	--E UMA TABELA VIRTUAL CAPTURADA DE FORMA DINAMICA NO BD DIRETAMENTE NA TABELA FISICA.
	CREATE VIEW VW_CURSOS
	AS
	SELECT CR.DESCRICAO CURSO, CONCAT('R$ ', CR.VALOR) AS VALOR, CA.DESCRICAO CATEGORIA
	  FROM CURSOS CR
	 INNER JOIN CATEGORIAS CA 
		ON CA.ID = CR.CATEGORIA_ID

	--ALTERANDO A VIEW
	ALTER VIEW VW_CURSOS
	AS
	SELECT CR.DESCRICAO CURSO, CONCAT('R$ ', CR.VALOR) AS VALOR, CA.DESCRICAO CATEGORIA, CR.CADASTRADO_EM
	  FROM CURSOS CR
	 INNER JOIN CATEGORIAS CA 
		ON CA.ID = CR.CATEGORIA_ID

	--USO DA VIEW
	SELECT * FROM VW_CURSOS WHERE CATEGORIA LIKE '%WEB%'



	/* SEQUENCES */

	--CRIACAO DA SEQUENCE
	CREATE SEQUENCE MinhaSequencia
	AS INT
	START WITH 6
	INCREMENT BY 1
	MINVALUE 6
	MAXVALUE 10 -- INFORMA O VALOR MAXIMO DA SEQUENCE
	CYCLE  --OR NO CYCLE-> INFORMA QUE NAO E PARA REINICIAR A SEQUENCE, JA O CYCLE REINICIA A SEQUENCE

	--COMO APAGAR A SEQUENCE
	DROP SEQUENCE MinhaSequencia

	--COMO EXECUTAR A SEQUENCE
	SELECT NEXT VALUE FOR MINHASEQUENCIA



	/*  ALTER  */

	--TABLE
	ALTER TABLE CATEGORIAS ADD TESTE VARCHAR(100) DEFAULT 'TESTE', NOVOCAMPO INT DEFAULT 0

	

	/* REMOVENDO COLUNAS */
	ALTER TABLE CATEGORIAS DROP COLUMN  TESTE, NOVOCAMPO  ---COMO A COLUNA FOI CRIADA COM DEFAUL O BD CRIOU UMA CONSTRAINT E PARA REMOVER A COLUNA SERA NECESSARIO ANTES EXCLUIR A CONSTRAINT

	ALTER TABLE CATEGORIAS DROP CONSTRAINT  DF__Categoria__NOVOC__44FF419A -- EXCLUSAO DA CONSTRAINT


	SELECT * FROM CATEGORIAS


	/* ALTERANDO O NOME DE UMA COLUNA */
	--CRIACAO DA COLUNA COM NOME ERRADO
	ALTER TABLE CATEGORIAS ADD TESTE VARCHAR(100)


	--RENOMEANDO A COLUNA
	EXECUTE sp_rename 'DBO.CATEGORIAS.TESTE', 'OBSERVACAO', 'COLUMN'
	ALTER TABLE CATEGORIAS DROP COLUMN  OBERSERVACAO

	--RENOMEANDO A TABELA
	EXECUTE sp_rename 'DBO.OBSERVACAO', 'CATEGORIAS'



	/* BACKUP */
	BACKUP FULL -> GERA BACKUP COMPLETO DA BASE DE DADOS.
	BACKUP DIFFERENTIAL -> GERA O BACKUP COM A DIFERENCA DO ULTIMO BACKUP GERADO 

	--FULL
	USE DESENVOLVEDORIO
	BACKUP DATABASE DESENVOLVEDORIO
	TO DISK= 'AULA-BACKUP.BAK'
	WITH INIT,
	NAME='BACKUP DA BASE DE DADOS'

	USE DESENVOLVEDORIO
	BACKUP DATABASE DESENVOLVEDORIO
	TO DISK= 'AULA-BACKUP-DIFF.BAK'
	WITH DIFFERENTIAL,
	NAME='BACKUP DA BASE DE DADOS'