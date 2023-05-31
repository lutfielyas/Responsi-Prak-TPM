import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'meal_list_detail.dart';

class MealList extends StatefulWidget {
  final String category;

  const MealList({Key? key, required this.category}) : super(key: key);

  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  List<dynamic> meals = [];

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'));
    if (response.statusCode == 200) {
      setState(() {
        meals = jsonDecode(response.body)['meals'];
      });
    } else {
      // Handle error
      print('Failed to load meals');
    }
  }

  void navigateToMealDetail(String mealId, String mealTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealListDetail(
          mealId: mealId,
          mealTitle: mealTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.green,
        title: Text(
          '${widget.category} Meals',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                navigateToMealDetail(meal['idMeal'], meal['strMeal']);
              },
              child: Card(
                elevation: 3.0,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        bottomLeft: Radius.circular(4.0),
                      ),
                      child: Image.network(
                        meal['strMealThumb'],
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          meal['strMeal'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
