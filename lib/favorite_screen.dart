// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quote_app/favorite_provider.dart';
import 'package:flutter_quote_app/quotes_model.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final myFavoriteItems =
        Provider.of<FavoriteProvider>(context).favoriteQuotes;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      drawer: Drawer(
        width: 220,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
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
              title: Text(
                'Home Screen',
                style: TextStyle(fontSize: 18),
              ),
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
              title: Text(
                'Favorite Screen',
                style: TextStyle(fontSize: 18),
              ),
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
        title: const Text('My Favorite Quotes'),
      ),
      body: myFavoriteItems.isEmpty
          ? Center(
              child: Text('No favorite quotes yet!'),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                itemCount: myFavoriteItems.length,
                itemBuilder: (context, index) {
                  // Quote quote = Quote.fromJson(jsonDecode(
                  //     myFavoriteItems[index] as String)); // Decode quote
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: Text(
                        myFavoriteItems[index].content,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          '~${myFavoriteItems[index].author}',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          favoriteProvider.removeFromFavorites(myFavoriteItems[
                              index]); // Remove from favorites on tap
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
