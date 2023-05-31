import 'package:flutter/material.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';

import '../../Constants/colors.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({Key? key}) : super(key: key);

  @override
  State<FaqsPage> createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  List<Map<String, dynamic>> faqs = [
    {
      'question': 'What is the courier app?',
      'answer':
          'The courier a  mobile application that allows you to send and receive packages from anywhere in the world. It is a platform that connects you to a network of drivers who can pick up and deliver your packages. You can also use the courier app to send packages to your friends and family.',
    },
    {
      "question": "How does the courier app work?",
      "answer":
          "The courier app works by connecting you to a network of drivers who can pick up and deliver your packages. You can also use the courier app to send packages to your friends and family.",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myText(
          'FAQs',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            for (var i = 0; i < faqs.length; i++)
              ExpansionTile(
                title: myText(
                  faqs[i]['question'],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  myText(
                    faqs[i]['answer'],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
