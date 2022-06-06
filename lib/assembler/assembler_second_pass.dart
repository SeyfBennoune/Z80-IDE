import 'instructions_map.dart';

class SecondPassClass {
  SecondPassClass({required this.firstPassAddressList, required this.changedText, required this.memoryData, required this.toDisplayMachineCode});
  List<int> firstPassAddressList;
  List<String> changedText;
  List<int> memoryData;
  List<List<int>> toDisplayMachineCode;
  List<int> instructionLength = [];
  List<String> assemblyFile = [];
  void secondPass() {
    assemblyFile = changedText;
    for (var i = 0; i < assemblyFile.length; i++) {
      bool isOrg = assemblyFile[i].contains('ORG');
      bool isEqu = assemblyFile[i].contains('EQU');
      bool isDB = assemblyFile[i].contains('DB');
      bool isEnd = assemblyFile[i].contains('END');

      bool isDirectiveButDB = isOrg || isEqu || isEnd;
      if (isDirectiveButDB) {
        memoryData[firstPassAddressList[i]] = 00;
        toDisplayMachineCode.add([00]);
      } else if (isDB) {
        int startQuotePosition = assemblyFile[i].indexOf('"');
        int endQuotePosition = assemblyFile[i].lastIndexOf('"');
        String dbString = assemblyFile[i].substring(startQuotePosition + 1, endQuotePosition);
        List<int> dbCodes = [];
        for (int j = 0; j < dbString.length; j++) {
          int asciiCode = dbString.codeUnitAt(j);
          memoryData[firstPassAddressList[i] + j] = asciiCode;

          print(firstPassAddressList[i] + j);
          dbCodes.add(dbString.codeUnitAt(j));
        }

        toDisplayMachineCode.add(dbCodes);
      } else {
        // it is an instruction

        String opcode;
        List<String> operands;
        assemblyFile[i] = removeSpace(assemblyFile[i]);

        opcode = getOpcode(assemblyFile[i]);

        operands = getOperands(assemblyFile[i]);
        bool isDirectAssignment = isContainingNumber(operands);
        print('1');
        List<int> soloMachineCode = getMachineCode(opcode, operands, isDirectAssignment);
        print('2');
        toDisplayMachineCode.add(soloMachineCode);
        instructionLength.add(soloMachineCode.length);
        for (int j = 0; j < soloMachineCode.length; j++) {
          memoryData[firstPassAddressList[i] + j] = soloMachineCode[j];
        }

        // print('opcode $i: $opcode');
        // print('operands $i: $operands');
      }
    }
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

  List<int> getMachineCode(String opcode, List<String> operands, bool isDirectAssignment) {
    return InstructionsMap(opcode: opcode, operands: operands).machineCodeSolo(isDirectAssignment);
  }

  bool isContainingNumber(List<String> operands) {
    int boolIndicator = 0;
    for (int j = 0; j < operands.length; j++) {
      if (int.tryParse(operands[j]) != null) {
        boolIndicator++;
      } else {
        boolIndicator = boolIndicator;
      }
    }
    if (boolIndicator == 0) {
      return false;
    } else {
      return true;
    }
  }
}
