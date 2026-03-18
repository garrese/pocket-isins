import urllib.request
import json
import sys

def search(query):
    url = "https://html.duckduckgo.com/html/?q=" + urllib.parse.quote(query)
    req = urllib.request.Request(
        url,
        data=None,
        headers={
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
    )

    try:
        response = urllib.request.urlopen(req)
        html = response.read().decode('utf-8')
        print(html[:500]) # Print beginning of html to verify
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    search(sys.argv[1] if len(sys.argv) > 1 else "openai api generic internet search")
