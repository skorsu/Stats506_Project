#!/usr/bin/env python
# coding: utf-8

# In[1]:


#------------------------------------------------------------------------------#
#Required Packages
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
import numpy as np
import os
import subprocess
import scipy
import seaborn as sns
from patsy import dmatrix, dmatrices 

#Set style for plots 
plt.style.use('seaborn')

#Add if running in a jupyter notebook 
#get_ipython().run_line_magic('matplotlib', 'inline')

#Create folder to store plot output 
if not os.path.exists('images'):
    os.makedirs('images')


# In[2]:


data = pd.read_csv('https://raw.githubusercontent.com/skorsu/Stats506_Project/main/Dataset/data.csv')
data.head()

#Saving output as png for rmd display 
data.head().to_html("images/summary_table.html")
subprocess.call('wkhtmltoimage -f png --width 0 images/summary_table.html images/summary_table.png', 
                shell=True)


# In[3]:


education_map = {'1. < HS Grad':1, '2. HS Grad':2, '3. Some College':3, 
                 '4. College Grad':4, '5. Advanced Degree':5}
data['education'] = data.education.map(education_map)


# In[4]:


data = data[['wage', 'age', 'education', 'year']]


# In[5]:


model = sm.OLS(data['wage'], sm.add_constant(data.drop('wage',axis=1))).fit()
model.summary()

#Saving output as png for rmd display - attribution:
#https://stackoverflow.com/questions/46664082/python-how-to-save-statsmodels-results-as-image-file
plt.rc('figure', figsize=(7.5, 7.5))
plt.text(0.01, 0.05, str(model.summary()), 
         {'fontsize': 10}, fontproperties = 'monospace') 
plt.axis('off')
plt.tight_layout()
plt.savefig('images/linear_model_summary.png')


# In[6]:


fig = sm.qqplot(model.resid, scipy.stats.norm, line='r')
fig.set_size_inches(7.5, 7.5)
plt.title('QQ Plot (Normal Distribution)')
plt.savefig("images/qqplot_lr.png")


# In[7]:


pd.Series(model.resid).plot.kde(figsize=(7.5,7.5))
plt.title('Kernal Density Estimate')
plt.savefig("images/kde_lr.png")


# In[8]:


fig, ax = plt.subplots(figsize=(7.5,7.5))
sns.regplot(data['age'],data['wage'])
plt.title('Age v. Wage (Linear Reg.)')
plt.xlim([17,81])
plt.savefig('images/age_v_wage_lr.png')


# In[9]:


plt.figure(figsize=(7.5,7.5))
p = np.poly1d(np.polyfit(data["age"], data["wage"], 3))
t = np.linspace(0, 80, 200)
plt.plot(data["age"], data["wage"], 'o', t, p(t), '-')
plt.ylabel('Wage')
plt.xlabel('Age')
plt.title('Age v. Wage (Cubic Polynomial)')
plt.savefig('images/age_v_wage_cubic.png')


# In[10]:


#Building model with a cubic polynomial from pandas df
cubic_model = sm.OLS(data["wage"], sm.add_constant(np.column_stack(
                                                     [data["age"]**i for i in [1,2,3]] 
                                                   + [np.array(data['education'])] 
                                                   + [np.array(data['year'])]))).fit()
cubic_model.summary(xname=['const','age*1', 'age*2', 'age*3', 'education', 'year'])

#Saving output as png for rmd display - attribution:
#https://stackoverflow.com/questions/46664082/python-how-to-save-statsmodels-results-as-image-file
plt.rc('figure', figsize=(7.5, 7.5))
plt.text(0.01, 0.05, str(cubic_model.summary(xname=['const','age*1', 'age*2', 'age*3', 
                                                    'education', 'year'])), 
                                                   {'fontsize': 10}, 
                                                   fontproperties = 'monospace') 
plt.axis('off')
plt.tight_layout()
plt.savefig('images/cubic_model_summary.png')


# In[11]:


data['age_cut'] = pd.cut(data.age, bins=6, labels=False)
data = data.merge(pd.get_dummies(data['age_cut']).add_prefix('age_cut_'), 
                  left_index=True, right_index=True)


# In[12]:


plt.figure(figsize=(7.5,7.5))
data.plot.scatter(x='age', y='wage', c='age_cut', colorbar=False)
plt.ylabel('Wage')
plt.xlabel('Age')
plt.title('Age v. Wage (stepwise)')
plt.savefig('images/age_v_wage_stepwise.png')


# In[13]:


stepwise_model = sm.OLS(data["wage"], sm.add_constant(data.drop(['wage','age','age_cut'],
                                                                axis=1))).fit()
stepwise_model.summary()

#Saving output as png for rmd display - attribution:
#https://stackoverflow.com/questions/46664082/python-how-to-save-statsmodels-results-as-image-file
plt.rc('figure', figsize=(7.5, 7.5))
plt.text(0.01, 0.05, str(stepwise_model.summary()), 
         {'fontsize': 10}, fontproperties = 'monospace') 
plt.axis('off')
plt.tight_layout()
plt.savefig('images/stepwise_model_summary.png')


# In[14]:


y_a,X_a = dmatrices('wage ~ bs(age, df=6)', data)
age_basis_model = sm.OLS(y_a,X_a).fit()
xs = np.linspace(18, 80, 200)
plt.plot(data["age"], data["wage"], 'o', xs, age_basis_model.predict(
    dmatrix("bs(age, df=6)",{"age":xs.reshape(-1,1)}, return_type='dataframe')), '-')
plt.ylabel('Wage')
plt.xlabel('Age')
plt.title('Age v. Wage (Basis Spline)')
plt.savefig('images/age_v_wage_basis.png')


# In[15]:


y,X = dmatrices('wage ~ education + year + bs(age, df=6)', data)
basis_model = sm.OLS(y,X).fit()
basis_model.summary()

#Saving output as png for rmd display - attribution:
#https://stackoverflow.com/questions/46664082/python-how-to-save-statsmodels-results-as-image-file
plt.rc('figure', figsize=(7.5, 7.5))
plt.text(0.01, 0.05, str(basis_model.summary()), 
         {'fontsize': 10}, fontproperties = 'monospace') 
plt.axis('off')
plt.tight_layout()
plt.savefig('images/basis_model_summary.png')


# In[16]:


y_na,X_na = dmatrices('wage ~ cr(age, df=6)', data)
age_natural_model = sm.OLS(y_na,X_na).fit()
xs = np.linspace(18, 80, 200)
plt.plot(data["age"], data["wage"], 'o', xs, age_natural_model.predict(
    dmatrix("cr(age, df=6)",{"age":xs.reshape(-1,1)}, return_type='dataframe')), '-')
plt.ylabel('Wage')
plt.xlabel('Age')
plt.title('Age v. Wage (Natural Spline)')
plt.savefig('images/age_v_wage_natural.png')


# In[17]:


y2,X2 = dmatrices("wage ~ education + year + cr(age, df=6)", data)
natural_model = sm.OLS(y2,X2).fit()
natural_model.summary()

#Saving output as png for rmd display - attribution:
#https://stackoverflow.com/questions/46664082/python-how-to-save-statsmodels-results-as-image-file
plt.rc('figure', figsize=(7.5, 7.5))
plt.text(0.01, 0.05, str(natural_model.summary()), 
         {'fontsize': 10}, fontproperties = 'monospace') 
plt.axis('off')
plt.tight_layout()
plt.savefig('images/natural_model_summary.png')


# In[ ]:




