
import 'package:flutter/material.dart';

import 'package:pay/pay.dart';
import 'package:prisma_orm/common/widgets/custom_textfield.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/constants/payment_config.dart';
import 'package:prisma_orm/constants/utils.dart';
import 'package:prisma_orm/features/address/services/address_service.dart';
import 'package:prisma_orm/providers/user_provider.dart';


import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  // final String pidx;
  final String totalAmount;

  static const String routeName = '/address';
  const AddressScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController flatBuildingController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  String addressToBeUsed = '';
  List<PaymentItem> paymentItems = [];
  final AddressServices addressServices = AddressServices();

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: "Total Amount",
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  // late final Future<Khalti> khalti;

  // @override
  // void initState() {
  //   super.initState();
  //   // final payConfig = KhaltiPayConfig(
  //   //   publicKey:
  //   //       'Key 6ca6ef59d7f246778c29a869fe0c60b0', // Merchant's public key
  //   //   pidx: widget
  //   //       .pidx, // This should be generated via a server side POST request.
  //   //   environment: Environment.prod,
  //   // );

  //   khalti = Khalti.init(
  //     enableDebugging: true,
  //     payConfig: payConfig,
  //     onPaymentResult: (paymentResult, khalti) {
  //       log(paymentResult.toString());
  //     },
  //     onMessage:
  //         (
  //           khalti, {
  //           description,
  //           statusCode,
  //           event,
  //           needsPaymentConfirmation,
  //         }) async {
  //           log(
  //             'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
  //           );
  //         },
  //     onReturn: () => log('Successfully redirected to return_url.'),
  //   );
  // }

  void onApplePayResult(res) {
    if (Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address.isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address.isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";
    bool isForm =
        flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;
    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text},${areaController.text},${cityController.text},${pincodeController.text}';
      } else {
        throw Exception('Please enter all the values');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'Error');
    }
    print(addressToBeUsed);
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(address, style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('OR', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: flatBuildingController,
                      hintText: "Flat,House No,Building",
                    ),
                    SizedBox(height: 10),
                    CustomTextfield(
                      controller: areaController,
                      hintText: "Area,street",
                    ),
                    SizedBox(height: 10),
                    CustomTextfield(
                      controller: pincodeController,
                      hintText: "Pincode",
                    ),
                    SizedBox(height: 10),

                    CustomTextfield(
                      controller: cityController,
                      hintText: "City",
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ApplePayButton(
                width: double.infinity,
                height: 50,
                paymentConfiguration: defaultApplePayConfig,
                paymentItems: paymentItems,
                type: ApplePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPressed: () => payPressed(address),
                onPaymentResult: onApplePayResult,
              ),
              const SizedBox(height: 10),
              GooglePayButton(
                onPressed: () => payPressed(address),
                paymentConfiguration: defaultGooglePayConfig,
                onPaymentResult: onGooglePayResult,
                paymentItems: paymentItems,
                height: 50,
                loadingIndicator: Center(child: CircularProgressIndicator()),
                type: GooglePayButtonType.buy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
