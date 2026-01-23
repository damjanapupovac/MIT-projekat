import 'package:flutter/material.dart';
import 'package:kpop_profiles/models/idol_model.dart';
import '../models/group_model.dart';
import '../models/comment_model.dart';
import '../models/enums.dart';

class IdolProfileScreen extends StatefulWidget {
  final IdolModel idol;
  final UserRole role;
  const IdolProfileScreen({super.key, required this.idol, required this.role});

  @override
  State<IdolProfileScreen> createState() => _IdolProfileScreenState();
}

class _IdolProfileScreenState extends State<IdolProfileScreen> {
  final TextEditingController _idolCommentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.idol.name}'s Profile")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 60, child: Icon(Icons.person, size: 60)),
          const SizedBox(height: 10),
          Text(
            widget.idol.name,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(
            "Birthday: ${widget.idol.birthday}",
            style: const TextStyle(fontSize: 18),
          ),
          const Divider(height: 30, thickness: 2),
          const Text(
            "FAN COMMENTS",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.idol.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.idol.comments[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(comment.text),
                    ],
                  ),
                );
              },
            ),
          ),
          if (widget.role != UserRole.guest)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _idolCommentController,
                      decoration: InputDecoration(
                        hintText: "Write to ${widget.idol.name}...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_idolCommentController.text.isNotEmpty) {
                        setState(() {
                          widget.idol.comments.add(
                            CommentModel(
                              username: "Fan",
                              text: _idolCommentController.text,
                            ),
                          );
                          _idolCommentController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
