import 'package:flutter/material.dart';
import 'package:kpop_profiles/screens/idol_profile.dart';
import '../models/group_model.dart';
import '../models/comment_model.dart';
import '../models/enums.dart';

class GroupDetailsScreen extends StatefulWidget {
  final GroupModel group;
  final UserRole role;
  const GroupDetailsScreen({super.key, required this.group, required this.role});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("MEMBERS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: widget.group.idols.length,
              itemBuilder: (context, index) {
                final idol = widget.group.idols[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (c) => IdolProfileScreen(idol: idol, role: widget.role),
                  )),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(idol.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(idol.birthday),
                          ],
                        ),
                        const Spacer(),
                        if (widget.role != UserRole.guest)
                          IconButton(
                            icon: Icon(
                              idol.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: idol.isFavorite ? Colors.red : null,
                              size: 30,
                            ),
                            onPressed: () => setState(() => idol.isFavorite = !idol.isFavorite),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(thickness: 2),
          const Text("GROUP COMMENTS", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            flex: 1,
            child: _buildCommentList(widget.group.comments),
          ),
          if (widget.role != UserRole.guest) _buildCommentInput(widget.group.comments),
        ],
      ),
    );
  }

  Widget _buildCommentList(List<CommentModel> comments) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.username, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
              Text(comment.text),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.favorite, size: 16, color: Colors.red), 
                    onPressed: () => setState(() => comment.likes++)),
                    Text("${comment.likes}"),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
  Widget _buildCommentInput(List<CommentModel> comments) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: TextField(controller: _commentController, decoration: const InputDecoration(hintText: "Add comment..."))),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                setState(() {
                  comments.add(CommentModel(username: "User", text: _commentController.text));
                  _commentController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}