#!/usr/bin/env python
# coding: utf-8

# # Linear Regression (ONNX)

# This tutorial shows how to use Predict on an ONNX model.

# ### Import SynapseML Predict

# In[1]:


from pyspark.sql.functions import col, pandas_udf,udf,lit
from azureml.core import Workspace
from azureml.core.authentication import ServicePrincipalAuthentication
import azure.synapse.ml.predict as pcontext


# ### Set some input parameters
# <p>Data is stored on ADLS, model is stored on AML<p>
# <p>Return type is float<p>

# In[2]:


DATA_FILE = "abfss://ajagarwfs@ajagarwdemoadlsg2.dfs.core.windows.net/predict/dataset/LengthOfStay_cooked_small.csv"
AML_MODEL_URI_ONNX = "aml://mlflow_onnx:1" #Here ":1" signifies model version in AML. We can choose which version we want to run. If ":1" is not provided then by default latest version will be picked
RETURN_TYPES = "FLOAT"


# # Service principal credenatials

# In[3]:


AZURE_TENANT_ID = "xyz"
AZURE_CLIENT_ID = "xyz"
AZURE_CLIENT_SECRET = "xyz"


# # Bind AML workspace

# In[4]:


AML_SUBSCRIPTION_ID = "xyz"
AML_RESOURCE_GROUP = "ajagarw-demo-rg"
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


# ### Enable SynapseML predict
# Set the spark conf spark.synapse.ml.predict.enabled as true to enable the library.

# In[5]:


spark.conf.set("spark.synapse.ml.predict.enabled","true")


# ### Bind Model

# In[6]:


model = pcontext.bind_model(
    RETURN_TYPES, 
    "mlflow",
    "ONNX_linear_regression",
    AML_MODEL_URI_ONNX,
    aml_workspace=ws
    ).register()


# ### Load Data

# In[7]:


df = spark.read     .format("csv")     .option("header", "true")     .csv(DATA_FILE,
        inferSchema=True)
df = df.select(df.columns[:9])
df.createOrReplaceTempView('data')
df.show(10)
df


# In[8]:


spark.sql(
    """
        select * from data
    """
).show()


# ### Model Prediction using SPARK_SQL

# In[9]:


predictions = spark.sql(
                  """
                      SELECT PREDICT('ONNX_linear_regression', *) AS predict FROM data
                  """
              ).show()

