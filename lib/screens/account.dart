import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/router.dart';
import 'package:mkp_hris/utils/constant.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/lib.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);

  final AuthCubit _authCubit = getIt<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignoutSuccess) {
          EasyLoading.dismiss();

          Navigator.of(context).pushNamedAndRemoveUntil(
            signinPageRoute,
            (route) => false,
          );
        } else if (state is SignoutFailed) {
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
        } else if (state is AuthLoading) {
          EasyLoading.show();
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // *Start Header
              Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/bg_mkp.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        Expanded(child: Container()),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is AuthSuccess) {
                              KaryawanModel karyawan = state.karyawan;
                              String fotoUrl = karyawan.fotoUrl;

                              if (fotoUrl.isEmpty) {
                                //kalau foto url nya kosong tampilkan Icon saja
                                return Icon(
                                  Icons.account_circle,
                                  size: 100,
                                  color: kWhiteColor,
                                );
                              }

                              return ImageNetwork(
                                image: publicStorageBaseUrl + fotoUrl,
                                height: 80,
                                width: 80,
                                borderRadius: BorderRadius.circular(50),
                                imageCache: CachedNetworkImageProvider(
                                  publicStorageBaseUrl + fotoUrl,
                                ),
                              );
                            }
                            return Icon(
                              Icons.account_circle,
                              size: 100,
                              color: kWhiteColor,
                            );
                          },
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is AuthSuccess) {
                              KaryawanModel karyawan = state.karyawan;
                              return Column(
                                children: [
                                  Text(
                                    karyawan.nama,
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 20,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  Text(
                                    karyawan.jabatan,
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 18,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                ),
              ),
              // *END Header

              // *START Info Akun
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthSuccess) {
                    int karyawanId = state.karyawan.id;
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          profilPageRoute,
                          arguments: karyawanId,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle,
                              color: kPrimaryColor,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Informasi Akun Saya",
                              style: blackTextStyle,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              // *END Info Akun

              const Divider(),

              // *START Riwayat Cuti
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_copy,
                        color: kPrimaryColor,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Riwayat Cuti Saya",
                        style: blackTextStyle,
                      )
                    ],
                  ),
                ),
              ),
              // *END Riwayat Cuti

              const Divider(),

              // *START Signout Menu
              InkWell(
                onTap: () {
                  _authCubit.signoutUser();
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app_outlined,
                        color: kPrimaryColor,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Keluar Aplikasi",
                        style: blackTextStyle,
                      )
                    ],
                  ),
                ),
              ),
              // *END Signout Menu

              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
