import 'package:flutter/material.dart';
import 'package:mkp_hris/router.dart';

import '../utils/lib.dart';
import '../utils/theme.dart';

class BannerPengumuman extends StatelessWidget {
  const BannerPengumuman({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(detailPengumumanPageRoute);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              image: const DecorationImage(
                image: AssetImage(
                  "assets/bg_mkp.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Judul Pengumuman",
                  style: blackTextStyle.copyWith(
                    fontSize: 20,
                    color: kWhiteColor,
                    letterSpacing: 2,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "By Enrico Irawan - 01/01/2022",
                  style: blackTextStyle.copyWith(
                    color: kWhiteColor,
                    letterSpacing: 1.5,
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: 2,
      viewportFraction: 0.8,
      scale: 0.9,
    );
  }
}
