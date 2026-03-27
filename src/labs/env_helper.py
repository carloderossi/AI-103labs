import os
from dotenv import load_dotenv
from pathlib import Path

def load_labs_env():
    # Get configuration settings 
    env_path = Path(__file__).resolve().parents[1] / ".env"
    print(f"Gathering environmental variables from {env_path}")
    b = load_dotenv(dotenv_path=env_path)
    if b:
        print(f"Gathering environment variables from {env_path}")
    else:
        print("*"*40)
        print(f"WARNING: environment variables from {env_path} were NOT set!!")
        print("*"*40)

def get_cert_path() -> str:
    cert_path = Path(__file__).resolve().parents[3] / "local/certs/client-cert.pem"
    print(f"using certificate from: '{cert_path}'")
    return cert_path
