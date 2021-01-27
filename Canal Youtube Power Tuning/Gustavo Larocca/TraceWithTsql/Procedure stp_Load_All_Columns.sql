
USE Traces

go

IF (OBJECT_ID('dbo.stp_Load_all_Columns') IS  NULL) EXEC('CREATE PROCEDURE dbo.stp_Load_all_Columns AS SELECT 1')
GO
ALTER PROCEDURE stp_Load_all_Columns (@fl_language VARCHAR(2)= NULL)

AS
BEGIN
SET NOCOUNT ON


		
    SET @fl_language = (CASE
        WHEN NULLIF(LTRIM(RTRIM(@fl_language)), '') IS NULL THEN (SELECT CASE WHEN [value] IN (5, 7, 27) THEN 'pt' ELSE 'en' END FROM sys.configurations WHERE [name] = 'default language')
        ELSE @fl_language
		END)



IF @fl_language = 'pt'
BEGIN 
		IF OBJECT_ID('tempdb..#ColumnsEvent') IS NOT NULL
		DROP TABLE tempdb..#ColumnsEvent
		CREATE TABLE tempdb..#ColumnsEvent 
		(
		numero_da_coluna int,
		Nm_coluna varchar(80),
		Descricao varchar(max) )

		INSERT INTO tempdb..#ColumnsEvent  VALUES 
		

	(1 ,'TextData '	,'Valor de texto dependente da classe de evento que é capturada no rastreamento.'),
	(2 ,	'BinaryData ','Valor binário dependente da classe de evento capturada no rastreamento.')
	,(3 ,	'DatabaseID','ID do banco de dados especificado pela instrução USE Database ou o banco de dados padrão se nenhuma instrução de banco de dados use for emitida para uma determinada conexão. O valor para um banco de dados pode ser determinado usando a função DB_ID.')
	,(4 ,	'TransactionID','ID da transação atribuída pelo sistema.')
	,(5 ,	'LineNumber','O número da linha que contém o erro. No caso de eventos que envolvem instruções Transact-SQL , como SP:StmtStarting, LineNumber contém o número de linha da instrução no procedimento armazenado ou lote.')
	,(6 ,	'NTUserName ','Nome de usuário do Microsoft Windows.')
	,(7 ,	'NTDomainName '	,'O domínio do Windows ao qual o usuário pertence.')
	,(8 ,	'HostName','Nome do computador cliente que originou a solicitação.')
	,(9 ,	'ClientProcessID ','ID atribuída pelo computador cliente ao processo no qual o aplicativo cliente está sendo executado.')
	,(10, 	'ApplicationName','Nome do aplicativo cliente que criou a conexão com uma instância do SQL Server. Essa coluna é populada com os valores passados pelo aplicativo e não com o nome exibido do programa.')
	,(11, 	'LoginName '				,'Nome de logon do cliente no SQL Server.')
	,(12, 	'SPID '					,'ID de processo de servidor atribuída pelo SQL Server ao processo associado ao cliente.')
	,(13, 	'Duration '				,'Tempo decorrido (em milhões de segundos) utilizado pelo evento. Esta coluna de dados não é populada pelo evento Hash Warning.')
	,(14, 	'StartTime '				,'Horário de início do evento, quando disponível.')
	,(15, 	'EndTime '				,'Horário em que o evento foi encerrado. Esta coluna não é populada para classes de eventos iniciais, como SQL:BatchStarting ou SP:Starting. Ele também não é preenchido pelo evento de aviso de hash .')
	,(16, 	'Reads' 					,'Número de leituras lógicas do disco executadas pelo servidor em nome do evento. Esta coluna não é preenchida pelo evento Lock: solto .')
	,(17, 	'Writes '					,'Número de gravações no disco físico executadas pelo servidor em nome do evento.')
	,(18, 	'CPU '					,'Tempo da CPU (em milissegundos) usado pelo evento.')
	,(19, 	'Permissões '				,'Representa o bitmap de permissões; usada pela Security Auditing.')
	,(20, 	'Gravidade' 				,'Nível de severidade de uma exceção.')
	,(21, 	'EventSubClass' 			,'Tipo de subclasse de evento. Essa coluna de dados não é populada para todas as classes de evento.')
	,(22, 	'ObjectID' 				,'ID de objeto atribuída pelo sistema.')
	,(23, 	'Êxito' 					,'Êxito da tentativa de uso de permissões; usada para auditoria. 1 = êxito 0 = falha')
	,(24, 	'IndexID '				,'ID do índice no objeto afetado pelo evento. Para determinar a ID do índice de um objeto, use a coluna indid da tabela do sistema sysindexes .')
	,(25, 	'IntegerData' 			,'O valor inteiro dependente da classe de evento capturada no rastreamento.')
	,(26, 	'ServerName' 				,'Nome da instância do SQL Server , ServerName ou nomedoservidor \ NomedaInstância, sendo rastreado.')
	,(27, 	'EventClass '				,'Tipo de classe de evento que está sendo registrada.')
	,(28, 	'ObjectType' 				,'Tipo de objeto, como tabela, função ou procedimento armazenado.')
	,(29, 	'NestLevel '				,'O nível de aninhamento no qual esse procedimento armazenado está sendo executado. Confira @NESTLEVEL&#41;de (TRANSACT-SQL .')
	,(30, 	'State' 					,'Estado do servidor, no caso de um erro.')
	,(31, 	'Erro '					,'Número de erro.')
	,(32, 	'Modo' 					,'Modo de bloqueio do bloqueio adquirido. Esta coluna não é preenchida pelo evento Lock: solto.')
	,(33, 	'Handle' 					,'Identificador do objeto mencionado no evento.')
	,(34, 	'ObjectName','Nome do objeto acessado.')
	,(35, 	'DatabaseName' 			,'Nome do banco de dados especificado na instrução de banco de dados use.')
	,(36, 	'FileName' 				,'Nome lógico do nome de arquivo modificado.')
	,(37, 	'OwnerName '				,'Nome do proprietário do objeto referenciado.')
	,(38, 	'RoleName' 				,'Nome do banco de dados ou da função em todo o servidor direcionados por uma instrução.')
	,(39, 	'TargetUserName' 			,'Nome de usuário do destino de alguma ação.')
	,(40, 	'DBUserName' 				,'Nome de usuário do banco de dados do SQL Server do cliente.')
	,(41, 	'LoginSid' 				,'SID (identificador de segurança) do usuário que fez logon.')
	,(42, 	'TargetLoginName' 		,'Nome de logon do destino de alguma ação.')
	,(43, 	'TargetLoginSid' 			,'SID do logon que é o destino de alguma ação.')
	,(44, 	'ColumnPermissions '		,'Status de permissões em nível de coluna; usado pela Security Auditing.')
	,(45, 	'LinkedServerName' 		,'Nome do servidor vinculado.')
	,(46, 	'ProviderName' 			,'Nome do provedor OLE DB.')
	,(47, 	'MethodName' 				,'Nome do método OLE DB.')
	,(48, 	'RowCounts '				,'Número de linhas no lote.')
	,(49, 	'RequestID' 				,'ID da solicitação que contém a instrução.')
	,(50, 	'XactSequence' 			,'Token usado para descrever a transação atual.')
	,(51, 	'EventSequence' 			,'Número de sequência para esse evento.')
	,(52, 	'BigintData1' 			,'valor bigint , que depende da classe de evento capturada no rastreamento.')
	,(53, 	'BigintData2 '			,'valor bigint , que depende da classe de evento capturada no rastreamento.')
	,(54, 	'GUID' 					,'Valor GUID,	que é dependente da classe de evento capturada no rastreamento.')
	,(55, 	'IntegerData2' 			,'Valor inteiro, que é dependente da classe de evento capturada no rastreamento.')
	,(56, 	'ObjectID2' 				,'ID do objeto ou entidade relacionada, se disponível.')
	,(57, 	'Tipo '					,'Valor inteiro, que é dependente da classe de evento capturada no rastreamento.')
	,(58, 	'OwnerID '				,'Tipo o objeto que possui o bloqueio. Apenas para eventos de bloqueio.')
	,(59, 	'ParentName' 				,'Nome do esquema que contém o objeto.')
	,(60, 	'IsSystem' 				,'Indica se o evento ocorreu em um processo do sistema ou do usuário. 1 = sistema 0 = usuário.')
	,(61, 	'Deslocamento' 			,'O deslocamento inicial da instrução no lote ou procedimento armazenado.')
	,(62, 	'SourceDatabaseID' 		,'ID do banco de dados no qual a origem do objeto existe.')
	,(63, 	'SqlHandle','Hash de	64 bits com base no texto de uma consulta ad hoc ou na ID de objeto e banco de dados de um objeto SQL. Esse valor pode ser passado a sys.dm_exec_sql_text() para recuperar o texto SQL associado.')
	,(64, 	'SessionLoginName' ,'O nome de logon do usuário que originou a sessão. Por exemplo, se você se conectar ao SQL Server usando Login1 e executar uma instrução como Login2, SessionLoginName irá exibir Login1, enquanto que LoginName exibirá Login2. Esta coluna de dados exibe logons tanto do SQL Server , quanto do Windows.')
