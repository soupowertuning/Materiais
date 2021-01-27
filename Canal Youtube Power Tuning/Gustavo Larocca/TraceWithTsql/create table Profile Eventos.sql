USE [Traces]
GO

IF OBJECT_ID('dbo.Profile_Eventos') IS NOT NULL
	DROP TABLE dbo.Profile_Eventos
	go

CREATE TABLE [dbo].[Profile_Eventos](
	[comando] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO