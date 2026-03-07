import 'dart:async';

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class Assigmentweek5 extends StatefulWidget {
  const Assigmentweek5({super.key});

  @override
  State<Assigmentweek5> createState() => _Assigmentweek5State();
}

class _Assigmentweek5State extends State<Assigmentweek5> {
  List<Product> products = [];
  Timer? _refreshTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _loadProducts(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      products = await ProductService.fetchAll();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createProduct(
    String name,
    String description,
    double price,
  ) async {
    try {
      await ProductService.create(
        Product(name: name, description: description, price: price),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create success!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _updateProduct(Product product) async {
    try {
      await ProductService.update(product);
      _loadProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _deleteProduct(dynamic id) async {
    try {
      await ProductService.delete(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete success!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _confirmDelete(dynamic id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showProductDialog({
    Product? existing,
    required Function(String, String, double) onSubmit,
  }) {
    final nameCtrl = TextEditingController(text: existing?.name);
    final descCtrl = TextEditingController(text: existing?.description);
    final priceCtrl = TextEditingController(
      text: existing != null ? existing.price.toString() : '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Add Product' : 'Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final desc = descCtrl.text.trim();
              final price = double.tryParse(priceCtrl.text) ?? 0;
              if (name.isNotEmpty && price > 0) {
                onSubmit(name, desc, price);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Manager')),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text("${product.price}"),
                        onTap: () => _showProductDialog(
                          existing: product,
                          onSubmit: (name, desc, price) => _updateProduct(
                            Product(
                              id: product.id,
                              name: name,
                              description: desc,
                              price: price,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () => _confirmDelete(product.id),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Refresh'),
              ),
              ElevatedButton(
                onPressed: () => _showProductDialog(onSubmit: _createProduct),
                child: const Text('Add Product'),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
