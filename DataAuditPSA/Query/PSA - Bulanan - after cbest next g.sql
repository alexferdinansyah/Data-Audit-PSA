-- Corporate Action --

CREATE TABLE CORPACT_20180102_20181130 AS 
(select A.*, B.ID_CAE_CAPCO, B.LST_UPD_TS LASTUPDATE, B.ACCT_ID_ACCT_CAPCO, B.ACCT_ID_ACCT_CAPCO_SRC
, B.AMT_GROSS, B.AMT_TAX, B.AMT_NET  
from reportintra.corporate_actions a, reportintra.CORPORATE_ACTION_ENTITLEMENTS B--CORPORATE_ACTION_ENTITLEMENTS@kseiore1.world B
where dat_pay between '2 jan 2018' and '30 nov 2018'
--and a.typ_ca = '3'
AND A.ID_CA_CAPCO = B.ca_id_ca_capco)

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
FROM CORPACT_20180102_20181130 A, reportintra.ACCOUNT_snap acs, 
accounts@kseiore1.world ac, securities_detail_bckp b, basic_securities@kseiore1.world C
WHERE A.INS_ID_INS_CAPCO = C.ID_INS_CAPCO
and A.ACCT_ID_ACCT_CAPCO_SRC = ac.ID_ACCT_CAPCO
and c.code_base_sec = b.code_base_sec
and ac.id_acct = acs.id_acct
and acs.snap_dat = b.snap_dat
and acs.snap_dat = '30 nov 2018'
and acs.memcode = 'KZ001'
ORDER BY b.CODE_BASE_SEC


-- Web AKSes --

SELECT distinct AC.id_acct "REKENING EFEK",
       FS.INV_ID "SID",
       SDI.FULL_NAME,
       TO_CHAR (BIRTH_DATE, 'DD-MON-YYYY') "BIRTH DATE",
       SDI.KTP_NUM "NOMOR KTP",
       SDI.NPWP_NUM "NOMOR NPWP",
      SDI.PASSPORT_NUM "NOMOR PASSWORD",
       SDI.email,
      SDI.MOBILE_PHN "MOBILE PHONE",
       cds.code_long_dsc LOC_ASING,
       SDI.NATIONALITY,
       ADDR1,
       ADDR2,
       POSTAL_CODE,
       SDI.HOME_PHN "HOME PHONE",
       SDI.OTHER_ADDR1,
       SDI.OTHER_ADDR2,
       SDI.OTHER_POSTAL_CODE,
       SDI.OTHER_HOME_PHN "OTHER HOME PHONE",
       SDI.CITY,
       SDI.PROVINCE,
       SDI.COUNTRY,
       SDI.OTHER_CITY,
       SDI.OTHER_PROVINCE,
       SDI.OTHER_COUNTRY,
       CASE
          WHEN LENGTH (SDI.OTHER_ADDR1) = 0 OR SDI.OTHER_ADDR1 IS NULL
          THEN
             'ID Address'
          WHEN LENGTH (SDI.OTHER_ADDR1) <> 0
          THEN
             'Other Address'
       END
          CORR_ADDR,
       TO_CHAR (TU.DAT_CREATE, 'DD-MON-YYYY') AS "CREATE DATE",
       DECODE ('KZ001', tu.mem_id, 'Printed', 'Not Printed') creation_status,
       DECODE (user_sta,  'F', 'Not Login',  'A', 'Login') "USER STATUS",
       cd.CODE_LONG_DSC account_status
  FROM reportintra.fundsep_get_sid_snap fs,
       reportintra.account_snap ac,
       reportintra.sdi_invs_static sdi,
       tr_users@kseistpi.world tu,
       tr_codes@kseistpi.world cds,
       codes@kseistpi.world cd
WHERE  fs.snap_dat = '30 Nov 2018'
        AND AC.SNAP_DAT = '30 Nov 2018'
--        AND SDI.SNAP_DAT = '04 JUL 2018'   
        AND fs.id_acct = ac.id_acct --(+)
       AND cd.col_nm(+) = 'CODE_ACCT_STA'
       AND ac.code_acct_sta = cd.code_val(+)
       AND TU.DAT_CREATE >= TRUNC (TO_DATE ('20090101', 'yyyymmdd')) --tanggal awal tidak diubah
       AND TU.DAT_CREATE <= TRUNC (TO_DATE ('20181130', 'yyyymmdd')) ---masukkan tanggal yang diminta
