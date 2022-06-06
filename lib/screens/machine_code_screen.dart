// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../constants.dart';
import '../widgets/app_drawer.dart';

class MachineCodeScreen extends StatefulWidget {
  MachineCodeScreen({Key? key, required this.memoryData}) : super(key: key);
  List<int> memoryData;
  static const screenRoute = '/machine-code';

  @override
  State<MachineCodeScreen> createState() => _MachineCodeScreenState(memoryData: memoryData);
}

class _MachineCodeScreenState extends State<MachineCodeScreen> {
  _MachineCodeScreenState({required this.memoryData});
  List<int> memoryData;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Machine Code'),
          backgroundColor: kDarkColor,
        ),
        drawer: AppDrawer(),
        body: MachineCodeScreenBody(memoryData: memoryData),
      ),
    );
  }
}

class MachineCodeScreenBody extends StatefulWidget {
  MachineCodeScreenBody({
    Key? key,
    required this.memoryData,
  });
  List<int> memoryData;
  @override
  State<MachineCodeScreenBody> createState() => _MachineCodeScreenBodyState();
}

class _MachineCodeScreenBodyState extends State<MachineCodeScreenBody> {
  bool isAddress = true;
  Color? dataColor = a[200];
  Color? addressColor = Colors.green[500];

  static int addressTyped = 0;

  // build method starts here
  @override
  Widget build(BuildContext context) {
    int dataValue = widget.memoryData[addressTyped];
    List<Widget> keyboardList = [];
    // 16 buttons keyboard generator
    List<Widget> keyboardFunction() {
      for (var i = 0; i < 16; i++) {
        keyboardList.add(
          buildKeyboardRaisedButton(
            '${i.toRadixString(16)}'.toUpperCase(),
            // keyboard button onPressed function
            () {
              setState(() {
                if (isAddress) {
                  if (addressTyped < 0X1000) {
                    addressTyped = (addressTyped << 4) + i;
                  } else {
                    addressTyped = ((addressTyped << 4) + i) & 0X0FFFF;
                  }
                  dataValue = widget.memoryData[addressTyped];
                } else {
                  if (dataValue < 0X10) {
                    dataValue = (dataValue << 4) + i;
                  } else {
                    dataValue = ((dataValue << 4) + i) & 0X0FF;
                  }
                  widget.memoryData[addressTyped] = dataValue;
                }
              });
            },
          ),
        );
      }
      return keyboardList;
    }

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Column(
        // main column
        children: [
          // upper side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //address column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildRaisedButton('Address', () {
                        setState(() {
                          dataColor = a[200];

                          addressColor = Colors.green[500];
                          isAddress = true;
                        });
                      }),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      buildAddressDataContainer(addressColor, addressTyped, 4),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      buildRaisedButton('Next', () {
                        setState(() {
                          if (addressTyped == 0XFFFF) {
                            addressTyped = addressTyped;
                          } else {
                            addressTyped = addressTyped + 1;
                          }
                          dataValue = widget.memoryData[addressTyped];
                        });
                      }),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      buildRaisedButton('Previous', () {
                        setState(() {
                          if (addressTyped == 0X0000) {
                          } else {
                            addressTyped = addressTyped - 1;
                          }
                          dataValue = widget.memoryData[addressTyped];
                        });
                      }),
                    ],
                  ),
                ),
              ),
              //data column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildRaisedButton('Data', () {
                        setState(() {
                          addressColor = Colors.green[200];
                          dataColor = a[500];
                          isAddress = false;
                        });
                      }),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      buildAddressDataContainer(dataColor, dataValue, 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //sizedBox
          SizedBox(height: kDefaultPadding * 2),
          // lower side

          Expanded(
            child: Container(
              width: 400,
              child: GridView(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  childAspectRatio: 1,
                  mainAxisSpacing: kDefaultPadding,
                  crossAxisSpacing: kDefaultPadding,
                ),
                children: keyboardFunction(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildAddressDataContainer(Color? color, int valueInside, int padLeftValue) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      color: color,
      alignment: Alignment.center,
      child: Text(
        '${valueInside.toRadixString(16)}'.toUpperCase().padLeft(padLeftValue, '0'),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  RaisedButton buildRaisedButton(String title, void onPushed()) {
    return RaisedButton(
      padding: EdgeInsets.all(kDefaultPadding),
      onPressed: onPushed,
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  RaisedButton buildKeyboardRaisedButton(String title, void onPushed()) {
    return RaisedButton(
      padding: EdgeInsets.all(kDefaultPadding),
      onPressed: onPushed,
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
