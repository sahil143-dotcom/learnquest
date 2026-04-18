// ─── placement_prep_screen.dart ───────────────────────────────────────────────
// Placement Prep Hub — the most important screen for student career outcomes.
// Shows readiness score, DSA track, interview round guide, and company prep.
// Accessible as the 6th tab in the Artifacts Hub.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class PlacementPrepScreen extends ConsumerStatefulWidget {
  const PlacementPrepScreen({super.key});

  @override
  ConsumerState<PlacementPrepScreen> createState() =>
      _PlacementPrepScreenState();
}

class _PlacementPrepScreenState extends ConsumerState<PlacementPrepScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  final _tabData = const [
    _Tab('🎯', 'Overview'),
    _Tab('💻', 'DSA'),
    _Tab('🎤', 'Interview'),
    _Tab('🏢', 'Companies'),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _tabData.length, vsync: this);
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  // Compute placement readiness 0–100 from milestone count + level
  int _readinessScore(int milestones, int level) {
    final fromMilestones = (milestones * 12).clamp(0, 60);
    final fromLevel      = ((level - 1) * 8).clamp(0, 40);
    return (fromMilestones + fromLevel).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final user  = ref.watch(userProgressProvider);
    final score = _readinessScore(user.completedMilestones.length, user.level);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F0FF),
      body: SafeArea(
        child: Column(
          children: [
            // ── Sticky white header ────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      _BackButton(),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Placement Prep 🎯',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          Text(
                            'Your career launch control panel',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Tab bar
                  TabBar(
                    controller: _tabs,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: const Color(0xFF7C6FD0),
                    labelColor: const Color(0xFF7C6FD0),
                    unselectedLabelColor: const Color(0xFF9CA3AF),
                    indicatorWeight: 2.5,
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 14),
                    tabs: _tabData.map((t) => Tab(
                      height: 42,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(t.emoji,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(t.label,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),

            // ── Tab content ───────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _OverviewTab(score: score, user: user),
                  const _DSATab(),
                  const _InterviewTab(),
                  const _CompaniesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab label model ──────────────────────────────────────────────────────────
class _Tab {
  final String emoji;
  final String label;
  const _Tab(this.emoji, this.label);
}

// ─── Shared back button ───────────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F0FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 16, color: Color(0xFF2D3748)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 1 — OVERVIEW
// ═══════════════════════════════════════════════════════════════════════════════

class _OverviewTab extends StatelessWidget {
  final int score;
  final dynamic user;
  const _OverviewTab({required this.score, required this.user});

  String get _scoreLabel {
    if (score < 20) return 'Just getting started 🌱';
    if (score < 40) return 'Building foundations ⚡';
    if (score < 60) return 'Solid progress 🔥';
    if (score < 80) return 'Almost placement ready 💪';
    return 'Placement Ready! 🏆';
  }

  Color get _scoreColor {
    if (score < 30) return const Color(0xFF4A90B8);
    if (score < 60) return const Color(0xFF7C6FD0);
    return const Color(0xFF27AE60);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // ── Readiness Score hero card ────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7C6FD0),
                const Color(0xFF5B6BD0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C6FD0).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular score dial
              SizedBox(
                width: 90,
                height: 90,
                child: CustomPaint(
                  painter: _ScoreDial(score: score),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$score',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          '/100',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              // Label + tip
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Placement Readiness',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _scoreLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Mini progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: score / 100,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Complete more milestones to raise your score',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Stats row ────────────────────────────────────────────────────
        Row(
          children: [
            _StatCard(emoji: '🏆', label: 'Milestones', value: '${user.completedMilestones.length}'),
            const SizedBox(width: 10),
            _StatCard(emoji: '⚡', label: 'Level', value: '${user.level}'),
          ],
        ),
        const SizedBox(height: 20),

        // ── Section title ────────────────────────────────────────────────
        const _SectionTitle('📋 Your Placement Checklist'),
        const SizedBox(height: 10),

        // ── Checklist items ──────────────────────────────────────────────
        ..._checklistItems.map((item) => _ChecklistRow(item: item)),
        const SizedBox(height: 20),

        // ── Pro tip card ─────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF27AE60).withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 20)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pro tip: Companies value consistent learners. '
                  'Keep your streak alive — recruiters notice discipline.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1B5E20),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static const _checklistItems = [
    _ChecklistItem('Build 2–3 solid projects and push to GitHub', false),
    _ChecklistItem('Solve 100+ LeetCode problems (Easy + Medium)', false),
    _ChecklistItem('Learn core CS subjects: OS, DBMS, Networks, OOP', false),
    _ChecklistItem('Create an ATS-friendly resume (1 page)', false),
    _ChecklistItem('Optimise your LinkedIn profile with keywords', false),
    _ChecklistItem('Practise mock interviews with peers or AI', false),
    _ChecklistItem('Appear in at least 5 real interviews for experience', false),
  ];
}

// Score dial custom painter
class _ScoreDial extends CustomPainter {
  final int score;
  const _ScoreDial({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const startAngle = pi * 0.75;
    const sweepTotal = pi * 1.5;

    // Track
    final trackPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      trackPaint,
    );

    // Fill
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal * (score / 100),
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_ScoreDial old) => old.score != score;
}

// Shared sub-widgets for Overview
class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  const _StatCard({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF9CA3AF))),
          ],
        ),
      ),
    );
  }
}

class _ChecklistItem {
  final String text;
  final bool done;
  const _ChecklistItem(this.text, this.done);
}

class _ChecklistRow extends StatefulWidget {
  final _ChecklistItem item;
  const _ChecklistRow({required this.item});

  @override
  State<_ChecklistRow> createState() => _ChecklistRowState();
}

class _ChecklistRowState extends State<_ChecklistRow> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.item.done;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _checked = !_checked),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _checked
              ? const Color(0xFF7C6FD0).withOpacity(0.07)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _checked
                ? const Color(0xFF7C6FD0).withOpacity(0.3)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _checked
                    ? const Color(0xFF7C6FD0)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _checked
                      ? const Color(0xFF7C6FD0)
                      : const Color(0xFFD1D5DB),
                  width: 1.5,
                ),
              ),
              child: _checked
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.item.text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _checked
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF374151),
                  decoration: _checked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 2 — DSA TRACK
