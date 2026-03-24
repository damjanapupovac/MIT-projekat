import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kpop_profiles/providers/group_provider.dart';
import 'package:kpop_profiles/screens/add_group.dart';
import 'package:kpop_profiles/screens/group_details.dart';
import '../models/group_model.dart';
import '../models/enums.dart';

class SearchScreen extends StatefulWidget {
  final UserRole role;
  const SearchScreen({super.key, required this.role});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    final List<GroupModel> allGroups = groupProvider.groups;

    List<GroupModel> displayList = searchTextController.text.isEmpty
        ? allGroups
        : allGroups
              .where(
                (group) => group.name.toLowerCase().contains(
                  searchTextController.text.toLowerCase(),
                ),
              )
              .toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Search Groups")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  hintText: "Search group name...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchTextController.clear();
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
            Expanded(
              child: displayList.isEmpty
                  ? const Center(child: Text("No groups found."))
                  : ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final group = displayList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.5,
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupDetailsScreen(
                                  group: group,
                                  role: widget.role,
                                ),
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: group.imageUrl.isNotEmpty
                                  ? NetworkImage(group.imageUrl)
                                  : null,
                              child: group.imageUrl.isEmpty
                                  ? const Icon(Icons.groups)
                                  : null,
                            ),
                            title: Text(
                              group.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: widget.role == UserRole.admin
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddGroupScreen(
                                                  existingGroup: group,
                                                ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          bool? confirm = await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text("Delete?"),
                                              content: Text(
                                                "Remove ${group.name}?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, false),
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, true),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await groupProvider.deleteGroup(
                                              group.id,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
