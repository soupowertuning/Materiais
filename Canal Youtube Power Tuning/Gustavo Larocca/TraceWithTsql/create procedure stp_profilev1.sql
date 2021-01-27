USE [Traces]
GO


-----------------------------------------------------------------
-- Procedure Stp_Profile_V1, for create trace on profiler with t-sql
--
-- version 0.0.1 - created by: Leonardo Medeiros
--
-- last update = 20/01/2021
-----------------------------------------------------------------

IF (OBJECT_ID('dbo.Stp_Profile_V1') IS  NULL) EXEC('CREATE PROCEDURE dbo.Stp_Profile_V1 AS SELECT 1')
GO

    
    
ALTER PROCEDURE [dbo].[Stp_Profile_V1] (@ID_Eventos VARCHAR(150),@ID_Colunas VARCHAR(150), @ID_Col_filter varchar(150), @logical_operator varchar(1),@comparison_operator varchar(10),@value varchar(150))      
AS      
BEGIN      
      
      
DECLARE @em INT      
DECLARE @maxFileSize BIGINT      
DECLARE @filename NVARCHAR(200)      
DECLARE @on BIT      
      
      
SELECT @maxFileSize = MaxFileSize,      
    @filename = FileName      
FROM Profiler_Parameter      
      
SET @on = 1      
      
     
DECLARE @SQL VARCHAR(MAX)      
DECLARE @eventos INT      
DECLARE @colunas INT      
DECLARE @CMD VARCHAR(MAX)      
      
 --  cria o trace      
      
DECLARE @TraceID INT      
      
EXEC @em = sp_trace_create @TraceID OUTPUT,      
0,@filename, @maxFileSize,NULL      
      
     
IF (@em != 0) GOTO error      
     
      
-- setando os eventos e dados de coluna a serem coletados      
      
if(OBJECT_ID('tempdb..#resultado')IS NOT NULL)      
DROP TABLE tempdb..#resultado      
      
select   palavra  INTO #resultado from dbo.fncSplitTexto(@ID_Eventos, ',')      
      
DECLARE Cursor_VarreTBL CURSOR FOR      
      
 SELECT palavra FROM #resultado      
      
OPEN Cursor_VarreTBL        
 FETCH NEXT FROM Cursor_VarreTBL INTO @eventos        
 WHILE @@FETCH_STATUS = 0        
    BEGIN       
SELECT @SQL   =  'INSERT INTO  Profile_eventos (comando) values ('' EXEC sp_trace_setevent '+CONVERT(VARCHAR(10),@TraceID)+','+ convert(varchar(10),@eventos) +',@c,1'')'      
       
exec (@SQL )      
       
 --select @SQL         
   set @SQL = ''      
      
 FETCH NEXT FROM Cursor_VarreTBL INTO @eventos      
 END      
CLOSE Cursor_VarreTBL      
DEALLOCATE Cursor_VarreTBL      
     
      
if(OBJECT_ID('tempdb..#resultadoColunas')IS NOT NULL)      
DROP TABLE tempdb..#resultadoColunas      
      
select   palavra  INTO #resultadoColunas from dbo.fncSplitTexto(@ID_Colunas, ',')      
      
DECLARE Cursor_VarreCOL CURSOR FOR      
      
 SELECT palavra FROM #resultadoColunas      
      
OPEN Cursor_VarreCOL        
 FETCH NEXT FROM Cursor_VarreCOL INTO @colunas        
 WHILE @@FETCH_STATUS = 0        
    BEGIN       
   
 SELECT TraceID=@TraceID     
SELECT @CMD   =  'INSERT INTO  Profile_Colunas (comando) values (''EXEC sp_trace_setevent '+CONVERT(VARCHAR(10),@TraceID)+', @e'+convert(varchar(10),@colunas)+',1'')'       
       
exec (@CMD )      
       
 --select @@CMD         
   set @CMD = ''      
      
 FETCH NEXT FROM Cursor_VarreCOL INTO @colunas      
 END      
CLOSE Cursor_VarreCOL      
DEALLOCATE Cursor_VarreCOL      
   
     
 if(OBJECT_ID('tempdb..#TBL')IS NOT NULL)    
DROP TABLE tempdb..#TBL    
    
    
SELECT comando, ROW_NUMBER() over (order by comando) As myRowNumber INTO #TBL    
    FROM Profile_eventos      
    
    
    
    
    
 if(OBJECT_ID('tempdb..#TBL2')IS NOT NULL)    
DROP TABLE tempdb..#TBL2    
    
    
 SELECT comando, ROW_NUMBER() over (order by comando) As myRowNumber  into #TBL2    
 FROM Profile_Colunas    
    
  truncate table  Profile_eventos    
    
 truncate table  Profile_Colunas    
    
    
  if(OBJECT_ID('tempdb..#valida')IS NOT NULL)    
DROP TABLE tempdb..#valida    
    
SELECT  replace(SUBSTRING(comando,29,2),',' ,'') as [CMD]   
  
into #valida    
    
     
FROM #TBL2      
    
 
  if(OBJECT_ID('tempdb..#FIM')IS NOT NULL)    
DROP TABLE tempdb..#FIM    
    
    
select replace(A.comando,'@c',B.CMD) AS [CMD] , ROW_NUMBER() over (order by [CMD]) As NLinhas      
into #FIM   
from #valida B, #TBL A        
      
    
    
    
declare @Loop int, @Comando nvarchar(MAX), @NLinhas INT     
 set @Loop = 1      
 SELECT @NLinhas = count(NLinhas) FROM #FIM    
   SELECT TraceID=@TraceID     
    
 while (@Loop <= @NLinhas)      
 begin      
      
     
  select  @Comando = [CMD]    
  from #FIM       
  where NLinhas = @Loop        
  EXECUTE sp_executesql @Comando     
   
      
  set @Loop = @Loop + 1       
      
      
      
 END      
      
  
 DECLARE @SQL2 VARCHAR(MAX)  
 declare @filter int  
--cria os filtros  
if(OBJECT_ID('tempdb..#Filtros')IS NOT NULL)      
DROP TABLE tempdb..#Filtros      
      
select   palavra  INTO #Filtros from dbo.fncSplitTexto(@ID_Col_filter, ',')      
    
DECLARE Cursor_Filter CURSOR FOR      
    
 SELECT palavra FROM #Filtros   
  
  
 OPEN Cursor_Filter        
 FETCH NEXT FROM Cursor_Filter INTO @filter        
 WHILE @@FETCH_STATUS = 0        
    BEGIN           
  SELECT TraceID=@TraceID   
  SELECT @SQL2   =  'sp_trace_setfilter '+CONVERT(VARCHAR(10),@TraceID)+','+convert(varchar(10),@filter)+','+convert(varchar(10),@logical_operator)+','+convert(varchar(10),@comparison_operator)+','+convert(varchar(10),@value)+''      
exec (@SQL2 )      
       
 --select @SQL2         
   set @SQL2 = ''      
      
 FETCH NEXT FROM Cursor_Filter INTO @filter      
 END      
CLOSE Cursor_Filter      
DEALLOCATE Cursor_Filter  
      
      
      
      
-- Start the Trace      
DECLARE @CC NVARCHAR(MAX)      
      
SELECT @CC =  'EXEC sp_trace_setstatus '+CONVERT(NVARCHAR(2),@TraceID)+ ' , 1'      
EXECUTE sp_executesql @CC      
      
      
      
 SELECT TraceID=@TraceID     
PRINT @TraceID      
GOTO finish ;      
-- Error       
error:      
SELECT ErrorCode = @em ;      
-- Exit       
finish: ;      
      
END    
   
GO


