import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_drawer.dart';
import '../constants.dart';

class PinDescriptionScreen extends StatelessWidget {
  const PinDescriptionScreen({Key? key}) : super(key: key);
  static const screenRoute = '/pin-description';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Pin Description'),
          backgroundColor: kDarkColor,
        ),
        drawer: AppDrawer(),
        body: PinDescriptionBody(),
      ),
    );
  }
}

class PinDescriptionBody extends StatelessWidget {
  const PinDescriptionBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              child: Image(
                image: AssetImage('assets/images/pin_description_image.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
