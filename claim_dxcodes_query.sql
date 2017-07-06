DECLARE @period_start DATE ='01-Jan-2016', @period_end DATE = '30-Nov-2016'

SELECT top 1000
  --,convert(date, cl.ch_create_date, 102) as claim_create_dt
  tc.tc_sk
 ,ch.ch_sk
 ,chdx.cdx_sk 
 ,chdx.cdx_order_num
 ,chdx.dxc_sk
 ,dx.dx_code
 ,dx.dx_icd_version
 ,dx.dx_long_desc
 ,dx.dx_english_desc

FROM [MC1_Logi_OpsSrcDb2_P].[dbo].[tpl_cases] tc
    ,[MC1_Logi_OpsSrcDb2_P].[dbo].[claimheaders] ch
	,[MC1_Logi_OpsSrcDb2_P].[dbo].[claimheader_dx_codes] chdx
	,[MC1_Logi_OpsSrcDb2_P].[dbo].[dx_codes_client] dxc
	,[MC1_Logi_OpsSrcDb2_P].[dbo].[dx_codes] dx

where (tc_closed_desc_cd_sk not in (1210011,3305,3350,3353,3351,3352) or tc_closed_desc_cd_sk is null)
  and tc.tc_sk = ch.tc_sk
  and ch.ch_sk = chdx.ch_sk
  and chdx.dxc_sk = dxc.dxc_sk 
  and dxc.dx_sk = dx.dx_sk 