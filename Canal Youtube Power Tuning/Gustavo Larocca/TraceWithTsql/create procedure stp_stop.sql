USE [Traces]
GO

IF (OBJECT_ID('dbo.Stp_stop') IS  NULL) EXEC('CREATE PROCEDURE dbo.Stp_stop AS SELECT 1')
GO


ALTER PROCEDURE [dbo].[Stp_stop] (@ID_trace INT )
AS 
BEGIN
--Stop the trace
EXEC sp_trace_setstatus @ID_trace, 0 ;
--Close the trace */
EXEC sp_trace_setstatus @ID_trace, 2 ;


END
GO