import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_bounty_hunter/models/candi.dart';

class DetailScreen extends StatefulWidget {
  final Candi candi;
  const DetailScreen({super.key, required this.candi});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSignStatus();
    _loadFavoriteStatus();
  }

  Future<void> _checkSignStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSignedIn = prefs.getBool('isSignedIn') ?? false;
    });
  }

  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'favorite_${widget.candi.name.replaceAll(' ', '_')}';
    setState(() {
      isFavorite = prefs.getBool(key) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    if (!isSignedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/signin');
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'favorite_${widget.candi.name.replaceAll(' ', '_')}';
    setState(() {
      isFavorite = !isFavorite;
    });
    await prefs.setBool(key, isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 248, 242, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 45, 5, 5),
          child: Card(
            color: const Color.fromRGBO(252, 250, 237, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: Color.fromRGBO(200, 199, 183, 1),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: widget.candi.imageAsset,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            widget.candi.imageAsset,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // tombol back kustom
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(252, 250, 237, 1)
                              .withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //info atas
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.candi.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                        icon: Icon(
                          isSignedIn && isFavorite
                              ? Icons.star
                              : Icons.star_border,
                          color: isSignedIn && isFavorite ? Colors.yellowAccent : null,
                        ),
                        onPressed: _toggleFavorite,
                        iconSize: 30,
                      ),
                        ],
                      ),
                      //info tengah
                      Row(
                        children: [
                          const Icon(
                            Icons.place,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const SizedBox(
                            width: 70,
                            child: Text(
                              'Lokasi',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(': ${widget.candi.location}')
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const SizedBox(
                            width: 70,
                            child: Text(
                              'Dibangun',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(': ${widget.candi.built}')
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.house,
                            color: Colors.amber,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const SizedBox(
                            width: 70,
                            child: Text(
                              'Tipe',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(': ${widget.candi.type}')
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Divider(
                        color: Colors.deepPurple.shade100,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //info bawah
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Deskripsi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            child: Text(widget.candi.description),
                          ),
                        ],
                      ),
                      //info galery
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: Colors.deepPurple.shade100,
                            ),
                            const Text(
                              'Galeri',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.candi.imageUrls.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                200, 199, 183, 1),
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                widget.candi.imageUrls[index],
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.deepPurple[50],
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.error,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              'Tap untuk memperbesar',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
