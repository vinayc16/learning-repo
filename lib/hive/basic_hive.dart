import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCrudExample extends StatefulWidget {
  const HiveCrudExample({super.key});

  @override
  State<HiveCrudExample> createState() => _HiveCrudExampleState();
}

class _HiveCrudExampleState extends State<HiveCrudExample> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late Box box;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    box = Hive.box('myBox');
  }

  // Add data to Hive
  void addData() async {
    final controller = nameController.text.isNotEmpty && ageController.text.isNotEmpty;

    if (!controller) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both name and age")),
      );
      return;
    }

    await box.put('name', nameController.text);
    await box.put('age', ageController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data Saved Successfully")),
    );
  }

  // Get data from Hive and show it in the text fields
  void getData() {
    var name = box.get('name');
    var age = box.get('age');

    if (name == null || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No Data Found")),
      );
      return;
    }

    // Set the text controllers with the existing data
    nameController.text = name;
    ageController.text = age.toString();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data Retrieved Successfully")),
    );
  }

  // Update data in Hive
  void updateData() async {
    final controller = nameController.text.isNotEmpty && ageController.text.isNotEmpty;

    if (!controller) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both name and age")),
      );
      return;
    }

    await box.put('name', nameController.text);
    await box.put('age', ageController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data Updated Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive CRUD Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box box, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Enter Name',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(
                        labelText: 'Enter Age',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      addData(); // Save data to Hive
                    },
                    child: const Text('CREATE'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      updateData(); // Update data in Hive
                    },
                    child: const Text('UPDATE'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      getData(); // Get data from Hive and show in UI
                    },
                    child: const Text('GET DATA'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      box.delete('age');
                      box.delete('name'); // Delete both name and age
                    },
                    child: const Text('DELETE DATA'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      box.clear(); // Clear all data in the box
                    },
                    child: const Text('CLEAR ALL'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
