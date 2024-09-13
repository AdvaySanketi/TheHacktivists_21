import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';

class Stage1 extends StatefulWidget {
  const Stage1({Key? key}) : super(key: key);

  void test() {}

  @override
  _Stage1State createState() => _Stage1State();
}

class _Stage1State extends State<Stage1> {
  DateTime _selectedDate = DateTime.now();
  late int _selectedCityIndex = -1;
  bool _ageSet = false;
  int _age = 0;
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
  TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedCityIndex = -1;
  }

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
        if (!_showCityTextField) {
          _selectedCityIndex = index;
        }
      });
    }
  }

  Future<bool> validate(BuildContext context) async {
    print(_ageSet);
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
}
