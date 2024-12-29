import 'package:fam/components/card_widget.dart';
import 'package:fam/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<CardProvider>(context);
    return Scaffold(
      backgroundColor: Constants.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Image(
          image: AssetImage(
            "assets/fampaylogo.png",
          ),
          width: 100,
        ),
      ),
      body: cardProvider.cardGroups.isEmpty
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: Colors.orange,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: Constants.defaultPadding,
                itemCount: cardProvider.cardGroups.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: DynamicContainer(
                      json: cardProvider.cardGroups[index],
                    ),
                  );
                },
              ),
              onRefresh: () async {
                await CardProvider().fetchCardData();
              },
            ),
    );
  }
}
