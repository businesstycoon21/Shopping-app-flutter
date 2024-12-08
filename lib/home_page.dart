import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> products = [
    {
      "name": "AKG N700NCM2 Wireless Headphones",
      "price": 199.0,
      "status": "Available",
      
      "image": "http://ts4.explicit.bing.net/th?id=OIP.eIVzcCr4lBSt2blBSutm4wHaHa&pid=15.1",
      
    },
    {
      "name": "AIAIAI TMA-2 Modular Headphones",
      "price": 250.0,
      "status": "Unavailable",
      "image": "C:\Users\vg739\desktop\shop_app\assets\images\green-headphones-on-a-green-and-salmon-background.webp"
    }
  ];

  String searchQuery = "";

  // Add a new product with an image
  Future<void> addProduct() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        products.add({
          "name": "New Product",
          "price": 100.0,
          "status": "Available",
          "image": pickedFile.path // Local file path
        });
      });
    }
  }

  // Delete a product
  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  // Filter products based on search query
  List<Map<String, dynamic>> get filteredProducts {
    if (searchQuery.isEmpty) {
      return products;
    }
    return products
        .where((product) =>
            product["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hi-Fi Shop & Service"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Products",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: product["image"] != null &&
                                product["image"].isNotEmpty
                            ? Image.file(
                                File(product["image"]),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                 errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                              )
                            : const Icon(Icons.image_not_supported, size: 50),
                      ),
                      title: Text(product["name"]),
                      subtitle: Text(
                        "\$${product["price"].toStringAsFixed(2)} - ${product["status"]}",
                        style: TextStyle(
                          color: product["status"] == "Available"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteProduct(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
