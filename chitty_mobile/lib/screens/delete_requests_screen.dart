import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';

class DeleteRequestsScreen extends StatefulWidget {
  const DeleteRequestsScreen({super.key});

  @override
  State<DeleteRequestsScreen> createState() => _DeleteRequestsScreenState();
}

class _DeleteRequestsScreenState extends State<DeleteRequestsScreen> {
  bool _isLoading = true;
  List<dynamic> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    final data = await AuthService.getDeleteRequests(status: 'Pending');
    if (!mounted) return;
    setState(() {
      _requests = data;
      _isLoading = false;
    });
  }

  Future<void> _approveRequest(int requestId, String customerName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Approve Delete Request"),
        content: Text("Are you sure you want to approve deleting '$customerName'? This will permanently delete the customer profile."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Approve & Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await AuthService.approveDeleteRequest(requestId);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delete request approved. Customer profile deleted.")),
      );
      _loadRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to approve delete request.")),
      );
    }
  }

  Future<void> _rejectRequest(int requestId) async {
    final success = await AuthService.rejectDeleteRequest(requestId);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delete request rejected.")),
      );
      _loadRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to reject delete request.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Customer Delete Requests"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_sweep, size: 64, color: textSecondary.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text("No pending delete requests", style: TextStyle(color: textSecondary, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _requests.length,
                  itemBuilder: (context, index) {
                    final req = _requests[index];
                    final customerName = req['customer_name'] ?? 'Unknown Customer';
                    final customerCode = req['customer_code'] ?? '';
                    final requestedBy = req['requested_by_name'] ?? 'Unknown Agent';
                    final dateStr = req['created_at']?.toString().split('T').first ?? '';

                    return Card(
                      color: cardBg,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    customerName,
                                    style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    customerCode,
                                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text("Requested by: $requestedBy", style: TextStyle(color: textSecondary, fontSize: 14)),
                            Text("Requested on: $dateStr", style: TextStyle(color: textSecondary, fontSize: 12)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _rejectRequest(req['id']),
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                  child: const Text("Reject"),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () => _approveRequest(req['id'], customerName),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text("Approve & Delete", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
