import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/providers/auth_provider.dart';
import 'package:efootball_fixture_generator/features/squad/domain/entities/player_card_entity.dart';
import 'package:efootball_fixture_generator/features/squad/domain/entities/squad_item_entity.dart';
import 'package:efootball_fixture_generator/features/squad/presentation/providers/squad_provider.dart';
import 'package:efootball_fixture_generator/features/squad/presentation/widgets/player_card_chip.dart';

class SquadBuilderScreen extends ConsumerStatefulWidget {
  const SquadBuilderScreen({super.key});

  @override
  ConsumerState<SquadBuilderScreen> createState() => _SquadBuilderScreenState();
}

class _SquadBuilderScreenState extends ConsumerState<SquadBuilderScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  int? _selectedSlot; // slot index being filled

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceMs),
      () => ref.read(cardSearchQueryProvider.notifier).state = value,
    );
  }

  void _onSlotTap(int slotIndex) {
    setState(() {
      _selectedSlot = _selectedSlot == slotIndex ? null : slotIndex;
    });
  }

  Future<void> _assignCard(PlayerCardEntity card) async {
    if (_selectedSlot == null) return;
    final slotIndex = _selectedSlot!;
    final isStarter = slotIndex < AppConstants.maxStarters;
    final position = isStarter
        ? AppConstants.positionStarter
        : AppConstants.positionSubstitute;

    await ref.read(userSquadProvider.notifier).addCard(
          masterCardId: card.masterCardId,
          position: position,
          slotIndex: slotIndex,
        );

    setState(() => _selectedSlot = null);
    _searchController.clear();
    ref.read(cardSearchQueryProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    final squadAsync = ref.watch(userSquadProvider);
    final searchResults = ref.watch(cardSearchResultsProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(user != null ? '${user.teamTag} Squad' : 'My Squad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(userSquadProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search player cards...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(cardSearchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Search results overlay
          if (ref.watch(cardSearchQueryProvider).isNotEmpty)
            _buildSearchResults(searchResults),

          // Squad grid
          Expanded(
            child: squadAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Error: $e',
                    style:
                        const TextStyle(color: AppColors.error)),
              ),
              data: (squad) => _buildSquadGrid(squad),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
      AsyncValue<List<PlayerCardEntity>> searchResults) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: searchResults.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (e, _) => Center(
          child: Text('Search error',
              style: const TextStyle(color: AppColors.error)),
        ),
        data: (cards) {
          if (cards.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No cards found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: cards.length,
            itemBuilder: (_, i) {
              final card = cards[i];
              final badgeColor = AppColors.cardTypeColor(card.cardType);
              final tappable = _selectedSlot != null;
              return ListTile(
                onTap: tappable ? () => _assignCard(card) : null,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: card.cardImageUrl != null
                      ? Image.network(
                          card.cardImageUrl!,
                          width: 44,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _searchPlaceholder(),
                        )
                      : _searchPlaceholder(),
                ),
                title: Text(
                  card.playerName,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600),
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: badgeColor.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        card.cardType,
                        style: TextStyle(
                            color: badgeColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${card.maxRating}',
                      style: const TextStyle(
                          color: AppColors.accentNeon,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                trailing: tappable
                    ? ElevatedButton(
                        onPressed: () => _assignCard(card),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Add'),
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSquadGrid(List<SquadItemEntity> squad) {
    final slotMap = {for (final item in squad) item.slotIndex: item};

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected slot hint
          if (_selectedSlot != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.accentNeon, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Slot ${_selectedSlot! + 1} selected — tap a card to assign',
                      style: const TextStyle(
                        color: AppColors.accentNeon,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _selectedSlot = null),
                    child: const Icon(Icons.close,
                        color: AppColors.textSecondary, size: 16),
                  ),
                ],
              ),
            ),

          // Starters
          _sectionHeader('STARTERS (11)',
              '${slotMap.keys.where((k) => k < AppConstants.maxStarters).length}/11'),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.72,
            ),
            itemCount: AppConstants.maxStarters,
            itemBuilder: (context, i) => _buildSlot(i, slotMap[i]),
          ),

          const SizedBox(height: 20),

          // Bench (12 substitutes in a 4-column grid)
          _sectionHeader('BENCH (12)',
              '${slotMap.keys.where((k) => k >= AppConstants.maxStarters).length}/12'),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.72,
            ),
            itemCount: AppConstants.maxSubstitutes,
            itemBuilder: (context, i) => _buildSlot(
              AppConstants.maxStarters + i,
              slotMap[AppConstants.maxStarters + i],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _searchPlaceholder() => Container(
        width: 44,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.person,
            color: AppColors.textDisabled, size: 24),
      );

  Widget _buildSlot(int slotIndex, SquadItemEntity? item) {
    final isSelected = _selectedSlot == slotIndex;
    final filled = item != null;

    if (filled) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          PlayerCardChip(
            card: item.card,
            isSelected: isSelected,
            onTap: () => _onSlotTap(slotIndex),
            onRemove: () =>
                ref.read(userSquadProvider.notifier).removeCard(item.squadItemId),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => _onSlotTap(slotIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 72),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surfaceVariant.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.accentNeon : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentNeon.withValues(alpha: 0.25),
                    blurRadius: 8,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.add_circle : Icons.add,
                color: isSelected
                    ? AppColors.accentNeon
                    : AppColors.textDisabled,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                '${slotIndex + 1}',
                style: TextStyle(
                  color: isSelected
                      ? AppColors.accentNeon
                      : AppColors.textDisabled,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
