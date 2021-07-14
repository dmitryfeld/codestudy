
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:landmarks/Helpers/Places/AddressSearchDelegate.dart';
import 'package:landmarks/Helpers/Places/PlacesAPIProvider.dart';
import 'package:landmarks/Model/AAS/Validator.dart';
import 'package:landmarks/Model/AAS/Address.dart';
import 'package:uuid/uuid.dart';

typedef OnAddressFormTextChanged(Address addressP);
typedef OnAddressFormEditingCompleted(Address addressP);

// Create a Form widget.
@immutable class AddressForm extends StatefulWidget {
    final Address address;
    final OnAddressFormTextChanged onAddressFormTextChanged;
    final OnAddressFormEditingCompleted onAddressFormEditingCompleted;
    final bool readOnly;


    const AddressForm({this.address,this.onAddressFormTextChanged,this.onAddressFormEditingCompleted,this.readOnly = false,Key key}):
        //assert(onAddressFormTextChanged != null,'OnAddressFormTextChanged can not be null'),
        //assert(onAddressFormEditingCompleted != null,'OnAddressFormEditingCompleted can not be null'),
        super(key: key);

    @override AddressFormState createState() {
        return AddressFormState();
    }
}
class AddressFormState extends State<AddressForm> {
    TextEditingController _numberController = TextEditingController();
    TextEditingController _streetController = TextEditingController();
    TextEditingController _unitController = TextEditingController();
    TextEditingController _cityController = TextEditingController();
    TextEditingController _stateController = TextEditingController();
    TextEditingController _zipController = TextEditingController();

    PlacesAPIProvider _provider;
    AddressSearchDelegate _searchDellegate;

    Address _address;


    @override void initState() {
        super.initState();
        this._address = widget.address;
        this._assumeVars();
    }

