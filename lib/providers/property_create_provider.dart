import 'package:albify/models/property_model.dart';
import 'package:albify/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  Future<bool> submit() async {
    await changeLoadingStatus();
    await Future.delayed(Duration(milliseconds: 500));

    bool value = await databaseService.addProperty(
      PropertyModel(
        location: PropertyLocation(
          47.4811516,
          19.0555954
        ),
        type: PropertyType.values[this.propertyTypeValue],
        rooms: int.parse(_roomsController.text),
        price: int.parse(_priceController.text),
        floorspace: double.parse(_floorspaceController.text),
        newlyBuilt: this.newlyBuilt,
        forSale: this.forSale,
        photoUrls: []
      )
    );
    changeLoadingStatus();
    return value;
  }
}