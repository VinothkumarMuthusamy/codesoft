import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';  // Import the share package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: QuoteGenerator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuoteGenerator extends StatefulWidget {
  const QuoteGenerator({super.key});

  @override
  State<QuoteGenerator> createState() => _QuoteGeneratorState();
}

class _QuoteGeneratorState extends State<QuoteGenerator> {
  final String QuoteURL = "https://api.adviceslip.com/advice";
  String quote = 'Daily quotes';
  bool isFavorite = false;
  List<String> favoriteQuotes = [];
  Color generateButtonColor = Colors.lightBlueAccent;  // Default button color

  generateQuote() async {
    var res = await http.get(Uri.parse(QuoteURL));
    var result = jsonDecode(res.body);
    print(result["slip"]["advice"]);
    setState(() {
      quote = result["slip"]["advice"];
      isFavorite = favoriteQuotes.contains(quote); // Check if the new quote is already in favorites
      generateButtonColor = Colors.lightBlueAccent;  // Change button color when clicked
    });
  }

  void toggleFavorite() {
    setState(() {
      if (isFavorite) {
        favoriteQuotes.remove(quote);
      } else {
        favoriteQuotes.add(quote);
      }
      isFavorite = !isFavorite;
    });
  }

  void shareQuote() {
    Share.share(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Quote Generator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                quote,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: generateQuote,
              style: ElevatedButton.styleFrom(
                backgroundColor: generateButtonColor,  // Use the dynamic color
              ),
              child: Text('Generate Quote'),
            ),
            const SizedBox(height: 30),
            IconButton(
              iconSize: 58.0, // Increase the size of the favorite button
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: toggleFavorite,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: shareQuote,
                  child: Text('Share Quote'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoriteQuotesScreen(favoriteQuotes: favoriteQuotes),
                      ),
                    );
                  },
                  child: Text('View Favorites'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteQuotesScreen extends StatelessWidget {
  final List<String> favoriteQuotes;

  FavoriteQuotesScreen({required this.favoriteQuotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
          backgroundColor: Colors.lightBlueAccent,



        ),

      body: ListView.builder(
        itemCount: favoriteQuotes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteQuotes[index]),

          );
        },
      ),
    );
  }
}
