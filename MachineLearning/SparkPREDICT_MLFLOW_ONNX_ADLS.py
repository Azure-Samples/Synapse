#!/usr/bin/env python
# coding: utf-8

# # Linear Regression (ONNX)

# This tutorial shows how to use Predict on an ONNX model.

# ### Import SynapseML Predict

# In[5]:


import pandas as pd

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, pandas_udf,udf,lit

import azure.synapse.ml.predict as pcontext
import azure.synapse.ml.predict.utils._logger as synapse_predict_logger

print(pcontext.__version__)


# ### Set some input parameters
# <p>Model and Data are both stored on ADLS<p>
# <p>Return type is float<p>

# In[6]:


DATA_FILE = "abfss://ajagarwfs@ajagarwdemoadlsg2.dfs.core.windows.net/predict/dataset/LengthOfStay_cooked_small.csv"
ADLS_MODEL_URI_SKLEARN = "abfss://ajagarwfs@ajagarwdemoadlsg2.dfs.core.windows.net/predict/models/mlflow/onnx/linear_regression/"
RETURN_TYPES = "FLOAT"


# ### Enable SynapseML predict
# Set the spark conf spark.synapse.ml.predict.enabled as true to enable the library.

# In[7]:


spark.conf.set("spark.synapse.ml.predict.enabled","true")


# ### Bind Model

# In[8]:


model = pcontext.bind_model(RETURN_TYPES, "mlflow","ONNX_linear_regression", ADLS_MODEL_URI_SKLEARN).register()


# ### Load Data

# In[9]:


df = spark.read     .format("csv")     .option("header", "true")     .csv(DATA_FILE,
        inferSchema=True)
df = df.select(df.columns[:9])
df.createOrReplaceTempView('data')
df.show(10)
df


# In[10]:


spark.sql(
    """
        select * from data
    """
).show()


# ### Model Prediction using SPARK_SQL

# In[11]:


predictions = spark.sql(
                  """
                      SELECT PREDICT('ONNX_linear_regression', *) AS predict FROM data
                  """
              ).show()

