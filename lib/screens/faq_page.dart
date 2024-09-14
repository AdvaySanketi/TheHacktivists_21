import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horcrux/appTheme.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Panel> panels = [
    Panel(
      'How does the swiping feature work in the app?',
      'In the app, you can swipe right to like a product, swipe left to dislike it, and swipe up to add it to your cart.',
      false,
    ),
    Panel(
      'Can I undo a swipe action?',
      'Yes, you can undo a swipe action by pressing the rewind button on the top-left corner of the Home Screen.',
      false,
    ),
    Panel(
      'What happens when I like a product?',
      'When you swipe right to like a product, it will be added to your Wishlist, which you can find in your profile.',
      false,
    ),
    Panel(
      'How do I remove a product from my wishlist?',
      'To remove a product from your wishlist, click on the item you want to delete and click on the heart icon.',
      false,
    ),
    Panel(
      'Will my swiping activity be used to personalize recommendations?',
      'Yes, your swiping activity helps the app personalize product recommendations based on your preferences.',
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appBlack,
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'FAQ',
          style: TextStyle(color: Colors.grey[700]),
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, bottom: 16.0),
                child: Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              ...panels
                  .map(
                    (panel) => ExpansionTile(
                      title: Text(
                        panel.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          color: Colors.grey[200],
                          child: Text(
                            panel.content,
                            style: TextStyle(
                              color: appBlack,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class Panel {
  String title;
  String content;
  bool expanded;

  Panel(this.title, this.content, this.expanded);
}
