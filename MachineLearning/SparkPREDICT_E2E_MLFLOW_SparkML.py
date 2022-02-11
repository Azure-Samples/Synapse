#!/usr/bin/env python
# coding: utf-8

# ## E2E SparkML MLFLOW

# In[4]:


from pyspark.sql import SparkSession
from pyspark.sql.functions import col, pandas_udf,udf,lit
from pyspark.ml.linalg import Vectors
from pyspark.ml.stat import Correlation
from pyspark.ml.regression import LinearRegression

import azure.synapse.ml.predict as pcontext
import azure.synapse.ml.predict.utils._logger as synapse_predict_logger

import numpy as np
import pandas as pd
import mlflow


# In[5]:


spark.conf.set("spark.synapse.ml.predict.enabled","true")


# ## Train and Save Model

# ### Training

# In[7]:


from pyspark.ml import Pipeline
from pyspark.ml.classification import LogisticRegression
from pyspark.ml.feature import HashingTF, Tokenizer

training = spark.read.format("libsvm").load("/predict/dataset/sample_linear_regression_data.txt")
lr = LinearRegression(maxIter=10, regParam=0.3, elasticNetParam=0.8)
pipeline = Pipeline(stages=[lr])

# Fit the pipeline to training documents.
model = pipeline.fit(training)


# In[8]:


# save model as Pipeline Model
model.save('/sparkml_pipeline_model')
# copy to local
import subprocess
subprocess.call(['hadoop fs -get /sparkml_pipeline_model ./pyfunc_mlflow_model'], shell=True)
# use mlfow.pyfunc.save_model to package
mlflow.pyfunc.save_model(
    data_path='./pyfunc_mlflow_model',
    path='./sparkml_pyfunc_model_path',
    loader_module='mlflow.spark')


# In[9]:


MODEL_URI = './sparkml_pyfunc_model_path'
RETURN_TYPES = 'float'


# In[10]:


model = pcontext.bind_model(
  return_types = RETURN_TYPES,
  runtime = 'mlflow',
  model_alias = 'sparkml_model',
  model_uri = MODEL_URI,).register()


# In[11]:


type(model)


# In[12]:


data = pd.DataFrame([(Vectors.dense(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),)], columns=["features"])
model.predict(data)


# In[ ]:




