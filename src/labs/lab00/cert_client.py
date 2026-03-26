import os
from dotenv import load_dotenv
from pathlib import Path
from azure.identity import CertificateCredential
from azure.ai.projects import AIProjectClient
from openai import AzureOpenAI


# Get configuration settings
env_path = Path(__file__).resolve().parents[1] / ".env"
print(f"Gathering environmental variables from {env_path}")
load_dotenv(dotenv_path=env_path)

azure_openai_endpoint = os.getenv("AZURE_OPENAI_ENDPOINT")
print(f"using endpoint: '{azure_openai_endpoint}'")
model_deployment = os.getenv("MODEL_DEPLOYMENT")

# 1. Configuration
TENANT_ID = os.getenv("TENANT_ID")
CLIENT_ID = "424d2e0e-2242-420a-b819-7cb75b790546" # The ID for 'cdr-foundry-client'
cert_path = Path(__file__).resolve().parents[3] / "local/certs/client-cert.pem"
print(f"using certificate from: '{cert_path}'")
CERT_PATH = cert_path

AZURE_OPENAI_ENDPOINT = azure_openai_endpoint #"https://cdr-lab03-proj-resource.openai.azure.com/"
MODEL_DEPLOYMENT = model_deployment #"gpt-4o-mini"
PROJECT_ENDPOINT = "https://cdr-lab03-proj-resource.services.ai.azure.com/api/projects/cdr-lab03-proj" # Found in Foundry Portal

# 2. Initialize the Certificate Credential
# This PEM contains both your RSA Private Key and Client Cert
# This automatically finds the RSA Private Key and the Certificate inside the file
credential = CertificateCredential(
    tenant_id=TENANT_ID,
    client_id=CLIENT_ID,
    certificate_path=CERT_PATH
)

# 3. Initialize the Project Client (The Latest Way)
project_client = AIProjectClient( #).from_connection_string(
    endpoint=PROJECT_ENDPOINT,
    credential=credential
    )

# 4. Get the OpenAI client through the Foundry Project
# This is the recommended "latest" way to ensure tracing and connections are linked
openai_client = project_client.get_openai_client()
# openai_client = AzureOpenAI(
#     azure_endpoint=AZURE_OPENAI_ENDPOINT,
#     api_version="2024-06-01",
#     azure_ad_token_provider=credential.get_token("https://cognitiveservices.azure.com/.default").token_provider
# )

# Test the connection
response = openai_client.chat.completions.create(
    model=MODEL_DEPLOYMENT,
    messages=[{"role": "user", "content": "Say hello from CDR ACME INC!"}]
)

print(response.choices[0].message.content)