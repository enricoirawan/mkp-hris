import 'package:flutter/material.dart';
import 'package:mkp_hris/model/model.dart';

import '../utils/constant.dart';
import '../utils/lib.dart';
import '../utils/theme.dart';

class KaryawanItem extends StatelessWidget {
  final KaryawanModel karyawan;

  const KaryawanItem({
    Key? key,
    required this.karyawan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "ID",
                  style: blackTextStyle.copyWith(fontSize: 14),
                ),
                Text(
                  (karyawan.id).toString(),
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            karyawan.fotoUrl.isEmpty
                ? const Icon(Icons.account_circle)
                : ImageNetwork(
                    image: publicStorageBaseUrl + karyawan.fotoUrl,
                    height: 50,
                    width: 50,
                    borderRadius: BorderRadius.circular(50),
                    imageCache: CachedNetworkImageProvider(
                      publicStorageBaseUrl + karyawan.fotoUrl,
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  karyawan.nama,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  karyawan.jabatan,
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