// ═══════════════════════════════════════════════════════════════════════════════

class _DSATab extends StatelessWidget {
  const _DSATab();

  static const _topics = [
    _DSATopic('📦', 'Arrays & Strings', 'Must-do foundation', 25, 'Easy–Medium', const Color(0xFF4A90B8)),
    _DSATopic('🔗', 'Linked Lists', 'Pointer manipulation', 15, 'Easy–Medium', const Color(0xFF7C6FD0)),
    _DSATopic('📚', 'Stacks & Queues', 'LIFO / FIFO patterns', 12, 'Easy', const Color(0xFF27AE60)),
    _DSATopic('🌳', 'Trees & BST', 'Traversals & operations', 20, 'Medium', const Color(0xFFE8593C)),
    _DSATopic('🌐', 'Graphs', 'BFS, DFS, shortest paths', 18, 'Medium–Hard', const Color(0xFFFF9500)),
    _DSATopic('🧠', 'Dynamic Programming', 'Memoisation & tabulation', 20, 'Hard', const Color(0xFFE91E8C)),
    _DSATopic('🔍', 'Searching & Sorting', 'Binary search patterns', 14, 'Easy–Medium', const Color(0xFF00BCD4)),
    _DSATopic('🎯', 'Greedy & Backtracking', 'Optimisation patterns', 10, 'Medium–Hard', const Color(0xFF795548)),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // Banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF7C6FD0).withOpacity(0.25)),
          ),
          child: const Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 18)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Focus on patterns, not just problems. '
                  'Solve 120–150 problems across all topics to be interview-ready.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4338CA),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _SectionTitle('📚 Topic-wise Roadmap'),
        const SizedBox(height: 10),
        ..._topics.map((t) => _DSATopicCard(topic: t)),
      ],
    );
  }
}

class _DSATopic {
  final String emoji;
  final String name;
  final String tagline;
  final int problemCount;
  final String difficulty;
  final Color color;
  const _DSATopic(this.emoji, this.name, this.tagline, this.problemCount, this.difficulty, this.color);
}

class _DSATopicCard extends StatefulWidget {
  final _DSATopic topic;
  const _DSATopicCard({required this.topic});

  @override
  State<_DSATopicCard> createState() => _DSATopicCardState();
}

class _DSATopicCardState extends State<_DSATopicCard> {
  bool _expanded = false;

