class GeneralOperations {
  List<int> memoryData = List.filled(0xffff, 0);
  int memRead(int address) {
    return memoryData[address];
  }

  int memWrite(int address, int data) {
    return memoryData[address] = data;
  }
}
