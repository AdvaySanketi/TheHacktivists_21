import 'package:flutter/material.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/models/clothing.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Past Orders'),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.only(bottom: 50, left: 16.0, right: 16.0),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You have not ordered anything yet :(',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                "Try buying some products.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ))),
      // body: ListView.builder(
      //   itemCount: orders.length,
      //   itemBuilder: (context, index) {
      //     return Container(
      //         decoration: BoxDecoration(color: Colors.white),
      //         child: _buildOrderCard(context, orders[index]));
      //   },
      // ),
    );
  }

  // Widget _buildOrderCard(BuildContext context, Order order) {
  //   return Container(
  //     color: Colors.white,
  //     margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     // elevation: 4.0,
  //     // shape: RoundedRectangleBorder(
  //     //   borderRadius: BorderRadius.circular(12.0),
  //     // ),
  //     child: InkWell(
  //       onTap: () {
  //         // Handle tap on order card
  //       },
  //       child: Padding(
  //         padding: EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 _buildStatusIcon(
  //                     order.status == 1 ? "Delivered" : "Processing"),
  //                 SizedBox(width: 18.0),
  //                 Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Order #${order.id}',
  //                         style: TextStyle(
  //                           fontSize: 16.0,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       SizedBox(height: 4.0),
  //                       Text(
  //                         '₹${order.totalPrice}    ${order.orderedAt}',
  //                         style: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Colors.grey[700],
  //                         ),
  //                       ),
  //                     ])
  //               ],
  //             ),
  //             SizedBox(height: 16.0),
  //             Divider(height: 20.0, thickness: 1.0, color: Colors.grey[300]),
  //             SizedBox(height: 16.0),
  //             _buildItemCarousel(order.products),
  //             SizedBox(height: 16.0),
  //             Divider(height: 20.0, thickness: 1.0, color: Colors.grey[300]),
  //             SizedBox(height: 16.0),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: ElevatedButton(
  //                     onPressed: () {},
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: appBlack,
  //                       padding: EdgeInsets.all(15),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                     ),
  //                     child: Text(
  //                       order.status == 1 ? 'Rate Order' : 'Track Order',
  //                       style: TextStyle(color: Colors.white, fontSize: 16),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildStatusIcon(String status) {
    IconData iconData;
    Color iconColor;
    switch (status) {
      case 'Delivered':
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case 'Processing':
        iconData = Icons.watch_later;
        iconColor = Colors.orange;
        break;
      case 'Cancelled':
        iconData = Icons.cancel;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.error;
        iconColor = Colors.grey;
    }
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        child: Icon(
          iconData,
          color: iconColor,
          size: 50,
        ));
  }

  Widget _buildItemCarousel(List<ClothingItem> items) {
    return SizedBox(
      height: 120.0,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                items[index].image,
                width: 100.0,
                height: 20.0,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
