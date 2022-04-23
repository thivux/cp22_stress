import 'package:cp22_health_app/nsdr_player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: NSDRList(),
  ));
}

class NSDRList extends StatelessWidget {
  final List<String> items = ['Tiếng Anh, giọng nam, 20\'', 'Tiếng Việt, giọng nữ, 20\''];
  final List<String> fileNames = ['nsdr_eng_male_23min.mp3', 'nsdr_adjusted_2.mp3'];
  final List<String> imgs = ['forest.jpg', 'ocean.jpg'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Text('Non-Sleep Deep Rest',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                   onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NSDR(fileName: fileNames[index])),
                    );},
                    child: Container(
                      margin: EdgeInsets.all(20),
                      height: 150,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset('assets/' + imgs[index],
                              fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              // color: Colors.blue,    // uncomment to see the shape of container
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 19),
                                child: Text(
                                    items[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createDialog(context);
        },
        child: const Text('?'),
      ),
    );
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              width: 300,
              height: 350,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    '- Lắng nghe và làm theo chỉ dẫn trong đoạn ghi âm \n\n- Tác dụng: giúp bạn thư giãn nhanh và sâu, dễ dàng chìm vào giấc ngủ hoặc ngủ trở lại nếu thức dậy giữa chừng lúc nửa đêm, có thể dùng để thay thế giấc ngủ đã mất\n',
                    // '- Nguồn khoa học nghiên cứu (trích): published by Front Psychiatry (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6361823/)',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
