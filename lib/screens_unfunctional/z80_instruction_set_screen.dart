import 'package:flutter/material.dart';
import 'package:emulator_app/constants.dart';
import '../../widgets/app_drawer.dart';

class InstructionSetScreen extends StatelessWidget {
  const InstructionSetScreen({Key? key}) : super(key: key);
  static const screenRoute = '/instruction-set';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Instruction Set'),
        backgroundColor: kDarkColor,
      ),
      drawer: AppDrawer(),
      body: InstructionSetBody(),
    ));
  }
}

class InstructionSetBody extends StatefulWidget {
  const InstructionSetBody({Key? key}) : super(key: key);

  @override
  State<InstructionSetBody> createState() => _InstructionSetBodyState();
}

class _InstructionSetBodyState extends State<InstructionSetBody> {
  int pageNumber = 0;
  List<Color> buttonsColors = [kPrimaryDarkColor, kButtonsColor, kButtonsColor];
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      height: deviceHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // image
          InteractiveViewer(
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                child: Image(
                  image: AssetImage(
                      'assets/images/instruction_set_page_${pageNumber + 1}.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          // buttons
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildpageNumberRaisedButton(0),
                buildpageNumberRaisedButton(1),
                buildpageNumberRaisedButton(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildpageNumberRaisedButton(int givePageNumber) {
    return MaterialButton(
      textColor: Colors.white,
      color: buttonsColors[givePageNumber],
      child: Text('${givePageNumber + 1}'),
      onPressed: () => buttonPressed(givePageNumber),
    );
  }

  void buttonPressed(int whichButton) {
    setState(() {
      pageNumber = whichButton;
    });
    for (int i = 0; i < 3; i++) {
      if (i == whichButton) {
        buttonsColors[i] = kPrimaryDarkColor;
      } else {
        buttonsColors[i] = kButtonsColor;
      }
    }
  }
}
