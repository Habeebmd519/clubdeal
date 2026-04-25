import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:clubdeal/featurs/model_placeholder/model.dart';

class OrderServices {
  Stream<List<Order>> getOrders() {
    return firestore.FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
        );
  }
}
