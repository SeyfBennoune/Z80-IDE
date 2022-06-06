import '../screens/disassembler_screen.dart';

import './screens_unfunctional/z80_instruction_set_screen.dart';
import './screens_unfunctional/assembler_rules_screen.dart';
import './screens_unfunctional/pin_description_screen.dart';

import './screens/emulator_screen.dart';
import './screens/memory_inspector_screen.dart';
import './screens/program_loader_screen.dart';
import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './screens/assembler_screen.dart';
import './screens/machine_code_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  List<int> memoryData = List.filled(0X10000, 00);
  List<String> instructionsReadyForSimulation = [];
  List<String> changedText = [];
  List<String> passedParameter = ['A'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Z80 Emulator',
      home: HomeScreen(),
      routes: {
        HomeScreen.screenRoute: (ctx) => HomeScreen(),
        MachineCodeScreen.screenRoute: (ctx) => MachineCodeScreen(
              memoryData: memoryData,
            ),
        AssemblerScreen.screenRoute: (ctx) => AssemblerScreen(
              instructionsReadyForSimulation: instructionsReadyForSimulation,
              changedText: changedText,
              memoryData: memoryData,
            ),
        EmulatorScreen.screenRoute: (ctx) => EmulatorScreen(
              firstPassResult: instructionsReadyForSimulation,
              changedText: changedText,
              passedParameter: passedParameter,
            ),
        ProgramLoaderScreen.screenRoute: (ctx) => ProgramLoaderScreen(),
        MemoryInspectorScreen.screenRoute: (ctx) => MemoryInspectorScreen(
              memoryData: memoryData,
            ),
        InstructionSetScreen.screenRoute: (ctx) => InstructionSetScreen(),
        AssemblerRulesScreen.screenRoute: (ctx) => AssemblerRulesScreen(),
        PinDescriptionScreen.screenRoute: (ctx) => PinDescriptionScreen(),
        DisassemblerScreen.screenRoute: (ctx) => DisassemblerScreen(),
      },
    );
  }
}
