import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/services/auth_service.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userData = user.data() as Map<String, dynamic>;
              final email = userData['email'] ?? '';
              final role = userData['role'] ?? 'user';
              final isAdmin = role == 'admin';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(email),
                  subtitle: Text('Role: $role'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isAdmin)
                        IconButton(
                          icon: const Icon(Icons.admin_panel_settings),
                          color: Colors.blue,
                          onPressed: () => _updateUserRole(
                            context,
                            user.id,
                            'admin',
                          ),
                        ),
                      if (isAdmin && user.id != authService.currentUser?.uid)
                        IconButton(
                          icon: const Icon(Icons.person_remove),
                          color: Colors.red,
                          onPressed: () => _updateUserRole(
                            context,
                            user.id,
                            'user',
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _updateUserRole(
    BuildContext context,
    String userId,
    String newRole,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'role': newRole});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User role updated to $newRole'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update user role'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}