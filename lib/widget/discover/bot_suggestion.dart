class BotSuggestions {
  List<String> suggestions = [];

  BotSuggestions(List<dynamic> messages) {
    messages.forEach((message) {
      if (message['payload'] != null) {
        List<dynamic> suggestionList = message['payload']['suggestions'];
        suggestionList.forEach((suggestion) => suggestions.add(suggestion));
      }
    });
  }
}
