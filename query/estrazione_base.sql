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
order by 1