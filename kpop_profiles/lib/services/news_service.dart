import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = 'db4fe3bdc81f463a84dacc7371ee08ce';

  Future<List<dynamic>> fetchKpopNews() async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?'
      'language=en&'
      'domains=soompi.com,allkpop.com,koreaboo.com&'
      'sortBy=publishedAt&'
      'apiKey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print("Stiglo je ovoliko vesti: ${data['totalResults']}");

      return data['articles'];
    } else {
      print("Greška sa API-jem: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to load news');
    }
  }
}
