import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<LogisticsTask> _tasks = [
    LogisticsTask(
      id: 1,
      vehiclePlate: '34 ABC 123',
      productCode: 'PRD001',
      productName: 'Laptop Dell XPS 13',
      targetQuantity: 50,
      completedQuantity: 12,
      taskType: TaskType.pickup,
      status: TaskStatus.inProgress,
    ),
    LogisticsTask(
      id: 2,
      vehiclePlate: '06 XYZ 456',
      productCode: 'PRD002',
      productName: 'Samsung Monitor 27"',
      targetQuantity: 25,
      completedQuantity: 25,
      taskType: TaskType.delivery,
      status: TaskStatus.completed,
    ),
    LogisticsTask(
      id: 3,
      vehiclePlate: '35 DEF 789',
      productCode: 'PRD003',
      productName: 'Wireless Mouse Logitech',
      targetQuantity: 100,
      completedQuantity: 0,
      taskType: TaskType.pickup,
      status: TaskStatus.pending,
    ),
    LogisticsTask(
      id: 4,
      vehiclePlate: '34 GHI 321',
      productCode: 'PRD004',
      productName: 'Mechanical Keyboard',
      targetQuantity: 30,
      completedQuantity: 15,
      taskType: TaskType.delivery,
      status: TaskStatus.inProgress,
    ),
  ];

  void _scanBarcode(LogisticsTask task) {
    // Burada normalde kamera açılacak ve barkod taranacak
    // Şimdilik simüle ediyoruz
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Barkod Tarayıcı'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 64,
              color: Color(0xFF3B82F6),
            ),
            const SizedBox(height: 16),
            Text(
              'Kamera açılacak ve barkod taranacak\n\n'
              'Taranacak Ürün: ${task.productName}\n'
              'Ürün Kodu: ${task.productCode}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateBarcodeScanned(task);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Simüle Et'),
          ),
        ],
      ),
    );
  }

  void _simulateBarcodeScanned(LogisticsTask task) {
    if (task.completedQuantity < task.targetQuantity) {
      setState(() {
        task.completedQuantity++;
        if (task.completedQuantity == task.targetQuantity) {
          task.status = TaskStatus.completed;
        } else if (task.completedQuantity > 0) {
          task.status = TaskStatus.inProgress;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Barkod tarandı! Kalan: ${task.targetQuantity - task.completedQuantity}',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Lojistik Görevler',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Çıkış Yap',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Özet kartları
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Toplam Görev',
                    _tasks.length.toString(),
                    Icons.assignment,
                    const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Tamamlanan',
                    _tasks
                        .where((t) => t.status == TaskStatus.completed)
                        .length
                        .toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Aktif Görevler',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),

            const SizedBox(height: 16),

            // Görev listesi
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return _buildTaskCard(task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildTaskCard(LogisticsTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık ve durum
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              _buildStatusChip(task.status),
            ],
          ),

          const SizedBox(height: 12),

          // Detaylar
          Row(
            children: [
              Icon(Icons.local_shipping, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                task.vehiclePlate,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.inventory_2, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                task.productCode,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // İlerleme çubuğu ve buton
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'İlerleme',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${task.completedQuantity}/${task.targetQuantity}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: task.completedQuantity / task.targetQuantity,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task.status == TaskStatus.completed
                            ? Colors.green
                            : const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Barkod tarama butonu
              if (task.status != TaskStatus.completed)
                ElevatedButton.icon(
                  onPressed: () => _scanBarcode(task),
                  icon: const Icon(Icons.qr_code_scanner, size: 18),
                  label: const Text('Tara'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
            ],
          ),

          // Görev tipi
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                task.taskType == TaskType.pickup
                    ? Icons.upload
                    : Icons.download,
                size: 16,
                color: task.taskType == TaskType.pickup
                    ? Colors.orange
                    : Colors.blue,
              ),
              const SizedBox(width: 6),
              Text(
                task.taskType == TaskType.pickup
                    ? 'Alma Görevi'
                    : 'Teslim Görevi',
                style: TextStyle(
                  fontSize: 12,
                  color: task.taskType == TaskType.pickup
                      ? Colors.orange
                      : Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color color;
    String text;

    switch (status) {
      case TaskStatus.pending:
        color = Colors.orange;
        text = 'Bekliyor';
        break;
      case TaskStatus.inProgress:
        color = const Color(0xFF3B82F6);
        text = 'Devam Ediyor';
        break;
      case TaskStatus.completed:
        color = Colors.green;
        text = 'Tamamlandı';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

// Model sınıfları
class LogisticsTask {
  final int id;
  final String vehiclePlate;
  final String productCode;
  final String productName;
  final int targetQuantity;
  int completedQuantity;
  final TaskType taskType;
  TaskStatus status;

  LogisticsTask({
    required this.id,
    required this.vehiclePlate,
    required this.productCode,
    required this.productName,
    required this.targetQuantity,
    required this.completedQuantity,
    required this.taskType,
    required this.status,
  });
}

enum TaskType { pickup, delivery }

enum TaskStatus { pending, inProgress, completed }
