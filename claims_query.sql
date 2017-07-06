DECLARE @period_start DATE ='01-Jan-2016', @period_end DATE = '30-Nov-2016'

SELECT --top 1000
  --,convert(date, cl.ch_create_date, 102) as claim_create_dt
  tc.tc_sk
 ,ch.ch_sk
 ,convert(date, ch.ch_check_date, 102) as claim_paid_dt
 ,convert(date, ch.ch_create_date, 102) as claim_create_dt
 ,(select concat(e_fname, ' ', e_lname) from [MC1_Logi_OpsSrcDb2_P].dbo.employees where e_sk = ch.ch_create_e_sk) as claim_create_by
 ,ch.ch_claim_form_type
 ,ch.ch_Claim_Type
 ,ch.ch_capitated_ind
 ,ch.ch_logical_delete_ind
 ,ch.ch_fdos_date
 ,ch.ch_ldos_date
 ,ch.ch_charge_amt
 ,ch.ch_benefit_amt
 ,ch.ch_prv_name
 ,ch.ch_prv_npi
 

FROM [MC1_Logi_OpsSrcDb2_P].[dbo].[tpl_cases] tc
    ,[MC1_Logi_OpsSrcDb2_P].[dbo].[claimheaders] ch
where (tc_closed_desc_cd_sk not in (1210011,3305,3350,3353,3351,3352) or tc_closed_desc_cd_sk is null)
  and tc.tc_sk = ch.tc_sk
  


--where (select min(convert(date, act_create_date,102)) from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (2,3)) between @period_start and @period_end
--   or ((select min(convert(date, act_create_date,102)) from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (2,3)) is null and 
--       (select min(convert(date, act_create_date,102)) from [MC1_Logi_OpsSrcDb2_P].[dbo].[activities] where tc_sk = tc.tc_sk and actc_sk in (5, 302003)) between @period_start and @period_end)
