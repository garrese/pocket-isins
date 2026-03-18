import 'dart:io';
import 'dart:convert';

void main() async {
  final symbols = ['NRGT', 'NRGT.L', 'NRGT.MI', 'WENT.DE', 'WENT.L'];
  
  for (final symbol in symbols) {
    final url = Uri.parse('https://query1.finance.yahoo.com/v8/finance/chart/$symbol?interval=1d&range=1d');
    try {
      final client = HttpClient();
      final request = await client.getUrl(url);
      request.headers.set(HttpHeaders.userAgentHeader, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
      final response = await request.close();
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final json = jsonDecode(body);
        if (json['chart']['result'] != null) {
          print('[OK] $symbol works');
        } else {
          print('[FAIL] $symbol exists but no data');
        }
      } else {
        print('[404] $symbol not found');
      }
    } catch (e) {
      print('Error $symbol: $e');
    }
  }
}
