import 'package:flutter/material.dart';
import 'package:projek_bounty_hunter/data/candi_data.dart';
import 'package:projek_bounty_hunter/widgets/card.dart';
import 'package:projek_bounty_hunter/models/candi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Candi> _filteredCandis = candiList;
  String _searchQuery = '';

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
      _filteredCandis = candiList
          .where((candi) =>
              candi.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(255, 248, 242, 1),    
        child: Column(
          children: [
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(240, 238, 225, 1),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              border: Border.all(
                color: const Color.fromRGBO(200, 199, 183, 1),
                width: 2,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 50, bottom: 10, right: 10, left: 10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(252, 250, 237, 1),
                borderRadius: BorderRadius.circular(50),
                 border: Border.all(
                color: const Color.fromRGBO(200, 199, 183, 1),
                width: 2,
              ),
              ),
              child: TextField(
                onChanged: _updateSearchQuery,
                decoration: const InputDecoration(
                    hintText: 'Cari Mafia',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,   
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
              ),       
            )
          ),
          Expanded(
            child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            padding: const EdgeInsets.all(5),
            itemCount: _filteredCandis.length,
            itemBuilder: (context, index) {
              return ItemCard(candi: _filteredCandis[index]);
            }),
          )     
        ],
      ),
    )
    );
  }
}