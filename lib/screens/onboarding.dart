import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/main.dart';
import 'package:sling/models/clothing.dart';
import 'package:sling/screens/stage1.dart';
import 'package:sling/screens/stage2.dart';

class OnBoarding extends StatefulWidget {
  final int stateValue;
  OnBoarding({Key? key, required this.stateValue}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  DateTime _selectedDate = DateTime.now();
  late int _selectedCityIndex = -1;
  bool _ageSet = false;
  int _age = 0;
  late List<bool> _selectedStates = List.generate(12, (index) => false);
  List<String> _selectedStatesFinal = [];
  List<dynamic> results = [];
  int _selectedCount = 0;
  final List<String> _cities = [
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Hyderabad',
    'Ahmedabad',
    'Chandigarh',
    'Lucknow',
    'Chennai',
    'Pune',
    'Kolkata',
    'Jaipur',
    'Others'
  ];
  final List<String> _citiesIcons = [
    'assets/Cities/mumbai.svg',
    'assets/Cities/delhi.svg',
    'assets/Cities/bengaluru.svg',
    'assets/Cities/hyderabad.svg',
    'assets/Cities/ahemdabad.svg',
    'assets/Cities/chandigarh.svg',
    'assets/Cities/lucknow.svg',
    'assets/Cities/chennai.svg',
    'assets/Cities/pune.svg',
    'assets/Cities/kolkata.svg',
    'assets/Cities/jaipur.svg',
    'assets/Cities/others.svg'
  ];
  final List<String> _monthAbbreviations = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  bool _showDatePicker = false;
  bool _showCityTextField = false;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  FocusNode _dateNode = FocusNode();
  FocusNode _monthNode = FocusNode();
  FocusNode _yearNode = FocusNode();

  TextEditingController _cityController = TextEditingController();

  String _formatDate(DateTime date) {
    return "${_monthAbbreviations[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  String _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    _age = age;
    return age.toString();
  }

  void _updateSelectedDate() {
    FocusScope.of(context).unfocus();
    int day = int.tryParse(_dateController.text) ?? _selectedDate.day;
    int month = int.tryParse(_monthController.text) ?? _selectedDate.month;
    int year = int.tryParse(_yearController.text) ?? _selectedDate.year;
    setState(() {
      _selectedDate = DateTime(year, month, day);
      _showDatePicker = true;
      _ageSet = true;
    });
  }

  void _handleCitySelection(int index) {
    if (_cities[index] == 'Others') {
      setState(() {
        _showCityTextField = !_showCityTextField;
        _selectedCityIndex = -1;
      });
    } else {
      setState(() {
        _selectedCityIndex = index;
        _showCityTextField = false;
      });
    }
  }

  Future<bool> validate1() async {
    if (_ageSet && int.parse(_calculateAge(_selectedDate)) >= 16) {
      if (_showCityTextField) {
        if (_cityController.text.isNotEmpty) {
          var resp = await APIHelper.getOnboard({
            'city': _cityController.text,
            'age': int.parse(_calculateAge(_selectedDate))
          });
          return resp['success'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('City is required'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
      } else {
        if (_selectedCityIndex != -1) {
          var resp = await APIHelper.getOnboard({
            'city': _cities[_selectedCityIndex],
            'age': int.parse(_calculateAge(_selectedDate))
          });
          return resp['success'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select a city'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must be at least 16 years old'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
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

  Future<bool> validate2() async {
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
      return false;
    }
  }

  Future<bool> _validatePage(int pageIndex) async {
    switch (pageIndex) {
      case 0:
        print("Stage1");
        return await validate1();
      case 1:
        print("Stage2");
        return await validate2();
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedStates = List.generate(12, (index) => false);
    _selectedDate = DateTime.now();
    _selectedCityIndex = -1;
    _fetchRecommendation();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: _introKey,
      showSkipButton: false,
      showDoneButton: true,
      showNextButton: true,
      initialPage: widget.stateValue,
      rawPages: [Stage1(), Stage2()],
      isProgress: false,
      freeze: true,
      animationDuration: 500,
      nextFlex: 700,
      overrideDone: SizedBox(
        width: double.infinity,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: MaterialButton(
              onPressed: () async {
                bool success = await _validatePage(1);
                print("Success: $success.");
                if (success == true) {
                  await AuthService.setLoggedIn(true);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => MainApp()));
                }
              },
              color: Colors.black,
              height: 60,
              child: Center(
                child: Text(
                  'Start My Journey',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )),
      ),
      overrideNext: SizedBox(
        width: double.infinity,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: MaterialButton(
              onPressed: () async {
                bool success = await _validatePage(0);
                if (success == true) {
                  _introKey.currentState?.next();
                }
              },
              color: Colors.black,
              height: 60,
              child: Center(
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )),
      ),
    );
  }

  Widget Stage1() {
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
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: Text(
                "Tell Us About Yourself",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: appBlack,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 12.0, bottom: 12.0),
              child: Text(
                "Enter your Birthdate",
                style: TextStyle(
                  fontSize: 16.0,
                  color: appGrey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 0.0, bottom: 12.0),
              child: !_showDatePicker
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _dateController,
                                focusNode: _dateNode,
                                decoration: InputDecoration(
                                  hintText: 'DD',
                                  hintStyle: TextStyle(color: appGrey),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    borderSide: BorderSide(color: appGrey),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (text) {
                                  if (text.length == 2) {
                                    _monthNode.requestFocus();
                                  }
                                  if (text.length == 2 &&
                                      _monthController.text.length == 2 &&
                                      _yearController.text.length == 4) {
                                    if (int.tryParse(_calculateAge(DateTime(
                                            int.parse(_yearController.text),
                                            int.parse(_monthController.text),
                                            int.parse(text))))! >=
                                        16) {
                                      _updateSelectedDate();
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _monthController,
                                focusNode: _monthNode,
                                decoration: InputDecoration(
                                  hintText: 'MM',
                                  hintStyle: TextStyle(color: appGrey),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    borderSide: BorderSide(color: appGrey),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (text) {
                                  if (text.length == 2) {
                                    _yearNode.requestFocus();
                                  }
                                  if (_dateController.text.length == 2 &&
                                      text.length == 2 &&
                                      _yearController.text.length == 4) {
                                    if (int.tryParse(_calculateAge(DateTime(
                                            int.parse(_yearController.text),
                                            int.parse(text),
                                            int.parse(
                                                _dateController.text))))! >=
                                        16) {
                                      _updateSelectedDate();
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _yearController,
                                focusNode: _yearNode,
                                decoration: InputDecoration(
                                  hintText: 'YYYY',
                                  hintStyle: TextStyle(color: appGrey),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    borderSide: BorderSide(color: appGrey),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (text) {
                                  if (_dateController.text.length == 2 &&
                                      _monthController.text.length == 2 &&
                                      text.length == 4) {
                                    if (int.tryParse(_calculateAge(DateTime(
                                            int.parse(text),
                                            int.parse(_monthController.text),
                                            int.parse(
                                                _dateController.text))))! >=
                                        16) {
                                      _updateSelectedDate();
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                      ],
                    )
                  : Container(
                      height: 70.0,
                      margin: EdgeInsets.symmetric(vertical: 12.0),
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: appGrey),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(_selectedDate),
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: appBlack,
                            ),
                          ),
                          Text(
                            "${_calculateAge(_selectedDate)} years old",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w200,
                              color: appGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            _ageSet
                ? Container(
                    height: _showCityTextField ? 350 : 435,
                    width: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Select your City",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 1.0,
                            ),
                            itemCount: _cities.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  _handleCitySelection(index);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                          _citiesIcons[index],
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          _cities[index],
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                    if (index == _selectedCityIndex)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: _showCityTextField
                  ? TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: 'Enter City',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          borderSide: BorderSide(color: appGrey),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    )
                  : SizedBox(height: 0),
            ),
            SizedBox(
              height: 35.0,
            )
          ],
        ),
      ),
    );
  }

  Widget Stage2() {
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
