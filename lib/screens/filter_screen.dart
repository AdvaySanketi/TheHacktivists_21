import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  // Define variables to store filter selections
  bool filter1 = false;
  bool filter2 = false;
  bool filter3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              // Clear filters and close the screen
              setState(() {
                filter1 = false;
                filter2 = false;
                filter3 = false;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Filter 1
          CheckboxListTile(
            title: Text('Filter 1'),
            value: filter1,
            onChanged: (value) {
              setState(() {
                filter1 = value ?? false;
              });
            },
          ),
          // Filter 2
          CheckboxListTile(
            title: Text('Filter 2'),
            value: filter2,
            onChanged: (value) {
              setState(() {
                filter2 = value ?? false;
              });
            },
          ),
          // Filter 3
          CheckboxListTile(
            title: Text('Filter 3'),
            value: filter3,
            onChanged: (value) {
              setState(() {
                filter3 = value ?? false;
              });
            },
          ),
          // Apply button
          ElevatedButton(
            onPressed: () {
              // Apply filters and close the screen
              // You can use the selected filter values here
              Navigator.pop(context);
            },
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
