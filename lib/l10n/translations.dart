/// Simple localization helper — maps keys to English and Arabic strings.
/// Usage: `tr(context, 'key')` — returns the translated string.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/settings_provider.dart';

String tr(BuildContext context, String key) {
  final lang = Localizations.maybeLocaleOf(context)?.languageCode ?? context.read<SettingsProvider>().language;
  final map = _translations[key];
  if (map == null) return key;
  return map[lang] ?? map['en'] ?? key;
}

String localizedAuthMessage(BuildContext context, String message) {
  final key = _authMessageKeys[message];
  return key == null ? message : tr(context, key);
}

String taskPriorityLabel(BuildContext context, TaskPriority priority) {
  switch (priority) {
    case TaskPriority.urgent:
      return tr(context, 'urgent');
    case TaskPriority.medium:
      return tr(context, 'medium');
    case TaskPriority.low:
      return tr(context, 'low');
  }
}

String taskCategoryLabel(BuildContext context, TaskCategory category) {
  switch (category) {
    case TaskCategory.work:
      return tr(context, 'work');
    case TaskCategory.personal:
      return tr(context, 'personal');
    case TaskCategory.health:
      return tr(context, 'health');
    case TaskCategory.study:
      return tr(context, 'study');
    case TaskCategory.finance:
      return tr(context, 'finance');
  }
}

