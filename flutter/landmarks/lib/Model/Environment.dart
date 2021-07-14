import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:landmarks/Model/AAS/Profile.dart';
import 'dart:convert';

import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Landmark.dart';
import 'package:landmarks/Model/TownsCollection.dart';


class Environment extends Object {
    static DataModel _model;

    static get model {
        return _model;
    }

    static Future<DataModel> initializeDataModel() async {
        Environment._model = DataModel();
        await Firebase.initializeApp();
        await Environment._loadLandmarksData(Environment._model);
        await Environment._loadStateTownData(Environment._model);
        await Environment._loadParticipant(Environment._model,FirebaseAuth.instance.currentUser);
        return Environment._model;
    }

    static Future<void> updateParticipant(Profile participant) async {
        User currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
            CollectionReference participants = FirebaseFirestore.instance.collection('participants');
            participants.doc(currentUser.uid).set(participant.toMap()).then((value){
                _model.participant = participant;
            });
        } else {
            _model.participant = participant;
        }
    }

    static void _loadLandmarksData(DataModel model) async {
        rootBundle.loadString('assets/jsons/landmarkData.json').then((value){
            List<dynamic> allLandmarks = jsonDecode(value) as List<dynamic>;
            Landmark tempLandmark;
            model.landmarks.clear();
            for (dynamic element in allLandmarks) {
                if (element is Map<String, dynamic>) {
                    tempLandmark = Landmark.newLandmark(element as Map<String, dynamic>);
                    model.landmarks.add(tempLandmark);
                    model.categoriesAndFeatures.addToCategories(tempLandmark);
                    model.categoriesAndFeatures.addToFeatures(tempLandmark);
                }
            }
        });
    }

    static void _loadStateTownData(DataModel model) async {
        rootBundle.loadString('assets/jsons/townsData.json').then((value){
            List<dynamic> allStateTowns = jsonDecode(value) as List<dynamic>;
            Towns tempTowns;
            model.townsCollection.clear();
            for (dynamic element in allStateTowns) {
                if (element is Map<String, dynamic>) {
                    tempTowns = Towns.newTowns(element as Map<String, dynamic>);
                    model.townsCollection.addTowns(tempTowns);
                }
            }
        });
    }

    static void _loadParticipant(DataModel model,User currentUser) async {
        if (currentUser != null) {
            final email = currentUser.email;
            CollectionReference participants = FirebaseFirestore.instance.collection('participants');
            DocumentSnapshot participant = await participants.doc(currentUser.uid).get();
            Map<String,dynamic> resultMap = participant.data();
            model.participant = Profile.newParticipant(resultMap);
        }
        // rootBundle.loadString('assets/jsons/user.json').then((value){
        //     model.user = Participant.newParticipant(jsonDecode(value) as Map<String,dynamic>);
        // });
    }
}