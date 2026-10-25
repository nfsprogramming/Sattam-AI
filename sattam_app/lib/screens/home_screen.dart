import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'generate_document_screen.dart';
import '../models/law_models.dart';
import '../services/law_service.dart';
import 'act_list_screen.dart';
import 'evidence_locker/locker_auth_screen.dart';
import 'documents_screen.dart';
import 'package:sattam_app/l10n/app_localizations.dart';
import '../services/supabase_service.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';
import 'notifications_screen.dart';
import 'laws_search_screen.dart';
import '../models/user_case.dart';
import '../services/case_service.dart';
import 'widgets/add_case_bottom_sheet.dart';
class HomeScreen extends StatefulWidget {
  final void Function(String? query) onChatTap;

  const HomeScreen({super.key, required this.onChatTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      setState(() => _isSearchFocused = _searchFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final query = _searchController.text.trim();
    _searchController.clear();
    _searchFocus.unfocus();
    widget.onChatTap(query.isEmpty ? null : query);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = SupabaseService.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] as String? ?? 'User';
    
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      l10n.welcomeUser(fullName.split(' ').first),
                                      style: GoogleFonts.instrumentSerif(
                                        color: context.colors.textPrimary,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('👋', style: TextStyle(fontSize: 24)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.howCanWeHelp,
                                style: GoogleFonts.plusJakartaSans(
                                  color: context.colors.textMuted,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [

                            // Bell Icon
                            StreamBuilder<List<AppNotification>>(
                              stream: NotificationService.streamUserNotifications(),
                              builder: (context, snapshot) {
                                final unreadCount = snapshot.data?.where((n) => !n.isRead).length ?? 0;
                                
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: context.colors.borderSubtle),
                                          color: context.colors.surface,
                                        ),
                                        child: Icon(Icons.notifications_none_rounded, color: context.colors.textPrimary, size: 22),
                                      ),
                                      if (unreadCount > 0)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: context.colors.surface, width: 1.5),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }
                            ),
                      ],
                    ),
                  ],
                ),
                    const SizedBox(height: 24),

                    // Search Bar
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isSearchFocused ? context.colors.primary : context.colors.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, color: _isSearchFocused ? context.colors.primary : context.colors.textMuted, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocus,
                              style: GoogleFonts.plusJakartaSans(color: context.colors.textPrimary, fontSize: 15),
                              decoration: InputDecoration(
                                hintText: l10n.searchLegalTopics,
                                hintStyle: GoogleFonts.plusJakartaSans(color: context.colors.textMuted, fontSize: 15),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onSubmitted: (_) => _submitSearch(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    _buildMyCasesSection(context, l10n),
                    const SizedBox(height: 24),

                    // Document Generator Action
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentsScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.colors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: context.colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.generateLegalDocuments,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.generateLegalDocumentsSubtitle,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: context.colors.textMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: context.colors.primary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),


                    // Popular Categories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.exploreCategories,
                          style: GoogleFonts.plusJakartaSans(
                            color: context.colors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search_rounded, color: context.colors.textPrimary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LawsSearchScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Categories Grid
                    FutureBuilder<List<LawCategory>>(
                      future: LawService.getLawCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: context.colors.primary));
                        }
                        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Failed to load laws', style: TextStyle(color: Colors.white)));
                        }
                        
                        final categories = snapshot.data!;
                        
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.15,
                          children: categories.asMap().entries.map((entry) {
                            final index = entry.key;
                            final category = entry.value;
                            
                            // Assign icons and colors based on index to keep the colorful aesthetic
                            final icons = [
                              Icons.gavel_rounded,
                              Icons.directions_car_rounded,
                              Icons.shopping_cart_outlined,
                              Icons.work_outline_rounded,
                              Icons.family_restroom_rounded,
                              Icons.security_rounded,
                            ];
                            final colors = [
                              const Color(0xFFFF453A),
                              const Color(0xFF64D2FF),
                              const Color(0xFF32D74B),
                              const Color(0xFFBF5AF2),
                              const Color(0xFFFF9F0A),
                              const Color(0xFFFFD60A),
                            ];
                            
                            return _buildCategoryCard(
                              index: index,
                              category: category,
                              icon: icons[index % icons.length],
                              color: colors[index % colors.length],
                            );
                          }).toList(),
                        );
                      }
                    ),
                    const SizedBox(height: 32),

                    // Quick Actions
                    Text(
                      l10n.quickActions,
                      style: GoogleFonts.plusJakartaSans(
                        color: context.colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              index: 0,
                              title: l10n.askAi,
                              subtitle: l10n.askAiSubtitle,
                              icon: Icons.chat_bubble_outline_rounded,
                              onTap: () => widget.onChatTap(null),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                              index: 1,
                              title: l10n.generateDocument,
                              subtitle: l10n.generateDocumentSubtitle,
                              icon: Icons.description_outlined,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenerateDocumentScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Evidence Locker Card
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const LockerAuthScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.colors.primary.withValues(alpha: 0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: context.colors.primary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.shield_rounded, color: context.colors.primary, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Evidence Locker',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: context.colors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Securely store and organize your legal files.',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: context.colors.textMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: context.colors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Open',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedCategoryName(BuildContext context, String englishName) {
    final l10n = AppLocalizations.of(context)!;
    switch (englishName) {
      case 'Criminal Law': return l10n.catCriminalLaw;
      case 'Traffic & Motor': return l10n.catTrafficMotor;
      case 'Consumer Law': return l10n.catConsumerLaw;
      case 'Labour Law': return l10n.catLabourLaw;
      case 'Family Law': return l10n.catFamilyLaw;
      case 'Cyber Law': return l10n.catCyberLaw;
      default: return englishName;
    }
  }

  Widget _buildCategoryCard({
    required int index,
    required LawCategory category,
    required IconData icon,
    required Color color,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Interval((index * 0.1).clamp(0.0, 1.0), 1.0, curve: Curves.easeOutCubic),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: SmoothBounce(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActListScreen(category: category),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const Spacer(),
              Text(
                _getLocalizedCategoryName(context, category.name),
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${category.acts.length} Acts',
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textMuted,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Interval((0.4 + index * 0.1).clamp(0.0, 1.0), 1.0, curve: Curves.easeOutCubic),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: SmoothBounce(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.colors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: context.colors.primary, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.primary.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyCasesSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.myCases,
              style: GoogleFonts.plusJakartaSans(
                color: context.colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => _showAddCaseBottomSheet(context),
              child: Text(
                l10n.addCase,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: FutureBuilder<List<UserCase>>(
            future: CaseService.getUserCases(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: context.colors.primary));
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyCasesCard(context, l10n);
              }

              final cases = snapshot.data!;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: cases.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final userCase = cases[index];
                  return _buildCaseCard(context, userCase);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCasesCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderSubtle),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, color: context.colors.textMuted, size: 32),
          const SizedBox(height: 12),
          Text(
            l10n.noActiveCases,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.keepTrackHere,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseCard(BuildContext context, UserCase userCase) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  userCase.title,
                  style: GoogleFonts.plusJakartaSans(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: userCase.status == 'Active' ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  userCase.status,
                  style: GoogleFonts.plusJakartaSans(
                    color: userCase.status == 'Active' ? Colors.green : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (userCase.description != null && userCase.description!.isNotEmpty)
            Expanded(
              child: Text(
                userCase.description!,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textMuted,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            const Spacer(),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: context.colors.primary, size: 14),
              const SizedBox(width: 4),
              Text(
                'Created: ${userCase.createdAt.day}/${userCase.createdAt.month}/${userCase.createdAt.year}',
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddCaseBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCaseBottomSheet(),
    );

    if (result == true && mounted) {
      setState(() {}); // Refresh the future builder
    }
  }
}

class SmoothBounce extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const SmoothBounce({super.key, required this.child, required this.onTap});

  @override
  State<SmoothBounce> createState() => _SmoothBounceState();
}

class _SmoothBounceState extends State<SmoothBounce> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
