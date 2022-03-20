import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/router.dart';

import '../utils/lib.dart';
import '../utils/theme.dart';

class RiwayatGajiKaryawan extends StatefulWidget {
  final KaryawanModel karyawan;

  const RiwayatGajiKaryawan({Key? key, required this.karyawan})
      : super(key: key);

  @override
  State<RiwayatGajiKaryawan> createState() => _RiwayatGajiKaryawanState();
}

class _RiwayatGajiKaryawanState extends State<RiwayatGajiKaryawan> {
  final GajiCubit _gajiCubit = getIt<GajiCubit>();

  @override
  void initState() {
    super.initState();

    _gajiCubit.getGajiByKaryawanId(widget.karyawan.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text(
          "Riwayat Gaji",
          style: whiteTextStyle,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: BlocBuilder<GajiCubit, GajiState>(
          builder: (context, state) {
            if (state is GajiLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetGajiFailed) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: blackTextStyle,
                ),
              );
            } else if (state is GetGajiSuccess) {
              List<GajiModel> listGaji = state.listGaji;
              if (listGaji.isEmpty) {
                return const Center(
                  child: Text("Belum ada slip gaji yang masuk"),
                );
              }
              return ListView.builder(
                itemCount: listGaji.length,
                itemBuilder: (context, index) {
                  GajiModel gaji = listGaji[index];
                  return Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dibuat pada",
                            style: blackTextStyle.copyWith(),
                          ),
                          Text(
                            gaji.createdAt,
                            style: blackTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Gaji Bersih",
                            style: blackTextStyle.copyWith(),
                          ),
                          Text(
                            "Rp " + gaji.gajiBersih.toString(),
                            style: blackTextStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Iuran BPJS Ketenagakerjaan",
                            style: blackTextStyle.copyWith(),
                          ),
                          Text(
                            "Rp " + gaji.bpjsTenaker.toString(),
                            style: blackTextStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Bonus",
                            style: blackTextStyle.copyWith(),
                          ),
                          Text(
                            "Rp " + gaji.bonus.toString(),
                            style: blackTextStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Catatan",
                            style: blackTextStyle.copyWith(),
                          ),
                          Text(
                            gaji.catatan.isEmpty ? "-" : gaji.catatan,
                            style: blackTextStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
      floatingActionButton: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            int roleId = state.karyawan.roleId;

            if (roleId == 3) {
              return Container();
            }

            return FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  inputGajiFormPageRoute,
                  arguments: widget.karyawan,
                );
              },
              child: const Icon(
                Icons.add,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
