import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> data = [
      ['Name', 'Age', 'Email'],
      ['John Doe', 434556, 'john.doe@example.com'],
      ['Jane Smith',12212121, 'jane.smith@example.com'],
      ['Bob Johnson', 40, 'bob.johnson@example.com'],
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV変換デモ'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // データをCSV形式の文字列に変換
                String csvData = ListToCsvConverter().convert(data);

                // CSVデータをファイルに保存
                saveCsvToFile(csvData);
              },
              child: Text('CSVファイルに変換'),
            ),
            ElevatedButton(
              onPressed: () async {
                // CSVファイルを読み込む
                String csvData = await loadCsvFromFile(context);

                // CSVデータをパースしてテーブルに表示
                List<List<dynamic>> csvTable =
                    CsvToListConverter().convert(csvData);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CsvTablePage(csvTable: csvTable),
                  ),
                );
              },
              child: Text('CSVファイルを表示'),
            ),
            ElevatedButton(
              onPressed: () async {
                // データをCSV形式の文字列に変換
                String csvData = ListToCsvConverter().convert(data);

                // CSVデータをファイルに保存
                saveCsvToFile(csvData);
                // CSVファイルを読み込む
                String Data = await loadCsvFromFile(context);

                // シェア
                shareCsvFile(Data, context);
              },
              child: Text('CSVファイルをシェア'),
            ),
            ElevatedButton(
              onPressed: () async {
                // データをCSV形式の文字列に変換
                String csvData = ListToCsvConverter().convert(data);

                shareCSVDataFile(csvData, context);
              },
              child: Text('CSVファイルをシェア2'),
            ),
          ],
        ),
      ),
    );
  }

  // CSVデータをファイルに保存
  void saveCsvToFile(String csvData) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/data.csv';
    final File file = File(path);
    await file.writeAsString(csvData);
    print('CSVファイルを保存しました: $path');
  }

// ファイルからCSVデータを読み込む関数

  Future<String> loadCsvFromFile(BuildContext context) async {
    final String dir = (await getTemporaryDirectory()).path;
    final String path =
        '/Users/wings/Library/Developer/CoreSimulator/Devices/710F290F-F84C-4A10-8F8B-46601D460BAE/data/Containers/Data/Application/2B5B045B-7969-484D-A264-CE5E2BF6FF3D/Documents/data.csv';
    final File file = File(path);

    if (await file.exists()) {
      return await file.readAsString();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('CSVファイルが見つかりませんでした。'),
      ));
      return '';
    }
  }
}

void shareCsvFile(String csvData, BuildContext context) {
  final RenderBox box = context.findRenderObject() as RenderBox;
  Share.share(
    csvData,
    subject: 'CSVデータをシェアします',
    sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
  );
}

void shareCSVDataFile(String csvData, BuildContext context) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/data.csv';
    final File file = File(path);
    await file.writeAsString(csvData);
    print('CSVファイルを保存しました: $path');
  
  await Share.shareFiles([file.path], text: "SCBチェックリスト");
}

class CsvTablePage extends StatelessWidget {
  final List<List<dynamic>> csvTable;

  CsvTablePage({required this.csvTable});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSVデータのテーブル表示'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: List.generate(
            csvTable[0].length,
            (index) => DataColumn(
              label: Text(csvTable[0][index].toString()),
            ),
          ),
          rows: List.generate(
            csvTable.length - 1,
            (index) => DataRow(
              cells: List.generate(
                csvTable[index + 1].length,
                (cellIndex) => DataCell(
                  Text(csvTable[index + 1][cellIndex].toString()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
