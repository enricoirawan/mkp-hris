import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/cuti/cuti_cubit.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/cuti_model.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/utils/lib.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/theme.dart';

class ApprovalCutiScreen extends StatefulWidget {
  final KaryawanModel karyawan;
  const ApprovalCutiScreen({
    Key? key,
    required this.karyawan,
  }) : super(key: key);

  @override
  State<ApprovalCutiScreen> createState() => _ApprovalCutiScreenState();
}

class _ApprovalCutiScreenState extends State<ApprovalCutiScreen> {
  final CutiCubit _cutiCubit = getIt<CutiCubit>();

  @override
  void initState() {
    super.initState();
    _cutiCubit.getRequestCuti();
  }

  void _approveCuti(int cutiId, int karyawanId) {
    _cutiCubit.approveRequestCuti(cutiId, karyawanId, widget.karyawan.nama);
  }

  void _rejectCuti(int cutiId) {
    _cutiCubit.rejectRequestCuti(cutiId, widget.karyawan.nama);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CutiCubit, CutiState>(
      listener: (context, state) {
        if (state is ApproveRequestCutiSuccess) {
          CustomSnackbar.buildSuccessSnackbar(context, state.message);
          _cutiCubit.getRequestCuti();
        } else if (state is ApproveRequestCutiFailed) {
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
          _cutiCubit.getRequestCuti();
        } else if (state is RejectRequestCutiSuccess) {
          CustomSnackbar.buildSuccessSnackbar(context, state.message);
          _cutiCubit.getRequestCuti();
        } else if (state is RejectRequestCutiFailed) {
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
          _cutiCubit.getRequestCuti();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Text(
            "Approval Cuti",
            style: whiteTextStyle,
          ),
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
                      "Belum ada permintaan cuti",
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
                      child: Card(
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Karyawan",
                                style: greyTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                cuti.nama,
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
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
                                "Lama Cuti",
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
                                "Durasi Cuti",
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        _approveCuti(cuti.id, cuti.karyawanId),
                                    child: Text(
                                      "Approve Cuti",
                                      style: greenTextStyle,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => _rejectCuti(cuti.id),
                                    child: Text(
                                      "Tolak Cuti",
                                      style: redTextStyle,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
