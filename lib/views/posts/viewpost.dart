import 'package:flutter/material.dart';

class ViewPostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Post"),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    //leading: Icon(Icons.sports_soccer),
                    title: Text("Post Title"),
                    subtitle: Text(
                      "Beginner",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        Text(
                          "09:00AM - 06/05/2021",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        Text(
                          "Victoria Park, Paignton",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description"),
                        Text(
                          "Lorem ipsum dolor sit amet...",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Stack(
                            children: [
                              Transform.translate(
                                offset: Offset(25, 0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.brown.shade800,
                                  child: Text("AW"),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0, 0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red.shade800,
                                  child: Text("AW"),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(-25, 0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue.shade800,
                                  child: Text("AW"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "3/5 members",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text("JOIN"),
            ),
          ],
        ),
      ),
    );
  }
}
