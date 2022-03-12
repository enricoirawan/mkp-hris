import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/karyawan/karyawan_cubit.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/karyawan_model.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/lib.dart';

class AddKaryawanScreen extends StatefulWidget {
  const AddKaryawanScreen({Key? key}) : super(key: key);

  @override
  State<AddKaryawanScreen> createState() => _AddKaryawanScreenState();
}

class _AddKaryawanScreenState extends State<AddKaryawanScreen> {
  final KaryawanCubit _karyawanCubit = getIt<KaryawanCubit>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _npwpController = TextEditingController();
  final TextEditingController _gajiController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _tanggalBergabungController =
      TextEditingController();
  final TextEditingController _divisiController = TextEditingController();
  final TextEditingController _roleIdController = TextEditingController();
  final TextEditingController _noRekController = TextEditingController();
  final TextEditingController _jatahCutiController = TextEditingController();

  final List<Map<String, dynamic>> _divisiItems = [
    {
      'value': 'Production',
      'label': 'Production',
    },
    {
      'value': 'Project',
      'label': 'Project',
    },
    {
      'value': 'Operation',
      'label': 'Operation',
    },
    {
      'value': 'Revenue',
      'label': 'Revenue',
    },
    {
      'value': 'Direktur',
      'label': 'Direktur',
    },
  ];

  final List<Map<String, dynamic>> _roleIdItems = [
    {
      'value': '2',
      'label': 'Admin (2)',
    },
    {
      'value': '3',
      'label': 'User (3)',
    },
  ];

  final List<Map<String, dynamic>> _jatahCutiItems = [
    {
      'value': '1',
      'label': '1',
    },
    {
      'value': '2',
      'label': '2',
    },
    {
      'value': '3',
      'label': '3',
    },
    {
      'value': '4',
      'label': '4',
    },
    {
      'value': '5',
      'label': '5',
    },
    {
      'value': '6',
      'label': '6',
    },
    {
      'value': '7',
      'label': '7',
    },
    {
      'value': '8',
      'label': '8',
    },
    {
      'value': '9',
      'label': '9',
    },
    {
      'value': '10',
      'label': '10',
    },
    {
      'value': '11',
      'label': '11',
    },
    {
      'value': '12',
      'label': '12',
    },
  ];

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Peringatan",
        desc: "Apakah semua data yang diinput sudah sesuai?",
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
              KaryawanModel karyawan = KaryawanModel(
                id: 0,
                nama: _namaController.text,
                email: _emailController.text,
                npwp: _npwpController.text,
                gaji: int.parse(_gajiController.text),
                fotoUrl: "",
                jabatan: _jabatanController.text,
                alamat: _alamatController.text,
                tanggalBergabung: _tanggalBergabungController.text,
                divisi: _divisiController.text,
                roleId: int.parse(_roleIdController.text),
                noRekening: _noRekController.text,
                jatahCuti: int.parse(_jatahCutiController.text),
                active: true,
              );

              _karyawanCubit.addKaryawan(karyawan);
            },
            width: 120,
            color: kPrimaryColor,
          ),
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KaryawanCubit, KaryawanState>(
      listener: (context, state) {
        if (state is AddKaryawanSuccess) {
          Navigator.of(context).pop();
          CustomSnackbar.buildSuccessSnackbar(context, state.message);

          Navigator.of(context).pop();
        } else if (state is AddKaryawanFailed) {
          Navigator.of(context).pop();
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Tambah Data Karyawan",
            style: whiteTextStyle,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _onSave,
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _namaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Nama harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kRedColor, width: 2),
                      ),
                      errorStyle: redTextStyle,
                      hintText: "Nama",
                      label: const Text("Nama"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
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
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
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
                  const SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _alamatController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Alamat harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
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
                  const SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _jabatanController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Jabatan harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
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
                  const SizedBox(height: 15),
                  SelectFormField(
                    type: SelectFormFieldType.dropdown,
                    controller: _divisiController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Divisi harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kRedColor, width: 2),
                      ),
                      errorStyle: redTextStyle,
                      hintText: "Divisi",
                      label: const Text("Divisi"),
                    ),
                    labelText: 'Divisi',
                    items: _divisiItems,
                    onChanged: (val) {
                      _divisiController.text = val;
                    },
                    onSaved: (val) {
                      _divisiController.text = val!;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _npwpController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*NPWP harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
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
                  const SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _gajiController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Gaji harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kRedColor, width: 2),
                      ),
                      errorStyle: redTextStyle,
                      hintText: "Gaji",
                      label: const Text("Gaji"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _noRekController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*No Rekening harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
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
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () async {
                      DateTime selectedDate = DateTime.now();
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(1990, 1),
                        lastDate: DateTime(3101),
                      );
                      List<String> date = picked.toString().split(" ");
                      _tanggalBergabungController.text = date[0];
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _tanggalBergabungController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Tanggal Bergabung harus diisi';
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
                        hintText: "Tanggal Bergabung",
                        label: const Text("Tanggal Bergabung"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SelectFormField(
                    type: SelectFormFieldType.dropdown,
                    controller: _jatahCutiController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Jatah Cuti harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
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
                    items: _jatahCutiItems,
                    onChanged: (val) {
                      _jatahCutiController.text = val;
                    },
                    onSaved: (val) {
                      _jatahCutiController.text = val!;
                    },
                  ),
                  const SizedBox(height: 15),
                  SelectFormField(
                    type: SelectFormFieldType.dropdown,
                    controller: _roleIdController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Role Id harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kRedColor, width: 2),
                      ),
                      errorStyle: redTextStyle,
                      hintText: "Role Id",
                      label: const Text("Role Id"),
                    ),
                    items: _roleIdItems,
                    onChanged: (val) {
                      _roleIdController.text = val;
                    },
                    onSaved: (val) {
                      _roleIdController.text = val!;
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
