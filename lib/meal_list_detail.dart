import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class MealListDetail extends StatefulWidget {
  final String mealId;
  final String mealTitle;

  const MealListDetail({
    Key? key,
    required this.mealId,
    required this.mealTitle,
  }) : super(key: key);

  @override
  _MealListDetailState createState() => _MealListDetailState();
}

class _MealListDetailState extends State<MealListDetail> {
  Map<String, dynamic>? mealDetails;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'));
    if (response.statusCode == 200) {
      setState(() {
        mealDetails = jsonDecode(response.body)['meals'][0];
      });
    } else {
      // Handle error
      print('Failed to load meal details');
    }
  }

  void launchYouTubeUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Failed to launch URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          widget.mealTitle,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: mealDetails != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(16.0),
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 3.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        mealDetails!['strMealThumb'],
                        height: 200.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Category: ${mealDetails!['strCategory']}',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Instructions:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      mealDetails!['strInstructions'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 1.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        launchYouTubeUrl(mealDetails!['strYoutube']);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text('Lihat di Youtube'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
