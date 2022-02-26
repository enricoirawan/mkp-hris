import 'package:flutter/material.dart';

import '../utils/lib.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FadeShimmer(
      height: 30,
      width: 100,
      radius: 4,
      highlightColor: Color(0xffF9F9FB),
      baseColor: Color(0xffE6E8EB),
    );
  }
}
