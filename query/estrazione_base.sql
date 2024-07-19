select 
    data_riferimento,
    cod_tipo_tasso,
    cod_digit_cap_floor,
    TO_CHAR(sum(IMP_EROGATO), '999G999G999D00') as IMP_EROGATO,
    listagg(distinct cod_prodotto,'; ')
from s2a.mutui_all
where abi_banca = '08883'
    and data_riferimento in ('30-giu-2023','31-lug-2023','31-ago-2023','30-set-2023')
    AND COD_TIPO_TASSO IS not NULL
    AND COD_STATO_RAPPORTO <> 'E'
group by data_riferimento,cod_tipo_tasso,cod_digit_cap_floor
order by 1;

select trunc(data_operativita_rapporto,'fmmm'),DESCRIZIONE_TASSO_RIFTO_AMMORTAM, 
    case 
        when SPREAD_TASSO_AMMORTAM_VALORE <= 1 then 1
        when 1 < SPREAD_TASSO_AMMORTAM_VALORE and SPREAD_TASSO_AMMORTAM_VALORE <= 2 then 2
        when 2 < SPREAD_TASSO_AMMORTAM_VALORE and SPREAD_TASSO_AMMORTAM_VALORE <= 3 then 3
        when 3 < SPREAD_TASSO_AMMORTAM_VALORE and SPREAD_TASSO_AMMORTAM_VALORE <= 4 then 4
        when 4 < SPREAD_TASSO_AMMORTAM_VALORE and SPREAD_TASSO_AMMORTAM_VALORE <= 5 then 5
        when 5 < SPREAD_TASSO_AMMORTAM_VALORE then 6
    end as SPREAD_TASSO_AMMORTAM_VALORE
    , count(1), round(avg(IMP_EROGATO),0),round(sum(IMP_EROGATO),0), round(sum(IMP_LIQUIDATO),0), round(avg(IMP_LIQUIDATO),0)
from s2a.mutui_all m
join (
        select VALORE as COD_TASSO_RIFTO_AMMORTAM, 
            DESCRIZIONE as DESCRIZIONE_TASSO_RIFTO_AMMORTAM
        from S2A.domini_attributi_all
        where abi_banca = '08883'
            and data_riferimento = '30-giu-2024'
            and SOTTO_APPLICAZIONE = 'MUTUI'
            and ATTRIBUTO = 'COD_TASSO_RIFTO_AMMORTAM'
    ) a
    on m.COD_TASSO_RIFTO_AMMORTAM = a.COD_TASSO_RIFTO_AMMORTAM
where data_riferimento = '30-giu-2023'
group by trunc(data_operativita_rapporto,'fmmm'),DESCRIZIONE_TASSO_RIFTO_AMMORTAM, case 
        when SPREAD_TASSO_AMMORTAM_VALORE <= 1 then 1
        when 1 < SPREAD_TASSO_AMMORTAM_VALORE and SPREAD_TASSO_AMMORTAM_VALORE <= 2 then 2
        when 2 < SPREAD_TASSO_AMMORTAM_VALORE and SPREAD_TASSO_AMMORTAM_VALORE <= 3 then 3
        when 3 < SPREAD_TASSO_AMMORTAM_VALORE and SPREAD_TASSO_AMMORTAM_VALORE <= 4 then 4
        when 4 < SPREAD_TASSO_AMMORTAM_VALORE and SPREAD_TASSO_AMMORTAM_VALORE <= 5 then 5
        when 5 < SPREAD_TASSO_AMMORTAM_VALORE then 6
    end
order by trunc(data_operativita_rapporto,'fmmm'),DESCRIZIONE_TASSO_RIFTO_AMMORTAM, 3
;

select *--cod_tipo_tasso, TASSO_RIFTO_AMMORTAM,DESCRIZIONE_TASSO_RIFTO_AMMORTAM, SPREAD_TASSO_AMMORTAM_VALORE, tasso_effettivo_ammortam,SPREAD_DATA_STIPULA, IMP_EROGATO,IMP_LIQUIDATO, TAEG 
from s2a.mutui_all m
join (
        select VALORE as COD_TASSO_RIFTO_AMMORTAM, 
            DESCRIZIONE as DESCRIZIONE_TASSO_RIFTO_AMMORTAM
        from S2A.domini_attributi_all
        where abi_banca = '08883'
            and data_riferimento = '30-giu-2024'
            and SOTTO_APPLICAZIONE = 'MUTUI'
            and ATTRIBUTO = 'COD_TASSO_RIFTO_AMMORTAM'
    ) a
    on m.COD_TASSO_RIFTO_AMMORTAM = a.COD_TASSO_RIFTO_AMMORTAM
where data_riferimento = '30-giu-2023'
    and abi_banca = '08883'
    and COD_TIPO_TASSO = '02'
;


select *
from S2A.domini_attributi_all
where abi_banca = '08883'
    and data_riferimento = '30-giu-2024'
    and SOTTO_APPLICAZIONE like '%MUTUI%'