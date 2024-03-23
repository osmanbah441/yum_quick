import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OrderPageListView extends StatelessWidget {
  const OrderPageListView({
    super.key,
    required this.pagingController,
    required this.onOrderSelected,
  });

  final PagingController<int, Order> pagingController;
  final void Function(String) onOrderSelected;

  @override
  Widget build(BuildContext context) => PagedListView(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Order>(
            itemBuilder: (context, order, index) {
          final textTheme = Theme.of(context).textTheme;
          return Card(
            color: order.status._color,
            child: ListTile(
              leading: order.status._icon,
              trailing: const Icon(Icons.arrow_right_outlined),
              onTap: () => onOrderSelected(order.id),
              title: Text(
                order.status._toLocalizedString,
                style: textTheme.titleMedium,
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery date', style: textTheme.labelMedium),
                  Text(order.formattedDate!, style: textTheme.labelMedium),
                ],
              ),
            ),
          );
        }),
      );
}

extension on OrderStatus {
  String get _toLocalizedString => switch (this) {
        OrderStatus.pending => 'Next in line!',
        OrderStatus.completed => 'Delivery dragon has landed!',
        OrderStatus.ongoing => 'Get ready to unpack!',
        OrderStatus.cancelled => 'Order on hold',
      };

  Color? get _color => switch (this) {
        OrderStatus.pending => const Color(0xFFB5DCFC),
        OrderStatus.completed => const Color(0xFFBDFABF),
        OrderStatus.ongoing => const Color(0xFFFFF9BE),
        OrderStatus.cancelled => const Color(0xFFF5B2AE),
      };

  Icon get _icon => switch (this) {
        OrderStatus.pending => const Icon(Icons.hourglass_empty_outlined),
        OrderStatus.completed => const Icon(Icons.done_outline),
        OrderStatus.ongoing => const Icon(Icons.gps_fixed_outlined),
        OrderStatus.cancelled => const Icon(Icons.cancel_outlined),
      };
}