  // Sample must-do problems per topic
  static const _problems = {
    'Arrays & Strings': ['Two Sum', 'Best Time to Buy & Sell Stock', 'Maximum Subarray (Kadane)', 'Rotate Array', 'Trapping Rain Water'],
    'Linked Lists': ['Reverse Linked List', 'Detect Cycle', 'Merge Two Sorted Lists', 'Find Middle Node', 'Remove N-th from End'],
    'Stacks & Queues': ['Valid Parentheses', 'Min Stack', 'Implement Queue Using Stacks', 'Next Greater Element', 'Sliding Window Maximum'],
    'Trees & BST': ['Inorder/Preorder/Postorder', 'Level Order Traversal', 'Height of Tree', 'Lowest Common Ancestor', 'Validate BST'],
    'Graphs': ['Number of Islands', 'Clone Graph', 'Dijkstra Shortest Path', 'Topological Sort', 'Detect Cycle in Directed Graph'],
    'Dynamic Programming': ['Fibonacci (Memoised)', 'Coin Change', '0/1 Knapsack', 'Longest Common Subsequence', 'Edit Distance'],
    'Searching & Sorting': ['Binary Search variants', 'Search in Rotated Array', 'Merge Sort implementation', 'Quick Sort', 'Kth Largest Element'],
    'Greedy & Backtracking': ['Activity Selection', 'Fractional Knapsack', 'N-Queens', 'Sudoku Solver', 'Permutations & Combinations'],
  };

  @override
  Widget build(BuildContext context) {
    final t = widget.topic;
    final problems = _problems[t.name] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: t.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(t.emoji,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.name,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E))),
                        const SizedBox(height: 2),
                        Text(t.tagline,
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF9CA3AF))),
                      ],
                    ),
                  ),
                  // Problem count + difficulty
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${t.problemCount} problems',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: t.color)),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: t.color.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(t.difficulty,
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: t.color)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 18, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ),

          // Expanded problem list
          if (_expanded) ...[
            Divider(height: 1, color: t.color.withOpacity(0.15)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MUST-DO PROBLEMS',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: t.color,
                          letterSpacing: 1.0)),
                  const SizedBox(height: 8),
                  ...problems.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            color: t.color.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(p,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF374151),
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 3 — INTERVIEW PREP
// ═══════════════════════════════════════════════════════════════════════════════

class _InterviewTab extends StatelessWidget {
  const _InterviewTab();

  static const _rounds = [
    _InterviewRound(
      emoji: '💻',
      title: 'Technical Round 1',
      subtitle: 'DSA & problem solving',
      color: Color(0xFF4A90B8),
      tips: [
        'Think out loud — explain your approach before coding',
        'Start with brute force, then optimise',
        'Always ask clarifying questions first',
        'Discuss time & space complexity for every solution',
        'Write clean, readable code — not just working code',
      ],
      topics: ['Arrays', 'Strings', 'Linked Lists', 'Trees', 'Binary Search'],
    ),
    _InterviewRound(
      emoji: '🧠',
      title: 'Technical Round 2',
      subtitle: 'CS fundamentals & core subjects',
      color: Color(0xFF7C6FD0),
      tips: [
        'Operating Systems: process scheduling, deadlocks, memory management',
        'DBMS: normalisation, joins, indexing, transactions (ACID)',
        'Computer Networks: OSI model, TCP/UDP, HTTP, DNS',
        'OOP: encapsulation, inheritance, polymorphism with examples',
        'Review your projects deeply — expect questions on every line',
      ],
      topics: ['OS', 'DBMS', 'Networks', 'OOP', 'Your Projects'],
    ),
    _InterviewRound(
      emoji: '🏗️',
      title: 'System Design',
      subtitle: 'For SDE-1 & above roles',
      color: Color(0xFFE8593C),
      tips: [
        'Start with requirements: functional vs non-functional',
        'Think scale: how many users, reads vs writes, data size',
        'Common patterns: load balancer, caching, CDN, DB sharding',
        'Know the trade-offs: SQL vs NoSQL, sync vs async',
        'Practice: URL shortener, parking lot, Netflix, WhatsApp',
      ],
      topics: ['Load Balancing', 'Caching', 'Databases', 'Queues', 'Microservices'],
    ),
    _InterviewRound(
      emoji: '🤝',
      title: 'HR Round',
      subtitle: 'Behavioural & culture fit',
      color: Color(0xFF27AE60),
      tips: [
        'Tell me about yourself — keep it 90 seconds, career-focused',
        'Why this company? — research their product, mission & culture',
        'Strengths & weaknesses — be honest, show self-awareness',
        'Use STAR method: Situation, Task, Action, Result',
        'Salary: know your market range, never be the first to say a number',
      ],
      topics: ['Self intro', 'Leadership', 'Conflict', 'Goals', 'Salary negotiation'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        const _SectionTitle('🎤 Interview Rounds Guide'),
        const SizedBox(height: 10),
        ..._rounds.map((r) => _InterviewRoundCard(round: r)),
      ],
    );
  }
}

class _InterviewRound {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final List<String> tips;
  final List<String> topics;
  const _InterviewRound({
    required this.emoji, required this.title, required this.subtitle,
    required this.color, required this.tips, required this.topics,
  });
}

