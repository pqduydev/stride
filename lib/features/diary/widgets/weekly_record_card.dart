import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WeeklyRecordCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const WeeklyRecordCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 228,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE8ECE8), width: 1),
      ),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .start,
        children: [
          Stack(
            children: [
              // ClipRRect để bo 2 góc trên của hình ảnh
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.asset(
                  imagePath,
                  height: 118,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      color: Colors.grey[300],
                      alignment: .center,
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'weekly_record_card.illustration'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 11,
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 17,
                  fontWeight: .w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 13,
                  fontWeight: .w400,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
