import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(color: Colors.brown[300], fontSize: 18),
            children: [
              TextSpan(text: 'You have not saved anything yet!!!\n'),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.bookmark_outline,
                  color: Colors.brown[300],
                  size: 24,
                ),
              ),
              TextSpan(text: '\nPress button to save recipes.'),
            ],
          ),
        ),
      ),
    );
  }
}
