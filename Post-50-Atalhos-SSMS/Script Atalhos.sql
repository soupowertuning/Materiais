CREATE DATABASE TRACES

USE Traces

----------------------------------------------------------------------------------------------------------------------------
--	Cria e popula a tabela "Tabela_Teste" para a realização dos testes
----------------------------------------------------------------------------------------------------------------------------
IF (OBJECT_ID('Tabela_Teste') IS NOT NULL) DROP TABLE Tabela_Teste

CREATE TABLE Tabela_Teste (
	Id_Cliente INT IDENTITY(1,1),
	Nm_Cliente VARCHAR(50),
	Dt_Nascimento DATETIME,
	CONSTRAINT PK_Tabela_Teste
	PRIMARY KEY(Id_Cliente),
	CONSTRAINT CH01_Tabela_Teste
	CHECK(Dt_Nascimento > '1900-01-01')
)

-- Cria alguns indices para a tabela
CREATE NONCLUSTERED INDEX SK01_Tabela_Teste
ON Tabela_Teste (Nm_Cliente) WITH (FILLFACTOR = 95)

CREATE NONCLUSTERED INDEX SK02_Tabela_Teste
ON Tabela_Teste (Dt_Nascimento) WITH (FILLFACTOR = 95)

-- Insere alguns registros de exemplo
INSERT INTO Tabela_Teste VALUES('João da Silva', '1978-01-29'), ('Paulo Santos', '1982-06-07'), ('Maria da Penha', '1975-08-02')
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	01) ALT + F1 – Executa o procedimento armazenado do sistema ”sp_help” e exibe várias informações do objeto selecionado
----------------------------------------------------------------------------------------------------------------------------
-- Essa sem dúvida e uma das dicas que utilizo com mais frequência. Ela retorna várias informações sobre a tabela de forma simples e rápida, 
-- ajudando a identificar rapidamente as colunas, tipos, índices, dentre outras informações da tabela.

-- Selecione o nome "Tabela_Teste" e pressione as teclas ALT + F1
SELECT * FROM Tabela_Teste


----------------------------------------------------------------------------------------------------------------------------
--	02) Selecionar Colunas: 
----------------------------------------------------------------------------------------------------------------------------
--	Pode ser útil para copiar o nome das colunas ou inserir texto.

--	Clicar na posição inicial + pressionar as teclas SHIFT e ALT + clicar na posição final

--	OBS: Só é possível "inserir texto" com essa seleção a partir do SSMS 2012 e posteriores.

Id_Cliente
Nm_Cliente
Dt_Nascimento
Id_Cliente
Nm_Cliente
Dt_Nascimento
Id_Cliente
Nm_Cliente
Dt_Nascimento
Id_Cliente
Nm_Cliente
Dt_Nascimento


----------------------------------------------------------------------------------------------------------------------------
--	03)	CTRL + Barra de Espaço – Exibe o Intellisense com a lista de objetos do banco de dados
----------------------------------------------------------------------------------------------------------------------------
--	Muito bom para aumentar a produtividade no desenvolvimento das tarefas do dia a dia.

--	OBS: Caso o IntelliSense não esteja habilitado, basta ir no menu “Query -> IntelliSense Enabled” e habilitar a opção.

--	Descomentar a linha abaixo, pressionar "CTRL + Barra de Espaço" após o FROM, começar a digitar o nome da 
--	tabela "Tabela_Teste" e irá aparecer o Intellisense.

--	SELECT * FROM 


----------------------------------------------------------------------------------------------------------------------------
--	04)	CTRL + SHIFT + R – Atualização de cache do Intellisense
----------------------------------------------------------------------------------------------------------------------------
--	Algumas vezes precisamos incluir / excluir colunas ou até mesmo criar novas tabelas nas tarefas do dia a dia. 
--	Entretanto, logo após realizar essas alterações o IntelliSense não é atualizado automaticamente e os objetos não são exibidos corretamente. 
--	Para contornar essa situação, basta atualizar o cache do IntelliSense manualmente.

--	Segue abaixo um pequeno script para testar:

--	Criar uma nova coluna na tabela
ALTER TABLE Tabela_Teste
ADD Nm_Pai VARCHAR(50) NULL

