import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';

class InstructionsMap {
  String opcode;
  List<String> operands;

  InstructionsMap({required this.opcode, required this.operands});

  Map<String, int> binaryEquivalent = {
    'B': 0,
    'C': 1,
    'D': 2,
    'E': 3,
    'H': 4,
    'L': 5,
    '(HL)': 6,
    'A': 7,
  };
  Map<String, int> binaryConditionEquivalent = {
    'C': 0XD8,
    'NC': 0XD0,
    'Z': 0XC8,
    'NZ': 0XC0,
    'PE': 0XE8,
    'PO': 0XE0,
    'N': 0XF8,
    'P': 0XF0,
  };

  // late Map<String, int> instructionsMap = {
  //   'LD ${operands[0]},${operands[1]}': 0x40 | binaryEquivalent[operands[0]]! << 3 | binaryEquivalent[operands[1]]!,
  //   'INC ${operands[0]}': 0X04 | binaryEquivalent[operands[0]]! << 3,
  // };
  List<int> machineCodeSolo(bool isDirectAssignment) {
    print('3');
    switch (opcode) {

      // 8-BIT LOAD GROUP
      case 'LD':
        if (isDirectAssignment) {
          return [0X06 | binaryEquivalent[operands[0]]! << 3, int.parse(operands[1])];
        } else {
          return [0X40 | binaryEquivalent[operands[0]]! << 3 | binaryEquivalent[operands[1]]!];
        }
      // ARITHMETIC AND LOGIC GROUP
      case 'INC':
        return [0X04 | binaryEquivalent[operands[0]]! << 3];
      case 'DEC':
        return [0X05 | binaryEquivalent[operands[0]]! << 3];

      case 'ADD':
        if (isDirectAssignment) {
          return [0XC6 | binaryEquivalent[operands[0]]! << 3, int.parse(operands[1])];
        } else {
          return [0X80 | binaryEquivalent[operands[0]]! << 3 | binaryEquivalent[operands[1]]!];
        }
      case 'ADC':
        if (isDirectAssignment) {
          return [0XCE, int.parse(operands[1])];
        } else {
          return [0X88 | binaryEquivalent[operands[0]]!];
        }

      case 'SUB':
        {
          if (isDirectAssignment) {
            return [0XD6, int.parse(operands[0])];
          } else {
            return [0X90 | binaryEquivalent[operands[0]]!];
          }
        }

      case 'SBC':
        if (isDirectAssignment) {
          return [0XDE, int.parse(operands[0])];
        } else {
          return [0X98 | binaryEquivalent[operands[0]]!];
        }
      case 'AND':
        if (isDirectAssignment) {
          return [0XE6, int.parse(operands[0])];
        } else {
          return [0XA0 | binaryEquivalent[operands[0]]!];
        }
      case 'XOR':
        if (isDirectAssignment) {
          return [0XEE, int.parse(operands[0])];
        } else {
          return [0XA8 | binaryEquivalent[operands[0]]!];
        }
      case 'OR':
        if (isDirectAssignment) {
          return [0XF6, int.parse(operands[0])];
        } else {
          return [0XB0 | binaryEquivalent[operands[0]]!];
        }
      case 'CP':
        if (isDirectAssignment) {
          return [0XFE, int.parse(operands[0])];
        } else {
          return [0XB8 | binaryEquivalent[operands[0]]!];
        }

      // JUMP & CALL & RETURN
      case 'JP':
        if (operands[0] == '(HL)') {
          return [0XEB];
        } else {
          return jpCall(0XC3, 2);
        }

      case 'CALL':
        return jpCall(0XCD, 4);
      case 'RET':
        if (operands.length == 1) {
          return [0XC9];
        } else {
          return [binaryConditionEquivalent[operands[0]]!];
        }
      case 'HALT':
        {
          return [0X76];
        }
      default:
        return [];
    }
  }

  List<int> jpCall(int unconditionalOpcode, int offset) {
    if (operands.length == 1) {
      int address = int.parse(operands[0]);
      return [unconditionalOpcode, (address & 0X00FF), address >> 8];
    } else {
      int address = int.parse(operands[1]);
      return [binaryConditionEquivalent[operands[1]]! + offset, address & 0X00FF, address >> 8];
    }
  }
}
