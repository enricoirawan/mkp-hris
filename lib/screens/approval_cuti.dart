import 'package:flutter/material.dart';
import 'package:mkp_hris/model/model.dart';

import '../utils/theme.dart';

class ApprovalCutiScreen extends StatefulWidget {
  final KaryawanModel karyawan;
  const ApprovalCutiScreen({
    Key? key,
    required this.karyawan,
  }) : super(key: key);

  @override
  State<ApprovalCutiScreen> createState() => _ApprovalCutiScreenState();
}

class _ApprovalCutiScreenState extends State<ApprovalCutiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Approval Cuti",
          style: whiteTextStyle,
        ),
      ),
    );
  }
}