const Map<String, Map<String, String>> _translations = {
  // ─── General ─────────────────────────────
  'app_name': {'en': 'TaskFlow', 'ar': 'تاسك فلو'},
  'search_tasks': {'en': 'Search tasks...', 'ar': 'ابحث عن مهام...'},
  'cancel': {'en': 'Cancel', 'ar': 'إلغاء'},
  'delete': {'en': 'Delete', 'ar': 'حذف'},
  'save': {'en': 'Save Changes', 'ar': 'حفظ التغييرات'},
  'or': {'en': 'or', 'ar': 'أو'},

  // ─── Auth ────────────────────────────────
  'welcome_back': {'en': 'Welcome Back', 'ar': 'مرحباً بعودتك'},
  'sign_in_subtitle': {'en': 'Sign in to continue with TaskFlow', 'ar': 'سجل الدخول للمتابعة مع تاسك فلو'},
  'sign_in': {'en': 'Sign In', 'ar': 'تسجيل الدخول'},
  'sign_up': {'en': 'Sign Up', 'ar': 'إنشاء حساب'},
  'create_account': {'en': 'Create Account', 'ar': 'إنشاء حساب'},
  'create_account_subtitle': {'en': 'Sign up to get started with TaskFlow', 'ar': 'سجل للبدء مع تاسك فلو'},
  'no_account': {'en': "Don't have an account? ", 'ar': 'ليس لديك حساب؟ '},
  'have_account': {'en': 'Already have an account? ', 'ar': 'لديك حساب بالفعل؟ '},
  'forgot_password': {'en': 'Forgot Password?', 'ar': 'نسيت كلمة المرور؟'},
  'reset_password': {'en': 'Reset Password', 'ar': 'إعادة تعيين كلمة المرور'},
  'reset_subtitle': {'en': 'Enter your email and a new password', 'ar': 'أدخل بريدك الإلكتروني وكلمة مرور جديدة'},
  'reset_success': {'en': 'Password Reset Successfully!', 'ar': 'تم إعادة تعيين كلمة المرور بنجاح!'},
  'reset_success_msg': {'en': 'You can now sign in with your new password.', 'ar': 'يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.'},
  'back_to_sign_in': {'en': 'Back to Sign In', 'ar': 'العودة لتسجيل الدخول'},
  'full_name': {'en': 'Full Name', 'ar': 'الاسم الكامل'},
  'email': {'en': 'Email', 'ar': 'البريد الإلكتروني'},
  'password': {'en': 'Password', 'ar': 'كلمة المرور'},
  'confirm_password': {'en': 'Confirm Password', 'ar': 'تأكيد كلمة المرور'},
  'new_password': {'en': 'New Password', 'ar': 'كلمة المرور الجديدة'},
  'confirm_new_password': {'en': 'Confirm New Password', 'ar': 'تأكيد كلمة المرور الجديدة'},
  'enter_name': {'en': 'Enter your full name', 'ar': 'أدخل اسمك الكامل'},
  'enter_email': {'en': 'Enter your email', 'ar': 'أدخل بريدك الإلكتروني'},
  'enter_password': {'en': 'Enter your password', 'ar': 'أدخل كلمة المرور'},
  'min_6_chars': {'en': 'Min 6 characters', 'ar': 'على الأقل 6 أحرف'},
  'reenter_password': {'en': 'Re-enter your password', 'ar': 'أعد إدخال كلمة المرور'},
  'reenter_new_password': {'en': 'Re-enter password', 'ar': 'أعد إدخال كلمة المرور'},
  'email_required': {'en': 'Email is required', 'ar': 'البريد الإلكتروني مطلوب'},
  'valid_email_required': {'en': 'Enter a valid email', 'ar': 'أدخل بريدًا إلكترونيًا صالحًا'},
  'password_required': {'en': 'Password is required', 'ar': 'كلمة المرور مطلوبة'},
  'password_min_6': {'en': 'Password must be at least 6 characters', 'ar': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل'},
  'account_not_found': {'en': 'No account found with this email', 'ar': 'لا يوجد حساب بهذا البريد الإلكتروني'},
  'incorrect_password': {'en': 'Incorrect password', 'ar': 'كلمة المرور غير صحيحة'},
  'generic_error_retry': {'en': 'Something went wrong. Please try again.', 'ar': 'حدث خطأ ما. الرجاء المحاولة مرة أخرى.'},

  // ─── Home ────────────────────────────────
  'good_morning': {'en': 'Good Morning', 'ar': 'صباح الخير'},
  'good_afternoon': {'en': 'Good Afternoon', 'ar': 'مساء الخير'},
  'good_evening': {'en': 'Good Evening', 'ar': 'مساء الخير'},
  'pending_prefix': {'en': 'You have ', 'ar': 'لديك '},
  'pending_suffix_one': {'en': ' pending task', 'ar': ' مهمة معلقة'},
  'pending_suffix_many': {'en': ' pending tasks', 'ar': ' مهام معلقة'},
  'pending_end': {'en': ' to handle today.', 'ar': ' للتعامل معها اليوم.'},
  'categories': {'en': 'Categories', 'ar': 'الفئات'},
  'priority_tasks': {'en': 'Priority Tasks', 'ar': 'المهام ذات الأولوية'},
  'tasks_label': {'en': 'tasks', 'ar': 'مهام'},

  // ─── Categories ──────────────────────────
  'work': {'en': 'Work', 'ar': 'عمل'},
  'personal': {'en': 'Personal', 'ar': 'شخصي'},
  'health': {'en': 'Health', 'ar': 'صحة'},
  'study': {'en': 'Study', 'ar': 'دراسة'},
  'finance': {'en': 'Finance', 'ar': 'مالية'},

  // ─── Weekly Performance ──────────────────
  'weekly_performance': {'en': 'Weekly Performance', 'ar': 'الأداء الأسبوعي'},
  'daily_average': {'en': 'Daily average', 'ar': 'المعدل اليومي'},
  'mon': {'en': 'Mon', 'ar': 'إثن'},
  'tue': {'en': 'Tue', 'ar': 'ثلا'},
  'wed': {'en': 'Wed', 'ar': 'أرب'},
  'thu': {'en': 'Thu', 'ar': 'خمي'},
  'fri': {'en': 'Fri', 'ar': 'جمع'},

  // ─── Tasks Screen ────────────────────────
  'my_tasks': {'en': 'My Tasks', 'ar': 'مهامي'},
  'daily_progress': {'en': 'Daily Progress', 'ar': 'التقدم اليومي'},
  'tasks_remaining_prefix': {'en': 'You have ', 'ar': 'لديك '},
  'tasks_remaining_suffix_one': {'en': ' task remaining\nfor today.', 'ar': ' مهمة متبقية\nلهذا اليوم.'},
  'tasks_remaining_suffix_many': {'en': ' tasks remaining\nfor today.', 'ar': ' مهام متبقية\nلهذا اليوم.'},
  'all': {'en': 'All', 'ar': 'الكل'},
  'today': {'en': 'Today', 'ar': 'اليوم'},
  'upcoming': {'en': 'Upcoming', 'ar': 'القادمة'},
  'done': {'en': 'Done', 'ar': 'مكتملة'},
  'no_tasks_found': {'en': 'No tasks found', 'ar': 'لم يتم العثور على مهام'},
  'tap_new_task': {'en': 'Tap + New Task to create one', 'ar': 'اضغط + مهمة جديدة لإنشاء واحدة'},

  // ─── Task Detail ─────────────────────────
  'task_details': {'en': 'Task Details', 'ar': 'تفاصيل المهمة'},
  'description': {'en': 'Description', 'ar': 'الوصف'},
  'checklist': {'en': 'Checklist', 'ar': 'قائمة المهام'},
  'mark_complete': {'en': 'Mark as Complete', 'ar': 'وضع علامة مكتملة'},
  'completed': {'en': 'Completed', 'ar': 'مكتملة'},
  'delete_task_title': {'en': 'Delete Task?', 'ar': 'حذف المهمة؟'},
  'delete_task_msg_prefix': {'en': 'This will permanently remove "', 'ar': 'سيتم حذف "'},
  'delete_task_msg_suffix': {'en': '".', 'ar': '" نهائياً.'},
  'urgent_priority': {'en': 'Urgent Priority', 'ar': 'أولوية عاجلة'},
  'medium_priority': {'en': 'Medium Priority', 'ar': 'أولوية متوسطة'},
  'low_priority': {'en': 'Low Priority', 'ar': 'أولوية منخفضة'},

  // ─── Add Task ────────────────────────────
  'new_task': {'en': 'New Task', 'ar': 'مهمة جديدة'},
  'task_title': {'en': 'Task Title', 'ar': 'عنوان المهمة'},
  'enter_task_title': {'en': 'Enter task title...', 'ar': 'أدخل عنوان المهمة...'},
  'add_description': {'en': 'Add a description...', 'ar': 'أضف وصفاً...'},
  'priority': {'en': 'Priority', 'ar': 'الأولوية'},
  'urgent': {'en': 'Urgent', 'ar': 'عاجل'},
  'medium': {'en': 'Medium', 'ar': 'متوسط'},
  'low': {'en': 'Low', 'ar': 'منخفض'},
  'category': {'en': 'Category', 'ar': 'الفئة'},
  'due_date_time': {'en': 'Due Date & Time', 'ar': 'تاريخ ووقت الاستحقاق'},
  'time_range': {'en': 'Time Range', 'ar': 'النطاق الزمني'},
  'from': {'en': 'From', 'ar': 'من'},
  'to': {'en': 'To', 'ar': 'إلى'},
  'create_task': {'en': 'Create Task', 'ar': 'إنشاء مهمة'},
  'enter_title_error': {'en': 'Please enter a task title', 'ar': 'الرجاء إدخال عنوان المهمة'},

  // ─── Events ──────────────────────────────
  'events': {'en': 'Events', 'ar': 'الأحداث'},
  'no_events': {'en': 'No Events', 'ar': 'لا أحداث'},
  'event_count_one': {'en': '1 Event', 'ar': '1 حدث'},
  'no_events_on_day': {'en': 'No events on this day', 'ar': 'لا أحداث في هذا اليوم'},
  'tap_add_event': {'en': 'Tap New Event to add one', 'ar': 'اضغط حدث جديد لإضافة واحد'},
  'new_event': {'en': 'New Event', 'ar': 'حدث جديد'},
  'event_title_hint': {'en': 'Event title', 'ar': 'عنوان الحدث'},
  'location': {'en': 'Location', 'ar': 'الموقع'},
  'add_event': {'en': 'Add Event', 'ar': 'إضافة حدث'},
  'task_created_msg': {'en': 'Task created successfully', 'ar': 'تم إنشاء المهمة بنجاح'},
  'event_created_msg': {'en': 'Event added successfully', 'ar': 'تمت إضافة الحدث بنجاح'},

  // ─── Settings ────────────────────────────
  'settings': {'en': 'Settings', 'ar': 'الإعدادات'},
  'preferences': {'en': 'Preferences', 'ar': 'التفضيلات'},
  'dark_mode': {'en': 'Dark Mode', 'ar': 'الوضع الداكن'},
  'push_notifications': {'en': 'Push Notifications', 'ar': 'الإشعارات'},
  'sound_effects': {'en': 'Sound Effects', 'ar': 'المؤثرات الصوتية'},
  'general': {'en': 'General', 'ar': 'عام'},
  'language': {'en': 'Language', 'ar': 'اللغة'},
  'about': {'en': 'About', 'ar': 'حول'},
  'help_support': {'en': 'Help & Support', 'ar': 'المساعدة والدعم'},
  'sign_out': {'en': 'Sign Out', 'ar': 'تسجيل الخروج'},
  'sign_out_title': {'en': 'Sign Out?', 'ar': 'تسجيل الخروج؟'},
  'sign_out_msg': {'en': 'You will need to sign in again to access the app.', 'ar': 'ستحتاج لتسجيل الدخول مرة أخرى للوصول إلى التطبيق.'},
  'edit_profile': {'en': 'Edit Profile', 'ar': 'تعديل الملف الشخصي'},
  'select_language': {'en': 'Select Language', 'ar': 'اختر اللغة'},
  'profile_updated': {'en': 'Profile updated', 'ar': 'تم تحديث الملف الشخصي'},

  // ─── Bottom Nav ──────────────────────────
  'nav_home': {'en': 'Home', 'ar': 'الرئيسية'},
  'nav_tasks': {'en': 'Tasks', 'ar': 'المهام'},
  'nav_events': {'en': 'Events', 'ar': 'الأحداث'},
  'nav_settings': {'en': 'Settings', 'ar': 'الإعدادات'},

  // ─── Splash ──────────────────────────────
  'splash_subtitle': {'en': 'The Ethereal Workspace', 'ar': 'مساحة العمل المتميزة'},

  // ─── Months ──────────────────────────────
  'january': {'en': 'January', 'ar': 'يناير'},
  'february': {'en': 'February', 'ar': 'فبراير'},
  'march': {'en': 'March', 'ar': 'مارس'},
  'april': {'en': 'April', 'ar': 'أبريل'},
  'may': {'en': 'May', 'ar': 'مايو'},
  'june': {'en': 'June', 'ar': 'يونيو'},
  'july': {'en': 'July', 'ar': 'يوليو'},
  'august': {'en': 'August', 'ar': 'أغسطس'},
  'september': {'en': 'September', 'ar': 'سبتمبر'},
  'october': {'en': 'October', 'ar': 'أكتوبر'},
  'november': {'en': 'November', 'ar': 'نوفمبر'},
  'december': {'en': 'December', 'ar': 'ديسمبر'},

  // ─── Day abbreviations ───────────────────
  'sat': {'en': 'Sat', 'ar': 'سبت'},
  'sun': {'en': 'Sun', 'ar': 'أحد'},

  // ─── Team General ─────────────────────────
  'team': {'en': 'Team', 'ar': 'الفريق'},
  'my_team': {'en': 'My Team', 'ar': 'فريقي'},
  'go_to_my_team': {'en': 'Go to My Team', 'ar': 'الذهاب لفريقي'},
  'create_team': {'en': 'Create a Team', 'ar': 'إنشاء فريق'},
  'join_team': {'en': 'Join a Team', 'ar': 'الانضمام لفريق'},
  'leave_team': {'en': 'Leave Team', 'ar': 'مغادرة الفريق'},
  'delete_team': {'en': 'Delete Team', 'ar': 'حذف الفريق'},
  'leave_team_q': {'en': 'Leave Team?', 'ar': 'مغادرة الفريق؟'},
  'delete_team_q': {'en': 'Delete Team?', 'ar': 'حذف الفريق؟'},
  'leave_team_msg': {'en': 'You will lose access to all shared tasks and workspace assets. This action cannot be undone.', 'ar': 'ستفقد الوصول إلى جميع المهام المشتركة وأصول مساحة العمل. لا يمكن التراجع عن هذا الإجراء.'},
  'delete_team_msg': {'en': 'This action is permanent and cannot be undone. All team data will be lost.', 'ar': 'هذا الإجراء دائم ولا يمكن التراجع عنه. سيتم فقدان جميع بيانات الفريق.'},
  'team_deleted': {'en': 'Team deleted', 'ar': 'تم حذف الفريق'},
  'left_team': {'en': 'You left the team', 'ar': 'غادرت الفريق'},
  'go_to_taskflow': {'en': 'Go to TaskFlow', 'ar': 'الذهاب إلى تاسك فلو'},
  'owner': {'en': 'OWNER', 'ar': 'المالك'},
  'leader': {'en': 'LEADER', 'ar': 'القائد'},
  'member': {'en': 'MEMBER', 'ar': 'عضو'},

  // ─── Team Create ──────────────────────────
  'owner_panel': {'en': 'OWNER PANEL', 'ar': 'لوحة المالك'},
  'create_team_subtitle': {'en': 'Establish your Team and invite your collaborators to the Ethereal Atelier.', 'ar': 'أنشئ فريقك وادعُ المتعاونين إلى مساحة العمل.'},
  'create_your_team': {'en': 'Create Your Team', 'ar': 'أنشئ فريقك'},
  'team_name': {'en': 'Team Name', 'ar': 'اسم الفريق'},
  'team_name_label': {'en': 'TEAM NAME', 'ar': 'اسم الفريق'},
  'enter_team_name': {'en': 'Enter team name', 'ar': 'أدخل اسم الفريق'},
  'team_name_example': {'en': 'e.g. Creative Ops', 'ar': 'مثال: فريق الإبداع'},
  'team_description': {'en': 'Description', 'ar': 'الوصف'},
  'team_description_label': {'en': 'DESCRIPTION', 'ar': 'الوصف'},
  'enter_team_desc': {'en': 'Describe your team\'s purpose...', 'ar': 'صف هدف فريقك...'},
  'team_password': {'en': 'Team Password', 'ar': 'كلمة مرور الفريق'},
  'team_password_label': {'en': 'TEAM PASSWORD', 'ar': 'كلمة مرور الفريق'},
  'access_security': {'en': 'Access Security', 'ar': 'أمان الوصول'},
  'access_control': {'en': 'ACCESS CONTROL', 'ar': 'التحكم في الوصول'},
  'unified_team_password': {'en': 'UNIFIED TEAM PASSWORD', 'ar': 'كلمة مرور الفريق الموحدة'},
  'enter_team_password': {'en': 'Set a password for members', 'ar': 'عيّن كلمة مرور للأعضاء'},
  'password_required_to_join': {'en': 'This password is required for others to join', 'ar': 'هذه الكلمة مطلوبة لانضمام الآخرين'},
  'create_team_btn': {'en': 'Create Team', 'ar': 'إنشاء الفريق'},
  'fill_all_fields': {'en': 'Please fill all fields', 'ar': 'يرجى ملء جميع الحقول'},
  'please_enter_team_name': {'en': 'Please enter team name', 'ar': 'يرجى إدخال اسم الفريق'},
  'please_enter_description': {'en': 'Please enter a description', 'ar': 'يرجى إدخال وصف'},
  'please_enter_password': {'en': 'Please enter a password', 'ar': 'يرجى إدخال كلمة مرور'},

  // ─── Team Join ────────────────────────────
  'join_a_team': {'en': 'Join a Team', 'ar': 'انضم لفريق'},
  'join_team_subtitle': {'en': 'Enter your credentials to synchronize with your team atelier.', 'ar': 'أدخل بياناتك للاتصال بفريقك.'},
  'team_name_hint_join': {'en': 'Creative Studio X', 'ar': 'استوديو الإبداع'},
  'enter_join_password': {'en': 'Enter team password', 'ar': 'أدخل كلمة مرور الفريق'},
  'required_verify_association': {'en': 'Required to verify association', 'ar': 'مطلوب للتحقق من الانتماء'},
  'your_user_id': {'en': 'Your User ID', 'ar': 'معرف المستخدم'},
  'user_id_label': {'en': 'USER ID', 'ar': 'معرف المستخدم'},
  'sign_in_required': {'en': 'Sign in required', 'ar': 'تسجيل الدخول مطلوب'},
  'must_sign_in_join': {'en': 'You must sign in before joining a team.', 'ar': 'يجب تسجيل الدخول قبل الانضمام إلى فريق.'},
  'please_enter_team_password': {'en': 'Please enter team password', 'ar': 'يرجى إدخال كلمة مرور الفريق'},
  'unable_join_team': {'en': 'Unable to join team.', 'ar': 'تعذر الانضمام إلى الفريق.'},
  'department': {'en': 'Department', 'ar': 'القسم'},
  'department_selection': {'en': 'DEPARTMENT SELECTION', 'ar': 'اختيار القسم'},
  'programming': {'en': 'Programming', 'ar': 'البرمجة'},
  'media': {'en': 'Media', 'ar': 'الإعلام'},
  'operation': {'en': 'Operation', 'ar': 'العمليات'},
  'join_team_btn': {'en': 'Join Team', 'ar': 'انضمام للفريق'},

  // ─── Team Tasks ───────────────────────────
  'add_task': {'en': 'Add Task', 'ar': 'إضافة مهمة'},
  'all_tasks': {'en': 'ALL TASKS', 'ar': 'جميع المهام'},
  'no_tasks_yet': {'en': 'No tasks yet', 'ar': 'لا مهام بعد'},
  'assign_tasks_hint': {'en': 'Assign tasks to your members above', 'ar': 'عيّن مهامًا لأعضائك أعلاه'},
  'performance': {'en': 'PERFORMANCE', 'ar': 'الأداء'},
  'team_health_score': {'en': 'TEAM HEALTH SCORE', 'ar': 'نقاط صحة الفريق'},
  'tasks_completed': {'en': 'Tasks Completed', 'ar': 'المهام المكتملة'},
  'tasks_pending': {'en': 'Tasks Pending', 'ar': 'المهام المعلقة'},
  'team_members': {'en': 'Team Members', 'ar': 'أعضاء الفريق'},
  'assign_to_member': {'en': 'Assign to Member', 'ar': 'تعيين لعضو'},
  'continue_btn': {'en': 'CONTINUE', 'ar': 'متابعة'},
  'new_task_for': {'en': 'New Task for', 'ar': 'مهمة جديدة لـ'},
  'what_needs_done': {'en': 'What needs to be done?', 'ar': 'ما الذي يجب فعله؟'},
  'add_context': {'en': 'Add more context about this task...', 'ar': 'أضف مزيدًا من التفاصيل حول هذه المهمة...'},
  'details': {'en': 'Details', 'ar': 'التفاصيل'},
  'send_task': {'en': 'Send Task', 'ar': 'إرسال المهمة'},
  'task_sent': {'en': 'Task Sent!', 'ar': 'تم إرسال المهمة!'},
  'assigned_to': {'en': 'Assigned to', 'ar': 'مُعيّنة إلى'},
  'task_visible_prefix': {'en': 'This task will be immediately visible in ', 'ar': 'ستظهر هذه المهمة فورًا في قائمة '},
  'task_visible_suffix': {'en': '\'s active queue. Notifications are enabled for the department.', 'ar': ' النشطة. تم تفعيل الإشعارات للقسم.'},
  'unassigned': {'en': 'Unassigned', 'ar': 'غير معيّنة'},

  // ─── Member Tasks ─────────────────────────
  'my_tasks_team': {'en': 'My Tasks', 'ar': 'مهامي'},
  'my_day': {'en': 'My Day', 'ar': 'يومي'},
  'remaining': {'en': 'Remaining', 'ar': 'متبقية'},
  'priority_focus': {'en': 'PRIORITY FOCUS', 'ar': 'التركيز على الأولوية'},
  'no_tasks_assigned': {'en': 'No tasks assigned', 'ar': 'لا مهام معيّنة'},
  'owner_will_assign': {'en': 'Your team owner will assign tasks to you', 'ar': 'سيقوم مالك الفريق بتعيين مهام لك'},
  'pending_label': {'en': 'PENDING', 'ar': 'معلقة'},
  'completed_label': {'en': 'COMPLETED', 'ar': 'مكتملة'},
  'mark_done': {'en': 'Mark Done', 'ar': 'تمّ'},
  'undo': {'en': 'Undo', 'ar': 'تراجع'},
  'note': {'en': 'Note', 'ar': 'ملاحظة'},
  'add_note': {'en': 'Add Note', 'ar': 'إضافة ملاحظة'},
  'write_note': {'en': 'Write your note...', 'ar': 'اكتب ملاحظتك...'},

  // ─── Leader Team ──────────────────────────
  'dept_pulse': {'en': 'DEPARTMENT PULSE', 'ar': 'نبض القسم'},
  'overall_completion': {'en': 'OVERALL COMPLETION', 'ar': 'نسبة الإنجاز الكلية'},
  'active_tasks': {'en': 'ACTIVE TASKS', 'ar': 'المهام النشطة'},
  'team_workload': {'en': 'TEAM WORKLOAD', 'ar': 'عبء عمل الفريق'},
  'tasks_suffix': {'en': 'Tasks', 'ar': 'مهام'},
  'total': {'en': 'total', 'ar': 'إجمالي'},
  'tasks_appear_hint': {'en': 'Tasks will appear here when the owner assigns them', 'ar': 'ستظهر المهام هنا عندما يعيّنها المالك'},
  'in_progress': {'en': 'IN PROGRESS', 'ar': 'قيد التنفيذ'},
  'done_label': {'en': 'DONE', 'ar': 'مكتملة'},
  'dept_suffix': {'en': 'Dept.', 'ar': 'قسم'},

  // ─── Team Settings ────────────────────────
  'team_settings': {'en': 'Settings', 'ar': 'الإعدادات'},
  'profile': {'en': 'PROFILE', 'ar': 'الملف الشخصي'},
  'manage_workspace': {'en': 'Manage your personal workspace and team configurations.', 'ar': 'إدارة مساحة عملك الشخصية وإعدادات الفريق.'},
  'team_info': {'en': 'TEAM INFO', 'ar': 'معلومات الفريق'},
  'role': {'en': 'Role', 'ar': 'الدور'},
  'danger_zone': {'en': 'DANGER ZONE', 'ar': 'منطقة الخطر'},
  'add_member': {'en': 'Add Member', 'ar': 'إضافة عضو'},
  'enter_member_name': {'en': 'Enter member name...', 'ar': 'أدخل اسم العضو...'},
  'add': {'en': 'Add', 'ar': 'إضافة'},
  'remove': {'en': 'Remove', 'ar': 'إزالة'},
  'remove_member_q_prefix': {'en': 'Remove ', 'ar': 'إزالة '},
  'remove_member_q_suffix': {'en': '?', 'ar': '؟'},
  'remove_member_msg': {'en': 'This will remove the member from your team.', 'ar': 'سيؤدي ذلك إلى إزالة العضو من فريقك.'},
  'leave': {'en': 'Leave', 'ar': 'مغادرة'},
  'user_fallback': {'en': 'User', 'ar': 'مستخدم'},
  'designer': {'en': 'Designer', 'ar': 'مصمم'},

  // ─── Team Nav ─────────────────────────────
  'nav_team': {'en': 'TEAM', 'ar': 'الفريق'},
  'nav_team_tasks': {'en': 'TASKS', 'ar': 'المهام'},
  'nav_team_settings': {'en': 'SETTINGS', 'ar': 'الإعدادات'},

  // ─── Date Labels ──────────────────────────
  'monday': {'en': 'MONDAY', 'ar': 'الإثنين'},
  'tuesday': {'en': 'TUESDAY', 'ar': 'الثلاثاء'},
  'wednesday': {'en': 'WEDNESDAY', 'ar': 'الأربعاء'},
  'thursday': {'en': 'THURSDAY', 'ar': 'الخميس'},
  'friday': {'en': 'FRIDAY', 'ar': 'الجمعة'},
  'saturday': {'en': 'SATURDAY', 'ar': 'السبت'},
  'sunday': {'en': 'SUNDAY', 'ar': 'الأحد'},
  'jan_short': {'en': 'JAN', 'ar': 'ينا'},
  'feb_short': {'en': 'FEB', 'ar': 'فبر'},
  'mar_short': {'en': 'MAR', 'ar': 'مار'},
  'apr_short': {'en': 'APR', 'ar': 'أبر'},
  'may_short': {'en': 'MAY', 'ar': 'ماي'},
  'jun_short': {'en': 'JUN', 'ar': 'يون'},
  'jul_short': {'en': 'JUL', 'ar': 'يول'},
  'aug_short': {'en': 'AUG', 'ar': 'أغس'},
  'sep_short': {'en': 'SEP', 'ar': 'سبت'},
  'oct_short': {'en': 'OCT', 'ar': 'أكت'},
  'nov_short': {'en': 'NOV', 'ar': 'نوف'},
  'dec_short': {'en': 'DEC', 'ar': 'ديس'},
};

const Map<String, String> _authMessageKeys = {
  'Email is required': 'email_required',
  'Enter a valid email': 'valid_email_required',
  'Password is required': 'password_required',
  'Password must be at least 6 characters': 'password_min_6',
  'No account found with this email': 'account_not_found',
  'Incorrect password': 'incorrect_password',
  'Something went wrong. Please try again.': 'generic_error_retry',
};
