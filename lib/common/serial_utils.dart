import 'dart:ffi';
import 'dart:io';

class SerialUtils {
  void init() {
    final DynamicLibrary nativeAddLib = Platform.isAndroid
        ? DynamicLibrary.open('libnative_add.so')
        : DynamicLibrary.process();

    final int Function(int x, int y) nativeAdd = nativeAddLib
        .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('native_add')
        .asFunction();

    final temp = nativeAdd(1, 1);
  }
}