class _InterviewRoundCard extends StatefulWidget {
  final _InterviewRound round;
  const _InterviewRoundCard({required this.round});

  @override
  State<_InterviewRoundCard> createState() => _InterviewRoundCardState();
}

class _InterviewRoundCardState extends State<_InterviewRoundCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.round;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: r.color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: r.color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: r.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                        child: Text(r.emoji,
                            style: const TextStyle(fontSize: 22))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E))),
                        const SizedBox(height: 2),
                        Text(r.subtitle,
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF9CA3AF))),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 20, color: r.color),
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) ...[
            Divider(height: 1, color: r.color.withOpacity(0.15)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topic chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: r.topics.map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: r.color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(t,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: r.color)),
                    )).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text('KEY TIPS',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: r.color,
                          letterSpacing: 1.0)),
                  const SizedBox(height: 8),
                  ...r.tips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 5, height: 5,
                          decoration: BoxDecoration(
                            color: r.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(tip,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF374151),
                                  height: 1.5,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 4 — COMPANIES
// ═══════════════════════════════════════════════════════════════════════════════

class _CompaniesTab extends StatelessWidget {
  const _CompaniesTab();

  static const _sections = [
    _CompanySection('🏆 Big Tech / FAANG+', [
      _CompanyCard('🔵', 'Google', '₹20–45 LPA', 'DSA (Hard), System Design, Googliness', const Color(0xFF4285F4)),
      _CompanyCard('🟠', 'Microsoft', '₹18–40 LPA', 'DSA (Medium–Hard), Problem Solving, Culture', const Color(0xFFFF6B00)),
      _CompanyCard('🟡', 'Amazon', '₹16–35 LPA', 'LP principles, DSA, System Design (distributed)', const Color(0xFFFF9900)),
      _CompanyCard('🔴', 'Adobe', '₹12–28 LPA', 'DSA, CS fundamentals, UI/Product thinking', const Color(0xFFE53935)),
    ]),
    _CompanySection('🚀 Top Indian Product Companies', [
      _CompanyCard('🟣', 'Flipkart', '₹14–32 LPA', 'DSA, System Design, CS core subjects', const Color(0xFF7C6FD0)),
      _CompanyCard('🟠', 'Swiggy / Zomato', '₹12–25 LPA', 'Product thinking, DSA, Backend scaling', const Color(0xFFE8593C)),
      _CompanyCard('🔵', 'Razorpay', '₹14–28 LPA', 'DSA, Fintech basics, System Design', const Color(0xFF3C6AF5)),
      _CompanyCard('🟢', 'Zepto / CRED', '₹12–24 LPA', 'DSA, Culture fit, Fast execution mindset', const Color(0xFF27AE60)),
    ]),
    _CompanySection('🏢 Service / Mass Recruiters', [
      _CompanyCard('🔵', 'TCS', '₹3.5–7 LPA', 'TCS NQT: Aptitude + Coding + Verbal', const Color(0xFF1565C0)),
      _CompanyCard('⚫', 'Infosys', '₹3.5–8 LPA', 'Hackwithinfy: DSA coding rounds', const Color(0xFF424242)),
      _CompanyCard('🔵', 'Wipro', '₹3.5–6.5 LPA', 'WILP/Elite: Online test + interviews', const Color(0xFF0288D1)),
      _CompanyCard('🟡', 'Cognizant', '₹4–8 LPA', 'GENC test: Aptitude + Coding', const Color(0xFF0E5D8A)),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFF9500).withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Text('⚡', style: TextStyle(fontSize: 18)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Target 2–3 companies per tier. '
                  'Don\'t just apply everywhere — deep preparation beats spray-and-pray.',
                  style: TextStyle(
                    fontSize: 12, color: Color(0xFF7B3F00),
                    height: 1.5, fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ..._sections.map((s) => _CompanySectionWidget(section: s)),
      ],
    );
  }
}

class _CompanySection {
  final String title;
  final List<_CompanyCard> companies;
  const _CompanySection(this.title, this.companies);
}

class _CompanyCard {
  final String logoEmoji;
  final String name;
  final String package;
  final String focus;
  final Color color;
  const _CompanyCard(this.logoEmoji, this.name, this.package, this.focus, this.color);
}

class _CompanySectionWidget extends StatelessWidget {
  final _CompanySection section;
  const _CompanySectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(section.title),
        const SizedBox(height: 10),
        ...section.companies.map((c) => _CompanyRow(card: c)),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _CompanyRow extends StatelessWidget {
  final _CompanyCard card;
  const _CompanyRow({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: card.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(card.logoEmoji,
                  style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(card.name,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: card.color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(card.package,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: card.color)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(card.focus,
                    style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared section title ─────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
}
