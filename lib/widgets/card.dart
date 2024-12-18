import 'package:flutter/material.dart';
import 'package:projek_bounty_hunter/models/candi.dart';
import 'package:projek_bounty_hunter/screens/Detail.dart';

class ItemCard extends StatelessWidget {
  final Candi candi;

  const ItemCard({super.key, required this.candi});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(candi: candi)));
      },
      child: Card(
        color: const Color.fromRGBO(252, 250, 237, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color.fromRGBO(200, 199, 183, 1),
          ),
        ),
        margin: const EdgeInsets.all(4),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Hero(
                  tag: candi.imageAsset,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      candi.imageAsset,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16,),
              child: Text(candi.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(candi.type, style: const TextStyle(fontSize: 12)),
            ),
            const Padding(
                    padding: EdgeInsets.only(right: 7.0, bottom: 7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Icon(Icons.star_border_outlined)],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
