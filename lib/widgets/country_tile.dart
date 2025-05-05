import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CountryTile extends StatelessWidget {
  final Country country;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showPopularity;
  final int? popularity;

  const CountryTile({
    Key? key,
    required this.country,
    this.onTap,
    this.isSelected = false,
    this.showPopularity = false,
    this.popularity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? const Color(0xFF0066CC) : Colors.grey.shade300,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Country flag
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/flags/${country.countryCode.toLowerCase()}.png',
                  width: 32,
                  height: 24,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 32,
                      height: 24,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: Text(
                        country.countryCode,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Country name and optional info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF0066CC) : Colors.black87,
                      ),
                    ),
                    if (showPopularity && popularity != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 14,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Popular destination',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Selected indicator or phone code
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF0066CC),
                  size: 20,
                )
              else if (showPopularity && popularity != null)
                _buildPopularityIndicator(popularity!)
              else
                Text(
                  country.phoneCode,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPopularityIndicator(int popularity) {
    final color = popularity > 90 
        ? Colors.green 
        : popularity > 70 
            ? Colors.amber 
            : Colors.grey.shade500;
    
    return Container(
      width: 36,
      height: 18,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: Text(
        '$popularity%',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}