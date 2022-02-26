import 'package:flutter/material.dart';

import '../utils/theme.dart';

class PengumumanDetail extends StatelessWidget {
  const PengumumanDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // *Start Header
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/bg_mkp.png",
                  ),
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
            // *End Header

            // *Start Detail Pengumuman
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Detail Pengumuman',
                    style: blackTextStyle.copyWith(
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            // *End Detail Pengumuman

            // *Start Button Back
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Kembali",
                  style: whiteTextStyle.copyWith(
                    letterSpacing: 2,
                  ),
                ),
              ),
            )
            // *End Button Back
          ],
        ),
      ),
    );
  }
}
