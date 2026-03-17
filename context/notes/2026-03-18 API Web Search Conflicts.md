Aquí tienes la traducción del informe, manteniendo la terminología técnica estándar de desarrollo de software:

```markdown
# Architecture Report: BYOK Integration vs. Web Search Conflict in Pocket ISINs

## 1. Nature of the Problem

There is a direct incompatibility between the functional specifications and the technical constraints defined in the project's initial design:

* **Functional Requirement:** The application must fetch news about the assets (ISINs/Tickers) and use AI to summarize the content and analyze sentiment.
* **Technical Constraint:** A "Universal Connector" is established, defined as a single HTTP client agnostic to the provider, strictly based on the OpenAI API standard (`/v1/chat/completions`).

**The Conflict:** The `/v1/chat/completions` standard unifies the structure of conversation messages, but does not standardize internet connection capabilities or the use of tools (Tool Calling / Grounding). Requiring a single static HTTP client to trigger web search across disparate providers (OpenAI, Gemini, Ollama, OpenRouter) via the same payload will result in runtime failures.

## 2. Impact Analysis on Current Architecture

Maintaining the current single HTTP client design generates the following critical issues at runtime:

* **Systemic Hallucinations:** If a standard provider API Key is configured (e.g., OpenAI with `gpt-4o`) using a basic payload without the specific `tools` array, the model will lack internet access. When asked for recent news on a Ticker, it will invent information based on its pre-training data, invalidating the core utility of the app.
* **400 Errors (Bad Request):** Attempting to inject proprietary parameters (like `plugins` for OpenRouter or `Google Search_retrieval` for Gemini) into the generic payload will cause APIs of providers that do not support those parameters to immediately reject the HTTP request.
* **Infeasibility of Local Models:** The specified support for tools like Ollama fails in this context. A local LLM lacks an integrated web search engine that can be activated from a prompt or flag; therefore, it cannot fulfill the requirement of fetching real-time news.

## 3. Architectural Refactoring Paths

To resolve the conflict while maintaining the "Bring Your Own Key" (BYOK) approach and state management in Riverpod, three alternatives are proposed:

### Option A: Decouple Search from Inference (Recommended)
This involves shifting the "web search" responsibility from the LLM to the Flutter application itself.

* **Mechanics:** The application's data layer makes HTTP requests to financial news APIs (e.g., NewsAPI, Yahoo Finance News) using the Tickers.
* **Inference:** The text extracted from the news is injected directly as context into the `content` of the system prompt.
* **Impact:** Allows keeping the original "Universal Connector" intact. The HTTP client becomes truly agnostic again, as the LLM is limited to processing text (summarizing and analyzing sentiment) without needing to connect to the internet. This makes any model viable, including Ollama.

### Option B: Implement an "Adapter" Pattern in the Network Layer
This involves abandoning the single static HTTP client in favor of a dynamic abstraction layer.

* **Mechanics:** Using Riverpod, factories (Adapters) are implemented to evaluate the active configuration (Base URL or Model Name). Before making the HTTP request, the Adapter mutates the base payload to inject the necessary proprietary structure (`tools`, `plugins`, etc.) according to the detected provider.
* **Impact:** Allows delegating the search to the LLM but significantly increases technical debt. It requires continuous maintenance in the Flutter codebase to adapt to changes in each provider's API specifications.

### Option C: Restrict BYOK to "Online" Providers
Modifies the project scope, limiting compatible services.

* **Mechanics:** The application will only accept credentials from providers whose models integrate web search by default in the endpoint itself without requiring payload alterations (e.g., Perplexity with the `sonar` family, or specific OpenRouter variants configured externally).
* **Impact:** This is the solution with the lowest initial development effort, preserving the single HTTP client. However, it breaks the requirement of being a purely agnostic app by preventing the use of standard LLMs or local infrastructures.
```