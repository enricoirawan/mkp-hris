import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/cuti/cuti_cubit.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/cuti_model.dart';
import 'package:mkp_hris/utils/lib.dart';

import '../utils/theme.dart';

class RiwayatCutiScreen extends StatefulWidget {
  final int karyawanId;
  final bool showAppBar;

  const RiwayatCutiScreen({
    Key? key,
    required this.karyawanId,
    required this.showAppBar,
  }) : super(key: key);

  @override
  State<RiwayatCutiScreen> createState() => _RiwayatCutiScreenState();
}

class _RiwayatCutiScreenState extends State<RiwayatCutiScreen> {
  final CutiCubit _cutiCubit = getIt<CutiCubit>();

  @override
  void initState() {
    super.initState();
    _cutiCubit.getHistoryCutiByKaryawanId(widget.karyawanId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              title: Text(
                "Riwayat Cuti Saya",
                style: whiteTextStyle,
              ),
            )
          : PreferredSize(
              child: Container(),
              preferredSize: const Size(0, 0),
            ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: BlocBuilder<CutiCubit, CutiState>(
          builder: (context, state) {
            if (state is GetListCutiSuccess) {
              List<CutiModel> listCuti = state.listCuti;

              if (listCuti.isEmpty) {
                return Center(
                  child: Text(
                    "Belum ada riwayat cuti",
                    style: blackTextStyle,
                  ),
                );
              }

              return ListView.builder(
                itemCount: listCuti.length,
                itemBuilder: (context, index) {
                  CutiModel cuti = listCuti[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color:
                          cuti.status == "approved" ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jenis Cuti",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              cuti.jenisCuti,
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Periode Cuti",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${cuti.startDate} s/d ${cuti.endDate}",
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Durasi Cuti",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              cuti.durasiCuti.toString() + " hari",
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Alasan",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              cuti.alasan.isEmpty ? "-" : cuti.alasan,
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Status",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              cuti.status == "approved"
                                  ? "Disetujui"
                                  : "Ditolak",
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              cuti.status == "approved"
                                  ? "Disetujui oleh"
                                  : "Ditolak oleh",
                              style: greyTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              cuti.status == "approved"
                                  ? cuti.approvedBy
                                  : cuti.rejectedBy,
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
            } else if (state is GetListCutiFailed) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: blackTextStyle,
                ),
              );
            } else if (state is CutiLoading) {
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
