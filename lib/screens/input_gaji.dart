import 'package:flutter/material.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/router.dart';
import 'package:mkp_hris/utils/theme.dart';

import '../bloc/bloc.dart';
import '../model/model.dart';
import '../utils/lib.dart';
import '../widgets/widgets.dart';

class InputGajiScreen extends StatefulWidget {
  const InputGajiScreen({Key? key}) : super(key: key);

  @override
  State<InputGajiScreen> createState() => _InputGajiState();
}

class _InputGajiState extends State<InputGajiScreen> {
  final KaryawanCubit _karyawanCubit = getIt<KaryawanCubit>();

  @override
  void initState() {
    super.initState();
    _karyawanCubit.getAllKaryawan();
  }

  Future<void> getAllKaryawanAll() async {
    _karyawanCubit.getAllKaryawan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text(
          "Input Gaji",
          style: whiteTextStyle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getAllKaryawanAll,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: BlocConsumer<KaryawanCubit, KaryawanState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GetListKaryawanSuccess) {
                List<KaryawanModel> listKaryawan = state.listKaryawan;
                return ListView.builder(
                  itemCount: listKaryawan.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(riwayatGajiPageRoute,
                            arguments: listKaryawan[index]);
                      },
                      child: KaryawanItem(
                        karyawan: listKaryawan[index],
                      ),
                    );
                  },
                );
              } else if (state is KaryawanLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetListKaryawanFailed) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: redTextStyle,
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
