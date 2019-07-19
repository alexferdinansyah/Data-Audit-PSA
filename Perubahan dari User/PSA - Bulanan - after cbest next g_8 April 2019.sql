-- Corporate Action --

//** query ini digunakan after next-g live **//


select * from user_tables 
where table_name like 'CORPACT%'


CREATE TABLE CORPACT_20190201_20190401 AS 
(select A.*, B.ID_ACCT, b.id_acct_src, b.code_base_sec
, B.AMT_GROSS, B.AMT_TAX, B.AMT_NET  
from reportintra.corporate_actions a, reportintra.CORPORATE_ACTION_ENTITLEMENT B--CORPORATE_ACTION_ENTITLEMENTS@kseiore1.world B
where dat_pay between '1 feb 2019' and '1 apr 2019'
--and a.typ_ca = '3'
AND A.ID_CA_CAPCO = B.ca_id_ca_capco)

--1,258,572

commit;

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
FROM CORPACT_20190201_20190401 A, reportintra.ACCOUNT_snap acs, securities_detail_bckp b
WHERE A.code_base_sec = b.code_base_sec
and a.id_acct_src = acs.id_acct
and acs.snap_dat = b.snap_dat
and acs.snap_dat = '1 apr 2019'
and acs.memcode = 'BMAN1'
ORDER BY b.CODE_BASE_SEC


-- Web AKSes --

SELECT distinct AC.id_acct "REKENING EFEK", --1,382
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
WHERE  fs.snap_dat = '22 Jul 2014'
        AND AC.SNAP_DAT = '22 Jul 2014'
--        AND SDI.SNAP_DAT = '04 JUL 2018'   
        AND fs.id_acct = ac.id_acct --(+)
       AND cd.col_nm(+) = 'CODE_ACCT_STA'
       AND ac.code_acct_sta = cd.code_val(+)
       AND TU.DAT_CREATE >= TRUNC (TO_DATE ('20090101', 'yyyymmdd')) --tanggal awal tidak diubah
       AND TU.DAT_CREATE <= TRUNC (TO_DATE ('20140722', 'yyyymmdd')) ---masukkan tanggal yang diminta
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

drop table WEBAKSES_KZ001_20181130

---UNTUK CARI CROSSLINK / NOT CROSSLINK 
create table WEBAKSES_KZ001_20140722 as
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
       AND TU.DAT_CREATE <= TRUNC (TO_DATE ('20140722', 'yyyymmdd')) ---masukkan tanggal yang diminta
--       AND a.inv_id = 'KZ001292700191'
       AND A.ID_ACCT = fs.ID_ACCT
       and ac.snap_dat = '22 Jul 2014'
       and fs.snap_dat  = '22 Jul 2014'
       AND SUBSTR (fs.id_acct, 1, 5) = 'KZ001'
       AND tu.inv_id = a.invs_sid
       AND tu.user_sta IN ('A', 'F')
       AND tu.GROUP_ID = '02'
       AND cds.col_nm = 'LA'
       AND cds.CODE_VAL = a.loc_asing --14,324
       
--CROSSLINK / NOT CROSSLINK -- sebelum 9 Jul 2018
select system_account, code_sta, initial_flag from reportintra.vw_data_inv_address 
where system_account in (select distinct(id_acct) from WEBAKSES_KZ001_20140722)
and code_sta = '0'
ORDER BY 1
       
 --CROSSLINK / NOT CROSSLINK -- setelah 6 Jul 2018
select  distinct d.system_account, 
        (case when length(d.system_account) = 10 then map.id_acct else d.system_account end) sre,
        d.code_sta, 
        d.initial_flag
from    (select distinct system_account from REPORTINTRA.MASTER_DATA_INV_SNAP
        where system_type = 1
        and code_sta = 0
        and substr(system_account,1,5) = 'KZ001'
        and snap_dat = '22 Jul 2014') m,  --untuk melihat seluruh data di PE
        reportintra.vw_data_inv_address  d, --untuk mengambil creator/crosslinknya
        (select a.*, INVESTORCODE
        from WEBAKSES_KZ001_20140722 a, 
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
where tradedate = '15 mar 2019'
and (sell_code = 'KZ' or buy_code = 'KZ') --14,539