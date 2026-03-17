import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final symbol = 'GOOGL';
  
  // 1. Current Price & Daily closing (1 day range, 1 day interval)
  await fetchAndSave(
    symbol, 
    '1d', 
    '1d', 
    'ai_context/yahoo_samples/quote_daily.json'
  );

  // 2. Intraday sparkline (1 day range, 5 minute interval)
  await fetchAndSave(
    symbol, 
    '1d', 
    '5m', 
    'ai_context/yahoo_samples/chart_intraday_1d.json'
  );

  // 3. Historical Data (6 months range, 1 day interval)
  await fetchAndSave(
    symbol, 
    '6mo', 
    '1d', 
    'ai_context/yahoo_samples/chart_historical_6mo.json'
  );
}

Future<void> fetchAndSave(String symbol, String range, String interval, String filename) async {
  final url = Uri.parse('https://query1.finance.yahoo.com/v8/finance/chart/$symbol?interval=$interval&range=$range');

  try {
    final client = HttpClient();
    final request = await client.getUrl(url);
    request.headers.set(HttpHeaders.userAgentHeader, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
    final response = await request.close();
    
    final responseBody = await response.transform(utf8.decoder).join();
    
    // Create directory if not exists
    final file = File(filename);
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    
    // Save formatted JSON
    if (responseBody.isNotEmpty) {
      final jsonResponse = jsonDecode(responseBody);
      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(jsonResponse));
      print('Saved: \$filename');
    }

  } catch (e) {
    print('Exception for \$filename: \$e');
  }
}
