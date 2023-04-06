// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../constants.dart';
import 'dart:convert';
import 'dart:core';
import '../assembler/assembler_first_pass.dart';
import '../assembler/assembler_second_pass.dart';

class AssemblerScreen extends StatelessWidget {
  AssemblerScreen(
      {Key? key,
      required this.instructionsReadyForSimulation,
      required this.changedText,
      required this.memoryData})
      : super(key: key);
  List<String> instructionsReadyForSimulation;
  List<String> changedText;
  List<int> memoryData;
  static const screenRoute = '/assembler';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Assembler'),
          backgroundColor: kDarkColor,
        ),
        drawer: AppDrawer(),
        body: AssemblerScreenBody(
          instructionsReadyForSimulation: instructionsReadyForSimulation,
          changedText: changedText,
          memoryData: memoryData,
        ),
      ),
    );
  }
}

class AssemblerScreenBody extends StatefulWidget {
  AssemblerScreenBody(
      {Key? key,
      required this.instructionsReadyForSimulation,
      required this.changedText,
      required this.memoryData})
      : super(key: key);
  List<String> instructionsReadyForSimulation;
  List<String> changedText;
  List<int> memoryData;

  @override
  State<AssemblerScreenBody> createState() => _AssemblerScreenBodyState();
}

class _AssemblerScreenBodyState extends State<AssemblerScreenBody> {
  // variables related to Widget
  TextEditingController _controller = TextEditingController();
  LineSplitter lsTwo = LineSplitter();
  List<Widget> precedentLineNumbersWidgetList = [];
  List<Widget> addressWidgetList = [];
  List<Row> machineCodeRowsList = [];
  List<List<int>> toDisplayMachineCode = [];

  // variables related to assembler
  // List<String> changedText = [];
  List<int> firstPassAddressList = [0];
  initState() {
    _controller.text = widget.changedText.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    double devicHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(20),
      height: devicHeight,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // button assemble is here
            SizedBox(
              height: devicHeight / 20,
              child: MaterialButton(
                child: Text('Assemble'),
                onPressed: assembleMethod,
              ),
            ),
            SizedBox(height: kDefaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Machine Code widget
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: devicHeight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 20,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, right: kDefaultPadding),
                                  child: SingleChildScrollView(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: addressWidgetList,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: machineCodeRowsList,
                                          ),
                                        ), // Assembler Widget
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children:
                                                precedentLineNumbersWidgetList,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                //Text field is here
                                child: TextField(
                                  onChanged: afterChanged,
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: 'Write Instructions',
                                    fillColor: kTextBgColor,
                                    filled: true,
                                  ),
                                  maxLines: null,
                                  expands: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////

  //here is the assembler method
  void assembleMethod() {
    toDisplayMachineCode = [];
    widget.instructionsReadyForSimulation.clear();
    firstPassAddressList = [0];
    List<int> instructionLength = [];

    FirstPassClass(
      changedText: widget.changedText,
      firstPassAddressList: firstPassAddressList,
      firstPassResult: widget.instructionsReadyForSimulation,
    ).firstPass();
    addressWidgetListUpdate(firstPassAddressList);

    print('AS: ${widget.instructionsReadyForSimulation}');

    SecondPassClass(
      firstPassAddressList: firstPassAddressList,
      changedText: widget.changedText,
      memoryData: widget.memoryData,
      toDisplayMachineCode: toDisplayMachineCode,
    ).secondPass();
    machineCodeRowsListUpdate(toDisplayMachineCode);
  }

  // onChanged method for the textField widget POP UP assembly line number
  void afterChanged(text) {
    widget.changedText
        .replaceRange(0, widget.changedText.length, lsTwo.convert(text));

    List<Widget> lineNumbersList = [];
    setState(() {
      if (widget.changedText.length > precedentLineNumbersWidgetList.length) {
        for (var i = 0; i < widget.changedText.length; i++) {
          lineNumbersList.add(
            Text(
              '${i + 1}',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        precedentLineNumbersWidgetList = lineNumbersList;
      } else if (widget.changedText.length <
          precedentLineNumbersWidgetList.length) {
        for (var i = 0; i < widget.changedText.length; i++) {
          lineNumbersList.add(
            Text(
              '${i + 1}',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        precedentLineNumbersWidgetList = lineNumbersList;
      }
    });
  }

  //  method that assigns each assembly line a widget of address
  void addressWidgetListUpdate(List<int> addressesList) {
    setState(() {
      addressWidgetList = [];
      for (var i = 0; i < addressesList.length; i++) {
        addressWidgetList.add(Text(
          '${addressesList[i].toRadixString(16).toUpperCase()}'.padLeft(4, '0'),
          style: TextStyle(fontSize: 16),
        ));
      }
    });
  }

  // method that assigns each assembly line a row widget of machine code
  void machineCodeRowsListUpdate(List<List<int>> toDisplayMachineCode) {
    setState(() {
      machineCodeRowsList = [];
      for (var i = 0; i < toDisplayMachineCode.length; i++) {
        List<Text> rowOfInstructionMachineCode = [];

        for (var j = 0; j < toDisplayMachineCode[i].length; j++) {
          rowOfInstructionMachineCode.add(Text(
            '${toDisplayMachineCode[i][j].toRadixString(16).padLeft(2, '0').toUpperCase()}',
            style: TextStyle(fontSize: 16, color: kPrimaryDarkColor),
          ));
        }
        machineCodeRowsList.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowOfInstructionMachineCode,
          ),
        );
      }
    });
  }
}