END
	ELSE IF (@fl_language = 'en')
 BEGIN 
		IF OBJECT_ID('tempdb..#ColumnsEvent2') IS NOT NULL
		DROP TABLE tempdb..#ColumnsEvent2
		CREATE TABLE tempdb..#ColumnsEvent2 
		(
		column_Number int,
		Nm_column varchar(80),
		Description_ varchar(max) )

		INSERT INTO tempdb..#ColumnsEvent2  VALUES 

		(1 	,'TextData' 					,'Text value dependent on the event class that is captured in the trace.'),
		(2 	,'BinaryData' 					,'Binary value dependent on the event class captured in the trace.')
		,(3 	,'DatabaseID' 				,'ID of the database specified by the USE database statement, or the default database if no USE database statement is issued for a given connection.The value for a database can be determined by using the DB_ID function.')
		,(4 	,'TransactionID' 			,'System-assigned ID of the transaction.')
		,(5 	,'LineNumber '				,'Contains the number of the line that contains the error. For events that involve Transact-SQL statements, like SP:StmtStarting, the LineNumber contains the line number of the statement in the stored procedure or batch.')
		,(6 	,'NTUserName '				,'Microsoft Windows user name.')
		,(7 	,'NTDomainName '			,'Windows domain to which the user belongs.')
		,(8 	,'HostName' 				,'Name of the client computer that originated the request.')
		,(9 	,'ClientProcessID '			,'ID assigned by the client computer to the process in which the client application is running.')
		,(10 	,'ApplicationName' 			,'Name of the client application that created the connection to an instance of SQL Server. This column is populated with the values passed by the application rather than the displayed name of the program.')
		,(11 	,'LoginName'				,'SQL Server login name of the client.')
		,(12 	,'SPID' 					,'Server Process ID assigned by SQL Server to the process associated with the client.')
		,(13 	,'Duration' 				,'Amount of elapsed time (in microseconds) taken by the event. This data column is not populated by the Hash Warning event.')
		,(14 	,'StartTime' 				,'Time at which the event started, when available.')
		,(15 	,'EndTime' 					,'Time at which the event ended. This column is not populated for starting event classes, such as SQL:BatchStarting or SP:Starting. It is also not populated by the Hash Warning event.')
		,(16 	,'Reads' 					,'Number of logical disk reads performed by the server on behalf of the event. This column is not populated by the Lock:Released event.')
		,(17 	,'Writes' 					,'Number of physical disk writes performed by the server on behalf of the event.')
		,(18 	,'CPU' 						,'Amount of CPU time (in milliseconds) used by the event.')
		,(19 	,'Permissions' 				,'Represents the bitmap of permissions; used by Security Auditing.')
		,(20 	,'Severity' 				,'Severity level of an exception.')
		,(21 	,'EventSubClass'			,'Type of event subclass. This data column is not populated for all event classes.')
		,(22 	,'ObjectID '				,'System-assigned ID of the object.')
		,(23 	,'Success '					,'Success of the permissions usage attempt; used for auditing. 1 = success0 = failure')
		,(24 	,'IndexID '					,'ID for the index on the object affected by the event. To determine the index ID for an object, use the indid column of the sysindexes system table.')
		,(25 	,'IntegerData '				,'Integer value dependent on the event class captured in the trace.')
		,(26 	,'ServerName' 				,'Name of the instance of SQL Server, either servername or servername\instancename, being traced.')
		,(27 	,'EventClass' 				,'Type of event class being recorded.')
		,(28 	,'ObjectType' 				,'Type of object, such as: table, function, or stored procedure.')
		,(29 	,'NestLevel '				,'The nesting level at which this stored procedure is executing. See @@NESTLEVEL (Transact-SQL).')
		,(30 	,'State' 					,'Server state, in case of an error.')
		,(31 	,'Error '					,'Error number.')
		,(32 	,'Mode' 					,'Lock mode of the lock acquired. This column is not populated by the Lock:Released event.')
		,(33 	,'Handle' 					,'Handle of the object referenced in the event.')
		,(34 	,'ObjectName '				,'Name of object accessed.')
		,(35 	,'DatabaseName' 			,'Name of the database specified in the USE database statement.')
		,(36 	,'FileName '				,'Logical name of the file name modified.')
		,(37 	,'OwnerName '				,'Owner name of the referenced object.')
		,(38 	,'RoleName '				,'Name of the database or server-wide role targeted by a statement.')
		,(39 	,'TargetUserName '			,'User name of the target of some action.')
		,(40 	,'DBUserName' 				,'SQL Server database user name of the client.')
		,(41 	,'LoginSid '				,'Security identifier (SID) of the logged-in user.')
		,(42 	,'TargetLoginName '			,'Login name of the target of some action.')
		,(43 	,'TargetLoginSid '			,'SID of the login that is the target of some action.')
		,(44 	,'ColumnPermissions' 		,'Column-level permissions status; used by Security Auditing.')
		,(45 	,'LinkedServerName' 		,'Name of the linked server.')
		,(46 	,'ProviderName' 			,'Name of the OLE DB provider.')
		,(47 	,'MethodName '				,'Name of the OLE DB method.')
		,(48 	,'RowCounts '				,'Number of rows in the batch.')
		,(49 	,'RequestID '				,'ID of the request containing the statement.')
		,(50 	,'XactSequence' 			,'A token to describe the current transaction.')
		,(51 	,'EventSequence' 			,'Sequence number for this event.')
		,(52 	,'BigintData1' 				,'bigint value, which is dependent on the event class captured in the trace.')
		,(53 	,'BigintData2 '				,'bigint value, which is dependent on the event class captured in the trace.')
		,(54 	,'GUID' 					,'GUID value, which is dependent on the event class captured in the trace.')
		,(55 	,'IntegerData2' 			,'Integer value, which is dependent on the event class captured in the trace.')
		,(56 	,'ObjectID2' 				,'ID of the related object or entity, if available.')
		,(57 	,'Type '					,'Integer value, which is dependent on the event class captured in the trace.')
		,(58 	,'OwnerID' 					,'Type of the object that owns the lock. For lock events only.')
		,(59 	,'ParentName '				,'Name of the schema the object is within.')
		,(60 	,'IsSystem' 				,'Indicates whether the event occurred on a system process or a user process. 1 = system 0 = user.')
		,(61 	,'Offset' 					,'Starting offset of the statement within the stored procedure or batch.')
		,(62 	,'SourceDatabaseID' 		,'ID of the database in which the source of the object exists.')
		,(63 	,'SqlHandle '				,'64-bit hash based on the text of an ad hoc query or the database and object ID of an SQL object. This value can be passed to sys.dm_exec_sql_text() to retrieve the associated SQL text.')
		,(64 	,'SessionLoginName' 		,'The login name of the user who originated the session. For example, if you connect to SQL Server using Login1 and execute a statement as Login2, SessionLoginName displays Login1, while LoginName displays Login2. This data column displays both SQL Server and Windows logins.')
	END


	IF (@fl_language = 'pt')
	BEGIN
		SELECT * FROM tempdb..#ColumnsEvent
		order by numero_da_coluna
	END
		ELSE IF (@fl_language = 'en')
		BEGIN
			SELECT * FROM tempdb..#ColumnsEvent2
			order by column_Number    
		END
END