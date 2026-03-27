from dotenv import load_dotenv
import os
from dotenv import load_dotenv
from pathlib import Path

# import namespaces
from azure.identity import DefaultAzureCredential, CertificateCredential
from azure.core.credentials import AzureKeyCredential
from azure.ai.textanalytics import TextAnalyticsClient
from azure.identity import get_bearer_token_provider

def main():
    try:
        # Clear the console
        os.system('cls' if os.name == 'nt' else 'clear')

        # 1. Configuration
        # Get configuration settings 
        env_path = Path(__file__).resolve().parents[1] / ".env"
        print(f"Gathering environmental variables from {env_path}")
        load_dotenv(dotenv_path=env_path)
        
        # Get API KEY
        api_key_path = Path(__file__).resolve().parents[1] / "api.key"
        api_key = api_key_path.read_text().strip()
        endpoint = os.getenv('AZUREAI_SERVICES_ENDPOINT')
        print(f"using enpoint : '{endpoint}'")

        # Create client using endpoint
        #credential = DefaultAzureCredential()
        credential = AzureKeyCredential(api_key)

        #endpoint = "https://cdr-lab03-proj-resource.cognitiveservices.azure.com/"
        # endpoint = "https://cdr-lab03-proj-resource.language.azure.com/"
        # https://cdr-lab03-proj-resource.services.ai.azure.com/
        
        ai_client = TextAnalyticsClient(endpoint=endpoint, credential=credential)
        ai_client.analyze_sentiment(documents=["Good Hotel and staff"])

        # Analyze each text file in the reviews folder
        reviews_folder = Path(__file__).resolve().parents[0] / "reviews"
        for file_name in os.listdir(reviews_folder):
            # Read the file contents
            print('\n-------------\n' + file_name)
            text = open(os.path.join(reviews_folder, file_name), encoding='utf8').read()
            print('\n' + text)

           # Get language
            detectedLanguage = ai_client.detect_language(documents=[text])[0]
            print('\nLanguage: {}'.format(detectedLanguage.primary_language.name))

            # Get sentiment
            sentimentAnalysis = ai_client.analyze_sentiment(documents=[text])[0]
            print("\nSentiment: {}".format(sentimentAnalysis.sentiment))

            # Get key phrases
            phrases = ai_client.extract_key_phrases(documents=[text])[0].key_phrases
            if len(phrases) > 0:
                print("\nKey Phrases:")
                for phrase in phrases:
                    print('\t{}'.format(phrase))

            # Get entities
            entities = ai_client.recognize_entities(documents=[text])[0].entities
            if len(entities) > 0:
                print("\nEntities")
                for entity in entities:
                    print('\t{} ({})'.format(entity.text, entity.category))

            # Get linked entities
            linked_entities = ai_client.recognize_linked_entities(documents=[text])[0].entities
            if len(linked_entities) > 0:
                print("\nLinks")
                for linked_entity in linked_entities:
                        print('\t{} ({})'.format(linked_entity.name, linked_entity.url))


    except Exception as ex:
        print(ex)
        raise ex


if __name__ == "__main__":
    main()