--	Abrir uma nova janela de query
--	Colocar uma virgula "," e começar a digitar o nome da nova coluna "Nm_Pai". Ela não irá aparecer no Intellisense.
SELECT Nm_Cliente
FROM Tabela_Teste

--	Pressionar as teclas "CTRL + SHIFT + R" para atualizar o Cache do Intellisense.

--	Colocar uma virgula "," e começar a digitar o nome da nova coluna "Nm_Pai". Dessa vez o nome da coluna irá aparecer no Intellisense.
SELECT Nm_Cliente
FROM Tabela_Teste


----------------------------------------------------------------------------------------------------------------------------
--	05)	Exibir a numeração das linhas
----------------------------------------------------------------------------------------------------------------------------
-- Útil para melhorar a visualização do código e para referências visuais.

--	Basta habilitar / desabilitar a opção no menu ”Tools -> Options -> Text Editor -> All Languages -> Line numbers”.


----------------------------------------------------------------------------------------------------------------------------
--	06)	CTRL + G – Vai para a linha informada
----------------------------------------------------------------------------------------------------------------------------
--	Útil quando você possui o número da linha desejada. Por exemplo, quando ocorre algum erro e a linha é informada.


----------------------------------------------------------------------------------------------------------------------------
--	07)	CTRL + F – Exibe a janela de Pesquisa
----------------------------------------------------------------------------------------------------------------------------
--	Muito útil para pesquisar o nome de objetos na janela de query atual. 
--	Utilizo com muita frequência também para poder encontrar algo dentro de uma procedure muito grande.

--	Também possui opções para pesquisar apenas no trecho de código selecionado, em todas as janelas abertas ou na solução inteira.


----------------------------------------------------------------------------------------------------------------------------
--	08)	CTRL + H – Exibe a janela de Substituição
----------------------------------------------------------------------------------------------------------------------------
--	Muito útil para substituir texto na janela de query atual.
--	Utilizo bastante para implantar as rotinas de monitoramento do banco de dados nos clientes e substituir a parte do email que será enviado.

--	Também possui opções para substituir apenas no trecho de código selecionado, em todas as janelas abertas ou na solução inteira.


----------------------------------------------------------------------------------------------------------------------------
--	09)	CTRL + F4 – Fecha a janela da query atual
----------------------------------------------------------------------------------------------------------------------------
--	Fecha apenas a janela da query que está aberta atualmente.


----------------------------------------------------------------------------------------------------------------------------
--	10)	CTRL + TAB – Alterna entre as janelas das consultas e painéis
----------------------------------------------------------------------------------------------------------------------------
--	Útil quando for necessário trabalhar com várias janelas de queries em paralelo e alternar entre elas.


----------------------------------------------------------------------------------------------------------------------------
--	11)	CTRL + K, CTRL + K – Inserir um marcador de código
----------------------------------------------------------------------------------------------------------------------------
--	Tem uma função similiar ao BREAKPOINT, mas é utilizado apenas para melhorar a visualização do código. 
--	Muito útil ao analisar códigos com muitas linhas para marcar os pontos mais importantes


----------------------------------------------------------------------------------------------------------------------------
--	12)	CTRL + K, CTRL + P – Ir para o próximo marcador de código
----------------------------------------------------------------------------------------------------------------------------
--	Alterar para o próximo marcador utilizado no código


----------------------------------------------------------------------------------------------------------------------------
--	13)	CTRL + K, CTRL + L – Limpar todos os marcadores de código
----------------------------------------------------------------------------------------------------------------------------
--	Utilizado para limpar todos os marcadores do código. Ao pressionar as teclas será exibida uma mensagem para confirmar a ação.


----------------------------------------------------------------------------------------------------------------------------
--	14)	CTRL + K, CTRL + W – Exibe o painel com todos os marcadores de código
----------------------------------------------------------------------------------------------------------------------------
--	Exibe um painel na parte inferior da tela com todos os marcadores e suas respectivas posições (linha).
--	OBS: Você também pode renomear o nome do marcador para facilitar o entendimento.


----------------------------------------------------------------------------------------------------------------------------
--	15)	CTRL + K, CTRL + C – Comenta as linhas selecionadas
----------------------------------------------------------------------------------------------------------------------------
--	Útil para comentar rapidamente o trecho de código selecionado. 
--	Caso não tenha selecionado nada, será inserido um comentário na linha atual do cursor do mouse.


