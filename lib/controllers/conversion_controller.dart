import 'package:get/get.dart';
import 'package:wegame/controllers/user_controller.dart';

class ConversionController extends GetxController {
  final inputValue = '0'.obs;
  final conversionResult = ''.obs;
  final UserController userController = Get.find();

  void updateInputValue(String value) {
    inputValue.value = value;
  }

  Future<void> convert() async {
    // Implement conversion logic here
    conversionResult.value = 'Conversion Result for ${inputValue.value}';
    // After successful conversion, update user balance
    await userController.fetchBalance();
  }
}
