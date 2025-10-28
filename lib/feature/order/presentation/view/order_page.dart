// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:empire/feature/order/presentation/view/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:empire/core/di/service_locator.dart';

import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/order/domain/entity/oder_entity.dart';
import 'package:empire/feature/order/presentation/Bloc/order_bloc.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrdersBloc>()..add(const WatchOrders()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'My Orders',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersError) {
              return Center(child: Text(state.message));
            }

            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return const Emptyorder();
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return OrderCard(order: state.orders[index]);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        bool isExpanded = false;

        if (state is OrdersLoaded) {
          isExpanded = state.expandedOrders[order.orderId] ?? false;
        }

        return GestureDetector(
          onTap: () {
            context.read<OrdersBloc>().add(ToggleOrderExpansion(order.orderId));
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                OrderHeader(order: order),
                if (isExpanded) _CartItemsList(order: order),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CartItemsList extends StatelessWidget {
  final OrderEntity order;
  const _CartItemsList({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey[100],
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: order.items.length,
        itemBuilder: (context, index) {
          final item = order.items[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: item.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      item.imageUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.shopping_bag),
            title: Text(item.productName ?? 'no name'),
            subtitle: Text('Qty: ${item.quantity}'),
            trailing: Text('₹${order.totalAmount}'),
          );
        },
      ),
    );
  }
}

class OrderHeader extends StatelessWidget {
  final OrderEntity order;

  OrderHeader({super.key, required this.order});
  Color _getStatusColor(String status) {
    switch (status) {
      case 'packed':
      case 'shipped':
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String? selectedValue;
  String _getStatusText(String status) {
    switch (status) {
      case 'packed':
        return 'packed';
      case 'shipped':
        return 'shipped';
      case 'delivered':
        return 'Delivered';
      default:
        return status;
    }
  }

  List<String> status = [
    'packed',
    'shipped',
    'succeeded',
    'completed',
    'delivered',
    'cancelled',
    'failed',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // existing UI from your OrderCard’s build method
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.purple[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: order.items[0].imageUrl != null
                ? OptimizedNetworkImage(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.30,
                    imageUrl: order.items[0].imageUrl,
                    errorWidget: const Icon(Icons.error),
                    borderRadius: 7,
                    fit: BoxFit.fill,
                    placeholder: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: const SizedBox(height: 80, width: 85),
                    ),
                    widthQueryParam: 'resize_width',
                  )
                : const Icon(Icons.error),
          ),
          const SizedBox(width: 12),
          // Order Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${order.orderId}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Cost ${order.totalAmount.toString()}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: Fonts.ralewaySemibold,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      _getStatusText(order.currency),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${order.items.length} item',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    _getStatusText('Completed'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.check_circle,
                    color: _getStatusColor(order.paymentStatus),
                    size: 18,
                  ),
                ],
              )
              // : Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       border: BoxBorder.all(width: 1),
              //     ),
              //     height: 40,
              //     child: Center(
              //       child: DropdownButton<String>(
              //         value: selectedValue,
              //         alignment: Alignment.center,
              //         hint: const Text('Select an option'),
              //         items: status.map((String value) {
              //           return DropdownMenuItem<String>(
              //             value: value,
              //             child: Text(value),
              //           );
              //         }).toList(),
              //         onChanged: (String? newValue) {
              //           if (newValue != null) {
              //             selectedValue = newValue;
              //             context.read<OrdersBloc>().add(
              //                   UpdateOrderstatus(
              //                     orderId: order.orderId,
              //                     newStatus: newValue,
              //                   ),
              //                 );
              //           }
              //         },
              //         icon: const SizedBox.shrink(),
              //         underline: const SizedBox.shrink(),
              //         elevation: 0,
              //         borderRadius: BorderRadius.circular(8),
              //         dropdownColor: Colors.white,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}

// class OrderCard extends StatefulWidget {
//   final OrderEntity order;

//   OrderCard({super.key, required this.order});

//   @override
//   State<OrderCard> createState() => _OrderCardState();
// }

// class _OrderCardState extends State<OrderCard> {
//   List<String> status = [
//     'packed',
//     'shipped',
//     'succeeded',
//     'completed',
//     'delivered',
//     'cancelled',
//     'failed',
//   ];

//   String? selectedValue;

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'packed':
//       case 'shipped':
//       case 'delivered':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   String _getStatusText(String status) {
//     switch (status) {
//       case 'packed':
//         return 'packed';
//       case 'shipped':
//         return 'shipped';
//       case 'delivered':
//         return 'Delivered';
//       default:
//         return status;
//     }
//   }

//   @override
//   void initState() {
//     if (status.contains(widget.order.paymentStatus)) {
//       selectedValue = widget.order.paymentStatus;
//     } else {
//       selectedValue = null;
//     }

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.purple[300],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: widget.order.items[0].imageUrl != null
//                   ? OptimizedNetworkImage(
//                       width: double.infinity,
//                       height: MediaQuery.of(context).size.height * 0.30,
//                       imageUrl: widget.order.items[0].imageUrl,
//                       errorWidget: const Icon(Icons.error),
//                       borderRadius: 7,
//                       fit: BoxFit.fill,
//                       placeholder: Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: const SizedBox(height: 80, width: 85),
//                       ),
//                       widthQueryParam: 'resize_width',
//                     )
//                   : const Icon(Icons.error),
//             ),
//             const SizedBox(width: 12),
//             // Order Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Order ID: ${widget.order.orderId}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   Text(
//                     'Total Cost ${widget.order.totalAmount.toString()}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontFamily: Fonts.ralewaySemibold,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),

//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Text(
//                         _getStatusText(widget.order.currency),
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   '${widget.order.items.length} item',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 24),
//                 widget.order.over == true
//                     ? Row(
//                         children: [
//                           Text(
//                             _getStatusText('Completed'),
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           Icon(
//                             Icons.check_circle,
//                             color: _getStatusColor(widget.order.paymentStatus),
//                             size: 18,
//                           ),
//                         ],
//                       )
//                     : Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: BoxBorder.all(width: 1),
//                         ),
//                         height: 40,

//                         child: Center(
//                           child: DropdownButton<String>(
//                             value: selectedValue,

//                             alignment: Alignment.center,
//                             hint: const Text('Select an option'),
//                             items: status.map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               if (newValue != null) {
//                                 selectedValue = newValue;
//                                 context.read<OrdersBloc>().add(
//                                   UpdateOrderStatus(
//                                     orderId: widget.order.orderId,
//                                     newStatus: newValue,
//                                   ),
//                                 );
//                               }
//                             },

//                             icon: const SizedBox.shrink(),

//                             underline: const SizedBox.shrink(),

//                             elevation: 0,
//                             borderRadius: BorderRadius.circular(8),
//                             dropdownColor: Colors.white,
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
