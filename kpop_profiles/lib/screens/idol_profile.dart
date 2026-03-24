import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:provider/provider.dart';
import 'package:kpop_profiles/models/idol_model.dart';
import 'package:kpop_profiles/providers/comment_provider.dart';
import '../models/comment_model.dart';
import '../models/enums.dart';
import '../providers/idol_provider.dart';

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
  void dispose() {
    _idolCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idolProvider = Provider.of<IdolProvider>(context);
    final commentProvider = Provider.of<CommentProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentIdol = idolProvider.idols.firstWhere(
      (i) => i.id == widget.idol.id,
      orElse: () => widget.idol,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: theme.iconTheme,
        title: Text(
          "${currentIdol.name}'s Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              currentIdol.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: currentIdol.isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => idolProvider.toggleFavourite(currentIdol.id),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Hero(
            tag: currentIdol.id,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.pink.withOpacity(0.1),
              backgroundImage:
                  currentIdol.imageUrl != null &&
                      currentIdol.imageUrl!.isNotEmpty
                  ? NetworkImage(currentIdol.imageUrl!)
                  : null,
              child:
                  currentIdol.imageUrl == null || currentIdol.imageUrl!.isEmpty
                  ? const Icon(Icons.person, size: 70, color: Colors.pink)
                  : null,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            currentIdol.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "🎂 ${currentIdol.birthday}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              "FAN MESSAGES ✨",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: commentProvider.getComments(currentIdol.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final idolComments = snapshot.data ?? [];

                idolComments.sort((a, b) {
                  if (a.createdAt == null || b.createdAt == null) return 0;
                  return b.createdAt!.compareTo(a.createdAt!);
                });

                if (idolComments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 50,
                          color: isDark ? Colors.white10 : Colors.grey[300],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No messages yet. Send some love!",
                          style: TextStyle(
                            color: isDark ? Colors.white38 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: idolComments.length,
                  itemBuilder: (context, index) {
                    final comment = idolComments[index];
                    return _buildCommentCard(
                      comment,
                      commentProvider,
                      currentUser,
                      theme,
                      isDark,
                    );
                  },
                );
              },
            ),
          ),
          if (widget.role != UserRole.guest)
            _buildCommentInput(
              commentProvider,
              authProvider,
              currentIdol.id,
              theme,
              isDark,
            ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
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
              controller: _idolCommentController,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: "Type a sweet message...",
                hintStyle: TextStyle(
                  color: isDark ? Colors.white24 : Colors.grey[400],
                ),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              final text = _idolCommentController.text.trim();
              if (text.isNotEmpty) {
                await commentProvider.addComment(
                  targetId,
                  text,
                  authProvider.username,
                  authProvider.userImage,
                );
                _idolCommentController.clear();
                if (mounted) FocusScope.of(context).unfocus();
              }
            },
            child: const CircleAvatar(
              backgroundColor: Colors.pink,
              radius: 24,
              child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(
    CommentModel comment,
    CommentProvider provider,
    User? currentUser,
    ThemeData theme,
    bool isDark,
  ) {
    final bool isMyComment =
        currentUser != null && comment.userId == currentUser.uid;
    final bool isLikedByMe =
        currentUser != null && comment.likedBy.contains(currentUser.uid);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.pink.withOpacity(0.2),
                backgroundImage: comment.userImage.isNotEmpty
                    ? NetworkImage(comment.userImage)
                    : null,
                child: comment.userImage.isEmpty
                    ? Text(
                        comment.username.isNotEmpty
                            ? comment.username[0].toUpperCase()
                            : "?",
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white : Colors.pink,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                comment.username,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const Spacer(),
              if (isMyComment)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onPressed: () => provider.deleteComment(comment.id),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.text, style: TextStyle(fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => provider.toggleLike(comment.id, comment.likedBy),
                child: Icon(
                  isLikedByMe ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: isLikedByMe ? Colors.pink : Colors.grey,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "${comment.likedBy.length}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
