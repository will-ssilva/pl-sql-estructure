----------------------------------------------------------------
--                      PL/SQL COMANDOS                       --
----------------------------------------------------------------

--> PROCESURES INICIO

SET SERVEROUTPUT ON;

--> INICIO

BEGIN
	DBMS_OUTPUT.put_line('Hello World!');
END;

--> IF

DECLARE
	meu_nome VARCHAR2(35);
BEGIN
	meu_nome := 'William';
	IF NOT meu_nome <> 'Goku' THEN
		DBMS_OUTPUT.put_line('O meu nome é diferente de '|| meu_nome);
	ELSIF meu_nome IS NOT NULL THEN
		DBMS_OUTPUT.put_line('O meu nome é: ' || meu_nome);
	ELSE 
		DBMS_OUTPUT.put_line('O meu nome é William');
	END IF;
EXCEPTION WHEN OTHERS THEN
	DBMS_OUTPUT.put_line(SQLERRM);
END;

--> CASE

BEGIN
	CASE
		WHEN (1 > 3) THEN 
			DBMS_OUTPUT.put_line('Conta errada!');
		WHEN (3 > 1) THEN
			DBMS_OUTPUT.put_line('Está correto!');
		ELSE
			DBMS_OUTPUT.put_line('Não deu certo!');
	END CASE;
END;

--> LOOP

BEGIN
	FOR i IN 1 .. 10 LOOP
		DBMS_OUTPUT.put_line('Linha :' || i);
	END LOOP;
END;


--> PRIMEIRA PROCEDURE

DECLARE
    V_NM_FUNCIONARIO employees.first_name%TYPE;
BEGIN

    SELECT first_name
    INTO V_NM_FUNCIONARIO
    FROM employees 
    WHERE employee_id = 26;
    
    IF V_NM_FUNCIONARIO <> 'LEON' THEN
        dbms_output.put_line(V_NM_FUNCIONARIO);
    ELSE
        dbms_output.put_line('NOK');
    END IF;

END;


--> PROCEDURE DE DOIS PARAMETROS

CREATE OR REPLACE PROCEDURE SP_CONFERE_NM_FUNCIONARIO (P_ID_FUNCIONARIO NUMBER, P_NM_FUNCIONARIO VARCHAR2) IS
    V_NM_FUNCIONARIO employees.first_name%TYPE;
BEGIN

    SELECT first_name
    INTO V_NM_FUNCIONARIO
    FROM employees 
    WHERE employee_id = P_ID_FUNCIONARIO;
    
    IF V_NM_FUNCIONARIO = P_NM_FUNCIONARIO THEN
        dbms_output.put_line(V_NM_FUNCIONARIO);
    ELSE
        dbms_output.put_line('NOK');
    END IF;

END SP_CONFERE_NM_FUNCIONARIO;


-- PROCEDURE TRATAMENTO EXCEPTION

CREATE TABLE tb_produto(
	id_produto number(10) PRIMARY KEY,
	nm_produto varchar2(30)
);

INSERT INTO tb_produto (id_produto, nm_produto) VALUES (1, 'COCA-COLA');
INSERT INTO tb_produto (id_produto, nm_produto) VALUES (3, 'Coca-Cola');
-- INSERT INTO tb_produto (id_produto, nm_produto) VALUES (1, 'Coca-Cola')

BEGIN 
	INSERT INTO tb_produto (id_produto, nm_produto) VALUES (1, 'Coca-Cola');
	EXCEPTION WHEN DUP_VAL_ON_INDEX THEN 
		UPDATE tb_produto 
			SET nm_produto = 'Coca-Cola'
		WHERE id_produto = 1;
	DBMS_OUTPUT.put_line('Atualizado!');
END;

DECLARE
	V_NM_PRODUTO TB_PRODUTO.NM_PRODUTO%TYPE;
BEGIN
	SELECT NM_PRODUTO
	INTO V_NM_PRODUTO
	FROM TB_PRODUTO
	WHERE NM_PRODUTO = 'Coca-Cola';
	DBMS_OUTPUT.PUT_LINE('O produto é: ' || V_NM_PRODUTO);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			INSERT INTO tb_produto (id_produto, nm_produto) VALUES (2, 'Fanta');
		WHEN TOO_MANY_ROWS THEN
			DBMS_OUTPUT.PUT_LINE('TEM MAIS DE UMA ' || V_NM_PRODUTO || ' NA TABELA!');
