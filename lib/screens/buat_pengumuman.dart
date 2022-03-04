import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/lib.dart';

class BuatPengumuman extends StatefulWidget {
  final String nama;

  const BuatPengumuman({Key? key, required this.nama}) : super(key: key);

  @override
  _BuatPengumumanState createState() => _BuatPengumumanState();
}

class _BuatPengumumanState extends State<BuatPengumuman> {
  final PengumumanCubit _pengumumanCubit = getIt<PengumumanCubit>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _pickedFile = "";
  String _filePath = "";
  File? _file;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'ppt', 'pdf', 'doc'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      final fileName = '${DateTime.now().toIso8601String()}.${file.extension}';
      final filePath = fileName;

      setState(() {
        _pickedFile = file.name;
        _filePath = filePath;
        _file = File(file.path!);
      });
    } else {
      // User canceled the picker
      CustomSnackbar.buildErrorSnackbar(context, "Tidak ada file yang dipilih");
    }
  }

  void _onPressed() {
    if (_formKey.currentState!.validate()) {
      String dateTime = DateTime.now().toLocal().toString();
      List<String> splitDate = dateTime.split(" ");
      String currentDate = splitDate[0];

      _pengumumanCubit.createAnnoucement(
        _titleController.text,
        _descriptionController.text,
        widget.nama,
        currentDate,
        file: _file,
        filePath: _filePath,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PengumumanCubit, PengumumanState>(
      listener: (context, state) {
        if (state is InsertPengumumanSuccess) {
          CustomSnackbar.buildSuccessSnackbar(context, state.message);

          Navigator.of(context).pop();
        } else if (state is InsertPengumumanFailed) {
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Buat Pengumuman",
            style: whiteTextStyle,
          ),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _onPressed,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Judul harus diisi';
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
                    hintText: "Judul",
                    label: const Text("Judul"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _descriptionController,
                  minLines:
                      15, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
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
                    hintText: "Isi Pengumuman",
                    label: const Text("Isi Pengumuman"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _pickedFile.isEmpty
                      ? "Belum ada file yang dipilih (opsional)"
                      : _pickedFile,
                  style: blackTextStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: Text(
                    "Sisipkan File",
                    style: whiteTextStyle,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
