import 'package:emulator_app/screens/memory_inspector_screen.dart';

import '../screens/assembler_screen.dart';
import '../screens/emulator_screen.dart';
import '../screens/program_loader_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../constants.dart';
import './machine_code_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  static const screenRoute = '/home-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Z80 IDE'),
        backgroundColor: kPrimaryDarkColor,
      ),
      drawer: AppDrawer(),
      body: HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  Container buildRaisedButton(
      String title, BuildContext con, String routeName) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(kDefaultPadding * 2),
      child: MaterialButton(
        elevation: 20,
        padding: EdgeInsets.all(30),
        onPressed: () => {Navigator.of(con).pushNamed(routeName)},
        color: kButtonsColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildRaisedButton(
                  'Assembler', context, AssemblerScreen.screenRoute),
              buildRaisedButton(
                  'Machine Code', context, MachineCodeScreen.screenRoute),
              buildRaisedButton(
                  'Emulator', context, EmulatorScreen.screenRoute),
              buildRaisedButton(
                  'Program Loader', context, ProgramLoaderScreen.screenRoute),
              buildRaisedButton('Memory Inspector', context,
                  MemoryInspectorScreen.screenRoute),
            ],
          ),
        ),
      ),
    );
  }
}
