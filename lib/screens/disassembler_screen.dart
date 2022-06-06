import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_drawer.dart';

class DisassemblerScreen extends StatelessWidget {
  const DisassemblerScreen({Key? key}) : super(key: key);
  static const screenRoute = '/disassembler';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Disassembler'),
          backgroundColor: kDarkColor,
        ),
        drawer: AppDrawer(),
        body: DisassemblerBody(),
      ),
    );
  }
}

class DisassemblerBody extends StatefulWidget {
  const DisassemblerBody({Key? key}) : super(key: key);

  @override
  State<DisassemblerBody> createState() => _DisassemblerBodyState();
}

class _DisassemblerBodyState extends State<DisassemblerBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Coming soon!')),
    );
  }
}
