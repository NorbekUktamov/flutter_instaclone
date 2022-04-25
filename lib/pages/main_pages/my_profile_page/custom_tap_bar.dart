import 'package:flutter/material.dart';

class CustomTapBar extends SliverPersistentHeaderDelegate {
  final double maxEx;
  final double minEx;

  CustomTapBar({required this.maxEx, required this.minEx});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: const TabBar(
        indicatorWeight: 1.5,
        indicatorColor: Colors.black,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        padding: EdgeInsets.only(bottom: 2),
        tabs: [
          Tab(
            icon: Icon(Icons.grid_on),
          ),
          Tab(
            icon: Icon(Icons.assignment_ind_outlined),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maxEx;

  @override
  // TODO: implement minExtent
  double get minExtent => minEx;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
