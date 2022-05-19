import 'package:albify/models/property_model.dart';
import 'package:albify/services/database_service.dart';
import 'package:flutter/foundation.dart';

class FavoritePropertyProvider extends ChangeNotifier {
  final DatabaseService databaseService;

  FavoritePropertyProvider(this.databaseService);

  Stream<List<PropertyModel>> favoriteProperties() =>
      databaseService.favoritePropertiesStream().map((snapshot) => snapshot.docs
          .map((property) => PropertyModel.fromDocumentSnapshot(property))
          .toList());
}
