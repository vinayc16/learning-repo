import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CounterProvider extends ChangeNotifier {
  int _count = 0;
  List<dynamic> _posts = [];
  bool _isLoading = false;

  int get count => _count;
  List<dynamic> get posts => _posts;
  bool get isLoading => _isLoading;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    final url = 'https://jsonplaceholder.typicode.com/posts';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      _posts = jsonDecode(response.body);
      print(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }

    _isLoading = false;
    notifyListeners();
  }
}
