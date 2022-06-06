import '../widgets/memory_table.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:flutter/services.dart';
import '../widgets/app_drawer.dart';
import '../emulator/emulator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmulatorScreen extends StatelessWidget {
  EmulatorScreen({Key? key, required this.firstPassResult, required this.changedText, required this.passedParameter}) : super(key: key);
  List<String> firstPassResult;
  List<String> changedText;
  List<String> passedParameter;
  static const screenRoute = '/emulator';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Emulator'),
        backgroundColor: kDarkColor,
      ),
      drawer: AppDrawer(),
      body: SafeArea(
          child: EmulatorScreenBody(
        firstPassResult: firstPassResult,
        changedText: changedText,
        passedParameter: passedParameter,
      )),
    );
  }
}

class EmulatorScreenBody extends StatelessWidget {
  EmulatorScreenBody({Key? key, required this.firstPassResult, required this.changedText, required this.passedParameter}) : super(key: key);
  ///////////////////////////////////////////////////////
  List<String> firstPassResult;
  List<String> changedText;
  List<String> passedParameter;
  /////////////////////////////////////////////////////////

  static int A = 0x00;
  static int B = 0x00;
  static int C = 0x00;
  static int D = 0x00;
  static int E = 0x00;
  static int H = 0x00;
  static int L = 0x00;
  static int F = 0x00;

  static int BC = C | (B << 8);
  static int DE = E | (D << 8);
  static int HL = L | (H << 8);

  static int fS = 0;
  static int fZ = 0;
  static int fH = 0;
  static int fP = 0;
  static int fN = 0;
  static int fC = 0;

  static int sP = 0x0000;
  static int pC = 0x0000;
  Map<String, int> flags = {
    'SF': fS,
    'ZF': fZ,
    'HF': fH,
    'PF': fP,
    'NF': fN,
    'CF': fC,
  };

  Map<String, int> generalRegisters = {
    'A': A,
    'B': B,
    'C': C,
    'D': D,
    'E': E,
    'H': H,
    'L': L,
    'F': F,
  };

  Map<String, int> registerPair = {
    'BC': BC,
    'DE': DE,
    'HL': HL,
  };

  Map<String, int> specialRegisters = {
    'SP': sP,
    'PC': pC,
  };

  /////////////////////////////////////////////////////////
  void execute() {
    Emulator(passedParameter: passedParameter, firstPassResult: firstPassResult).startSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            // BUTTONS

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    child: Text('Execute'),
                    onPressed: () {
                      if (firstPassResult.length == 0) {
                        setstate() {
                          Fluttertoast.showToast(
                            msg: "PLEASE ASSEMBLE THE PROGRAM FIRST",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Color.fromARGB(255, 41, 29, 29),
                            fontSize: 16.0,
                          );
                        }
                      } else {
                        execute();
                      }
                    }),
                RaisedButton(
                    child: Text('STEP'),
                    onPressed: () {
                      print(firstPassResult);
                    }),
                RaisedButton(
                    child: Text('END'),
                    onPressed: () {
                      print(firstPassResult);
                    }),
              ],
            ),

            SizedBox(height: kDefaultPadding),

            // instruction overview
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildRow('Previous Instruction', 'LD A,B'),
                  SizedBox(height: kDefaultPadding),
                  buildRow('Next Instruction', 'LD A,B'),
                  SizedBox(height: kDefaultPadding),
                  buildRow('Instructions Counter', '0'),
                  SizedBox(height: kDefaultPadding),
                  buildRow('Clock Cycles Counter', '0'),
                ],
              ),
            ),
            SizedBox(height: kDefaultPadding),
            // main registers
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow('A', '${generalRegisters['A']}'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow('F', '${generalRegisters['F']}'),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow('B', '${generalRegisters['B']}'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow('C', '${generalRegisters['C']}'),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow('D', '${generalRegisters['D']}'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow('E', '${generalRegisters['E']}'),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow('H', '${generalRegisters['H']}'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow('L', '${generalRegisters['L']}'),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildFlagsWidget('SF', '${flags['SF']}'),
                    buildFlagsWidget('ZF', '${flags['ZF']}'),
                    buildFlagsWidget('YF', '0'),
                    buildFlagsWidget('HF', '${flags['HF']}'),
                    buildFlagsWidget('XF', '0'),
                    buildFlagsWidget('PF', '${flags['PF']}'),
                    buildFlagsWidget('NF', '${flags['NF']}'),
                    buildFlagsWidget('CF', '${flags['CF']}'),
                  ],
                ),
              ],
            ),
            SizedBox(height: kDefaultPadding),
            // 16 bit registers
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow('IX', '0000'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow('IY', '0000'),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow('SP', '${specialRegisters['SP']}'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow('PC', '${specialRegisters['PC']}'),
                  ],
                ),
              ],
            ),
            SizedBox(height: kDefaultPadding),
            // I and R registers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildRegistersRow('I', '00'),
                SizedBox(width: kDefaultPadding),
                buildRegistersRow('R', '00'),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: Divider(
                thickness: 3,
              ),
            ),
            // alternate registers
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow("A '", '00'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow("F '", '00'),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow("B '", '00'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow("C '", '00'),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow("D '", '00'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow("E '", '00'),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRegistersRow("H '", '00'),
                    SizedBox(width: kDefaultPadding),
                    buildRegistersRow("L '", '00'),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildFlagsWidget("S ' ", '0'),
                    buildFlagsWidget("Z '", '0'),
                    buildFlagsWidget("Y '", '0'),
                    buildFlagsWidget("H '", '0'),
                    buildFlagsWidget("X '", '0'),
                    buildFlagsWidget("P '", '0'),
                    buildFlagsWidget("Z '", '0'),
                    buildFlagsWidget("C '", '0'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//////////////////////////////////////////////// build methodd finished////////////////////////////////////////////
  Column buildFlagsWidget(String constPrefix, String dataChanging) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: 47.5,
              alignment: Alignment.center,
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                border: Border.all(color: kDarkColor, width: 2),
                color: kPrimaryColor,
              ),
              child: Text(
                constPrefix,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: kDefaultPadding),
            Container(
              width: 47.5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: kDarkColor, width: 2),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(kDefaultPadding / 2),
              child: Text(
                dataChanging,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }

  Row buildRow(String constPrefix, String dataChanging) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180,
          alignment: Alignment.center,
          padding: EdgeInsets.all(kDefaultPadding / 2),
          decoration: BoxDecoration(
            border: Border.all(color: kDarkColor, width: 2),
            color: kPrimaryColor,
          ),
          child: Text(
            '$constPrefix',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: kDefaultPadding),
        Container(
          alignment: Alignment.center,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(color: kDarkColor, width: 2),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(kDefaultPadding / 2),
          child: Text(
            ' $dataChanging',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Row buildRegistersRow(String constPrefix, String dataChanging) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          alignment: Alignment.center,
          padding: EdgeInsets.all(kDefaultPadding / 2),
          decoration: BoxDecoration(
            border: Border.all(color: kDarkColor, width: 2),
            color: kPrimaryColor,
          ),
          child: Text(
            '$constPrefix',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 70,
          decoration: BoxDecoration(
            border: Border.all(color: kDarkColor, width: 2),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(kDefaultPadding / 2),
          child: Text(
            ' $dataChanging',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
