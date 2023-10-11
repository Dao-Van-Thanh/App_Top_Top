import 'package:app/Provider/dang_ky_email_provider.dart';
import 'package:app/Provider/gui_data_provider.dart';
import 'package:app/View/Screen/DangKy/man_hinh_dang_ky_createPass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManHinhDangKyEmail extends StatefulWidget {
  const ManHinhDangKyEmail({Key? key}) : super(key: key);

  @override
  State<ManHinhDangKyEmail> createState() => _MyManHinhDangKyEmailState();
}

class _MyManHinhDangKyEmailState extends State<ManHinhDangKyEmail> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DangKyEmailProvider>(context);
    final myData = Provider.of<MyData>(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              TextField(
                controller: provider.emailController,
                onChanged: (text) {
                  setState(() {
                    provider.updateButtonStatus(text.isNotEmpty);
                    provider.isClearButtonVisible = text.isNotEmpty;
                    if (provider.isButtonEnabled) {
                      provider.emailErrorText = null;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Địa chỉ email',
                  errorText: provider.emailErrorText,
                  suffixIcon: provider.isClearButtonVisible
                      ? GestureDetector(
                          onTap: () {
                            provider.emailController.clear();
                            provider.isClearButtonVisible = false;
                          },
                          child: Icon(Icons.close),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: provider.isButtonEnabled
                    ? () {
                        setState(() {
                          provider.emailErrorText = provider.validateEmail()
                              ? null
                              : 'Nhập địa chỉ email hợp lệ';
                        });
                        if (provider.emailErrorText == null) {
                          myData.updateEmail(provider.emailController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePassSingup(
                                  data: provider.emailController),
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  backgroundColor: provider.isButtonEnabled
                      ? Colors.red
                      : const Color.fromARGB(255, 219, 219, 219),
                  minimumSize: const Size(500, 50),
                ),
                child: const Text(
                  'Tiếp',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
