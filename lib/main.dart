import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fl_chart/fl_chart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ocrnpvpfxjddvwdmihli.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9jcm5wdnBmeGpkZHZ3ZG1paGxpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk0NTY3MzMsImV4cCI6MjA5NTAzMjczM30.SERMtUNq_Gkn0VR-Rk4vHzhknpcZKC74yrPQ_f9hv_0',
  );

  runApp(const CoworkingApp());
}
bool isDarkMode = false;

class CoworkingApp extends StatefulWidget {
  const CoworkingApp({super.key});

  @override
  State<CoworkingApp> createState() => _CoworkingAppState();
}

class _CoworkingAppState extends State<CoworkingApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Co-Working Rezervasyon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
  primarySwatch: Colors.indigo,
  brightness: isDarkMode ? Brightness.dark : Brightness.light,
  useMaterial3: false,
),
home: LoginPage(
  onThemeChanged: () {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  },
),
    );
  }
}

List<Map<String, String>> reservations = [];
List<Map<String, String>> favoriteWorkspaces = [];
final supabase = Supabase.instance.client;
Future<void> addLog(String action) async {
  final userEmail = supabase.auth.currentUser?.email;

  await supabase.from('logs').insert({
    'action': action,
    'user_email': userEmail,
  });
}
Map<String, String> currentCustomer = {
  'name': '',
  'phone': '',
  'email': '',
};

final List<Map<String, String>> workspaces = [
  {
    'name': 'Masa A1',
    'type': 'Bireysel Çalışma Masası',
    'price': '50 TL / saat',
    'capacity': '1 kişi',
    'owner': 'WorkPlus Ortak Ofis',
    'status': 'Aktif',
  },
  {
    'name': 'Masa A2',
    'type': 'Bireysel Çalışma Masası',
    'price': '50 TL / saat',
    'capacity': '1 kişi',
    'owner': 'WorkPlus Ortak Ofis',
    'status': 'Aktif',
  },
  {
    'name': 'Toplantı Odası B1',
    'type': 'Toplantı Odası',
    'price': '200 TL / saat',
    'capacity': '6 kişi',
    'owner': 'Merkez Co-Working',
    'status': 'Aktif',
  },
  {
    'name': 'Özel Ofis C1',
    'type': 'Özel Ofis',
    'price': '180 TL / saat',
    'capacity': '2 kişi',
    'owner': 'Merkez Co-Working',
    'status': 'Aktif',
  },
];

class LoginPage extends StatefulWidget {
  final VoidCallback onThemeChanged;

  const LoginPage({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

final passwordController = TextEditingController();
  String selectedRole = 'Müşteri';

  
    
   
    Future<void> login() async {
      print('LOGIN BUTONUNA BASILDI');
  try {
    final response = await supabase.auth.signInWithPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (response.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giriş başarılı'),
          
        ),
      );
      await addLog('Kullanıcı giriş yaptı');
      if (selectedRole == 'Admin') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AdminPage(),
    ),
  );
} else if (selectedRole == 'Müşteri') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CustomerPage(),
    ),
  );
} else {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const OwnerPage(),
    ),
  );
}
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hata: $e'),
      ),
    );
  }
}
  
Future<void> register() async {
  try {
    final response = await supabase.auth.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (response.user != null) {
      await supabase.from('users').insert({
        'email': emailController.text.trim(),
        'full_name': emailController.text.trim(),
        'role': selectedRole,
      });
      await addLog('Yeni kullanıcı kaydı oluşturuldu');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kayıt başarılı. Şimdi giriş yapabilirsiniz.'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kayıt hatası: $e')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
   return Scaffold(
  backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.indigo.shade50,
  appBar: AppBar(
    title: const Text('Giriş'),
    actions: [
      IconButton(
        icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
        onPressed: widget.onThemeChanged,
      ),
    ],
  ),
  body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 380,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.business_center,
                      size: 70, color: Colors.indigo),
                  const SizedBox(height: 12),
                  const Text(
                    'Co-Working Rezervasyon Sistemi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
  controller: emailController,
  decoration: const InputDecoration(
    labelText: 'E-posta',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.email),
  ),
),
const SizedBox(height: 12),
TextField(
  controller: passwordController,
  obscureText: true,
  decoration: const InputDecoration(
    labelText: 'Şifre',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.lock),
  ),
),
const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Kullanıcı Rolü',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Müşteri', child: Text('Müşteri')),
                      DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                      DropdownMenuItem(
                        value: 'Kiralayan',
                        child: Text('Kiralayan / İşletme'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: login,
                      icon: const Icon(Icons.login),
                      label: const Text('Giriş Yap'),
                    ),
                    
                  ),
                const SizedBox(height: 8),
OutlinedButton.icon(
  onPressed: register,
  icon: const Icon(Icons.person_add),
  label: const Text('Kayıt Ol'),
),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final nameController = TextEditingController(text: currentCustomer['name']);
  final phoneController = TextEditingController(text: currentCustomer['phone']);
  final emailController = TextEditingController(text: currentCustomer['email']);

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveProfile() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen profil bilgilerini doldurun')),
      );
      return;
    }

    setState(() {
      currentCustomer = {
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
      };
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil bilgileri kaydedildi')),
    );
  }

  void goToReservation() {
    if (currentCustomer['name']!.isEmpty ||
        currentCustomer['phone']!.isEmpty ||
        currentCustomer['email']!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rezervasyon için önce profil bilgilerini kaydedin')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkspaceListPage(
          title: 'Müşteri Paneli - Alan Rezervasyonu',
          showReserveButton: true,
        ),
      ),
    );
  }

  void goToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CustomerHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Müşteri Paneli'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Müşteri Profil Bilgileri'),
              subtitle: Text('Rezervasyon yapmadan önce bilgilerinizi kaydedin.'),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Ad Soyad',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Telefon',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'E-posta',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: saveProfile,
            icon: const Icon(Icons.save),
            label: const Text('Profil Bilgilerini Kaydet'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: goToReservation,
            icon: const Icon(Icons.business),
            label: const Text('Çalışma Alanlarını Gör'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: goToHistory,
            icon: const Icon(Icons.history),
            label: const Text('Rezervasyon Geçmişim'),
          ),
          const SizedBox(height: 8),
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FavoriteWorkspacesPage(),
      ),
    );
  },
  icon: const Icon(Icons.favorite),
  label: const Text('Favori Alanlarım'),
),
        ],
      ),
    );
  }
}

class OwnerPage extends StatelessWidget {
  const OwnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiralayan Paneli'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add_business),
            label: const Text('Yeni Çalışma Alanı Ekle'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddWorkspacePage()),
              );
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.business),
            label: const Text('Alanlarımı Gör'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkspaceListPage(
                    title: 'Kiralayan Paneli - Alanlarım',
                    showReserveButton: false,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
  icon: const Icon(Icons.receipt_long),
  label: const Text('Bana Ait Rezervasyonları Gör'),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OwnerReservationPage()),
    );
  },
),
        ],
      ),
    );
  }
}
class AddWorkspacePage extends StatefulWidget {
  const AddWorkspacePage({super.key});

  @override
  State<AddWorkspacePage> createState() => _AddWorkspacePageState();
}

class _AddWorkspacePageState extends State<AddWorkspacePage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final capacityController = TextEditingController();
  final ownerController = TextEditingController();

  String selectedType = 'Bireysel Çalışma Masası';

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    capacityController.dispose();
    ownerController.dispose();
    super.dispose();
  }

  Future<void> addWorkspace() async {
    print('WORKSPACE EKLEME ÇALIŞTI');

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        capacityController.text.isEmpty ||
        ownerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    workspaces.add({
      'name': nameController.text,
      'type': selectedType,
      'price': '${priceController.text} TL / saat',
      'capacity': '${capacityController.text} kişi',
      'owner': ownerController.text,
      'status': 'Aktif',
    });
    await supabase.from('workspaces').insert({
  'name': nameController.text,
  'type': selectedType,
  'capacity': int.tryParse(capacityController.text) ?? 0,
  'price': int.tryParse(priceController.text) ?? 0,
  'owner_name': ownerController.text,
  'status': 'Aktif',
});
print('SUPABASE WORKSPACE KAYDI BAŞARILI');
    addLog('Yeni çalışma alanı eklendi');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Çalışma alanı başarıyla eklendi')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Alan Ekle'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Alan Adı örn: Masa A5',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedType,
            decoration: const InputDecoration(
              labelText: 'Alan Türü',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Bireysel Çalışma Masası',
                child: Text('Bireysel Çalışma Masası'),
              ),
              DropdownMenuItem(
                value: 'Toplantı Odası',
                child: Text('Toplantı Odası'),
              ),
              DropdownMenuItem(
                value: 'Özel Ofis',
                child: Text('Özel Ofis'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedType = value!;
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Saatlik Ücret örn: 150',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: capacityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Kapasite örn: 4',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ownerController,
            decoration: const InputDecoration(
              labelText: 'Kiralayan / İşletme Adı',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: addWorkspace,
            icon: const Icon(Icons.save),
            label: const Text('Alanı Kaydet'),
          ),
        ],
      ),
    );
  }
}



  int get totalWorkspaces => workspaces.length;
  
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  int get totalWorkspaces => workspaces.length;

  int get totalReservations => reservations.length;

  int get totalActiveWorkspaces {
    return workspaces.where((w) => w['status'] == 'Aktif').length;
  }

  int get activeReservations {
    return reservations.where((r) => r['status'] == 'Aktif').length;
  }

  int get cancelledReservations {
    return reservations.where((r) => r['status'] == 'İptal Edildi').length;
  }

  int get totalCustomers {
    return reservations.map((r) => r['customerName']).toSet().length;
  }

  int get totalOwners {
    return workspaces.map((w) => w['owner']).toSet().length;
  }

  int get totalIncome {
    int total = 0;

    for (var reservation in reservations) {
      if (reservation['status'] == 'Aktif') {
        String priceText = reservation['totalPrice'] ?? '0';
        priceText = priceText.replaceAll(' TL / saat', '');
        total += int.tryParse(priceText) ?? 0;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DashboardCard(
            title: 'Toplam Çalışma Alanı',
            value: totalWorkspaces.toString(),
            icon: Icons.meeting_room,
          ),
          DashboardCard(
            title: 'Aktif Alan Sayısı',
            value: totalActiveWorkspaces.toString(),
            icon: Icons.check_circle,
          ),
          DashboardCard(
            title: 'Toplam Rezervasyon',
            value: totalReservations.toString(),
            icon: Icons.calendar_month,
          ),
          DashboardCard(
            title: 'Aktif Rezervasyon',
            value: activeReservations.toString(),
            icon: Icons.event_available,
          ),
          DashboardCard(
            title: 'İptal Edilen Rezervasyon',
            value: cancelledReservations.toString(),
            icon: Icons.cancel,
          ),
          DashboardCard(
            title: 'Müşteri Sayısı',
            value: totalCustomers.toString(),
            icon: Icons.people,
          ),
          DashboardCard(
            title: 'Kiralayan Sayısı',
            value: totalOwners.toString(),
            icon: Icons.store,
          ),
          DashboardCard(
            title: 'Toplam Gelir',
            value: '$totalIncome TL',
            icon: Icons.attach_money,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.business),
            label: const Text('Tüm Çalışma Alanlarını Gör'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkspaceListPage(
                    title: 'Admin - Tüm Alanlar',
                    showReserveButton: false,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

        ElevatedButton.icon(
  icon: const Icon(Icons.receipt_long),
  label: const Text('Rezervasyonları Gör'),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReservationListPage()),
    );
  },
),

const SizedBox(height: 8),

ElevatedButton.icon(
  icon: const Icon(Icons.bar_chart),
  label: const Text('İstatistikleri Gör'),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StatisticsPage(),
      ),
    );
  },
),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_search),
            label: const Text('Müşteri Listesini Gör'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerListPage()),
              );
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.store),
            label: const Text('Kiralayan Listesini Gör'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OwnerListPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo, size: 36),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class WorkspaceListPage extends StatefulWidget {
  final String title;
  final bool showReserveButton;

  const WorkspaceListPage({
    super.key,
    required this.title,
    required this.showReserveButton,
  });

  @override
  State<WorkspaceListPage> createState() => _WorkspaceListPageState();
}

class _WorkspaceListPageState extends State<WorkspaceListPage> {
  String selectedFilter = 'Tümü';
  final searchController = TextEditingController();

 List<Map<String, String>> get filteredWorkspaces {
  return workspaces.where((workspace) {
    final matchesFilter = selectedFilter == 'Tümü' ||
        workspace['type'] == selectedFilter;

    final searchText = searchController.text.toLowerCase();

    final matchesSearch =
        workspace['name']!.toLowerCase().contains(searchText) ||
        workspace['type']!.toLowerCase().contains(searchText) ||
        workspace['owner']!.toLowerCase().contains(searchText);

    return matchesFilter && matchesSearch;
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.showReserveButton)
            IconButton(
              icon: const Icon(Icons.receipt_long),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReservationListPage()),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
  child: TextField(
    controller: searchController,
    decoration: const InputDecoration(
      labelText: 'Alan Ara',
      hintText: 'Masa, Ofis, İşletme...',
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.search),
    ),
    onChanged: (value) {
      setState(() {});
    },
  ),
),
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: selectedFilter,
              decoration: const InputDecoration(
                labelText: 'Alan Türüne Göre Filtrele',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Tümü', child: Text('Tümü')),
                DropdownMenuItem(
                  value: 'Bireysel Çalışma Masası',
                  child: Text('Bireysel Çalışma Masası'),
                ),
                DropdownMenuItem(
                  value: 'Toplantı Odası',
                  child: Text('Toplantı Odası'),
                ),
                DropdownMenuItem(
                  value: 'Özel Ofis',
                  child: Text('Özel Ofis'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredWorkspaces.length,
              itemBuilder: (context, index) {
                final workspace = filteredWorkspaces[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.business, color: Colors.indigo),
                    title: Text(workspace['name']!),
                    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => WorkspaceDetailPage(
        workspace: workspace,
        showReserveButton: widget.showReserveButton,
      ),
    ),
  );
},
                    subtitle: Text(
                      '${workspace['type']}\n'
                      'Kapasite: ${workspace['capacity']}\n'
                      'Ücret: ${workspace['price']}\n'
                      'Kiralayan: ${workspace['owner']}\n'
                      'Durum: ${workspace['status']}',
                    ),
                   trailing: widget.showReserveButton
    ? ElevatedButton(
        onPressed: workspace['status'] == 'Aktif'
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ReservationPage(workspace: workspace),
                  ),
                );
              }
            : null,
        child: const Text('Rezerve Et'),
      )
    : IconButton(
        icon: Icon(
          workspace['status'] == 'Aktif'
              ? Icons.toggle_on
              : Icons.toggle_off,
          color: workspace['status'] == 'Aktif'
              ? Colors.green
              : Colors.grey,
          size: 36,
        ),
        onPressed: () {
          setState(() {
            workspace['status'] =
                workspace['status'] == 'Aktif' ? 'Pasif' : 'Aktif';
          });
        },
      ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationPage extends StatefulWidget {
  final Map<String, String> workspace;

  const ReservationPage({
    super.key,
    required this.workspace,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
 final nameController = TextEditingController(text: currentCustomer['name']);
final phoneController = TextEditingController(text: currentCustomer['phone']);
  final dateController = TextEditingController();
  final noteController = TextEditingController();

String selectedStartTime = '09:00';
String selectedEndTime = '10:00';
String selectedPaymentMethod = 'Kart';

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    dateController.dispose();
    noteController.dispose();
   
    super.dispose();
  }
  int timeToNumber(String time) {
  return int.parse(time.replaceAll(':00', ''));
}
Future<void> selectDate() async {
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2030),
  );

  if (selectedDate != null) {
    setState(() {
      dateController.text =
          '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}';
    });
  }
}
  Future<void> saveReservation() async {
    if (nameController.text.isEmpty ||
    phoneController.text.isEmpty ||
    dateController.text.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
  );
  return;
}

final selectedStart = timeToNumber(selectedStartTime);
final selectedEnd = timeToNumber(selectedEndTime);

if (selectedEnd <= selectedStart) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Bitiş saati başlangıç saatinden büyük olmalıdır'),
    ),
  );
  return;
}

final hasConflict = reservations.any((reservation) {
  if (reservation['workspaceName'] != widget.workspace['name'] ||
      reservation['date'] != dateController.text ||
      reservation['status'] != 'Aktif') {
    return false;
  }

  final existingStart = timeToNumber(reservation['start']!);
  final existingEnd = timeToNumber(reservation['end']!);

  return selectedStart < existingEnd && selectedEnd > existingStart;
});

if (hasConflict) {
  showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text('Rezervasyon Çakışması'),
      content: const Text(
        'Bu alan seçilen tarih ve saat aralığında zaten rezerve edilmiş.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Tamam'),
        ),
      ],
    );
  },
);
  return;
}

    reservations.add({
      'customerName': nameController.text,
      'phone': phoneController.text,
      'email': currentCustomer['email']!,
      'workspaceName': widget.workspace['name']!,
      'workspaceType': widget.workspace['type']!,
      'owner': widget.workspace['owner']!,
      'date': dateController.text,
      'start': selectedStartTime,
'end': selectedEndTime,
'note': noteController.text.isEmpty ? 'Not yok' : noteController.text,
      'status': 'Aktif',
      'paymentStatus': 'Ödendi',
      'paymentMethod': selectedPaymentMethod,
'totalPrice': widget.workspace['price']!,
    });
    await supabase.from('reservations').insert({
  'customer_name': nameController.text,
  'customer_phone': phoneController.text,
  'workspace_id': widget.workspace['id'],
  'reservation_date': dateController.text,
  'start_time': selectedStartTime,
  'end_time': selectedEndTime,
  'payment_method': selectedPaymentMethod,
  'payment_status': 'Ödendi',
  'status': 'Aktif',
  'note': noteController.text,
});
    addLog('Yeni rezervasyon oluşturuldu');

   showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text('Rezervasyon Oluşturuldu'),
      content: Text(
        'Alan: ${widget.workspace['name']}\n'
        'Tarih: ${dateController.text}\n'
        'Saat: $selectedStartTime - $selectedEndTime\n'
        'Ödeme: $selectedPaymentMethod',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ReservationListPage(),
              ),
            );
          },
          child: const Text('Tamam'),
        ),
      ],
    );
  },
);
  }

  @override
  Widget build(BuildContext context) {
    final workspace = widget.workspace;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezervasyon Oluştur'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.meeting_room),
              title: Text(workspace['name']!),
              subtitle: Text(
                '${workspace['type']} - ${workspace['price']}\n'
                'Kiralayan: ${workspace['owner']}',
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Müşteri Ad Soyad',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Telefon',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
         TextField(
  controller: dateController,
  readOnly: true,
  onTap: selectDate,
  decoration: const InputDecoration(
    labelText: 'Tarih Seç',
    border: OutlineInputBorder(),
    suffixIcon: Icon(Icons.calendar_month),
  ),
),
const SizedBox(height: 12),
DropdownButtonFormField<String>(
  value: selectedStartTime,
  decoration: const InputDecoration(
    labelText: 'Başlangıç Saati',
    border: OutlineInputBorder(),
  ),
  items: const [
    DropdownMenuItem(value: '09:00', child: Text('09:00')),
    DropdownMenuItem(value: '10:00', child: Text('10:00')),
    DropdownMenuItem(value: '11:00', child: Text('11:00')),
    DropdownMenuItem(value: '12:00', child: Text('12:00')),
    DropdownMenuItem(value: '13:00', child: Text('13:00')),
    DropdownMenuItem(value: '14:00', child: Text('14:00')),
    DropdownMenuItem(value: '15:00', child: Text('15:00')),
    DropdownMenuItem(value: '16:00', child: Text('16:00')),
    DropdownMenuItem(value: '17:00', child: Text('17:00')),
  ],
  onChanged: (value) {
    setState(() {
      selectedStartTime = value!;
    });
  },
),
const SizedBox(height: 12),
DropdownButtonFormField<String>(
  value: selectedEndTime,
  decoration: const InputDecoration(
    labelText: 'Bitiş Saati',
    border: OutlineInputBorder(),
  ),
  items: const [
    DropdownMenuItem(value: '10:00', child: Text('10:00')),
    DropdownMenuItem(value: '11:00', child: Text('11:00')),
    DropdownMenuItem(value: '12:00', child: Text('12:00')),
    DropdownMenuItem(value: '13:00', child: Text('13:00')),
    DropdownMenuItem(value: '14:00', child: Text('14:00')),
    DropdownMenuItem(value: '15:00', child: Text('15:00')),
    DropdownMenuItem(value: '16:00', child: Text('16:00')),
    DropdownMenuItem(value: '17:00', child: Text('17:00')),
    DropdownMenuItem(value: '18:00', child: Text('18:00')),
  ],
  onChanged: (value) {
    setState(() {
      selectedEndTime = value!;
    });
  },
),
const SizedBox(height: 12),
TextField(
  controller: noteController,
  maxLines: 3,
  minLines: 2,
  decoration: const InputDecoration(
    labelText: 'Rezervasyon Notu',
    hintText: 'Örn: Sessiz alan tercihi',
    border: OutlineInputBorder(),
    alignLabelWithHint: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 16,
    ),
  ),
),
const SizedBox(height: 20),
DropdownButtonFormField<String>(
  value: selectedPaymentMethod,
  decoration: const InputDecoration(
    labelText: 'Ödeme Yöntemi',
    border: OutlineInputBorder(),
  ),
  items: const [
    DropdownMenuItem(value: 'Kart', child: Text('Kart')),
    DropdownMenuItem(value: 'Nakit', child: Text('Nakit')),
    DropdownMenuItem(value: 'Havale/EFT', child: Text('Havale/EFT')),
  ],
  onChanged: (value) {
    setState(() {
      selectedPaymentMethod = value!;
    });
  },
),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: saveReservation,
            icon: const Icon(Icons.save),
            label: const Text('Rezervasyonu Kaydet'),
          ),
        ],
      ),
    );
  }
}

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  void cancelReservation(int index) {
    setState(() {
      reservations[index]['status'] = 'İptal Edildi';
      reservations[index]['paymentStatus'] = 'İade Edilecek';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rezervasyon iptal edildi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezervasyon Listesi'),
      ),
      body: reservations.isEmpty
          ? const Center(
              child: Text('Henüz rezervasyon bulunmuyor'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.event_available),
                    title: Text(reservation['workspaceName']!),
                    subtitle: Text(
                      'Müşteri: ${reservation['customerName']}\n'
  'Telefon: ${reservation['phone']}\n'
  'Kiralayan: ${reservation['owner']}\n'
  'Tarih: ${reservation['date']}\n'
  'Saat: ${reservation['start']} - ${reservation['end']}\n'
  'Durum: ${reservation['status']}\n'
  'Ödeme: ${reservation['paymentStatus']}\n'
'Ödeme Yöntemi: ${reservation['paymentMethod']}\n'
'Ücret: ${reservation['totalPrice']}',
                    ),
                    trailing: reservation['status'] == 'Aktif'
                        ? IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => cancelReservation(index),
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customerNames = reservations
        .map((r) => r['customerName']!)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Müşteri Listesi'),
      ),
      body: customerNames.isEmpty
          ? const Center(
              child: Text('Henüz müşteri kaydı bulunmuyor'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: customerNames.length,
              itemBuilder: (context, index) {
                final name = customerNames[index];

                final customerReservations = reservations
                    .where((r) => r['customerName'] == name)
                    .length;

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(name),
                    subtitle: Text(
                      'Toplam rezervasyon: $customerReservations',
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class OwnerListPage extends StatelessWidget {
  const OwnerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerNames = workspaces
        .map((w) => w['owner']!)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiralayan / İşletme Listesi'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: ownerNames.length,
        itemBuilder: (context, index) {
          final ownerName = ownerNames[index];

          final ownerWorkspaceCount = workspaces
              .where((w) => w['owner'] == ownerName)
              .length;

          final ownerReservationCount = reservations
              .where((r) => r['owner'] == ownerName)
              .length;

          return Card(
            child: ListTile(
              leading: const Icon(Icons.store),
              title: Text(ownerName),
              subtitle: Text(
                'Alan sayısı: $ownerWorkspaceCount\n'
                'Rezervasyon sayısı: $ownerReservationCount',
              ),
            ),
          );
        },
      ),
    );
  }
}
class CustomerHistoryPage extends StatefulWidget {
  const CustomerHistoryPage({super.key});

  @override
  State<CustomerHistoryPage> createState() => _CustomerHistoryPageState();
}

class _CustomerHistoryPageState extends State<CustomerHistoryPage> {

  @override
  Widget build(BuildContext context) {
    final customerReservations = reservations.where((reservation) {
      return reservation['email'] == currentCustomer['email'];
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezervasyon Geçmişim'),
      ),
      body: customerReservations.isEmpty
          ? const Center(
              child: Text('Henüz size ait rezervasyon bulunmuyor'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: customerReservations.length,
              itemBuilder: (context, index) {
                final reservation = customerReservations[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(reservation['workspaceName']!),
                    subtitle: Text(
                      'Tarih: ${reservation['date']}\n'
                      'Saat: ${reservation['start']} - ${reservation['end']}\n'
                      'Durum: ${reservation['status']}\n'
                      'Ödeme: ${reservation['paymentStatus']}\n'
                      'Ödeme Yöntemi: ${reservation['paymentMethod']}\n'
                      'Ücret: ${reservation['totalPrice']}',
                    ),
                    trailing: reservation['status'] == 'Aktif'
    ? IconButton(
        icon: const Icon(Icons.cancel, color: Colors.red),
        onPressed: () {
          setState(() {
            reservation['status'] = 'İptal Edildi';
            reservation['paymentStatus'] = 'İade Edilecek';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rezervasyon iptal edildi'),
            ),
          );
        },
      )
    : null,
                  ),
                );
              },
            ),
    );
  }
}

class OwnerReservationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ownerNames = workspaces
        .map((w) => w['owner']!)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiralayan Rezervasyonları'),
      ),
      body: ownerNames.isEmpty
          ? const Center(
              child: Text('Kiralayan bulunmuyor'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: ownerNames.length,
              itemBuilder: (context, ownerIndex) {
                final ownerName = ownerNames[ownerIndex];

                final ownerReservations =
                    reservations.where((reservation) {
                  return reservation['owner'] == ownerName;
                }).toList();

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: const Icon(Icons.store),
                    title: Text(ownerName),
                    subtitle: Text(
                      'Rezervasyon sayısı: ${ownerReservations.length}',
                    ),
                    children: ownerReservations.isEmpty
                        ? [
                            const ListTile(
                              title: Text(
                                'Bu işletmeye ait rezervasyon yok',
                              ),
                            ),
                          ]
                        : ownerReservations.map((reservation) {
                            return ListTile(
                              leading: const Icon(Icons.event),
                              title: Text(
                                reservation['workspaceName']!,
                              ),
                              subtitle: Text(
                                'Müşteri: ${reservation['customerName']}\n'
                                'Telefon: ${reservation['phone']}\n'
                                'Tarih: ${reservation['date']}\n'
                                'Saat: ${reservation['start']} - ${reservation['end']}\n'
                                'Durum: ${reservation['status']}',
                              ),
                            );
                          }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
class WorkspaceDetailPage extends StatelessWidget {
  final Map<String, String> workspace;
  final bool showReserveButton;

  const WorkspaceDetailPage({
    super.key,
    required this.workspace,
    required this.showReserveButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workspace['name']!),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.business, size: 40),
              title: Text(
                workspace['name']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(workspace['type']!),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Kapasite'),
              subtitle: Text(workspace['capacity']!),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Saatlik Ücret'),
              subtitle: Text(workspace['price']!),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Kiralayan / İşletme'),
              subtitle: Text(workspace['owner']!),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                workspace['status'] == 'Aktif'
                    ? Icons.check_circle
                    : Icons.cancel,
              ),
              title: const Text('Durum'),
              subtitle: Text(workspace['status']!),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
  onPressed: () async {
    final alreadyFavorite = favoriteWorkspaces.contains(workspace);

    if (!alreadyFavorite) {
      favoriteWorkspaces.add(workspace);
      await supabase.from('favorites').insert({
  'workspace_id': workspace['id'],
  'user_email': supabase.auth.currentUser?.email,
});
      addLog('Çalışma alanı favorilere eklendi');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alan favorilere eklendi'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu alan zaten favorilerde'),
        ),
      );
    }
  },
  icon: const Icon(Icons.favorite),
  label: const Text('Favorilere Ekle'),
),
const SizedBox(height: 12),

      
          ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditWorkspacePage(workspace: workspace),
      ),
    );
  },
  icon: const Icon(Icons.edit),
  label: const Text('Alanı Düzenle'),
),
const SizedBox(height: 12),
ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
  ),
  onPressed: () {
    workspaces.remove(workspace);
    addLog('Çalışma alanı silindi');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Çalışma alanı silindi'),
      ),
    );

    Navigator.pop(context);
  },
  icon: const Icon(Icons.delete),
  label: const Text('Alanı Sil'),
),
const SizedBox(height: 12),
          if (showReserveButton)
            ElevatedButton.icon(
              onPressed: workspace['status'] == 'Aktif'
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ReservationPage(workspace: workspace),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.calendar_month),
              label: const Text('Bu Alanı Rezerve Et'),
            ),
        ],
      ),
    );
  }
}
class EditWorkspacePage extends StatefulWidget {
  final Map<String, String> workspace;

