import 'package:flutter/material.dart';

class ItemRadioTouteGroup extends StatefulWidget {
  const new({super.key});

  @override
  State<ItemRadioTouteGroup> createState() => _ItemRadioTouteGroupState();
}

class _ItemRadioTouteGroupState extends State<ItemRadioTouteGroup> {
  List<String> categories = ["Sức khỏe", "Học tập", "Cá nhân"];

  late String selectedCategory;

  @override
  void initState() {
    selectedCategory = "Sức khỏe";
    super.initState();
  }

  void _onChangeSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Nhóm mục tiêu",
          style: TextStyle(
            color: Color(0xFF768079),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: categories.map((category) {
            bool isSelected = selectedCategory == category;

            return InkWell(
              onTap: () => _onChangeSelectedCategory(category),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              child: Container(
                width: 100,
                height: 39,
                decoration: BoxDecoration(
                  color: Color(isSelected ? 0xFF1C2520 : 0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFFE8ECE8),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                alignment: .center,
                child: Text(
                  category,
                  style: TextStyle(
                    color: Color(isSelected ? 0xFFFFFFFF : 0xFF768079),
                    fontSize: 13,
                    fontWeight: .w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// class ItemRadioTouteGroup extends StatefulWidget {
//   const new({super.key});

//   @override
//   State<ItemRadioTouteGroup> createState() => _ItemRadioTouteGroupState();
// }

// class _ItemRadioTouteGroupState extends State<ItemRadioTouteGroup> {
//   final List<String> categories = ['Sức khỏe', 'Học tập', 'Cá nhân'];

//   // Chỉ lưu 1 giá trị duy nhất đại diện cho nhóm đang chọn
//   String selectedCategory = 'Sức khỏe';

//   void _selectCategory(String category) {
//     setState(() {
//       // Gán thẳng nhóm được bấm vào biến selectedCategory
//       selectedCategory = category;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: .start,
//       children: [
//         const Text(
//           'Nhóm mục tiêu',
//           style: TextStyle(
//             color: Color(0xFF768079),
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: .spaceBetween,
//           children: categories.map((category) {
//             // So sánh trực tiếp: Đúng nhóm đang lưu thì isSelected = true
//             final isSelected = selectedCategory == category;

//             return InkWell(
//               onTap: () => _selectCategory(category),
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 width: 100,
//                 height: 39,
//                 alignment: .center,
//                 decoration: BoxDecoration(
//                   color: isSelected ? const Color(0xFF1C2520) : Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: isSelected
//                         ? Colors.transparent
//                         : const Color(0xFFE2E8F0),
//                     width: 1,
//                   ),
//                 ),
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : const Color(0xFF768079),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
