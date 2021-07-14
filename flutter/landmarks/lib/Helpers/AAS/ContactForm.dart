
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:landmarks/Model/AAS/Validator.dart';
import 'package:landmarks/Model/AAS/Contact.dart';

typedef OnContactFormTextChanged(Contact contactP);
typedef OnContactFormEditingCompleted(Contact contactP);


@immutable class ContactForm extends StatefulWidget {
    final Contact contact;
    final OnContactFormTextChanged onContactFormTextChanged;
    final OnContactFormEditingCompleted onContactFormEditingCompleted;
    final bool readOnly;

    const ContactForm({this.contact,this.onContactFormTextChanged,this.onContactFormEditingCompleted,this.readOnly = false,Key key}):
        //assert(onContactFormTextChanged != null,'OnContactFormTextChanged can not be null'),
        //assert(onContactFormEditingCompleted != null,'OnContactFormEditingCompleted can not be null'),
        super(key: key);

    @override ContactFormState createState() {
        return ContactFormState();
    }
}
class ContactFormState extends State<ContactForm> {
    TextEditingController _phoneNumberController = TextEditingController(
    );
    TextEditingController _emailController = TextEditingController();

    @override void initState() {
        super.initState();
        if (widget.contact != null) {
            this._phoneNumberController.text = widget.contact.phone;
            this._emailController.text = widget.contact.email;
        }
    }

    @override Widget build(BuildContext context) {
        TextStyle style = Theme.of(context).textTheme.headline6.apply(color: Colors.grey,fontWeightDelta: -1,fontSizeFactor:0.75);
        TextStyle headStyle = Theme.of(context).textTheme.headline6.apply(color: Colors.grey,fontWeightDelta: 2,fontSizeFactor:1);

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Text(
                    'Contact',
                    style: headStyle,
                ),
                TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                        hintText: '+14086806862',
                        labelText: 'Phone Number',
                        hintStyle: style
                    ),
                    controller: this._phoneNumberController,
                    readOnly: widget.readOnly,
                    //obscureText: true,
                    validator: (value) {
                        if (value == null || value.isEmpty && !Validator.validatePhone(value)) {
                            return 'Please enter valid Phone Number';
                        }
                        return null;
                    },
                    onChanged: (value) {
                        if (null != widget.onContactFormTextChanged) {
                            widget.onContactFormTextChanged(this._formContact());
                        }
                    },
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    // inputFormatters: [
                    //     FilteringTextInputFormatter.deny(
                    //         RegExp(
                    //             r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$"
                    //         )
                    //         //replacementString: ''
                    //     )
                    // ],
                    onEditingComplete: () {
                        if (null != widget.onContactFormEditingCompleted) {
                            widget.onContactFormEditingCompleted(this._formContact());
                        }
                        FocusScope.of(context).unfocus();
                    }
                ),
                TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                        hintText: 'me@you.org',
                        labelText: 'Email'
                    ),
                    controller: this._emailController,
                    readOnly: widget.readOnly,
                    validator: (value) {
                        if (value == null || value.isEmpty && !Validator.validateEmail(value)) {
                            return 'Please enter valid Last Name';
                        }
                        return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {
                        if (null != widget.onContactFormTextChanged) {
                            widget.onContactFormTextChanged(this._formContact());
                        }
                    },
                    onEditingComplete: () {
                        if (null != widget.onContactFormEditingCompleted) {
                            widget.onContactFormEditingCompleted(this._formContact());
                        }
                        FocusScope.of(context).unfocus();
                    },
                )
            ],
        );
    }
    Contact _formContact() {
        return Contact(
            email: this._emailController.text.toLowerCase(),
            phone: this._phoneNumberController.text,
        );
    }
}
