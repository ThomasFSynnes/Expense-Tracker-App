import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays an options overlay where the user can change
/// the languge of the app
class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Options();
  }
}

class _Options extends State<Options> {
  @override
  Widget build(BuildContext context) {
    //Change language to ENG
    void setLanguageENG() {
      context.setLocale(const Locale("en", "US"));
    }

    //Change language to NO
    void setLanguageNO() {
      context.setLocale(const Locale("no", "NO"));
    }

    // Cancel button
    var cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("button.cancel".tr()),
    );

    //Select Languag Butons
    var selectLanguageButtons = Column(
      children: [
        Text("options.selectLanguage".tr()),
        const SizedBox(height: 24),

        //ENG
        ElevatedButton(
          onPressed: setLanguageENG,
          child: const Text("English"),
        ),

        //NO
        ElevatedButton(
          onPressed: setLanguageNO,
          child: const Text("Norks"),
        ),
      ],
    );

    //Options Structure
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            selectLanguageButtons,
            const SizedBox(height: 24),
            cancelButton,
            const Row(), //Todo: replace to get max width.
          ],
        ));
  }
}
