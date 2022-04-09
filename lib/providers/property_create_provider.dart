import 'dart:math';

import 'package:albify/models/property_model.dart';
import 'package:albify/services/database_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PropertyCreateProvider extends ChangeNotifier {
  final DatabaseService databaseService;

  bool isLoading = false;
  bool isDisposed = false;
  bool forSale = false;
  bool newlyBuilt = false;
  int propertyTypeValue = 0;
  String? locationName;
  List<PlatformFile> imageFiles = [];
  PropertyLocation? propertyLocation;

  late final TextEditingController _priceController, _roomsController, _floorspaceController, _descriptionController;

  PropertyCreateProvider(this.databaseService) {
    _priceController = TextEditingController();
    _roomsController = TextEditingController();
    _floorspaceController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  TextEditingController get priceController => _priceController;
  TextEditingController get roomsController => _roomsController;
  TextEditingController get floorspaceController => _floorspaceController;
  TextEditingController get descriptionController => _descriptionController;

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

  changeLocationName(String? value) {
    locationName = value;
    if (!isDisposed) notifyListeners();
  }

  changeImages(List<PlatformFile> values) {
    imageFiles = values;
    if (!isDisposed) notifyListeners();
  }

  removeImage(PlatformFile value) {
    imageFiles.remove(value);
    if (!isDisposed) notifyListeners();
  }

  changeLocation(PropertyLocation value) {
    propertyLocation = value;
    if (!isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _roomsController.dispose();
    _floorspaceController.dispose();
    _descriptionController.dispose();
    isDisposed = true;
    super.dispose();
  }

  Future<bool> submit() async {
    await changeLoadingStatus();
    await Future.delayed(Duration(milliseconds: 500));

    bool value = await databaseService.addProperty(
      PropertyModel(
        location: propertyLocation!,
        type: PropertyType.values[this.propertyTypeValue],
        rooms: int.parse(_roomsController.text),
        price: int.parse(_priceController.text),
        floorspace: int.parse(_floorspaceController.text),
        newlyBuilt: this.newlyBuilt,
        forSale: this.forSale,
        photoUrls: [],
        description: _descriptionController.text
      ),
      imageFiles
    );
    changeLoadingStatus();
    return value;
  }
}