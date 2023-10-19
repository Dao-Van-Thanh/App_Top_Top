import 'package:app/Model/video_model.dart';
import 'package:app/Services/search_service.dart';
import 'package:app/View/Pages/TrangChu/trang_chu.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../Widget/bottom_navigation.dart';
import '../Others/man_hinh_video_search.dart';

class ManHinhTimKiem extends StatefulWidget {
  const ManHinhTimKiem({Key? key}) : super(key: key);

  @override
  State<ManHinhTimKiem> createState() => _ManHinhTimKiemState();
}

class _ManHinhTimKiemState extends State<ManHinhTimKiem> {
  TextEditingController textInputSearch = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> captions = [];
  List<String> historySearchs = [
    'Thuy ngo 2',
    'Thuy ngo 3',
    'Thuy ngo 4',
  ];
  List<String> recomments = [];
  bool isSearching = false;
  String textSearch = '';
  @override
  void initState() {
    super.initState();
    loadCaptions(); // Gọi hàm để tải captions
  }

  Future<void> loadCaptions() async {
    final fetchedCaptions = await SearchService().fetchCaptionsFromVideos();
    setState(() {
      captions = fetchedCaptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5.0),
              ),
              width: 270,
              height: 35,
              child: TextField(
                cursorColor: Colors.pinkAccent,
                controller: textInputSearch,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm theo tên',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onTap: () {
                  textSearch = textInputSearch.text;
                },
                onChanged: (text) {
                  setState(() {
                    isSearching =
                        textInputSearch.text.length == 0 ? false : true;
                    if (text.length != 0) {
                      textSearch = '';
                      recomments = captions
                          .where((caption) => caption
                              .toLowerCase()
                              .contains(textInputSearch.text.toLowerCase()))
                          .toList();
                      Set<String> uniqueSet = recomments.toSet();
                      recomments = uniqueSet.toList();
                    }
                  });
                },
              )),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Bottom_Navigation_Bar()));
              }),
          leadingWidth: 20,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text('Tìm kiếm',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        body: textSearch.length <= 0
            ? ListView.builder(
                itemCount:
                    isSearching ? recomments.length : historySearchs.length,
                itemBuilder: (BuildContext context, int index) {
                  final item =
                      isSearching ? recomments[index] : historySearchs[index];
                  return InkWell(
                    onTap: () {
                      print('Item $item được nhấn');
                      _focusNode.unfocus();
                      setState(() {
                        textInputSearch.text = item;
                        textSearch = item;
                      });
                    },
                    child: ListTile(
                      title: Text(item),
                    ),
                  );
                },
              )
            : Padding(
              padding: EdgeInsets.all(8.0),
              child: StreamBuilder<List<VideoModel>>(
                  stream:
                      SearchService().getVideosByCaption(textSearch.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing:5,
                              mainAxisExtent: 328.0,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final videoData = snapshot.data?[index];
                          Stream<List<VideoModel>> videoStream = Stream.fromIterable([snapshot.data!]);
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ManhinhVideoSearch(videoStream: videoStream);
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                color: Colors.black,
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 300.0, // Giới hạn chiều cao của Chewie
                                          child: Chewie(
                                            controller: ChewieController(
                                              videoPlayerController: VideoPlayerController.network(
                                                videoData!.videoUrl,
                                              ),
                                              autoPlay: false,
                                              looping: true,
                                              allowMuting: true,
                                              showControls: false,
                                              showOptions: false,
                                              aspectRatio: 0.8,
                                              autoInitialize: true,
                                              errorBuilder: (context, errorMessage) {
                                                return Center(
                                                  child: Text('Lỗi: $errorMessage'),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        if (videoData!.videoUrl == null)
                                          Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      videoData!.caption,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                        },
                      );
                    }
                  },
                ),
            ));
  }
}
