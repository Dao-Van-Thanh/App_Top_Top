import 'package:app/Provider/edit_item_profile_provider.dart';
import 'package:app/Services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditItemProfile extends StatefulWidget {
  const EditItemProfile({super.key});

  @override
  State<EditItemProfile> createState() => _MyEditItemProfileState();
}

class _MyEditItemProfileState extends State<EditItemProfile> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditItemProfileProvider>(context);
    final editProfileProvider = Provider.of<EditItemProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          provider.getLabel.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Hủy',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              UserService().editDataUser(provider.getLabel.toString(),
                  provider.getTextController.text);
              editProfileProvider.updateProfileData(
                  provider.getLabel.toString(),
                  provider.getTextController.text);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Lưu',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              maxLines: provider.getMaxLine,
              onChanged: (text) {
                provider.updateCountText(text);
              },
              controller: provider.getTextController,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung',
                suffixIcon: IconButton(
                  onPressed: () {
                    // Xử lý khi nhấn nút x để xóa nội dung
                  },
                  icon: const Icon(
                    Icons.cancel_sharp,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(provider.getMaxText)
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  provider.countText.toString(),
                  style: TextStyle(color: provider.colorText),
                ),
                Text('/' + provider.getMaxText.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
