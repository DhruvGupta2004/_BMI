import 'package:flutter/material.dart';
import 'package:news_app/services/news_client.dart';
import 'package:news_app/services/news_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

NewsClient nClient = NewsClient();

Future<List<NewsModel>> getNEWS() async {
  Map<String, dynamic> newsMap =
  await nClient.getNewsDataFormatAPI(); //complete news JSON/map
  List<dynamic> nList = newsMap['articles'];
  List<NewsModel> newsList = genericToSpecificObject(nList);
  return newsList;
}

genericToSpecificObject(List<dynamic> list) {
  List<NewsModel> newsList = list.map((singleObject) {
    NewsModel singleNews = NewsModel.extractFromJSON(singleObject);
    return singleNews;
  }).toList();

  return newsList;
}
class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed:(){
                setState(() {
                });
              }, icon: const Icon(Icons.replay),)
        ],
      ),

      body: Container(
        color: Colors.greenAccent,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(future:getNEWS(), builder:(context , snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );


          }else if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );


          }else if(snapshot.hasData){

            return ListView.builder(itemCount:snapshot.data!.length , itemBuilder: (context , index){
              return Card(
                margin: EdgeInsets.all(16), // Margin around the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(snapshot.data![index].urlToImage),

                      const SizedBox(height: 8),

                      Text(
                        snapshot.data![index].title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        snapshot.data![index].description,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(snapshot.data![index].author,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
            // return const Center(
            //   child: Text("Success"),
            // );
          }
          return Container();
        }),
      ),
    ));
  }
}
