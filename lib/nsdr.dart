import 'package:cp22_health_app/nsdr_player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: NSDRList(),
  ));
}

class NSDRList extends StatelessWidget {
  final List<String> items = ['Eng', 'Vie'];
  final List<String> files = ['Entrelosdos.mp3', 'nsdr_adjusted_2.mp3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${items[index]}'),
            // When the child is tapped, show a snackbar.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NSDR(fileName: files[index])),
              );
            },
          );
        },
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
