import pandas as pd
import numpy as np


cols = [0,1,5,6,8]
df = pd.read_csv('ocorrenciasmun-brasil2015.csv', sep=';', usecols=cols, dtype={'PC-Qtde Ocorrências': np.float64}, encoding='latin-1', error_bad_lines=False)

def totalCrimesByKey(key: str, it):
    returnDict = {}
    # https://stackoverflow.com/questions/7837722/what-is-the-most-efficient-way-to-loop-through-dataframes-with-pandas
    for i,row in it.iterrows():
        if it[key][i] in returnDict:
            returnDict[it[key][i]] += it["PC-Qtde Ocorrências"][i]
        else:
            returnDict[it[key][i]] = it["PC-Qtde Ocorrências"][i]
    return returnDict

def crimeByMonth(crime: str, it):
    returnDict = {}
    for i,row in it.iterrows():
        if it["Tipo Crime"][i] == crime:
            if it["Mês"][i] in returnDict:
                returnDict[it["Mês"][i]] += it["PC-Qtde Ocorrências"][i]
            else:
                returnDict[it["Mês"][i]] = it["PC-Qtde Ocorrências"][i]
    return returnDict

# Extrai o total de crimes por mes;
print(totalCrimesByKey("Mês", df).values())

# Imprimir dicionário de Crimes por Estado
print(totalCrimesByKey("Sigla UF", df))

# Imprimir dicionário de Crimes por região
print(totalCrimesByKey("Região", df))

# Imprimir o total por Tipo de Crime
print(totalCrimesByKey("Tipo Crime", df))

# Imprime a quantidade de determinado crime por mes
print(crimeByMonth("Estupro", df))