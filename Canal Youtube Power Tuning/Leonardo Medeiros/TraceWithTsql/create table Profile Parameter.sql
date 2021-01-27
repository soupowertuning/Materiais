USE [Traces]
GO

/*
Após criar a tabela, No momento do INSERT o valor da coluna FileName, para o caminho que deseja que o seu Trace seja salvo

D:\Bancos\estudos e testes\ProfileTrace2021 alterar para o caminho e nome do arquivo desejado.
*/


IF OBJECT_ID('dbo.Profiler_Parameter') IS NOT NULL
	DROP TABLE dbo.Profiler_Parameter
	go

CREATE TABLE [dbo].[Profiler_Parameter](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nm_Trace] [varchar](500) NULL,
	[MaxFileSize] [bigint] NULL,
	[StopTime] [datetime] NULL,
	[FileName] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Profiler_Parameter] ADD  DEFAULT (NULL) FOR [StopTime]
GO