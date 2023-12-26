import 'dart:io';

import 'package:app/Provider/quay_video_provider.dart';
import 'package:app/Services/dang_video_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart'; // Import thư viện video_player

class ManHinhDangVideo extends StatefulWidget {
  final XFile xflie;
  final String musicChoose;
  const ManHinhDangVideo(this.xflie, this.musicChoose, {super.key});

  @override
  _ManHinhDangVideoState createState() => _ManHinhDangVideoState();
}

class _ManHinhDangVideoState extends State<ManHinhDangVideo> {
  late VideoPlayerController _videoController;
  TextEditingController controller = TextEditingController();
  bool isUploading = false;
  bool blockComments = false;


  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(widget.xflie.path))
      ..initialize().then((_) {
        // Đảm bảo rằng video đã sẵn sàng để phát khi khởi tạo
          setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuayVideoProvider>(
      builder: (context, provider, _) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,color: Colors.black),
              ),
              title: const Text(
                'Đăng',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: TextField(
                              controller: controller,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: const InputDecoration(
                                hintText: 'Viết nội dung video của bạn ở đây',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            padding: const EdgeInsets.all(13),
                            child: AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                    ),
                    const Row(
                      children: [
                        // Biểu tượng "person"
                        Icon(
                          Icons.person_outline,
                          size: 30.0,
                        ),
                        SizedBox(width: 10.0), // Khoảng cách giữa biểu tượng và văn bản
                        // Dòng văn bản "Gắn thẻ mọi người"
                        Text(
                          'Gắn thẻ mọi người',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigate_next_sharp, // Thay thế bằng biểu tượng mong muốn
                        ),
                      ],
                    ),
                    const SizedBox(height: 13.0,),
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 30
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          'Vị trí',
                          style:TextStyle(fontSize: 20.0),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigate_next_sharp, // Thay thế bằng biểu tượng mong muốn
                        ),
                      ],
                    ),
                    const SizedBox(height: 13.0,),
                    const Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 30,
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          'Thêm liên kết',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigate_next
                        )
                      ],
                    ),
                    const SizedBox(height: 13.0,),
                    Row(
                      children: [
                        const Icon(
                          Icons.comment_bank_outlined,
                          size: 30,
                        ),
                        const SizedBox(width: 10.0,),
                        const Text(
                          'Cho phép bình luận ',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        const Spacer(),
                        Switch(
                          value: provider.isChecked, // Giá trị bật/tắt (có thể thay đổi tùy thuộc vào trạng thái thực tế)
                          onChanged: (value) {
                            provider.setChecked();
                            blockComments = !value;
                          },
                        ),

                      ],
                    ),
                    const SizedBox(height: 13.0,),
                    const Row(
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 30,
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          'Ai cũng có thể xem bài đăng này',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Spacer(),
                        Icon(
                            Icons.navigate_next
                        )
                      ],
                    ),
                    const SizedBox(height: 13.0,),
                    const Row(
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 30,
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          'Lưu vào thiết bị',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Spacer(),
                        Icon(
                            Icons.navigate_next
                        )
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                                ),
                                child: const Text('Quay lại'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Đánh dấu đang tải lên và cập nhật giao diện
                                  setState(() {
                                    isUploading = true;
                                  });

                                  DangVideoService service = DangVideoService();
                                  bool check =
                                  await service.dangVideo(controller.text,blockComments, widget.xflie,widget.musicChoose);
                                  if (check) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Đăng video thành công.'),

                                      ),
                                    );
                                    // ignore: use_build_context_synchronously
                                    if(!context.mounted) return;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    if(!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Đăng video thất bại.'),
                                      ),
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }

                                  // Đánh dấu xong tải lên và cập nhật giao diện
                                  setState(() {
                                    isUploading = false;
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.pinkAccent),
                                ),
                                child: const Text('Đăng'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Hiển thị tiện ích hàng chờ nếu đang tải lên
                if (isUploading)
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
