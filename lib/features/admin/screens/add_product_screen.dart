import 'dart:io';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/custom_buttom.dart';
import 'package:prisma_orm/common/widgets/custom_textfield.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/constants/utils.dart';
import 'package:prisma_orm/features/admin/services/admin_service.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();
  String category = "Mobiles";
  final _addProductFormKey = GlobalKey<FormState>();
  List<File> images = [];
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();

    priceController.dispose();
    quantityController.dispose();
  }

  List<String> productCategories = [
    "Mobiles",
    "Essentials",
    "Appliances",
    "Book",
  ];

  void sellProduct() async {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.tryParse(priceController.text) ?? 0.0,
        quantity: double.tryParse(quantityController.text) ?? 0.0,
        category: category,
        images: images,
      );
    } else if (images.isEmpty) {
      showSnackBar(context, "Please select at least one image");
    }
    setState(() {
      isLoading = false;
    });
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Text(
            'Add a product',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: 20),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map((i) {
                          return Builder(
                            builder: (BuildContext context) =>
                                Image.file(i, fit: BoxFit.cover, height: 200),
                          );
                        }).toList(),

                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 2),
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 1400,
                          ),
                          autoPlayCurve: Curves.easeInOut,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          options: RectDottedBorderOptions(
                            strokeWidth: 2,
                            dashPattern: [10, 4],
                            color: Colors.grey,
                            strokeCap: StrokeCap.round,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 40),
                                SizedBox(height: 15),
                                Text(
                                  "Select Product",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 30),
                CustomTextfield(
                  controller: productNameController,
                  hintText: "Product Name",
                ),
                SizedBox(height: 20),

                CustomTextfield(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                SizedBox(height: 20),

                CustomTextfield(controller: priceController, hintText: 'Price'),
                SizedBox(height: 20),

                CustomTextfield(
                  controller: quantityController,
                  hintText: 'Quantity',
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                    icon: Icon(Icons.keyboard_arrow_down),
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal!;
                      });
                    },
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : CustomButtom(text: "Sell", onTap: sellProduct),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
