import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:kpop_profiles/providers/comment_provider.dart';
import 'package:kpop_profiles/screens/idol_profile.dart';
import 'package:provider/provider.dart';
import 'package:kpop_profiles/providers/idol_provider.dart';
import 'package:kpop_profiles/providers/group_provider.dart';
import '../models/group_model.dart';
import '../models/comment_model.dart';
import '../models/enums.dart';
import '../models/idol_model.dart';

class GroupDetailsScreen extends StatefulWidget {
  final GroupModel group;
  final UserRole role;
  const GroupDetailsScreen({
    super.key,
    required this.group,
    required this.role,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idolProvider = Provider.of<IdolProvider>(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final commentProvider = Provider.of<CommentProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentGroup = groupProvider.groups.firstWhere(
      (g) => g.id == widget.group.id,
      orElse: () => widget.group,
    );

    final List<IdolModel> members = idolProvider.idols
        .where((idol) => idol.groupId == currentGroup.id)
        .toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          currentGroup.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: theme.iconTheme,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "MEMBERS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? Colors.pinkAccent : Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: members.isEmpty
                ? Center(
                    child: Text(
                      "No members found",
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final idol = members[index];
                      return _buildMemberCard(
                        idol,
                        idolProvider,
                        theme,
                        isDark,
                      );
                    },
                  ),
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: isDark ? Colors.white10 : Colors.grey[200],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "GROUP DISCUSSIONS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white38 : Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: StreamBuilder<List<CommentModel>>(
              stream: commentProvider.getComments(currentGroup.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comments = snapshot.data ?? [];

                comments.sort((a, b) {
                  if (a.createdAt == null || b.createdAt == null) return 0;
                  return b.createdAt!.compareTo(a.createdAt!);
                });

                return _buildCommentList(
                  comments,
                  commentProvider,
                  currentUser,
                  theme,
                  isDark,
                );
              },
            ),
          ),
          if (widget.role != UserRole.guest)
            _buildCommentInput(
              commentProvider,
              authProvider,
              currentGroup.id,
              theme,
              isDark,
            ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(
    IdolModel idol,
    IdolProvider idolProvider,
    ThemeData theme,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => IdolProfileScreen(idol: idol, role: widget.role),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.pink.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.pink.withOpacity(0.1),
              backgroundImage:
                  idol.imageUrl != null && idol.imageUrl!.isNotEmpty
                  ? NetworkImage(idol.imageUrl!)
                  : null,
              child: idol.imageUrl == null || idol.imageUrl!.isEmpty
                  ? const Icon(Icons.person, color: Colors.pink)
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    idol.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    idol.birthday,
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.role != UserRole.guest)
              IconButton(
                icon: Icon(
                  idol.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: idol.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () => idolProvider.toggleFavourite(idol.id),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentList(
    List<CommentModel> comments,
    CommentProvider commentProvider,
    User? currentUser,
    ThemeData theme,
    bool isDark,
  ) {
    if (comments.isEmpty) {
      return Center(
        child: Text(
          "No comments yet. Be the first!",
          style: TextStyle(color: isDark ? Colors.white24 : Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        final bool isMyComment =
            currentUser != null && comment.userId == currentUser.uid;
        final bool isLikedByMe =
            currentUser != null && comment.likedBy.contains(currentUser.uid);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.pink.withOpacity(0.2),
                backgroundImage: comment.userImage.isNotEmpty
                    ? NetworkImage(comment.userImage)
                    : null,
                child: comment.userImage.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 20,
                        color: isDark ? Colors.white : Colors.pink,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMyComment
                        ? Colors.pink.withOpacity(isDark ? 0.15 : 0.05)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          if (isMyComment)
                            GestureDetector(
                              onTap: () =>
                                  commentProvider.deleteComment(comment.id),
                              child: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => commentProvider.toggleLike(
                              comment.id,
                              comment.likedBy,
                            ),
                            child: Icon(
                              isLikedByMe
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: isLikedByMe ? Colors.pink : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${comment.likedBy.length}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentInput(
    CommentProvider commentProvider,
    AuthProvider authProvider,
    String targetId,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 25),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white10 : Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: "Say something nice...",
                hintStyle: TextStyle(
                  color: isDark ? Colors.white24 : Colors.grey[400],
                ),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.pink,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: () async {
                final text = _commentController.text.trim();
                if (text.isNotEmpty) {
                  // IZMENA: Prosleđujemo username i sliku iz AuthProvider-a
                  await commentProvider.addComment(
                    targetId,
                    text,
                    authProvider.username,
                    authProvider.userImage,
                  );
                  _commentController.clear();
                  if (mounted) FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
