import 'package:edevice_admin/presentation/admin/products/add_product_screen.dart';
import 'package:edevice_admin/presentation/admin/products/update_product_screen.dart';
import 'package:edevice_admin/view_model/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Admin"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddProductScreen()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
          return ListView(
            children: List.generate(productViewModel.productsAdmin.length, (index) {
              var product = productViewModel.productsAdmin[index];
              return ListTile(
                title: Text(product.productName),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProductScreen(
                                  productModel: product,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            context
                                .read<ProductViewModel>()
                                .deleteProduct(product.productId);
                            print("DELETING ID:${product.productId}");
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}