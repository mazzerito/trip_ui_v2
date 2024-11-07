import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../dummy_test/example_screen.dart';

class SettingsScreen extends StatefulWidget {
  
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final btnTxtColor = Theme.of(context).colorScheme.onPrimary;
    final btnBgColor = Theme.of(context).colorScheme.primary;
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final textTitle = Theme.of(context).textTheme.bodyLarge;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", 
          style: TextStyle(color: btnTxtColor)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: btnTxtColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Click Switch to change \nDark mode and Light mode!',
              style: TextStyle(
                fontSize: 20,
                color: textTitle?.color
                ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Switch(
            value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
            
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ThemedPage()),
            //     );
            //   },
            //   child: Text('Switch'),
            //   style: ElevatedButton.styleFrom(
            //     // backgroundColor: primaryColor,
            //     foregroundColor: btnTxtColor, 
            //     backgroundColor: btnBgColor,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// fillColor: Theme.of(context).textTheme.bodyLarge?.color,
// color: Theme.of(context).textTheme.displayLarge?.color