import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CowSearchPage extends StatefulWidget {
  @override
  _CowSearchPageState createState() => _CowSearchPageState();
}

class _CowSearchPageState extends State<CowSearchPage> {
  String searchTag = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cow'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by tag no.',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  searchTag = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchTag.isEmpty)
                  ? FirebaseFirestore.instance.collection('cows').snapshots()
                  : FirebaseFirestore.instance
                      .collection('cows')
                      .where('tagNo', isEqualTo: searchTag)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/no_data_found.png', // Make sure this image is in your assets folder
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No Data Found',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }

                // Display list of cows
                final cows = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: cows.length,
                  itemBuilder: (context, index) {
                    var cow = cows[index];
                    return ListTile(
                      title: Text('Tag No: ${cow['tagNo']}'),
                      subtitle: Text('Breed: ${cow['breed']}'),
                      leading: Icon(Icons.pets, color: Colors.brown),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
