import 'package:flutter/material.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget title;
  final Widget child;

  const MySliverAppBar({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: title,
        background: child,
      ),
    );
  }
}
