import 'package:flutter/material.dart';
import 'package:horcrux/appTheme.dart';

class FiltersModal extends StatefulWidget {
  const FiltersModal({Key? key}) : super(key: key);

  @override
  _FiltersModalState createState() => _FiltersModalState();
}

class _FiltersModalState extends State<FiltersModal> {
  bool _showBrandsModal = false;
  double _bottomInset = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is OverscrollNotification) {
            setState(() {
              _bottomInset = notification.metrics.viewportDimension -
                  notification.metrics.maxScrollExtent;
            });
          }
          return false;
        },
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AppBar(
                  automaticallyImplyLeading: false, // Remove back arrow
                  title: Center(
                    child: Text(
                      'Filters',
                      style: TextStyle(color: appBlack), // Text color
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return BrandsModal();
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Brands', style: TextStyle(color: appBlack)),
                          Icon(Icons.keyboard_arrow_right, color: appBlack),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              child: PriceRangeModal(),
                              height:
                                  MediaQuery.of(context).viewInsets.bottom == 0
                                      ? 250
                                      : MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          400,
                            );
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Price Range',
                              style: TextStyle(color: appBlack)),
                          Icon(Icons.keyboard_arrow_right, color: appBlack),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ColorsModal();
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Colors/Patterns',
                              style: TextStyle(color: appBlack)), // Text color
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: appBlack,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return TypesModal();
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Product Type',
                              style: TextStyle(color: appBlack)), // Text color
                          Icon(Icons.keyboard_arrow_right, color: appBlack),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: appBlack,
                            minimumSize: Size(double.infinity, 50),
                            maximumSize: Size(double.infinity, 50)),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: appBlack),
                          minimumSize:
                              Size(double.infinity, 50), // Stretch across width
                        ),
                        child: Text(
                          'Clear Filters',
                          style: TextStyle(color: appBlack),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}

class BrandsModal extends StatefulWidget {
  @override
  _BrandsModalState createState() => _BrandsModalState();
}

class _BrandsModalState extends State<BrandsModal> {
  List<String> selectedBrands = [];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Brands', textAlign: TextAlign.center),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Brands',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildListItem('Urban Outfit'),
                    _buildListItem('Denim Dreams'),
                    _buildListItem('Style Haven'),
                    _buildListItem('Trendy Styles'),
                    _buildListItem('Fashion Empire'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedBrands);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: appBlack,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedBrands.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: appBlack),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(color: appBlack),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String brandName) {
    final isSelected = selectedBrands.contains(brandName);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedBrands.remove(brandName);
          } else {
            selectedBrands.add(brandName);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(brandName),
          trailing: isSelected ? Icon(Icons.check) : null,
        ),
      ),
    );
  }
}

class PriceRangeModal extends StatefulWidget {
  @override
  _PriceRangeModalState createState() => _PriceRangeModalState();
}

class _PriceRangeModalState extends State<PriceRangeModal> {
  final minController = TextEditingController();
  final maxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Price Range', textAlign: TextAlign.center),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Min'),
                  Text('Max'),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      // controller: minController,
                      decoration: InputDecoration(
                        hintText: '0',
                        prefixIcon: Icon(Icons.currency_rupee),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '-',
                    style: TextStyle(fontSize: 35),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: TextField(
                      // controller: _maxController,
                      decoration: InputDecoration(
                        hintText: '1000',
                        prefixIcon: Icon(Icons.currency_rupee),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: appBlack,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: appBlack),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(color: appBlack),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }
}

class TypesModal extends StatefulWidget {
  @override
  _TypesModalState createState() => _TypesModalState();
}

class _TypesModalState extends State<TypesModal> {
  List<String> selectedTypes = ['All Dresses'];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Types', textAlign: TextAlign.center),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Types',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildListItem('All Dresses'),
                    _buildListItem('Mini Dresses'),
                    _buildListItem('Crop Tops'),
                    _buildListItem('Long Sleeved Dresses'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedTypes);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: appBlack,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTypes.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: appBlack),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(color: appBlack),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String brandName) {
    final isSelected = selectedTypes.contains(brandName);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedTypes.remove(brandName);
          } else {
            selectedTypes.add(brandName);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(brandName),
          trailing: isSelected ? Icon(Icons.check) : null,
        ),
      ),
    );
  }
}

class ColorsModal extends StatefulWidget {
  @override
  _ColorsModalState createState() => _ColorsModalState();
}

class _ColorsModalState extends State<ColorsModal> {
  List<String> selectedBrands = [];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Colors/Patterns', textAlign: TextAlign.center),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Colors or Patterns',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildListItem('Stripe'),
                    _buildListItem('Floral'),
                    _buildListItem('Graphic'),
                    _buildListItem('Print'),
                    _buildListItem('Sequin'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedBrands);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: appBlack,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedBrands.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: appBlack),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(color: appBlack),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String brandName) {
    final isSelected = selectedBrands.contains(brandName);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedBrands.remove(brandName);
          } else {
            selectedBrands.add(brandName);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(brandName),
          trailing: isSelected ? Icon(Icons.check) : null,
        ),
      ),
    );
  }
}
