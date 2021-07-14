
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:landmarks/Model/AAS/Validator.dart';
import 'package:landmarks/Model/AAS/Person.dart';

typedef OnPersonFormTextChanged(Person personP);
typedef OnPersonFormEditingCompleted(Person personP);


@immutable class PersonForm extends StatefulWidget {
    final Person person;
    final OnPersonFormTextChanged onPersonFormTextChanged;
    final OnPersonFormEditingCompleted onPersonFormEditingCompleted;
    final bool readOnly;

    PersonForm({this.person,this.onPersonFormTextChanged,this.onPersonFormEditingCompleted,this.readOnly = false,Key key}) :
        //assert(onPersonFormTextChanged != null,'OnPersonFormTextChanged can not be null'),
        //assert(onPersonFormEditingCompleted != null,'OnPersonFormEditingCompleted can not be null'),
        super(key: key);

    @override PersonFormState createState() {
        return PersonFormState();
    }
}
class PersonFormState extends State<PersonForm> {
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();

    @override void initState() {
        super.initState();
        if (widget.person != null) {
            this._firstNameController.text = widget.person.firstName;
            this._lastNameController.text = widget.person.lastName;
        }
    }

    @override Widget build(BuildContext context) {
       TextStyle style = Theme.of(context).textTheme.headline6.apply(color: Colors.grey,fontWeightDelta: -1,fontSizeFactor:0.75);
       TextStyle headStyle = Theme.of(context).textTheme.headline6.apply(color: Colors.grey,fontWeightDelta: 2,fontSizeFactor:1);

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Text(
                    'User Name',
                    style: headStyle,
                ),
                TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                        hintText: 'Joe',
                        labelText: 'First Name',
                        hintStyle: style
                    ),
                    controller: this._firstNameController,
                    readOnly: widget.readOnly,
                    textCapitalization: TextCapitalization.words,
                    //obscureText: true,
                    validator: (value) {
                        if (value == null || value.isEmpty && !Validator.validateName(value)) {
                            return 'Please enter valid First Name';
                        }
                        return null;
                    },
                    onChanged: (value) {
                        if (null != widget.onPersonFormTextChanged) {
                            widget.onPersonFormTextChanged(this._formPerson());
                        }
                    },
                    // keyboardType: TextInputType.text,
                    // inputFormatters: [
                    //     FilteringTextInputFormatter.deny(
                    //         RegExp(
                    //             r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$"
                    //         )
                    //         //replacementString: ''
                    //     )
                    // ],
                    onEditingComplete: () {
                        if (null != widget.onPersonFormEditingCompleted) {
                            widget.onPersonFormEditingCompleted(this._formPerson());
                        }
                        FocusScope.of(context).unfocus();
                    }
                ),
                TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                        labelText: 'Last Name'
                    ),
                    controller: this._lastNameController,
                    readOnly: widget.readOnly,
                    validator: (value) {
                        if (value == null || value.isEmpty && !Validator.validateName(value)) {
                            return 'Please enter valid Last Name';
                        }
                        return null;
                    },
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                        if (null != widget.onPersonFormTextChanged) {
                            widget.onPersonFormTextChanged(this._formPerson());
                        }
                    },
                    onEditingComplete: () {
                        if (null != widget.onPersonFormEditingCompleted) {
                            widget.onPersonFormEditingCompleted(this._formPerson());
                        }
                        FocusScope.of(context).unfocus();
                    },
                )
            ]
        );
    }
    Person _formPerson() {
        return Person(
            firstName: this._firstNameController.text,
            lastName: this._lastNameController.text
        );
    }
}