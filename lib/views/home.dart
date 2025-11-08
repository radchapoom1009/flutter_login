import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/views/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _inputController = TextEditingController();
  final List<String> _items = [];

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  Future<void> _openCalendar(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // วันที่เริ่มต้น
      firstDate: DateTime(2000), // วันที่ต่ำสุด
      lastDate: DateTime(2100), // วันที่สูงสุด
    );

    if (pickedDate != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected date: ${pickedDate.toLocal()}")),
      );
    }
  }

  void _showAddInputDialog() {
    _inputController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              hintText: 'Enter item name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_inputController.text.trim().isNotEmpty) {
                  setState(() {
                    _items.add(_inputController.text.trim());
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added: ${_inputController.text.trim()}'),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Welcome ${user?.email ?? "Guest"}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            color: Colors.white,
            onPressed: () => _openCalendar(context),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () => logout(context), // ✅ ใช้งานได้
          ),
        ],
        backgroundColor: Colors.brown[800],
      ),
      body: _items.isEmpty
          ? SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Home Page',
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No items yet. Tap the + button to add one!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(_items[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _items.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddInputDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
    );
  }
}
