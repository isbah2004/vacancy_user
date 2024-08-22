import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vacancy_app/reusablewidgets/neomorphism_widget.dart';
import 'package:vacancy_app/screens/detailscreen/detail_screen.dart';
import 'package:vacancy_app/screens/summaryscreen/summary_screen.dart';
import 'package:vacancy_app/theme/theme.dart';
import 'package:vacancy_app/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fireStore =
      FirebaseFirestore.instance.collection('vacancies').snapshots();

  CollectionReference urlRef =
      FirebaseFirestore.instance.collection('vacancies');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SummaryScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.summarize))
        ],
        centerTitle: true,
        title: Text(
          'Current Manpower Status and Vacancy Overview',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppTheme.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.6),
                    child: Center(
                      child: Text(
                        'Something went wrong',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.6),
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.6),
                  child: Center(
                    child: Text(
                      'No data available',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 8),
                      child: NeomorphicWidget(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                    department: data['department'],
                                    approvedNumbers: data['approved_numbers'],
                                    manpowerNumbers: data['manpower_numbers'],
                                    vacancy: data['vacancy'],
                                    number: data['number'], snapshot: snapshot, docId: document.id,),
                              ),
                            );
                          },
                          child: Hero(
                            tag: data['department'],
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 18),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppTheme.greyColor),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  const SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image(
                                        image: AssetImage(
                                            Constants.jobSearchIcon)),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    data['department'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
