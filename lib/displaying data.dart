import 'package:firestore/user/sendrequest.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataFetch extends StatefulWidget {
  @override
  _DataFetchState createState() => _DataFetchState();
}

enum FilterOption {
  All,
  CriminalDefense,
  Civil,
  Corporate,
  PublicInterest,
  Immigration,
  IntellectualProperty
}

class _DataFetchState extends State<DataFetch> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FilterOption selectedFilter = FilterOption.All;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Lawyers"),
      ),
      body: Column(
        children: [
          DropdownButton<FilterOption>(
            // Dropdown button for selecting a filter
            value: selectedFilter,
            onChanged: (newValue) {
              setState(() {
                selectedFilter = newValue!;
              });
            },
            items: FilterOption.values.map((option) {
              return DropdownMenuItem<FilterOption>(
                value: option,
                child: Text(option.toString().split('.').last),
              );
            }).toList(),
          ),

          Expanded(
            child: StreamBuilder(
              stream: selectedFilter == FilterOption.All
                  ? users.snapshots()
                  : users
                  .where('filter', isEqualTo: selectedFilter.toString().split('.').last)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        // Handle the click event here, e.g., navigate to a new page or show a dialog
                        _showDetailsDialog(data);
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        elevation: 4,
                        child: ListTile(
                          title: Text(data['name'] ?? ''),
                          subtitle: Text(data['description'] ?? ''),
                          leading: data['images'] != null
                              ? Image.network(
                            data['images'],
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Image.network(
                                  'images'); // Replace with your placeholder image
                            },
                          )
                              : Image.asset(
                              'Image not available'), // Display a placeholder if 'image_url' is missing
                          // Add more card content here based on your data
                        ),
                      ),
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

  void _showDetailsDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 80, // Adjust the size as needed
                backgroundImage: NetworkImage(data['images'] ?? ''), // Use the image URL if available
                backgroundColor: Colors.grey, // Use a placeholder background color
              ),
              SizedBox(height: 16), // Add spacing between image and name
              Text(
                data['name'] ?? '',
                style: TextStyle(
                  fontSize: 18, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8), // Add spacing between name and description
              Text(data['description'] ?? ''),
              SizedBox(height: 20), // Add spacing between text and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => sendrequest()),
                      );
                    },
                    child: Text('Request'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}