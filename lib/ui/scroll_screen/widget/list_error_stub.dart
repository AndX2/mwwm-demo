
import 'package:flutter/material.dart';

class ListErrorStub extends StatelessWidget {
  const ListErrorStub(
    this.error,
    this.maxListHeight,
    this.onReload, {
    Key? key,
  }) : super(key: key);

  final dynamic error;
  final double maxListHeight;
  final Function() onReload;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxListHeight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              child: Container(
                height: 104.0,
                width: 104.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('asset/image/error.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 48.0),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48.0),
            ElevatedButton(onPressed: onReload, child: Text('Попробовать еще раз')),
          ],
        ),
      ),
    );
  }
}