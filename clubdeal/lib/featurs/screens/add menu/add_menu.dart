// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Future<void> seedMenuToFirestore() async {
//       final List<Map<String, dynamic>> kMenuSeed = [
//         // BURGER
//         {
//           "name": "Veg Burger",
//           "price": 80,
//           "category": "burger",
//           "emoji": "🍔",
//         },
//         {
//           "name": "Zinger Burger",
//           "price": 100,
//           "category": "burger",
//           "emoji": "🍔",
//         },
//         {
//           "name": "Classic Chicken Burger",
//           "price": 140,
//           "category": "burger",
//           "emoji": "🍔",
//         },
//         {
//           "name": "Chicken Burger",
//           "price": 150,
//           "category": "burger",
//           "emoji": "🍔",
//         },
//         {
//           "name": "BBQ Chicken",
//           "price": 180,
//           "category": "burger",
//           "emoji": "🍔",
//         },
//         {
//           "name": "Hot & Chilli Beef",
//           "price": 200,
//           "category": "burger",
//           "emoji": "🍔",
//         },
//         {
//           "name": "Cheesy Beef Burger",
//           "price": 180,
//           "category": "burger",
//           "emoji": "🍔",
//         },

//         // SANDWICH
//         {
//           "name": "Veg Sandwich",
//           "price": 110,
//           "category": "sandwich",
//           "emoji": "🥪",
//         },
//         {
//           "name": "Egg Sandwich",
//           "price": 120,
//           "category": "sandwich",
//           "emoji": "🥪",
//         },
//         {
//           "name": "Zinger Sandwich",
//           "price": 140,
//           "category": "sandwich",
//           "emoji": "🥪",
//         },
//         {
//           "name": "Tikka Sandwich",
//           "price": 140,
//           "category": "sandwich",
//           "emoji": "🥪",
//         },
//         {
//           "name": "Grilled Sandwich",
//           "price": 140,
//           "category": "sandwich",
//           "emoji": "🥪",
//         },

//         // WRAP
//         {"name": "Veg Wrap", "price": 90, "category": "wrap", "emoji": "🌯"},
//         {"name": "Egg Wrap", "price": 90, "category": "wrap", "emoji": "🌯"},
//         {
//           "name": "Paneer Tikka Wrap",
//           "price": 100,
//           "category": "wrap",
//           "emoji": "🌯",
//         },
//         {
//           "name": "Zinger Wrap",
//           "price": 110,
//           "category": "wrap",
//           "emoji": "🌯",
//         },
//         {"name": "Tikka Wrap", "price": 110, "category": "wrap", "emoji": "🌯"},
//         {
//           "name": "Grilled Wrap",
//           "price": 110,
//           "category": "wrap",
//           "emoji": "🌯",
//         },

//         // FRIES
//         {
//           "name": "Chicken Loaded Fries",
//           "price": 150,
//           "category": "fries",
//           "emoji": "🍟",
//         },
//         {
//           "name": "SPC Beef Loaded Fries",
//           "price": 200,
//           "category": "fries",
//           "emoji": "🍟",
//         },
//         {
//           "name": "Cheesy Fries",
//           "price": 120,
//           "category": "fries",
//           "emoji": "🍟",
//         },
//         {
//           "name": "French Fries",
//           "price": 80,
//           "category": "fries",
//           "emoji": "🍟",
//         },
//         {
//           "name": "French Fries Spicy",
//           "price": 90,
//           "category": "fries",
//           "emoji": "🍟",
//         },

//         // CHICKEN
//         {
//           "name": "2 pcs Chicken",
//           "price": 130,
//           "category": "fried_chicken",
//           "emoji": "🍗",
//         },
//         {
//           "name": "4 pcs Chicken",
//           "price": 250,
//           "category": "fried_chicken",
//           "emoji": "🍗",
//         },
//         {
//           "name": "6 pcs Chicken",
//           "price": 390,
//           "category": "fried_chicken",
//           "emoji": "🍗",
//         },
//         {
//           "name": "8 pcs Chicken",
//           "price": 550,
//           "category": "fried_chicken",
//           "emoji": "🍗",
//         },
//         {
//           "name": "Chicken Popcorn",
//           "price": 100,
//           "category": "fried_chicken",
//           "emoji": "🍗",
//         },
//       ];

