import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # We only want to replace UI strings, not variable names.
    # Look for exact UI strings that need changing based on the provided grep.

    replacements = [
        (r"'No markets found automatically\. You can add them manually\.'", r"'No tickers found automatically. You can add them manually.'"),
        (r"'Error searching markets'", r"'Error searching tickers'"),
        (r"'Error searching markets: \$e'", r"'Error searching tickers: $e'"),
        (r"'Added market: \$symbol'", r"'Added ticker: $symbol'"),
        (r"'Market \$symbol is already in the list\.'", r"'Ticker $symbol is already in the list.'"),
        (r"'Add Market Manually'", r"'Add Ticker Manually'"),
        (r"'Could not find market data for symbol: \$symbol'", r"'Could not find ticker data for symbol: $symbol'"),
        (r"'Error manually adding market'", r"'Error manually adding ticker'"),
        (r"'Error finding market: \$e'", r"'Error finding ticker: $e'"),
        (r"'Please add at least one market before saving\.'", r"'Please add at least one ticker before saving.'"),
        (r"'Error saving ISIN from Markets step'", r"'Error saving ISIN from Tickers step'"),
        (r"const Text\('Markets'\)", r"const Text('Tickers')"),
        (r"'Select Markets:'", r"'Select Tickers:'"),
    ]

    for old, new in replacements:
        content = re.sub(old, new, content)

    with open(filepath, 'w') as f:
        f.write(content)

process_file('lib/features/portfolio/presentation/screens/markets_step_screen.dart')
