import 'package:app/Provider/profile_provider.dart';
import 'package:app/Services/admin_service.dart';
import 'package:app/View/Widget/sreach_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabAdmin extends StatelessWidget {
  const TabAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider =
    Provider.of<ProfileProvider>(context, listen: false);
    final controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Xử lý khi người dùng nhấn vào nút
            },
            icon: Icon(Icons.notifications), // Chọn một biểu tượng thích hợp
            tooltip: "Thông báo", // Mô tả khi di chuột vào biểu tượng
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(flex:0,child: searchWidget(profileProvider: profileProvider, controller: controller)),
          Expanded(
            flex: 1,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center();
                  }else if(snapshot.hasError){
                    return Text("Error: ${snapshot.error}");
                  }else{
                  final docs = snapshot.data!.docs;
                  return ChangeNotifierProvider<ProfileProvider>(
                    create: (context) => ProfileProvider(),
                        child: ListView.builder (
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data();
                            return UserCard(data,index);
                          },
                        ),
                  );

                  }
                },
            ),
          ),
        ],
      )
    );
  }
  Widget UserCard(Map<String,dynamic> data,int index){

    return Container(

      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: NetworkImage(data['avatarURL']),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['fullname']),
                    SizedBox(height: 10),
                    Text(data['email']),
                  ],
                ),
              ),
              Consumer<ProfileProvider>(
                builder: (context, provier, child) {
                  Color buttonColor = data['ban'] == true ? Color(0x61ABA8A8) : Color(0x61EF307A);
                  String buttonText = data['ban'] == true ? 'UnBan' : 'Ban';
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(buttonColor),
                    minimumSize: MaterialStateProperty.all(Size(60, 40)), // Đặt kích thước tối thiểu (rộng x cao)
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)), // Đặt padding (khoảng cách xung quanh văn bản)
                  ),
                  onPressed: () async{
                    provier.banUser();
                    await AdminService().banUser(data['uid'], provier.ban);
                  },
                  child: Text(buttonText),
                );
                },
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0x6130D9EF)),
                  minimumSize: MaterialStateProperty.all(Size(60, 40)), // Đặt kích thước tối thiểu (rộng x cao)
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)), // Đặt padding (khoảng cách xung quanh văn bản)
                ),
                onPressed: () {
                  print(data['uid']);
                },
                child: Text("Chi tiết"),
              ),
            ],
          ),
        ],
      ),
    );

  }

}
