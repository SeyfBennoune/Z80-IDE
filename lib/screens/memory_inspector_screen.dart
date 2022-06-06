import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_drawer.dart';
import '../widgets/memory_table.dart';

class MemoryInspectorScreen extends StatefulWidget {
  MemoryInspectorScreen({Key? key, required this.memoryData}) : super(key: key);
  static const screenRoute = '/memory-inspector';
  List<int> memoryData;
  @override
  State<MemoryInspectorScreen> createState() => _MemoryInspectorScreenState();
}

class _MemoryInspectorScreenState extends State<MemoryInspectorScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Memory Inspector'),
          backgroundColor: kDarkColor,
        ),
        drawer: AppDrawer(),
        body: MemoryInspectorScreenBody(memoryData: widget.memoryData),
      ),
    );
  }
}

class MemoryInspectorScreenBody extends StatefulWidget {
  MemoryInspectorScreenBody({Key? key, required this.memoryData}) : super(key: key);
  List<int> memoryData;
  @override
  State<MemoryInspectorScreenBody> createState() => _MemoryInspectorScreenBodyState();
}

class _MemoryInspectorScreenBodyState extends State<MemoryInspectorScreenBody> {
  @override
  Widget build(BuildContext context) {
    return MemoryTable(
      memoryData: widget.memoryData,
    );
  }
}
