# API Contracts

This document defines the expected request and response structures for the external integrations used in Pocket ISINs. According to `AGENTS.md`, this file serves as the source of truth for all API communications.

## 1. Yahoo Finance API (Market Data)

We use the Yahoo Finance Chart API (`https://query1.finance.yahoo.com/v8/finance/chart/{SYMBOL}`) to retrieve all market data. 
The API is extremely versatile based on the `range` and `interval` parameters.

We are interested in three levels of data:
1. **Current Quote**: The latest closing price, previous close, and currency (used for basic portfolio valuation).
2. **Intraday Chart (Sparkline)**: A lightweight set of data representing the evolution of the current/last trading day directly on the dashboard.
3. **Historical Chart**: Long-term data (weekly, monthly, 6-monthly) for dedicated detail screens.

### Common Requirements
- **Method**: GET
- **Headers Required**: 
  - `User-Agent`: Must be a standard browser user agent to avoid HTTP 401/403 Unauthorized errors (e.g. `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36`).

---

### Level 1: Current Quote
- **Query**: `?interval=1d&range=1d`
The endpoint returns a robust JSON object, but we are primarily interested in the `chart.result[0].meta` object which contains the last known market information.

```json
{
  "chart": {
    "result": [
      {
        "meta": {
          "currency": "USD",
          "symbol": "GOOGL",
          "regularMarketPrice": 310.92,
          "chartPreviousClose": 305.56,
          "regularMarketTime": 1773777601
          // ... other fields are ignored for now
        }
      }
    ],
    "error": null
  }
}
```

**Target Mapping (Dart)**:
- Parse `chart` -> `result` -> `[0]` -> `meta`.
- Extract `regularMarketPrice` as `double`.
- Extract `currency` as `String`.
- Extract `chartPreviousClose` to calculate daily variation (%).

---

### Level 2: Intraday Chart (Sparkline)
- **Query**: `?interval=5m&range=1d`
- **Goal**: Show a small graphic of the daily evolution on the main Portfolio list.
- **Structure**: Uses `timestamp` array for X-axis, and `indicators.quote[0].close` array for Y-axis.

---

### Level 3: Historical Chart
- **Query**: `?interval=1d&range=6mo` (configurable range: `1wk`, `1mo`, `3mo`, `6mo`, `1y`)
- **Goal**: Used in dedicated detail screens to show candlestick or larger line charts over time.
- **Structure**: Similar to Intraday, mapping `timestamp` against `indicators.quote[0].close`.

*(Check the `ai_context/yahoo_samples/` folder for exact JSON examples for these queries.)*

## 2. BYOK AI Insights (Universal Connector)

The application uses a universal HTTP connector compatible with the standard OpenAI API (`/v1/chat/completions`) to integrate LLMs, allowing users to configure OpenAI, OpenRouter, Ollama, or any compatible proxy.

### Syntax Selectors Strategy
Instead of generic company selectors, the BYOK settings allow the user to select the **Syntax** to be used for the HTTP request.
- If a new provider or model uses the exact same syntax as OpenAI, **no new selector is needed**. The user just selects the "OpenAI Compatible" syntax.
- If a provider (like Google AI Studio) or a specific feature (like OpenRouter's Web Search) requires a proprietary payload structure or endpoint, a **new Syntax Selector** is implemented.

Currently Supported Syntaxes:
1. **OpenAI Compatible**: Standard `/v1/chat/completions`. Used by OpenAI, Ollama, standard OpenRouter models, Groq, etc.
2. **Google AI Studio**: Proprietary Google Gemini syntax (`generateContent`).
3. **OpenRouter Web Search**: OpenAI compatible, but requires injecting `"plugins": [{"id": "web"}]` into the payload for models that support it (like `minmax/minmax-m2.7` or `openai/gpt-4o`).

### Setup and Authentication
- **Endpoint**: Configurable Base URL (defaults to `https://api.openai.com/v1/chat/completions`)
- **Headers**:
  - `Content-Type`: `application/json`
  - `Authorization`: `Bearer {API_KEY}` (if provided)
  - `HTTP-Referer`: `https://pocket-isins.app` (for OpenRouter ranking)
  - `X-Title`: `Pocket ISINs` (for OpenRouter display)

### News Insights Request Structure
The app requests news through standard system/user prompting, instructing the model to fetch and return formatted financial news.
```json
{
  "model": "{CONFIGURED_MODEL}",
  "messages": [
    {
      "role": "system",
      "content": "You are a financial AI assistant. Your task is to search the internet for the most relevant and recent news about global stock markets, economy, or major financial events.\\n\\nReturn exactly 5 news items.\\nYou must return the result STRICTLY as a JSON array of objects, with no markdown formatting, no code blocks, and no other text."
    },
    {
      "role": "user",
      "content": "Find the latest important stock market news."
    }
  ]
}
```

### Expected Response JSON Structure
The LLM is prompted to strictly return a string representing a JSON array with the following schema:
```json
[
  {
    "title": "News Headline",
    "summary": "Brief 2-3 sentence overview.",
    "url": "https://source.com/article",
    "source": "News Outlet Name"
  }
]
```
