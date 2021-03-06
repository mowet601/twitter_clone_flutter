import 'package:flutter/material.dart';
import 'package:social_app/model/scream_response.dart';
import 'package:social_app/repository/repository.dart';

class ScreamDetailPage extends StatefulWidget {
  final String screamId;

  const ScreamDetailPage({Key key, this.screamId}) : super(key: key);

  @override
  _ScreamDetailPageState createState() => _ScreamDetailPageState();
}

class _ScreamDetailPageState extends State<ScreamDetailPage> {
  Repository repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: FutureBuilder<ScreamResponse>(
            future: repository.getScreamById(screamId: widget.screamId),
            builder:
                (BuildContext context, AsyncSnapshot<ScreamResponse> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.amberAccent,
                  ));
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    print(snapshot.error); //Print Error
                    print(widget.screamId);
                    return Center(child: Text('${snapshot.error}'));
                  }

                  return Container(child: BuildScream(scream: snapshot.data));

                case ConnectionState.none:
                  break;
                case ConnectionState.active:
                  break;
              }
              return Text('');
            }),
      ),
    );
  }
}

class BuildScream extends StatefulWidget {
  final ScreamResponse scream;

  const BuildScream({Key key, this.scream}) : super(key: key);

  @override
  _BuildScreamState createState() => _BuildScreamState();
}

class _BuildScreamState extends State<BuildScream> {
  @override
  Widget build(BuildContext context) {
    var lengthOfComments = widget.scream.comments.length;
    return Container(
        child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5,top: 5),
              child: Text(widget.scream.userHandle),
            ),
            // contentPadding: EdgeInsets.all(5),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(widget.scream.image),
            ),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    widget.scream.body,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(.8),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(widget.scream.createdAt.toString()),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.thumb_up_alt_outlined),
                          label: Text(widget.scream.likeCount.toString())),
                      TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.thumb_down_alt_outlined),
                          label: Text(widget.scream.unlikeCount.toString())),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.messenger_outline),
                        label: Text(widget.scream.commentCount.toString()),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                   Column(
                      children: [
                        for(int i = 0; i<lengthOfComments; i++)
                          ListTile(leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(widget.scream.comments.elementAt(i).imageUrl),
                          ),
                            title: Text(widget.scream.comments.elementAt(i).userHandle),
                            subtitle: Column(children: [
                              Text(widget.scream.comments.elementAt(i).body)
                            ],),
                          )
                      ],
                    ),

            ])

        ));
  }
}
