# Documento de Arquitectura y Concepto: Pocket ISINs

**Nombre de la aplicación:** “Pocket ISINs”

---

## 1. Concepto Funcional de la Aplicación
* **Objetivo:** App híbrida (móvil/PC) para el seguimiento de una cartera de inversión basada en ISINs, combinando la extracción de precios de mercado con agentes de IA para el análisis de noticias.
* **Flujo principal:** El usuario introduce los ISINs de sus activos y su posición (cantidad invertida). La app categoriza los activos, calcula el valor total, muestra el peso relativo en la cartera y renderiza gráficas de evolución. En paralelo, busca noticias sobre esos activos y usa IA para resumir su contenido y analizar el sentimiento o impacto de mercado.

## 2. Arquitectura de Software y Ecosistema
* **Framework:** Flutter (Dart). Todo el desarrollo se concentra en el cliente.
* **Paradigma:** 100% Local (Client-Side). No existe un backend propio ni servidor en la nube. Toda la lógica de orquestación reside en la aplicación.
* **Gestión de Estado:** Riverpod. Encargado de separar la capa de datos de la interfaz visual y manejar la reactividad.
* **Persistencia de Datos:**
    * Base de datos local (SQLite o Isar) para almacenar la cartera (ISINs, relaciones con Tickers, transacciones, caché de noticias).
    * Capa de almacenamiento seguro (`flutter_secure_storage`) para encriptar en el dispositivo las API Keys del usuario.

## 3. Integración de Inteligencia Artificial (Enfoque BYOK)
* **Modelo "Bring Your Own Key":** La app es agnóstica al proveedor. El usuario configura sus propias credenciales en los ajustes locales de la app.
* **Conector Universal:** Se programará un único cliente HTTP basado en el estándar de la API de OpenAI (`/v1/chat/completions`). Compatible con OpenAI, OpenRouter, modelos locales (Ollama) y Google Gemini (vía endpoint OpenAI).
* **Variables de configuración:** Base URL, API Key y Model Name.

## 4. Extracción de Datos Financieros (Market Data)
* **Modelo de Datos (ISIN -> Tickers):** Relación 1 a N. Un único activo (ISIN) puede rastrearse en múltiples mercados simultáneamente a través de distintos Tickers (ej. AAPL en NASDAQ/USD y APC.DE en Xetra/EUR).
* **Proveedor:** API pública de Yahoo Finance.
* **Optimización de Red:** Peticiones HTTP en bloque (múltiples símbolos por llamada).
* **Visualización Multimercado:** Interfaz con tabs para alternar entre las diferentes cotizaciones de un mismo activo.
