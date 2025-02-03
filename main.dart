import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Initialize Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDTAcuHj4UwE2T-P1hrkrQcgKbYTktXbvs",
      appId: "1:195903514898:web:c8935dc9448d56cca72bcb",
      messagingSenderId: "195903514898",
      projectId: "myapp1-a3d13",
      authDomain: "myapp1-a3d13.firebaseapp.com",
      storageBucket: "myapp1-a3d13.appspot.com",
      measurementId: "G-WVEJG53S7C",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FoodListScreen(),
    );
  }
}

class FoodListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff47D125),
        leading: Image.asset(
          'assets/logo.png',
          height: 50,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/background1.png', // Replace with your desired image
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
            FirebaseFirestore.instance.collection('afternoon').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No items found'));
              }

              final afternoon =
              snapshot.data!.docs.map((doc) => doc.data()).toList();
              return PageView.builder(
                itemCount: afternoon.length,
                controller: PageController(viewportFraction: 1.0),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final item = afternoon[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: FoodCard(
                      name: item['name'],
                      price: item['price'].toDouble(),
                      rating: item['rating'].toDouble(),
                      category: item['category'],
                      dish: item['dish'],
                      seller: item['seller'],
                      imageUrl: item['imageUrl'],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String name;
  final double price;
  final double rating;
  final String dish;
  final String category;
  final String seller;
  final String imageUrl;

  const FoodCard({
    Key? key,
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    required this.dish,
    required this.seller,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrl.startsWith('http')
              ? Image.network(
            imageUrl,
            height: 300,
            width: 350,
            fit: BoxFit.cover,
          )
              : Center(
            child: Image.asset(
              imageUrl,
              height: 300,
              width: 350,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    name,
                    style: GoogleFonts.kavoon(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹$price',
                      style: TextStyle(fontSize: 20, color: Color(0xff0f0e0e)),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.green, size: 20),
                        Text(
                          '$rating',
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  '| Dish: $dish',
                  style: GoogleFonts.blinker(
                    fontSize: 18,
                    color: Color(0xff111010),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '| Category: $category',
                  style: GoogleFonts.blinker(
                    fontSize: 18,
                    color: Color(0xff060606),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '| Seller: $seller',
                  style: GoogleFonts.blinker(
                    fontSize: 18,
                    color: Color(0xff030303),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff434597),
                    ),
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
