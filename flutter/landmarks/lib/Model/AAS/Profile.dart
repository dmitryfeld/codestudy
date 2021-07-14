import 'package:landmarks/Model/AAS/Contact.dart';
import 'package:landmarks/Model/AAS/Person.dart';
import 'package:landmarks/Model/AAS/Address.dart';
import 'package:landmarks/Model/AAS/Credentials.dart';

class Profile extends Object {
    final Person person;
    final Address address;
    final Contact contact;

    const Profile({this.person,this.address,this.contact}) : super();
    bool get valid {
        return this.person.valid && this.address.valid && this.contact.valid;
    }
    Profile apply({Person person = null,Address address = null,Contact contact = null,Credentials credentials = null}) {
        return Profile(
            person: person == null ? this.person : person,
            address: address == null ? this.address : address,
            contact: contact == null ? this.contact : contact
        );
    }
    static Profile newParticipant(Map<String,dynamic> map) {
        return Profile(
            address: Address.newAddress(map['address'] as Map<String,dynamic>),
            contact: Contact.newContact(map['contact'] as Map<String,dynamic>),
            person:  Person.newPerson(map['person'] as Map<String,dynamic>)
        );
    }
    Map<String,dynamic> toMap() {
        Map<String,dynamic> result = Map<String,dynamic>();
        result['address'] = this.address.toMap();
        result['contact'] = this.contact.toMap();
        result['person'] = this.person.toMap();
        return result;
    }
}