import 'package:flutter/material.dart';

class Portrait extends StatelessWidget {
  const Portrait({Key? key, this.photo, this.width, this.radius})
      : super(key: key);

  final int? photo;
  final double? width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    if (photo != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 25),
        child: const Icon(
          Icons.face,
          size: 40,
        ),
        /*
        child: photo! < 30
            ? Image.asset(
                "assets/ima/heads/b${photo! + 1}.png",
                width: width ?? 40,
                height: width ?? 40,
              )
            : Container(
                width: 40,
                height: 40,
                color: Colors.redAccent,
              ),

         */
      );
    } else {
      return Container();
    }
  }
}
