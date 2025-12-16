import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/localization/app_localizations.dart';
import 'settings_provider.dart';

class ParametresScreen extends ConsumerWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(ref.tr('settings'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(ref.tr('settings_title'), style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 32),

            // Profil Section
            _buildSection(
              ref.tr('profile'),
              FontAwesomeIcons.user,
              Colors.blue,
              isDark,
              [
                _buildProfileCard(context, ref, isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Apparence Section
            _buildSection(
              ref.tr('preferences'),
              FontAwesomeIcons.palette,
              Colors.purple,
              isDark,
              [
                _buildSwitchTile(
                  ref.tr('dark_mode'), 
                  ref.tr('enable_dark_theme'), 
                  themeMode == ThemeMode.dark,
                  (value) {
                    ref.read(themeNotifierProvider.notifier).setThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light
                    );
                    _showSuccess(context, ref.tr('save_success'));
                  },
                  isDark,
                ),
                _buildDropdownTile(
                  ref.tr('language'), 
                  ref.tr('choose_language'), 
                  ref.watch(languageProvider), 
                  ['Français', 'English', 'العربية'], 
                  (value) {
                    ref.read(languageProvider.notifier).setLanguage(value!);
                    ref.read(settingsNotifierProvider.notifier).setLanguage(value);
                    _showSuccess(context, ref.tr('language_changed'));
                  }, 
                  isDark
                ),
                _buildDropdownTile(
                  ref.tr('date_format'), 
                  ref.tr('choose_date_format'), 
                  settings.dateFormat, 
                  ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'], 
                  (value) {
                    ref.read(settingsNotifierProvider.notifier).setDateFormat(value!);
                    _showSuccess(context, ref.tr('save_success'));
                  }, 
                  isDark
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Notifications Section
            _buildSection(
              ref.tr('notifications'),
              FontAwesomeIcons.bell,
              Colors.orange,
              isDark,
              [
                _buildSwitchTile(
                  ref.tr('notifications_enabled'), 
                  ref.tr('receive_push_notifications'), 
                  settings.pushNotifications, 
                  (value) {
                    ref.read(settingsNotifierProvider.notifier).setPushNotifications(value);
                    _showSuccess(context, value ? ref.tr('push_enabled') : ref.tr('push_disabled'));
                  }, 
                  isDark
                ),
                _buildSwitchTile(
                  ref.tr('email_notifications'), 
                  ref.tr('receive_email_notifications'), 
                  settings.emailNotifications, 
                  (value) {
                    ref.read(settingsNotifierProvider.notifier).setEmailNotifications(value);
                    _showSuccess(context, value ? ref.tr('email_enabled') : ref.tr('email_disabled'));
                  }, 
                  isDark
                ),
                _buildSwitchTile(
                  ref.tr('sms_notifications'), 
                  ref.tr('receive_sms_notifications'), 
                  settings.smsNotifications, 
                  (value) {
                    ref.read(settingsNotifierProvider.notifier).setSmsNotifications(value);
                    _showSuccess(context, value ? ref.tr('sms_enabled') : ref.tr('sms_disabled'));
                  }, 
                  isDark
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sécurité Section
            _buildSection(
              ref.tr('security'),
              FontAwesomeIcons.shield,
              Colors.green,
              isDark,
              [
                _buildActionTile(ref.tr('change_password'), ref.tr('modify_current_password'), FontAwesomeIcons.key, () => _showChangePasswordDialog(context, ref), isDark),
                _buildActionTile(
                  ref.tr('two_factor'), 
                  settings.twoFactorEnabled ? ref.tr('active') : ref.tr('inactive'), 
                  FontAwesomeIcons.fingerprint, 
                  () => _show2FADialog(context, ref, settings.twoFactorEnabled), 
                  isDark
                ),
                _buildActionTile(ref.tr('active_sessions'), ref.tr('manage_sessions'), FontAwesomeIcons.desktop, () => _showSessionsDialog(context, ref, isDark), isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Données Section
            _buildSection(
              ref.tr('data'),
              FontAwesomeIcons.database,
              Colors.teal,
              isDark,
              [
                _buildActionTile(ref.tr('export_data'), ref.tr('download_data_copy'), FontAwesomeIcons.download, () => _exportData(context, ref), isDark),
                _buildActionTile(ref.tr('backups'), ref.tr('manage_backups'), FontAwesomeIcons.cloudArrowUp, () => _showBackupDialog(context, ref, isDark), isDark),
                _buildActionTile(ref.tr('clear_cache'), ref.tr('free_storage'), FontAwesomeIcons.broom, () => _clearCache(context, ref), isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Danger Zone
            _buildSection(
              ref.tr('danger_zone'),
              FontAwesomeIcons.triangleExclamation,
              Colors.red,
              isDark,
              [
                _buildDangerTile(ref.tr('reset_settings'), ref.tr('restore_defaults'), () => _resetSettings(context, ref), isDark),
                _buildDangerTile(ref.tr('logout'), ref.tr('logout_from_app'), () => _logout(context, ref), isDark),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, bool isDark, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: FaIcon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, WidgetRef ref, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: const Text('A', style: TextStyle(fontSize: 28, color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ref.tr('administrator'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
                const SizedBox(height: 4),
                Text('admin@hospital.com', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(ref.tr('super_admin'), style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showEditProfileDialog(context, ref),
            icon: const Icon(Icons.edit, size: 18),
            label: Text(ref.tr('modify')),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[900])),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      trailing: Switch(value: value, onChanged: onChanged, activeColor: Colors.blue),
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, String value, List<String> options, ValueChanged<String?> onChanged, bool isDark) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[900])),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap, bool isDark) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: FaIcon(icon, size: 16, color: Colors.grey[600]),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[900])),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDangerTile(String title, String subtitle, VoidCallback onTap, bool isDark) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, color: Colors.red),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: ref.tr('administrator'));
    final emailController = TextEditingController(text: 'admin@hospital.com');
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(ref.tr('modify_profile')),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: ref.tr('name'), border: const OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: emailController, decoration: InputDecoration(labelText: ref.tr('email'), border: const OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(ref.tr('cancel'))),
          ElevatedButton(
            onPressed: () { 
              Navigator.pop(dialogContext); 
              _showSuccess(context, ref.tr('profile_updated')); 
            }, 
            child: Text(ref.tr('save'))
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(ref.tr('change_password')),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text(errorMessage!, style: const TextStyle(color: Colors.red))),
                        ],
                      ),
                    ),
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: ref.tr('current_password'),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validator: (value) => value == null || value.isEmpty ? ref.tr('required_field') : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: ref.tr('new_password'),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return ref.tr('required_field');
                      if (value.length < 6) return ref.tr('password_too_short');
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: ref.tr('confirm_password'),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_clock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return ref.tr('required_field');
                      if (value != newPasswordController.text) return ref.tr('password_mismatch');
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(ref.tr('cancel'))),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Utiliser le backend pour changer le mot de passe
                  final success = await ref.read(loginControllerProvider.notifier).changePassword(
                    currentPasswordController.text,
                    newPasswordController.text,
                  );
                  
                  if (success) {
                    Navigator.pop(dialogContext);
                    _showSuccess(context, ref.tr('password_changed'));
                    // Déconnecter l'utilisateur car le token est invalidé
                    await ref.read(loginControllerProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  } else {
                    setDialogState(() {
                      errorMessage = ref.tr('password_error');
                    });
                  }
                }
              },
              child: Text(ref.tr('save')),
            ),
          ],
        ),
      ),
    );
  }

  void _show2FADialog(BuildContext context, WidgetRef ref, bool isEnabled) {
    final codeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isEnabled ? ref.tr('disable_2fa') : ref.tr('enable_2fa')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isEnabled) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_2, size: 100),
                    const SizedBox(height: 12),
                    Text(ref.tr('scan_qr_code'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: isEnabled ? ref.tr('enter_2fa_code') : ref.tr('verification_code'),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(ref.tr('cancel'))),
          ElevatedButton(
            style: isEnabled ? ElevatedButton.styleFrom(backgroundColor: Colors.red) : null,
            onPressed: () {
              if (codeController.text.length >= 6) {
                ref.read(settingsNotifierProvider.notifier).setTwoFactorEnabled(!isEnabled);
                Navigator.pop(dialogContext);
                _showSuccess(context, isEnabled ? ref.tr('2fa_disabled') : ref.tr('2fa_enabled'));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ref.tr('invalid_code')), backgroundColor: Colors.red),
                );
              }
            },
            child: Text(isEnabled ? ref.tr('disable_2fa') : ref.tr('enable_2fa')),
          ),
        ],
      ),
    );
  }

  void _showSessionsDialog(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(ref.tr('active_sessions')),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSessionItem('Chrome - Windows', ref.tr('current_session'), DateTime.now(), true, isDark, ref),
              _buildSessionItem('Firefox - MacOS', 'Paris, France', DateTime.now().subtract(const Duration(hours: 2)), false, isDark, ref),
              _buildSessionItem('Mobile App - iOS', 'Lyon, France', DateTime.now().subtract(const Duration(days: 1)), false, isDark, ref),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () { 
              Navigator.pop(dialogContext); 
              _showSuccess(context, ref.tr('other_sessions_disconnected')); 
            }, 
            child: Text(ref.tr('disconnect_all'), style: const TextStyle(color: Colors.red))
          ),
          ElevatedButton(onPressed: () => Navigator.pop(dialogContext), child: Text(ref.tr('close'))),
        ],
      ),
    );
  }

  Widget _buildSessionItem(String device, String location, DateTime time, bool isCurrent, bool isDark, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.blue.withOpacity(0.1) : (isDark ? const Color(0xFF0F172A) : Colors.grey[50]),
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(color: Colors.blue) : null,
      ),
      child: Row(
        children: [
          Icon(Icons.computer, color: isCurrent ? Colors.blue : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[900])),
                Text(location, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
              child: Text(ref.tr('current'), style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(ref.tr('backups')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cloud_done, color: Colors.green),
              title: Text(ref.tr('last_backup')),
              subtitle: Text('${ref.tr('today_at')} 14:30'),
              trailing: IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _showSuccess(context, ref.tr('backup_download'));
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.blue),
              title: Text(ref.tr('auto_backup')),
              subtitle: Text('${ref.tr('daily_at')} 02:00'),
              trailing: Switch(value: true, onChanged: (v) {}),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(ref.tr('close'))),
          ElevatedButton(
            onPressed: () { 
              Navigator.pop(dialogContext); 
              _showSuccess(context, ref.tr('backup_started')); 
            }, 
            child: Text(ref.tr('backup_now'))
          ),
        ],
      ),
    );
  }

  void _exportData(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(children: [const Icon(Icons.download, color: Colors.blue), const SizedBox(width: 8), Text(ref.tr('export_data'))]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(ref.tr('export_pdf')),
              onTap: () { Navigator.pop(dialogContext); _showSuccess(context, ref.tr('pdf_export_progress')); },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: Text(ref.tr('export_excel')),
              onTap: () { Navigator.pop(dialogContext); _showSuccess(context, ref.tr('excel_export_progress')); },
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.blue),
              title: Text(ref.tr('json_export')),
              onTap: () { Navigator.pop(dialogContext); _showSuccess(context, ref.tr('json_export_progress')); },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(ref.tr('cancel'))),
        ],
      ),
    );
  }

  void _clearCache(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(ref.tr('clear_cache')),
        content: Text(ref.tr('clear_cache_confirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(ref.tr('cancel'))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showSuccess(context, ref.tr('cache_cleared_mb'));
            },
            child: Text(ref.tr('confirm')),
          ),
        ],
      ),
    );
  }

  void _resetSettings(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(children: [const Icon(Icons.warning, color: Colors.orange), const SizedBox(width: 8), Text(ref.tr('reset_settings'))]),
        content: Text(ref.tr('reset_warning')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(ref.tr('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () { 
              ref.read(settingsNotifierProvider.notifier).resetSettings();
              ref.read(themeNotifierProvider.notifier).setThemeMode(ThemeMode.system);
              Navigator.pop(dialogContext); 
              _showSuccess(context, ref.tr('settings_reset')); 
            },
            child: Text(ref.tr('reset_settings')),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(children: [const Icon(Icons.logout, color: Colors.red), const SizedBox(width: 8), Text(ref.tr('logout'))]),
        content: Text(ref.tr('logout_confirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(ref.tr('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(loginControllerProvider.notifier).logout();
              context.go('/login');
            },
            child: Text(ref.tr('logout')),
          ),
        ],
      ),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
