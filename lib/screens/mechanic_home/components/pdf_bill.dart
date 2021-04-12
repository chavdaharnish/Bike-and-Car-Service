// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
// import 'package:pdf/widgets.dart' as pdfLib;
// import 'package:share_extend/share_extend.dart';
// import 'package:path_provider/path_provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'PDF Flutter'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String cname;
//   String pnum;
//   String vname;
//   String vnum;
//   String iovehicle;
//   String price;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//             Text(
//               'Example of Flutter',
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Customer Name'),
//               onChanged: (val){
//                 setState(() {
//                   cname=val;
//                 });
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Phone Number'),
//               onChanged: (val){
//                 setState(() {
//                   pnum=val;
//                 });
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Vehicle name'),
//               onChanged: (val){
//                 setState(() {
//                   vname=val;
//                 });
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Vehicle Number'),
//               onChanged: (val){
//                 setState(() {
//                   vnum=val;
//                 });
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Issue of Vehicle'),
//               onChanged: (val){
//                 setState(() {
//                   iovehicle=val;
//                 });
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Price'),
//               onChanged: (val){
//                 setState(() {
//                   price=val;
//                 });
//               },
//             ),
//             RaisedButton(
//               onPressed: (){
//                 _createPdf(context,cname,pnum,vname,vnum,iovehicle,price);
//               },
//               child: Text('Create PDF'),
//             )
//           ],
//           ), 
//         ),
//       ), 
//     );
//   }

//   _createPdf(BuildContext context,cname,pnum,vname,vnumber,iovehicle,price) async{
//     final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

//     pdf.addPage(pdfLib.MultiPage(
//       build: (context) => [
        
//         pdfLib.Table.fromTextArray(data: <List<String>>[
//           <String>['Customer Name','Phone Number','Vehicle Name','Vehicle Number','Issue of Vehicle','Price'],
//           [cname,pnum,vname,vnumber,iovehicle,price]
//         ])
//       ]));
//     final String dir = (await getApplicationDocumentsDirectory()).path;
//     final String path = '$dir/pdfExample.pdf';

//     final File file = File(path);
//     file.writeAsBytesSync(pdf.save());

//     Navigator.push(context, MaterialPageRoute(builder: (context) => PDFScreen(path)));
//   }
// }

// class PDFScreen extends StatelessWidget {
//   PDFScreen(this.pathPDF);

//   final String pathPDF;

//   @override
//   Widget build(BuildContext context){
//     return PDFViewerScaffold(
//       appBar: AppBar(
//         title: Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.share),
//             onPressed: (){
//               ShareExtend.share(pathPDF, "file", sharePanelTitle: "Example PDF");
//             },
//           ),
//         ],
//       ),
//       path: pathPDF);
//   }
// }