    @override Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                this._createTitle(context),
                this._createStreetAddressComposition(context),
                this._createCityField(context),
                this._createStateField(context),
                this._createZipField(context),
            ],
        );
    }
    Address _formAddress() {
        return Address(
            unit: this._unitController.text,
            street: this._streetController.text,
            number: this._numberController.text,
            city: this._cityController.text,
            zipCode: this._zipController.text,
            country: 'USA',
            state: this._stateController.text
        );
    }
    Widget _createTitle(BuildContext context) {
        TextStyle headStyle = Theme.of(context).textTheme.headline6.apply(color: Colors.grey,fontWeightDelta: 2,fontSizeFactor:1);
        return Row(
            children: [
                Text(
                    'Address',
                    style: headStyle,
                ),
                Spacer(),
                !widget.readOnly ? this._createMoreButton(context) : Text('')
            ]
        );
    }
    Widget _createStreetAddressComposition(BuildContext context) {
        return Row(
            children: [
                Expanded(
                    flex: 1,
                    child:this._createNumberField(context)
                ),
                Expanded(
                    flex:2,
                    child: this._createStreetField(context)
                ),
                Expanded(
                    flex: 1,
                    child: this._createUnitField(context)
                )
            ],
        );
    }
    Widget _createNumberField(BuildContext context) {
        return TextFormField(
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
                hintText: '111',
                labelText: 'Number',
                //hintStyle: style
            ),
            controller: this._numberController,
            readOnly: widget.readOnly,
            onChanged: (value) {
                if (null != widget.onAddressFormTextChanged) {
                    widget.onAddressFormTextChanged(this._formAddress());
                }
            },
            validator: (value) {
                if (this._streetController.text == null || this._streetController.text.isEmpty) {
                    return '';
                }
                return null;
            },
            keyboardType: TextInputType.text,
            onEditingComplete: () {
                if (null != widget.onAddressFormEditingCompleted) {
                    widget.onAddressFormEditingCompleted(this._formAddress());
                }
                FocusScope.of(context).unfocus();
            }
        );
    }
    Widget _createStreetField(BuildContext context) {
        return TextFormField(
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
                hintText: 'Compton Crt',
                labelText: 'Street',
                //hintStyle: style
            ),
            controller: this._streetController,
            readOnly: widget.readOnly,
            validator: (value) {
                if (value == null || value.isEmpty) {
                    return 'Please enter valid Street';
                }
                return null;
            },
            onChanged: (value) {
                if (null != widget.onAddressFormTextChanged) {
                    widget.onAddressFormTextChanged(this._formAddress());
                }
            },
            keyboardType: TextInputType.text,
            onEditingComplete: () {
                if (null != widget.onAddressFormEditingCompleted) {
                    widget.onAddressFormEditingCompleted(this._formAddress());
                }
                FocusScope.of(context).unfocus();
            }
        );
    }
    Widget _createUnitField(BuildContext context) {
        return TextFormField(
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
                hintText: '314',
                labelText: 'Unit',
                //hintStyle: style
            ),
            controller: this._unitController,
            readOnly: widget.readOnly,
            validator: (value) {
                if (this._streetController.text == null || this._streetController.text.isEmpty) {
                    return '';
                }
                return null;
            },
            onChanged: (value) {
                if (null != widget.onAddressFormTextChanged) {
                    widget.onAddressFormTextChanged(this._formAddress());
                }
            },
            keyboardType: TextInputType.text,
            onEditingComplete: () {
                if (null != widget.onAddressFormEditingCompleted) {
                    widget.onAddressFormEditingCompleted(this._formAddress());
                }
                FocusScope.of(context).unfocus();
            }
        );
    }
    Widget _createCityField(BuildContext context) {
        return TextFormField(
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
                hintText: 'Ashland',
                labelText: 'City',
                //suffixIcon: this._createMoreButton(context, widget.onCity),
                //contentPadding: EdgeInsets.only(right: 10)
            ),
            controller: this._cityController,
            readOnly: widget.readOnly,
            validator: (value) {
                if (value == null || value.isEmpty && !Validator.validateCity(value)) {
                    return 'Please enter valid City';
                }
                return null;
            },
            keyboardType: TextInputType.text,
            onChanged: (value) {
                if (null != widget.onAddressFormTextChanged) {
                    widget.onAddressFormTextChanged(this._formAddress());
                }
            },
            onEditingComplete: () {
                if (null != widget.onAddressFormEditingCompleted) {
                    widget.onAddressFormEditingCompleted(this._formAddress());
                }
                FocusScope.of(context).unfocus();
            },
        );
    }
    Widget _createStateField(BuildContext context) {
        return TextFormField(
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
                hintText: 'Oregon',
                labelText: 'State',
                //suffixIcon: this._createMoreButton(context, widget.onState),
            ),
            controller: this._stateController,
            readOnly: widget.readOnly,
            validator: (value) {
                if (value == null || value.isEmpty && !Validator.validateState(value)) {
                    return 'Please enter valid City';
                }
                return null;
            },
            keyboardType: TextInputType.text,
            onChanged: (value) {
                if (null != widget.onAddressFormTextChanged) {
                    widget.onAddressFormTextChanged(this._formAddress());
                }
            },
            onEditingComplete: () {
                if (null != widget.onAddressFormEditingCompleted) {
                    widget.onAddressFormEditingCompleted(this._formAddress());
                }
                FocusScope.of(context).unfocus();
            },
        );
    }
    Widget _createZipField(BuildContext context) {
        return TextFormField(
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
                hintText: '95051',
                labelText: 'Zip'
            ),
            controller: this._zipController,
            readOnly: widget.readOnly,
            validator: (value) {
                if (value == null || value.isEmpty && !Validator.validateZip(value)) {
                    return 'Please enter valid Zip Code';
                }
                return null;
            },
            keyboardType: TextInputType.number,
            onChanged: (value) {
                if (null != widget.onAddressFormTextChanged) {
                    widget.onAddressFormTextChanged(this._formAddress());
                }
            },
            onEditingComplete: () {
                if (null != widget.onAddressFormEditingCompleted) {
                    widget.onAddressFormEditingCompleted(this._formAddress());
                }
                FocusScope.of(context).unfocus();
            },
        );
    }
    Widget _createMoreButton(BuildContext context) {
        return IconButton (
            icon: Icon(
                    Icons.more,
                    size: 35,
                    color: Colors.grey,

            ),
            onPressed: this._onPressed
        );
    }

    void _assumeVars() {
        this._numberController.text = '';
        this._streetController.text = '';
        this._unitController.text = '';
        this._cityController.text = '';
        this._stateController.text = '';
        this._zipController.text = '';
        if (this._address != null) {
            this._numberController.text = this._address.number == null ? '' : this._address.number;
            this._streetController.text = this._address.street == null ? '' : this._address.street;
            this._unitController.text = this._address.unit == null ? '' : this._address.unit;
            this._cityController.text = this._address.city == null ? '' : this._address.city;
            this._stateController.text = this._address.state == null ? '' : this._address.state;
            this._zipController.text = this._address.zipCode == null ? '' : this._address.zipCode;
        }
    }

    void _onPressed() async {
        Suggestion result = await showSearch(
            context: context,
            delegate: this._createSearchDelegate(context)
        );
        // This will change the text displayed in the TextField
        if (result != null) {
            this._address = await this._createProvider(context).getPlaceDetailFromId(result.placeId);
            setState(() {
                 this._assumeVars();
            });
            if (null != widget.onAddressFormTextChanged) {
                widget.onAddressFormTextChanged(this._address);
            }
        }
    }


    PlacesAPIProvider _createProvider(BuildContext context) {
        if (null == this._provider) {
            String sessionToken = Uuid().v4();
            String language = Localizations.localeOf(context).languageCode;
            String country = 'us';
            this._provider = PlacesAPIProvider(
                sessionToken: sessionToken,
                language: language,
                country: country
            );
        }
        return this._provider;
    }
    AddressSearchDelegate _createSearchDelegate(BuildContext context) {
        if (null == this._searchDellegate) {
            this._searchDellegate = AddressSearchDelegate(
                apiClient:this._createProvider(context)
            );
        }
        return this._searchDellegate;
    }
}

