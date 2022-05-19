import 'package:albify/animations/custom_page_route_builder.dart';
import 'package:albify/animations/slide_directions.dart';
import 'package:albify/common/constants.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/screens/property/property_page.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteElement extends StatelessWidget {
  final PropertyModel property;

  const FavoriteElement({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 10, horizontal: MARGIN_HORIZONTAL),
      child: ListTile(
        leading: Image.network(
          property.photoUrls[0],
          width: 96,
        ),
        title:
            MyText(text: property.location.locationName ?? 'Unknown location'),
        subtitle: MyText(text: '${property.price} Ft'),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: Text('Remove from favorites'),
              onTap: () {
                Provider.of<DatabaseService>(context, listen: false)
                    .removeFromFavorites(property.id!);
              },
            )
          ],
        ),
        onTap: () => Navigator.of(context).push(CustomPageRouteBuilder(
            child: PropertyPage(property: property),
            direction: SlideDirections.FROM_DOWN)),
      ),
    );
  }
}
