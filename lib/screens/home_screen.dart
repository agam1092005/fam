// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:fam/components/dynamic_container.dart';
import 'package:fam/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTimeout = false;
  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = _fetchDataWithTimeout();
  }

  Future<void> _fetchDataWithTimeout() async {
    try {
      await Future.any([
        Provider.of<CardProvider>(context, listen: false).fetchCardData(),
        Future.delayed(Duration(seconds: 10), () {
          throw TimeoutException("Timeout, unable to fetch data");
        })
      ]);
      setState(() {
        isTimeout = false;
      });
    } catch (e) {
      if (e is TimeoutException) {
        setState(() {
          isTimeout = true;
        });
      }
    }
  }

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
          image: AssetImage("assets/fampaylogo.png"),
          width: 100,
        ),
      ),
      body: FutureBuilder<void>(
        future: fetchDataFuture,
        builder: (ctx, snapshot) {
          if (isTimeout) {
            return Center(
              child: Container(
                color: Colors.red,
                padding: EdgeInsets.all(16),
                child: Text(
                  'Timeout, unable to fetch data',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          return cardProvider.cardGroups.isEmpty
              ? Center(child: CircularProgressIndicator(color: Colors.orange))
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
                    // Refreshing the data & removing the ones in temporary removed / remind later
                    await Provider.of<CardProvider>(context, listen: false)
                        .fetchCardData();
                    Provider.of<CardProvider>(context, listen: false)
                        .removeOnRefresh();
                  },
                );
        },
      ),
    );
  }
}
