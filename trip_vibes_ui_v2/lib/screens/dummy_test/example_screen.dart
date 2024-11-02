import 'package:flutter/material.dart';

class ThemedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access theme colors
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: primaryColor);

    return Scaffold(
      appBar: AppBar(
        title: Text('Themed Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use primary color for text
            Text(
              'Primary Color Text',
              style: textStyle,
            ),
            SizedBox(height: 20),
            // Button with secondary color
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor, // Use theme's secondary color
              ),
              onPressed: () {},
              child: Text('Button with Secondary Color'),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: primaryColor,
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
