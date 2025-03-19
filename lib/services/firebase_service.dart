import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;


class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  late final FirebaseFirestore _firestore;
  bool _initialized = false;

  // Singleton pattern
  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<void> initialize() async {
    try {
      if (!_initialized) {
        FirebaseOptions? options;

        if (kIsWeb) {
          // Web Firebase configuration
          options = const FirebaseOptions(
            apiKey: "AIzaSyCAPUQ9VSaLuDDtDTLWLj9Ii3KyQzyMJBA",
            authDomain: "data-f9959.firebaseapp.com",
            projectId: "data-f9959",
            storageBucket: "data-f9959.firebasestorage.app",
            messagingSenderId: "603995143773",
            appId: "1:603995143773:web:fe1b1656cfbfa19bb957b4"
          );
        } else if (Platform.isAndroid) {
          // Android Firebase configuration
          options = const FirebaseOptions(
            apiKey: "AIzaSyAxn47L0e0Q_SwQs3SQABgnpRm0pUREgAE",
            appId: "1:259095385005:android:e8cf0e378adc65daae8724",
            messagingSenderId: "259095385005",
            projectId: "r-square-530ea",
            storageBucket: "r-square-530ea.firebasestorage.app",
            databaseURL: "https://r-square-530ea-default-rtdb.firebaseio.com",
          );
        } else if (Platform.isIOS) {
          // iOS Firebase configuration
          options = const FirebaseOptions(
            apiKey: "AIzaSyDXJnZh-qlxmUYoSS-V2wf9EPWo_B4xWn8",
            appId: "1:259095385005:ios:7dedc94e92b45434ae8724",
            messagingSenderId: "259095385005",
            projectId: "r-square-530ea",
            storageBucket: "r-square-530ea.firebasestorage.app",
            iosBundleId: "com.example.attendanceApp",
            databaseURL: "https://r-square-530ea-default-rtdb.firebaseio.com",
          );
        }

        if (options == null) {
          throw Exception('Unsupported platform for Firebase initialization');
        }

        await Firebase.initializeApp(options: options);
        _firestore = FirebaseFirestore.instance;
        _initialized = true;
      }
    } catch (e) {
      throw Exception('Failed to initialize Firebase: ${e.toString()}');
    }
  }

  // Get collection reference
  CollectionReference getCollection(String collection) {
    if (!_initialized) {
      throw Exception(
          'Firebase has not been initialized. Call initialize() first.');
    }
    return _firestore.collection(collection);
  }

  // Add a document to a collection
  Future<void> addDocument(
      String collection, String documentId, Map<String, dynamic> data) async {
    try {
      final collectionRef = getCollection(collection);
      await collectionRef.doc(documentId).set(data);
    } catch (e) {
      throw Exception('Failed to add document: ${e.toString()}');
    }
  }

  // Get a document by ID
  Future<DocumentSnapshot> getDocument(
      String collection, String documentId) async {
    try {
      final collectionRef = getCollection(collection);
      return await collectionRef.doc(documentId).get();
    } catch (e) {
      throw Exception('Failed to get document: ${e.toString()}');
    }
  }

  // Get all documents in a collection
  Stream<QuerySnapshot> getCollectionStream(String collection) {
    try {
      final collectionRef = getCollection(collection);
      return collectionRef.snapshots();
    } catch (e) {
      throw Exception('Failed to get collection stream: ${e.toString()}');
    }
  }

  // Update a document
  Future<void> updateDocument(
      String collection, String documentId, Map<String, dynamic> data) async {
    try {
      final collectionRef = getCollection(collection);
      await collectionRef.doc(documentId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: ${e.toString()}');
    }
  }

  // Delete a document
  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      final collectionRef = getCollection(collection);
      await collectionRef.doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: ${e.toString()}');
    }
  }
}
