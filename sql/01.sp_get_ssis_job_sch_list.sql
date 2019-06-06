IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[comm].[sp_get_ssis_job_sch_list]') AND type in (N'P'))
 DROP PROC comm.sp_get_ssis_job_sch_list
GO
	
-- =============================================
-- Author:		jones
-- Create date: 2015/11/4
-- Description:	取得ssis作業的排程設定清單
-- 新增 conn_string欄位(取得sbpclient路徑) by jones 2018/8/28
-- 加入判別作業不能在執行中 by jones 2019/6/5
-- exp:         exec [comm].[sp_get_ssis_job_sch_list] 
-- =============================================
CREATE PROCEDURE [comm].[sp_get_ssis_job_sch_list] 
AS
BEGIN
select  js.ssis_job_no --作業編號
,tb.sch_no --排程編號
, tb.sch_name --排程名稱
, tb.freq_type --頻率類型
, tb.freq_interval --執行作業數
, tb.freq_subday_type --作業間隔單位
, tb.freq_subday_interval --作業間隔
, tb.freq_relative_interval --執行作業相對數
, tb.freq_recurrence_factor --執行間隔周(月)數
, tb.active_start_date --開始作業日期
, tb.active_end_date --停止作業日期
, tb.active_start_time --開始作業時間
, tb.active_end_time --停止作業時間
, js.next_run_date --下次執行日期
, isnull(case when tb.freq_subday_type='1' then replace(tb.active_start_time,':','') else  js.next_run_time end,'000000') next_run_time --下次執行時間
, cs.conn_string
 from comm.tb_ssis_sch tb --ssis排程檔
 inner join comm.tb_ssis_job_sch js --ssis作業排程檔
 on tb.sch_no=js.sch_no
 inner join comm.tb_conn_set cs
 on js.remote_conn_id=cs.remote_conn_id
 inner join comm.tb_ssis_job job
on js.ssis_job_no=job.ssis_job_no
 where tb.is_active=1 and job.is_active=1
 and (job.last_exec_status_key<>'012|R' or  job.last_exec_status_key is null) 
 order by js.next_run_date,js.next_run_time,tb.active_start_date,tb.active_start_time
END



GO
IF  EXISTS (SELECT * FROM ::fn_listextendedproperty(N'ms_description',N'SCHEMA',N'comm',N'PROCEDURE',N'sp_get_ssis_job_sch_list',null,default))
 EXEC sys.sp_updateextendedproperty @name=N'ms_description', @value=N'	取得ssis作業的排程設定清單' , @level0type=N'SCHEMA',@level0name=N'comm', @level1type=N'PROCEDURE',@level1name=N'sp_get_ssis_job_sch_list'
ELSE 
 EXEC sys.sp_addextendedproperty @name=N'ms_description', @value=N'	取得ssis作業的排程設定清單' , @level0type=N'SCHEMA',@level0name=N'comm', @level1type=N'PROCEDURE',@level1name=N'sp_get_ssis_job_sch_list'
IF  EXISTS (SELECT * FROM ::fn_listextendedproperty(N'category',N'SCHEMA',N'comm',N'PROCEDURE',N'sp_get_ssis_job_sch_list',null,default))
 EXEC sys.sp_updateextendedproperty @name=N'category', @value=N'未分類' , @level0type=N'SCHEMA',@level0name=N'comm', @level1type=N'PROCEDURE',@level1name=N'sp_get_ssis_job_sch_list'
ELSE 
 EXEC sys.sp_addextendedproperty @name=N'category', @value=N'未分類' , @level0type=N'SCHEMA',@level0name=N'comm', @level1type=N'PROCEDURE',@level1name=N'sp_get_ssis_job_sch_list'
