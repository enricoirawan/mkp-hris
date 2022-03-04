import 'package:flutter/material.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/lib.dart';
import '../utils/theme.dart';

class PengumumanDetail extends StatelessWidget {
  final PengumumanModel pengumumanModel;
  const PengumumanDetail({Key? key, required this.pengumumanModel})
      : super(key: key);

  void _onDownloadAttachment(String url, BuildContext context) async {
    if (!await launch(url)) {
      CustomSnackbar.buildErrorSnackbar(context, "Tidak bisa membuka link");
    }
  }

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
                    pengumumanModel.title,
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
                    "By ${pengumumanModel.createdBy} - ${pengumumanModel.createdAt}",
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
                    pengumumanModel.detail,
                    style: blackTextStyle.copyWith(
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            // *End Detail Pengumuman

            pengumumanModel.attachmentUrl.isEmpty
                ? const SizedBox()
                : TextButton.icon(
                    onPressed: () => _onDownloadAttachment(
                        pengumumanModel.attachmentUrl, context),
                    icon: const Icon(Icons.attach_file),
                    label: Text(
                      "Dokumen",
                      style: primaryTextStyle,
                    ),
                  ),

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
