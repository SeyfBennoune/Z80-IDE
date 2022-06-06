// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_const, prefer_const_constructors

import 'package:emulator_app/screens/disassembler_screen.dart';

import '../screens_unfunctional/z80_instruction_set_screen.dart';
import '../screens_unfunctional/assembler_rules_screen.dart';
import '../screens_unfunctional/pin_description_screen.dart';
import '../screens/assembler_screen.dart';
import '../screens/emulator_screen.dart';
import '../screens/home_screen.dart';
import '../screens/machine_code_screen.dart';
import '../screens/memory_inspector_screen.dart';
import '../screens/program_loader_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  ListTile buildListTile(BuildContext context, String title, String routeName, IconData whichIcon) {
    return ListTile(
      leading: Icon(whichIcon),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: kPrimaryColor,
                  height: 200,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/app_drawer.png'),
                      ),
                      SizedBox(width: kDefaultPadding),
                      Text(
                        'Z80 IDE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildListTile(context, 'Home', HomeScreen.screenRoute, Icons.home),
            buildListTile(context, 'Assembler', AssemblerScreen.screenRoute, Icons.code),
            buildListTile(context, 'Disassembler', DisassemblerScreen.screenRoute, Icons.transform),
            buildListTile(context, 'Machine Code', MachineCodeScreen.screenRoute, Icons.numbers),
            buildListTile(context, 'Emulator', EmulatorScreen.screenRoute, Icons.computer),
            buildListTile(context, 'Program Loader', ProgramLoaderScreen.screenRoute, Icons.bluetooth),
            buildListTile(context, 'Memory Inspector', MemoryInspectorScreen.screenRoute, Icons.memory),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Divider(),
            ),
            buildListTile(context, 'Z80 Instruction Set', InstructionSetScreen.screenRoute, Icons.menu_book),
            buildListTile(context, 'Pin Description', PinDescriptionScreen.screenRoute, Icons.format_list_numbered),
            buildListTile(context, 'Assembler Rules', AssemblerRulesScreen.screenRoute, Icons.rule),
          ],
        ),
      ),
    );
  }
}
