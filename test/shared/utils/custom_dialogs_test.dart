import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:waveglow/core/core_exports.dart';

class _FakeFailure extends Fake implements Failure {}

void main() {
  late CustomDialogs customDialogs;

  setUpAll(() {
    customDialogs = CustomDialogs();
  });

  group("showFailure -", () {
    testWidgets("should show $FailureWidget and show a dialog using Get", (tester) async {
      //arrange
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => customDialogs.showFailure(_FakeFailure()),
                child: const Text("click"),
              ),
            ),
          ),
        ),
      );

      //verification
      expect(find.text('click'), findsOneWidget);

      //act
      await tester.tap(find.text('click'));
      await tester.pumpAndSettle();

      // expect
      expect(Get.isDialogOpen, true);
      expect(find.byType(FailureWidget), findsOneWidget);
    });
  });
}
