use Traces
go

--exec stp_Load_all_Events  @help = 1 @fl_language = 'pt'
IF (OBJECT_ID('dbo.stp_Load_all_Events') IS  NULL) EXEC('CREATE PROCEDURE dbo.stp_Load_all_Events AS SELECT 1')
GO
ALTER PROCEDURE stp_Load_all_Events (@fl_language VARCHAR(2)= NULL, @help BIT = 0, @id VARCHAR(8) = NULL )


-----------------------------------------------------------------
-- Procedure stp_Load_all_Events, for help in creating a trace on profiler with t-sql
--
-- version 0.0.1 - created by: Leonardo Medeiros
--
-- last update = 02/01/2021
-----------------------------------------------------------------

AS
BEGIN

IF @help = 1 
BEGIN
		PRINT '/-----------------------------------------------------------/'
		PRINT 'Procedure para exibir os valores do event, para utilizarmos na query de criar um trace do profiler via t-sql'
		PRINT 'Alguns parametros que podem ser usados na execução dessa procedure'
		PRINT '                                                                                                             '
		PRINT '@fl_language = se colocar pt ira exbiir o resultado completo no idioma portugues, se digitar en, irá exibir em inglês,'
		PRINT'se nao colocar nada, o sql gera com base no idioma da sua instancia'
		PRINT ''
		PRINT '@id = por default, a proc vai exibir os dados sem utilizar filtro no where, ira exibir os 182 eventos,' 
		PRINT'se você quiser, filtrar algum pelo ID, deve informar na variavel @ID = 10 por exemplo, ´PORÉM SÓ FUNCIONA QUANDO O IDIMOA FOR  INGLÊS'
		PRINT '/-----------------------------------------------------------/'
		RETURN;
END

SET NOCOUNT ON


		
    SET @fl_language = (CASE
        WHEN NULLIF(LTRIM(RTRIM(@fl_language)), '') IS NULL THEN (SELECT CASE WHEN [value] IN (5, 7, 27) THEN 'pt' ELSE 'en' END FROM sys.configurations WHERE [name] = 'default language')
        ELSE @fl_language
		END)
-----------------
-- idioma
-----------------



