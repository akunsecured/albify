import 'package:albify/providers/edit_profile_provider.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/widgets/edit_profile_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  static const String ROUTE_ID = '/edit';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Edit profile'),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider(
            create: (_) => EditProfileProvider(
                _databaseService),
            builder: (context, child) => EditProfilePageWidgets()));
}
