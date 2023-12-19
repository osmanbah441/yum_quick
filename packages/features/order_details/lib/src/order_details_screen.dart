import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:component_library/component_library.dart';
import 'package:order_repository/order_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'order_details_cubit.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.onBackButtonTap,
    required this.orderId,
    required this.orderRepository,
    required this.userRepository,
  });

  final String orderId;
  final OrderRepository orderRepository;
  final VoidCallback onBackButtonTap;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailsCubit>(
      create: (context) => OrderDetailsCubit(
        userRepository: userRepository,
        orderId: orderId,
        orderRepository: orderRepository,
      ),
      child: OrderDetailsView(onBackButtonTap: onBackButtonTap),
    );
  }
}

@visibleForTesting
class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({
    super.key,
    required this.onBackButtonTap,
  });

  final VoidCallback onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor:
              state is OrderDetailsSuccess ? state.order.status._color : null,
          title: state is OrderDetailsSuccess
              ? Text(state.order.status._toLocalizedString)
              : null,
          leading: BackButton(
            onPressed: onBackButtonTap,
          ),
        ),
        body: switch (state) {
          OrderDetailsInProgress() => const CenteredCircularProgressIndicator(),
          OrderDetailsSuccess() => _OrderDetails(order: state.order),
          OrderDetailsFailure() => const ExceptionIndicator()
        },
      ),
    );
  }
}

class _OrderDetails extends StatelessWidget {
  const _OrderDetails({required this.order});

  final Order order;

  List<String> getImageUrl() {
    final images = <String>[];

    for (var item in order.items) {
      images.add(item.product.imageUrl);
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImagesRow(imageUrls: getImageUrl()),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Date:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                order.formattedDate!,
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Products Ordered:',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ...order.items.map((item) => Card(
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.product.name),
                      Text('Qty: ${item.quantity}'),
                    ],
                  ),
                  subtitle: Text(
                      'Unit Price: \$${item.product.price.toStringAsFixed(2)}'),
                ),
              )),

          const SizedBox(height: 20),
          ExpandedElevatedButton(
              label: 'Order Again',
              onTap: () => showDialog(
                    context: context,
                    builder: (_) => OrderSummaryDialog(
                      totalPrice: order.totalPrice,
                      totalQuantity: order.quantity,
                      onOrderConfirmed: () {},
                    ),
                  )),
          const SizedBox(height: 20),
          // Add other widgets like PaymentInfoWidget, ShippingAddressWidget, etc.
        ],
      ),
    );
  }
}

extension on OrderStatus {
  String get _toLocalizedString => switch (this) {
        OrderStatus.pending => 'Next in line!',
        OrderStatus.completed => 'Delivery Completed!',
        OrderStatus.ongoing => 'Get ready to unpack!',
        OrderStatus.cancelled => 'Order on hold',
      };

  Color? get _color => switch (this) {
        OrderStatus.pending => const Color(0xFFB5DCFC),
        OrderStatus.completed => const Color(0xFFBDFABF),
        OrderStatus.ongoing => const Color(0xFFFFF9BE),
        OrderStatus.cancelled => const Color(0xFFF5B2AE),
      };
}
