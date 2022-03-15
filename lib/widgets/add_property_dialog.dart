import 'dart:io';

import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/providers/property_create_provider.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:albify/widgets/rounded_dropdown_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPropertyDialog extends StatefulWidget {
  @override
  State<AddPropertyDialog> createState() => _AddPropertyDialogState();
}

class _AddPropertyDialogState extends State<AddPropertyDialog> {
  final _addPropertyFormKey = GlobalKey<FormState>();
  List<PlatformFile> _imageFiles = [];

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => PropertyCreateProvider(Provider.of<DatabaseService>(context, listen: false)),
      builder: (context, child) {
        final _propertyCreateProvider = Provider.of<PropertyCreateProvider>(context, listen: true);
        print(getPreferredSize(_size));
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RADIUS)
          ),
          elevation: 0,
          content: Center(
            child: Container(
              width: getPreferredSize(_size),
              margin: EdgeInsets.all(DIALOG_MARGIN),
              // padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(RADIUS),
              ),
              child: Form(
                key: _addPropertyFormKey,
                child: Column(
                  children: [
                    CircularTextFormField(
                      hintText: 'Price',
                      icon: Icon(Icons.price_change),
                      validateFun: Utils.validatePrice,
                      textEditingController: _propertyCreateProvider.priceController,
                      inputType: TextInputType.number,
                    ),
                    Utils.addVerticalSpace(8),
                    CircularTextFormField(
                      hintText: 'Rooms',
                      icon: Icon(Icons.meeting_room),
                      validateFun: Utils.validateRooms,
                      textEditingController: _propertyCreateProvider.roomsController,
                      inputType: TextInputType.number,
                    ),
                    Utils.addVerticalSpace(8),
                    CircularTextFormField(
                      hintText: 'Floorspace',
                      icon: Icon(Icons.area_chart),
                      validateFun: Utils.validateFloorspace,
                      textEditingController: _propertyCreateProvider.floorspaceController,
                      inputType: TextInputType.number,
                    ),
                    Utils.addVerticalSpace(8),
                    Selector<PropertyCreateProvider, int>(
                      selector: (_, propertyCreateProvider) => propertyCreateProvider.propertyTypeValue,
                      builder: (_, typeValue, __) => RoundedDropdownButton(
                        value: typeValue,
                        items: getDropdownButtonItems(),
                        onChanged: (value) {
                          _propertyCreateProvider.changePropertyTypeValue(value!);
                        },
                      ),
                    ),
                    Utils.addVerticalSpace(8),
                    Selector<PropertyCreateProvider, bool>(
                      selector: (_, propertyCreateProvider) => propertyCreateProvider.forSale,
                      builder: (_, isItForSale, __) => SwitchListTile(
                        title: Text('For sale?'),
                        value: isItForSale,
                        onChanged: (bool value) {
                          _propertyCreateProvider.changeForSaleStatus();
                        }
                      ),
                    ),
                    Utils.addVerticalSpace(8),
                    Selector<PropertyCreateProvider, bool>(
                      selector: (_, propertyCreateProvider) => propertyCreateProvider.newlyBuilt,
                      builder: (_, isItNewlyBuilt, __) => SwitchListTile(
                        title: Text('Newly built?'),
                        value: isItNewlyBuilt,
                        onChanged: (bool value) {
                          _propertyCreateProvider.changeNewlyBuiltStatus();
                        }
                      ),
                    ),
                    Utils.addVerticalSpace(8),
                    RoundedButton(
                      text: 'Choose images',
                      outlined: true,
                      onPressed: () async {
                        selectImages();
                      },
                    ),
                    _imageFiles.isNotEmpty ?
                      LimitedBox(
                        maxWidth: getPreferredSize(_size),
                        maxHeight: getGridContainerHeight(_size),
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 8
                          ),
                          width: getPreferredSize(_size),
                          height: getGridContainerHeight(_size),
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _imageFiles.length,
                            primary: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isWebWidth(_size) ? 2 : 1,
                              childAspectRatio: 1.0,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4
                            ),
                            itemBuilder: (context, index) =>
                              Stack(
                                children: [
                                  Container(
                                    child: kIsWeb ? 
                                      Image.memory(
                                        _imageFiles[index].bytes!,
                                        fit: BoxFit.cover,
                                      ) :
                                      Image.file(
                                        File(_imageFiles[index].path!),
                                        fit: BoxFit.cover,
                                      ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _imageFiles.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ]
                              )
                          ),
                        ),
                      ) :
                      Container(),
                    Utils.addVerticalSpace(16),
                    Selector<PropertyCreateProvider, bool>(
                      selector: (_, propertyCreateProvider) => propertyCreateProvider.isLoading,
                      builder: (_, onLoading, __) => onLoading ?
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppStyle.appColorGreen),
                        )
                        : RoundedButton(
                            text: 'Add property',
                            onPressed: () async {
                              if (_addPropertyFormKey.currentState!.validate()) {
                                if (_imageFiles.isEmpty) {
                                  Utils.showToast('At least one image must be selected');
                                } else {
                                  bool value = await _propertyCreateProvider.submit(_imageFiles);
                                  Navigator.pop(context, value);
                                }
                              }
                            },
                          ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  getDropdownButtonItems() =>
    PropertyType.values.map((value) {
      return DropdownMenuItem(
        child: Text(Utils.enumToString(value)),
        value: value.index
      );
    }).toList();

  getGridContainerHeight(Size size) {
    int count = isWebWidth(size) ? 2 : 1;
    print('Count: ' + count.toString());
    print('Images count: ' + _imageFiles.length.toString());
    int rowHeight = (_imageFiles.length / count).round();
    print('Row height: ' + rowHeight.toString());
    double height = (getPreferredSize(size) - 2 * DIALOG_MARGIN) / count * rowHeight;
    print('Height: ' + height.toString());
    return height;
  }

  selectImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg']
    );

    if (result != null) {
      setState(() {
        _imageFiles = result.files;
      });
    }
  }
}