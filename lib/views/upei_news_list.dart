import 'package:a1_fakenews/views/upei_news_details.dart';
import 'package:flutter/material.dart';
import '../news/model/model.dart';

class UPEINewsList extends StatefulWidget {
  const UPEINewsList({Key? key}) : super(key: key);

  @override
  _UPEINewsListState createState() => _UPEINewsListState();
}

class _UPEINewsListState extends State<UPEINewsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "UPEI News Reader",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      backgroundColor: Colors.green,
      body: FutureBuilder<List<NewsItem>>(
        future: NewsDatabase().getNewsItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<NewsItem>? news = snapshot.data;
            return ListView.builder(
              itemCount: news!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  child: InkWell(
                    onTap: () async {
                      await NewsDatabase().markItemAsRead(news[index].id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UPEINewsDetail(news: news[index]),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(news[index].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (news[index].isRead)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                news[index].title,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading news..."),
              ],
            ),
          );
        },
      ),
    );
  }
}
