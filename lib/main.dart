import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const ExpenseTrackerApp());
}

class Expense {
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String note;
  final String paymentMethod;

  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
    required this.paymentMethod,
  });
}


class Country {
  final String name;
  final String code;
  final String dialCode;
  final String currency;
  final String currencySymbol;

  const Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.currency,
    required this.currencySymbol,
  });
}

final List<Country> countries = [
  Country(name: 'India', code: 'IN', dialCode: '+91', currency: 'Rupees', currencySymbol: '₹'),
  Country(name: 'United States', code: 'US', dialCode: '+1', currency: 'Dollars', currencySymbol: '\$'),
  Country(name: 'United Kingdom', code: 'GB', dialCode: '+44', currency: 'Pounds', currencySymbol: '£'),
  Country(name: 'Canada', code: 'CA', dialCode: '+1', currency: 'Dollars', currencySymbol: '\$'),
  Country(name: 'Australia', code: 'AU', dialCode: '+61', currency: 'Dollars', currencySymbol: '\$'),
  Country(name: 'Germany', code: 'DE', dialCode: '+49', currency: 'Euros', currencySymbol: '€'),
  Country(name: 'France', code: 'FR', dialCode: '+33', currency: 'Euros', currencySymbol: '€'),
  Country(name: 'Japan', code: 'JP', dialCode: '+81', currency: 'Yen', currencySymbol: '¥'),
  Country(name: 'China', code: 'CN', dialCode: '+86', currency: 'Yuan', currencySymbol: '¥'),
];

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  Country? _selectedCountry;

  final String _demoEmail = "user@example.com";
  final String _demoMobile = "9876543210";
  final String _demoPassword = "password123";

  @override
  void initState() {
    super.initState();

    _selectedCountry = countries.firstWhere((country) => country.code == 'IN');
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);


      await Future.delayed(const Duration(seconds: 1));

      if (_emailController.text == _demoEmail &&
          _mobileController.text == _demoMobile &&
          _passwordController.text == _demoPassword) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(selectedCountry: _selectedCountry!),
          ),
        );
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade700,
              Colors.purple.shade300,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 60,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 30),

                
                const Text(
                  'Expense Tracker',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Track your expenses smartly',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),

                // Login Card
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Country Selection with Mobile Number - FIXED OVERLAPPING
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // For smaller screens, stack vertically
                              if (constraints.maxWidth < 400) {
                                return Column(
                                  children: [
                                    // Country Dropdown
                                    DropdownButtonFormField<Country>(
                                      value: _selectedCountry,
                                      decoration: const InputDecoration(
                                        labelText: 'Country',
                                        prefixIcon: Icon(Icons.flag),
                                        border: OutlineInputBorder(),
                                      ),
                                      items: countries.map((country) {
                                        return DropdownMenuItem<Country>(
                                          value: country,
                                          child: Text(
                                            '${country.name} ${country.dialCode}',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCountry = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select country';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // Mobile Number Field
                                    TextFormField(
                                      controller: _mobileController,
                                      decoration: const InputDecoration(
                                        labelText: 'Mobile Number',
                                        prefixIcon: Icon(Icons.phone),
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter mobile number';
                                        }
                                        if (value.length != 10) {
                                          return 'Mobile number must be 10 digits';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                );
                              }
                              // For larger screens, keep horizontal layout
                              return Row(
                                children: [
                                  // Country Dropdown - made it more compact
                                  Expanded(
                                    flex: 3,
                                    child: DropdownButtonFormField<Country>(
                                      value: _selectedCountry,
                                      decoration: const InputDecoration(
                                        labelText: 'Country',
                                        prefixIcon: Icon(Icons.flag),
                                        border: OutlineInputBorder(),
                                      ),
                                      items: countries.map((country) {
                                        return DropdownMenuItem<Country>(
                                          value: country,
                                          child: Text(
                                            '${country.code} ${country.dialCode}',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCountry = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select country';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Mobile Number Field
                                  Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      controller: _mobileController,
                                      decoration: const InputDecoration(
                                        labelText: 'Mobile Number',
                                        prefixIcon: Icon(Icons.phone),
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter mobile number';
                                        }
                                        if (value.length != 10) {
                                          return 'Mobile number must be 10 digits';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Demo Credentials
                Card(
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Demo Credentials:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: $_demoEmail',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Mobile: $_demoMobile',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Password: $_demoPassword',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Quick Login Button (for demo)
                TextButton(
                  onPressed: () {
                    _emailController.text = _demoEmail;
                    _mobileController.text = _demoMobile;
                    _passwordController.text = _demoPassword;
                    _login();
                  },
                  child: const Text(
                    'Quick Login with Demo Account',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class HomeScreen extends StatefulWidget {
  final Country selectedCountry;

  const HomeScreen({super.key, required this.selectedCountry});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Expense> _expenses = [];
  double _monthlyBudget = 5000.0;
  File? _profileImage;
  bool _showNotifications = false;

  // Sample notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Budget Alert',
      'message': 'You have used 80% of your monthly budget',
      'time': '2 hours ago',
      'read': false,
    },
    {
      'title': 'Bill Reminder',
      'message': 'Electricity bill due in 3 days',
      'time': 'Yesterday',
      'read': true,
    },
    {
      'title': 'Spending Alert',
      'message': 'High spending detected in Food category',
      'time': '2 days ago',
      'read': true,
    },
    {
      'title': 'Welcome',
      'message': 'Welcome to Expense Tracker! Start tracking your expenses.',
      'time': '1 week ago',
      'read': true,
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': Icons.fastfood, 'color': Colors.green, 'budget': 800},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.blue, 'budget': 400},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.purple, 'budget': 600},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Colors.orange, 'budget': 300},
    {'name': 'Bills', 'icon': Icons.receipt, 'color': Colors.red, 'budget': 1200},
    {'name': 'Healthcare', 'icon': Icons.medical_services, 'color': Colors.teal, 'budget': 300},
    {'name': 'Education', 'icon': Icons.school, 'color': Colors.indigo, 'budget': 200},
    {'name': 'Other', 'icon': Icons.more_horiz, 'color': Colors.grey, 'budget': 200},
  ];

  @override
  void initState() {
    super.initState();

    _expenses.addAll([
      Expense(
        title: 'Grocery Shopping',
        amount: 85.50,
        category: 'Food',
        date: DateTime.now().subtract(const Duration(days: 1)),
        note: 'Weekly groceries',
        paymentMethod: 'Credit Card',
      ),
      Expense(
        title: 'Uber Ride',
        amount: 25.00,
        category: 'Transport',
        date: DateTime.now().subtract(const Duration(days: 2)),
        note: 'Airport transfer',
        paymentMethod: 'Google Pay',
      ),
      Expense(
        title: 'Netflix Subscription',
        amount: 15.99,
        category: 'Entertainment',
        date: DateTime.now().subtract(const Duration(days: 5)),
        note: 'Monthly subscription',
        paymentMethod: 'Debit Card',
      ),
    ]);
  }

  // Get currency symbol based on selected country
  String get currencySymbol => widget.selectedCountry.currencySymbol;

  // Format amount with currency symbol
  String formatAmount(double amount) {
    return '$currencySymbol${amount.toStringAsFixed(2)}';
  }

  double get _totalExpenses {
    double total = 0;
    for (var expense in _expenses) {
      total += expense.amount;
    }
    return total;
  }

  double get _remainingBudget => _monthlyBudget - _totalExpenses;
  double get _budgetUsagePercent => _monthlyBudget > 0 ? (_totalExpenses / _monthlyBudget) * 100 : 0;

  Map<String, double> get _categoryTotals {
    Map<String, double> totals = {};
    for (var expense in _expenses) {
      if (totals.containsKey(expense.category)) {
        totals[expense.category] = totals[expense.category]! + expense.amount;
      } else {
        totals[expense.category] = expense.amount;
      }
    }
    return totals;
  }

  void _addExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(
          categories: _categories,
          currencySymbol: currencySymbol,
        ),
      ),
    );

    if (result != null && result is Expense) {
      setState(() {
        _expenses.add(result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Expense added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _showBudgetDialog() {
    TextEditingController budgetController = TextEditingController(text: _monthlyBudget.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Monthly Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Current Budget: ${formatAmount(_monthlyBudget)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.attach_money),
                  labelText: 'New Budget',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newBudget = double.tryParse(budgetController.text);
                if (newBudget != null) {
                  setState(() {
                    _monthlyBudget = newBudget;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Budget updated to ${formatAmount(_monthlyBudget)}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Show category details
  void _showCategoryDetails(String categoryName) {
    final categoryExpenses = _expenses.where((expense) => expense.category == categoryName).toList();
    final total = _categoryTotals[categoryName] ?? 0;
    final category = _categories.firstWhere((cat) => cat['name'] == categoryName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      color: category['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total Spent: ${formatAmount(total)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Expense History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (categoryExpenses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No expenses in this category yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = categoryExpenses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(expense.title),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy').format(expense.date),
                          ),
                          trailing: Text(
                            '-${formatAmount(expense.amount)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          onTap: () => _showExpenseDetails(expense),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Show notifications dropdown
  void _showNotificationsDropdown() {
    setState(() {
      _showNotifications = !_showNotifications;
    });
  }

  // Mark notification as read
  void _markNotificationAsRead(int index) {
    setState(() {
      _notifications[index]['read'] = true;
    });
  }

  // Clear all notifications
  void _clearAllNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          // Country flag and currency info - FIXED WHITE TEXT
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.selectedCountry.code,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  currencySymbol,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Budget edit icon
          IconButton(
            onPressed: _showBudgetDialog,
            icon: const Icon(Icons.edit),
            tooltip: 'Set Monthly Budget',
          ),
          // Notifications with dropdown
          Stack(
            children: [
              IconButton(
                onPressed: _showNotificationsDropdown,
                icon: const Icon(Icons.notifications),
              ),
              if (_notifications.any((notif) => !notif['read']))
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _notifications.where((notif) => !notif['read']).length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          _selectedIndex == 0 ? _buildHomeScreen() : _selectedIndex == 1 ? _buildStatisticsScreen() : _buildProfileScreen(),

          // Notifications Dropdown
          if (_showNotifications)
            Positioned(
              right: 16,
              top: 70,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 320,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: _clearAllNotifications,
                                  child: const Text(
                                    'Clear All',
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: _showNotificationsDropdown,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Notifications List
                      if (_notifications.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.notifications_none, size: 48, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No notifications',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      else
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _notifications.length,
                            itemBuilder: (context, index) {
                              final notification = _notifications[index];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: notification['read'] ? Colors.grey[200] : Colors.purple[50],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        notification['read'] ? Icons.notifications_none : Icons.notifications_active,
                                        color: notification['read'] ? Colors.grey : Colors.purple,
                                      ),
                                    ),
                                    title: Text(
                                      notification['title'],
                                      style: TextStyle(
                                        fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(notification['message']),
                                        const SizedBox(height: 4),
                                        Text(
                                          notification['time'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () => _markNotificationAsRead(index),
                                  ),
                                  if (index < _notifications.length - 1)
                                    Divider(height: 1, color: Colors.grey[200]),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _showNotifications = false; // Hide notifications when switching tabs
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
      ),
      // Moved FAB to the right side
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Monthly Budget',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Chip(
                          label: Text(
                            DateFormat('MMM yyyy').format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.purple.withOpacity(0.1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${formatAmount(_totalExpenses)} / ${formatAmount(_monthlyBudget)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _budgetUsagePercent / 100,
                      backgroundColor: Colors.grey[200],
                      color: _budgetUsagePercent > 80 ? Colors.red : Colors.purple,
                      minHeight: 12,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_budgetUsagePercent.toStringAsFixed(1)}% used',
                          style: TextStyle(
                            color: _budgetUsagePercent > 80 ? Colors.red : Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${formatAmount(_remainingBudget)} left',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Stats
            const Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard(
                    title: 'Today',
                    amount: 43.50,
                    icon: Icons.today,
                    color: Colors.blue[100]!,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    title: 'This Week',
                    amount: 185.25,
                    icon: Icons.date_range,
                    color: Colors.purple[100]!,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    title: 'Avg/Day',
                    amount: _expenses.isNotEmpty ? _totalExpenses / 30 : 0,
                    icon: Icons.trending_up,
                    color: Colors.green[100]!,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (_expenses.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No expenses yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add your first expense using the + button',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _expenses.length > 5 ? 5 : _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];
                  final category = _categories.firstWhere(
                        (cat) => cat['name'] == expense.category,
                    orElse: () => _categories.last,
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: category['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          category['icon'],
                          color: category['color'],
                        ),
                      ),
                      title: Text(
                        expense.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${expense.category} • ${DateFormat('MMM d').format(expense.date)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '-${formatAmount(expense.amount)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            expense.paymentMethod,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _showExpenseDetails(expense),
                      onLongPress: () => _deleteExpense(index),
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            // Categories Overview
            const Text(
              'Spending by Category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final total = _categoryTotals[category['name']] ?? 0;

                  return GestureDetector(
                    onTap: () => _showCategoryDetails(category['name']),
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (category['color'] as Color).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  category['icon'] as IconData,
                                  color: category['color'] as Color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category['name'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${formatAmount(total)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Spending Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220, // INCREASED HEIGHT TO PREVENT OVERLAPPING
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final day = DateTime.now().subtract(Duration(days: 6 - index));
                        double dayExpenses = 0;
                        for (var expense in _expenses) {
                          if (expense.date.day == day.day && expense.date.month == day.month) {
                            dayExpenses += expense.amount;
                          }
                        }

                        // Calculate bar height with a maximum limit
                        double barHeight = dayExpenses > 0 ? (dayExpenses * 1.5) : 5;
                        barHeight = barHeight > 150 ? 150 : barHeight; // Limit max height

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 60,
                                ),
                                child: Text(
                                  formatAmount(dayExpenses),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 30,
                                height: barHeight,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 40,
                                child: Column(
                                  children: [
                                    Text(
                                      DateFormat('E').format(day),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      day.day.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Last 7 Days',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._categories.map((category) {
                    final total = _categoryTotals[category['name']] ?? 0;
                    final budget = (category['budget'] as num).toDouble();
                    final percent = budget > 0 ? (total / budget * 100) : 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (category['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              color: category['color'] as Color,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      category['name'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${formatAmount(total)} / ${formatAmount(budget)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: percent / 100,
                                  backgroundColor: Colors.grey[200],
                                  color: category['color'] as Color,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Picture with Camera Icon
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.purple, width: 3),
                ),
                child: ClipOval(
                  child: _profileImage != null
                      ? Image.file(_profileImage!, fit: BoxFit.cover)
                      : Container(
                    color: Colors.purple,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    onPressed: _pickImage,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Expense Tracker User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Premium Member • ${widget.selectedCountry.name}',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

          _buildProfileOption(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              _showOptionDetails(
                'Settings',
                'Configure your expense tracker preferences. Here you can:\n\n• Change app theme\n• Set default currency\n• Manage notifications\n• Backup and restore data\n• Set financial goals\n• Customize categories',
              );
            },
          ),
          _buildProfileOption(
            icon: Icons.security,
            title: 'Privacy & Security',
            onTap: () {
              _showOptionDetails(
                'Privacy & Security',
                'Manage your privacy and security settings:\n\n• Two-factor authentication\n• Data encryption\n• Privacy controls\n• App lock with PIN/Fingerprint\n• Data sharing preferences\n• Account security audit',
              );
            },
          ),
          _buildProfileOption(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              _showOptionDetails(
                'Notifications',
                'Configure notification preferences:\n\n• Budget alerts\n• Bill reminders\n• Spending updates\n• Monthly reports\n• Security alerts\n• Custom notification schedule',
              );
            },
          ),
          _buildProfileOption(
            icon: Icons.file_download,
            title: 'Export Data',
            onTap: () {
              _showOptionDetails(
                'Export Data',
                'Export your expense data in various formats:\n\n• CSV for spreadsheets\n• PDF for reports\n• JSON for developers\n• Excel compatible\n• Google Sheets integration\n• Scheduled exports',
              );
            },
          ),
          _buildProfileOption(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              _showOptionDetails(
                'Help & Support',
                'Get assistance with the app:\n\n• FAQ section\n• Video tutorials\n• Contact support\n• Feature requests\n• Bug reporting\n• User community',
              );
            },
          ),

          const SizedBox(height: 30),

          Card(
            color: Colors.red[50],
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red[600],
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionDetails(String title, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(description),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 120,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatAmount(amount),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExpenseDetails(Expense expense) {
    final category = _categories.firstWhere(
          (cat) => cat['name'] == expense.category,
      orElse: () => _categories.last,
    );

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      color: category['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          expense.category,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '-${formatAmount(expense.amount)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow(
                icon: Icons.calendar_today,
                title: 'Date',
                value: DateFormat('MMM dd, yyyy - hh:mm a').format(expense.date),
              ),
              _buildDetailRow(
                icon: Icons.credit_card,
                title: 'Payment Method',
                value: expense.paymentMethod,
              ),
              if (expense.note.isNotEmpty)
                _buildDetailRow(
                  icon: Icons.note,
                  title: 'Note',
                  value: expense.note,
                ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _addExpense();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// AddExpenseScreen class
class AddExpenseScreen extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final String currencySymbol;

  const AddExpenseScreen({super.key, required this.categories, required this.currencySymbol});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'Credit Card';
  final List<String> _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'Cash',
    'Google Pay',
    'Apple Pay',
    'Bank Transfer',
    'PayPal',
  ];

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final expense = Expense(
                  title: _titleController.text,
                  amount: double.parse(_amountController.text),
                  category: _selectedCategory,
                  date: _selectedDate,
                  note: _noteController.text,
                  paymentMethod: _selectedPaymentMethod,
                );
                Navigator.pop(context, expense);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.attach_money),
                  labelText: 'Amount (${widget.currencySymbol})',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.title),
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category),
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: widget.categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category['name'] as String,
                    child: Row(
                      children: [
                        Icon(category['icon'] as IconData, color: category['color'] as Color),
                        const SizedBox(width: 8),
                        Text(category['name'] as String),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),


              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),


              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.credit_card),
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: _paymentMethods.map<DropdownMenuItem<String>>((method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 16),


              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.note),
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),


              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final expense = Expense(
                        title: _titleController.text,
                        amount: double.parse(_amountController.text),
                        category: _selectedCategory,
                        date: _selectedDate,
                        note: _noteController.text,
                        paymentMethod: _selectedPaymentMethod,
                      );
                      Navigator.pop(context, expense);
                    }
                  },
                  child: const Text(
                    'Save Expense',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}