import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/models/clothing.dart';
import 'package:sling/widgets/filters_modal.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(64);

  VoidCallback? callback;

  HomeAppBar({required this.callback});
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return _buildAppBar(context);
  }

  void rewind() {
    widget.callback?.call();
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      rewind();
                    },
                    child: SvgPicture.asset(
                      'assets/icons/previous.svg',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  Text(
                    "Sling",
                    style: TextStyle(
                      color: appBlack,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Aladin',
                    ),
                  ),
                  SizedBox(height: 6.0),
                ],
              ),
            ),
            EaseInWidget(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return const FiltersModal();
                  },
                );
              },
              child: SvgPicture.asset(
                'assets/icons/filter.svg',
                height: 30.0,
                width: 30.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EaseInWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const EaseInWidget({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}
