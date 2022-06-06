import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/app_drawer.dart';

import 'dart:async';
import 'dart:math';

class ProgramLoaderScreen extends StatefulWidget {
  const ProgramLoaderScreen({Key? key}) : super(key: key);
  static const screenRoute = '/program-loader';
  @override
  State<ProgramLoaderScreen> createState() => _ProgramLoaderScreenState();
}

class _ProgramLoaderScreenState extends State<ProgramLoaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Program Loader'),
        backgroundColor: kDarkColor,
      ),
      drawer: AppDrawer(),
      body: ProgramLoaderScreenBody(),
    );
  }
}

class ProgramLoaderScreenBody extends StatelessWidget {
  const ProgramLoaderScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text('Coming soon!')));
  }
}