IF @fl_language = 'pt'
BEGIN 
		IF OBJECT_ID('tempdb..#TracesEvent') IS NOT NULL
		DROP TABLE tempdb..#TracesEvent
		CREATE TABLE tempdb..#TracesEvent 
		(
		numero_do_evento varchar(8),
		Nome_Do_Evento varchar(200),
		Descricao varchar(max))
		
		CREATE CLUSTERED INDEX  SK01_#TracesEvent ON #TracesEvent (numero_do_evento)
		
		CREATE NONCLUSTERED INDEX SK21_#TracesEvent ON #TracesEvent (numero_do_evento) INCLUDE (Nome_Do_Evento,Descricao)
		
		INSERT INTO tempdb..#TracesEvent  VALUES (
		'0-9', 'Reservado','Reservado'),
		('10','RPC:Completed','Ocorre quando uma RPC (chamada de procedimento remoto) é concluída'),
		('11' ,'RPC:Starting', 	'Ocorre quando uma RPC é iniciada'),
		('12','SQL:BatchCompleted','Ocorre quando um lote Transact-SQL é concluído'),
		('13','SQL:BatchStarting','Ocorre quando um lote Transact-SQL é iniciado'),
		('14','Auditar logon','Ocorre quando um usuário faz logoff do SQL Server'),
		('15','Auditar logoff','Ocorre quando um usuário faz logoff do SQL Server'),
		('16' ,'Attention' ,'Ocorre quando eventos de atenção, como solicitações de interrupção de cliente ou conexões de cliente interrompidas, acontecem'),
		('17','ExistingConnection', 	'Detecta toda a atividade dos usuários conectados ao SQL Server antes do início do rastreamento')
		,('18 	','Audit Server Starts and Stops','Ocorre quando o estado de serviço do SQL Server é modificado.')
		,('19 	','DTCTransaction','Rastreia as transações do MS DTC (Microsoft Distributed Transaction Coordinator) entre dois ou mais bancos de dados.')
		,('20 	','Audit Login Failed','Indica que uma tentativa de logon no SQL Server de um cliente falhou.')
		,('21 	','EventLog','Indica que os eventos foram registrados no log de aplicativo do Windows.')
		,('22 	','ErrorLog','Indica que eventos de erro foram registrados no log de erros do SQL Server .')
		,('23 	','Lock:Released','Indica que um bloqueio em um recurso, como uma página, foi liberado.')
		,('24 	','Lock:Acquired','Indica a aquisição de um bloqueio em um recurso, como uma página de dados.')
		,('25 	','Lock:Deadlock','Indica que duas transações simultâneas fizeram deadlock uma na outra ao tentar obter bloqueios incompatíveis em recursos de propriedade da outra transação.')
		,('26 	','Lock:Cancel','Indica que a aquisição de um bloqueio em um recurso foi cancelada (por exemplo, devido a um deadlock')
		,('27 	','Lock:Timeout ','Indica que uma solicitação para um bloqueio em um recurso, como uma página, expirou por causa de outra transação que estava mantendo um bloqueio no recurso necessário. O tempo limite é determinado pela função @ @LOCK_TIMEOUT e pode ser definido com a instrução set LOCK_TIMEOUT.')
		,('28 	','Degree of Parallelism Event (7.0 Insert)','Acontece antes de uma instrução SELECT, INSERT ou UPDATE ser executada')
		,('29-31 ','	Reservado' ,'Use o Evento 28 em vez disso')		
		,('32 ','Reservado',	'Reservado')
		,('33' ,'Exceção','Indica que uma exceção ocorreu no SQL Server')
		,('34 	','SP:CacheMiss' ,'Indica quando um procedimento armazenado não é localizado no cache de procedimento')
		,('35 	','SP:CacheInsert','Indica quando um item é inserido no cache de procedimento.')
		,('36 	','SP:CacheRemove ','Indica quando um item é removido do cache de procedimento.')
		,('37 	','SP:Recompile','Indica que um procedimento armazenado foi recompilado.')
		,('38 	','SP:CacheHit','Indica quando um procedimento armazenado é localizado no cache de procedimento.')
		,('39 	','Preterido', 'Preterido')
		,('40 	','SQL:StmtStarting','Ocorre quando a instrução Transact-SQL é iniciada.')
		,('41 	','SQL:StmtCompleted','Ocorre quando a instrução Transact-SQL é concluída.')
		,('42 	','SP:Starting','Indica quando o procedimento armazenado é iniciado.')
		,('43 	','SP:Completed','Indica quando o procedimento armazenado é concluído.')
		,('44 	','SP:StmtStarting','Indica que a execução de uma instrução Transact-SQL em um procedimento armazenado foi iniciada.')
		,('45 	','SP:StmtCompleted','Indica que a execução de uma instrução Transact-SQL em um procedimento armazenado foi concluída.')
		,('46 	','Object:Created','Indica que um objeto foi criado, tal como para as instruções CREATE INDEX, CREATE TABLE e CREATE DATABASE.')
		,('47 	','Object:Deleted','Indica que um objeto foi excluído, tal como nas instruções DROP INDEX e DROP TABLE.')
		,('48 	','Reservado','')
		,('49 	','Reservado','')
		,('50 	','SQL Transaction','Rastreia as seguintes instruções Transact-SQL: BEGIN TRAN, COMMIT TRAN, SAVE TRAN e ROLLBACK TRAN.')
		,('51 	','Scan:Started' ,'Indica quando foi iniciada uma verificação de tabela ou de índice.')
		,('52 	','Scan:Stopped','Indica quando foi interrompida uma verificação de tabela ou de índice.')
		,('53 	','CursorOpen','Indica quando um cursor é aberto em uma instrução Transact-SQL por ODBC, OLE DB ou DB-Library.')
		,('54 	','TransactionLog','Rastreia quando as transações são gravadas no log de transações.')
		,('55 	','Hash Warning	','Indica que uma operação de hash (por exemplo, junção hash, agregação de hash, união de hash e distinção de hash) que não está sendo processada em uma partição de buffer foi revertida para um plano alternativo. Isso pode ocorrer por causa de profundidade de recursão, distorção de dados, sinalizadores de rastreamento ou contagem de bits.')
		,('56-57 ','	Reservado ','')
		,('58 	','Auto Stats','Indica que ocorreu uma atualização automática de estatísticas de índice.')
		,('59 	','Lock:Deadlock Chain','Produzido para cada um dos eventos que resultam no deadlock.')
		,('60 	','Lock:Escalation ','Indica que um bloqueio mais refinado foi convertido em um bloqueio mais rústico (por exemplo, um bloqueio de página escalonado ou convertido em um bloqueio TABLE ou HoBT).')
		,('61 	','OLE DB Errors','Indica que ocorreu um erro OLE DB.')
		,('62-66 ','	Reservado ','')
		,('67 	','Execution Warnings','Indicam qualquer aviso que ocorreu durante a execução de uma instrução ou um procedimento armazenado do SQL Server.')
		,('68 	','Showplan Text (Unencoded)','Exibe a árvore de plano da instrução Transact-SQL executada.')
		,('69 	','Sort Warnings','Indica operações de classificação que não cabem na memória. Isso não inclui operações de classificação envolvendo a criação de índices, mas somente operações de classificação em uma consulta (como uma cláusula ORDER BY usada em uma instrução SELECT).')
		,('70 	','CursorPrepare','Indica quando um cursor em uma instrução Transact-SQL está pronto para ser usado por ODBC, OLE DB ou DB-Library.')
		,('71 	','Prepare SQL ','ODBC, OLE DB ou DB-Library preparou uma instrução Transact-SQL ou instruções para uso.')
		,('72 	','Exec Prepared SQL','ODBC, OLE DB ou DB-Library executou uma instrução ou instruções Transact-SQL preparadas.')
		,('73 	','Unprepare SQL','ODBC, OLE DB ou DB-Library despreparou (excluiu) uma instrução ou instruções Transact-SQL preparadas.')
		,('74 	','CursorExecute','Um cursor anteriormente preparado em uma instrução Transact-SQL por ODBC, OLE DB ou DB-Library é executado.')
		,('75 	','CursorRecompile ','Um cursor aberto em uma instrução Transact-SQL por ODBC, OLE DB, ou DB-Library foi recompilado diretamente ou devido a uma alteração de esquema. Disparado para cursores ANSI e não ANSI')
		,('76 	','CursorImplicitConversion','Um cursor em uma instrução Transact-SQL é convertido de um tipo para outro pelo SQL Server. Disparado para cursores ANSI e não ANSI.')
		,('77 	','CursorUnprepare','Um cursor preparado em uma instrução Transact-SQL é despreparado (excluído) por ODBC, OLE DB ou DB-Library.')
		,('78 	','CursorClose ','Um cursor anteriormente aberto em uma instrução Transact-SQL por ODBC, OLE DB, ou DB-Library foi fechado.')
		,('79 	','Missing Column Statistics','Estatísticas de coluna que podem ter sido úteis para o otimizador não estão disponíveis.')
		,('80 	','Missing Join Predicate','A consulta que está sendo executada não tem nenhum predicado de junção. Isso pode resultar em uma consulta de longa execução.')
		,('81 	','Server Memory Change','O uso de memória do SQL Server aumentou ou diminuiu em 1 megabyte (MB) ou em 5 por cento da memória máxima de servidor, o que for maior.')
		,('82-91 ','	User Configurable (0-9)','Dados de evento definidos pelo usuário.')
		,('92 	','Data File Auto Grow','Indica que um arquivo de dados foi automaticamente estendido pelo servidor.')
		,('93 	','Log File Auto Grow ','Indica que um arquivo de log foi automaticamente estendido pelo servidor.')
		,('94 	','Data File Auto Shrink ','Indica que um arquivo de dados foi automaticamente reduzido pelo servidor.')
		,('95 	','Log File Auto Shrink ','Indica que um arquivo de log foi automaticamente reduzido pelo servidor.')
		,('96 	','Showplan Text','Exibe a árvore de plano de consulta da instrução SQL a partir do otimizador de consulta. Observe que a coluna TextData não contém o Showplan para esse evento.')
		,('97 	','Showplan All','Exibe o plano de consulta com detalhes completos de tempo de compilação da instrução SQL executada. Observe que a coluna TextData não contém o Showplan para esse evento.')
		,('98 	','Showplan Statistics Profile','Exibe o plano de consulta com detalhes completos de tempo de execução da instrução SQL executada. Observe que a coluna TextData não contém o Showplan para esse evento.')
		,('99 	','Reservado','')
		,('100 	','RPC Output Parameter','Produz valores de saída dos parâmetros para todo RPC.')
		,('101 	','Reservado','')
		,('102 	','Audit Database Scope GDR ','Ocorre sempre que GRANT, DENY, REVOKE é emitido para uma permissão de instrução por qualquer usuário no SQL Server para ações somente de banco de dados, como conceder permissões em um banco de dados.')
		,('103 	','Evento Audit Object GDR','Ocorre sempre que um GRANT, DENY, REVOKE para uma permissão de objeto é emitido por qualquer usuário no SQL Server.')
		,('104 	','Evento Audit AddLogin','Ocorre quando um SQL Server logon é adicionado ou removido; por sp_addlogin e sp_droplogin.')
		,('105 	','Evento Audit Login GDR','Ocorre quando um direito de logon do Windows é adicionado ou removido; para sp_grantlogin, sp_revokelogine sp_denylogin.')
		,('106 	','Evento Audit Login Change Property','Ocorre quando uma propriedade de um logon, exceto senhas, é modificada; para sp_defaultdb e sp_defaultlanguage.')
		,('107 	','Evento Audit Login Change Password','Ocorre quando uma senha de logon do SQL Server é alterada. As senhas não são registradas.')
		,('108 	','Evento Audit Add Login to Server Role','Ocorre quando um logon é adicionado ou removido de uma função de servidor fixa; para sp_addsrvrolemembere sp_dropsrvrolemember.')
		,('109 	','Evento Audit Add DB User','Ocorre quando um logon é adicionado ou removido como um usuário de banco de dados (Windows ou SQL Server ) para um banco de dados; para sp_grantdbaccess, sp_revokedbaccess, sp_addusere sp_dropuser.')
		,('110 	','Evento Audit Add Member to DB Role','Ocorre quando um logon é adicionado ou removido como um usuário de banco de dados (fixo ou definido pelo usuário) para um banco de dados; para sp_addrolemember, sp_droprolemembere sp_changegroup.')
		,('111 	','Evento Audit Add Role ','Ocorre quando um logon é adicionado ou removido como um usuário de banco de dados para um banco de dados; para sp_addrole e sp_droprole.')
		,('112 	','Evento Audit App Role Change Password ','Ocorre quando uma senha de uma função de aplicativo é alterada.')
		,('113 	','Evento Audit Statement Permission','Ocorre quando uma permissão de instrução (como CREATE TABLE) é usada.')
		,('114 	','Evento Audit Schema Object Access','Ocorre quando uma permissão de objeto (como SELECT) é usada, com êxito ou não.')
		,('115 	','Audit Backup/Restore Event','Ocorre quando um comando BACKUP ou RESTORE é emitido.')
		,('116 	','Evento Audit DBCC ','Ocorre quando comandos DBCC são emitidos.')
		,('117 	','Evento Audit Change Audit ','Ocorre quando são feitas modificações de rastreamento de auditoria.')
		,('118 	','Evento Audit Object Derived Permission','Ocorre quando um comando de objeto CREATE, ALTER e DROP é emitido.')
		,('119 	','Evento OLEDB Call','Ocorre quando as chamadas de provedor OLE DB são feitas para consultas distribuídas e procedimentos armazenados remotos.')
		,('120 	','Evento OLEDB QueryInterface','Ocorre quando OLE DB chamadas de QueryInterface são feitas para consultas distribuídas e procedimentos armazenados remotos.')
		,('121 	','Evento OLEDB DataRead','Ocorre quando uma chamada de solicitação de dados é feita ao provedor OLE DB.')
		,('122 	','Showplan XML','Ocorre quando uma instrução SQL é executada. Inclua este evento para identificar operadores de plano de execução. Cada evento é armazenado em um documento XML bem formado. Observe que a coluna Binary desse evento contém o Showplan codificado. Use o SQL Server Profiler para abrir o rastreamento e exibir o plano de execução.')
		,('123 	','SQL:FullTextQuery','Ocorre quando uma consulta de texto completo é executada.')
		,('124 	','Broker:Conversation','Relata o progresso de uma conversa do Agente de Serviço.')
		,('125 	','Deprecation Announcement ','Ocorre quando é usado um recurso que será removido de uma versão futura do SQL Server.')
		,('126 	','Deprecation Final Support','Ocorre quando é usado um recurso que será removido da próxima versão principal do SQL Server.')
		,('127 	','Evento Exchange Spill','Ocorre quando os buffers de comunicação em um plano de consulta paralelo foram gravados temporariamente no banco de dados tempdb .')
		,('128 	','Evento Audit Database Management','Ocorre quando um banco de dados é criado, alterado ou descartado.')
		,('129 	','Evento Audit Database Object Management','Ocorre quando uma instrução CREATE, ALTER ou DROP é executada em objetos de banco de dados, como esquemas.')
		,('130 	','Evento Audit Database Principal Management ','Ocorre quando os principais, como usuários, são criados, alterados ou descartados de um banco de dados.')
		,('131 	','Evento Audit Schema Object Management','Ocorre quando objetos de servidor são criados, alterados ou descartados.')
		,('132 	','Evento Audit Server Principal Impersonation','Ocorre quando há uma representação no escopo de servidor, como EXECUTE LOGIN AS.')
		,('133 	','Evento Audit Database Principal Impersonation','Ocorre quando uma representação acontece no escopo de banco de dados, como EXECUTE AS USER ou SETUSER.')
		,('134 	','Evento Audit Server Object Take Ownership','Ocorre quando o proprietário é alterado para objetos no escopo de servidor.')
		,('135 	','Evento Audit Database Object Take Ownership','Ocorre quando acontece uma alteração de proprietário para objetos no escopo de banco de dados.')
		,('136 	','Broker:Conversation Group' ,'Ocorre quando o Agente de Serviço cria um novo grupo de conversa ou descarta um existente.')
		,('137 	','Blocked Process Report','Ocorre quando um processo foi bloqueado para mais do que um período especificado. Não inclui processos do sistema ou processos que estão aguardando em recursos não detectáveis por deadlock. Use sp_configure para configurar o limite e a frequência em que os relatórios são gerados.')
		,('138 	','Broker:Connection ','Relata o status de uma conexão de transporte administrada pelo Agente de Serviço.')
		,('139 	','Broker:Forwarded Message Sent','Ocorre quando o Agente de Serviço encaminha uma mensagem.')
		,('140 	','Broker:Forwarded Message Dropped','Ocorre quando o Agente de Serviço descarta uma mensagem destinada a ser encaminhada.')
		,('141 	','Broker:Message Classify','Ocorre quando o Agente de Serviço determina o roteamento para uma mensagem.')
		,('142 	','Broker:Transmission' ,'Indica que erros ocorreram na camada de transporte do Agente de Serviço. O número do erro e os valores de estado indicam a origem do erro.')
		,('143 ','Broker:Queue Disabled','Indica que uma mensagem suspeita foi detectada porque havia cinco reversões de transação sucessivas em uma fila do Agente de Serviço. O evento contém a ID do banco de dados e a ID de fila da fila que contém a mensagem suspeita.')
		,('144-145','Reservado','') 									
		,('146 	','Showplan XML Statistics Profile','Ocorre quando uma instrução SQL é executada. Identifica os operadores de plano de execução e exibe dados de tempo de compilação completos. Observe que a coluna Binary desse evento contém o Showplan codificado. Use o SQL Server Profiler para abrir o rastreamento e exibir o plano de execução.')
		,('148 	','Deadlock Graph','Ocorre quando uma tentativa para adquirir um bloqueio é cancelada porque a tentativa fazia parte de um deadlock e foi escolhida como a vítima de deadlock. Fornece uma descrição XML de um deadlock.')
		,('149 	','Broker:Remote Message Acknowledgement','Ocorre quando o Agente de Serviço envia ou recebe uma confirmação de mensagem.')
		,('150 	','Trace File Close','Ocorre quando um arquivo de rastreamento é fechado durante a sua substituição.')
		,('151 	','Reservado '	,'')
		,('152 	','Audit Change Database Owner','Ocorre quando a instrução ALTER AUTHORIZATION é usada para alterar o proprietário de um banco de dados e as permissões são marcadas para fazer isso.')
		,('153 	','Evento Audit Schema Object Take Ownership','Ocorre quando a instrução ALTER AUTHORIZATION é usada para atribuir um proprietário a um objeto e as permissões para fazer isso estão marcadas.')
		,('154 	','Reservado' ,'')
		,('155 	','FT:Crawl Started ','Ocorre quando um rastreamento (população) de texto completo é iniciado. Use para verificar se uma solicitação de rastreamento está sendo selecionada por tarefas de trabalhado.')
		,('156 	','FT:Crawl Stopped','Ocorre quando um rastreamento (população) de texto completo é interrompido. As interrupções acontecem quando um rastreamento é concluído com êxito ou quando ocorre um erro fatal.')
		,('157 	','FT:Crawl Aborted','Ocorre quando uma exceção é encontrada em um rastreamento de texto completo. Em geral, provoca a interrupção do rastreamento de texto completo.')
		,('158 	','Audit Broker Conversation' ,'Relata mensagens de auditoria relacionadas à segurança de diálogo do Agente de Serviço.')
		,('159 	','Audit Broker Login','Relata mensagens de auditoria relacionadas à segurança de transporte do Agente de Serviço.')
		,('160 	','Broker:Message Undeliverable','Ocorre quando o Agente de Serviço não pode reter uma mensagem recebida que deve ser entregue a um serviço.')
		,('161 	','Broker:Corrupted Message','Ocorre quando o Agente de Serviço recebe uma mensagem corrompida.')
		,('162 	','User Error Message' ,'Exibe mensagens de erro que os usuários veem no caso de um erro ou uma exceção.')
		,('163 	','Broker:Activation' ,'Ocorre quando um monitor de fila inicia um procedimento armazenado de ativação, envia uma notificação QUEUE_ACTIVATION ou quando um procedimento armazenado de ativação iniciado por um monitor de fila é encerrado.')
		,('164 	','Object:Altered','Ocorre quando um objeto de banco de dados é alterado.')
		,('165 	','Performance statistics'	,'Ocorre quando um plano de consulta compilado foi armazenado em cache pela primeira vez, recompilado ou removido do cache do plano.')
		,('166 	','SQL:StmtRecompile','Ocorre quando uma recompilação do nível de instrução acontece.')
		,('167 	','Database Mirroring State Change','Ocorre quando o estado de um banco de dados espelho é alterado.')
		,('168 	','Showplan XML For Query Compile','Ocorre quando uma instrução SQL é compilada. Exibe os dados de tempo de compilação completos. Observe que a coluna Binary desse evento contém o Showplan codificado. Use o SQL Server Profiler para abrir o rastreamento e exibir o plano de execução.')
		,('169 	','Showplan All For Query Compile','Ocorre quando uma instrução SQL é compilada. Exibe dados completos e em tempo de compilação. Use para identificar operadores de plano de execução')
		,('170 	','Evento Audit Server Scope GDR','Indica que ocorreu um evento de concessão, recusa ou revogação para permissões no escopo de servidor, tal como criar um logon.')
		,('171 	','Evento Audit Server Object GDR','Indica que ocorreu um evento de concessão, negação ou revogação para um objeto de esquema, tal como uma tabela ou função.')
		,('172 	','Evento Audit Database Object GDR','Indica que ocorreu um evento de concessão, negação ou revogação para objetos de banco de dados, tal como assemblies e esquemas.')
		,('173 	','Evento Audit Server Operation','Ocorre quando são usadas operações de Segurança Auditoria, tal como alterar configurações, recursos, acesso externo ou autorização.')
		,('175 	','Evento Audit Server Alter Trace','Ocorre quando uma instrução verifica a permissão ALTER TRACE.')
		,('176 	','Evento Audit Server Object Management','Ocorre quando objetos de servidor são criados, alterados ou descartados.')
		,('177 	','Evento Audit Server Principal Management' ,'Ocorre quando principais são criados, alterados ou descartados.')
		,('178 	','Evento Audit Database Operation','Ocorre quando ocorrem operações de banco de dados, tal como ponto de verificação ou notificação de consulta de assinatura.')
		,('180 	','Evento Audit Database Object Access','Ocorre quando são acessados objetos de banco de dados, tal como esquemas.')
		,('181 	','TM: Begin Tran starting','Ocorre quando uma solicitação BEGIN TRANSACTION é iniciada.')
		,('182 	','TM: Begin Tran completed ','Ocorre quando uma solicitação BEGIN TRANSACTION é concluída.')
		,('183 	','TM: Promote Tran starting','Ocorre quando uma solicitação PROMOTE TRANSACTION é iniciada.')
		,('184 	','TM: Promote Tran completed' ,'Ocorre quando uma solicitação PROMOTE TRANSACTION é concluída.')
		,('185 	','TM: Commit Tran starting ','Ocorre quando uma solicitação COMMIT TRANSACTION é iniciada.')
		,('186 	','TM: Commit Tran completed ','Ocorre quando uma solicitação COMMIT TRANSACTION é concluída.')
		,('187 	','TM: Rollback Tran starting ','Ocorre quando uma solicitação ROLLBACK TRANSACTION é iniciada.')
		,('188 	','TM: Rollback Tran completed','Ocorre quando uma solicitação ROLLBACK TRANSACTION é concluída.')
		,('189 	','Bloqueio: tempo limite (tempo limite > 0)','Ocorre quando uma solicitação para um bloqueio em um recurso, como uma página, expira.')
		,('190 	','Progress Report: Online Index Operation','Relata o progresso de uma operação de criação de índice online quando o processo de criação está sendo executado.')
		,('191 	','TM: Save Tran starting','Ocorre quando uma solicitação SAVE TRANSACTION é iniciada.')
		,('192 	','TM: Save Tran completed','Ocorre quando uma solicitação SAVE TRANSACTION é concluída.')
		,('193 	','Background Job Error','Ocorre quando um trabalho em segundo plano é terminado de maneira anormal.')
		,('194 	','OLEDB Provider Information','Ocorre quando uma consulta distribuída é executada e coleta informações que correspondem à conexão de provedor.')
		,('195 	','Mount Tape','Ocorre quando uma solicitação de montagem de fita é recebida.')
		,('196 	','Assembly Load','Ocorre quando acontece uma solicitação para carregar um assembly CLR.')
		,('197 	','Reservado ','')
		,('198 	','XQuery Static Type','Ocorre quando uma expressão XQuery é executada. Essa classe de evento fornece o tipo estático da expressão XQuery.')
		,('199 	','QN: subscription ','Ocorre quando um registro de consulta não pode ser assinado. A coluna TextData contém informações sobre o evento.')
		,('200 	','QN: parameter table','Informações sobre assinaturas ativas são armazenadas em tabelas de parâmetro internas. Esta classe de evento ocorre quando uma tabela de parâmetro é criada ou excluída. Normalmente, essas tabelas são criadas ou excluídas quando o banco de dados é reiniciado. A coluna TextData contém informações sobre o evento.')
		,('201 	','QN: template','Um modelo de consulta representa uma classe de consultas de assinatura. Normalmente, as consultas de mesma classe são idênticas com exceção dos valores de parâmetro. Essa classe de evento ocorre quando uma nova solicitação de assinatura se enquadra em uma classe já existente de (Match), uma nova classe (Create) ou uma classe Drop, que indica a limpeza de modelos para classes de consulta sem assinaturas ativas. A coluna TextData contém informações sobre o evento.')
		,('202 	','QN: dynamics','Rastreia atividades internas de notificações de consulta. A coluna TextData contém informações sobre o evento.')
		,('212 	','Aviso de bitmap','Indica quando os filtros do bitmap foram desabilitados em uma consulta.')
		,('213 	','Database Suspect Data Page','Indica quando uma página é adicionada à tabela de suspect_pages no msdb.')
		,('214 	','Limite de CPU excedido','Indica quando o Administrador de Recursos detecta que uma consulta excedeu o valor do limite de CPU em (REQUEST_MAX_CPU_TIME_SEC.')
		,('215 	','PreConnect:Starting','Indica quando uma função do gatilho LOGON ou do classificador Administrador de Recursos inicia a execução.')
		,('216 	','PreConnect:Completed','Indica quando uma função do gatilho LOGON ou do classificador Administrador de Recursos conclui a execução.')
		,('217 ','Guia de plano bem-sucedido','Indica que o SQL Server produziu com sucesso um plano de execução para uma consulta ou lote, que continha um guia de plano.')
		,('218 ','Guia de plano malsucedido','Indica que o SQL Server não pôde produzir um plano de execução, para uma consulta ou lote, que continha um guia de plano. O SQL Server tentou gerar um plano de execução para esta consulta ou lote sem aplicar o guia de plano. Um guia de plano inválido pode ser a causa deste problema. Você pode validar o guia de plano usando a função de sistema sys.fn_validate_plan_guide.')
		,('235', 'Audit Fulltext','')




