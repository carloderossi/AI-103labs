import os
from dotenv import load_dotenv
from pathlib import Path
from openai import OpenAI

def main(): 
    # Clear the console
    os.system('cls' if os.name == 'nt' else 'clear')

    try:
        # Get configuration settings 
        env_path = Path(__file__).resolve().parents[1] / ".env"
        print(f"Gathering environmental variables from {env_path}")
        load_dotenv(dotenv_path=env_path)
        
        # Get API KEY
        api_key_path = Path(__file__).resolve().parents[1] / "api.key"
        api_key = api_key_path.read_text().strip()

        azure_openai_endpoint = os.getenv("AZURE_OPENAI_ENDPOINT")
        print(f"using endpoint: '{azure_openai_endpoint}'")
        # api_key = os.getenv("API_KEY")
        model_deployment = os.getenv("MODEL_DEPLOYMENT")

        # Initialize the OpenAI client
        openai_client = OpenAI(
            base_url=azure_openai_endpoint,
            api_key=api_key
        )   

        # Loop until the user wants to quit
        while True:
            input_text = input('\nEnter a prompt (or type "quit" to exit): ')
            if input_text.lower() == "quit":
                break
            if len(input_text) == 0:
                print("Please enter a prompt.")
                continue

            # Get a response - using Responses API: more compact syntax
            response = openai_client.responses.create(
                        model=model_deployment,
                        instructions="You are a helpful AI assistant that answers questions and provides information.",
                        input=input_text
            )
            print(response.output_text)
            
    except Exception as ex:
        print(ex)

if __name__ == '__main__': 
    main()
