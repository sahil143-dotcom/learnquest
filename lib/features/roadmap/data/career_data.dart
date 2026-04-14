import '../models/career_model.dart';
import '../../../core/theme/app_theme.dart';

// ─── Career Data ──────────────────────────────────────────────────────────────
// All career content lives here. Each Milestone now includes:
//   topics   → specific things you'll learn
//   tools    → tools/technologies you'll use
//   outcome  → what you'll be able to do after completing it

const List<CareerModel> careerList = [

  // ── AI / Data Science ───────────────────────────────────────────────────────
  CareerModel(
    id: 'ai',
    emoji: '🤖',
    title: 'AI / Data Science',
    subtitle: 'Models & intelligent systems',
    badge: 'High demand',
    accentColor: AppColors.aiAccent,
    backgroundColor: AppColors.aiBg,
    description:
        'AI is about teaching computers to think and learn from data. '
        'You build systems that recognise faces, predict the weather, '
        'recommend movies — all without being explicitly programmed for each task.',
    realWorldExamples: [
      'Netflix recommending what to watch next',
      'Google Translate converting languages in real time',
      'Doctors using AI to detect cancer in scans',
      'Chatbots that understand your questions',
    ],
    skills: ['Python', 'Math basics', 'Statistics', 'Pandas / NumPy', 'Scikit-learn'],
    whoIsItFor:
        'Perfect if you love problem-solving with numbers, enjoy research, '
        'and want to work at the cutting edge of technology. '
        'Curiosity matters more than being a maths genius.',
    roadmapLevels: [
      RoadmapLevel(
        tier: LevelTier.beginner,
        milestones: [
          Milestone(
            number: 1,
            title: 'Python Fundamentals',
            description: 'Variables, loops, functions, lists. The language everything AI runs on.',
            taskCount: 4,
            resourceCount: 5,
            isActive: true,
            isLocked: false,
            topics: [
              'Variables & data types',
              'Loops & conditionals',
              'Functions & modules',
              'Lists, dicts & sets',
              'File handling basics',
              'Object-oriented basics',
            ],
            tools: ['Python 3', 'VSCode', 'Jupyter Notebook', 'Google Colab'],
            outcome: 'Write Python scripts to automate tasks and process data confidently.',
          ),
          Milestone(
            number: 2,
            title: 'Data with Pandas',
            description: 'Read CSVs, clean data, ask questions with code. Your first real analysis.',
            taskCount: 5,
            resourceCount: 4,
            topics: [
              'Loading CSV & Excel files',
              'Filtering & sorting data',
              'GroupBy & aggregations',
              'Handling missing values',
              'Basic charts with Matplotlib',
              'Merging DataFrames',
            ],
            tools: ['Pandas', 'NumPy', 'Matplotlib', 'Google Colab'],
            outcome: 'Clean and analyse real-world datasets independently.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.intermediate,
        milestones: [
          Milestone(
            number: 3,
            title: 'Math for ML',
            description: 'Statistics, probability, linear algebra — only what you actually need.',
            taskCount: 6,
            resourceCount: 5,
            topics: [
              'Mean, median & standard deviation',
              'Probability & Bayes theorem',
              'Vectors & matrix operations',
              'Gradient & derivatives (intuition)',
              'Correlation vs causation',
            ],
            tools: ['NumPy', 'Khan Academy', 'Desmos', 'Wolfram Alpha'],
            outcome: 'Understand *why* ML algorithms work, not just how to run them.',
          ),
          Milestone(
            number: 4,
            title: 'Your First ML Model',
            description: 'Train a classifier with scikit-learn. Predict, evaluate, improve.',
            taskCount: 7,
            resourceCount: 6,
            topics: [
              'Train / test splits',
              'Linear & logistic regression',
              'Decision trees & random forests',
              'Model evaluation (accuracy, F1, ROC)',
              'Overfitting & regularisation',
            ],
            tools: ['Scikit-learn', 'Pandas', 'Matplotlib', 'Google Colab'],
            outcome: 'Build, train, and evaluate a classification model from scratch.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.advanced,
        milestones: [
          Milestone(
            number: 5,
            title: 'Deep Learning & Neural Nets',
            description: 'TensorFlow or PyTorch. Build image classifiers and NLP models.',
            taskCount: 8,
            resourceCount: 7,
            topics: [
              'How neural networks work',
              'Backpropagation (intuition)',
              'CNNs for image recognition',
              'RNNs & transformers intro',
              'Transfer learning with pretrained models',
            ],
            tools: ['TensorFlow / PyTorch', 'Keras', 'Hugging Face', 'GPU Colab'],
            outcome: 'Build image classifiers and fine-tune pretrained language models.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.placementReady,
        milestones: [
          Milestone(
            number: 6,
            title: 'Projects + Interview Prep',
            description: 'Build 3 end-to-end ML projects. Crack data science interviews.',
            taskCount: 10,
            resourceCount: 8,
            topics: [
              'End-to-end ML project pipeline',
              'Model deployment with Flask / FastAPI',
              'GitHub portfolio setup',
              'DS interview patterns & case studies',
              'System design for ML pipelines',
            ],
            tools: ['Flask', 'FastAPI', 'Heroku / Render', 'GitHub', 'LeetCode'],
            outcome: 'Land your first data science or ML engineer role.',
          ),
        ],
      ),
    ],
  ),

  // ── Web Development ──────────────────────────────────────────────────────────
  CareerModel(
    id: 'web',
    emoji: '🌐',
    title: 'Web Development',
    subtitle: 'Frontend & backend',
    badge: 'Easiest to start',
    accentColor: AppColors.webAccent,
    backgroundColor: AppColors.webBg,
    description:
        'Web dev is building everything you see on the internet — websites, '
        'dashboards, e-commerce stores. You create what users see (frontend) '
        'and the logic behind the scenes (backend).',
    realWorldExamples: [
      "Zomato's food ordering website",
      'Your college admission portal',
      "Instagram's web version",
      'Building your own portfolio site',
    ],
    skills: ['HTML & CSS', 'JavaScript', 'React / Vue', 'Node.js', 'Databases'],
    whoIsItFor:
        'Great for creative people who want to see results fast. '
        'You will build things people actually use within weeks of starting. '
        'One of the most in-demand and freelance-friendly skills.',
    roadmapLevels: [
      RoadmapLevel(
        tier: LevelTier.beginner,
        milestones: [
          Milestone(
            number: 1,
            title: 'HTML & CSS Fundamentals',
            description: 'Build static pages, learn box model, flexbox and responsive design.',
            taskCount: 3,
            resourceCount: 5,
            isActive: true,
            isLocked: false,
            topics: [
              'HTML tags & semantic structure',
              'CSS selectors & specificity',
              'Box model & flexbox',
              'CSS Grid layout',
              'Responsive design & media queries',
              'CSS variables & animations',
            ],
            tools: ['VSCode', 'Chrome DevTools', 'CodePen', 'Figma (basics)'],
            outcome: 'Build responsive, pixel-perfect static websites from scratch.',
          ),
          Milestone(
            number: 2,
            title: 'JavaScript Basics',
            description: 'Variables, functions, DOM manipulation, events and ES6+.',
            taskCount: 5,
            resourceCount: 4,
            topics: [
              'Variables, scope & hoisting',
              'Functions & arrow functions',
              'DOM manipulation',
              'Events & callbacks',
              'ES6+ (let/const, spread, destructuring)',
              'Fetch API & promises',
            ],
            tools: ['Browser console', 'VSCode', 'Node.js'],
            outcome: 'Add interactivity and dynamic behaviour to any web page.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.intermediate,
        milestones: [
          Milestone(
            number: 3,
            title: 'React.js',
            description: 'Component-based UI, state management, hooks and routing.',
            taskCount: 8,
            resourceCount: 6,
            topics: [
              'Components & JSX',
              'Props & state',
              'useState & useEffect hooks',
              'React Router v6',
              'Context API & global state',
              'Fetching data with useEffect',
            ],
            tools: ['React', 'Vite', 'npm / yarn', 'React DevTools'],
            outcome: 'Build complete multi-page interactive web apps with React.',
          ),
          Milestone(
            number: 4,
            title: 'Backend with Node.js',
            description: 'REST APIs, Express, databases (MongoDB/SQL), authentication.',
            taskCount: 6,
            resourceCount: 5,
            topics: [
              'Node.js runtime & modules',
              'Express routing & middleware',
              'REST API design principles',
              'MongoDB / SQL basics',
              'JWT authentication',
              'Environment variables & security',
            ],
            tools: ['Node.js', 'Express', 'MongoDB', 'Postman', 'JWT'],
            outcome: 'Build and secure full-stack REST APIs with authentication.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.advanced,
        milestones: [
          Milestone(
            number: 5,
            title: 'Full Stack Projects',
            description: 'Build 3 complete projects with deployment and real users.',
            taskCount: 8,
            resourceCount: 5,
            topics: [
              'Connecting frontend to backend',
              'Handling env variables & secrets',
              'Deployment to Vercel / Railway',
              'Error handling & logging',
              'Performance optimisation basics',
              'Version control best practices',
            ],
            tools: ['Vercel', 'Railway / Render', 'Git', 'GitHub', 'MongoDB Atlas'],
            outcome: 'Deploy 3 live full-stack projects accessible to real users.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.placementReady,
        milestones: [
          Milestone(
            number: 6,
            title: 'DSA + Interview Prep',
            description: 'Data structures, system design and mock interviews.',
            taskCount: 10,
            resourceCount: 7,
            topics: [
              'Arrays, strings & hashmaps',
              'Recursion & backtracking',
              'System design basics',
              'Portfolio site & GitHub profile',
              'Mock interview practice',
              'Negotiating your first offer',
            ],
            tools: ['LeetCode', 'Excalidraw', 'GitHub', 'LinkedIn'],
            outcome: 'Crack frontend / full-stack interviews at product companies.',
          ),
        ],
      ),
    ],
  ),

  // ── App Development ──────────────────────────────────────────────────────────
  CareerModel(
    id: 'app',
    emoji: '📱',
    title: 'App Development',
    subtitle: 'Flutter & mobile',
    badge: "You're using one now",
    accentColor: AppColors.appAccent,
    backgroundColor: AppColors.appBg,
    description:
        'App dev means building mobile applications you download from the Play Store '
        'or App Store. Flutter lets you build for both Android and iOS '
        'with one single codebase.',
    realWorldExamples: [
      'Building apps like Swiggy or PhonePe',
      'Your own startup app idea',
      'Fitness trackers and productivity tools',
      'Games and educational apps',
    ],
    skills: ['Flutter', 'Dart language', 'Firebase', 'UI/UX basics', 'State management'],
    whoIsItFor:
        "If you love using apps and have ever thought 'I wish there was an app "
        "for this' — this is for you. Flutter is beginner-friendly and you "
        'get to see your app running on a real phone.',
    roadmapLevels: [
      RoadmapLevel(
        tier: LevelTier.beginner,
        milestones: [
          Milestone(
            number: 1,
            title: 'Dart Basics',
            description: 'The language Flutter runs on. Variables, classes, null safety.',
            taskCount: 4,
            resourceCount: 4,
            isActive: true,
            isLocked: false,
            topics: [
              'Variables & null safety',
              'Functions & closures',
              'Classes & objects',
              'Lists & maps',
              'Async / await & Futures',
              'Error handling & exceptions',
            ],
            tools: ['DartPad', 'VSCode', 'Dart SDK'],
            outcome: 'Write clean, null-safe Dart code with confidence.',
          ),
          Milestone(
            number: 2,
            title: 'Flutter Widgets',
            description: 'Everything in Flutter is a widget. Learn the core building blocks.',
            taskCount: 5,
            resourceCount: 5,
            topics: [
              'Stateless vs Stateful widgets',
              'Row, Column & Stack layouts',
              'ListView & GridView',
              'Navigation & named routes',
              'Forms & user input',
              'Themes & custom styling',
            ],
            tools: ['Flutter SDK', 'Android Studio', 'Flutter DevTools'],
            outcome: 'Build complete multi-screen Flutter app UIs from scratch.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.intermediate,
        milestones: [
          Milestone(
            number: 3,
            title: 'State Management',
            description: 'Provider or Riverpod. Make your app react to data changes.',
            taskCount: 6,
            resourceCount: 4,
            topics: [
              'Why setState is not enough',
              'Provider pattern basics',
              'Riverpod providers & consumers',
              'Watching vs reading state',
              'Global vs local state',
              'Async providers & FutureProvider',
            ],
            tools: ['flutter_riverpod', 'VSCode', 'Flutter DevTools'],
            outcome: 'Manage complex app state cleanly across all screens.',
          ),
          Milestone(
            number: 4,
            title: 'Firebase Integration',
            description: 'Auth, Firestore, Storage — add a real backend to your app.',
            taskCount: 7,
            resourceCount: 5,
            topics: [
              'Firebase Auth (email + Google)',
              'Firestore CRUD operations',
              'Real-time streams & listeners',
              'Firebase Storage for media',
              'Security rules basics',
              'FlutterFire CLI setup',
            ],
            tools: ['Firebase', 'FlutterFire CLI', 'Cloud Firestore', 'Firebase Auth'],
            outcome: 'Add real authentication and a live database to your Flutter app.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.advanced,
        milestones: [
          Milestone(
            number: 5,
            title: 'Publish to Play Store',
            description: 'Sign, build, and release your app to real users.',
            taskCount: 5,
            resourceCount: 4,
            topics: [
              'App signing & keystore generation',
              'Build release APK / AAB',
              'Google Play Console setup',
              'Store listing, screenshots & icon',
              'Crash reporting with Firebase',
              'App versioning strategy',
            ],
            tools: ['Google Play Console', 'Firebase Crashlytics', 'Gradle', 'Canva'],
            outcome: 'Get your app live on the Play Store with real users downloading it.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.placementReady,
        milestones: [
          Milestone(
            number: 6,
            title: 'Portfolio + Interviews',
            description: 'Three polished apps. Prepare for Flutter developer interviews.',
            taskCount: 8,
            resourceCount: 6,
            topics: [
              'Clean architecture (feature-first)',
              'Flutter-specific interview Q&A',
              'Performance & widget tree optimisation',
              'GitHub profile & README setup',
              'Freelance vs job search strategy',
              'Building in public on LinkedIn',
            ],
            tools: ['GitHub', 'LinkedIn', 'Portfolio site', 'LeetCode (Dart)'],
            outcome: 'Land your first Flutter developer role or freelance client.',
          ),
        ],
      ),
    ],
  ),

  // ── Cloud & DevOps ───────────────────────────────────────────────────────────
  CareerModel(
    id: 'cloud',
    emoji: '☁️',
    title: 'Cloud & DevOps',
    subtitle: 'AWS, Docker & infra',
    badge: 'High salary',
    accentColor: AppColors.cloudAccent,
    backgroundColor: AppColors.cloudBg,
    description:
        'Cloud engineers make sure apps run reliably for millions of users. '
        'You manage servers, automate deployments, and ensure nothing crashes. '
        "It's the backbone that powers every app you use.",
    realWorldExamples: [
      'How Hotstar streams IPL to 50M people simultaneously',
      'Automatic app updates without downtime',
      'Scaling a startup from 10 to 10 million users',
      'Setting up secure cloud infrastructure',
    ],
    skills: ['Linux basics', 'AWS / GCP', 'Docker', 'CI/CD pipelines', 'Kubernetes'],
    whoIsItFor:
        'Best for people who enjoy systems thinking, love making things efficient, '
        'and want high-paying jobs with remote work potential. '
        "It's not about pretty UIs — it's about powerful infrastructure.",
    roadmapLevels: [
      RoadmapLevel(
        tier: LevelTier.beginner,
        milestones: [
          Milestone(
            number: 1,
            title: 'Linux Command Line',
            description: 'Navigate files, run scripts, manage processes. The foundation of DevOps.',
            taskCount: 4,
            resourceCount: 4,
            isActive: true,
            isLocked: false,
            topics: [
              'File system navigation (ls, cd, pwd)',
              'File permissions & chmod',
              'Process management (ps, kill, top)',
              'Shell scripting basics',
              'SSH & remote server access',
              'Package management (apt, yum)',
            ],
            tools: ['Ubuntu / WSL2', 'Bash', 'Terminal', 'VirtualBox'],
            outcome: 'Operate and manage Linux servers with confidence.',
          ),
          Milestone(
            number: 2,
            title: 'Git & Version Control',
            description: 'Track code changes, collaborate, and never lose work again.',
            taskCount: 3,
            resourceCount: 3,
            topics: [
              'Init, add, commit & push',
              'Branching & merging strategies',
              'Resolving merge conflicts',
              'Pull requests & code review',
              '.gitignore & repo best practices',
              'Git rebase vs merge',
            ],
            tools: ['Git', 'GitHub', 'VSCode Git integration'],
            outcome: 'Collaborate on code and manage project history professionally.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.intermediate,
        milestones: [
          Milestone(
            number: 3,
            title: 'Docker & Containers',
            description: 'Package apps so they run anywhere. The heart of modern DevOps.',
            taskCount: 6,
            resourceCount: 5,
            topics: [
              'What containers solve vs VMs',
              'Writing a Dockerfile',
              'Build, run & tag images',
              'Docker Compose for multi-service apps',
              'Volumes & persistent storage',
              'Docker networking basics',
            ],
            tools: ['Docker Desktop', 'Docker Hub', 'Docker Compose', 'Portainer'],
            outcome: 'Package any application to run identically on any machine.',
          ),
          Milestone(
            number: 4,
            title: 'AWS Fundamentals',
            description: 'EC2, S3, Lambda, RDS. Host real projects on the cloud.',
            taskCount: 7,
            resourceCount: 6,
            topics: [
              'IAM users, roles & policies',
              'EC2 instances & SSH access',
              'S3 storage & static site hosting',
              'RDS & managed databases',
              'Lambda serverless functions',
              'VPC & security groups',
            ],
            tools: ['AWS Free Tier', 'AWS CLI', 'CloudWatch', 'Terraform (intro)'],
            outcome: 'Deploy and manage real applications on AWS cloud infrastructure.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.advanced,
        milestones: [
          Milestone(
            number: 5,
            title: 'CI/CD & Kubernetes',
            description: 'Automate deployments. Orchestrate containers at scale.',
            taskCount: 8,
            resourceCount: 6,
            topics: [
              'GitHub Actions pipeline setup',
              'Automated tests in CI',
              'Kubernetes pods & services',
              'Deployments & rolling updates',
              'ConfigMaps & Secrets',
              'Helm charts for packaging',
            ],
            tools: ['GitHub Actions', 'Kubernetes (k8s)', 'kubectl', 'Helm', 'ArgoCD'],
            outcome: 'Automate deployments and scale containerised apps with zero downtime.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.placementReady,
        milestones: [
          Milestone(
            number: 6,
            title: 'Certifications + Interviews',
            description: 'AWS Solutions Architect cert + DevOps interview prep.',
            taskCount: 8,
            resourceCount: 7,
            topics: [
              'AWS SAA-C03 exam domains',
              'DevOps scenario & design questions',
              'Infrastructure cost optimisation',
              'Incident response & on-call basics',
              'Monitoring & alerting (CloudWatch, Grafana)',
              'Resume & LinkedIn for cloud roles',
            ],
            tools: ['A Cloud Guru', 'AWS Practice Exams', 'Excalidraw', 'LinkedIn'],
            outcome: 'Pass AWS Solutions Architect and land a cloud / DevOps engineer role.',
          ),
        ],
      ),
    ],
  ),

  // ── Data Science ─────────────────────────────────────────────────────────────
  CareerModel(
    id: 'datasci',
    emoji: '📊',
    title: 'Data Science',
    subtitle: 'Analytics & visualization',
    badge: 'Growing fast',
    accentColor: AppColors.dsAccent,
    backgroundColor: AppColors.dsBg,
    description:
        'Data scientists turn raw numbers into business decisions. '
        'You analyse patterns, build dashboards, and tell stories with data '
        'that help companies make smarter choices.',
    realWorldExamples: [
      'Flipkart deciding which products to promote',
      'Government tracking disease outbreaks',
      'Sports teams analysing player performance',
      'Banks detecting fraudulent transactions',
    ],
    skills: ['Python / R', 'SQL', 'Tableau / Power BI', 'Statistics', 'Excel advanced'],
    whoIsItFor:
        'Great if you love finding patterns and translating numbers into stories. '
        'Strong career in banking, healthcare, e-commerce, and government. '
        'More approachable than pure ML — business-facing and high impact.',
    roadmapLevels: [
      RoadmapLevel(
        tier: LevelTier.beginner,
        milestones: [
          Milestone(
            number: 1,
            title: 'SQL & Databases',
            description: 'Query, filter, and aggregate data from real databases.',
            taskCount: 4,
            resourceCount: 4,
            isActive: true,
            isLocked: false,
            topics: [
              'SELECT, WHERE & ORDER BY',
              'JOINs (inner, left, right, full)',
              'GROUP BY & aggregate functions',
              'Subqueries & CTEs',
              'Window functions (RANK, ROW_NUMBER)',
              'Indexing & query performance basics',
            ],
            tools: ['MySQL / PostgreSQL', 'DB Browser for SQLite', 'SQLZoo', 'Mode Analytics'],
            outcome: 'Query any database and answer business questions with SQL fluently.',
          ),
          Milestone(
            number: 2,
            title: 'Python for Data',
            description: 'Pandas, NumPy, and Matplotlib for real analysis workflows.',
            taskCount: 5,
            resourceCount: 5,
            topics: [
              'Pandas DataFrames & Series',
              'NumPy arrays & operations',
              'Matplotlib & Seaborn charts',
              'Data cleaning workflows',
              'Merging & reshaping datasets',
              'Exploratory data analysis (EDA)',
            ],
            tools: ['Python', 'Pandas', 'NumPy', 'Matplotlib', 'Jupyter Notebook'],
            outcome: 'Clean, explore and visualise datasets end-to-end in Python.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.intermediate,
        milestones: [
          Milestone(
            number: 3,
            title: 'Statistics & Probability',
            description: 'Hypothesis testing, A/B testing, confidence intervals.',
            taskCount: 5,
            resourceCount: 5,
            topics: [
              'Descriptive statistics (mean, std, IQR)',
              'Probability distributions (normal, binomial)',
              'Hypothesis testing (t-test, chi-square)',
              'A/B testing framework',
              'Confidence intervals & p-values',
              'Correlation & causation',
            ],
            tools: ['SciPy', 'Statsmodels', 'Python', 'Google Sheets'],
            outcome: 'Make data-driven decisions backed by statistical evidence.',
          ),
          Milestone(
            number: 4,
            title: 'Dashboards & Visualisation',
            description: 'Build interactive dashboards in Tableau or Power BI.',
            taskCount: 6,
            resourceCount: 4,
            topics: [
              'Connecting to data sources',
              'Chart selection & design principles',
              'Calculated fields & filters',
              'Drill-down & interactive views',
              'Designing for non-technical stakeholders',
              'Publishing & embedding dashboards',
            ],
            tools: ['Tableau Public', 'Power BI Desktop', 'Looker Studio', 'Figma'],
            outcome: 'Build executive-ready dashboards from raw data in hours.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.advanced,
        milestones: [
          Milestone(
            number: 5,
            title: 'Predictive Modelling',
            description: 'Build forecasting models. Deploy them into real products.',
            taskCount: 7,
            resourceCount: 6,
            topics: [
              'Feature engineering & selection',
              'Regression & classification models',
              'Time series forecasting (ARIMA, Prophet)',
              'Model evaluation metrics',
              'Deploying models via Streamlit / FastAPI',
              'Monitoring model drift',
            ],
            tools: ['Scikit-learn', 'XGBoost', 'Streamlit', 'FastAPI', 'Prophet'],
            outcome: 'Build and deploy forecasting models that drive real business decisions.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.placementReady,
        milestones: [
          Milestone(
            number: 6,
            title: 'Capstone Projects + Interviews',
            description: 'Three real-world data projects. Crack analyst interviews.',
            taskCount: 9,
            resourceCount: 7,
            topics: [
              'End-to-end data project lifecycle',
              'Communicating insights to stakeholders',
              'SQL + Python interview patterns',
              'Case study approach & frameworks',
              'Resume & portfolio for analysts',
              'LinkedIn optimisation for data roles',
            ],
            tools: ['Kaggle', 'GitHub', 'Tableau', 'Notion portfolio', 'LinkedIn'],
            outcome: 'Land your first data analyst or junior data scientist role.',
          ),
        ],
      ),
    ],
  ),

  // ── Cybersecurity ────────────────────────────────────────────────────────────
  CareerModel(
    id: 'cybersec',
    emoji: '🔐',
    title: 'Cybersecurity',
    subtitle: 'Ethical hacking & networks',
    badge: 'Always in demand',
    accentColor: AppColors.cyberAccent,
    backgroundColor: AppColors.cyberBg,
    description:
        'Cybersecurity professionals protect systems from hackers and data breaches. '
        'You think like an attacker to build better defences — '
        'one of the most exciting and well-paid fields in tech.',
    realWorldExamples: [
      'Finding security vulnerabilities before hackers do',
      'Protecting bank systems from fraud',
      'Setting up VPNs and firewalls for companies',
      'Responding to live cyberattacks',
    ],
    skills: ['Networking basics', 'Linux', 'Python scripting', 'Ethical hacking tools', 'Cryptography'],
    whoIsItFor:
        'Perfect for people who love puzzles, are naturally curious about how things break, '
        'and want a career that feels like a detective game. '
        'High demand in government, banking, and every large tech company.',
    roadmapLevels: [
      RoadmapLevel(
        tier: LevelTier.beginner,
        milestones: [
          Milestone(
            number: 1,
            title: 'Networking Fundamentals',
            description: 'IP, DNS, TCP/IP, HTTP. How the internet actually works.',
            taskCount: 4,
            resourceCount: 4,
            isActive: true,
            isLocked: false,
            topics: [
              'OSI model & its 7 layers',
              'IP addressing & subnetting (CIDR)',
              'DNS, DHCP & HTTP/S protocols',
              'TCP/IP three-way handshake',
              'Packet analysis with Wireshark',
              'Firewalls & NAT basics',
            ],
            tools: ['Wireshark', 'Cisco Packet Tracer', 'Nmap', 'TryHackMe'],
            outcome: 'Understand how data travels across networks and spot anomalies.',
          ),
          Milestone(
            number: 2,
            title: 'Linux for Security',
            description: 'Command line, file permissions, process management.',
            taskCount: 4,
            resourceCount: 4,
            topics: [
              'File permissions & ACLs',
              'User & group management',
              'Cron jobs & background services',
              'Log analysis (auth.log, syslog)',
              'Bash scripting for automation',
              'Hardening a Linux server',
            ],
            tools: ['Kali Linux', 'Ubuntu', 'Bash', 'TryHackMe'],
            outcome: 'Operate and harden Linux systems like a security professional.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.intermediate,
        milestones: [
          Milestone(
            number: 3,
            title: 'Ethical Hacking Basics',
            description: 'Kali Linux, Nmap, Metasploit. Legal penetration testing.',
            taskCount: 7,
            resourceCount: 6,
            topics: [
              'Reconnaissance & OSINT techniques',
              'Port scanning with Nmap',
              'Exploitation with Metasploit',
              'Password cracking (Hashcat, John)',
              'Post-exploitation & cleanup',
              'Writing a pentest report',
            ],
            tools: ['Kali Linux', 'Metasploit', 'Nmap', 'Hashcat', 'TryHackMe'],
            outcome: 'Perform basic penetration tests on authorised systems legally.',
          ),
          Milestone(
            number: 4,
            title: 'Web Application Security',
            description: 'OWASP Top 10. Find and fix common web vulnerabilities.',
            taskCount: 6,
            resourceCount: 5,
            topics: [
              'OWASP Top 10 vulnerabilities',
              'SQL injection detection & prevention',
              'XSS & CSRF attacks',
              'Broken authentication patterns',
              'Security testing with Burp Suite',
              'Responsible disclosure process',
            ],
            tools: ['Burp Suite Community', 'OWASP WebGoat', 'DVWA', 'ZAP Proxy'],
            outcome: 'Identify and remediate the most common web application vulnerabilities.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.advanced,
        milestones: [
          Milestone(
            number: 5,
            title: 'CTF Challenges & Bug Bounty',
            description: 'Compete in capture-the-flag. Find real bugs and earn rewards.',
            taskCount: 8,
            resourceCount: 6,
            topics: [
              'CTF platform walkthroughs (Hack The Box)',
              'Reverse engineering basics',
              'Binary exploitation intro',
              'Bug bounty scoping & methodology',
              'Writing a professional bug report',
              'Reading CVE advisories',
            ],
            tools: ['HackTheBox', 'TryHackMe', 'CTFtime', 'HackerOne', 'Ghidra'],
            outcome: 'Solve intermediate CTFs and file your first bug bounty report.',
          ),
        ],
      ),
      RoadmapLevel(
        tier: LevelTier.placementReady,
        milestones: [
          Milestone(
            number: 6,
            title: 'CEH Cert + Interviews',
            description: 'Certified Ethical Hacker exam prep and security interviews.',
            taskCount: 8,
            resourceCount: 7,
            topics: [
              'CEH v12 exam domains overview',
              'Security operations centre (SOC) basics',
              'Incident response lifecycle',
              'Blue team vs red team roles',
              'Security interview Q&A patterns',
              'Building your security portfolio',
            ],
            tools: ['EC-Council materials', 'Practice exams', 'Hack The Box Pro', 'LinkedIn'],
            outcome: 'Pass the CEH certification and land a security analyst role.',
          ),
        ],
      ),
    ],
  ),
];

// Helper — find a career by its id string
CareerModel findCareerById(String id) =>
    careerList.firstWhere((c) => c.id == id);
