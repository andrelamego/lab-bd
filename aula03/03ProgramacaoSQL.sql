CREATE DATABASE programacaoSQL03
GO
USE programacaoSQL03

-- a) Dado um número inteiro. Calcule e mostre o seu fatorial. (Não usar entrada superior a 12)
DECLARE @num     INT = 7;
DECLARE @fatorial BIGINT = 1;
DECLARE @i       INT = 1;

IF @num < 0 OR @num > 12
BEGIN
    SELECT 'Entrada inválida. Use um número entre 0 e 12' AS Resultado;
END
ELSE
BEGIN
    WHILE @i <= @num
    BEGIN
        SET @fatorial = @fatorial * @i;
        SET @i = @i + 1;
    END

    SELECT @num AS Numero, @fatorial AS Fatorial;
END
GO


-- b) Dados A, B, e C de uma equação do 2o grau da fórmula AX2+BX+C=0. Verifique e mostre a
-- existência de raízes reais e se caso exista, calcule e mostre. Caso não existam, exibir mensagem.
DECLARE @a FLOAT = 1;
DECLARE @b FLOAT = -5;
DECLARE @c FLOAT = 6;
DECLARE @delta FLOAT;
DECLARE @x1    FLOAT;
DECLARE @x2    FLOAT;

IF @a = 0
BEGIN
    SELECT 'Valor de A não pode ser 0' AS Resultado;
END
ELSE
BEGIN
    SET @delta = (@b * @b) - (4 * @a * @c);

    IF @delta < 0
    BEGIN
        SELECT
            @delta AS Delta,
            'Delta negativo: não existem raízes reais' AS Resultado;
    END
    ELSE IF @delta = 0
    BEGIN
        SET @x1 = (-@b) / (2 * @a);
        SELECT
            @delta AS Delta,
            'Delta igual a zero: uma raiz real' AS Resultado,
            @x1 AS X1,
            @x1 AS X2;
    END
    ELSE
    BEGIN
        SET @x1 = ((-@b) + SQRT(@delta)) / (2 * @a);
        SET @x2 = ((-@b) - SQRT(@delta)) / (2 * @a);
        SELECT
            @delta AS Delta,
            'Delta positivo: duas raízes reais' AS Resultado,
            @x1 AS X1,
            @x2 AS X2;
    END
END
GO


-- c) Calcule e mostre quantos anos serão necessários para que Ana seja maior que Maria sabendo
-- que Ana tem 1,10 m e cresce 3 cm ao ano e Maria tem 1,5 m e cresce 2 cm ao ano.
DECLARE @alturaAna   FLOAT = 1.10;
DECLARE @alturaMaria FLOAT = 1.50;
DECLARE @anos        INT   = 0;

WHILE @alturaAna <= @alturaMaria
BEGIN
    SET @alturaAna   = @alturaAna   + 0.03;
    SET @alturaMaria = @alturaMaria + 0.02;
    SET @anos        = @anos + 1;
END

SELECT
    @anos        AS AnosNecessarios,
    @alturaAna   AS AlturaFinalAna,
    @alturaMaria AS AlturaFinalMaria;
GO


-- d) Seja a seguinte série: 1, 4, 4, 2, 5, 5, 3, 6, 6, 4, 7, 7, ...
-- Escreva uma aplicação que a escreva N termos
DECLARE @N        INT = 15;
DECLARE @termos   INT = 0;
DECLARE @base     INT = 1;
DECLARE @posGrupo INT = 1;

CREATE TABLE #Serie (Posicao INT, Valor INT);

WHILE @termos < @N
BEGIN
    IF @posGrupo = 1
    BEGIN
        INSERT INTO #Serie VALUES (@termos + 1, @base);
    END
    ELSE
    BEGIN
        INSERT INTO #Serie VALUES (@termos + 1, @base + 3);
    END

    SET @termos   = @termos + 1;
    SET @posGrupo = @posGrupo + 1;

    IF @posGrupo > 3
    BEGIN
        SET @posGrupo = 1;
        SET @base     = @base + 1;
    END
END

SELECT Posicao, Valor FROM #Serie ORDER BY Posicao;
DROP TABLE #Serie;
GO


-- e) Considerando a tabela abaixo, gere uma database, a tabela e crie um algoritmo para inserir
-- uma massa de dados, com 50 registros, para fins de teste, com as regras estabelecidas (Não
-- usar constraints na criação da tabela)

CREATE DATABASE DBProduto;
GO

USE DBProduto;
GO

CREATE TABLE Produto (
    Codigo     INT,
    Nome       VARCHAR(30),
    Valor      DECIMAL(7,2),
    Vencimento DATE
);
GO

DECLARE @cont   INT = 1;
DECLARE @codigo INT;
DECLARE @nome   VARCHAR(30);
DECLARE @valor  DECIMAL(7,2);
DECLARE @diasVenc INT;
DECLARE @venc   DATE;

WHILE @cont <= 50
BEGIN
    SET @codigo = 50000 + @cont;
    SET @nome   = 'Produto ' + CAST(@cont AS VARCHAR(10));

    -- aleatório entre 10.00 e 100.00
    SET @valor  = CAST(RAND() * 90 + 10 AS DECIMAL(7,2));

    -- aleatorio entre 3 e 7
    SET @diasVenc = FLOOR(RAND() * 5) + 3;

    SET @venc = DATEADD(DAY, @diasVenc, GETDATE());

    INSERT INTO Produto (Codigo, Nome, Valor, Vencimento)
    VALUES (@codigo, @nome, @valor, @venc);

    SET @cont = @cont + 1;
END

SELECT * FROM Produto ORDER BY Codigo;
GO


-- f) Considerando a tabela abaixo, gere uma database, a tabela e crie um algoritmo para inserir
-- uma massa de dados, com 50 registros, para fins de teste, com as regras estabelecidas (Não
-- usar constraints na criação da tabela)
CREATE DATABASE DBLivro;
GO

USE DBLivro;
GO

CREATE TABLE Livro (
    ID           INT,
    Titulo       VARCHAR(30),
    Qtd_Paginas  INT,
    Qtd_Estoque  INT
);
GO

DECLARE @contL    INT = 0;
DECLARE @idL      INT;
DECLARE @tituloL  VARCHAR(30);
DECLARE @paginas  INT;
DECLARE @estoque  INT;

WHILE @contL < 50
BEGIN
    SET @idL     = 981101 + @contL;
    SET @tituloL = 'Livro ' + CAST(@idL AS VARCHAR(10));

    -- aleatorio entre 100 e 400
    SET @paginas = FLOOR(RAND() * 301) + 100;

    -- aleatorio entre 2 e 20
    SET @estoque = FLOOR(RAND() * 19) + 2;

    INSERT INTO Livro (ID, Titulo, Qtd_Paginas, Qtd_Estoque)
    VALUES (@idL, @tituloL, @paginas, @estoque);

    SET @contL = @contL + 1;
END

SELECT * FROM Livro ORDER BY ID;
GO