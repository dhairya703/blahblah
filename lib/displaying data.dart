import 'package:firestore/payment_page.dart';
import 'package:firestore/user/sendrequest.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  IntellectualProperty,
}

class _DataFetchState extends State<DataFetch> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FilterOption selectedFilter = FilterOption.All;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD4AF37),
      appBar: AppBar(
        backgroundColor: Color(0xff660033),
        title: Text(
          "Available Lawyers",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          DropdownButton<FilterOption>(
            value: selectedFilter,
            onChanged: (newValue) {
              setState(() {
                selectedFilter = newValue!;
              });
            },
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            items: FilterOption.values.map((option) {
              return DropdownMenuItem<FilterOption>(
                value: option,
                child: Text(
                  option.toString().split('.').last,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: StreamBuilder(
              stream: selectedFilter == FilterOption.All
                  ? users.snapshots()
                  : users
                  .where('filter',
                  isEqualTo: selectedFilter.toString().split('.').last)
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
                        _showDetailsDialog(data);
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ${data['name'] ?? ''}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Lawyer Type: ${data['lawyer_type'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Lawyer Experience: ${data['lawyer_experience'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Case Ratio: ${data['case_ratio'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                          leading: Container(
                            width: 100,
                            height: 100,
                            child: data['images'] != null
                                ? Image.network(
                              data['images'],
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'placeholder_image_url',
                                  width: 100,
                                  height: 100,
                                );
                              },
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                              'placeholder_image_path',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff4169E1),
        onPressed: () {
          // Redirect to InternetHistoryPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InternetHistoryPage(),
            ),
          );
        },
        child: Icon(
          Icons.history,
        ),
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
                radius: 80,
                backgroundImage: NetworkImage(data['images'] ?? ''),
                backgroundColor: Color(0xffFFFFFF),
              ),
              SizedBox(height: 16),
              Text(
                data['name'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF010010),
                ),
              ),
              SizedBox(height: 8),
              Text(data['description'] ?? ''),
              SizedBox(height: 20),
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

class InternetHistoryPage extends StatefulWidget {
  @override
  _InternetHistoryPageState createState() => _InternetHistoryPageState();
}

class HistoryEntry {
  String casenum;
  String lastCase;
  String dateOfLastCase;
  String lawyerOfLastCase;
  String caseStartDate;
  String caseClosedOn;
  bool solved;
  double? userRating;

  HistoryEntry({
    required this.casenum,
    required this.lastCase,
    required this.dateOfLastCase,
    required this.lawyerOfLastCase,
    required this.caseStartDate,
    required this.caseClosedOn,
    required this.solved,
    this.userRating,
  });
}

class _InternetHistoryPageState extends State<InternetHistoryPage> {
  List<HistoryEntry> internetHistory = [
    HistoryEntry(
      casenum: 'CASE 1',
      lastCase: 'Fake Documents Case',
      dateOfLastCase: '2023-09-25',
      lawyerOfLastCase: 'John Doe',
      caseStartDate: '2023-09-01',
      caseClosedOn: '2023-09-20',
      solved: true,
    ),
    HistoryEntry(
      casenum: 'CASE 2',
      lastCase: 'Land grabbing Case',
      dateOfLastCase: '2023-09-22',
      lawyerOfLastCase: 'Jane Smith',
      caseStartDate: '2023-09-10',
      caseClosedOn: '2023-09-18',
      solved: false,
    ),
    HistoryEntry(
      casenum: 'CASE 3',
      lastCase: 'Dowry Case',
      dateOfLastCase: '2023-09-20',
      lawyerOfLastCase: 'Bob Johnson',
      caseStartDate: '2023-09-05',
      caseClosedOn: '2023-09-15',
      solved: true,
    ),
    // Add more history entries here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5DC),
      appBar: AppBar(
        title: Text('Case History'),
      ),
      body: ListView.builder(
        itemCount: internetHistory.length,
        itemBuilder: (context, index) {
          var entry = internetHistory[index];
          return InkWell(
            onTap: () async {
              final userRating =
              await _showRatingDialog(context, entry.userRating);
              setState(() {
                entry.userRating = userRating;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CaseDetailsPage(
                    historyEntry: entry,
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text('CASE NUMBER: ${entry.casenum}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last Case: ${entry.lastCase}'),
                  Text('Date of Last Case: ${entry.dateOfLastCase}'),
                  Text('Lawyer of Last Case: ${entry.lawyerOfLastCase}'),
                  Text('Case Start Date: ${entry.caseStartDate}'),
                  Text('Case Closed On: ${entry.caseClosedOn}'),
                  Text('Solved: ${entry.solved ? 'Yes' : 'No'}'),
                  if (entry.userRating != null)
                    Text('User Rating: ${entry.userRating}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<double?> _showRatingDialog(
      BuildContext context, double? initialRating) async {
    double? userRating = initialRating;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate the Lawyer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Rate the lawyer:'),
              RatingBar.builder(
                initialRating: userRating ?? 3.0,
                minRating: 1,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
                onRatingUpdate: (newValue) {
                  userRating = newValue;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToPaymentPage(context, userRating);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );

    return userRating;
  }

  void _navigateToPaymentPage(BuildContext context, double? userRating) {
    // You can implement the logic to navigate to the payment page here.
    // For example, you can use Navigator to push a new page.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(userRating: userRating),
      ),
    );
  }
}

class CaseDetailsPage extends StatelessWidget {
  final HistoryEntry historyEntry;

  CaseDetailsPage({
    required this.historyEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff660033),
      appBar: AppBar(
        title: Text('Case Details'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Case: ${historyEntry.lastCase}'),
            Text('Date of Last Case: ${historyEntry.dateOfLastCase}'),
            Text('Lawyer of Last Case: ${historyEntry.lawyerOfLastCase}'),
            Text('Case Start Date: ${historyEntry.caseStartDate}'),
            Text('Case Closed On: ${historyEntry.caseClosedOn}'),
            Text('Solved: ${historyEntry.solved ? 'Yes' : 'No'}'),
            if (historyEntry.userRating != null)
              Text('User Rating: ${historyEntry.userRating}'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DataFetch(),
  ));
}
