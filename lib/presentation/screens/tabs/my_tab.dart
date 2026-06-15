import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/api_key_provider.dart';

class MyTab extends ConsumerStatefulWidget {
  const MyTab({super.key});
  @override
  ConsumerState<MyTab> createState() => _MyTabState();
}

class _MyTabState extends ConsumerState<MyTab> {
  final Set<int> _selectedStyles = {};

  static const kBg      = Color(0xFFF6F7FF);
  static const kSurface = Color(0xFFFFFFFF);
  static const kBorder  = Color(0xFFE4E6F5);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kMint    = Color(0xFF00C49A);
  static const kGold    = Color(0xFFFFBE0B);
  static const kText    = Color(0xFF1E1B4B);
  static const kSub     = Color(0xFF9496B0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileHeader(),
                  _statsRow(),
                  _divider(),
                  _sectionLabel('나의 여행 스타일'),
                  _styleSubtitle(),
                  _travelStyleGrid(),
                  _divider(),
                  _sectionLabel('AI 설정'),
                  const SizedBox(height: 14),
                  _apiKeyGroup(),
                  const SizedBox(height: 12),
                  _divider(),
                  _sectionLabel('설정'),
                  const SizedBox(height: 14),
                  _settingsGroup1(),
                  const SizedBox(height: 12),
                  _settingsGroup2(),
                  _versionInfo(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B6EF6), Color(0xFFa855f7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30, top: -20,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Positioned(
            left: -20, bottom: -20,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 2.5),
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: Colors.white, size: 46),
                    ),
                    Positioned(
                      bottom: 0, right: -2,
                      child: Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFF6F7FF), width: 2),
                          boxShadow: [BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6)],
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Color(0xFF7B6EF6), size: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('여행자',
                    style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.w800,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.mail_outline_rounded,
                      size: 13,
                      color: Colors.white.withValues(alpha: 0.7)),
                  const SizedBox(width: 5),
                  Text('로그인이 필요해요',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.75))),
                ]),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _headerBtn(icon: Icons.edit_rounded,
                        label: '프로필 편집', isPrimary: true),
                    const SizedBox(width: 10),
                    _headerBtn(icon: Icons.share_outlined,
                        label: '공유', isPrimary: false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerBtn({
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isPrimary
            ? Colors.white
            : Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(22),
        border: isPrimary
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: isPrimary
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12, offset: const Offset(0, 4))]
            : null,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon,
            color: isPrimary ? kPrimary : Colors.white, size: 14),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: isPrimary ? kPrimary : Colors.white)),
      ]),
    );
  }

  Widget _statsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder),
          boxShadow: [BoxShadow(
              color: kPrimary.withValues(alpha: 0.06),
              blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(children: [
          _statBox('0', '여행 일정', kPrimary),
          _statDivider(),
          _statBox('0', '방문 도시', kSecond),
          _statDivider(),
          _statBox('0', '저장 장소', kMint),
        ]),
      ),
    );
  }

  Widget _statDivider() => Container(width: 1, height: 36, color: kBorder);

  Widget _statBox(String value, String label, Color color) {
    return Expanded(
      child: Column(children: [
        ShaderMask(
          shaderCallback: (b) => LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)]).createShader(b),
          child: Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 26, fontWeight: FontWeight.w800,
                  color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: kSub, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _divider() => Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      color: kBorder);

  Widget _sectionLabel(String label) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w700, color: kText)));

  Widget _styleSubtitle() => Padding(
      padding: const EdgeInsets.fromLTRB(24, 5, 24, 16),
      child: Text('탭해서 나의 여행 스타일을 선택해보세요',
          style: GoogleFonts.poppins(fontSize: 12, color: kSub)));

  Widget _travelStyleGrid() {
    final styles = [
      ('🍜', '맛집 투어',   kSecond),
      ('🌿', '자연 힐링',   kMint),
      ('🏛️', '문화 탐방',  kPrimary),
      ('🛍️', '쇼핑',       kGold),
      ('📸', '인스타 성지', Color(0xFFFF8E53)),
      ('🎭', '현지 체험',   Color(0xFF0085FF)),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
        children: styles.asMap().entries.map((e) {
          final i   = e.key;
          final s   = e.value;
          final c   = s.$3;
          final sel = _selectedStyles.contains(i);
          return GestureDetector(
            onTap: () => setState(() {
              if (sel) { _selectedStyles.remove(i); }
              else { _selectedStyles.add(i); }
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: sel ? c.withValues(alpha: 0.1) : kSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: sel ? c.withValues(alpha: 0.5) : kBorder,
                  width: sel ? 1.5 : 1,
                ),
                boxShadow: sel
                    ? [BoxShadow(color: c.withValues(alpha: 0.15),
                        blurRadius: 10, offset: const Offset(0, 3))]
                    : [BoxShadow(color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.$1, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(s.$2,
                            style: GoogleFonts.poppins(
                                fontSize: 11, fontWeight: FontWeight.w600,
                                color: sel ? c : kSub)),
                      ],
                    ),
                  ),
                  if (sel)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        width: 18, height: 18,
                        decoration: BoxDecoration(
                            color: c, shape: BoxShape.circle),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 11),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Claude API 키 그룹 ──────────────────────────────

  Widget _apiKeyGroup() {
    final apiKey = ref.watch(apiKeyProvider);
    final hasKey = apiKey.isNotEmpty;
    final maskedKey = hasKey
        ? '${apiKey.substring(0, apiKey.length.clamp(0, 10))}••••••••'
        : '미설정';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: hasKey
                  ? kMint.withValues(alpha: 0.4)
                  : kBorder),
          boxShadow: [BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: InkWell(
          onTap: () => _showApiKeyDialog(apiKey),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: (hasKey ? kMint : kSub).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  hasKey ? Icons.key_rounded : Icons.key_off_rounded,
                  color: hasKey ? kMint : kSub, size: 19),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Claude API 키',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500,
                            color: kText)),
                    Text(maskedKey,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: hasKey ? kMint : kSub)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (hasKey ? kMint : kPrimary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  hasKey ? '변경' : '입력',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: hasKey ? kMint : kPrimary),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _showApiKeyDialog(String currentKey) {
    final ctrl = TextEditingController(text: currentKey);
    bool obscure = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(color: kPrimary.withValues(alpha: 0.15),
                    blurRadius: 40, offset: const Offset(0, 16)),
              ],
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [kPrimary, kSecond]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.key_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Claude API 키',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w700,
                                color: kText)),
                        Text('Anthropic Console에서 발급',
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: kSub)),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F7FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kBorder),
                  ),
                  child: TextField(
                    controller: ctrl,
                    obscureText: obscure,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: kText,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: 'sk-ant-api03-...',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 13, color: kSub),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: kSub, size: 18),
                        onPressed: () => setDlg(() => obscure = !obscure),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('키는 기기에만 저장되며 외부로 전송되지 않아요.',
                    style: GoogleFonts.poppins(fontSize: 11, color: kSub)),
                const SizedBox(height: 24),
                Row(children: [
                  if (currentKey.isNotEmpty) ...[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(apiKeyProvider.notifier).clear();
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: kSecond.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: kSecond.withValues(alpha: 0.3)),
                          ),
                          child: Center(
                            child: Text('삭제',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kSecond)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        final key = ctrl.text.trim();
                        if (key.isNotEmpty) {
                          ref.read(apiKeyProvider.notifier).set(key);
                        }
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [kPrimary, kSecond]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(
                              color: kPrimary.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4))],
                        ),
                        child: Center(
                          child: Text('저장',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    ).then((_) => ctrl.dispose());
  }

  // ── 일반 설정 그룹 ──────────────────────────────────

  Widget _settingsGroup1() {
    return _settingCard([
      _SettingItem(Icons.account_circle_outlined, '계정 관리',
          kPrimary, '로그인 필요'),
      _SettingItem(Icons.notifications_outlined,  '알림 설정',
          kSecond, null),
      _SettingItem(Icons.language_outlined,       '언어',
          kMint, '한국어'),
    ]);
  }

  Widget _settingsGroup2() {
    return _settingCard([
      _SettingItem(Icons.help_outline_rounded,    '도움말',           kSub, null),
      _SettingItem(Icons.privacy_tip_outlined,    '개인정보 처리방침', kSub, null),
      _SettingItem(Icons.info_outline_rounded,    '앱 정보',          kSub, 'v1.0.0'),
    ]);
  }

  Widget _settingCard(List<_SettingItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder),
          boxShadow: [BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: items.asMap().entries.map((e) {
            final i    = e.key;
            final item = e.value;
            final isLast = i == items.length - 1;
            return Column(
              children: [
                InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 15),
                    child: Row(children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(item.icon, color: item.color, size: 19),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(item.label,
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w500,
                                color: kText)),
                      ),
                      if (item.trailing != null)
                        Text(item.trailing!,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: kSub)),
                      const SizedBox(width: 6),
                      Icon(Icons.chevron_right_rounded,
                          color: kSub.withValues(alpha: 0.5), size: 19),
                    ]),
                  ),
                ),
                if (!isLast) Divider(color: kBorder, height: 1, indent: 70),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _versionInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Center(
        child: Column(children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
                colors: [kPrimary, kSecond]).createShader(b),
            child: Text('TR.',
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
          const SizedBox(height: 4),
          Text('ver 1.0.0  ·  Made with ❤️',
              style: GoogleFonts.poppins(fontSize: 11, color: kSub)),
        ]),
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  final Color color;
  final String? trailing;
  final VoidCallback? onTap;
  const _SettingItem(this.icon, this.label, this.color, this.trailing,
      {this.onTap});
}
