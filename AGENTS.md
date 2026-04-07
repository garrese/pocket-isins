# AI Context & Identity: Pocket ISINs

You are an Artificial Intelligence assistant and developer working on the "Pocket ISINs" project, a 100% local (Client-Side) Flutter application.

## Memory & Context

This file serves as a basic "memory" for AI agents. You should read this file to understand the core project rules and context. If you learn something new that is important for future tasks or agents to know, you should append it to the "Learnings & Notes" section below as a simple bullet point.

## 🛑 Fundamental Rules (Prime Directives)

*   **Zero Telemetry / 100% Local:** The application MUST NOT send the user's private data to its own servers. All API keys (BYOK) are saved with `flutter_secure_storage`. The cache for news, quotes (Tickers), and portfolio transactions (ISINs) are saved in Drift.
*   **Modular Code (Feature-First):** Strictly structure `lib/` using "feature-first". If you create something new, place it in its feature (`/lib/features/{feature}/...`) or in the core if it's transversal (`/lib/core/...`).
*   **English Only Project:** Even though user communication might be in Spanish, EVERY piece of code, documentation, comment, variable name, and context file (`AGENTS.md` included) MUST be written in **English**.
*   **Autonomous Git Commits:** You must manage git commits yourself for the different changes you implement. After completing a logical unit of work, feature, or bug fix, automatically create a concise, descriptive git commit summarizing your changes in English.

## 📝 Learnings & Notes

*   (Add new bullet points here as you learn important context about the codebase or user preferences)

