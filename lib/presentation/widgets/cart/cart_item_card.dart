import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:re_serve/data/models/cart_model.dart';

class CartItemCard extends StatelessWidget {
  final CartModel cartItem;
  final VoidCallback onDelete;
  final ValueChanged<int> onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final food = cartItem.food;
    if (food == null) return const SizedBox.shrink();

    final name = food['name'] as String? ?? 'Unknown';
    final imageUrl = food['imageUrl'] as String?;
    final originalPrice = food['price'] as int? ?? 0;
    final discountPrice = food['priceDiscount'] as int?;
    final finalPrice = discountPrice ?? originalPrice;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.fastfood,
                          color: Colors.grey,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 12),

          // Food Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Pricing
                Row(
                  children: [
                    if (discountPrice != null) ...[
                      Text(
                        'Rp ${originalPrice.toString()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      'Rp ${finalPrice.toString()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE74C3C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Quantity Controls
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onPressed: cartItem.quantity > 1
                          ? () => onQuantityChanged(cartItem.quantity - 1)
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        cartItem.quantity.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onPressed: () => onQuantityChanged(cartItem.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete Button
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: onPressed != null ? const Color(0xFFE74C3C) : Colors.grey[300],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onPressed != null ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
