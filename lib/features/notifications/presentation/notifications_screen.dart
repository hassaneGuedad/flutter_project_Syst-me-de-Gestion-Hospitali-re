import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_localizations.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _selectedFilter = 'all';

  final List<_Notification> _notifications = [
    _Notification(id: '1', title: 'Nouveau patient enregistré', message: 'Jean Dupont a été ajouté au système', type: 'info', time: DateTime.now().subtract(const Duration(minutes: 5)), read: false),
    _Notification(id: '2', title: 'Rendez-vous confirmé', message: 'Marie Martin - Consultation cardiologie à 14h00', type: 'success', time: DateTime.now().subtract(const Duration(hours: 1)), read: false),
    _Notification(id: '3', title: 'Alerte stock médicaments', message: 'Stock faible pour Paracétamol 500mg', type: 'warning', time: DateTime.now().subtract(const Duration(hours: 3)), read: true),
    _Notification(id: '4', title: 'Urgence signalée', message: 'Patient critique en salle 204', type: 'error', time: DateTime.now().subtract(const Duration(hours: 5)), read: true),
    _Notification(id: '5', title: 'Rapport disponible', message: 'Le rapport mensuel de juin est prêt', type: 'info', time: DateTime.now().subtract(const Duration(days: 1)), read: true),
    _Notification(id: '6', title: 'Maintenance programmée', message: 'Mise à jour système prévue ce soir à 22h', type: 'warning', time: DateTime.now().subtract(const Duration(days: 1)), read: true),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final unreadCount = _notifications.where((n) => !n.read).length;

    final filteredNotifications = _selectedFilter == 'all'
        ? _notifications
        : _selectedFilter == 'unread'
            ? _notifications.where((n) => !n.read).toList()
            : _notifications.where((n) => n.type == _selectedFilter).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(ref.tr('notifications'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        if (unreadCount > 0) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                            child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(ref.tr('notification_list'), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: _markAllAsRead,
                  icon: const Icon(Icons.done_all, size: 18),
                  label: Text(ref.tr('mark_all_read')),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filters
            _buildFilters(isDark),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notifications list
                  Expanded(
                    flex: 2,
                    child: _buildNotificationsList(filteredNotifications, isDark),
                  ),
                  const SizedBox(width: 24),
                  // Stats
                  Expanded(
                    child: _buildStats(isDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(bool isDark) {
    final filters = {
      'all': ref.tr('all'),
      'unread': ref.tr('unread'),
      'info': ref.tr('info'),
      'success': ref.tr('success'),
      'warning': ref.tr('warning'),
      'error': ref.tr('error'),
    };
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.entries.map((filter) {
            final isSelected = _selectedFilter == filter.key;
            Color filterColor = Colors.blue;
            if (filter.key == 'success') filterColor = Colors.green;
            if (filter.key == 'warning') filterColor = Colors.orange;
            if (filter.key == 'error') filterColor = Colors.red;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _selectedFilter = filter.key),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? filterColor.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected ? Border.all(color: filterColor.withOpacity(0.5)) : null,
                    ),
                    child: Text(
                      filter.value,
                      style: TextStyle(
                        color: isSelected ? filterColor : Colors.grey[600],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<_Notification> notifications, bool isDark) {
    if (notifications.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.bellSlash, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text('Aucune notification', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildNotificationCard(notifications[index], isDark),
      ),
    );
  }

  Widget _buildNotificationCard(_Notification notification, bool isDark) {
    Color typeColor;
    IconData typeIcon;
    switch (notification.type) {
      case 'success':
        typeColor = Colors.green;
        typeIcon = FontAwesomeIcons.circleCheck;
        break;
      case 'warning':
        typeColor = Colors.orange;
        typeIcon = FontAwesomeIcons.triangleExclamation;
        break;
      case 'error':
        typeColor = Colors.red;
        typeIcon = FontAwesomeIcons.circleExclamation;
        break;
      default:
        typeColor = Colors.blue;
        typeIcon = FontAwesomeIcons.circleInfo;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.read
            ? (isDark ? const Color(0xFF0F172A) : Colors.grey[50])
            : typeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: notification.read ? null : Border.all(color: typeColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: FaIcon(typeIcon, color: typeColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!notification.read)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(color: typeColor, shape: BoxShape.circle),
                      ),
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.read ? FontWeight.w500 : FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                    ),
                    Text(_formatTime(notification.time), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notification.message, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey[400]),
            onSelected: (value) {
              if (value == 'read') _toggleRead(notification);
              if (value == 'delete') _deleteNotification(notification);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'read', child: Text(notification.read ? ref.tr('mark_unread') : ref.tr('mark_read'))),
              PopupMenuItem(value: 'delete', child: Text(ref.tr('delete'), style: const TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(bool isDark) {
    final total = _notifications.length;
    final unread = _notifications.where((n) => !n.read).length;
    final info = _notifications.where((n) => n.type == 'info').length;
    final success = _notifications.where((n) => n.type == 'success').length;
    final warning = _notifications.where((n) => n.type == 'warning').length;
    final error = _notifications.where((n) => n.type == 'error').length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ref.tr('summary'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 24),
          _buildStatItem(ref.tr('total'), '$total', FontAwesomeIcons.bell, Colors.grey, isDark),
          const SizedBox(height: 12),
          _buildStatItem(ref.tr('unread'), '$unread', FontAwesomeIcons.envelope, Colors.blue, isDark),
          const SizedBox(height: 12),
          _buildStatItem(ref.tr('info'), '$info', FontAwesomeIcons.circleInfo, Colors.blue, isDark),
          const SizedBox(height: 12),
          _buildStatItem(ref.tr('success'), '$success', FontAwesomeIcons.circleCheck, Colors.green, isDark),
          const SizedBox(height: 12),
          _buildStatItem(ref.tr('warning'), '$warning', FontAwesomeIcons.triangleExclamation, Colors.orange, isDark),
          const SizedBox(height: 12),
          _buildStatItem(ref.tr('errors'), '$error', FontAwesomeIcons.circleExclamation, Colors.red, isDark),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          FaIcon(icon, color: color, size: 16),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(color: isDark ? Colors.white : Colors.grey[700], fontSize: 14))),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    final lang = ref.watch(languageProvider);

    if (diff.inMinutes < 60) {
      if (lang == 'English') return '${diff.inMinutes} min ago';
      if (lang == 'العربية') return 'منذ ${diff.inMinutes} دقيقة';
      return 'Il y a ${diff.inMinutes} min';
    }
    if (diff.inHours < 24) {
      if (lang == 'English') return '${diff.inHours}h ago';
      if (lang == 'العربية') return 'منذ ${diff.inHours} ساعة';
      return 'Il y a ${diff.inHours} h';
    }
    if (diff.inDays == 1) return ref.tr('yesterday');
    return DateFormat('dd/MM').format(time);
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.read = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ref.tr('all_read')), backgroundColor: Colors.green),
    );
  }

  void _toggleRead(_Notification notification) {
    setState(() => notification.read = !notification.read);
  }

  void _deleteNotification(_Notification notification) {
    setState(() => _notifications.remove(notification));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ref.tr('notification_deleted')), backgroundColor: Colors.orange),
    );
  }
}

class _Notification {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime time;
  bool read;

  _Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.read,
  });
}
