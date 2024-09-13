import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sling/appTheme.dart';

class RatingBottomSheet extends StatefulWidget {
  @override
  _RatingBottomSheetState createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  double rating = 0.0;
  List<int> ratings = [2, 1, 5, 2, 4, 3];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.9),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), topLeft: Radius.circular(24))),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                height: 92,
                width: 92,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.transparent,
                          offset: Offset(0, 3),
                          blurRadius: 6)
                    ],
                    border:
                        Border.all(width: 8.0, color: Colors.deepPurpleAccent)),
                child: Image.asset('assets/1.avif'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 72.0, vertical: 16.0),
                child: Text(
                  'Chinle Bolster Traditional Weaving Pillow',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text(
                    '4.0',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
                Column(
                  children: <Widget>[
                    RatingBar(
//                      borderColor: Color(0xffFF8993),
//                      fillColor: Color(0xffFF8993),
                      ignoreGestures: true,
                      itemSize: 20,
                      allowHalfRating: true,
                      initialRating: 4,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      ratingWidget: RatingWidget(
                        empty: Icon(Icons.favorite_border,
                            color: Color(0xffFF8993), size: 20),
                        full: Icon(
                          Icons.favorite,
                          color: Color(0xffFF8993),
                          size: 20,
                        ),
                        half: SizedBox(),
                      ),
                      onRatingUpdate: (value) {
                        setState(() {
                          rating = value;
                        });
                        print(value);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('from 25 people'),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Align(
                alignment: Alignment(-1, 0), child: Text('Recent Reviews')),
          ),
          Column(
            children: <Widget>[
              ...ratings
                  .map((val) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: appBlack,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: CircleAvatar(
                              maxRadius: 14,
                              backgroundImage:
                                  AssetImage('assets/icons/etherealLogo.jpg'),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'The Hacktivists',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '10 am',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: RatingBar(
                                    ignoreGestures: true,
                                    itemSize: 20,
                                    allowHalfRating: true,
                                    initialRating: val.toDouble(),
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    ratingWidget: RatingWidget(
                                      empty: Icon(Icons.favorite_border,
                                          color: Color(0xffFF8993), size: 20),
                                      full: Icon(
                                        Icons.favorite,
                                        color: Color(0xffFF8993),
                                        size: 20,
                                      ),
                                      half: SizedBox(),
                                    ),
                                    onRatingUpdate: (value) {
                                      setState(() {
                                        rating = value;
                                      });
                                      print(value);
                                    },
                                  ),
                                ),
                                Text(
                                  'Great Product, Worth the price',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '21 likes',
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        '1 Comment',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )))
                  .toList()
            ],
          )
        ],
      ),
    );
  }
}
