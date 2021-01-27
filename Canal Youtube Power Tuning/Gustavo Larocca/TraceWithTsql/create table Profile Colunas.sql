USE [Traces]
GO


IF OBJECT_ID('dbo.Profile_colunas') IS NOT NULL
	DROP TABLE dbo.Profile_colunas
	go
CREATE TABLE [dbo].[Profile_colunas](
	[comando] [varchar](200) NULL
) ON [PRIMARY]
GO