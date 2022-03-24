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
import 'package:responsive_grid/responsive_grid.dart';

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
                    CircularTextFormField(
                      hintText: 'Write about the property ...',
                      icon: Icon(Icons.list_alt),
                      validateFun: Utils.validateDescription,
                      textEditingController: _propertyCreateProvider.descriptionController,
                      maxLines: null,
                      maxLength: 500,
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
                      Container(
                        margin: EdgeInsets.only(
                          top: 8
                        ),
                        child: SingleChildScrollView(
                          child: Container(
                            child: ResponsiveGridRow(
                              children: _imageFiles.map(
                                (image) => ResponsiveGridCol(
                                  xs: 12,
                                  sm: 12,
                                  md: 12,
                                  lg: 6,
                                  xl: 6,
                                  child: Stack(
                                    children: [
                                      kIsWeb ?
                                        Image.memory(
                                          image.bytes!,
                                          fit: BoxFit.cover,
                                        ) :
                                        Image.file(
                                          File(image.path!),
                                          fit: BoxFit.cover
                                        ),
                                      Container(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              _imageFiles.remove(image);
                                            });
                                          },
                                        ),
                                      )
                                    ]
                                  ),
                                )
                              ).toList(),
                            ),
                          ),
                        ),
                      )
                      : Container(),
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