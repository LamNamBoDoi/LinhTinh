import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import '../model/language_model.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({required BuildContext context}) {
    return AppConstants.languages;
  }
}
