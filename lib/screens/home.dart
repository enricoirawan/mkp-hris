import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/router.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../injection.dart';
import '../utils/lib.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PengumumanCubit _pengumumanCubit = getIt<PengumumanCubit>();

  @override
  void initState() {
    super.initState();
    _pengumumanCubit.getAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // *Start Berita
                  BlocBuilder<PengumumanCubit, PengumumanState>(
                    builder: (context, state) {
                      if (state is GetPengumumanSuccess) {
                        return Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          height: MediaQuery.of(context).size.height / 4,
                          child: BannerPengumuman(
                            listPengumuman: state.listPengumuman,
                          ),
                        );
                      } else if (state is GetPengumumanFailed) {
                        return Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          height: MediaQuery.of(context).size.height / 4,
                          child: Center(
                            child: Text(
                              "Terjadi kesalahan, silahkan coba ulang kembali",
                              style: blackTextStyle,
                            ),
                          ),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                  // *End Berita

                  // *Start Grid List Menu
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    height: 120,
                    child: GridView.count(
                      crossAxisSpacing: 20,
                      crossAxisCount: 3,
                      children: [
                        Card(
                          elevation: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/edit-calendar.png"),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Ajukan Cuti",
                                style: primaryTextStyle.copyWith(
                                  letterSpacing: 1,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/tips.png"),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Slip Gaji",
                                style: primaryTextStyle.copyWith(
                                  letterSpacing: 1,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/upload.png"),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Berkas Data",
                                style: primaryTextStyle.copyWith(
                                  letterSpacing: 1,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // *End Grid List Menu

                  state.karyawan.roleId == 3
                      ? const SizedBox()
                      :
                      // *Start Grid List Menu HR
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          height: MediaQuery.of(context).size.height,
                          child: GridView.count(
                            crossAxisSpacing: 20,
                            crossAxisCount: 3,
                            children: [
                              Card(
                                elevation: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/ipproval.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Approve Cuti",
                                      style: primaryTextStyle.copyWith(
                                        letterSpacing: 1,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/payroll.png",
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Input Gaji",
                                      style: primaryTextStyle.copyWith(
                                        letterSpacing: 1,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/employees.png"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Karyawan",
                                      style: primaryTextStyle.copyWith(
                                        letterSpacing: 1,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(
                                        buatPengumumanPageRoute,
                                        arguments: state.karyawan.nama,
                                      )
                                      .then(
                                        (value) =>
                                            _pengumumanCubit.getAnnouncement(),
                                      );
                                },
                                child: Card(
                                  elevation: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/commercial.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Buat Pengumuman",
                                        style: primaryTextStyle.copyWith(
                                          letterSpacing: 1,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  // *End Grid List Menu HR
                ],
              ),
            );
          }

          return const Center(
            child: Text("Terjadi kesalahan silahkan login ulang"),
          );
        },
      ),
    );
  }
}
