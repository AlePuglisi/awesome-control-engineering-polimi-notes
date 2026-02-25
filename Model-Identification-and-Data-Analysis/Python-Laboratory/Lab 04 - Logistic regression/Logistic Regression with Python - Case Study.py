
# coding: utf-8

# # Logistic Regression with Python - Case Study
# 
# For this case study we will work with the [Titanic Data Set from Kaggle](https://www.kaggle.com/c/titanic). This is a very famous dataset and very often adopted for students' first step in machine learning! 
# 
# We'll be trying to predict a classification - survival or deceased - by implementing Logistic Regression in Python.
# 
# We'll use a "semi-cleaned" version of the titanic dataset; if you use the data set directly hosted on Kaggle, you may need to perform some additional data cleaning operations not shown in this lecture notebook.
# 
# ## Import  Data Analysis and Visualization Libraries

# In[1]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

get_ipython().run_line_magic('matplotlib', 'inline')


# ## Import Dataset

# In[2]:


data = pd.read_csv('titanic.csv')                               # Import dataset


# In[3]:


data.head()                                                     # Show dataset header


# In[4]:


data.info()


# In[5]:


data.describe()


# # Exploratory Data Analysis
# 
# 
# ## Missing Data
# 
# We can use seaborn to create a simple heatmap to see where are missing data.

# In[6]:


sns.heatmap(data.isnull(), yticklabels =False, cbar = False, cmap='viridis')


# Roughly 20% of the 'Age' data is missing. Looking at the 'Cabin' column, a very high percentage of the related data is missing.

# ## Data Visualization

# In[7]:


sns.countplot(x = 'Survived', data = data, palette = 'RdBu_r')


# In[8]:


sns.countplot(x = 'Survived', hue = 'Sex', data = data)


# In[9]:


sns.countplot(x = 'Survived', hue = 'Pass. Class', data = data, palette = 'rainbow')


# In[10]:


sns.distplot(data['Age'].dropna(), kde = False, color = 'darkred', bins = 30)


# ## Data Cleaning
# We want to fill in missing age data instead of just dropping the missing age data rows. One way to do this is by filling in the mean age of all the passengers (imputation).
# However we can adopt a smarter approach and check the average age by passenger class.

# In[11]:


plt.figure(figsize=(12, 7))
sns.boxplot(x='Pass. Class', y='Age', data=data, palette='rainbow')


# We can see the wealthier passengers in the higher classes tend to be older, which makes sense. We'll use these average age values to impute based on Pass. Class for Age.

# In[12]:


def impute_age(cols):
    Age = cols[0]
    Pclass = cols[1]
    
    if pd.isnull(Age):

        if Pclass == 1:
            return 37

        elif Pclass == 2:
            return 29

        else:
            return 24

    else:
        return Age


# In[13]:


data['Age'] = data[['Age','Pass. Class']].apply(impute_age, axis=1)


# Now let's check that heat map again.

# In[14]:


sns.heatmap(data.isnull(), yticklabels=False, cbar=False, cmap='viridis')


# ### Drop Columns

# In[15]:


# Drop 'Cabin' column since useless (too many missing values)
data.drop('Cabin',axis=1,inplace=True)


# In[16]:


# Drop non-numeric columns
data.drop(['Ticket', 'Name'],axis=1,inplace=True)


# In[17]:


sns.heatmap(data.isnull(), yticklabels=False, cbar=False, cmap='viridis')


# In[18]:


data.head()


# In[19]:


data.info()


# # Building a Logistic Regression model
# 
# Let's start by splitting our data into a training set and test set.
# 
# ## Train-Test Split

# In[20]:


from sklearn.model_selection import train_test_split


# In[21]:


X = data.drop('Survived',axis=1)
y = data['Survived']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.30, random_state=101)


# ## Training and Predicting

# In[22]:


from sklearn.linear_model import LogisticRegression                      # Import Logistic Regression


# In[23]:


logmodel = LogisticRegression()                                          # Logistic Regression model instantiation
logmodel.fit(X_train, y_train)                                           # Model fitting


# In[24]:


predictions = logmodel.predict(X_test)                                   # Predictions on test set


# ## Performance Evaluation

# In[25]:


from sklearn.metrics import confusion_matrix, classification_report


# In[26]:


print(np.transpose(confusion_matrix(y_test, predictions)))  


# In[27]:


print(classification_report(y_test, predictions))                         # Compute precision, recall, f1-score


# ## Conclusion

# Not so bad! You might want to explore other features and the full Titanic Kaggle dataset; some suggestions for feature selection:
# 
# * Try grabbing the Title (Dr., Mr., Mrs, etc..) from the name as a feature
# * Maybe Ticket information could be exploited
# 
# Notice that, when dealing with non-numeric features, it is suggested to convert them into numerical values.
