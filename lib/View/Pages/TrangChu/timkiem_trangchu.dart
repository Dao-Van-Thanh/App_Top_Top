import 'package:flutter/material.dart';

void main() => runApp(TikTokSearchApp());

class TikTokSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TikTokSearchScreen(),
    );
  }
}

class TikTokSearchScreen extends StatefulWidget {
  @override
  _TikTokSearchScreenState createState() => _TikTokSearchScreenState();
}

class _TikTokSearchScreenState extends State<TikTokSearchScreen> {
  List<String> searchResults = []; // Danh sách kết quả tìm kiếm
  TextEditingController searchController = TextEditingController();

  void search(String query) {
    // Viết mã tìm kiếm ở đây
    // Ví dụ: Gọi API, tìm trong cơ sở dữ liệu, ...
    // Dưới đây là ví dụ tìm kiếm đơn giản
    List<String> results = [
      'Result 1',
      'Result 2',
      'Result 3',
    ];

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm',
          ),
          onSubmitted: search,
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(searchResults[index]),
          );
        },
      ),
    );
  }
}