import os
from dotenv import load_dotenv
from pathlib import Path

def load_labs_env():
    # Get configuration settings 
    env_path = Path(__file__).resolve().parent / ".env"
    print(f"Gathering environmental variables from {env_path}")
    b = load_dotenv(dotenv_path=env_path)
    if b:
        print(f"Successfully loaded environment variables from {env_path}")
    else:
        print("*"*40)
        print(f"WARNING: environment variables from {env_path} were NOT set!!")
        print("*"*40)

def get_cert_path() -> str:
    cert_path = Path(__file__).resolve().parents[2] / "local/certs/client-cert.pem"
    print(f"using certificate from: '{cert_path}'")
    return cert_path

def get_api_key():
    # Get API KEY
    api_key_path = Path(__file__).resolve().parent / "api.key"
    print(f"Gathering API Key from '{api_key_path}'")
    api_key = api_key_path.read_text().strip()
    if api_key:
        print(f"Successfully loaded API Key from '{api_key_path}'")
    else:
        print("*"*40)
        print(f"WARNING: API Key from '{api_key_path}' was NOT found!!")
        print("*"*40)
    return api_key