END


ELSE IF (@fl_language = 'en')
 BEGIN 
		IF OBJECT_ID('tempdb..##TracesEvent2') IS NOT NULL
		DROP TABLE tempdb..#TracesEvent2
		CREATE TABLE tempdb..#TracesEvent2
		(
		event_number varchar(8),
		event_name varchar(200),
		description_ varchar(max))
		
			CREATE CLUSTERED INDEX  SK01_#TracesEvent ON #TracesEvent2 (event_number)
		
		CREATE NONCLUSTERED INDEX SK21_#TracesEvent ON #TracesEvent2 (event_number) INCLUDE(event_name,description_)
		
		
		INSERT INTO tempdb..#TracesEvent2  VALUES (
		
 '0-9' 	,'Reserved','Reserved'),
('10' 	,'RPC:Completed','Occurs when a remote procedure call (RPC) has completed.')
,('11' 	,'RPC:Starting','Occurs when an RPC has started.')
,('12' 	,'SQL:BatchCompleted','Occurs when a Transact-SQL batch has completed.')
,('13' 	,'SQL:BatchStarting','Occurs when a Transact-SQL batch has started.')
,('14' 	,'Audit Login','Occurs when a user successfully logs in to SQL Server.')
,('15' 	,'Audit Logout','Occurs when a user logs out of SQL Server.')
,('16' 	,'Attention','Occurs when attention events, such as client-interrupt requests or broken client connections, happen.')
,('17' 	,'ExistingConnection','Detects all activity by users connected to SQL Server before the trace started.')
,('18' 	,'Audit Server Starts and Stops','Occurs when the SQL Server service state is modified.')
,('19' 	,'DTCTransaction','Tracks Microsoft Distributed Transaction Coordinator (MS DTC) coordinated transactions between two or more databases.')
,('20' 	,'Audit Login Failed','Indicates that a login attempt to SQL Server from a client failed.')
,('21' 	,'EventLog','Indicates that events have been logged in the Windows application log.')
,('22' 	,'ErrorLog','Indicates that error events have been logged in the SQL Server error log.')
,('23' 	,'Lock:Released','Indicates that a lock on a resource, such as a page, has been released.')
,('24' 	,'Lock:Acquired','Indicates acquisition of a lock on a resource, such as a data page.')
,('25' 	,'Lock:Deadlock','Indicates that two concurrent transactions have deadlocked each other by trying to obtain incompatible locks on resources the other transaction owns.')
,('26' 	,'Lock:Cancel','Indicates that the acquisition of a lock on a resource has been canceled (for example, due to a deadlock).')
,('27' 	,'Lock:Timeout ','Indicates that a request for a lock on a resource, such as a page, has timed out due to another transaction holding a blocking lock on the required resource. Time-out is determined by the @@LOCK_TIMEOUT function, and can be set with the SET LOCK_TIMEOUT statement.')
,('28' 	,'Degree of Parallelism Event (7.0 Insert)','Occurs before a SELECT, INSERT, or UPDATE statement is executed.')
,('29-31' ,'	Reserved ','Use Event 28 instead.')
,('32' 	,'Reserved','Reserved')
,('33' 	,'Exception','Indicates that an exception has occurred in SQL Server.')
,('34' 	,'SP:CacheMiss','Indicates when a stored procedure is not found in the procedure cache.')
,('35' 	,'SP:CacheInsert','Indicates when an item is inserted into the procedure cache.')
,('36' 	,'SP:CacheRemove','Indicates when an item is removed from the procedure cache.')
,('37' 	,'SP:Recompile ','Indicates that a stored procedure was recompiled.')
,('38' 	,'SP:CacheHit ','Indicates when a stored procedure is found in the procedure cache.')
,('39' 	,'Deprecated','Deprecated')
,('40' 	,'SQL:StmtStarting ','Occurs when the Transact-SQL statement has started.')
,('41' 	,'SQL:StmtCompleted ','Occurs when the Transact-SQL statement has completed.')
,('42' 	,'SP:Starting ','Indicates when the stored procedure has started.')
,('43' 	,'SP:Completed ','Indicates when the stored procedure has completed.')
,('44' 	,'SP:StmtStarting','Indicates that a Transact-SQL statement within a stored procedure has started executing.')
,('45' 	,'SP:StmtCompleted ','Indicates that a Transact-SQL statement within a stored procedure has finished executing.')
,('47' 	,'Object:Deleted ','Indicates that an object has been deleted, such as in DROP INDEX and DROP TABLE statements.')
,('46' 	,'Object:Created ','Indicates that an object has been created, such as for CREATE INDEX, CREATE TABLE, and CREATE DATABASE statements.')
,('48' 	,'Reserved ', '')   	
,('49' 	,'Reserved ','')	
,('50' 	,'SQL Transaction ','Tracks Transact-SQL BEGIN, COMMIT, SAVE, and ROLLBACK TRANSACTION statements.')
,('51' 	,'Scan:Started','Indicates when a table or index scan has started.')
,('52' 	,'Scan:Stopped ','Indicates when a table or index scan has stopped.')
,('53' 	,'CursorOpen ','Indicates when a cursor is opened on a Transact-SQL statement by ODBC, OLE DB, or DB-Library.')
,('54' 	,'TransactionLog ','Tracks when transactions are written to the transaction log.')
,('55' 	,'Hash Warning ','Indicates that a hashing operation (for example, hash join, hash aggregate, hash union, and hash distinct) that is not processing on a buffer partition has reverted to an alternate plan. This can occur because of recursion depth, data skew, trace flags, or bit counting.')
,('56-57' ,'	Reserved','')	
,('58' 	,'Auto Stats ','Indicates an automatic updating of index statistics has occurred.')
,('59' 	,'Lock:Deadlock Chain ','Produced for each of the events leading up to the deadlock.')
,('60' 	,'Lock:Escalation','Indicates that a finer-grained lock has been converted to a coarser-grained lock (for example, a page lock escalated or converted to a TABLE or HoBT lock).')
,('61' 	,'OLE DB Errors','Indicates that an OLE DB error has occurred.')
,('62-66' ,'	Reserved','')
,('67' 	,'Execution Warnings ','Indicates any warnings that occurred during the execution of a SQL Server statement or stored procedure.')
,('68' 	,'Showplan Text (Unencoded)','Displays the plan tree of the Transact-SQL statement executed.')
,('69' 	,'Sort Warnings ','Indicates sort operations that do not fit into memory. Does not include sort operations involving the creating of indexes; only sort operations within a query (such as an ORDER BY clause used in a SELECT statement).')
,('70' 	,'CursorPrepare ','Indicates when a cursor on a Transact-SQL statement is prepared for use by ODBC, OLE DB, or DB-Library.')
,('71' 	,'Prepare SQL','ODBC, OLE DB, or DB-Library has prepared a Transact-SQL statement or statements for use.')
,('72' 	,'Exec Prepared SQL','ODBC, OLE DB, or DB-Library has executed a prepared Transact-SQL statement or statements.')
,('73' 	,'Unprepare SQL','ODBC, OLE DB, or DB-Library has unprepared (deleted) a prepared Transact-SQL statement or statements.')
,('74' 	,'CursorExecute ','A cursor previously prepared on a Transact-SQL statement by ODBC, OLE DB, or DB-Library is executed.')
,('75' 	,'CursorRecompile','A cursor opened on a Transact-SQL statement by ODBC or DB-Library has been recompiled either directly or due to a schema change. Triggered for ANSI and non-ANSI cursors.')
,('76' 	,'CursorImplicitConversion ','A cursor on a Transact-SQL statement is converted by SQL Server from one type to another. Triggered for ANSI and non-ANSI cursors.')
,('77' 	,'CursorUnprepare ','A prepared cursor on a Transact-SQL statement is unprepared (deleted) by ODBC, OLE DB, or DB-Library.')
,('78' 	,'CursorClose','A cursor previously opened on a Transact-SQL statement by ODBC, OLE DB, or DB-Library is closed.')
,('79' 	,'Missing Column Statistics ','Column statistics that could have been useful for the optimizer are not available.')
,('80' 	,'Missing Join Predicate ','Query that has no join predicate is being executed. This could result in a long-running query.')
,('81' 	,'Server Memory Change ','SQL Server memory usage has increased or decreased by either 1 megabyte (MB) or 5 percent of the maximum server memory, whichever is greater.')
,('82-91' ,'	User Configurable (0-9)','Event data defined by the user.')
,('92 '	,'Data File Auto Grow ','Indicates that a data file was extended automatically by the server.')
,('93 '	,'Log File Auto Grow ','Indicates that a log file was extended automatically by the server.')
,('94 '	,'Data File Auto Shrink ','Indicates that a data file was shrunk automatically by the server.')
,('95 '	,'Log File Auto Shrink ','Indicates that a log file was shrunk automatically by the server.')
,('96 '	,'Showplan Text ','Displays the query plan tree of the SQL statement from the query optimizer. Note that the TextData column does not contain the Showplan for this event.')
,('97 '	,'Showplan All','Displays the query plan with full compile-time details of the SQL statement executed. Note that the TextData column does not contain the Showplan for this event.')
,('98 '	,'Showplan Statistics Profile','Displays the query plan with full run-time details of the SQL statement executed. Note that the TextData column does not contain the Showplan for this event.')
,('99 '	,'Reserved','')
,('100' 	,'RPC Output Parameter ','Produces output values of the parameters for every RPC.')
,('101' 	,'Reserved','')
,('102' 	,'Audit Database Scope GDR','Occurs every time a GRANT, DENY, REVOKE for a statement permission is issued by any user in SQL Server for database-only actions such as granting permissions on a database.')
,('103' 	,'Audit Object GDR Event','Occurs every time a GRANT, DENY, REVOKE for an object permission is issued by any user in SQL Server.')
,('104' 	,'Audit AddLogin Event ','Occurs when a SQL Server login is added or removed; for sp_addlogin and sp_droplogin.')
,('105' 	,'Audit Login GDR Event ','Occurs when a Windows login right is added or removed; for sp_grantlogin, sp_revokelogin, and sp_denylogin.')
,('106' 	,'Audit Login Change Property Event ','Occurs when a property of a login, except passwords, is modified; for sp_defaultdb and sp_defaultlanguage.')
,('107' 	,'Audit Login Change Password Event ','Occurs when a SQL Server login password is changed. Passwords are not recorded.')
,('108' 	,'Audit Add Login to Server Role Event','Occurs when a login is added or removed from a fixed server role; for sp_addsrvrolemember, and sp_dropsrvrolemember.')
,('109' 	,'Audit Add DB User Event ','Occurs when a login is added or removed as a database user (Windows or SQL Server) to a database; for sp_grantdbaccess, sp_revokedbaccess, sp_adduser, and sp_dropuser.')
,('110' 	,'Audit Add Member to DB Role Event ','Occurs when a login is added or removed as a database user (fixed or user-defined) to a database; for sp_addrolemember, sp_droprolemember, and sp_changegroup.')
,('111' 	,'Audit Add Role Event 	','Occurs when a login is added or removed as a database user to a database; for sp_addrole and sp_droprole.')
,('112' 	,'Audit App Role Change Password Event','Occurs when a password of an application role is changed.')
,('113' 	,'Audit Statement Permission Event','Occurs when a statement permission (such as CREATE TABLE) is used.')
,('114' 	,'Audit Schema Object Access Event','Occurs when an object permission (such as SELECT) is used, both successfully or unsuccessfully.')
,('115' 	,'Audit Backup/Restore Event','Occurs when a BACKUP or RESTORE command is issued.')
,('116' 	,'Audit DBCC Event','Occurs when DBCC commands are issued.')
,('117' 	,'Audit Change Audit Event ','Occurs when audit trace modifications are made.')
,('118' 	,'Audit Object Derived Permission Event ','Occurs when a CREATE, ALTER, and DROP object commands are issued.')
,('119' 	,'OLEDB Call Event 	','Occurs when OLE DB provider calls are made for distributed queries and remote stored procedures.')
,('120' 	,'OLEDB QueryInterface Event','Occurs when OLE DB QueryInterface calls are made for distributed queries and remote stored procedures.')
,('121' 	,'OLEDB DataRead Event ','Occurs when a data request call is made to the OLE DB provider.')
,('122' 	,'Showplan XML 	','Occurs when an SQL statement executes. Include this event to identify Showplan operators. Each event is stored in a well-formed XML document. Note that the Binary column for this event contains the encoded Showplan. Use SQL Server Profiler to open the trace and view the Showplan.')
,('123' 	,'SQL:FullTextQuery ','Occurs when a full text query executes.')
,('124' 	,'Broker:Conversation','Reports the progress of a Service Broker conversation.')
,('125' 	,'Deprecation Announcement','Occurs when you use a feature that will be removed from a future version of SQL Server.')
,('126' 	,'Deprecation Final Support ','Occurs when you use a feature that will be removed from the next major release of SQL Server.')
,('127' 	,'Exchange Spill Event','Occurs when communication buffers in a parallel query plan have been temporarily written to the tempdb database.')
,('128' 	,'Audit Database Management Event ','Occurs when a database is created, altered, or dropped.')
,('129' 	,'Audit Database Object Management Event','Occurs when a CREATE, ALTER, or DROP statement executes on database objects, such as schemas.')
,('130' 	,'Audit Database Principal Management Event ','Occurs when principals, such as users, are created, altered, or dropped from a database.')
,('131' 	,'Audit Schema Object Management Event ','Occurs when server objects are created, altered, or dropped.')
,('132' 	,'Audit Server Principal Impersonation Event','Occurs when there is an impersonation within server scope, such as EXECUTE AS LOGIN.')
,('133' 	,'Audit Database Principal Impersonation Event','Occurs when an impersonation occurs within the database scope, such as EXECUTE AS USER or SETUSER.')
,('134' 	,'Audit Server Object Take Ownership Event','Occurs when the owner is changed for objects in server scope.')
,('135' 	,'Audit Database Object Take Ownership Event ','Occurs when a change of owner for objects within database scope occurs.')
,('136' 	,'Broker:Conversation Group','Occurs when Service Broker creates a new conversation group or drops an existing conversation group.')
,('137' 	,'Blocked Process Report','Occurs when a process has been blocked for more than a specified amount of time. Does not include system processes or processes that are waiting on non deadlock-detectable resources. Use sp_configure to configure the threshold and frequency at which reports are generated.')
,('138' 	,'Broker:Connection ','Reports the status of a transport connection managed by Service Broker.')
,('139' 	,'Broker:Forwarded Message Sent','Occurs when Service Broker forwards a message.')
,('140' 	,'Broker:Forwarded Message Dropped','Occurs when Service Broker drops a message that was intended to be forwarded.')
,('141' 	,'Broker:Message Classify','Occurs when Service Broker determines the routing for a message.')
,('142' 	,'Broker:Transmission ','Indicates that errors have occurred in the Service Broker transport layer. The error number and state values indicate the source of the error.')
,('143' 	,'Broker:Queue Disabled','Indicates a poison message was detected because there were five consecutive transaction rollbacks on a Service Broker queue. The event contains the database ID and queue ID of the queue that contains the poison message.')
,('144-145' 	,'Reserved','')
,('146' 	,'Showplan XML Statistics Profile','Occurs when an SQL statement executes. Identifies the Showplan operators and displays complete, compile-time data. Note that the Binary column for this event contains the encoded Showplan. Use SQL Server Profiler to open the trace and view the Showplan.')
,('148' 	,'Deadlock Graph ','Occurs when an attempt to acquire a lock is canceled because the attempt was part of a deadlock and was chosen as the deadlock victim. Provides an XML description of a deadlock.')
,('149' 	,'Broker:Remote Message Acknowledgement ','Occurs when Service Broker sends or receives a message acknowledgement.')
,('150' 	,'Trace File Close ','Occurs when a trace file closes during a trace file rollover.')
,('151' 	,'Reserved','')
,('152' 	,'Audit Change Database Owner ','Occurs when ALTER AUTHORIZATION is used to change the owner of a database and permissions are checked to do that.')
,('153' 	,'Audit Schema Object Take Ownership Event ','Occurs when ALTER AUTHORIZATION is used to assign an owner to an object and permissions are checked to do that.')
,('154' 	,'Reserved','	')
,('155' 	,'FT:Crawl Started','Occurs when a full-text crawl (population) starts. Use to check if a crawl request is picked up by worker tasks.')
,('156' 	,'FT:Crawl Stopped','Occurs when a full-text crawl (population) stops. Stops occur when a crawl completes successfully or when a fatal error occurs.')
,('157' 	,'FT:Crawl Aborted','Occurs when an exception is encountered during a full-text crawl. Usually causes the full-text crawl to stop.')
,('158' 	,'Audit Broker Conversation ','Reports audit messages related to Service Broker dialog security.')
,('159' 	,'Audit Broker Login ','Reports audit messages related to Service Broker transport security.')
,('160' 	,'Broker:Message Undeliverable','Occurs when Service Broker is unable to retain a received message that should have been delivered to a service.')
,('161' 	,'Broker:Corrupted Message','Occurs when Service Broker receives a corrupted message.')
,('162' 	,'User Error Message ','Displays error messages that users see in the case of an error or exception.')
,('163' 	,'Broker:Activation ','Occurs when a queue monitor starts an activation stored procedure, sends a QUEUE_ACTIVATION notification, or when an activation stored procedure started by a queue monitor exits.')
,('164' 	,'Object:Altered ','Occurs when a database object is altered.')
,('165' 	,'Performance statistics ','Occurs when a compiled query plan has been cached for the first time, recompiled, or removed from the plan cache.')
,('166' 	,'SQL:StmtRecompile','Occurs when a statement-level recompilation occurs.')
,('167' 	,'Database Mirroring State Change','Occurs when the state of a mirrored database changes.')
,('168' 	,'Showplan XML For Query Compile','Occurs when an SQL statement compiles. Displays the complete, compile-time data. Note that the Binary column for this event contains the encoded Showplan. Use SQL Server Profiler to open the trace and view the Showplan.')
,('169' 	,'Showplan All For Query Compile ','Occurs when an SQL statement compiles. Displays complete, compile-time data. Use to identify Showplan operators.')
,('170' 	,'Audit Server Scope GDR Event ','Indicates that a grant, deny, or revoke event for permissions in server scope occurred, such as creating a login.')
,('171' 	,'Audit Server Object GDR Event','Indicates that a grant, deny, or revoke event for a schema object, such as a table or function, occurred.')
,('172' 	,'Audit Database Object GDR Event','Indicates that a grant, deny, or revoke event for database objects, such as assemblies and schemas, occurred.')
,('173' 	,'Audit Server Operation Event ','Occurs when Security Audit operations such as altering settings, resources, external access, or authorization are used.')
,('175' 	,'Audit Server Alter Trace Event','Occurs when a statement checks for the ALTER TRACE permission.')
,('176' 	,'Audit Server Object Management Event','Occurs when server objects are created, altered, or dropped.')
,('177' 	,'Audit Server Principal Management Event','Occurs when server principals are created, altered, or dropped.')
,('178' 	,'Audit Database Operation Event','Occurs when database operations occur, such as checkpoint or subscribe query notification.')
,('180' 	,'Audit Database Object Access Event','Occurs when database objects, such as schemas, are accessed.')
,('181' 	,'TM: Begin Tran starting ','Occurs when a BEGIN TRANSACTION request starts.')
,('182' 	,'TM: Begin Tran completed 	','Occurs when a BEGIN TRANSACTION request completes.')
,('183' 	,'TM: Promote Tran starting ','Occurs when a PROMOTE TRANSACTION request starts.')
,('184' 	,'TM: Promote Tran completed ','Occurs when a PROMOTE TRANSACTION request completes.')
,('185' 	,'TM: Commit Tran starting ','Occurs when a COMMIT TRANSACTION request starts.')
,('186' 	,'TM: Commit Tran completed','Occurs when a COMMIT TRANSACTION request completes.')
,('187' 	,'TM: Rollback Tran starting ','Occurs when a ROLLBACK TRANSACTION request starts.')
,('188' 	,'TM: Rollback Tran completed','Occurs when a ROLLBACK TRANSACTION request completes.')
,('189' 	,'Lock:Timeout (timeout > 0)','Occurs when a request for a lock on a resource, such as a page, times out.')
,('190' 	,'Progress Report: Online Index Operation','Reports the progress of an online index build operation while the build process is running.')
,('191' 	,'TM: Save Tran starting','Occurs when a SAVE TRANSACTION request starts.')
,('192' 	,'TM: Save Tran completed','Occurs when a SAVE TRANSACTION request completes.')
,('193' 	,'Background Job Error','Occurs when a background job terminates abnormally.')
,('194' 	,'OLEDB Provider Information','Occurs when a distributed query runs and collects information corresponding to the provider connection.')
,('195' 	,'Mount Tape ','Occurs when a tape mount request is received.')
,('196' 	,'Assembly Load','Occurs when a request to load a CLR assembly occurs.')
,('197' 	,'Reserved','')
,('198' 	,'XQuery Static Type','Occurs when an XQuery expression is executed. This event class provides the static type of the XQuery expression.')
,('199' 	,'QN: subscription','Occurs when a query registration cannot be subscribed. The TextData column contains information about the event.')
,('200' 	,'QN: parameter table ','Information about active subscriptions is stored in internal parameter tables. This event class occurs when a parameter table is created or deleted. Typically, these tables are created or deleted when the database is restarted. The TextData column contains information about the event.')
,('201' 	,'QN: template','A query template represents a class of subscription queries. Typically, queries in the same class are identical except for their parameter values. This event class occurs when a new subscription request falls into an already existing class of (Match), a new class (Create), or a Drop class, which indicates cleanup of templates for query classes without active subscriptions. The TextData column contains information about the event.')
,('202' 	,'QN: dynamics ','Tracks internal activities of query notifications. The TextData column contains information about the event.')
,('212' 	,'Bitmap Warning','Indicates when bitmap filters have been disabled in a query.')
,('213' 	,'Database Suspect Data Page','Indicates when a page is added to the suspect_pages table in msdb.')
,('214' 	,'CPU threshold exceeded','Indicates when the Resource Governor detects a query has exceeded the CPU threshold value (REQUEST_MAX_CPU_TIME_SEC).')
,('215' 	,'PreConnect:Starting','Indicates when a LOGON trigger or Resource Governor classifier function starts execution.')
,('216' 	,'PreConnect:Completed','Indicates when a LOGON trigger or Resource Governor classifier function completes execution.')
,('217' 	,'Plan Guide Successful','Indicates that SQL Server successfully produced an execution plan for a query or batch that contained a plan guide.')
,('218' 	,'Plan Guide Unsuccessful','Indicates that SQL Server could not produce an execution plan for a query or batch that contained a plan guide. SQL Server attempted to generate an execution plan for this query or batch without applying the plan guide. An invalid plan guide may be the cause of this problem. You can validate the plan guide by using the sys.fn_validate_plan_guide system function.')
,('235' 	,'Audit Fulltext','') 	


-- APENAS QUANDO TEM A VARIAVEL ID <> NULL	
	 IF (@id IS NOT NULL AND (@fl_language = 'en'))
		BEGIN
			SELECT * FROM tempdb..#TracesEvent2
			where event_number = @id
			order by event_name  
			RETURN;
		END
		
	END
	IF (@fl_language = 'pt')
	BEGIN
		SELECT * FROM tempdb..#TracesEvent
		order by nome_do_evento
	END
		ELSE IF (@fl_language = 'en')
		BEGIN
			SELECT * FROM tempdb..#TracesEvent2
			order by event_name    
		END





	
END






