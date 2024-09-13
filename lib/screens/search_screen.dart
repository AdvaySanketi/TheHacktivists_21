import 'package:flutter/material.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/main.dart';
import 'package:sling/models/clothing.dart';
import 'package:sling/screens/view_product_page.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  List<dynamic> searchResults = [];
  bool isSearching = false;
  List<dynamic> trendingResults = [];

  @override
  void initState() {
    super.initState();
    _fetchTrending();
  }

  Future<void> _fetchTrending() async {
    try {
      List<ClothingItem> clothingProducts;
      Map<String, dynamic> resp = await APIHelper.getRecommendation();
      clothingProducts = resp['response'].toList();
      setState(() {
        trendingResults = clothingProducts;
      });
    } catch (e) {
      print("Error fetching recommendation: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffF9F9F9),
      child: Container(
        margin: const EdgeInsets.only(top: kToolbarHeight),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color(0xFFF5F5F5),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              top: 15.0,
                              bottom: 15.0,
                              left: 1.0,
                              right: 1.0,
                            ),
                            child: Image.asset(
                              'assets/icons/search.png',
                              fit: BoxFit.scaleDown,
                              height: 20.0,
                              width: 20.0,
                              color: appGrey,
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                              top: 15.0,
                              bottom: 15.0,
                              left: 1.0,
                              right: 1.0,
                            ),
                            child: Image.asset(
                              'assets/icons/filter.png',
                              fit: BoxFit.scaleDown,
                              height: 20.0,
                              width: 20.0,
                              color: appGrey,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                            if (searchText.isEmpty) {
                              searchResults = [];
                              isSearching = false;
                            }
                          });
                        },
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            search(value);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    searchResults.isNotEmpty && isSearching
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 16),
                            child: Text(
                              'Search Results For "$searchText"',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          )
                        : searchResults.isEmpty && isSearching
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Text(
                                    'Not Found',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "Sorry, the keyword you entered can not be found, please check again or search with another keyword.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Trending Today',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
            ];
          },
          body: isSearching
              ? Container(
                  padding:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewProductPage(
                                product: ClothingItem(
                                  id: searchResults[index]['id'],
                                  name: searchResults[index]["title"],
                                  seller: searchResults[index]["shop"][0]
                                      ["name"],
                                  price: searchResults[index]['variants']
                                      ["price"],
                                  image: searchResults[index]["productImage"][0]
                                      ['source'],
                                  images: [
                                    for (Map<String, dynamic> item
                                        in searchResults[index]["productImage"])
                                      item['source']!
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: ProductCard(
                          imagePath: searchResults[index]["productImage"][0]
                              ["source"],
                          dressName: searchResults[index]["title"],
                          seller: searchResults[index]["shop"][0]["name"],
                          price:
                              '₹${searchResults[index]['variants']["price"]}',
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  padding:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 7.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: trendingResults.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewProductPage(
                                product: ClothingItem(
                                  id: trendingResults[index].id,
                                  name: trendingResults[index].name,
                                  seller: trendingResults[index].seller,
                                  price: trendingResults[index].price,
                                  image: trendingResults[index].image,
                                  images: trendingResults[index].images,
                                ),
                              ),
                            ),
                          );
                        },
                        child: TrendingCard(
                          imagePath: trendingResults[index].image,
                          dressName: trendingResults[index].name,
                          seller: trendingResults[index].seller,
                          price: '₹${trendingResults[index].price}',
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  void search(String query) async {
    List<dynamic> results;
    var resp = await APIHelper.getSearch(query);
    results = resp['response'].toList();

    setState(() {
      searchResults = results;
      isSearching = true;
    });
  }
}

class TrendingCard extends StatelessWidget {
  final String imagePath;
  final String dressName;
  final String seller;
  final String price;

  const TrendingCard({
    required this.imagePath,
    required this.dressName,
    required this.seller,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dressName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      seller,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String dressName;
  final String seller;
  final String price;

  const ProductCard({
    required this.imagePath,
    required this.dressName,
    required this.seller,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    child: imagePath != 'Null'
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(
                            color: Colors.grey[300],
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "No Preview \n Available",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            )),
                  )),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dressName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      seller,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
