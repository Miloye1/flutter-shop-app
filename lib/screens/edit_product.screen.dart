import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.provider.dart';
import '../providers/products.provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageURLController = TextEditingController();
  final form = GlobalKey<FormState>();

  var editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    isFavorite: false,
  );

  @override
  void dispose() {
    super.dispose();
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageURLController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context)?.settings.arguments as String?;

    if (productId != null) {
      final product = productProvider.findById(productId);

      editedProduct = Product(
        id: product.id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );

      imageURLController.text = editedProduct.imageUrl;
    }

    void saveForm() {
      final isValid = form.currentState!.validate();
      if (!isValid) return;

      if (form.currentState != null) {
        form.currentState!.save();

        if (editedProduct.id.isEmpty) {
          productProvider.addProduct(editedProduct);
        } else {
          productProvider.updateProduct(editedProduct.id, editedProduct);
        }

        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(onPressed: saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                initialValue: editedProduct.title,
                onChanged: (value) => print(editedProduct.toString()),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(priceFocusNode),
                onSaved: (value) =>
                    editedProduct = editedProduct.copyWith(title: value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter title';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                initialValue: editedProduct.price.toString(),
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(descriptionFocusNode),
                focusNode: priceFocusNode,
                onSaved: (value) => editedProduct =
                    editedProduct.copyWith(price: double.parse(value!)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter price';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Not a number';
                  }

                  if (double.parse(value) < 0) {
                    return '>0';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                initialValue: editedProduct.description,
                focusNode: descriptionFocusNode,
                onSaved: (value) =>
                    editedProduct = editedProduct.copyWith(description: value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter description';
                  }

                  if (value.length < 5) {
                    return '>5';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: imageURLController.text.isEmpty
                        ? const Text('Enter an url')
                        : FittedBox(
                            child: Image.network(
                              imageURLController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageURLController,
                      onEditingComplete: () => setState(() {}),
                      onSaved: (value) => editedProduct =
                          editedProduct.copyWith(imageUrl: value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter ur';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
