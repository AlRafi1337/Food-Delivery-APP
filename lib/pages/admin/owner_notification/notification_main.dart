// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_super_parameters, use_build_context_synchronously, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:breeze_mobile/pages/admin/owner_notification/notification_body.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => NotificationsPage());
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationsBody(),
    );
  }
}
