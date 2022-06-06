import '../emulator/z80_general_operations.dart';

class Emulator extends GeneralOperations {
  List<int> memoryDataWithSimulator = List.filled(0xffff, 00);
  static int A = 0x00;
  static int B = 0x00;
  static int C = 0x00;
  static int D = 0x00;
  static int E = 0x00;
  static int H = 0x00;
  static int L = 0x00;

  static int BC = C | (B << 8);
  static int DE = E | (D << 8);
  static int HL = L | (H << 8);

  static int IX = 0x0000;
  static int IY = 0x0000;
  static int d = 0x00;

  Map<String, int> generalRegisters = {
    'A': A,
    'B': B,
    'C': C,
    'D': D,
    'E': E,
    'H': H,
    'L': L,
  };

  Map<String, int> registerPair = {
    'BC': BC,
    'DE': DE,
    'HL': HL,
  };
  Map<String, int> indexRegisters = {
    'IX+$d': IX + d,
    'IX+$d': IY + d,
  };

  Emulator({
    required this.passedParameter,
    required this.firstPassResult,
  });
  List<String> passedParameter;
  List<String> firstPassResult;
  List<int> machineCodeAssembled = [];
  List<int> instructionLength = [];
  void startSimulation() {
    for (var i = 0; i < firstPassResult.length; i++) {
      String opcode;
      List<String> operands;
      firstPassResult[i] = removeSpace(firstPassResult[i]);

      opcode = getOpcode(firstPassResult[i]);

      operands = getOperands(firstPassResult[i]);
      testForOperands(operands[0]);
      //// here are multiple instructions simulations
      switch (opcode) {
        case 'LD':
          {
            if (isIndirect(operands)) {
              setState() {
                if (isRead(operands)) {
                  memRead(getLocation(operands[0]));
                }
              }
            }
          }
      }
      //// here finishes the table

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

  List<bool> testForOperands(String operands) {
    bool isGeneralRegister = false;
    bool isRegisterPair = false;
    bool isIndexRegisters = false;
    List<String> generalRegistersKeys = generalRegisters.keys.toList();
    for (var j = 0; j < generalRegistersKeys.length; j++) {
      if (operands == generalRegistersKeys[j]) {
        isGeneralRegister = true;
      } else {
        isGeneralRegister = false;
      }
    }
    List<String> registerPairKeys = registerPair.keys.toList();
    for (var j = 0; j < registerPairKeys.length; j++) {
      if (operands == registerPairKeys[j]) {
        isRegisterPair = true;
      } else {
        isRegisterPair = false;
      }
    }
    List<String> indexRegistersKeys = indexRegisters.keys.toList();
    for (var j = 0; j < indexRegistersKeys.length; j++) {
      if (operands == indexRegistersKeys[j]) {
        isIndexRegisters = true;
      } else {
        isGeneralRegister = false;
      }
    }

    return [isGeneralRegister, isRegisterPair, isIndexRegisters];
  }

  bool isIndirect(List<String> operands) {
    return operands[0].contains('(') || operands[1].contains('(');
  }

  bool isRead(List<String> operands) {
    return operands[0].contains('(');
  }

  int getLocation(String operand) {
    String operandWithoutBrackets = operand.replaceAll('(', '');
    operandWithoutBrackets = operand.replaceAll(')', '');
    return registerPair[operandWithoutBrackets]!;
  }
}
