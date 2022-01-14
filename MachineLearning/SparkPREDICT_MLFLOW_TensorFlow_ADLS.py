#!/usr/bin/env python
# coding: utf-8

# # Linear Regression (Tensorflow)

# This tutorial shows how to use Predict on a TensorFlow model.

# ### Import SynapseML Predict

# In[1]:


import pandas as pd

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, pandas_udf,udf,lit

import azure.synapse.ml.predict as pcontext
import azure.synapse.ml.predict.utils._logger as synapse_predict_logger

print(pcontext.__version__)


# ### Set some input parameters
# <p>Model and Data are both stored on ADLS<p>
# <p>Return type is array of float<p>

# In[2]:


DATA_FILE = "abfss://ajagarwfs@ajagarwdemoadlsg2.dfs.core.windows.net/predict/dataset/iris.csv"
ADLS_MODEL_URI_TENSORFLOW = "abfss://ajagarwfs@ajagarwdemoadlsg2.dfs.core.windows.net/predict/models/mlflow/tensorflow/mlflow/"
#ADLS_MODEL_URI_TENSORFLOW = "abfss://ajagarwfs@ajagarwdemoadlsg2.dfs.core.windows.net/predict/models/mlflow/tensorflow/linear_regression/"
RETURN_TYPES = "array<float>"


# ### Enable SynapseML predict
# Set the spark conf spark.synapse.ml.predict.enabled as true to enable the library.

# In[3]:


spark.conf.set("spark.synapse.ml.predict.enabled","true")


# ### Bind Model

# In[4]:


model = pcontext.bind_model(
    return_types=RETURN_TYPES, 
    runtime="mlflow", 
    model_alias="tensorflow_linear_regression", 
    model_uri=ADLS_MODEL_URI_TENSORFLOW
    ##meta_data={'meta_graph': ['serve'], 'signature_def_key': 'serving_default'},
).register()


# ### Load Data

# In[5]:


df = spark.read     .format("csv")     .option("header", "true")     .csv(DATA_FILE,
        inferSchema=True)
df = df.select(df.columns[:4])
df.createOrReplaceTempView('data')
df.show(10)
df


# In[6]:


spark.sql(
    """
        select * from data
    """
).show()


# ### Model Prediction using SPARK_SQL

# In[7]:


predictions = spark.sql(
                  """
                      SELECT PREDICT('tensorflow_linear_regression', *) AS predict FROM data
                  """
              ).show()