----------------------------------------------------------------------------------------------------------------------------
--	16)	CTRL + K, CTRL + U – Descomenta as linhas selecionadas
----------------------------------------------------------------------------------------------------------------------------
--	Útil para descomentar rapidamente o trecho de código selecionado. 
--	Caso não tenha selecionado nada, será removido um comentário na linha atual do cursor do mouse.


----------------------------------------------------------------------------------------------------------------------------
--	17)	CTRL + SHIFT + L – Transforma todas as letras do texto selecionado em Minúsculo (LOWER)
----------------------------------------------------------------------------------------------------------------------------
--	Tem a mesma funcionalidade que o LOWER(string).
SELECT LOWER('TRANSFORMAR PARA MINÚSCULO')


----------------------------------------------------------------------------------------------------------------------------
--	18)	CTRL + SHIFT + U – Transforma todas as letras do texto selecionado em Maiúsculo (UPPER) 
----------------------------------------------------------------------------------------------------------------------------
--	Tem a mesma funcionalidade que o UPPER(string).
SELECT UPPER('transformar para maiúsculo')


----------------------------------------------------------------------------------------------------------------------------
--	19)	CTRL + T – Exibe o Resultado como Texto 
----------------------------------------------------------------------------------------------------------------------------
--	Útil quando utilizamos uma query dinâmica para retornar um script como resultado e depois copiamos o resultado para poder executar.
--	Por exemplo, utilizar uma query para montar um script para realizar o Backup de todas as databases da instância.
SELECT * FROM Tabela_Teste

SELECT 'BACKUP DATABASE ' + name + ' TO DISK = ''C:\SQL Server\' + name + '.bak'' WITH  FORMAT, CHECKSUM , COMPRESSION, STATS = 1'
FROM sys.databases
WHERE name <> 'tempdb'


----------------------------------------------------------------------------------------------------------------------------
--	20)	CTRL + D – Exibe o Resultado como Grid 
----------------------------------------------------------------------------------------------------------------------------
--	Exibe o resultado normalmente como uma tabela com as linhas numeradas a esquerda.


----------------------------------------------------------------------------------------------------------------------------
--	21)	F1 – Abre o Menu de Ajuda
----------------------------------------------------------------------------------------------------------------------------
--	Exibe o conteúdo de ajuda do SQL Server. Se algum texto estiver selecionado, será feito um filtro com esse texto.
SELECT CONVERT(VARCHAR(10), GETDATE(), 120)


----------------------------------------------------------------------------------------------------------------------------
--	22)	F2 – Altera o nome do objeto selecionado na janela do Object Explorer
----------------------------------------------------------------------------------------------------------------------------
--	OBS: Tomar bastante cuidado antes de alterar o nome de algum objeto para não causar erros em outras rotinas que o utilizam.
--		 Pois ao alterar o nome do objeto pelo Object Explorer, as rotinas que utilizam esse objeto não serão atualizadas para o novo nome.


----------------------------------------------------------------------------------------------------------------------------
--	23)	F3 – Localiza a próxima ocorrência do texto de pesquisa
----------------------------------------------------------------------------------------------------------------------------
--	Útil para ir para a próxima ocorrência da pesquisa sem precisar utilizar o mouse. Pode aumentar a sua produtividade.


----------------------------------------------------------------------------------------------------------------------------
--	24)	F4 – Exibe a janela de Propriedades
----------------------------------------------------------------------------------------------------------------------------
--	Exibe o painel de Propriedades com diversas informações. Por exemplo: Login name, Server name, SPID, etc...


----------------------------------------------------------------------------------------------------------------------------
--	25)	F5 – Executa a parte selecionada da query ou toda a query se nada estiver selecionado
----------------------------------------------------------------------------------------------------------------------------
--	OBS: Tomar bastante cuidado antes de executar um script, lembrando sempre de conferir se está na instância / database corretos.


----------------------------------------------------------------------------------------------------------------------------
--	26)	F6 – Alterna entre o painel de consulta e de resultados
----------------------------------------------------------------------------------------------------------------------------
--	Alterna o cursor do mouse entre o painel de consulta e de resultados.


----------------------------------------------------------------------------------------------------------------------------
--	27)	F7 – Exibe a janela Object Explorer Details com os detalhes dos objetos do Banco de Dados 
----------------------------------------------------------------------------------------------------------------------------
--	Muito útil para gerar o script de criação de vários objetos de uma database.


