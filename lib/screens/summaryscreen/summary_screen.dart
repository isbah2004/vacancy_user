import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vacancy_app/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:vacancy_app/reusablewidgets/neomorphism_widget.dart';
import 'package:vacancy_app/screens/detailscreen/detail_screen.dart';
import 'package:vacancy_app/theme/theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> fireStoreStream =
        FirebaseFirestore.instance.collection('vacancies').snapshots();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.blueColor,
        title: Text(
          'Summary of Manpower and Vacancies',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppTheme.whiteColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: MulticolorProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No data available',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            );
          }

          var data = snapshot.data!.docs;

          int totalApproved = data.fold(
              0,
              (totalApprovedData, doc) =>
                  totalApprovedData + (int.parse(doc['approved_numbers'])));
          int totalManpower = data.fold(
              0,
              (totalManPowerData, doc) =>
                  totalManPowerData + (int.parse(doc['manpower_numbers'])));
          int totalVacant = data.fold(
              0,
              (totalVacantData, doc) =>
                  totalVacantData + (int.parse(doc['vacancy'])));

          return LayoutBuilder(
            builder: (context, constraints) {
              double fontSize = constraints.maxWidth < 600 ? 13 : 15;
              double headingFontSize = constraints.maxWidth < 600 ? 13 : 15;
              double columnSpacing = constraints.maxWidth < 600 ? 10 : 20;

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
                            child: DataTable(
                              showCheckboxColumn: false,
                              border: TableBorder.all(
                                color: AppTheme.lightGreyColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              columnSpacing: columnSpacing,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              headingRowColor: WidgetStateColor.resolveWith(
                                  (states) => AppTheme.blueColor),
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
                                    label:
                                        FittedBox(child: Text('Department'))),
                                DataColumn(
                                    label: Expanded(
                                        child: FittedBox(
                                            child: Text('Approved')))),
                                DataColumn(
                                    label: Expanded(
                                        child:
                                            FittedBox(child: Text('Current')))),
                                DataColumn(
                                    label: Expanded(
                                        child:
                                            FittedBox(child: Text('Vacant')))),
                              ],
                              rows: [
                                ...data.map((doc) {
                                  return DataRow(
                                    onSelectChanged: (selected) {
                                      if (selected ?? false) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreen(
                                                        department: doc[
                                                            'department'],
                                                        approvedNumbers: doc[
                                                            'approved_numbers'],
                                                        manpowerNumbers: doc[
                                                            'manpower_numbers'],
                                                        vacancy:
                                                            doc['vacancy'],
                                                        number: doc['number'],
                                                        snapshot: snapshot,
                                                        docId: doc.id)));
                                      }
                                    },
                                    cells: [
                                      DataCell(FittedBox(
                                          child: Text(
                                              doc['department'].toString()))),
                                      DataCell(FittedBox(
                                          child: Text(doc['approved_numbers']
                                              .toString()))),
                                      DataCell(FittedBox(
                                          child: Text(doc['manpower_numbers']
                                              .toString()))),
                                      DataCell(FittedBox(
                                          child:
                                              Text(doc['vacancy'].toString()))),
                                    ],
                                  );
                                }),
                                DataRow(
                                  cells: [
                                    const DataCell(FittedBox(
                                        child: Text(
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            'Total'))),
                                    DataCell(FittedBox(
                                        child: Text(
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            totalApproved.toString()))),
                                    DataCell(FittedBox(
                                        child: Text(
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            totalManpower.toString()))),
                                    DataCell(FittedBox(
                                        child: Text(
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            totalVacant.toString()))),
                                  ],
                                ),
                              ],
                              dividerThickness: 1,
                              horizontalMargin: 20,
                            ),
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
    );
  }
}
