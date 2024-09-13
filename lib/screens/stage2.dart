import 'package:flutter/material.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/models/clothing.dart';

class Stage2 extends StatefulWidget {
  const Stage2({Key? key}) : super(key: key);

  @override
  _Stage2State createState() => _Stage2State();
}

class _Stage2State extends State<Stage2> {
  late List<bool> _selectedStates = [];
  List<String> _selectedStatesFinal = [];
  List<dynamic> results = [];
  int _selectedCount = 0;

  @override
  void initState() {
    super.initState();
    _selectedStates = List.generate(12, (index) => false);
    _fetchRecommendation();
  }

  Future<void> _fetchRecommendation() async {
    try {
      List<ClothingItem> clothingProducts;
      Map<String, dynamic> resp = await APIHelper.getRecommendation();
      clothingProducts = resp['response'].toList();
      setState(() {
        results = clothingProducts;
        results.add(results[4]);
        results.add(results[3]);
      });
    } catch (e) {
      print("Error fetching recommendation: $e");
    }
  }

  Future<bool> validate(BuildContext context) async {
    print(_selectedStatesFinal);
    if (_selectedStatesFinal.length >= 3) {
      var resp = await APIHelper.getOnboard({"style": _selectedStatesFinal});
      return resp['success'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select atleast 3 Styles'),
          duration: Duration(seconds: 2),
        ),
      );
      print("hereee");
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                "Nearly There!",
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: appBlack),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 12.0,
                bottom: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose your Vibe",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: appGrey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Select 3 or more of the given Styles",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: appGrey,
                    ),
                  ),
                  SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(results.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          if (!_selectedStates[index]) {
                            setState(() {
                              _selectedStates[index] = true;
                              _selectedCount += 1;
                            });
                            _selectedStatesFinal.add(results[index].id);
                          } else {
                            setState(() {
                              _selectedStates[index] = false;
                              _selectedCount -= 1;
                            });
                            _selectedStatesFinal.remove(results[index].id);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    results[index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (_selectedStates[index])
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
