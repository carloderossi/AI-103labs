import os
import asyncio
from dotenv import load_dotenv
from openai import AsyncOpenAI
from pathlib import Path

async def main():
    # Clear the console
    os.system('cls' if os.name == 'nt' else 'clear')

    try:
        # Get configuration settings 
        env_path = Path(__file__).resolve().parents[1] / ".env"
        print(f"Gathering environmental variables from {env_path}")
        load_dotenv(dotenv_path=env_path)

        azure_openai_endpoint = os.getenv("AZURE_OPENAI_ENDPOINT")
        api_key = os.getenv("API_KEY")
        model_deployment = os.getenv("MODEL_DEPLOYMENT")

        # Initialize an async OpenAI client
        async_client = AsyncOpenAI(
            base_url=azure_openai_endpoint,
            api_key=api_key
        )

        # Track responses
        last_response_id = None

        # Loop until the user wants to quit
        while True:
            input_text = input('\nEnter a prompt (or type "quit" to exit): ')
            if input_text.lower() == "quit":
                break
            if len(input_text) == 0:
                print("Please enter a prompt.")
                continue

            # Await an asynchronous response
            response = await async_client.responses.create(
                        model=model_deployment,
                        instructions="You are a helpful AI assistant that answers questions and provides information.",
                        input=input_text,
                        previous_response_id=last_response_id
            )
            assistant_text = response.output_text
            print("Assistant:", assistant_text)
            last_response_id = response.id

    except Exception as ex:
        print("Error:", ex)

if __name__ == "__main__":
    asyncio.run(main())