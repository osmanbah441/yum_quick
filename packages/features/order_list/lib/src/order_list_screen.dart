import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_list/src/horizontal_list_filter.dart';
import 'package:order_list/src/order_cubit.dart';
import 'package:order_repository/order_repository.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({
    required this.userId,
    required this.onAuthenticationError,
    required this.orderRepository,
    super.key,
  });

  final String userId;
  final VoidCallback onAuthenticationError;
  final OrderRepository orderRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderListCubit>(
      create: (_) => OrderListCubit(
        orderRepository: orderRepository,
      ),
      child: CartView(
        onAuthenticationError: onAuthenticationError,
      ),
    );
  }
}

@visibleForTesting
class CartView extends StatelessWidget {
  const CartView({
    required this.onAuthenticationError,
    super.key,
  });

  final VoidCallback onAuthenticationError;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderListCubit, OrderListState>(
      listener: (context, state) {
        // final cartUpdateError =
        //     state is CartStateSuccess ? state.cartUpdateError : null;
        // if (cartUpdateError != null) {
        //   final snackBar =
        //       cartUpdateError is UserAuthenticationRequiredException
        //           ? const AuthenticationRequiredErrorSnackBar()
        //           : const GenericErrorSnackBar();

        //   ScaffoldMessenger.of(context)
        //     ..hideCurrentSnackBar()
        //     ..showSnackBar(snackBar);

        //   if (cartUpdateError is UserAuthenticationRequiredException) {
        //     onAuthenticationError();
        //   }
        // }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) return;
          },
          child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Feast Flashback'),
                  leading: Icon(Icons.history_rounded),
                ),
                body: switch (state) {
                  OrderListInProgress() =>
                    const CenteredCircularProgressIndicator(),
                  OrderListSuccess() => _Order(state.orders),
                  OrderListFailure() => ExceptionIndicator(
                      onTryAgain: () {
                        final cubit = context.read<OrderListCubit>();
                        cubit.refetch();
                      },
                    ),
                }),
          ),
        );
      },
    );
  }
}

class _Order extends StatelessWidget {
  const _Order(this.orders);
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    final orderCubit = context.read<OrderListCubit>();
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: 16),
        const HorizontalListFilter(),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                color: order.status._color,
                child: ListTile(
                  leading: order.status._icon,
                  trailing: const Icon(Icons.arrow_right_outlined),
                  onTap: () {},
                  title: Text(
                    order.status._toLocalizedString,
                    style: textTheme.titleMedium,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery date', style: textTheme.labelMedium),
                      Text(order.formattedDate, style: textTheme.labelMedium),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
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
