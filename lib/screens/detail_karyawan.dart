import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/karyawan/karyawan_cubit.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/router.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/constant.dart';
import '../utils/lib.dart';

class DetailKaryawanScreen extends StatelessWidget {
  final KaryawanModel karyawan;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _npwpController = TextEditingController();
  final TextEditingController _gajiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noRekController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _activeController = TextEditingController();
  final TextEditingController _jatahCutiController = TextEditingController();
  final TextEditingController _tanggalBergabungController =
      TextEditingController();

  final KaryawanCubit _karyawanCubit = getIt<KaryawanCubit>();

  DetailKaryawanScreen({
    Key? key,
    required this.karyawan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<KaryawanCubit, KaryawanState>(
      listener: (context, state) {
        if (state is DeleteKaryawanSuccess) {
          Navigator.of(context).pop();
          CustomSnackbar.buildSuccessSnackbar(context, state.message);
          Navigator.of(context).pop();
        } else if (state is DeleteKaryawanFailed) {
          Navigator.of(context).pop();
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Detail Karyawan",
            style: whiteTextStyle,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Alert(
                  context: context,
                  type: AlertType.warning,
                  title: "Peringatan",
                  desc:
                      "Apakah anda yakin menghapus data karyawan ini? Data karyawan yang sudah dihapus tidak dapat dipulihkan kembali",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Tidak",
                        style: whiteTextStyle,
                      ),
                      onPressed: () => Navigator.pop(context),
                      width: 120,
                      color: kRedColor,
                    ),
                    DialogButton(
                      child: Text(
                        "Ya",
                        style: whiteTextStyle,
                      ),
                      onPressed: () {
                        _karyawanCubit.deleteKaryawan(karyawan.id);
                      },
                      width: 120,
                      color: kPrimaryColor,
                    ),
                  ],
                ).show();
              },
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  updateKaryawanPageRoute,
                  arguments: karyawan,
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  dataRiwayatKaryawanPageRoute,
                  arguments: karyawan,
                );
              },
              icon: const Icon(Icons.info),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                karyawan.fotoUrl.isNotEmpty
                    ? ImageNetwork(
                        image: publicStorageBaseUrl + karyawan.fotoUrl,
                        height: 100,
                        width: 100,
                        borderRadius: BorderRadius.circular(50),
                        imageCache: CachedNetworkImageProvider(
                          publicStorageBaseUrl + karyawan.fotoUrl,
                        ),
                      )
                    : Center(
                        child: CircleAvatar(
                          child: const Icon(
                            Icons.account_circle,
                            size: 100,
                            color: Colors.black,
                          ),
                          radius: 50,
                          backgroundColor: kWhiteColor,
                        ),
                      ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _idController..text = karyawan.id.toString(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "ID Karyawan",
                    label: const Text("ID Karyawan"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _namaController..text = karyawan.nama,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "Nama",
                    label: const Text("Nama"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _jabatanController..text = karyawan.jabatan,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "Jabatan",
                    label: const Text("Jabatan"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _emailController..text = karyawan.email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "Email",
                    label: const Text("Email"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _npwpController..text = karyawan.npwp,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "NPWP",
                    label: const Text("NPWP"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _alamatController..text = karyawan.alamat,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "Alamat",
                    label: const Text("Alamat"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _noRekController..text = karyawan.noRekening,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "No Rekening",
                    label: const Text("No Rekening"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _gajiController..text = karyawan.gaji.toString(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "Gaji",
                    label: const Text("Gaji"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _tanggalBergabungController
                    ..text = karyawan.tanggalBergabung,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "Tanggal Bergabung",
                    label: const Text("Tanggal Bergabung"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _jatahCutiController
                    ..text = karyawan.jatahCuti.toString(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "Jatah Cuti",
                    label: const Text("Jatah Cuti"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  enabled: false,
                  controller: _activeController
                    ..text = karyawan.active ? "Aktif" : "Tidak Aktif",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    hintText: "Status",
                    label: const Text("Status"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
