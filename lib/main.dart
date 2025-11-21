import 'package:flutter/material.dart';
import 'views/app_styles.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class StyledButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed; // changed to nullable
  final Color backgroundColor;

  const StyledButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.brown,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return ElevatedButton.icon(
      onPressed: onPressed, // pass null to disable
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? backgroundColor : Colors.grey,
        foregroundColor: enabled ? Colors.white : Colors.white70,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

// ...existing code...
class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  String _selectedSize = 'Footlong'; // changed code

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
        'Sandwich Counter',
        style: heading1
        )
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // changed code: dropdown to pick sandwich size
            DropdownButton<String>(
              value: _selectedSize,
              items: const [
                DropdownMenuItem(value: 'Footlong', child: Text('Footlong')),
                DropdownMenuItem(value: '6-inch', child: Text('6-inch')),
              ],
              onChanged: (value) => setState(() {
                if (value != null) _selectedSize = value;
              }),
            ),

            // changed code: use selectedSize
            OrderItemDisplay(_quantity, _selectedSize),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  label: 'Add',
                  icon: Icons.add,
                  onPressed: _quantity < widget.maxQuantity
                      ? _increaseQuantity
                      : null,
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 16),
                StyledButton(
                  label: 'Remove',
                  icon: Icons.remove,
                  onPressed: _quantity > 0 ? _decreaseQuantity : null,
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// ...existing code...

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    final sandwiches = List.generate(quantity, (_) => '🥪').join(); // changed code
    return Text(
      '$quantity $itemType sandwich(es): $sandwiches',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}
