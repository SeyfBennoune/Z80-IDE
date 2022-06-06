import 'package:emulator_app/assembler/assembler_second_pass.dart';
import 'package:emulator_app/assembler/instructions_map.dart';

class FirstPassClass {
  FirstPassClass({required this.changedText, required this.firstPassAddressList, required this.firstPassResult});
  List<String> changedText;
  List<int> firstPassAddressList;
  List<String> firstPassResult;

  void firstPass() {
    List<String> assemblyFile = changedText;

    // this map tracks EQU
    Map<String, int> equateOccurances = {};
    Map<String, int> labelOccurances = {};
    // PASS 1
    for (var i = 0; i < assemblyFile.length; i++) {
      bool isOrg = assemblyFile[i].contains('ORG');
      bool isEqu = assemblyFile[i].contains('EQU');
      bool isDB = assemblyFile[i].contains('DB');
      bool isEnd = assemblyFile[i].contains('END');
      // print('pass1;$i');
      // test the line whether it contains a directive or not
      bool isDirective = isOrg || isEqu || isDB || isEnd;

      if (isDirective) {
        // It is a directive
        if (isOrg) {
          String assemblyLine = assemblyFile[i];
          assemblyLine = assemblyLine.replaceAll(' ', '');
          String orgAddressString = assemblyLine.replaceAll('ORG', '');
          int orgAddress = int.parse(orgAddressString);
          firstPassAddressList.add(orgAddress);
        } else if (isEqu) {
          String assemblyLine = assemblyFile[i];
          assemblyLine = assemblyLine.replaceAll(' ', '');
          List<String> equateSplittedList = assemblyLine.split('EQU');
          equateOccurances.addAll({equateSplittedList[0]: int.parse(equateSplittedList[1])});
          firstPassAddressList.add(firstPassAddressList[i]);
        } else if (isDB) {
          String assemblyLine = assemblyFile[i];
          int startQuotePosition = assemblyLine.indexOf('"');
          int endQuotePosition = assemblyLine.lastIndexOf('"');
          String dbString = assemblyLine.substring(startQuotePosition + 1, endQuotePosition);
          firstPassAddressList.add(firstPassAddressList[i] + dbString.length);
        } else if (isEnd) {
          i = assemblyFile.length;
          break;
        }
      } else {
        // It is an instruction
        firstPassResult.add(assemblyFile[i]);
        String instructionWithoutSpace = removeSpace(assemblyFile[i]);
        List<String> operands = getOperands(instructionWithoutSpace);
        bool containsNumber = isContainingNumber(operands);
        int instructionByteNumber = getInstructionByteNumber(assemblyFile[i], containsNumber, operands);
        switch (instructionByteNumber) {
          case 2:
            firstPassAddressList.add(firstPassAddressList[i] + 2);
            break;
          case 3:
            firstPassAddressList.add(firstPassAddressList[i] + 3);
            break;
          case 4:
            firstPassAddressList.add(firstPassAddressList[i] + 4);
            break;
          default:
            firstPassAddressList.add(firstPassAddressList[i] + 1);
        }
      }
    }
    //end of PASS 1
    List<String> equateOccurancesKeyList = equateOccurances.keys.toList();

    // Pass 2: replace EQU Strings
    for (var i = 0; i < firstPassResult.length; i++) {
      // print('pass2:$i');
      for (var j = 0; j < equateOccurancesKeyList.length; j++) {
        if (firstPassResult[i].contains(equateOccurancesKeyList[j])) {
          firstPassResult[i] = firstPassResult[i].replaceAll(equateOccurancesKeyList[j], '${equateOccurances[equateOccurancesKeyList[j]]}');
        }
      }
    }

    // PASS 3
    for (var i = 0; i < assemblyFile.length; i++) {
      // print('pass3:$i');
      if (assemblyFile[i].contains(':')) {
        int indexOfColon = assemblyFile[i].indexOf(':');
        String labelName = assemblyFile[i].replaceAll(' ', '');
        labelName = labelName.substring(0, indexOfColon);
        labelOccurances.addAll({labelName: firstPassAddressList[i]});
      }
    }
    //Pass 4
    for (var i = 0; i < firstPassResult.length; i++) {
      // print('pass4:$i');
      if (firstPassResult[i].contains(':')) {
        int indexOfColon = firstPassResult[i].indexOf(':');
        firstPassResult[i] = firstPassResult[i].substring(indexOfColon + 1);
      }
    }
    List<String> labelOccurancesKeyList = labelOccurances.keys.toList();

    // PASS 5
    for (var i = 0; i < firstPassResult.length; i++) {
      // print('pass5:$i');
      for (var j = 0; j < labelOccurancesKeyList.length; j++) {
        if (firstPassResult[i].contains(labelOccurancesKeyList[j])) {
          firstPassResult[i] = firstPassResult[i].replaceAll(labelOccurancesKeyList[j], '${labelOccurances[labelOccurancesKeyList[j]]}');
        }
      }
    }
    print('FP: $firstPassResult');
  }

  String removeSpace(String instructionWithSpace) {
    return instructionWithSpace.substring(1);
  }

  String getOpcode(String instructionWithoutSpace) {
    if (instructionWithoutSpace.indexOf(' ') == -1) {
      return instructionWithoutSpace;
    } else {
      List<String> split;
      split = instructionWithoutSpace.split(' ');
      return split[0];
    }
  }

  List<String> getOperands(String instructionWithoutSpace) {
    if (instructionWithoutSpace.indexOf(' ') == -1) {
      return [];
    } else {
      String instructionWithoutOpcode = instructionWithoutSpace.substring(instructionWithoutSpace.indexOf(' '));
      String instructionWithoutSpaceOpcode = instructionWithoutOpcode.replaceAll(' ', '');
      return instructionWithoutSpaceOpcode.split(',');
    }
  }

  bool isContainingNumber(List<String> operands) {
    int boolIndicator = 0;
    for (int i = 0; i < operands.length; i++) {
      if (int.tryParse(operands[i]) != null) {
        boolIndicator++;
      }
    }
    if (boolIndicator == 0) {
      return false;
    } else {
      return true;
    }
  }

  int getInstructionByteNumber(String instruction, bool containsNumber, List<String> operands) {
    print('20');
    bool isJpOrCall = instruction.contains('JP') || instruction.contains('CALL');
    bool isLDDirect = instruction.contains('LD') && isNotRegister(operands);
    if (isJpOrCall) {
      return 3;
    } else if (isLDDirect) {
      return 2;
    }

    return 1;
  }

  bool isNotRegister(List<String> operands) {
    List<String> register = ['A', 'B', 'C', 'D', 'E', 'H', 'L', '(HL)'];

    for (int count = 0; count < operands.length; count++) {
      if (!register.contains(operands[count])) {
        print('10');
        return true;
      }
    }
    return false;
  }
}
