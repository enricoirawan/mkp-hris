import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/karyawan/karyawan_cubit.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/utils/lib.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../router.dart';

class KaryawanScreen extends StatefulWidget {
  const KaryawanScreen({Key? key}) : super(key: key);

  @override
  State<KaryawanScreen> createState() => _KaryawanScreenState();
}

class _KaryawanScreenState extends State<KaryawanScreen> {
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
        title: Text(
          "Karyawan",
          style: whiteTextStyle,
        ),
        centerTitle: true,
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
                        Navigator.of(context)
                            .pushNamed(
                              detailKaryawanPageRoute,
                              arguments: listKaryawan[index],
                            )
                            .then((_) => getAllKaryawanAll());
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed(addKaryawanPageRoute).then((value) {
            _karyawanCubit.getAllKaryawan();
          });
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
