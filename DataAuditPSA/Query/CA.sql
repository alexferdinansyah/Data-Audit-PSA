SELECT b.CODE_BASE_SEC "KODE_EFEK", 
    b.SEC_DSC "NAMA_EFEK", 
    A.TYP_CA, 
    A.CA_DSC, 
    A.DAT_REC, 
    A.DAT_PAY, 
    b.SEC_REGISTRA_ID, 
    acs.ID_ACCT "REKENING_EFEK", 
    acs.DSC_ACCT "NAMA_NASABAH", 
    acs.memcode "KODE MEMBER", 
    A.AMT_GROSS, 
    A.AMT_TAX, 
    A.AMT_NET 
FROM 
(select A.*, B.ID_CAE_CAPCO, B.LST_UPD_TS LASTUPDATE, B.ACCT_ID_ACCT_CAPCO, B.ACCT_ID_ACCT_CAPCO_SRC
, B.AMT_GROSS, B.AMT_TAX, B.AMT_NET  
from reportintra.corporate_actions@dw1_prod a, reportintra.CORPORATE_ACTION_ENTITLEMENTS@dw1_prod B--CORPORATE_ACTION_ENTITLEMENTS@kseiore1.world B
where dat_pay = '04-feb-19'
--and a.typ_ca = '3'
AND A.ID_CA_CAPCO = B.ca_id_ca_capco) A, reportintra.ACCOUNT_snap@dw1_prod acs, 
securities_detail_bckp@dw1_prod b
WHERE 
--A.INS_ID_INS_CAPCO = C.ID_INS_CAPCO
--and A.ACCT_ID_ACCT_CAPCO_SRC = ac.ID_ACCT_CAPCO
--and c.code_base_sec = b.code_base_sec
--and ac.id_acct = acs.id_acct
--and 
acs.snap_dat = b.snap_dat
and acs.snap_dat = '04 feb 2019'
and acs.memcode = 'KZ001'