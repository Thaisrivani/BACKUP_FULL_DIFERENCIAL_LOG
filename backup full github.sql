--Identificar Recovery Model dos bancos
--1.FULL(banco de produção que recebe atualização constante) 2.SIMPLE (banco de teste, desenvolvimento)

SELECT [name] as Banco, Recovery_Model_Desc AS RecoveryModel
FROM Sys.Databases
WHERE DATABASE_ID >4
ORDER BY Banco

--Alterando base de Simple para FULL
ALTER DATABASE Loja SET RECOVERY FULL

--Backup FULL 
 BACKUP DATABASE Loja
 TO DISK = 'C\BACKUP\Loja.bak'
 WITH INIT, COMPRESSION, CHECKSUM, STATUS = 5, 
 NAME = 'C\BACKUP\Loja.bak'

--Backup Diferencial
BACKUP DATABASE Loja
TO DISK = 'C\BACKUP\Loja.bak'
WITH DIFFERENTIAL, INIT, COMPRESSION, CHECKSUM, STATS  = 5,
NAME = 'C\BACKUP\Loja.bak'

--Backup do Log
BACKUP LOG Loja
TO DISK = 'C\BACKUP\Loja_1.bak'
WITH INIT, COMPRESSION, CHECKSUM,
NAME = 'C\BACKUP\Loja_1.bak'

--Outro Backup do Log
BACKUP LOG Loja
TO DISK = 'C\BACKUP\Loja_2.bak'
WITH INIT, COMPRESSION, CHECKSUM,
NAME = 'C\BACKUP\Loja_2.bak'

--Conferir o histórico de Backup que foi executado
SELECT	database_name, name,backup_start_date, datediff(mi, backup_start_date, backup_finish_date) [tempo (min)],
		position, server_name, recovery_model, isnull(logical_device_name, ' ') logical_device_name, device_type, 
		type, cast(backup_size/1024/1024 as numeric(15,2)) [Tamanho (MB)]
FROM msdb.dbo.backupset B
	  INNER JOIN msdb.dbo.backupmediafamily BF ON B.media_set_id = BF.media_set_id
where backup_start_date >=  dateadd(hh, -24 ,getdate()  )
--  and type in ('D','I')
order by backup_start_date desc
