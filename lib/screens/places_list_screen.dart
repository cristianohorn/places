import 'package:flutter/material.dart';
import 'package:places/providers/great_places.dart';
import 'package:places/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _loadPlaces() {
      Provider.of<GreatPlaces>(context).items;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus lugares'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                child: Center(
                  child: Text('Nenhum local cadastrado'),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.itemsCount == 0
                    ? ch!
                    : ListView.builder(
                        itemCount: greatPlaces.itemsCount,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlaces.itemByIndex(i).image),
                          ),
                          title: Text(greatPlaces.itemByIndex(i).title),
                          subtitle: Text(
                              greatPlaces.itemByIndex(i).location!.address),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.PLACE_DETAILS,
                              arguments: greatPlaces.itemByIndex(i),
                            );
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
