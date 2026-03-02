CREATE DATABASE programacaoSQL04
GO
USE programacaoSQL04

-- a) Fazer um algoritmo que leia 1 número e mostre se são múltiplos de 2,3,5 ou nenhum deles
DECLARE @numero INT = 15;
DECLARE @resultadoA VARCHAR(100) = '';

IF @numero % 2 = 0
    SET @resultadoA = @resultadoA + 'Múltiplo de 2 | ';

IF @numero % 3 = 0
    SET @resultadoA = @resultadoA + 'Múltiplo de 3 | ';

IF @numero % 5 = 0
    SET @resultadoA = @resultadoA + 'Múltiplo de 5 | ';

IF @resultadoA = ''
    SET @resultadoA = 'Não é múltiplo de 2, 3 ou 5';

SELECT @numero AS Numero, @resultadoA AS Resultado;
GO


-- b) Fazer um algoritmo que leia 3 números e mostre o maior e o menor
DECLARE @n1 INT = 42;
DECLARE @n2 INT = 17;
DECLARE @n3 INT = 88;
DECLARE @maior INT;
DECLARE @menor INT;

-- maior
IF @n1 >= @n2 AND @n1 >= @n3
    SET @maior = @n1;
ELSE IF @n2 >= @n1 AND @n2 >= @n3
    SET @maior = @n2;
ELSE
    SET @maior = @n3;

-- menor
IF @n1 <= @n2 AND @n1 <= @n3
    SET @menor = @n1;
ELSE IF @n2 <= @n1 AND @n2 <= @n3
    SET @menor = @n2;
ELSE
    SET @menor = @n3;

SELECT @n1 AS Numero1, @n2 AS Numero2, @n3 AS Numero3,
       @maior AS Maior, @menor AS Menor;
GO


-- c) Fazer um algoritmo que calcule os 15 primeiros termos da série de Fibonacci
DECLARE @pos     INT = 1;
DECLARE @atual   INT = 1;
DECLARE @anterior INT = 0;
DECLARE @proximo INT;
DECLARE @somaFib INT = 0;

-- tabela temporaria
CREATE TABLE #Fibonacci (Posicao INT, Termo INT);

WHILE @pos <= 15
BEGIN
    INSERT INTO #Fibonacci VALUES (@pos, @atual);
    SET @somaFib = @somaFib + @atual;

    SET @proximo  = @atual + @anterior;
    SET @anterior = @atual;
    SET @atual    = @proximo;
    SET @pos      = @pos + 1;
END

SELECT Posicao, Termo, @somaFib AS SomaTotal
FROM #Fibonacci
ORDER BY Posicao;

DROP TABLE #Fibonacci;
GO


-- d) Fazer um algoritmo que separa uma frase, colocando todas as letras em maiúsculo e em
-- minúsculo (Usar funções UPPER e LOWER)
DECLARE @frase VARCHAR(200) = 'Exercicios em SQL server';

SELECT
    @frase          AS FraseOriginal,
    UPPER(@frase)   AS EmMaiusculo,
    LOWER(@frase)   AS EmMinusculo;
GO


-- e) Fazer um algoritmo que inverta uma palavra (Usar a função SUBSTRING)
DECLARE @palavra VARCHAR(100) = 'SQLServer';

DECLARE @invertida VARCHAR(100) = '';
DECLARE @i INT = LEN(@palavra);

WHILE @i >= 1
BEGIN
    SET @invertida = @invertida + SUBSTRING(@palavra, @i, 1);
    SET @i = @i - 1;
END

SELECT
    @palavra   AS PalavraOriginal,
    @invertida AS PalavraInvertida;
GO


-- f) Considerando a tabela abaixo, gere uma massa de dados, com 100 registros, para fins de teste
-- com as regras estabelecidas (Não usar constraints na criação da tabela)

CREATE TABLE Computador (
    ID       INT,
    Marca    VARCHAR(40),
    QtdRAM   INT,
    TipoHD   VARCHAR(10),
    QtdHD    INT,
    FreqCPU  DECIMAL(7, 2)
);
GO

DECLARE @contador INT = 1;
DECLARE @id       INT;
DECLARE @marca    VARCHAR(40);
DECLARE @qtdRAM   INT;
DECLARE @tipoHD   VARCHAR(10);
DECLARE @qtdHD    INT;
DECLARE @freqCPU  DECIMAL(7, 2);

DECLARE @ramOpcoes  TABLE (idx INT, val INT);
INSERT INTO @ramOpcoes VALUES (0,2),(1,4),(2,8),(3,16);

WHILE @contador <= 100
BEGIN
    SET @id = 10000 + @contador;

    SET @marca = 'Marca ' + CAST(@contador AS VARCHAR(3));

    -- QtdRAM aleatorio
    SELECT @qtdRAM = val
    FROM @ramOpcoes
    WHERE idx = FLOOR(RAND() * 4);

    -- TipoHD
    SET @tipoHD = CASE (@id % 3)
                      WHEN 0 THEN 'HDD'
                      WHEN 1 THEN 'SSD'
                      ELSE 'M2 NVME'
                  END;

    -- QtdHD conforme TipoHD
    IF @tipoHD = 'HDD'
    BEGIN
        SET @qtdHD = CASE FLOOR(RAND() * 3)
                         WHEN 0 THEN 500
                         WHEN 1 THEN 1000
                         ELSE 2000
                     END;
    END
    ELSE
    BEGIN
        SET @qtdHD = CASE FLOOR(RAND() * 3)
                         WHEN 0 THEN 128
                         WHEN 1 THEN 256
                         ELSE 512
                     END;
    END

    -- FreqCPU aleatorio entre 1.70 e 3.20
    SET @freqCPU = CAST(RAND() * 1.50 + 1.70 AS DECIMAL(7, 2));

    INSERT INTO Computador (ID, Marca, QtdRAM, TipoHD, QtdHD, FreqCPU)
    VALUES (@id, @marca, @qtdRAM, @tipoHD, @qtdHD, @freqCPU);

    SET @contador = @contador + 1;
END

-- resultado
SELECT * FROM Computador ORDER BY ID;
GO