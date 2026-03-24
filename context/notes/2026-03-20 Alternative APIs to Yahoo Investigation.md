# Research Summary: Alternatives to Yahoo Finance for European Market Data (Trade Republic)

## 1. Context and Initial Intent
The goal of the project is to track an investment portfolio based on Trade Republic (TR) by extracting reliable stock market data. TR routes its trades through the market maker **Lang & Schwarz Exchange (LSX)**. 

Currently, the public Yahoo Finance API is being used, which has several critical flaws for this use case:
* **Lack of LSX coverage:** Yahoo does not provide Lang & Schwarz data.
* **Schedule/Timezone mismatch:** Forces the use of Xetra (`.DE`) tickers as a workaround. Xetra operates from 09:00 to 17:30 CET, while TR/LSX operates from 07:30 to 23:00 CET. Outside Xetra's trading hours, Yahoo only returns frozen/stale prices.
* **Symbology Problem (Tickers vs. ISINs):** Yahoo relies on exchange-specific tickers, while the portfolio uses ISINs. For many European ISINs (especially ETFs), Yahoo returns very poor, fragmented, or completely non-existent intraday data.

## 2. The Tradegate (XGAT) Alternative
Given the opacity of LSX data, using **Tradegate (XGAT)** as a "twin" market was evaluated. Tradegate is a retail-focused exchange in Germany with a schedule almost identical to TR (08:00 to 22:00 CET), making its prices and spreads practically a carbon copy of what the Trade Republic app shows. However, data providers gatekeep Tradegate just as fiercely as they do LSX.

## 3. Evaluated Options and Reasons for Rejection
Various REST APIs and services were investigated to obtain LSX/XGAT data or better ISIN resolution, but none meet the requirements of a free, robust side project:

* **EODHD (EOD Historical Data):**
  * *Pros:* Excellent support for European ISINs and ETFs (via the EUFUND virtual index). 
  * *Why it's rejected:* The free tier is useless (20 calls/day). A viable plan costs ~$20/month.
* **Financial Modeling Prep (FMP):**
  * *Pros:* Exceptional endpoint for translating ISINs to Tickers.
  * *Why it's rejected:* The free plan (250 requests/day) blocks real-time telemetry for European markets (it is heavily US-centric).
* **Leeway.tech:**
  * *Pros:* Natively and flawlessly supports Tradegate.
  * *Why it's rejected:* Absurdly low free limit (50 calls/day), making it unfeasible for real-time portfolio tracking.
* **Twelve Data and Finnhub:**
  * *Why they are rejected:* They hide retail markets (Tradegate) and ISIN searches behind paywalls or require expensive premium data add-ons.
* **Lemon.markets / Trade Republic Wrappers (`pytr`):**
  * *Pros:* Direct access to the broker's backend and 100% real LSX prices.
  * *Why they are rejected:* Lemon.markets lacks historical depth. Unofficial TR wrappers force logouts on the user's mobile app (strict single-device limitation) and require storing the account PIN in plain text, posing a high security risk.

## 4. Technical Curiosity: Web Scraping with `pytradegate`
As an alternative to paid API ecosystems, there is the brute-force approach via web scraping. Python libraries like `pytradegate` allow you to query an ISIN by simulating a web browser and extracting the real-time price directly from the HTML code of Tradegate's public webpage. 
* *Conclusion:* Discarded for now due to its fragility. Any minor change in Tradegate's frontend design would break the integration, requiring constant code maintenance.

## 5. Final Conclusion
For a zero-cost personal project, the current financial data ecosystem does not offer a direct, plug-and-play solution for European retail markets (LSX/Tradegate). The most pragmatic decision is to **stick with Yahoo Finance**, map the ISINs to Xetra (or other European exchanges) tickers, and accept the limitations of price lagging outside institutional trading hours and poor intraday granularity.