import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    replacements = [
        (r"Tab 2: Markets", r"Tab 2: Tickers"),
    ]

    for old, new in replacements:
        content = re.sub(old, new, content)

    with open(filepath, 'w') as f:
        f.write(content)

process_file('context/ui_flow.md')
