class ApiConstants {
  static const String baseUrl = 'https://newsapi.org';
  static const String apiKey = '4ff31187fed84422a239d644f8b20f7a';
  static const String everytingEndpoint = '/v2/everything';
  static const String topHeadlineEndpoint = '/v2/top-headlines';
  static const String sourceEndpoint = '/v2/top-headlines/sources';

  static const Map<String, String> defaultParams = {
    'country': 'us',
    'pageSize': '20',
  };

  static Map<String, String> get headers {
    return {'X-Api-Key': apiKey, 'Content-Type': 'application/json'};
  }

  static Map<String, String> get authHeader {
    return {'Authorization': apiKey, 'Content-Type': 'application/json'};
  }
}
