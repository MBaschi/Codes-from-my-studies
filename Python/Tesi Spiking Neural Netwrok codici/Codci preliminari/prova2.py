import numpy as np
import pandas as pd


U=(np.zeros((2,2)) , np.ones((2,2)) , np.zeros((2,2)))


W=(np.zeros((2,2)),np.zeros((2,2)))

df=pd.DataFrame(U[0])
df1=pd.DataFrame(U[1])

dfexcel=pd.ExcelWriter('prova2.xlsx',engine='xlsxwriter')

df.to_excel(dfexcel,sheet_name='U')
df1.to_excel(dfexcel,sheet_name='U1')

dfexcel.save()
print(df)