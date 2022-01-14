#!/usr/bin/env python
# coding: utf-8

# ## SparkML MLFLOW

# In[74]:


from pyspark.sql import SparkSession
from pyspark.sql.functions import col, pandas_udf,udf,lit

import azure.synapse.ml.predict as pcontext
import azure.synapse.ml.predict.utils._logger as synapse_predict_logger

import numpy as np
import pandas as pd
from pyspark.ml.linalg import Vectors
from pyspark.ml.stat import Correlation
from pyspark.ml.regression import LinearRegression


# In[75]:


spark.conf.set("spark.synapse.ml.predict.enabled","true")


# In[76]:


MODEL_URI = 'abfss://mlfs@synapsemladlsgen2.dfs.core.windows.net/predict/models/mlflow/sparkml/linear_regression_np10/'
RETURN_TYPES = 'float'


# In[77]:


model = pcontext.bind_model(
  return_types = RETURN_TYPES,
  runtime = 'mlflow',
  model_alias = 'sparkml_model',
  model_uri = MODEL_URI,).register()


# In[78]:


type(model)


# In[81]:


data = pd.DataFrame([(Vectors.dense(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),)], columns=["features"])
model.predict(data)


# In[ ]:




