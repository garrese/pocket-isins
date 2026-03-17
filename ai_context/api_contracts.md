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

## 2. OpenAI (BYOK AI Insights)
*(To be defined when we reach the AI integration phase)*

## 3. OpenRouter (BYOK AI Insights)
*(To be defined when we reach the AI integration phase)*
