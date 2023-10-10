import 'package:app/Provider/dang_nhap_sdt_provider.dart';
import 'package:app/View/Screen/DangNhap/man_hinh_otp.dart';
import 'package:app/View/Widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

class ManHinhDangNhapSDT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<DangNhapSdtProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            Container(
              height: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    PhoneFormField(
                      defaultCountry: IsoCode.VN,
                      // default
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                        hintText: 'Số điện thoại',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black), // Màu đường viền khi focus
                        ),
                      ),
                      validator: PhoneValidator.compose([
                        PhoneValidator.valid(errorText: "Không đúng định dạng"),
                        PhoneValidator.required(
                            errorText: "Không được để trống"),
                      ]),
                      countrySelectorNavigator:
                          CountrySelectorNavigator.draggableBottomSheet(),
                      onChanged: (p) {
                        provider.changePhone(p!.nsn.toString());
                        print(
                            'Số điện thoại đã thay đổi thành: ${provider.phone}');
                      }, // default null
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            provider.changeChecked(!provider.isChecked);
                          },
                          child: Container(
                            width: 18,
                            // Điều chỉnh kích thước của hình tròn
                            height: 18,
                            // Điều chỉnh kích thước của hình tròn
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Để tạo hình tròn
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 2 // Màu đường viền khi không được chọn
                                  ),
                              color: provider.isChecked
                                  ? Colors.grey
                                  : Colors.transparent, // Màu nền khi được chọn
                            ),
                            child: provider.isChecked
                                ? Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors
                                        .white, // Màu của biểu tượng kiểm tra khi được chọn
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Lưu thông tin đăng nhập',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  provider.phone.length < 1
                                      ? Colors.black12
                                      : Colors.pinkAccent)),
                          onPressed: provider.phone.length < 1
                              ? null
                              : () {
                                  provider.dangNhapPhone(context);
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => ManHinhOTP())
                                  // );
                                },
                          child: const Text(
                            'Gửi mã',
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: provider.isPhoneNumberCheck,
                      // Ẩn hoặc hiển thị dựa trên giá trị của isTextVisible
                      child: const Text(
                        'Lỗi. Thử lại !',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            LoadingWidget(isLoading: provider.isLoading),
          ],
        );
      },
    ));
  }
}
