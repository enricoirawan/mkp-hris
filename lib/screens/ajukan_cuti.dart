import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/cuti_model.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/lib.dart';

class AjukanCutiScreen extends StatefulWidget {
  final KaryawanModel karyawan;
  const AjukanCutiScreen({Key? key, required this.karyawan}) : super(key: key);

  @override
  State<AjukanCutiScreen> createState() => _AjukanCutiScreenState();
}

class _AjukanCutiScreenState extends State<AjukanCutiScreen> {
  int jatahCuti = 0;
  int cutiTerpakai = 0;

  final CutiCubit _cutiCubit = getIt<CutiCubit>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jenisCutiController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();

  final List<Map<String, dynamic>> _jenisCutiItems = [
    {
      'value': 'Cuti Sakit',
      'label': 'Cuti Sakit',
    },
    {
      'value': 'Cuti Melahirkan',
      'label': 'Cuti Melahirkan',
    },
    {
      'value': 'Cuti Kepentingan Lain',
      'label': 'Cuti Kepentingan Lain',
    },
  ];

  @override
  void initState() {
    super.initState();
    getSisaCuti();
    _cutiCubit.getRequestCutiOnProsesByKaryawanId(widget.karyawan.id);
  }

  Future<void> getSisaCuti() async {
    PostgrestResponse response = await Supabase.instance.client
        .from("Karyawan")
        .select("jatah_cuti")
        .eq("id", widget.karyawan.id)
        .execute();

    setState(() {
      jatahCuti = response.data[0]['jatah_cuti'];
      cutiTerpakai = 12 - jatahCuti;
    });
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      String startDateString = _startDateController.text;
      String endDateString = _endDateController.text;
      DateTime startDate = DateTime.parse(startDateString);
      DateTime endDate = DateTime.parse(endDateString);
      int durasiCuti = endDate.difference(startDate).inDays + 2;

      if (durasiCuti > jatahCuti) {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Peringatan",
          desc:
              "Durasi cuti melebihi sisa cuti, hubungi HR untuk mendapat persetujuan cuti diluar jatah cuti",
          buttons: [
            DialogButton(
              height: 50,
              child: Text(
                "Saya sudah dapat persetujuan",
                style: whiteTextStyle,
              ),
              onPressed: () {
                _cutiCubit.requestCuti(
                  _jenisCutiController.text,
                  widget.karyawan.id,
                  _alasanController.text,
                  _startDateController.text,
                  _endDateController.text,
                  durasiCuti,
                  DateTime.now().toString(),
                );
              },
              width: 120,
              color: kRedColor,
            ),
            DialogButton(
              height: 50,
              child: Text(
                "Baik",
                style: whiteTextStyle,
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
              color: kPrimaryColor,
            ),
          ],
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CutiCubit, CutiState>(
      listener: (context, state) {
        if (state is RequestCutiSuccess) {
          _jenisCutiController.clear();
          _alasanController.clear();
          _startDateController.clear();
          _endDateController.clear();
          _cutiCubit.getRequestCutiOnProsesByKaryawanId(widget.karyawan.id);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Text(
            "Ajukan Cuti",
            style: whiteTextStyle,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Card(
                elevation: 10,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cuti Terpakai : $cutiTerpakai hari",
                        style: redTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Sisa Cuti : $jatahCuti hari",
                        style: primaryTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SelectFormField(
                        type: SelectFormFieldType.dropdown,
                        controller: _jenisCutiController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Jenis Cuti harus diisi';
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
                          hintText: "Jenis Cuti",
                          label: const Text("Jenis Cuti"),
                        ),
                        items: _jenisCutiItems,
                        onChanged: (val) {
                          _jenisCutiController.text = val;
                        },
                        onSaved: (val) {
                          _jenisCutiController.text = val!;
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                DateTime selectedDate = DateTime.now();
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(1990, 1),
                                  lastDate: DateTime(3101),
                                );
                                List<String> date =
                                    picked.toString().split(" ");
                                _startDateController.text = date[0];
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: _startDateController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '*Tanggal Mulai harus diisi';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                        color: kPrimaryColor, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      color: kRedColor,
                                      width: 2,
                                    ),
                                  ),
                                  errorStyle: redTextStyle,
                                  hintText: "Tanggal Mulai",
                                  label: const Text("Tanggal Mulai"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (_startDateController.text.isEmpty) {
                                  CustomSnackbar.buildErrorSnackbar(
                                    context,
                                    "Input tanggal mulai terlebih dahulu",
                                  );
                                  return;
                                }

                                String startDate = _startDateController.text;
                                DateTime selectedDate =
                                    DateTime.parse(startDate);
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: selectedDate,
                                  lastDate: DateTime(3101),
                                );
                                List<String> sdate =
                                    picked.toString().split(" ");
                                _endDateController.text = sdate[0];
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: _endDateController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '*Tanggal Akhir harus diisi';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                        color: kPrimaryColor, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      color: kRedColor,
                                      width: 2,
                                    ),
                                  ),
                                  errorStyle: redTextStyle,
                                  hintText: "Tanggal Akhir",
                                  label: const Text("Tanggal Akhir"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 5,
                        controller: _alasanController,
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
                            borderSide: BorderSide(
                              color: kRedColor,
                              width: 2,
                            ),
                          ),
                          errorStyle: redTextStyle,
                          hintText: "Alasan",
                          label: const Text("Alasan"),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: jatahCuti == 0 ? kRedColor : kPrimaryColor,
                          ),
                          child: Text(
                            jatahCuti == 0
                                ? "Jatah Cuti Telah Habis"
                                : "Ajukan Cuti",
                            style: whiteTextStyle,
                          ),
                          onPressed: jatahCuti == 0 ? () {} : _onSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pengajuan Cuti On Proses",
                    style: blackTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  BlocBuilder<CutiCubit, CutiState>(builder: (context, state) {
                    if (state is GetListCutiSuccess) {
                      if (state.listCuti.isEmpty) {
                        return Text(
                          "Tidak ada pengajuan cuti on proses",
                          style: blackTextStyle,
                        );
                      }
                      return SizedBox(
                        height: 110,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.listCuti.length,
                            itemBuilder: (context, index) {
                              CutiModel cuti = state.listCuti[index];
                              return Card(
                                elevation: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${cuti.startDate} s/d ${cuti.endDate}",
                                        style: primaryTextStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        cuti.jenisCuti,
                                        style: blackTextStyle.copyWith(),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        cuti.alasan.isEmpty ? "-" : cuti.alasan,
                                        style: blackTextStyle.copyWith(),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Dibuat pada : " +
                                            cuti.createdAt.split(" ")[0],
                                        style: blackTextStyle.copyWith(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
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
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
