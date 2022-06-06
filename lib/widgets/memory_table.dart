import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/memory_inspector_screen.dart';

class MemoryTable extends StatefulWidget {
  MemoryTable({Key? key, required this.memoryData}) : super(key: key);
  List<int> memoryData;
  @override
  State<MemoryTable> createState() => _MemoryTableState();
}

class _MemoryTableState extends State<MemoryTable> {
  // this function creates the offset Row widget
  List<Container> offsetRowListBuilder() {
    List<Container> offsetRowList = [
      Container(
        width: 30,
      )
    ];
    for (var i = 0; i < 16; i++) {
      offsetRowList.add(
        Container(
          width: 20,
          child: Center(
            child: Text(
              '${i.toRadixString(16).toUpperCase()}'.padLeft(2, '0'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    return offsetRowList;
  }

// the function that creates the table
  Widget memoryTableBuilder(int index) {
    List<Container> allRow = [
      Container(
        width: 30,
        child: Center(
          child: Text(
            '${index.toRadixString(16).toUpperCase()}0'.padLeft(4, '0'),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
    for (var i = 0; i < 16; i++) {
      allRow.add(Container(
        width: 20,
        decoration: BoxDecoration(color: Colors.grey[300], boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(1, 1))]),
        child: Center(
          child: Text(
            widget.memoryData[(index << 4) + i].toRadixString(16).toString().toUpperCase().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ));
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: allRow);
  }

  //  here is the build method
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: offsetRowListBuilder(),
            ),
          ),
          SizedBox(
            height: kDefaultPadding / 4,
          ),
          // ListView builder
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
              itemCount: 0X1000,
              separatorBuilder: (context, index) {
                return SizedBox(height: kDefaultPadding / 4);
              },
              itemBuilder: (context, index) {
                return memoryTableBuilder(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
