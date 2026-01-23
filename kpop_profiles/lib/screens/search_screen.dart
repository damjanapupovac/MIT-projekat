import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kpop_profiles/providers/idol_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    final idolProvider = Provider.of<IdolProvider>(context);

    final List<GroupModel> allGroups = [
      GroupModel(
        id: '1',
        name: 'TWICE',
        imageUrl: '',
        idols: [
          idolProvider.idols.firstWhere((i) => i.id == '101'),
        ],
        comments: [],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Search Groups")),
      body: ListView.builder(
        itemCount: allGroups.length,
        itemBuilder: (context, index) {
          final group = allGroups[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => GroupDetailsScreen(group: group, role: widget.role),
            )),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(width: 2.5, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 45, child: Icon(Icons.groups, size: 40)),
                    const SizedBox(width: 20),
                    Text(group.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    if (widget.role == UserRole.admin)
                      IconButton(
                        icon: const Icon(Icons.edit, size: 30, color: Colors.blue),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddGroupScreen(existingGroup: group),
                        )),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}