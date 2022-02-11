#!/usr/bin/env python
# coding: utf-8

# # LightGBM

# This tutorial shows how to use Predict on a LightGBM model.

# ### Import SynapseML Predict

# In[1]:


import pandas as pd
import numpy as np

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, pandas_udf,udf,lit

import azure.synapse.ml.predict as pcontext
import azure.synapse.ml.predict.utils._logger as synapse_predict_logger

print(pcontext.__version__)


# ### Set some input parameters
# <p>Model and Data are both stored on ADLS<p>
# <p>Return type is array of float<p>

# In[2]:


ADLS_MODEL_URI_XGBOOST = "abfss://ajagarwfs@ajagarwdemoadlsg2.dfs.core.windows.net/predict/models/mlflow/lightgbm/lmodel_nf10/"
RETURN_TYPES = "float"


# ### Enable SynapseML predict
# Set the spark conf spark.synapse.ml.predict.enabled as true to enable the library.

# In[3]:


spark.conf.set("spark.synapse.ml.predict.enabled","true")


# ### Bind Model

# In[4]:


model = pcontext.bind_model(
    return_types=RETURN_TYPES, 
    runtime="mlflow", 
    model_alias="lightgbm_model", 
    model_uri=ADLS_MODEL_URI_XGBOOST
).register()


# ### Load Data

# In[5]:


data = np.random.rand(5, 10)
df = spark.createDataFrame(pd.DataFrame(data))
df.createOrReplaceTempView("data")
df.show()


# ### Model Prediction using SPARK_SQL

# In[6]:


predictions = spark.sql(
                  """
                      SELECT PREDICT('lightgbm_model', *) AS predict FROM data
                  """
              ).show()