END;

DECLARE
	V_ZERO_DIVIDE NUMBER(10);
BEGIN
	V_ZERO_DIVIDE := 10/0;
	DBMS_OUTPUT.PUT_LINE('V_ZERO_DIVIDE');
	EXCEPTION 
		WHEN ZERO_DIVIDE THEN
		DBMS_OUTPUT.PUT_LINE('NÃO PODE DIVIDIR POR ZERO');
		WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;

--> CRIANDO UMA EXCEPTION
DECLARE 
	E_ERRO EXCEPTION;
BEGIN
	IF 1 = 1 THEN
		RAISE E_ERRO;
	END IF;
	DBMS_OUTPUT.PUT_LINE('ESTÁ COM ERRO NÃO ENTROU NA EXCEPTION!');
	EXCEPTION WHEN E_ERRO THEN
	DBMS_OUTPUT.PUT_LINE('ESTÁ TUDO CERTO');
END;


-- OUTROS
-- CURSORES

CREATE TABLE TB_ALUNOS (
	ID_ALUNO NUMBER(10),
	NM_ALUNO VARCHAR2(100),
	DT_NASCIMENTO DATE
);

INSERT INTO TB_ALUNOS (ID_ALUNO, NM_ALUNO, DT_NASCIMENTO) 
VALUES (1, 'WILLIAM', TO_DATE('20/12/1986', 'DD/MM/RRRR'));

INSERT INTO TB_ALUNOS (ID_ALUNO, NM_ALUNO, DT_NASCIMENTO) 
VALUES (1, 'WILLIAM1', TO_DATE('20/12/1986', 'DD/MM/RRRR'));

INSERT INTO TB_ALUNOS (ID_ALUNO, NM_ALUNO, DT_NASCIMENTO) 
VALUES (1, 'WILLIAM2', TO_DATE('20/12/1986', 'DD/MM/RRRR'));

INSERT INTO TB_ALUNOS (ID_ALUNO, NM_ALUNO, DT_NASCIMENTO) 
VALUES (1, 'WILLIAM3', TO_DATE('20/12/1986', 'DD/MM/RRRR'));

-- CURSOR
DECLARE
	CURSOR CUR_ALUNOS IS
	SELECT ID_ALUNO, NM_ALUNO, DT_NASCIMENTO FROM TB_ALUNOS;
BEGIN
	FOR C_ALUNOS IN CUR_ALUNOS LOOP
		DBMS_OUTPUT.PUT_LINE('O ID DO ALUNO É:' || C_ALUNOS.ID_ALUNO);
		DBMS_OUTPUT.PUT_LINE('O NOME DO ALUNO É:' || C_ALUNOS.NM_ALUNO);
		DBMS_OUTPUT.PUT_LINE('A DATA DO ALUNO É:' || C_ALUNOS.DT_NASCIMENTO);
		DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
		DBMS_OUTPUT.PUT_LINE('');
	END LOOP;
END;

DECLARE
	CURSOR CUR_ALUNOS (C_ID_ALUNO TB_ALUNOS.ID_ALUNO%TYPE) IS
	SELECT ID_ALUNO, NM_ALUNO, DT_NASCIMENTO FROM TB_ALUNOS
	WHERE ID_ALUNO = C_ID_ALUNO;
	
	V_ID_ALUNO TB_ALUNOS.ID_ALUNO%TYPE;
	V_NM_ALUNO TB_ALUNOS.NM_ALUNO%TYPE;
	V_DT_NASCIMENTO TB_ALUNOS.DT_NASCIMENTO%TYPE;

BEGIN

	OPEN CUR_ALUNOS(1);
	FETCH CUR_ALUNOS
	INTO V_ID_ALUNO, V_NM_ALUNO, V_DT_NASCIMENTO;
	CLOSE CUR_ALUNOS;

	DBMS_OUTPUT.PUT_LINE('O ID DO ALUNO É:' || V_ID_ALUNO);
	DBMS_OUTPUT.PUT_LINE('O NOME DO ALUNO É:' || V_NM_ALUNO);
	DBMS_OUTPUT.PUT_LINE('A DATA DO ALUNO É:' || V_DT_NASCIMENTO);
	DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
	DBMS_OUTPUT.PUT_LINE('');
END;

CREATE OR REPLACE PROCEDURE SP_REL_ALUNOS (
	P_ID_ALUNO IN TB_ALUNOS.ID_ALUNO%TYPE, 
	P_NM_ALUNO OUT TB_ALUNOS.NM_ALUNO%TYPE, 
	P_DT_NASCIMENTO OUT TB_ALUNOS.DT_NASCIMENTO%TYPE)
IS 
CURSOR CUR_ALUNOS (C_ID_ALUNO TB_ALUNOS.ID_ALUNO%TYPE) IS
	SELECT ID_ALUNO, NM_ALUNO, DT_NASCIMENTO FROM TB_ALUNOS
	WHERE ID_ALUNO = C_ID_ALUNO;
	
	V_ID_ALUNO TB_ALUNOS.ID_ALUNO%TYPE;
	V_NM_ALUNO TB_ALUNOS.NM_ALUNO%TYPE;
	V_DT_NASCIMENTO TB_ALUNOS.DT_NASCIMENTO%TYPE;

BEGIN
	OPEN CUR_ALUNOS(P_ID_ALUNO);
	FETCH CUR_ALUNOS
	INTO V_ID_ALUNO, V_NM_ALUNO, V_DT_NASCIMENTO;
	CLOSE CUR_ALUNOS;

	P_NM_ALUNO := V_NM_ALUNO; 
	P_DT_NASCIMENTO := V_DT_NASCIMENTO;
END SP_REL_ALUNOS;

-- BLOCO ANONIMO PARA CHAMAR PROCEDURE
DECLARE
	V_ID_ALUNO TB_ALUNOS.ID_ALUNO%TYPE;
	V_NM_ALUNO TB_ALUNOS.NM_ALUNO%TYPE;
	V_DT_NASCIMENTO TB_ALUNOS.DT_NASCIMENTO%TYPE;
BEGIN
	V_ID_ALUNO := 3;
	SP_REL_ALUNOS(
		P_ID_ALUNO => V_ID_ALUNO,
		P_NM_ALUNO => V_NM_ALUNO,
		P_DT_NASCIMENTO => V_DT_NASCIMENTO
	);
	DBMS_OUTPUT.PUT_LINE('O ID DO ALUNO É:' || V_ID_ALUNO);
	DBMS_OUTPUT.PUT_LINE('O NOME DO ALUNO É:' || V_NM_ALUNO);
	DBMS_OUTPUT.PUT_LINE('A DATA DO ALUNO É:' || V_DT_NASCIMENTO);
	DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
	DBMS_OUTPUT.PUT_LINE('');
END;

-- FUNCTION
CREATE OR REPLACE FUNCTION FN_REL_ALUNO (
	P_ID_ALUNO IN TB_ALUNOS.ID_ALUNO%TYPE
) RETURN TB_ALUNOS.NM_ALUNO%TYPE 
IS 
CURSOR CUR_ALUNOS (C_ID_ALUNO TB_ALUNOS.ID_ALUNO%TYPE) IS
	SELECT ID_ALUNO, NM_ALUNO, DT_NASCIMENTO FROM TB_ALUNOS
	WHERE ID_ALUNO = C_ID_ALUNO;
	
	V_ID_ALUNO TB_ALUNOS.ID_ALUNO%TYPE;
	V_NM_ALUNO TB_ALUNOS.NM_ALUNO%TYPE;
	V_DT_NASCIMENTO TB_ALUNOS.DT_NASCIMENTO%TYPE;

BEGIN
	OPEN CUR_ALUNOS(P_ID_ALUNO);
	FETCH CUR_ALUNOS
	INTO V_ID_ALUNO, V_NM_ALUNO, V_DT_NASCIMENTO;
	CLOSE CUR_ALUNOS;

	RETURN V_NM_ALUNO; 
	RETURN V_DT_NASCIMENTO;
END FN_REL_ALUNO;

SELECT FN_REL_ALUNO(3) FROM DUAL;

