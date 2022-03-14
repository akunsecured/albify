import 'dart:math';

import 'package:albify/models/property_model.dart';
import 'package:albify/services/database_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PropertyCreateProvider extends ChangeNotifier {
  final DatabaseService databaseService;

  bool isLoading = false;
  bool isDisposed = false;
  bool forSale = false;
  bool newlyBuilt = false;
  int propertyTypeValue = 0;

  late final TextEditingController _priceController, _roomsController, _floorspaceController;

  PropertyCreateProvider(this.databaseService) {
    _priceController = TextEditingController();
    _roomsController = TextEditingController();
    _floorspaceController = TextEditingController();
  }

  TextEditingController get priceController => _priceController;
  TextEditingController get roomsController => _roomsController;
  TextEditingController get floorspaceController => _floorspaceController;

  changeLoadingStatus() async {
    isLoading = !isLoading;
    if (!isDisposed) notifyListeners();
  }

  changeForSaleStatus() {
    forSale = !forSale;
    if (!isDisposed) notifyListeners();
  }

  changeNewlyBuiltStatus() {
    newlyBuilt = !newlyBuilt;
    if (!isDisposed) notifyListeners();
  }

  changePropertyTypeValue(int value) {
    propertyTypeValue = value;
    if (!isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _roomsController.dispose();
    _floorspaceController.dispose();
    isDisposed = true;
    super.dispose();
  }

  // Future<bool> submit(List<XFile> images) async {
  Future<bool> submit(List<PlatformFile> images) async {
    await changeLoadingStatus();
    await Future.delayed(Duration(milliseconds: 500));

    bool value = await databaseService.addProperty(
      PropertyModel(
        location: PropertyLocation(
          47.4806695 + (Random().nextDouble() / 100),
          19.0561783 + (Random().nextDouble() / 100)
        ),
        type: PropertyType.values[this.propertyTypeValue],
        rooms: int.parse(_roomsController.text),
        price: int.parse(_priceController.text),
        floorspace: double.parse(_floorspaceController.text),
        newlyBuilt: this.newlyBuilt,
        forSale: this.forSale,
        photoUrls: []
      ),
      images
    );
    changeLoadingStatus();
    return value;
  }
}