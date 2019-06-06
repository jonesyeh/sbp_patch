IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[comm].[sp_get_ssis_job_sch_list]') AND type in (N'P'))
 DROP PROC comm.sp_get_ssis_job_sch_list
GO
	
-- =============================================
-- Author:		jones
-- Create date: 2015/11/4
-- Description:	���ossis�@�~���Ƶ{�]�w�M��
-- �s�W conn_string���(���osbpclient���|) by jones 2018/8/28
-- �[�J�P�O�@�~����b���椤 by jones 2019/6/5
-- exp:         exec [comm].[sp_get_ssis_job_sch_list] 
-- =============================================
CREATE PROCEDURE [comm].[sp_get_ssis_job_sch_list] 
AS
BEGIN
select  js.ssis_job_no --�@�~�s��
,tb.sch_no --�Ƶ{�s��
, tb.sch_name --�Ƶ{�W��
, tb.freq_type --�W�v����
, tb.freq_interval --����@�~��
, tb.freq_subday_type --�@�~���j���
, tb.freq_subday_interval --�@�~���j
, tb.freq_relative_interval --����@�~�۹��
, tb.freq_recurrence_factor --���涡�j�P(��)��
, tb.active_start_date --�}�l�@�~���
, tb.active_end_date --����@�~���
, tb.active_start_time --�}�l�@�~�ɶ�
, tb.active_end_time --����@�~�ɶ�
, js.next_run_date --�U��������
, isnull(case when tb.freq_subday_type='1' then replace(tb.active_start_time,':','') else  js.next_run_time end,'000000') next_run_time --�U������ɶ�
, cs.conn_string
 from comm.tb_ssis_sch tb --ssis�Ƶ{��
 inner join comm.tb_ssis_job_sch js --ssis�@�~�Ƶ{��
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
 EXEC sys.sp_updateextendedproperty @name=N'ms_description', @value=N'	���ossis�@�~���Ƶ{�]�w�M��' , @level0type=N'SCHEMA',@level0name=N'comm', @level1type=N'PROCEDURE',@level1name=N'sp_get_ssis_job_sch_list'
ELSE 
 EXEC sys.sp_addextendedproperty @name=N'ms_description', @value=N'	���ossis�@�~���Ƶ{�]�w�M��' , @level0type=N'SCHEMA',@level0name=N'comm', @level1type=N'PROCEDURE',@level1name=N'sp_get_ssis_job_sch_list'
IF  EXISTS (SELECT * FROM ::fn_listextendedproperty(N'category',N'SCHEMA',N'comm',N'PROCEDURE',N'sp_get_ssis_job_sch_list',null,default))
 EXEC sys.sp_updateextendedproperty @name=N'category', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'comm', @level1type=N'PROCEDURE',@level1name=N'sp_get_ssis_job_sch_list'
ELSE 
 EXEC sys.sp_addextendedproperty @name=N'category', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'comm', @level1type=N'PROCEDURE',@level1name=N'sp_get_ssis_job_sch_list'
