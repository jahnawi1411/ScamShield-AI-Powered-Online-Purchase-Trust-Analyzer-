import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';
import '../core/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save product analysis to Firestore
  Future<ProductModel> saveProduct({
    required String productName,
    required String productUrl,
    required Map<String, dynamic> analysisResult,
  }) async {
    try {
      final userId = _auth.currentUser?.uid ?? '';
      final docRef = _firestore
          .collection(AppConstants.productsCollection)
          .doc();

      final product = ProductModel(
        id: docRef.id,
        userId: userId,
        productUrl: productUrl,
        productName: productName,
        trustScore: (analysisResult['trustScore'] ?? 50).toDouble(),
        trustExplanation: analysisResult['explanation'] ?? '',
        redFlags: List<String>.from(analysisResult['redFlags'] ?? []),
        recommendation: analysisResult['recommendation'] ?? 'caution',
        status: AppConstants.statusAnalyzed,
        createdAt: DateTime.now(),
      );

      await docRef.set(product.toMap());
      print('=== Product saved to Firestore ===');
      return product;
    } catch (e) {
      print('=== Firestore Error: $e ===');
      rethrow;
    }
  }

  // Get user's product history
  Stream<List<ProductModel>> getUserProducts() {
    final userId = _auth.currentUser?.uid ?? '';
    return _firestore
        .collection(AppConstants.productsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.data()))
            .toList());
  }
  // Get total products analyzed
Future<int> getTotalAnalyzed() async {
  final userId = _auth.currentUser?.uid ?? '';
  final snapshot = await _firestore
      .collection(AppConstants.productsCollection)
      .where('userId', isEqualTo: userId)
      .get();
  return snapshot.docs.length;
}

// Get total scams detected (score below 40)
Future<int> getTotalScams() async {
  final userId = _auth.currentUser?.uid ?? '';
  final snapshot = await _firestore
      .collection(AppConstants.productsCollection)
      .where('userId', isEqualTo: userId)
      .where('recommendation', isEqualTo: 'avoid')
      .get();
  return snapshot.docs.length;
}

// Get total safe purchases (score above 70)
Future<int> getTotalSafe() async {
  final userId = _auth.currentUser?.uid ?? '';
  final snapshot = await _firestore
      .collection(AppConstants.productsCollection)
      .where('userId', isEqualTo: userId)
      .where('recommendation', isEqualTo: 'safe')
      .get();
  return snapshot.docs.length;
}
}
