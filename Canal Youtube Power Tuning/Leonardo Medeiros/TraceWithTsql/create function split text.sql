USE [Traces]
GO

-- link da function https://www.dirceuresende.com/blog/como-quebrar-uma-string-tabela-substrings-utilizando-delimitador-sql-server/

-- credito by: Dirceu Resende

CREATE FUNCTION [dbo].[fncSplitTexto] (
    @Ds_Texto VARCHAR(MAX),
    @Ds_Delimitador VARCHAR(100)
)
RETURNS @Tabela_Palavras TABLE
(
    Id INT,
    Palavra VARCHAR(MAX)
)
AS
BEGIN
 
    DECLARE
        @Ds_String VARCHAR(MAX),
        @Ds_Palavra VARCHAR(MAX) = '',
        @Qt_Palavras INT = 1
 
 
    IF (LEN(@Ds_Texto) > 0)
       SET @Ds_Texto = @Ds_Texto + @Ds_Delimitador   
 
    
    WHILE (LEN(@Ds_Texto) > 0)
    BEGIN  
    
        
        SET @Ds_String = LTRIM(SUBSTRING(@Ds_Texto, 1, CHARINDEX(@Ds_Delimitador, @Ds_Texto) - 1))  
 
 
        IF (@Ds_Palavra = ' ')
            SET @Ds_Palavra = '' 
        
        
        IF ((@Qt_Palavras = 1 AND LEN(@Ds_Palavra) > 0) OR @Qt_Palavras > 1)
        BEGIN
            
            INSERT INTO @Tabela_Palavras ( Id, Palavra )
            VALUES ( @Qt_Palavras, @Ds_Palavra ) 
                
            SET @Qt_Palavras = @Qt_Palavras + 1
            
        END
        
        
        SET @Ds_Palavra = @Ds_String
        SET @Ds_Texto = SUBSTRING(@Ds_Texto, CHARINDEX(@Ds_Delimitador, @Ds_Texto) + 1, LEN(@Ds_Texto))
          
    END  
 
 
    -- Insere o resto do texto
    INSERT INTO @Tabela_Palavras ( Id, Palavra )
    VALUES ( @Qt_Palavras, @Ds_Palavra ) 
 
 
    RETURN
 
 
END
GO


