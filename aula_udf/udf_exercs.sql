CREATE DATABASE udfs_exerc
GO
USE udfs_exerc
GO

CREATE TABLE funcionario (
	codigo INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	salario DECIMAL(8,2) NOT NULL,
	PRIMARY KEY (codigo)
)

CREATE TABLE dependente (
	codigo_dep		INT NOT NULL,
	codigo_func		INT NOT NULL,
	nome_dep		VARCHAR(100) NOT NULL,
	salario_dep		DECIMAL(8,2),
	PRIMARY KEY (codigo_dep),
	FOREIGN KEY (codigo_func) REFERENCES funcionario(codigo)
)

INSERT INTO funcionario (codigo, nome, salario) VALUES
(1, 'Ana Silva', 5000.50),
(2, 'Bruno Costa', 7000.00),
(3, 'Carla Souza', 6200.00),
(4, 'Daniel Lima', 8100.00),
(5, 'Eduarda Alves', 4800.00),
(6, 'Fernando Rocha', 6700.00),
(7, 'Gabriela Martins', 7500.00),
(8, 'Henrique Gomes', 5900.00),
(9, 'Isabela Ribeiro', 8800.00),
(10, 'Julio Cesar', 4300.00);

INSERT INTO dependente (codigo_dep, codigo_func, nome_dep, salario_dep) VALUES
(101, 1, 'João Silva', 1200.00),
(102, 1, 'Maria Silva', 1000.00),
(103, 2, 'Pedro Costa', 1500.00),
(104, 3, 'Lucas Souza', 800.00),
(105, 4, 'Juliana Lima', 1300.00),
(106, 5, 'Rafael Alves', 900.00),
(107, 2, 'Fernanda Costa', 1100.00),
(108, 6, 'Marcos Rocha', 1400.00),
(109, 6, 'Patricia Rocha', 1200.00),
(110, 7, 'Aline Martins', 1000.00),
(111, 8, 'Carlos Gomes', 700.00),
(112, 8, 'Beatriz Gomes', 600.00),
(113, 9, 'Renato Ribeiro', 1500.00),
(114, 9, 'Clara Ribeiro', 1300.00),
(115, 10, 'Paulo Cesar', 900.00),
(116, 10, 'Larissa Cesar', 800.00);


-- Ex 1 a)
CREATE ALTER FUNCTION fn_tabeladep()
RETURNS @tabela TABLE (
	nome_func		VARCHAR(100) NULL,
	nome_dep		VARCHAR(100) NULL,
	salario_func	DECIMAL(8,2) NULL,
	salario_dep		DECIMAL(8,2) NULL
)
AS
BEGIN
	INSERT INTO @tabela (nome_func, nome_dep, salario_func, salario_dep)
		SELECT 
			f.nome AS nome_func,
			d.nome_dep AS Nome_Dependente,
			f.salario AS Salario_Funcionario,
			d.salario_dep AS Salario_Dependente
			FROM funcionario f
			INNER JOIN dependente d ON f.codigo = d.codigo_func
	RETURN
END

SELECT * FROM fn_tabeladep() ORDER BY nome_func


-- Ex 1 b)
CREATE FUNCTION fn_soma_salarios(@cod_func INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE	@total	DECIMAL(10,2)
	SELECT @total = f.salario + ISNULL(SUM(d.salario_dep), 0)
	FROM funcionario f
	LEFT JOIN dependente d ON f.codigo = d.codigo_func
	WHERE f.codigo = @cod_func
	GROUP BY f.salario

	RETURN @total
END

SELECT dbo.fn_soma_salarios(10) AS Soma_Salarios;

SELECT * FROM funcionario

------------------------------------------------------------------------
CREATE TABLE produtos (
	codigo INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	valor_un DECIMAL(6,2) NOT NULL,
	qtd_estoque DECIMAL(6,2) NOT NULL,
	PRIMARY KEY (codigo)
)

INSERT INTO produtos (codigo, nome, valor_un, qtd_estoque) VALUES
(1, 'Arroz 5kg', 25.90, 100.00),
(2, 'Feijão 1kg', 8.50, 200.00),
(3, 'Macarrão 500g', 4.20, 150.00),
(4, 'Óleo de Soja 900ml', 7.80, 80.00),
(5, 'Açúcar 1kg', 5.10, 120.00),
(6, 'Sal 1kg', 2.30, 90.00),
(7, 'Café 500g', 14.70, 60.00),
(8, 'Leite 1L', 4.90, 300.00),
(9, 'Manteiga 200g', 9.80, 70.00),
(10, 'Pão de Forma', 6.50, 110.00),
(11, 'Biscoito Recheado', 3.20, 140.00),
(12, 'Refrigerante 2L', 8.90, 95.00),
(13, 'Suco de Caixa 1L', 5.60, 85.00),
(14, 'Detergente 500ml', 2.80, 130.00),
(15, 'Sabão em Pó 1kg', 12.40, 75.00),
(16, 'Shampoo 350ml', 11.90, 65.00),
(17, 'Condicionador 350ml', 12.10, 60.00),
(18, 'Papel Higiênico 12un', 18.50, 50.00),
(19, 'Escova de Dente', 7.30, 100.00),
(20, 'Creme Dental', 4.70, 120.00)



-- EX 2 a)
CREATE FUNCTION fn_estoque_baixo(@valor DECIMAL(6,2))
RETURNS INT
AS
BEGIN
	DECLARE @qtd_produtos INT

	SELECT @qtd_produtos = COUNT(*)
	FROM produtos p
	WHERE p.qtd_estoque < @valor

	RETURN @qtd_produtos
END

SELECT dbo.fn_estoque_baixo(14.00) AS Qtd_Estoque_Baixo


-- EX 2 b)
CREATE ALTER FUNCTION fn_tabela_estoque_baixo(@entrada DECIMAL(6,2))
RETURNS @tabela TABLE (
	codigo			INT NULL,
	nome_produto	VARCHAR(100) NULL,
	qtd_estoque		DECIMAL(6,2) NULL
)
AS
BEGIN
	INSERT INTO @tabela(codigo, nome_produto, qtd_estoque)
		SELECT 
			p.codigo AS codigo,
			p.nome AS nome_produto,
			p.qtd_estoque AS qtd_estoque
		FROM produtos p
		WHERE p.qtd_estoque < @entrada
	RETURN
END

SELECT * FROM fn_tabela_estoque_baixo(80.00) ORDER BY qtd_estoque