--       AND a.inv_id = 'KZ001292700191'
       AND SUBSTR (AC.id_acct, 1, 5) = 'KZ001'
       AND AC.ID_ACCT = SDI.ID_ACCT
       and substr(ac.id_acct,10,3) = '001'
       AND tu.inv_id = FS.inv_id
       AND tu.user_sta IN ('A', 'F')
       AND tu.GROUP_ID = '02'
       AND cds.col_nm = 'LA'
       AND cds.CODE_VAL = aC.loc_asing
ORDER BY 1 --11,859 --11,832

---UNTUK CARI CROSSLINK / NOT CROSSLINK 
create table WEBAKSES_KZ001_20181130 as
  select distinct fs.id_acct, A.INVs_sID
  FROM sdi_invs_static a,
       reportintra.account_snap ac,
       reportintra.fundsep_get_sid_snap fs,
       tr_users@kseistpi.world tu,
       tr_codes@kseistpi.world cds,
       codes@kseistpi.world cd
WHERE     a.invs_sid = fs.inv_id
       AND a.id_acct = ac.id_acct(+)
       AND cd.col_nm(+) = 'CODE_ACCT_STA'
       AND ac.code_acct_sta = cd.code_val(+)
       AND TU.DAT_CREATE >= TRUNC (TO_DATE ('20090101', 'yyyymmdd')) --tanggal awal tidak diubah
       AND TU.DAT_CREATE <= TRUNC (TO_DATE ('20181130', 'yyyymmdd')) ---masukkan tanggal yang diminta
--       AND a.inv_id = 'KZ001292700191'
       AND A.ID_ACCT = fs.ID_ACCT
       and ac.snap_dat = '30 Nov 2018'
       and fs.snap_dat  = '30 Nov 2018'
       AND SUBSTR (fs.id_acct, 1, 5) = 'KZ001'
       AND tu.inv_id = a.invs_sid
       AND tu.user_sta IN ('A', 'F')
       AND tu.GROUP_ID = '02'
       AND cds.col_nm = 'LA'
       AND cds.CODE_VAL = a.loc_asing --14,324
       
       
 --CROSSLINK / NOT CROSSLINK 
select  distinct d.system_account, 
        (case when length(d.system_account) = 10 then map.id_acct else d.system_account end) sre,
        d.code_sta, 
        d.initial_flag
from    (select distinct system_account from REPORTINTRA.MASTER_DATA_INV_SNAP
        where system_type = 1
        and code_sta = 0
        and substr(system_account,1,5) = 'KZ001'
        and snap_dat = '30 Nov 2018') m,  --untuk melihat seluruh data di PE
        reportintra.vw_data_inv_address  d, --untuk mengambil creator/crosslinknya
        (select a.*, INVESTORCODE
        from WEBAKSES_KZ001_20181130 a, 
        (SELECT INV.CODE INVESTORCODE, AC.ACCOUNTIDENTIFIERVALUE ACCOUNTNUMBER
        FROM ACCOUNTCOMPOSITE@toba AC
        LEFT JOIN INVESTOR@toba INV ON AC.IDENT_HOLDER = INV.IDENT_STAKEHOLDER
        WHERE AC.IDENT_MASTER IS NULL
        AND AC.IDENT_ACTIVATIONTYPE != 5) b
        where b.ACCOUNTNUMBER = a.id_acct) map --untuk melihat mapping investorcode dengan system_account
where   m.system_account = d.system_account
        and d.code_sta = '0'
        and d.system_account = INVESTORCODE (+)
order by 1 

--- FLAG 1 = CREATOR
--- FLAG selain 1 = CROSSLINK 


-- Transaksi Bursa --
select distinct trade_no, transactionref, tradedate, sell_code, seller_inv_Id SELLER_SID, buy_code, 
buyer_inv_id BUYER_SID, sec_code, quantity, price, quantity*price MARKET_VALUE 
from reportintra.trade_instructions
where tradedate = '30 NOV 2018'
and (sell_code = 'KZ' or buy_code = 'KZ')