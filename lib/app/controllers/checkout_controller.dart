// // lib/app/modules/checkout/controllers/checkout_controller.dart
// import 'package:antarkanma/app/controllers/cart_controller.dart';

// class CheckoutController extends GetxController {
//   final CartController cartController = Get.find();
//   final AddressController addressController = Get.find();

//   var selectedAddress = Rx<AddressModel?>(null);
//   var cartItems = <CartItemModel>[].obs;
//   var paymentMethods = <PaymentMethodModel>[].obs;
  
//   var subtotal = 0.0.obs;
//   var deliveryFee = 0.0.obs;
//   var total = 0.0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadCheckoutData();
//   }

//   void loadCheckoutData() {
//     // Load cart items
//     cartItems.value = cartController.items;
    
//     // Load default address
//     selectedAddress.value = addressController.defaultAddress.value;
    
//     // Load payment methods
//     loadPaymentMethods();
    
//     // Calculate totals
//     calculateTotals();
//   }

//   void loadPaymentMethods() {
//     // TODO: Load payment methods