// ─── App Routes ─────────────────────────────────────────────────────────────
// All named routes in one place. Use these constants everywhere —
// never hardcode string paths like '/login' in widgets.

class AppRoutes {
  AppRoutes._();

  static const onboarding     = '/';
  static const login          = '/login';
  static const welcome        = '/welcome';
  static const domainSelect   = '/domain-select';
  static const branchSelect   = '/branch-select';   // NEW: Engineering branches
  static const specialization = '/specialization';
  static const roadmapLoading = '/roadmap-loading';
  static const roadmap        = '/roadmap';
  static const artifacts      = '/artifacts';
  static const placementPrep  = '/placement-prep';  // NEW: Placement Prep hub
}
