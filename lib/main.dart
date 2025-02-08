import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_sns/next_page.dart';
import 'package:fire_sns/post.dart';
import 'package:fire_sns/update_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();

    _FetchFirebaseData();
  }

  Future _FetchFirebaseData() async{
    await FirebaseFirestore.instance.collection("posts").orderBy("createdAt", descending: true).get().then((event) {
      final docs = event.docs;
      setState(() {
        posts = docs.map((doc){
          final data = doc.data();
          final id = doc.id;
          final text = data['text'];
          final createdAt = data['createdAt'].toDate();
          final updatedAt = data['updatedAt']?.toDate();
          return Post(id: id, text: text, createdAt: createdAt, updatedAt: updatedAt,);
        },).toList();
      });
    });
  }

  Future _delete(String id)async{
    await FirebaseFirestore.instance.collection("posts").doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: posts.map((post) => InkWell(
            onTap: ()async{
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  UpdatePage(post)),
              );

              _FetchFirebaseData();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 48,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.text, style: TextStyle(fontSize: 20),),
                          Text(post.createdAt.toString(), style: TextStyle(fontSize: 10),),
                        ],
                      ),
                      Spacer(),
                      IconButton(onPressed: ()async{
                        //削除
                        await _delete(post.id);
                        await _FetchFirebaseData();
                      }, icon: Icon(Icons.delete, size: 30,))
                    ],
                  ),
                ],
              ),
            ),
          )).toList(),
        ),
      ),      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //画面遷移
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );

          _FetchFirebaseData();
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
