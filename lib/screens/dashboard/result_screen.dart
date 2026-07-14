import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../core/constants.dart';

class ResultScreen extends StatelessWidget {
  final ProductModel product;

  const ResultScreen({super.key, required this.product});

  Color get _scoreColor {
    if (product.trustScore >= AppConstants.safeScore) {
      return const Color(0xFF16A34A);
    } else if (product.trustScore >= AppConstants.cautionScore) {
      return const Color(0xFFF59E0B);
    } else {
      return const Color(0xFFDC2626);
    }
  }

  String get _scoreLabel {
    if (product.trustScore >= AppConstants.safeScore) {
      return 'Safe to Buy';
    } else if (product.trustScore >= AppConstants.cautionScore) {
      return 'Proceed with Caution';
    } else {
      return 'Avoid this Product';
    }
  }

  IconData get _scoreIcon {
    if (product.trustScore >= AppConstants.safeScore) {
      return Icons.verified_outlined;
    } else if (product.trustScore >= AppConstants.cautionScore) {
      return Icons.warning_amber_outlined;
    } else {
      return Icons.dangerous_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trust Analysis',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product name
            Text(
              product.productName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.productUrl,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),

            // Trust score card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _scoreColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _scoreIcon,
                    size: 48,
                    color: _scoreColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${product.trustScore.toInt()}',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: _scoreColor,
                    ),
                  ),
                  Text(
                    'Trust Score',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _scoreColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _scoreLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _scoreColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Score breakdown
            const Text(
              'Score Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            _buildScoreBar('Reviews', product.trustScore, Icons.star_outline),
            _buildScoreBar('Seller', product.trustScore * 0.9, Icons.store_outlined),
            _buildScoreBar('Price', product.trustScore * 1.1 > 100 ? 100 : product.trustScore * 1.1, Icons.price_check_outlined),
            const SizedBox(height: 24),

            // AI Explanation
            const Text(
              'AI Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.psychology_outlined,
                    color: Color(0xFF2563EB),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      product.trustExplanation,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Red flags
            if (product.redFlags.isNotEmpty) ...[
              const Text(
                'Red Flags',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              ...product.redFlags.map(
                (flag) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFECACA),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_outlined,
                        color: Color(0xFFDC2626),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          flag,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Back button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.search),
                label: const Text(
                  'Analyze Another Product',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar(String label, double score, IconData icon) {
    final clampedScore = score.clamp(0.0, 100.0);
    Color barColor;
    if (clampedScore >= 70) {
      barColor = const Color(0xFF16A34A);
    } else if (clampedScore >= 40) {
      barColor = const Color(0xFFF59E0B);
    } else {
      barColor = const Color(0xFFDC2626);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              Text(
                '${clampedScore.toInt()}/100',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: clampedScore / 100,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}