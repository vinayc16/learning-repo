import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_provider.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Provider Example')),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            'Count: ${counter.count}',
            style: const TextStyle(fontSize: 24),
          ),

          const SizedBox(height: 20),

          counter.isLoading
              ? const CircularProgressIndicator()
              : Expanded(
            child: ListView.builder(
              itemCount: counter.posts.length,
              itemBuilder: (context, index) {
                final item = counter.posts[index];
                return ListTile(
                  title: Text(item['title']),
                  subtitle: Text(item['body']),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.increment();
          counter.fetchData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
