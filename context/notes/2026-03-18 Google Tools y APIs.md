# Google AI PRO Ecosystem and API Options: Limits and Architecture

## 1. Google AI PRO Subscription Tools
The limits for these tools operate under an isolation principle: consumption in one does not affect the quota of the others (except for CLI and Code Assist).

### Gemini Advanced (Chatbot)
* **Scope:** Web and mobile conversational interface for general use, reasoning, and multimedia generation.
* **Limits:** * Flash Model: 300 prompts/day.
    * Pro Model (3.1 Pro): 100 prompts/day.
    * Thinking Model: 90 prompts/day.
    * Generation: 100 images/day, 3 videos/day (Veo), 20 Deep Research reports/day.
* **Cooldown:** Daily reset (generally at midnight PST). Limits per model are independent.

### Google Antigravity (Agentic IDE)
* **Scope:** Interactive development environment for massive code generation and agent-based planning.
* **Limits:** Measured by dynamic token expenditure ("Work Performed").
* **Cooldown:** * *Sprint:* 5-hour continuous burst limit. Once exhausted, requires waiting 5 hours from the start of the session.
    * *Marathon:* Weekly token limit. Exceeding it blocks premium models for 1 to 7 days (Monthly 1,000 AI Credits can be used as a rescue).

### Google Jules (Asynchronous Agent)
* **Scope:** Background execution connected to repositories (e.g., GitHub) to resolve issues, refactor, or review PRs autonomously using Gemini 3.1 Pro.
* **Limits:** 100 tasks/day, with a maximum of 15 concurrent executions.
* **Cooldown:** Strict 24-hour rolling window for each task started.

### Gemini CLI and Code Assist
* **Scope:** Autocompletion in local editors (VS Code, IntelliJ) and terminal commands.
* **Limits:** 120 Requests Per Minute (RPM) and 1,500 Requests Per Day (RPD).
* **Cooldown:** The short-term limit resets every 60 seconds; the daily limit resets at local midnight. These two tools **do share** their quota with each other.

---

## 2. API Token Options for Custom Projects (BYOT)
The Google AI PRO subscription is a closed environment and **does not provide API keys** for integration into third-party applications (BYOT). For this use case, tokens must be generated through independent channels, and their quotas do not affect or consume the PRO plan limits.

### Google AI Studio
* **Scope:** Personal projects, quick testing, and prototyping.
* **Limits/Cost:** Allows generating a free API Key. It is subject to strict technical limits on requests per minute and per day (Free Tier), managed separately from other accounts.

### Google Cloud (Vertex AI)
* **Scope:** Enterprise-grade integrations, application scaling, and production deployments.
* **Limits/Cost:** Requires cloud project configuration and a credit card (Pay-as-you-go). It does not have artificial quota limits like the consumer environment; billing is directly based on the volume of processed input and output tokens.
* **OAuth:** It does not use Tokens, but OAuth, a different login system. 