#!/usr/bin/env python
# coding: utf-8

# # Linear Regression (Sklearn)

# This tutorial shows how to use Predict on a Sklearn model.

# ## Train SKLearn Model

# In[1]:


import fsspec
import pandas

adls_account_name = 'ajagarwdemoadlsg2' #Provide exact ADLS account name
adls_account_key = '' #Provide exact ADLS account key

fsspec_handle = fsspec.open('abfs://ajagarwfs/predict/dataset/LengthOfStay_cooked_small.csv', account_name=adls_account_name, account_key=adls_account_key)

with fsspec_handle.open() as f:
    train_df = pandas.read_csv(f)


# In[2]:


import os
import shutil
import mlflow
import json
from mlflow.utils import model_utils

import numpy as np
import pandas as pd

from sklearn.linear_model import LinearRegression


class LinearRegressionModel():
  _ARGS_FILENAME = 'args.json'
  FEATURES_KEY = 'features'
  TARGETS_KEY = 'targets'
  TARGETS_PRED_KEY = 'targets_pred'

  def __init__(self, fit_intercept, nb_input_features=9, nb_output_features=1):
    self.fit_intercept = fit_intercept
    self.nb_input_features = nb_input_features
    self.nb_output_features = nb_output_features

  def get_args(self):
    args = {
        'nb_input_features': self.nb_input_features,
        'nb_output_features': self.nb_output_features,
        'fit_intercept': self.fit_intercept
    }
    return args

  def create_model(self):
    self.model = LinearRegression(fit_intercept=self.fit_intercept)

  def train(self, dataset):

    features = np.stack([sample for sample in iter(
        dataset[LinearRegressionModel.FEATURES_KEY])], axis=0)

    targets = np.stack([sample for sample in iter(
        dataset[LinearRegressionModel.TARGETS_KEY])], axis=0)


    self.model.fit(features, targets)

  def predict(self, dataset):
    features = np.stack([sample for sample in iter(
        dataset[LinearRegressionModel.FEATURES_KEY])], axis=0)
    targets_pred = self.model.predict(features)
    return targets_pred

  def save(self, path):
    if os.path.exists(path):
      shutil.rmtree(path)

    # save the sklearn model with mlflow
    mlflow.sklearn.save_model(self.model, path)

    # save args
    self._save_args(path)

  def _save_args(self, path):
    args_filename = os.path.join(path, LinearRegressionModel._ARGS_FILENAME)
    with open(args_filename, 'w') as f:
      args = self.get_args()
      json.dump(args, f)


def train(train_df, output_model_path):
  print(f"Start to train LinearRegressionModel.")

  # Initialize input dataset
  dataset = train_df.to_numpy()
  datasets = {}
  datasets['targets'] = dataset[:, -1]
  datasets['features'] = dataset[:, :9]

  # Initialize model class obj
  model_class = LinearRegressionModel(fit_intercept=10)
  with mlflow.start_run(nested=True) as run:
    model_class.create_model()
    model_class.train(datasets)
    model_class.save(output_model_path)
    print(model_class.predict(datasets))


train(train_df, './artifacts/output')


# ## Upload to AML

# In[3]:


from azureml.core import Workspace, Model
from azureml.core.authentication import ServicePrincipalAuthentication

AZURE_TENANT_ID = ""
AZURE_CLIENT_ID = ""
AZURE_CLIENT_SECRET = ""

AML_SUBSCRIPTION_ID = ""
AML_RESOURCE_GROUP = ""
AML_WORKSPACE_NAME = "ajagarw-demo-aml-ws"

svc_pr = ServicePrincipalAuthentication( 
    tenant_id=AZURE_TENANT_ID,
    service_principal_id=AZURE_CLIENT_ID,
    service_principal_password=AZURE_CLIENT_SECRET
)

ws = Workspace(
    workspace_name = AML_WORKSPACE_NAME,
    subscription_id = AML_SUBSCRIPTION_ID,
    resource_group = AML_RESOURCE_GROUP,
    auth=svc_pr
)

model = Model.register(
    model_path="./artifacts/output",
    model_name="mlflow_sklearn_e2e",
    workspace=ws,
)


# ### Import SynapseML Predict

# In[4]:


from pyspark.sql.functions import col, pandas_udf,udf,lit
import azure.synapse.ml.predict as pcontext


# ### Set some input parameters
# <p>Data is stored on ADLS, model is stored on AML<p>
# <p>Return type is int<p>

# In[5]:


DATA_FILE = "abfss://ajagarwfs@ajagarwdemoadlsg2.dfs.core.windows.net/predict/dataset/LengthOfStay_cooked_small.csv"
AML_MODEL_URI_SKLEARN = "aml://mlflow_sklearn_e2e" #Here ":1" signifies model version in AML. We can choose which version we want to run. If ":1" is not provided then by default latest version will be picked
RETURN_TYPES = "INT"


# ### Enable SynapseML predict
# Set the spark conf spark.synapse.ml.predict.enabled as true to enable the library.

# In[6]:


spark.conf.set("spark.synapse.ml.predict.enabled","true")


# ### Bind Model

# In[7]:


model = pcontext.bind_model(
    RETURN_TYPES, 
    "mlflow",
    "sklearn_linear_regression",
    AML_MODEL_URI_SKLEARN,
    aml_workspace=ws
    ).register()


# ### Load Data

# In[8]:


df = spark.read     .format("csv")     .option("header", "true")     .csv(DATA_FILE,
        inferSchema=True)
df = df.select(df.columns[:9])
df.createOrReplaceTempView('data')
df.show(10)
df


# In[9]:


spark.sql(
    """
        select * from data
    """
).show()


# ### Model Prediction using SPARK_SQL

# In[10]:


predictions = spark.sql(
                  """
                      SELECT PREDICT('sklearn_linear_regression', *) AS predict FROM data
                  """
              ).show()


# In[ ]:
