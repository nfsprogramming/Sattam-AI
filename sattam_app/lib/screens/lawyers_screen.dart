import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sattam_app/l10n/app_localizations.dart';
import 'lawyer_profile_screen.dart';
import '../theme/app_theme.dart';
import '../services/supabase_service.dart';

class LawyersScreen extends StatefulWidget {
  const LawyersScreen({super.key});

  @override
  State<LawyersScreen> createState() => _LawyersScreenState();
}

class _LawyersScreenState extends State<LawyersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allLawyers = [];
  List<Map<String, dynamic>> _filteredLawyers = [];
  bool _isLoading = true;
  int _selectedFilter = 0;

  final List<String> _filterKeys = [
    'all',
    'criminal',
    'family',
    'civil',
    'corporate'
  ];

  @override
  void initState() {
    super.initState();
    _fetchLawyers();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchLawyers() async {
    try {
      final dbLawyers = await SupabaseService.getVerifiedLawyers();
      if (mounted) {
        setState(() {
          _allLawyers = dbLawyers.isNotEmpty ? dbLawyers : _getLawyers(context);
          // Sort by rating by default
          _allLawyers.sort((a, b) {
            final ratingA = double.tryParse(a['rating'].toString()) ?? 0.0;
            final ratingB = double.tryParse(b['rating'].toString()) ?? 0.0;
            return ratingB.compareTo(ratingA); // Descending
          });
          _filteredLawyers = List.from(_allLawyers);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _allLawyers = _getLawyers(context);
          _filteredLawyers = List.from(_allLawyers);
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      _filteredLawyers = _allLawyers.where((lawyer) {
        // 1. Search Query Match
        final name = (lawyer['name']?.toString() ?? '').toLowerCase();
        final loc = (lawyer['loc']?.toString() ?? lawyer['location']?.toString() ?? '').toLowerCase();
        final spec = (lawyer['spec']?.toString() ?? lawyer['specialization']?.toString() ?? '').toLowerCase();
        
        final matchesSearch = name.contains(query) || loc.contains(query) || spec.contains(query);

        // 2. Category Match
        bool matchesCategory = true;
        if (_selectedFilter != 0) { // If not "All"
           final categoryKey = _filterKeys[_selectedFilter];
           matchesCategory = spec.contains(categoryKey);
        }

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  List<String> _getFilters(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.allFilters,
      l10n.catCriminalLaw,
      l10n.catFamilyLaw,
      l10n.catCivilLaw,
      l10n.catCorporateLaw
    ];
  }

  List<Map<String, dynamic>> _getLawyers(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'name': 'Adv. R. Karthik',
        'rating': '4.8',
        'reviews': '120',
        'spec': l10n.catCriminalLaw,
        'exp': '8 Years',
        'dist': '1.2 km',
        'loc': 'Coimbatore, Tamil Nadu',
      },
      {
        'name': 'Adv. Priya Sharma',
        'rating': '4.7',
        'reviews': '98',
        'spec': l10n.catFamilyLaw,
        'exp': '6 Years',
        'dist': '1.8 km',
        'loc': 'Coimbatore, Tamil Nadu',
      },
      {
        'name': 'Adv. M. Arjun',
        'rating': '4.6',
        'reviews': '76',
        'spec': l10n.catCivilLaw,
        'exp': '10 Years',
        'dist': '2.1 km',
        'loc': 'Coimbatore, Tamil Nadu',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.lawyersNearYou,
          style: GoogleFonts.plusJakartaSans(
            color: context.colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: context.colors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: context.colors.textMuted, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.plusJakartaSans(color: context.colors.textPrimary, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.searchLawyers,
                              hintStyle: GoogleFonts.plusJakartaSans(color: context.colors.textMuted, fontSize: 15),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Horizontal Filters
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _getFilters(context).length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedFilter == index;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedFilter = index);
                            _applyFilters();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected ? context.colors.primary : context.colors.surfaceContainer,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: isSelected ? context.colors.primary : context.colors.borderSubtle),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _getFilters(context)[index],
                              style: GoogleFonts.plusJakartaSans(
                                color: isSelected ? Colors.white : context.colors.textPrimary,
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lawyer Cards
                  _isLoading
                      ? Center(child: CircularProgressIndicator(color: context.colors.primary))
                      : _filteredLawyers.isEmpty
                          ? Center(
                              child: Text('No lawyers found.', style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted)),
                            )
                          : _buildLawyerList(_filteredLawyers),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLawyerList(List<Map<String, dynamic>> lawyers) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lawyers.length,
      separatorBuilder: (context, index) => Divider(color: context.colors.borderSubtle, height: 32),
      itemBuilder: (context, index) {
        final lawyer = lawyers[index];
        return _buildLawyerCard(lawyer);
      },
    );
  }

  Widget _buildLawyerCard(Map<String, dynamic> data) {
    // Normalize data for the profile screen
    final normalizedData = {
      'name': data['name'] ?? 'Unknown',
      'image': data['image'] ?? 'https://ui-avatars.com/api/?name=${data['name']?.replaceAll(" ", "+") ?? "Lawyer"}&background=random',
      'rating': data['rating'] ?? 0.0,
      'reviews': data['reviews'] ?? 0,
      'location': data['location'] ?? data['loc'] ?? 'Unknown',
      'experience': data['experience'] ?? data['exp'] ?? 'Unknown',
      'specialties': data['specialization'] != null 
          ? [data['specialization']] 
          : (data['spec'] != null ? [data['spec']] : ['General Practice']),
      'languages': ['English', 'Tamil'], // Default languages
    };

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LawyerProfileScreen(lawyer: normalizedData),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile Image
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.borderSubtle),
          ),
          child: Center(
            child: Icon(Icons.person_rounded, color: context.colors.textMuted, size: 40),
          ),
        ),
        const SizedBox(width: 16),
        // Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['name'] ?? 'Unknown',
                    style: GoogleFonts.plusJakartaSans(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: context.colors.textPrimary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        (data['rating']?.toString()) ?? '0.0',
                        style: GoogleFonts.plusJakartaSans(
                          color: context.colors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        ' (${data['reviews']?.toString() ?? '0'})',
                        style: GoogleFonts.plusJakartaSans(
                          color: context.colors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${data['specialization'] ?? data['spec'] ?? ''} • ${data['experience'] ?? data['exp'] ?? ''}',
                    style: GoogleFonts.plusJakartaSans(
                      color: context.colors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    data['dist'] ?? '',
                    style: GoogleFonts.plusJakartaSans(
                      color: context.colors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: context.colors.textMuted, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        data['location'] ?? data['loc'] ?? '',
                        style: GoogleFonts.plusJakartaSans(
                          color: context.colors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.colors.borderSubtle),
                    ),
                    child: Icon(Icons.phone_in_talk_rounded, color: context.colors.textPrimary, size: 18),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ),
    );
  }
}
