import 'package:flutter/material.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../bloc/bloc.dart';
import '../utils/lib.dart';

class InputgajiFormScreen extends StatefulWidget {
  final KaryawanModel karyawan;
  const InputgajiFormScreen({Key? key, required this.karyawan})
      : super(key: key);

  @override
  State<InputgajiFormScreen> createState() => _InputgajiFormScreenState();
}

class _InputgajiFormScreenState extends State<InputgajiFormScreen> {
  final GajiCubit _gajiCubit = getIt<GajiCubit>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gajiController = TextEditingController();
  final TextEditingController _bpjsTenakerController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    double gaji = widget.karyawan.gaji.toDouble();
    double bpjsTenaker = gaji * 0.02;
    double gajiBersih = gaji - bpjsTenaker;

    _bpjsTenakerController.text = bpjsTenaker.toString();
    _gajiController.text = gajiBersih.toString();
  }

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
              GajiModel gaji = GajiModel(
                karyawanId: widget.karyawan.id,
                gajiBersih: double.parse(_gajiController.text),
                bpjsTenaker: double.parse(_bpjsTenakerController.text),
                bonus: double.parse(_bonusController.text),
                catatan: _catatanController.text,
                createdAt: DateTime.now().toString(),
              );

              _gajiCubit.addGaji(gaji);
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
    return BlocListener<GajiCubit, GajiState>(
      listener: (context, state) {
        if (state is AddGajiFailed) {
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
        } else if (state is AddGajiSuccess) {
          Navigator.of(context).pop();
          CustomSnackbar.buildSuccessSnackbar(context, state.message);

          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Text(
            "Input Gaji Form",
            style: whiteTextStyle,
          ),
          actions: [
            IconButton(
              onPressed: _onSave,
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.number,
                  controller: _gajiController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Gaji Bersih harus diisi';
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
                    hintText: "Gaji Bersih",
                    label: const Text("Gaji Bersih"),
                    prefix: const Text("Rp "),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.number,
                  controller: _bpjsTenakerController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*BPJS harus diisi';
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
                    hintText: "BPJS Ketenagakerjaan",
                    label: const Text("BPJS Ketenagakerjaan"),
                    prefix: const Text("Rp "),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _bonusController..text = "0",
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
                    hintText: "Bonus",
                    label: const Text("Bonus"),
                    prefix: const Text("Rp "),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _catatanController,
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
                    hintText: "Catatan",
                    label: const Text("Catatan"),
                    prefix: const Text("Rp "),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
