class ProductModel {
  final String id;
  final String userId;
  final String productUrl;
  final String productName;
  final double trustScore;
  final String trustExplanation;
  final List<String> redFlags;
  final String recommendation;
  final String status;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.userId,
    required this.productUrl,
    required this.productName,
    required this.trustScore,
    required this.trustExplanation,
    required this.redFlags,
    required this.recommendation,
    required this.status,
    required this.createdAt,
  });

  // Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productUrl': productUrl,
      'productName': productName,
      'trustScore': trustScore,
      'trustExplanation': trustExplanation,
      'redFlags': redFlags,
      'recommendation': recommendation,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Firestore map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      productUrl: map['productUrl'] ?? '',
      productName: map['productName'] ?? '',
      trustScore: (map['trustScore'] ?? 0.0).toDouble(),
      trustExplanation: map['trustExplanation'] ?? '',
      redFlags: List<String>.from(map['redFlags'] ?? []),
      recommendation: map['recommendation'] ?? 'caution',
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}