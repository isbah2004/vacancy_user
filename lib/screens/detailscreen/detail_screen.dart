import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacancy_app/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:vacancy_app/reusablewidgets/neomorphism_widget.dart';
import 'package:vacancy_app/theme/theme.dart';
import 'package:vacancy_app/utils/utils.dart';

class DetailScreen extends StatefulWidget {
  final String department,
      approvedNumbers,
      manpowerNumbers,
      vacancy,
      number,
      docId;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  const DetailScreen({
    super.key,
    required this.department,
    required this.approvedNumbers,
    required this.manpowerNumbers,
    required this.vacancy,
    required this.number,
    required this.snapshot,
    required this.docId,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> fireStoreStream =
        FirebaseFirestore.instance.collection(widget.department).snapshots();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Statistics on employee headcount and existing vacancies',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppTheme.whiteColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              NeomorphicWidget(
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: AppTheme.greyColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        buildDetailField('Department:', widget.department),
                        const SizedBox(height: 20),
                        buildDetailField(
                            'Approved numbers:', widget.approvedNumbers),
                        const SizedBox(height: 20),
                        buildDetailField(
                            'Manpower numbers:', widget.manpowerNumbers),
                        const SizedBox(height: 20),
                        buildDetailField('Vacancy:', widget.vacancy),
                        const SizedBox(height: 20),
                        buildDetailField('Number:', widget.number),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: fireStoreStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: MulticolorProgressIndicator(),
                    );
                  }

               else   if (snapshot.hasError) {
                    Utils.toastMessage(
                        message: snapshot.error.toString(), context: context);
                  }

         else       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SizedBox();
                  }

                  var data = snapshot.data!.docs;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      double fontSize = constraints.maxWidth < 600 ? 13 : 15;
                      double headingFontSize =
                          constraints.maxWidth < 600 ? 13 : 15;
                      double columnSpacing =
                          constraints.maxWidth < 600 ? 10 : 20;

                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: NeomorphicWidget(
                                    child:DataTable(showCheckboxColumn: false,
                                          border: TableBorder.all(
                                            color: AppTheme.lightGreyColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          columnSpacing: columnSpacing,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          headingRowColor:
                                              WidgetStateColor.resolveWith(
                                                  (states) =>
                                                      AppTheme.blueColor),
                                          headingTextStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: AppTheme.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: headingFontSize,
                                              ),
                                          dataTextStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: fontSize,
                                              ),
                                          columns: const [
                                            DataColumn(
                                                label: FittedBox(
                                                    child: Text('Name'))),
                                            DataColumn(
                                                label: Expanded(
                                                    child: FittedBox(
                                                        child: Text(
                                                            'Last Working Day')))),
                                            DataColumn(
                                                label: FittedBox(
                                                    child:
                                                        Text('Designation'))),
                                            DataColumn(
                                                label: Expanded(
                                                    child: FittedBox(
                                                        child: Text('Grade')))),
                                          ],
                                          rows: [
                                            ...data.map((doc) {
                                              return DataRow(
                                           
                                                cells: [
                                                  DataCell(FittedBox(
                                                      child: Text(doc['name']
                                                          .toString()))),
                                                  DataCell(FittedBox(
                                                      child: Text(doc['date']
                                                          .toString()))),
                                                  DataCell(FittedBox(
                                                      child: Text(
                                                          doc['designation']
                                                              .toString()))),
                                                  DataCell(FittedBox(
                                                      child: Text(doc['grade']
                                                          .toString()))),
                                                ],
                                              );
                                            }),
                                          ],
                                          dividerThickness: 1,
                                          horizontalMargin: 20,
                                        )
                                    
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailField(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.kanit(
              fontSize: 20,
              color: AppTheme.darkGrey,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            softWrap: true,
            style: GoogleFonts.kanit(
                fontSize: 20,
                color: AppTheme.darkGrey,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
