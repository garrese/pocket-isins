# AI Context Architecture

This document defines how AI agents should read, maintain, and structure the project context throughout its lifecycle.

## 1. Context File Structure
The application's development context is divided into the following levels, ensuring that AI tools (agents) do not lose track.

*   `AGENTS.md` (Root): Master file. Contains absolute rules, the repository's "System Prompt", and the entry point for any agent.
*   `ai_context/` (Directory): Rules, guides, and long-term memory for the AI.
    *   `ai_context/architecture.md`: Architectural decisions (Riverpod, Isar, BYOK).
    *   `ai_context/database_schema.md`: Definitions of local models, relationships, and persistence rules.
    *   `ai_context/api_contracts.md`: How we integrate with Yahoo Finance and LLM APIs (OpenAI, OpenRouter, etc.).

## 2. Agent Operation Rules

1.  **Mandatory Reading:** Before planning any major refactoring or Feature creation, the agent MUST read `AGENTS.md` and relevant files within `ai_context/`.
2.  **Constant Maintenance:** If an important technical decision is made (e.g., changing from DIO to HTTP, modifying the Isar schema), the agent MUST update the corresponding file in `ai_context/`.
3.  **Do Not Assume:** If there are discrepancies between the current code and `ai_context/architecture.md`, the agent must propose to the user and be guided by the architecture document.
4.  **Language:** All context, documentation, and code MUST be written in English. The agent might communicate with the user in Spanish if requested, but project artifacts are English strictly.

## 3. Software Architecture and Ecosystem
* **Framework:** Flutter (Dart). All development is concentrated on the client.
* **Paradigm:** 100% Local (Client-Side). There is no proprietary backend or cloud server. All orchestration logic resides in the application.
* **State Management:** Riverpod. In charge of separating the data layer from the visual interface and handling reactivity.
* **Data Persistence:**
    * Local database (Drift/SQLite) to store the portfolio (ISINs, Tickers, caches).
    * Secure storage layer (`flutter_secure_storage`) to encrypt the user's API Keys on the device.

## 4. Artificial Intelligence Integration (BYOK Approach)
* **"Bring Your Own Key" Model:** The app is provider-agnostic. The user configures their own credentials (Base URL, API Key, Model Name) in the local app settings (`flutter_secure_storage`).
* **Universal Connector:** A single HTTP client based on the OpenAI API standard (`/v1/chat/completions`) inside `AiService`. It strictly defines JSON output schemas via system prompts to ensure data can be mapped to Dart models, leveraging the model's native capability to search the web if instructed (e.g. OpenAI's `gpt-4o` or Perplexity models via OpenRouter).

## 5. Financial Data Extraction Strategy
* **Bulk HTTP requests:** Network optimization fetching multiple symbols per call when communicating with Yahoo Finance API.
* **Caching Strategy:** 
    * Heavily cache Level 1 (quote) and Level 2 (intraday 5m) via Isar using the `MarketDataCache` model. 
    * Fetch Level 3 (historical data) strictly on-demand in Detail screens to avoid overloading the local storage and network.

## 6. Known Limitations
* **Flutter Web Support:** Previously the app used Isar, which was fundamentally incompatible with Web due to its usage of 64-bit integers breaking Javascript's safety limit. **The project now uses Drift**, resolving this compilation error. Sembast was considered as a NoSQL alternative but discarded because it loads the entire database into RAM upon initialization, which is inefficient since the app stores massive JSON payloads for historical charts and news. Drift was chosen because it provides robust support for WebAssembly and OPFS file systems for proper disk storage on the Web, resolving the 1:N relations while emulating NoSQL capabilities using JSON strings for heavy payload columns.
