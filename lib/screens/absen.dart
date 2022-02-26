import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/lib.dart';

/*
  * Logika absen karyawan
  * 1. ketika init page, cek tanggal di local storage apakah sama dengan tanggal sekarang
  * 2. Kalau beda, maka replace tanggal di local storage dengan tanggal sekarang
  * 3. Kalau sama, maka get data absen hari ini

  * Simpan data tanggal di local storage ketika user check in 
 */

class AbsenScreen extends StatefulWidget {
  const AbsenScreen({Key? key}) : super(key: key);

  @override
  State<AbsenScreen> createState() => _AbsenScreenState();
}

class _AbsenScreenState extends State<AbsenScreen> {
  bool _isAlredyCheckIn = false;
  String _currentDate = "";

  final AbsensiCubit _absensiCubit = getIt<AbsensiCubit>();

  @override
  void initState() {
    super.initState();
    getTodayAbsence();
  }

  Future<void> getTodayAbsence() async {
    String dateTime = DateTime.now().toLocal().toString();
    List<String> splitDate = dateTime.split(" ");
    String currentDate = splitDate[0];

    setState(() {
      _currentDate = currentDate;
    });

    final prefs = await SharedPreferences.getInstance();
    String? lastAbsenceDate = prefs.getString('lastAbsenceDate');
    bool? isAlredyCheckIn = prefs.getBool('isAlredyCheckIn');
    int? karyawanId = prefs.getInt('karyawanId');

    if (isAlredyCheckIn != null) {
      setState(() {
        _isAlredyCheckIn = isAlredyCheckIn;
      });
    }

    if (currentDate != lastAbsenceDate) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("lastAbsenceDate", currentDate);
      await prefs.setBool("isAlredyCheckIn", false);
    }

    _absensiCubit.getTodayAbsensi(currentDate, karyawanId!);
  }

  _onPressed() async {
    final prefs = await SharedPreferences.getInstance();
    String dateTime = DateTime.now().toLocal().toString();
    List<String> splitDate = dateTime.split(" ");
    String currentTime = splitDate[1];
    int? karyawanId = prefs.getInt('karyawanId');

    if (_isAlredyCheckIn) {
      //panggil fungsi checkout
      _absensiCubit.checkOut(karyawanId!, currentTime, _currentDate);
    } else {
      //panggil fungsi checkin
      _absensiCubit.checkIn(karyawanId!, currentTime, _currentDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AbsensiCubit, AbsensiState>(
      listener: (context, state) {
        if (state is GetTodayAbsenFailed) {
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
          Future.delayed(const Duration(seconds: 2), getTodayAbsence);
        } else if (state is CheckInSuccess) {
          CustomSnackbar.buildSuccessSnackbar(context, state.message);
          Future.delayed(const Duration(seconds: 1), getTodayAbsence);
        } else if (state is CheckInFailed) {
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
          Future.delayed(const Duration(seconds: 2), getTodayAbsence);
        } else if (state is CheckOutSuccess) {
          CustomSnackbar.buildSuccessSnackbar(context, state.message);
          Future.delayed(const Duration(seconds: 1), getTodayAbsence);
        } else if (state is CheckOutFailed) {
          CustomSnackbar.buildErrorSnackbar(context, state.errorMessage);
          Future.delayed(const Duration(seconds: 2), getTodayAbsence);
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Column(
                children: [
                  Text(
                    "Waktu server",
                    style: blackTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  DigitalClock(
                    digitAnimationStyle: Curves.elasticOut,
                    is24HourTimeFormat: true,
                    areaDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    hourMinuteDigitTextStyle: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 50,
                    ),
                    amPmDigitTextStyle: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informasi absen pada $_currentDate",
                    style: primaryTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Text(
                    "Check In",
                    style: primaryTextStyle.copyWith(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<AbsensiCubit, AbsensiState>(
                    builder: (context, state) {
                      if (state is GetTodayAbsenNull) {
                        return Text(
                          "-",
                          style: blackTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (state is GetTodayAbsenSuccess) {
                        String checkIn = state.absensi.waktuCheckIn;
                        return Text(
                          checkIn,
                          style: blackTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return const Skeleton();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<AbsensiCubit, AbsensiState>(
                    builder: (context, state) {
                      if (state is GetTodayAbsenNull) {
                        return Text(
                          "Lokasi check in : -",
                          style: blackTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (state is GetTodayAbsenSuccess) {
                        String lokasiCheckIn = state.absensi.lokasiCheckIn;

                        return Text(
                          lokasiCheckIn,
                          style: blackTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return const Skeleton();
                    },
                  ),
                  const Divider(),
                  Text(
                    "Check Out",
                    style: primaryTextStyle.copyWith(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<AbsensiCubit, AbsensiState>(
                    builder: (context, state) {
                      if (state is GetTodayAbsenNull) {
                        return Text(
                          "-",
                          style: blackTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (state is GetTodayAbsenSuccess) {
                        String waktuCheckOut = state.absensi.waktuCheckOut;
                        return Text(
                          waktuCheckOut.isEmpty ? "-" : waktuCheckOut,
                          style: blackTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return const Skeleton();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<AbsensiCubit, AbsensiState>(
                    builder: (context, state) {
                      if (state is GetTodayAbsenNull) {
                        return Text(
                          "Lokasi check out : -",
                          style: blackTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (state is GetTodayAbsenSuccess) {
                        String lokasiCheckOut = state.absensi.lokasiCheckOut;
                        return Text(
                          lokasiCheckOut.isEmpty
                              ? "Lokasi check out : -"
                              : lokasiCheckOut,
                          style: blackTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return const Skeleton();
                    },
                  ),
                  const Divider(),
                ],
              ),
              Expanded(child: Container()),
              BlocBuilder<AbsensiCubit, AbsensiState>(
                builder: (context, state) {
                  if (state is AbsensiLoading) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                      ),
                      onPressed: null,
                      child: Text(
                        _isAlredyCheckIn ? 'Check Out' : 'Check In',
                        style: whiteTextStyle.copyWith(
                          letterSpacing: 2,
                        ),
                      ),
                    );
                  } else if (state is GetTodayAbsenSuccess) {
                    String waktuCheckOut = state.absensi.waktuCheckOut;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                      ),
                      onPressed: waktuCheckOut.isEmpty ? _onPressed : null,
                      child: Text(
                        _isAlredyCheckIn ? 'Check Out' : 'Check In',
                        style: whiteTextStyle.copyWith(
                          letterSpacing: 2,
                        ),
                      ),
                    );
                  } else if (state is GetTodayAbsenNull) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                      ),
                      onPressed: _onPressed,
                      child: Text(
                        _isAlredyCheckIn ? 'Check Out' : 'Check In',
                        style: whiteTextStyle.copyWith(
                          letterSpacing: 2,
                        ),
                      ),
                    );
                  }
                  return const Skeleton();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kBlackColor,
                ),
                onPressed: getTodayAbsence,
                child: Text(
                  'Refresh Halaman',
                  style: whiteTextStyle.copyWith(
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "*Aplikasi akan mengambil lokasi tempat kamu ${_isAlredyCheckIn ? 'check out' : 'check in'}",
                style: blackTextStyle.copyWith(),
                textAlign: TextAlign.start,
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
