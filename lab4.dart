import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool following = false;
  bool liked = false;
  bool disliked = false;

  int likes = 55;
  int dislikes = 0;
  int followers = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 55,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Danel",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text("IT in Business Student"),
                const Text("Business Analytics & Project Management"),

                const SizedBox(height: 10),

                Text("$followers Followers"),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      following = !following;

                      if (following) {
                        followers++;
                      } else {
                        followers--;
                      }
                    });
                  },
                  child: Text(
                    following ? "Unfollow" : "Follow",
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (liked) {
                            liked = false;
                            likes--;
                          } else {
                            liked = true;
                            likes++;

                            if (disliked) {
                              disliked = false;
                              dislikes--;
                            }
                          }
                        });
                      },
                      icon: Icon(
                        liked
                            ? Icons.thumb_up
                            : Icons.thumb_up_outlined,
                        color: liked ? Colors.blue : Colors.grey,
                      ),
                    ),

                    Text("$likes Likes"),

                    const SizedBox(width: 10),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (disliked) {
                            disliked = false;
                            dislikes--;
                          } else {
                            disliked = true;
                            dislikes++;

                            if (liked) {
                              liked = false;
                              likes--;
                            }
                          }
                        });
                      },
                      icon: Icon(
                        disliked
                            ? Icons.thumb_down
                            : Icons.thumb_down_outlined,
                        color: disliked ? Colors.red : Colors.grey,
                      ),
                    ),

                    Text("$dislikes Dislikes"),
                  ],
                ),

                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      following = false;
                      liked = false;
                      disliked = false;
                      likes = 55;
                      dislikes = 0;
                      followers = 0;
                    });
                  },
                  child: const Text("Reset"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
