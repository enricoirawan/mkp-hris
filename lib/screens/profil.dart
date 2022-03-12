import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/utils/constant.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/lib.dart';

class ProfilScreen extends StatefulWidget {
  final int idKaryawan;

  const ProfilScreen({Key? key, required this.idKaryawan}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final KaryawanCubit _karyawanCubit = getIt<KaryawanCubit>();
  final AuthCubit _authCubit = getIt<AuthCubit>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _npwpController = TextEditingController();
  final TextEditingController _noRekController = TextEditingController();
  final TextEditingController _jatahCutiController = TextEditingController();
  final TextEditingController _tanggalBergabungController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _karyawanCubit.getKaryawanById(widget.idKaryawan);
  }

  Future<void> _onPressed() async {
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }

    final bytes = await imageFile.readAsBytes();
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;

    _karyawanCubit.uploadImageProfile(bytes, filePath, widget.idKaryawan);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: BlocConsumer<KaryawanCubit, KaryawanState>(
            listener: (context, state) {
              if (state is KaryawanLoading) {
                EasyLoading.show();
              } else if (state is UploadImageProfileSuccess) {
                EasyLoading.dismiss();

                CustomSnackbar.buildSuccessSnackbar(
                  context,
                  state.message,
                );

                _karyawanCubit.getKaryawanById(widget.idKaryawan);
              } else if (state is UploadImageProfileFailed) {
                EasyLoading.dismiss();

                CustomSnackbar.buildErrorSnackbar(
                  context,
                  state.errorModel.errorMessage,
                );

                _karyawanCubit.getKaryawanById(widget.idKaryawan);
              }
            },
            builder: (context, state) {
              if (state is GetKaryawanByIdSuccess) {
                EasyLoading.dismiss();
                KaryawanModel karyawan = state.karyawan;

                _authCubit.updateAuthSuccessState(karyawan);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // *Start Profile Image
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/bg_mkp.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                          BlocBuilder<KaryawanCubit, KaryawanState>(
                            builder: (context, state) {
                              if (state is GetKaryawanByIdSuccess) {
                                String fotoUrl = publicStorageBaseUrl +
                                    state.karyawan.fotoUrl;

                                return InkWell(
                                  onTap: _onPressed,
                                  child: Center(
                                    child: CircleAvatar(
                                      child: fotoUrl.isEmpty
                                          ? const Icon(
                                              Icons.account_circle,
                                              size: 100,
                                              color: Colors.black,
                                            )
                                          : ImageNetwork(
                                              image: fotoUrl,
                                              height: 100,
                                              width: 100,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              imageCache:
                                                  CachedNetworkImageProvider(
                                                fotoUrl,
                                              ),
                                            ),
                                      radius: 50,
                                      backgroundColor: kWhiteColor,
                                    ),
                                  ),
                                );
                              }
                              return Center(
                                child: CircleAvatar(
                                  child: const Icon(
                                    Icons.account_circle,
                                    size: 100,
                                    color: Colors.black,
                                  ),
                                  radius: 50,
                                  backgroundColor: kWhiteColor,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // *End Profile Image

                    const SizedBox(height: 20),

                    // *Start Info List

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController..text = karyawan.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Email harus diisi';
                          } else if (!value.contains("@")) {
                            return "*Email tidak valid";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: kRedColor, width: 2),
                          ),
                          errorStyle: redTextStyle,
                          hintText: "Email",
                          label: const Text("Email"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _jabatanController..text = karyawan.jabatan,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Jabatan harus diisi';
                          } else if (!value.contains("@")) {
                            return "*Jabatan tidak valid";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: kRedColor, width: 2),
                          ),
                          errorStyle: redTextStyle,
                          hintText: "Jabatan",
                          label: const Text("Jabatan"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _alamatController..text = karyawan.alamat,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Alamat harus diisi';
                          } else if (!value.contains("@")) {
                            return "*Alamat tidak valid";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: kRedColor, width: 2),
                          ),
                          errorStyle: redTextStyle,
                          hintText: "Alamat",
                          label: const Text("Alamat"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _npwpController..text = karyawan.npwp,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*NPWP harus diisi';
                          } else if (!value.contains("@")) {
                            return "*NPWP tidak valid";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: kRedColor, width: 2),
                          ),
                          errorStyle: redTextStyle,
                          hintText: "NPWP",
                          label: const Text("NPWP"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _noRekController
                          ..text = karyawan.noRekening,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*No Rekening harus diisi';
                          } else if (!value.contains("@")) {
                            return "*No Rekening tidak valid";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: kRedColor, width: 2),
                          ),
                          errorStyle: redTextStyle,
                          hintText: "No Rekening",
                          label: const Text("No Rekening"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _tanggalBergabungController
                          ..text = karyawan.tanggalBergabung,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Tanggal bergabung harus diisi';
                          } else if (!value.contains("@")) {
                            return "*Tanggal bergabung tidak valid";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: kRedColor, width: 2),
                          ),
                          errorStyle: redTextStyle,
                          hintText: "Tanggal bergabung",
                          label: const Text("Tanggal bergabung"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _jatahCutiController
                          ..text = karyawan.jatahCuti.toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Tanggal bergabung harus diisi';
                          } else if (!value.contains("@")) {
                            return "*Tanggal bergabung tidak valid";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: kRedColor, width: 2),
                          ),
                          errorStyle: redTextStyle,
                          hintText: "Jatah Cuti",
                          label: const Text("Jatah Cuti"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // *End Info List

                    // *Start Button Action
                    // BlocBuilder<AuthCubit, AuthState>(
                    //   builder: (context, state) {
                    //     if (state is AuthSuccess) {
                    //       if (state.karyawan.roleId == 1) {
                    //         return Container(
                    //           padding: const EdgeInsets.symmetric(horizontal: 15),
                    //           child: ElevatedButton(
                    //             onPressed: () {},
                    //             style: ElevatedButton.styleFrom(
                    //               primary: kPrimaryColor,
                    //             ),
                    //             child: Text(
                    //               "Update Data Karyawan",
                    //               style: whiteTextStyle.copyWith(
                    //                 letterSpacing: 1,
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //     }
                    //     return Container();
                    //   },
                    // ),
                    // *End Button Action
                  ],
                );
              } else if (state is GetKaryawanByIdFailed) {
                return Center(
                  child: Text(
                    state.error.errorMessage,
                    style: primaryTextStyle,
                  ),
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
