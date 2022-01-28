




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var dataBank = FirebaseFirestore.instance.collection('cliente');

User currentUser;
FirebaseAuth authG = FirebaseAuth.instance;