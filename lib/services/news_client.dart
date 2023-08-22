import 'package:dio/dio.dart';

class NewsClient{
  Dio dio = Dio();

  getNewsDataFormatAPI() async{
    String newsURL = "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=b3746bc139d34924af817228006aa137";

    try{
      var response = await dio.get(newsURL);

      print("this is teh news data from the API ${response.data}");
      return response.data;
    }

    catch(error){
      print("error in fecting the data");
    }
  }
}