import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test/test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("Flutter Auth App Test", () async {
    final emailField = find.byValueKey("email-field");
    final passwordField = find.byValueKey("password-field");
    final signInButton = find.text("Login");
    final mainScreen = find.byType("MainScreen");
    final snackbar = find.byType("SnackBar");

    FlutterDriver driver = await FlutterDriver.connect();
    // setUpAll(() async {
    //   driver = await FlutterDriver.connect();
    // });

    tearDownAll(() async {
      // ignore: unnecessary_null_comparison
      if (driver != null) {
        driver.close();
      }
    });

    test(
        "login fails with incorrect email and password, provides snackbar feedback",
        () async {
      await driver.tap(emailField);
      await driver.enterText("test@testmail.com");
      await driver.tap(passwordField);
      await driver.enterText("test");
      await driver.tap(signInButton);
      await driver.waitFor(snackbar);
      // ignore: unnecessary_null_comparison
      assert(snackbar != null);
      await driver.waitUntilNoTransientCallbacks();
      // ignore: unnecessary_null_comparison
      assert(mainScreen == null);
    });

    test("logs in with correct email and password", () async {
      await driver.tap(emailField);
      await driver.enterText("testing.c98@gmail.com");
      await driver.tap(passwordField);
      await driver.enterText("Chanu25@");
      await driver.tap(signInButton);
      await driver.waitFor(mainScreen);
      // ignore: unnecessary_null_comparison
      assert(mainScreen != null);
      await driver.waitUntilNoTransientCallbacks();
    });
  });
}
