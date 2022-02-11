#!/usr/bin/env python
# coding: utf-8

# ## E2E Xgboost MLFLOW

# In[45]:


from pyspark.sql import SparkSession
from pyspark.sql.functions import col, pandas_udf,udf,lit

import azure.synapse.ml.predict as pcontext
import azure.synapse.ml.predict.utils._logger as synapse_predict_logger

import numpy as np
import pandas as pd
import xgboost as xgb
import mlflow


# In[46]:


spark.conf.set("spark.synapse.ml.predict.enabled","true")


# ## Train and Save Model

# ### Training

# In[47]:


data = np.random.rand(5, 10)  # 5 entities, each contains 10 features
label = np.random.randint(1, size=5)  # binary target
dtrain = xgb.DMatrix(data, label=label)

xgr = xgb.XGBRFRegressor(objective='reg:linear', n_estimators=10, seed=123)
xgr.fit(data, label)


# In[48]:


xgr.save_model('./model.json')


# In[49]:


mlflow.pyfunc.save_model(
    data_path='./model.json',
    path='./xgboost_pyfunc_model_path',
    loader_module='mlflow.xgboost')


# In[50]:


MODEL_URI = './xgboost_pyfunc_model_path'
RETURN_TYPES = 'float'


# In[51]:


model = pcontext.bind_model(
  return_types = RETURN_TYPES,
  runtime = 'mlflow',
  model_alias = 'xgb_model',
  model_uri = MODEL_URI,).register()


# In[52]:


type(model)


# In[53]:


data = np.random.rand(5, 10)
df = spark.createDataFrame(pd.DataFrame(data))
df.createOrReplaceTempView("data")
df.show()


# In[54]:


predictions = spark.sql(
                  """
                      SELECT PREDICT('xgb_model', *) AS predict FROM data
                  """
              ).show()

