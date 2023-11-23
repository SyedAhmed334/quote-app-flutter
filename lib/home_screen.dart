// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quote_app/favorite_provider.dart';
import 'package:flutter_quote_app/quotes_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Quote> _futureQuote;
  Future<Quote> getQuotes() async {
    var response =
        await http.get(Uri.parse("https://api.quotable.io/quotes/random"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return Quote.fromJson(data[0]);
    } else {
      throw Exception('No data found');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureQuote = getQuotes();
  }

  @override
  Widget build(BuildContext context) {
    final favorite = Provider.of<FavoriteProvider>(context, listen: false);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Daily Quotes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home Screen'),
              onTap: () {
                // Perform action when Item 1 is tapped
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen())); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Favorite Screen'),
              onTap: () {
                // Perform action when Item 2 is tapped
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FavoriteScreen())); // Close the drawer
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Quote App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {});
                _futureQuote = getQuotes();
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                    ),
                    Text(
                      'Change Quote',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
                future: _futureQuote,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.hasData) {
                    Quote quote = snapshot.data as Quote;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.pink,
                                  Colors.purple
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  quote.content,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16), // Add some spacing
                                Text(
                                  '~${quote.author}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {
                                        setState(() {
                                          Share.share(
                                              '${quote.content} \n- ${quote.author}');
                                        });
                                      },
                                    ),
                                    Text("Share"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Consumer<FavoriteProvider>(
                                        builder: (context, value, child) {
                                      return IconButton(
                                        onPressed: () {
                                          print(favorite.favoriteQuotes);
                                          bool isFavoriteInQuotes = favorite
                                              .favoriteQuotes
                                              .contains(quote);
                                          if (isFavoriteInQuotes) {
                                            favorite.removeFromFavorites(quote);
                                          } else if (!isFavoriteInQuotes) {
                                            favorite.addToFavorites(quote);
                                          }
                                        },
                                        icon: favorite.favoriteQuotes
                                                .contains(quote)
                                            ? Icon(Icons.favorite)
                                            : Icon(Icons.favorite_border),
                                      );
                                    }),
                                    Text('Favorite'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text('No Data Found');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
