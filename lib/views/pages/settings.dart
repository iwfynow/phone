import 'package:flutter/material.dart';
import 'package:phone_book/generated/l10n.dart';
import 'package:phone_book/viewmodels/setting_view_model.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
  final settingsViewModel = Provider.of<SettingViewModel>(context);
  int themeIndex = settingsViewModel.themeIndex;
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: const Icon(Icons.arrow_back)),
      title: Text(S.of(context).settings),),
      body: Column(children: [
            RadioListTile(value: 0, groupValue: themeIndex,
            title: Text(S.of(context).system_them),
            onChanged: (value){
              setState(() {
                themeIndex = value!;
                settingsViewModel.themeIndex = value;
              });
            }),
            RadioListTile(value: 1, groupValue: themeIndex,
            title: Text(S.of(context).light_theme),
            onChanged: (value){
              setState(() {
                themeIndex = value!;
                settingsViewModel.themeIndex = value;
              });
            }),
            RadioListTile(value: 2, groupValue: themeIndex,
            title: Text(S.of(context).dark_theme),
            onChanged: (value){
              setState(() {
                themeIndex = value!;
                settingsViewModel.themeIndex = value;
              });
            }),
           ListTile(
              title: Text(S.of(context).language),
              trailing: DropdownButton<String>(
                value: settingsViewModel.language,
                onChanged: (value) {
                  if (value != null) settingsViewModel.changeLanguage(value);
                },
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ru', child: Text('Русский')),
                ],
              ),
            ),
          ],),
    );
  }
}