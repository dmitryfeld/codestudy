import 'package:flutter/material.dart';
import 'package:landmarks/Helpers/Places/PlacesAPIProvider.dart';

class AddressSearchDelegate extends SearchDelegate<Suggestion> {

    final PlacesAPIProvider apiClient;

    AddressSearchDelegate({this.apiClient}) :
        assert(apiClient != null,'API Client can not be null'),
        super();

    @override List<Widget> buildActions(BuildContext context) {
        return [
            IconButton(
                tooltip: 'Clear',
                icon: Icon(Icons.clear),
                onPressed: () {
                    this.query = '';
                },
            )
        ];
    }

    @override Widget buildLeading(BuildContext context) {
        return IconButton(
            tooltip: 'Back',
            icon: Icon(Icons.arrow_back),
            onPressed: () {
                this.close(context, null);
            }
        );
    }

    @override Widget buildResults(BuildContext context) {
        return null;
    }

    @override Widget buildSuggestions(BuildContext context) {
        Future<List<Suggestion>> suggestions = null;
        if (this.query.length != 0) {
            suggestions = this.apiClient.fetchSuggestions(
                this.query,
            );
        }
        return FutureBuilder(
            future: suggestions,
            builder: (BuildContext contextP, AsyncSnapshot snapshotP) {
                if (this.query.length == 0) {
                    return Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Enter your address'),
                    );
                }
                if (snapshotP.hasData) {
                    return ListView.builder(
                        itemCount: snapshotP.data.length,
                        itemBuilder: (BuildContext contextP, int indexP) {
                            return ListTile(
                                title: Text(
                                    (snapshotP.data[indexP] as Suggestion).description
                                ),
                                onTap: () {
                                    this.close(context, snapshotP.data[indexP] as Suggestion);
                                },
                            );
                        }
                    );
                } else if (snapshotP.hasError) {
                    return Container(
                        child: Text(
                            snapshotP.error.toString() + 'Error!!!'
                        )
                    );
                } else {
                    return Container(
                        child: Text(
                            'Loading...'
                        )
                    );
                }
            }
        );
    }
}
