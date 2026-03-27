# Before running the sample:
#    pip install azure-ai-projects>=2.0.0

from azure.identity import DefaultAzureCredential, CertificateCredential
from azure.ai.projects import AIProjectClient

import sys, os
sys.path.append('c:/Carlo/Azure/AI-102/labs/src/labs')
from env_helper import load_labs_env, get_cert_path, get_api_key

load_labs_env()
TENANT_ID = os.getenv("TENANT_ID")
SUBSCRIPTION_ID = os.getenv("SUBSCRIPTION_ID")
CLIENT_ID = "424d2e0e-2242-420a-b819-7cb75b790546"

CERT_PATH = get_cert_path()
credential = CertificateCredential(
    tenant_id=TENANT_ID,
    client_id=CLIENT_ID,
    certificate_path=CERT_PATH
)

my_endpoint = "https://charliebossanova-0800-resource.services.ai.azure.com/api/projects/charliebossanova-0800"

project_client = AIProjectClient(
    endpoint=my_endpoint,
    # credential=DefaultAzureCredential(),
    credential=credential
)

my_agent = "Agent176"
my_version = "2"

openai_client = project_client.get_openai_client()

# Reference the agent to get a response
response = openai_client.responses.create(
    input=[{"role": "user", "content": "Tell me what you can help with."}],
    extra_body={"agent_reference": {"name": my_agent, "version": my_version, "type": "agent_reference"}},
)

print(f"Response output: {response.output_text}")



