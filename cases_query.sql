DECLARE @period_start DATE ='01-Jan-2016', @period_end DATE = '30-Nov-2016'

SELECT --top 1000
  --,convert(date, cl.ch_create_date, 102) as claim_create_dt
  tc.tc_sk
  ,tc.a_sk
  ,a.a_segment_1 as funding_src
  ,tc.s_sk 
  ,concat(s.s_fname, ' ', s.s_lname) as subscriber_name
  ,s.s_zip as subscriber_zip
  ,convert(date, s.s_dob_date, 102) as subscriber_dob
  ,tc.tc_benefit_amt
  ,convert(date, tc.tc_create_date,102) as case_create_dt
  ,(select convert(date,max(act_create_date),102) from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk) last_act_date
  ,tc.tc_status_cd_sk as case_status_cd
  ,(select cd_desc from [MC1_Logi_OpsSrcDb2_P].[dbo].[codes] where cd_sk = tc.tc_status_cd_sk) as case_status_descr
 -- ,tc.tc_status_reason_cd_sk
 -- ,(select cd_desc from [DHP_TPL_LEGACY].[dbo].[codes] where cd_sk = tc.tc_status_reason_cd_sk) as status_rsn_descr
  ,tc.tc_closed_desc_cd_sk as case_clsd_desc_cd
  ,(select cd_desc from [MC1_Logi_OpsSrcDb2_P].[dbo].[codes] where cd_sk = tc.tc_closed_desc_cd_sk) as case_closed_descr
  ,(select min(convert(date, act_create_date,102)) from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (2,3,4)) as min_succ_dt
  ,(case when exists (select 'x' from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (2,3,4)) then NULL
		 else (select min(convert(date, act_create_date,102)) from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (5, 302003)) end) as min_cwoc_dt
  --,cl.ch_benefit_amt as claim_benefit_amt
  ,(case when tc_closed_desc_cd_sk not in (1210011,3305,3350,3353,3351,3352) then 1 
         when tc_closed_desc_cd_sk is null then 1
		 else 0 end) as case_selected_flag
  ,(case when exists (select 'x' from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (2,3,4)) then 1 else 0 end) as case_success_flag
  ,(case when not exists (select 'x' from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (2,3,4)) and
                  exists (select 'x' from [MC1_Logi_OpsSrcDb2_P].[dbo].[tpl_cases] where tc_sk = tc.tc_sk and tc_status_cd_sk = 2905 and tc_closed_desc_cd_sk not in (1210011,3305,3350,3353,3351,3352)) 
	     then 1 else 0 end) as case_fail_flag
FROM [MC1_Logi_OpsSrcDb2_P].[dbo].[tpl_cases] tc
    ,[MC1_Logi_OpsSrcDb2_P].[dbo].[accounts] a 
    ,[MC1_Logi_OpsSrcDb2_P].[dbo].[subscribers] s

where (tc_closed_desc_cd_sk not in (1210011,3305,3350,3353,3351,3352) or tc_closed_desc_cd_sk is null)
  and tc.a_sk = a.a_sk
  and tc.s_sk = s.s_sk


--where (select min(convert(date, act_create_date,102)) from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (2,3)) between @period_start and @period_end
--   or ((select min(convert(date, act_create_date,102)) from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (2,3)) is null and 
--       (select min(convert(date, act_create_date,102)) from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (5, 302003)) between @period_start and @period_end)
