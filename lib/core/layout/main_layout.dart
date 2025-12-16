import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../localization/app_localizations.dart';
import '../../features/auth/presentation/auth_providers.dart';

/// Layout principal avec sidebar moderne et navigation
class MainLayout extends ConsumerStatefulWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  bool _isSidebarExpanded = true;
  bool _isMobile = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    _isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Row(
          children: [
            if (!_isMobile || _isSidebarExpanded) _buildSidebar(context, isDark),
            Expanded(
              child: Column(
                children: [
                  if (!_isMobile) _buildTopBar(context, isDark),
                  Expanded(
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isMobile
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isSidebarExpanded = !_isSidebarExpanded;
                });
              },
              child: const Icon(Icons.menu),
            )
          : null,
    );
  }

  Widget _buildSidebar(BuildContext context, bool isDark) {
    final sidebarWidth = _isSidebarExpanded ? 280.0 : 80.0;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSidebarHeader(context, isDark),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildNavItem(
                  context,
                  ref.tr('dashboard'),
                  FontAwesomeIcons.chartLine,
                  '/',
                  isDark,
                ),
                _buildNavItem(
                  context,
                  ref.tr('patients'),
                  FontAwesomeIcons.userInjured,
                  '/patients',
                  isDark,
                ),
                _buildNavItem(
                  context,
                  ref.tr('services'),
                  FontAwesomeIcons.hospital,
                  '/services',
                  isDark,
                ),
                _buildNavItem(
                  context,
                  ref.tr('care'),
                  FontAwesomeIcons.heartPulse,
                  '/soins',
                  isDark,
                ),
                _buildNavItem(
                  context,
                  ref.tr('appointments'),
                  FontAwesomeIcons.calendarCheck,
                  '/rendez-vous',
                  isDark,
                ),
                _buildNavItem(
                  context,
                  ref.tr('finance'),
                  FontAwesomeIcons.euroSign,
                  '/finance',
                  isDark,
                ),
                _buildNavItem(
                  context,
                  ref.tr('reports'),
                  FontAwesomeIcons.fileLines,
                  '/rapports',
                  isDark,
                ),
                _buildNavItem(
                  context,
                  ref.tr('notifications'),
                  FontAwesomeIcons.bell,
                  '/notifications',
                  isDark,
                  badge: 3,
                ),
                const Divider(height: 32),
                _buildNavItem(
                  context,
                  ref.tr('settings'),
                  FontAwesomeIcons.gear,
                  '/parametres',
                  isDark,
                ),
              ],
            ),
          ),
          if (!_isMobile)
            Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                icon: Icon(
                  _isSidebarExpanded ? Icons.chevron_left : Icons.chevron_right,
                  color: isDark ? Colors.white : Colors.grey[700],
                ),
                onPressed: () {
                  setState(() {
                    _isSidebarExpanded = !_isSidebarExpanded;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const FaIcon(
              FontAwesomeIcons.hospital,
              color: Colors.white,
              size: 24,
            ),
          ),
          if (_isSidebarExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.tr('hospital_name'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ref.tr('admin_panel'),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String label,
    IconData icon,
    String route,
    bool isDark, {
    int? badge,
  }) {
    final isActive = widget.currentRoute == route;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryBlue.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(route),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                FaIcon(
                  icon,
                  color: isActive
                      ? AppTheme.primaryBlue
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  size: 20,
                ),
                if (_isSidebarExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isActive
                            ? AppTheme.primaryBlue
                            : (isDark ? Colors.white : Colors.grey[700]),
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (badge != null && badge > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '${ref.tr('search')}...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell),
            onPressed: () => context.go('/notifications'),
            tooltip: ref.tr('notifications'),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: const Text('A', style: TextStyle(color: Colors.white)),
            ),
            onSelected: (value) {
              if (value == 'profile') {
                _showProfileDialog(context, isDark);
              } else if (value == 'settings') {
                context.go('/parametres');
              } else if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 20),
                    const SizedBox(width: 8),
                    Text(ref.tr('profile')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    const Icon(Icons.settings, size: 20),
                    const SizedBox(width: 8),
                    Text(ref.tr('settings')),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(ref.tr('logout'), style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.person, color: Colors.blue),
            const SizedBox(width: 12),
            Text(ref.tr('profile_admin')),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Text('A', style: TextStyle(fontSize: 40, color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              _buildProfileItem(Icons.person, ref.tr('name'), ref.tr('administrator'), isDark),
              _buildProfileItem(Icons.email, ref.tr('email'), 'admin@hospital.com', isDark),
              _buildProfileItem(Icons.work, ref.tr('role'), ref.tr('super_admin'), isDark),
              _buildProfileItem(Icons.calendar_today, ref.tr('member_since'), '${ref.tr('january')} 2024', isDark),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('close'))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(ref.tr('profile_updated')), backgroundColor: Colors.blue),
              );
            },
            child: Text(ref.tr('edit')),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[900])),
            ],
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.red),
            const SizedBox(width: 12),
            Text(ref.tr('logout')),
          ],
        ),
        content: Text(ref.tr('logout_confirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ref.read(loginControllerProvider.notifier).logout();
              context.go('/login');
            },
            child: Text(ref.tr('logout')),
          ),
        ],
      ),
    );
  }
}
