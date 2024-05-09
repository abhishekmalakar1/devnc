import requests
import json

def get_aws_instance_metadata():
    url = "http://169.254.169.254/latest/dynamic/instance-identity/document"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            metadata = response.json()
            return metadata
        else:
            print(f"Failed to retrieve instance metadata. Status code: {response.status_code}")
            return None
    except requests.exceptions.RequestException as e:
        print(f"Error retrieving instance metadata: {e}")
        return None

def main():
    aws_metadata = get_aws_instance_metadata()
    if aws_metadata:
        print(json.dumps(aws_metadata, indent=4))
    else:
        print("Failed to retrieve AWS instance metadata.")

if __name__ == "__main__":
    main()