//       final firestore = FirebaseFirestore.instance;
//       final batch = firestore.batch();

//       final collection = firestore.collection('menu');

//       for (var item in kMenuSeed) {
//         final doc = collection.doc(); // auto id
//         batch.set(doc, {
//           ...item,
//           "isAvailable": true,
//           "createdAt": FieldValue.serverTimestamp(),
//         });
//       }

//       await batch.commit();
//     }

//     return Scaffold(
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () async {
//               await seedMenuToFirestore();
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(const SnackBar(content: Text("Menu uploaded 🚀")));
//             },
//             child: const Text("Upload Menu to Firebase"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  Future<void> seedMenuToFirestore() async {
    final List<Map<String, dynamic>> kMenuSeed = [
      // BURGER
      {
        "name": "Veg Burger",
        "price": 80,
        "category": "burger",
        "emoji": "🍔",
        "description": "Classic veg patty with fresh veggies and sauce.",
      },
      {
        "name": "Zinger Burger",
        "price": 100,
        "category": "burger",
        "emoji": "🍔",
        "description": "Crispy zinger chicken with spicy mayo.",
      },
      {
        "name": "Classic Chicken Burger",
        "price": 140,
        "category": "burger",
        "emoji": "🍔",
        "description": "Juicy chicken patty with lettuce and sauce.",
      },
      {
        "name": "Chicken Burger",
        "price": 150,
        "category": "burger",
        "emoji": "🍔",
        "description": "Grilled chicken burger with rich flavor.",
      },
      {
        "name": "BBQ Chicken",
        "price": 180,
        "category": "burger",
        "emoji": "🍔",
        "description": "Smoky BBQ chicken with caramelized onions.",
      },
      {
        "name": "Hot & Chilli Beef",
        "price": 200,
        "category": "burger",
        "emoji": "🍔",
        "description": "Spicy beef patty with hot chilli sauce.",
      },
      {
        "name": "Cheesy Beef Burger",
        "price": 180,
        "category": "burger",
        "emoji": "🍔",
        "description": "Beef patty loaded with melted cheese.",
      },

      // SANDWICH
      {
        "name": "Veg Sandwich",
        "price": 110,
        "category": "sandwich",
        "emoji": "🥪",
        "description": "Fresh veggie sandwich with creamy spread.",
      },
      {
        "name": "Egg Sandwich",
        "price": 120,
        "category": "sandwich",
        "emoji": "🥪",
        "description": "Boiled egg sandwich with light seasoning.",
      },
      {
        "name": "Zinger Sandwich",
        "price": 140,
        "category": "sandwich",
        "emoji": "🥪",
        "description": "Crispy chicken sandwich with zinger flavor.",
      },
      {
        "name": "Tikka Sandwich",
        "price": 140,
        "category": "sandwich",
        "emoji": "🥪",
        "description": "Chicken tikka filling with spices.",
      },
      {
        "name": "Grilled Sandwich",
        "price": 140,
        "category": "sandwich",
        "emoji": "🥪",
        "description": "Toasted sandwich with rich filling.",
      },

      // WRAP
      {
        "name": "Veg Wrap",
        "price": 90,
        "category": "wrap",
        "emoji": "🌯",
        "description": "Veg wrap with fresh fillings and sauce.",
      },
      {
        "name": "Egg Wrap",
        "price": 90,
        "category": "wrap",
        "emoji": "🌯",
        "description": "Egg wrap with soft roti and sauce.",
      },
      {
        "name": "Paneer Tikka Wrap",
        "price": 100,
        "category": "wrap",
        "emoji": "🌯",
        "description": "Paneer tikka with spicy masala wrap.",
      },
      {
        "name": "Zinger Wrap",
        "price": 110,
        "category": "wrap",
        "emoji": "🌯",
        "description": "Crispy chicken wrap with zinger flavor.",
      },
      {
        "name": "Tikka Wrap",
        "price": 110,
        "category": "wrap",
        "emoji": "🌯",
        "description": "Chicken tikka wrap with smoky flavor.",
      },
      {
        "name": "Grilled Wrap",
        "price": 110,
        "category": "wrap",
        "emoji": "🌯",
        "description": "Grilled wrap with juicy fillings.",
      },

      // FRIES
      {
        "name": "Chicken Loaded Fries",
        "price": 150,
        "category": "fries",
        "emoji": "🍟",
        "description": "Fries topped with chicken and sauces.",
      },
      {
        "name": "SPC Beef Loaded Fries",
        "price": 200,
        "category": "fries",
        "emoji": "🍟",
        "description": "Loaded fries with spicy beef topping.",
      },
      {
        "name": "Cheesy Fries",
        "price": 120,
        "category": "fries",
        "emoji": "🍟",
        "description": "Crispy fries loaded with cheese sauce.",
      },
      {
        "name": "French Fries",
        "price": 80,
        "category": "fries",
        "emoji": "🍟",
        "description": "Classic crispy salted fries.",
      },
      {
        "name": "French Fries Spicy",
        "price": 90,
        "category": "fries",
        "emoji": "🍟",
        "description": "Spicy seasoned crispy fries.",
      },

      // FRIED CHICKEN (important with addons)
      {
        "name": "2 pcs Chicken",
        "price": 130,
        "category": "fried_chicken",
        "emoji": "🍗",
        "description": "2 pieces crispy fried chicken.",
      },
      {
        "name": "4 pcs Chicken",
        "price": 250,
        "category": "fried_chicken",
        "emoji": "🍗",
        "description": "4 pieces crispy fried chicken.",
      },
      {
        "name": "6 pcs Chicken",
        "price": 390,
        "category": "fried_chicken",
        "emoji": "🍗",
        "description": "6 pcs chicken with fries, dip and bun.",
        "addons": ["Fries", "Dip", "Bun"],
      },
      {
        "name": "8 pcs Chicken",
        "price": 550,
        "category": "fried_chicken",
        "emoji": "🍗",
        "description": "8 pcs chicken with fries, dip and 2 buns.",
        "addons": ["Fries", "Dip", "2 Bun"],
      },
      {
        "name": "Chicken Popcorn",
        "price": 100,
        "category": "fried_chicken",
        "emoji": "🍗",
        "description": "Crunchy bite-sized chicken popcorn.",
      },
    ];

    final firestore = FirebaseFirestore.instance;
    // final batch = firestore.batch();
    // final collection = firestore.collection('menu');

    for (var item in kMenuSeed) {
      final query = await firestore
          .collection('menu')
          .where('name', isEqualTo: item['name'])
          .get();

      if (query.docs.isNotEmpty) {
        // ✅ UPDATE existing
        final docId = query.docs.first.id;

        await firestore.collection('menu').doc(docId).update({
          ...item,
          "addons": item["addons"] ?? [],
        });
      } else {
        // ✅ INSERT new
        await firestore.collection('menu').add({
          ...item,
          "addons": item["addons"] ?? [],
          "createdAt": FieldValue.serverTimestamp(),
          "isAvailable": true,
        });
      }
    }

    // final batch = firestore.batch();
  }

  // Future<void> seedMenuOnce() async {
  //   final firestore = FirebaseFirestore.instance;

  //   final existing = await firestore.collection('menu').limit(1).get();

  //   if (existing.docs.isNotEmpty) {
  //     print("Menu already exists ❌");
  //     return;
  //   }

  //   await seedMenuToFirestore();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await seedMenuToFirestore(); // 🔥 always run
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Menu synced 🔄")));
          },
          child: const Text("Upload Menu to Firebase"),
        ),
      ),
    );
  }
}