----------------------------------------------------------------------------------------------------------------------------
--	28)	F8 – Exibe a janela Object Explorer com os objetos do Banco de Dados 
----------------------------------------------------------------------------------------------------------------------------
--	Muito útil para visualizar os objetos do Banco de Dados. Por exemplo: Instâncias, databases, tabelas, procedures, etc...


----------------------------------------------------------------------------------------------------------------------------
--	29)	Selecionar Código + TAB – Incrementa uma identação no código selecionado
----------------------------------------------------------------------------------------------------------------------------
--	Fazer o teste com o código abaixo. Código para a direita ->
CREATE TABLE [dbo].[CheckList_Database_Growth_Email] (
	[Nm_Servidor]	VARCHAR(50) NULL,
	[Nm_Database]	VARCHAR(100) NULL,
	[Tamanho_Atual] NUMERIC(38, 2) NULL,
	[Cresc_1_dia]	NUMERIC(38, 2) NULL,
	[Cresc_15_dia]	NUMERIC(38, 2) NULL,
	[Cresc_30_dia]	NUMERIC(38, 2) NULL,
	[Cresc_60_dia]	NUMERIC(38, 2) NULL
)


----------------------------------------------------------------------------------------------------------------------------
--	30)	Selecionar Código + SHIFT + TAB – Decrementa uma identação no código selecionado
----------------------------------------------------------------------------------------------------------------------------
--	Fazer o teste com o código abaixo. Código para a esquerda <-
CREATE TABLE [dbo].[CheckList_Database_Growth_Email] (
		[Nm_Servidor]	VARCHAR(50) NULL,
		[Nm_Database]	VARCHAR(100) NULL,
		[Tamanho_Atual] NUMERIC(38, 2) NULL,
		[Cresc_1_dia]	NUMERIC(38, 2) NULL,
		[Cresc_15_dia]	NUMERIC(38, 2) NULL,
		[Cresc_30_dia]	NUMERIC(38, 2) NULL,
		[Cresc_60_dia]	NUMERIC(38, 2) NULL
)


----------------------------------------------------------------------------------------------------------------------------
--	31)	Alterar coloração da barra status (por instância) – “File -> Connect Object Explorer... -> Options -> Select -> Selecionar uma cor -> Connect”
----------------------------------------------------------------------------------------------------------------------------
--	Muito útil para diferenciar visualmente as instâncias do servidor. Pode identificar facilmente uma instância antes de executar um script em produção!
--	Por exemplo: 
--	Instancia 1: Produção			->	Cor: Vermelho
--	Instancia 2: Desenvolvimento	->	Cor: Amarelo
--	Instancia 3: Homologação		->	Cor: Verde


----------------------------------------------------------------------------------------------------------------------------
--	32)	CTRL + A – Seleciona todo o texto da query 
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	33)	SHIFT + PAGE UP – Seleciona uma pagina de texto para cima 
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	34)	SHIFT + PAGE DOWN – Seleciona uma pagina de texto para baixo 
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	35)	SHIFT + HOME – Seleciona o texto até o início da linha 
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	36)	SHIFT + END – Seleciona o texto até o final da linha 
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	37)	CTRL + SHIFT + ESC – Abre o Gerenciador de Tarefas 
----------------------------------------------------------------------------------------------------------------------------
--	Apesar de não fazer parte do Management Studio, é útil para auxiliar na análise de performance (CPU) e memória.


----------------------------------------------------------------------------------------------------------------------------
--	38)	CTRL + M – Habilita / Desabilita o Plano de Execução Atual 
----------------------------------------------------------------------------------------------------------------------------
--	Habilita / Desabilita a exibição do Plano de Execução Atual. O plano será exibido apenas quando algum código for executado.
SELECT * FROM Tabela_Teste where Nm_Cliente like 'Joao%'


----------------------------------------------------------------------------------------------------------------------------
--	39)	CTRL + L – Executa o Plano de Execução Estimado para o trecho de código selecionado
----------------------------------------------------------------------------------------------------------------------------
--	OBS: Exibe o plano de execução estimado para o trecho de código selecionado sem executar o código efetivamente.
SELECT * FROM Tabela_Teste where Nm_Cliente like 'Joao%'


