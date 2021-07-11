import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const headerMaxExtent = 272.0;
const _headerMinExtent = kToolbarHeight;

class ScrollHeaderDelegate extends SliverPersistentHeaderDelegate {
  ScrollHeaderDelegate(this._topPadding, this.onReload);

  final double _topPadding;
  final Function()? onReload;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final shrinkRelative = max(minExtent, maxExtent - shrinkOffset);
    final shrinkPart = (shrinkRelative - minExtent) / (maxExtent - minExtent);
    return CustomSingleChildLayout(
      delegate: _HeaderLayoutDelegate(shrinkRelative, minExtent),
      child: Stack(
        children: [
          AppBar(
            leading: Container(),
            title: Text('Scroll screen'),
            actions: onReload != null
                ? [
                    CupertinoButton(
                      child: Icon(Icons.refresh, color: Colors.white),
                      onPressed: onReload,
                    )
                  ]
                : null,
          ),
          IgnorePointer(
            child: Opacity(
              opacity: Curves.easeOutCirc.transform(shrinkPart),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('asset/image/inno_back.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: shrinkPart * 24.0, bottom: shrinkPart * 24.0),
              child: SizedBox(
                height: kToolbarHeight + shrinkPart * 32.0,
                width: kToolbarHeight + shrinkPart * 32.0,
                child: Center(
                  child: Image.asset(
                    'asset/image/surf_logo.png',
                    height: 40.0 + shrinkPart * 64.0,
                    width: 40.0 + shrinkPart * 64.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => headerMaxExtent;

  @override
  double get minExtent => _headerMinExtent + _topPadding;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class _HeaderLayoutDelegate extends SingleChildLayoutDelegate {
  _HeaderLayoutDelegate(this.maxHeight, this.minHeight);

  final double maxHeight;
  final double minHeight;

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return true;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }
}
