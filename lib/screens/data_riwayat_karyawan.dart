import 'package:flutter/material.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/screens/screens.dart';

import '../utils/theme.dart';

class DataRiwayatKaryawanScreen extends StatelessWidget {
  final KaryawanModel karyawan;
  const DataRiwayatKaryawanScreen({
    Key? key,
    required this.karyawan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Text(
            "Riwayat ${karyawan.nama}",
            style: whiteTextStyle,
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Riwayat Cuti",
                ),
              ),
              Tab(
                child: Text(
                  "Riwayat Absen",
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RiwayatCutiScreen(
              karyawanId: karyawan.id,
              showAppBar: false,
            ),
            RiwayatAbsenScreen(
              karyawanId: karyawan.id,
              showAppBar: false,
            ),
          ],
        ),
      ),
    );
  }
}