  const EditWorkspacePage({
    super.key,
    required this.workspace,
  });

  @override
  State<EditWorkspacePage> createState() => _EditWorkspacePageState();
}

class _EditWorkspacePageState extends State<EditWorkspacePage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController capacityController;
  late TextEditingController ownerController;

  late String selectedStatus;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.workspace['name'],
    );

    priceController = TextEditingController(
      text: widget.workspace['price']!
          .replaceAll(' TL / saat', ''),
    );

    capacityController = TextEditingController(
      text: widget.workspace['capacity']!
          .replaceAll(' kişi', ''),
    );

    ownerController = TextEditingController(
      text: widget.workspace['owner'],
    );

    selectedStatus = widget.workspace['status']!;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    capacityController.dispose();
    ownerController.dispose();
    super.dispose();
  }

  void saveChanges() {
    widget.workspace['name'] = nameController.text;

    widget.workspace['price'] =
        '${priceController.text} TL / saat';

    widget.workspace['capacity'] =
        '${capacityController.text} kişi';

    widget.workspace['owner'] = ownerController.text;

    widget.workspace['status'] = selectedStatus;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alan bilgileri güncellendi'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alan Düzenle'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Alan Adı',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Saatlik Ücret',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: capacityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Kapasite',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ownerController,
            decoration: const InputDecoration(
              labelText: 'Kiralayan',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Durum',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Aktif',
                child: Text('Aktif'),
              ),
              DropdownMenuItem(
                value: 'Pasif',
                child: Text('Pasif'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedStatus = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: saveChanges,
            icon: const Icon(Icons.save),
            label: const Text('Değişiklikleri Kaydet'),
          ),
        ],
      ),
    );
  }
}
class FavoriteWorkspacesPage extends StatelessWidget {
  const FavoriteWorkspacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori Alanlarım'),
      ),
      body: favoriteWorkspaces.isEmpty
          ? const Center(
              child: Text('Henüz favori alan eklenmedi'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favoriteWorkspaces.length,
              itemBuilder: (context, index) {
                final workspace = favoriteWorkspaces[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.favorite),
                    title: Text(workspace['name']!),
                    subtitle: Text(
                      '${workspace['type']}\n'
                      'Kapasite: ${workspace['capacity']}\n'
                      'Ücret: ${workspace['price']}\n'
                      'Kiralayan: ${workspace['owner']}\n'
                      'Durum: ${workspace['status']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        favoriteWorkspaces.remove(workspace);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Favorilerden kaldırıldı'),
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoriteWorkspacesPage(),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkspaceDetailPage(
                            workspace: workspace,
                            showReserveButton: true,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeReservations = reservations
        .where((r) => r['status'] == 'Aktif')
        .length;

    final cancelledReservations = reservations
        .where((r) => r['status'] == 'İptal Edildi')
        .length;

    final favoriteCount = favoriteWorkspaces.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistikler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Sistem Kullanım İstatistikleri',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: reservations.length.toDouble(),
                      title: 'Toplam',
                      radius: 90,
                    ),
                    PieChartSectionData(
                      value: activeReservations.toDouble(),
                      title: 'Aktif',
                      radius: 90,
                    ),
                    PieChartSectionData(
                      value: cancelledReservations.toDouble(),
                      title: 'İptal',
                      radius: 90,
                    ),
                    PieChartSectionData(
                      value: favoriteCount.toDouble(),
                      title: 'Favori',
                      radius: 90,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Toplam Rezervasyon'),
                trailing: Text('${reservations.length}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Aktif Rezervasyon'),
                trailing: Text('$activeReservations'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('İptal Edilen'),
                trailing: Text('$cancelledReservations'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favori Alanlar'),
                trailing: Text('$favoriteCount'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}