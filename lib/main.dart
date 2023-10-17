import "package:flutter/material.dart";
import 'package:ui_one/features/auth/presentation/pages/app_widget.dart';
import 'package:ui_one/features/auth/presentation/pages/sign_in_page.dart';

import 'package:ui_one/service._locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  setupLocator();
  runApp(const AppWidget());
}
