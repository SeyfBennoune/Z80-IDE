import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_drawer.dart';

class AssemblerRulesScreen extends StatelessWidget {
  const AssemblerRulesScreen({Key? key}) : super(key: key);
  static const screenRoute = '/assembler-rules';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Assembler Rules'),
          backgroundColor: kDarkColor,
        ),
        drawer: AppDrawer(),
        body: AssemblerRulesBody(),
      ),
    );
  }
}

class AssemblerRulesBody extends StatelessWidget {
  const AssemblerRulesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: ClipRRect(
          child: Image(
            image: AssetImage('assets/images/assembler_rules_text.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
