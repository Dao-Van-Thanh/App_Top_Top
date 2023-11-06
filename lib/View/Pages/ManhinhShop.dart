import 'package:flutter/material.dart';
class ManhinhShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tik Tok Shop"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi người dùng nhấn vào nút tìm kiếm
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // Màu nền của nút
                    ),
                    child: Text('Tìm kiếm'),
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_bag_outlined),
                      onPressed: () {},
                    ),
                    Text(
                      "Đơn hàng",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.message_outlined),
                      onPressed: () {},
                    ),
                    Text(
                      "Tin nhắn",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.credit_card_outlined),
                      onPressed: () {},
                    ),
                    Text(
                      "Voucher",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.location_on_outlined),
                      onPressed: () {},
                    ),
                    Text(
                      "Địa chỉ",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.monetization_on_outlined),
                      onPressed: () {},
                    ),
                    Text(
                      "Thanh toán",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.contact_support_outlined),
                      onPressed: () {},
                    ),
                    Text(
                      "Hỗ trợ",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Flash sale',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '23:01:06',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0), // Add spacing between rows
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network('https://www.vietnamfineart.com.vn/wp-content/uploads/2023/07/anh-girl-xinh-viet-nam.jpg'),
                        ),
                        subtitle: Container(
                          width: double.infinity,
                          height: 100.0,
                          child: Text("100.000 ")
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0), // Add spacing between ListTiles
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network('https://www.vietnamfineart.com.vn/wp-content/uploads/2023/07/anh-girl-xinh-viet-nam.jpg'),
                        ),
                        subtitle: Container(
                            width: double.infinity,
                            height: 100.0,
                            child: Text("100.000 ")
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0), // Add spacing between ListTiles
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network('https://www.vietnamfineart.com.vn/wp-content/uploads/2023/07/anh-girl-xinh-viet-nam.jpg'),
                        ),
                        subtitle: Container(
                            width: double.infinity,
                            height: 100.0,
                            child: Text("100.000 ")
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),


          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hàng hiệu giá hời',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '23:01:06',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0), // Add spacing between rows
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network('https://www.vietnamfineart.com.vn/wp-content/uploads/2023/07/anh-girl-xinh-viet-nam.jpg'),
                        ),
                        subtitle: Container(
                            width: double.infinity,
                            height: 100.0,
                            child: Text("100.000 ")
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0), // Add spacing between ListTiles
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network('https://www.vietnamfineart.com.vn/wp-content/uploads/2023/07/anh-girl-xinh-viet-nam.jpg'),
                        ),
                        subtitle: Container(
                            width: double.infinity,
                            height: 100.0,
                            child: Text("100.000 ")
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0), // Add spacing between ListTiles
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network('https://www.vietnamfineart.com.vn/wp-content/uploads/2023/07/anh-girl-xinh-viet-nam.jpg'),
                        ),
                        subtitle: Container(
                            width: double.infinity,
                            height: 100.0,
                            child: Text("100.000 ")
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
