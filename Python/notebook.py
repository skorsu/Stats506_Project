#!/usr/bin/env python
# coding: utf-8

# In[31]:


import pandas as pd
import matplotlib.pyplot as plt
plt.style.use('fivethirtyeight')
get_ipython().run_line_magic('matplotlib', 'inline')
import statsmodels.api as sm
import numpy as np


# In[2]:


data = pd.read_csv("/Users/kwschulz/STATS506/Stats506_Project/Dataset/data.csv")


# In[3]:


data.head()


# In[4]:


data.isna().sum()


# In[5]:


data = data[["wage", "age", "education", "year"]]


# In[6]:


education_map = {"1. < HS Grad":"LessThanHS","2. HS Grad":"HSGrad",
                "3. Some College":"SomeCollege", "4. College Grad":"CollegeGrad",
                "5. Advanced Degree":"AdvancedDegree"}
data['education'] = data.education.map(education_map)


# In[7]:


data[["wage", "age"]].hist(layout=(2,1), figsize=(15,15))
plt.show()
plt.savefig('hist.png')


# In[8]:


data.year.value_counts().plot(kind='bar', title='year', ylabel='count', figsize=(7.5,7.5))
plt.savefig('year_bar.png')


# In[9]:


data.education.value_counts().plot(kind='bar', title='education', ylabel='count', figsize=(7.5,7.5))
plt.savefig('education_bar.png')


# In[10]:


dummy_vars = pd.get_dummies(data.education)[['CollegeGrad', 'HSGrad',
                                             'LessThanHS', 'SomeCollege']]
data = pd.concat([data[['wage', 'age', 'year']], dummy_vars], axis=1)


# In[11]:


data.head()


# In[12]:


model = sm.OLS(data["wage"], sm.add_constant(data.drop('wage',axis=1))).fit()


# In[13]:


model.summary()


# In[14]:


data["age_cut"] = pd.cut(data.age, bins=6, labels=False)


# In[15]:


model2 = sm.OLS(data["wage"], sm.add_constant(data.drop(['wage','age'],axis=1))).fit()


# In[16]:


model2.summary()


# In[17]:


data.plot(x="age", y="wage", kind='scatter', figsize=(7.5,7.5))


# In[32]:


p = np.poly1d(np.polyfit(data["age"], data["wage"], 2))
t = np.linspace(0, 80, 200)
plt.plot(data["age"], data["wage"], 'o', t, p(t), '-')
rs = sm.OLS(data["wage"], 
            np.column_stack([data["age"]**i for i in range(2)]) ).fit().rsquared
plt.title('r2 = {}'.format(rs))
plt.show()
plt.savefig('poly2.png')


# In[33]:


p = np.poly1d(np.polyfit(data["age"], data["wage"], 3))
t = np.linspace(0, 80, 200)
plt.plot(data["age"], data["wage"], 'o', t, p(t), '-')
rs = sm.OLS(data["wage"], 
            np.column_stack([data["age"]**i for i in range(3)]) ).fit().rsquared
plt.title('r2 = {}'.format(rs))
plt.show()
plt.savefig('poly3.png')


# In[34]:


p = np.poly1d(np.polyfit(data["age"], data["wage"], 4))
t = np.linspace(0, 80, 200)
plt.plot(data["age"], data["wage"], 'o', t, p(t), '-')
rs = sm.OLS(data["wage"], 
            np.column_stack([data["age"]**i for i in range(4)]) ).fit().rsquared
plt.title('r2 = {}'.format(rs))
plt.show()
plt.savefig('poly4.png')


# In[35]:


p = np.poly1d(np.polyfit(data["age"], data["wage"], 5))
t = np.linspace(0, 80, 200)
plt.plot(data["age"], data["wage"], 'o', t, p(t), '-')
rs = sm.OLS(data["wage"], 
            np.column_stack([data["age"]**i for i in range(5)]) ).fit().rsquared
plt.title('r2 = {}'.format(rs))
plt.show()
plt.savefig('poly5.png')


# In[ ]:




