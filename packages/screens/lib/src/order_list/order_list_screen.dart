import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:repositories/repositories.dart';
import 'package:screens/src/order_list/order_list_bloc.dart';

import 'horizontal_list_filter.dart';
import 'order_page_list_view.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({
    required this.userId,
    required this.onAuthenticationError,
    required this.orderRepository,
    super.key,
    required this.userRepository,
    required this.onOrderSelected,
  });

  final String userId;
  final VoidCallback onAuthenticationError;
  final void Function(String id) onOrderSelected;
  final OrderRepository orderRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderListBloc>(
        create: (_) => OrderListBloc(
              userRepository: userRepository,
              orderRepository: orderRepository,
            ),
        child: OrderListView(
          onAuthenticationError: onAuthenticationError,
          onOrderSelected: onOrderSelected,
        ));
  }
}

@visibleForTesting
class OrderListView extends StatefulWidget {
  const OrderListView({
    super.key,
    required this.onOrderSelected,
    required this.onAuthenticationError,
  });

  final void Function(String) onOrderSelected;
  final VoidCallback onAuthenticationError;

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  final _pagingController = PagingController<int, Order>(
    firstPageKey: 1,
  );

  OrderListBloc get _bloc => context.read<OrderListBloc>();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageNumber) {
      if (pageNumber > 1) _bloc.add(OrderListNextPageRequested(pageNumber));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderListBloc, OrderListState>(
      listener: (context, state) {
        if (state.refreshError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('refresh errror text message')),
          );
        }

        _pagingController.value = state.toPagingState();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('Feast Flaskback')),
          body: Column(
            children: [
              const FilterHorizontalList(),
              Expanded(
                child: RefreshIndicator(
                    onRefresh: () {
                      _bloc.add(const OrderListRefreshed());

                      final stateChangeFuture = _bloc.stream.first;
                      return stateChangeFuture;
                    },
                    child: OrderPageListView(
                      pagingController: _pagingController,
                      onOrderSelected: widget.onOrderSelected,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

extension on OrderListState {
  PagingState<int, Order> toPagingState() {
    return PagingState(
      itemList: itemList,
      nextPageKey: nextPage,
      error: error,
    );
  }
}
