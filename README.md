# Architecture and Concept Document: Pocket ISINs

**Application Name:** "Pocket ISINs"

---

## 1. Functional Concept of the Application
* **Objective:** Hybrid app (mobile/PC) for tracking an investment portfolio based on ISINs, combining market price extraction with AI agents for news analysis.
* **Main flow:** The user inputs the ISINs of their assets and their position (invested amount). The app categorizes the assets, calculates the total value, shows the relative weight in the portfolio, and renders evolution charts. In parallel, it searches for news about those assets and uses AI to summarize their content and analyze market sentiment or impact.

## 2. Software Architecture and Ecosystem
* **Framework:** Flutter (Dart). All development is concentrated on the client.
* **Paradigm:** 100% Local (Client-Side). There is no proprietary backend or cloud server. All orchestration logic resides in the application.
* **State Management:** Riverpod. In charge of separating the data layer from the visual interface and handling reactivity.
* **Data Persistence:**
    * Local database (Isar) to store the portfolio (ISINs, relationships with Tickers, transactions, news cache, tickers cache).
    * Secure storage layer (`flutter_secure_storage`) to encrypt the user's API Keys on the device.

## 3. Artificial Intelligence Integration (BYOK Approach)
* **"Bring Your Own Key" Model:** The app is provider-agnostic. The user configures their own credentials in the local app settings.
* **Universal Connector:** A single HTTP client will be programmed based on the OpenAI API standard (`/v1/chat/completions`). Compatible with OpenAI, OpenRouter, local models (Ollama), and Google Gemini (via OpenAI endpoint).
* **Configuration variables:** Base URL, API Key, and Model Name.

## 4. Financial Data Extraction (Market Data)
* **Data Model (ISIN -> Tickers):** 1 to N relationship. A single asset (ISIN) can be tracked in multiple markets simultaneously through different Tickers (e.g., AAPL on NASDAQ/USD and APC.DE on Xetra/EUR).
* **Provider:** Public Yahoo Finance API.
* **Network Optimization:** Bulk HTTP requests (multiple symbols per call).
* **Multi-market visualization:** Interface with tabs to switch between different quotes for the same asset.
