# UI Flow and Architecture
The application is structured around a bottom navigation bar with three main tabs. This document describes the behavior and user interaction of each screen.

## Tab 1: Portfolio
*   **Purpose**: The entry point for the user to manually manage their portfolio.
*   **Behavior**: Users list their investments (ISINs), specifying `position` (shares), `purchasePrice`, `currency`, and the specific `Ticker`s related to that ISIN.
*   **Data Source**: Completely local (Reads and Writes from `Isar`). No external API fetching happens automatically here.

## Tab 2: Markets
*   **Purpose**: A dashboard presenting the live/recent market status of the user's portfolio.
*   **Behavior**: For each ISIN, displays its assigned Tickers. Shows the current session value, previous closing price (Level 1 Data), and a miniature 1-day evolution chart (Level 2 Intraday Data).
*   **Flow**: Tapping a Ticker row navigates to the **Detail Screen**.
*   **Data Strategy**: heavily relies on cached Level 1 and Level 2 data in `Isar` (`MarketDataCache`).

### Ticker Detail Screen
*   **Purpose**: In-depth view.
*   **Behavior**: Allows the user to select time ranges (1D, 1W, 1M, 3M, 6M, 1Y) and view detailed historical charts (Level 3 Data).
*   **Data Strategy**: Fetched on-demand from Yahoo Finance API. Not heavily cached locally.

## Tab 3: Insights
*   **Purpose**: The AI hub.
*   **Behavior**: Uses BYOK integration (OpenAI/OpenRouter) to provide summaries, news analysis, or sentiment regarding the user's portfolio.
