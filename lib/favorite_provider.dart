import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quote_app/quotes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Quote> _favoriteQuotes = [];
  List<Quote> get favoriteQuotes => _favoriteQuotes;

  // Add a quote to favorites
  void addToFavorites(Quote quote) {
    _favoriteQuotes.add(quote);
    saveFavorites();
    notifyListeners();
  }

  // Remove a quote from favorites
  void removeFromFavorites(Quote quote) {
    _favoriteQuotes.remove(quote);
    saveFavorites();
    notifyListeners();
  }

  // Load favorite quotes from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites');

    if (favoritesJson != null) {
      _favoriteQuotes = favoritesJson
          .map((json) => Quote.fromJson(jsonDecode(json)))
          .toList();
      notifyListeners();
    }
  }

  // Save favorite quotes to SharedPreferences
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson =
        _favoriteQuotes.map((quote) => jsonEncode(quote.toJson())).toList();
    prefs.setStringList('favorites', favoritesJson);
  }
}