----------------------------------------------------------------------------------------------------------------------------
--	40)	CTRL + ALT + P – Abre o SQL Server Profiler 
----------------------------------------------------------------------------------------------------------------------------
--	O SQL Server Profiler pode ser usado para visualizar sessões ao vivo de atividades no SQL Server. 
--	Podemos colher informações importantes como, por exemplo, quantas consultas o banco de dados está executando, quanto tempo estão demandando estas consultas, 
--	qual banco de dados está executando qual consulta e assim por diante.

--	Veja também:
--	http://www.fabriciolima.net/blog/2010/06/05/passo-a-passo-para-encontrar-as-querys-mais-demoradas-do-banco-de-dados-parte-1/
--	http://www.fabriciolima.net/blog/2010/06/05/passo-a-passo-para-encontrar-as-querys-mais-demoradas-do-banco-de-dados-parte-2/
--	http://www.fabriciolima.net/blog/2011/01/26/querys-do-dia-a-dia-acompanhando-as-querys-mais-demoradas-do-banco-de-dados/


----------------------------------------------------------------------------------------------------------------------------
--	41)	CTRL + 0 até CTRL + 9 – Executa o procedimento armazenado configurado para esses atalhos através dos menus ”Tools -> Options -> Environment -> Keyboard -> Query shortcuts”
----------------------------------------------------------------------------------------------------------------------------
--	Atalhos úteis para procedimentos executados com frequência. Podem aumentar a sua produtividade. Por Exemplo:
--	CTRL + 1 – Executar o procedimento armazenado do sistema ”sp_who”
--	CTRL + 2 – Executar o procedimento armazenado do sistema ”sp_lock”


----------------------------------------------------------------------------------------------------------------------------
--	42)	Gerar script colunas separadas por vírgula – Object Explorer + Arrastar "Columns" para a query
----------------------------------------------------------------------------------------------------------------------------
--	Útil quando você precisa fazer um SELECT / INSERT em uma tabela que possui muitas colunas.


----------------------------------------------------------------------------------------------------------------------------
--	43)	CTRL + U – Alterar a database Ao
----------------------------------------------------------------------------------------------------------------------------
--	atual pressionar as teclas o foco é alterado para a caixa de seleção com os nomes das databases.


----------------------------------------------------------------------------------------------------------------------------
--	44)	CTRL + ALT + T – Exibe a janela de Templates
----------------------------------------------------------------------------------------------------------------------------
--	Permite que você utilize scripts padronizados e com parametros para realizar tarefas repetitivas.
--	Após abrir o Template desejado, clique no menu "Query -> Specify Values for Template Parameters..." ou pressione CTRL + SHIFT + M.
--	Será aberta uma janela onde você deve preencher o valor do parâmetro no campo "Value".

--	Para criar o seu próprio template, clique com o botão direito em alguma pasta (ou crie uma nova) no painel "Template Explorer" -> New Template.
--	Coloque o nome desejado no arquivo que será criado. Agora, clique com o botão direito no arquivo -> "Edit" -> uma nova janela será aberta.
--	Por fim, basta escreve o script desejado e incluir o código <Parameter, Type, Value> como parâmetro.
--	OBS: Todas as ocorrências do código <Parameter, Type, Value> serão substituídas após o preenchimento dos parâmetros.

--	Referência:
--	http://sqlmag.com/database-administration/introduction-using-template-explorer-sql-server-management-studio


----------------------------------------------------------------------------------------------------------------------------
--	45)	CTRL + R – Exibe / Esconde o Painel de Resultado de query
----------------------------------------------------------------------------------------------------------------------------
--	Utilizado para exibir o Painel de Resultado ou para esconder e visualizar melhor o código da query.


----------------------------------------------------------------------------------------------------------------------------
--	46)	CTRL + SHIFT + C – Copia a grade de resultados e o cabeçalho para a área de transferência
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	47)	CTRL + N – Cria uma nova janela de query
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	48)	CTRL + O – Exibe a caixa de diálogo Abrir Arquivo para abrir um arquivo existente
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	49)	CTRL + SHIFT + N – Exibe a caixa de diálogo Novo Projeto
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--	50)	CTRL + S – Salva a query
----------------------------------------------------------------------------------------------------------------------------
--	OBS: Importante sempre salvar a query com as modificações realizadas para evitar perda em caso de desastres. Por exemplo: queda de energia.