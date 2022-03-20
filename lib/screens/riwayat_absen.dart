import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/utils/lib.dart';

import '../utils/theme.dart';

class RiwayatAbsenScreen extends StatefulWidget {
  final int karyawanId;
  final bool showAppBar;

  const RiwayatAbsenScreen({
    Key? key,
    required this.karyawanId,
    required this.showAppBar,
  }) : super(key: key);

  @override
  State<RiwayatAbsenScreen> createState() => _RiwayatAbsenScreenState();
}

class _RiwayatAbsenScreenState extends State<RiwayatAbsenScreen> {
  final AbsensiCubit _absensiCubit = getIt<AbsensiCubit>();

  @override
  void initState() {
    super.initState();
    _absensiCubit.getHistoryAbsensi(widget.karyawanId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              title: Text(
                "Riwayat Absen Saya",
                style: whiteTextStyle,
              ),
            )
          : PreferredSize(
              child: Container(),
              preferredSize: const Size(0, 0),
            ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: BlocBuilder<AbsensiCubit, AbsensiState>(
          builder: (context, state) {
            if (state is GetListAbsensiSuccess) {
              List<AbsensiModel> listAbsensi = state.listAbsen;

              if (listAbsensi.isEmpty) {
                return Center(
                  child: Text(
                    "Belum ada riwayat absensi yang ditemukan",
                    style: blackTextStyle,
                  ),
                );
              }

              return ListView.builder(
                itemCount: listAbsensi.length,
                itemBuilder: (context, index) {
                  AbsensiModel absensi = listAbsensi[index];
                  DateTime checkIn = DateTime.parse(
                      absensi.tanggalAbsensi + " " + absensi.waktuCheckIn);
                  DateTime checkOut = DateTime.parse(
                      absensi.tanggalAbsensi + " " + absensi.waktuCheckOut);
                  int waktuKerja = checkOut.difference(checkIn).inHours;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tanggal Absensi",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              absensi.tanggalAbsensi,
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Waktu Check-In",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              absensi.waktuCheckIn,
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Lokasi Check-In",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              absensi.lokasiCheckIn,
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Waktu Check-out",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              absensi.waktuCheckOut,
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Lokasi Check-Out",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              absensi.lokasiCheckOut,
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Waktu Kerja",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              waktuKerja.toString() + " jam",
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is GetListAbsensiFailed) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: blackTextStyle,
                ),
              );
            } else if (state is AbsensiLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
