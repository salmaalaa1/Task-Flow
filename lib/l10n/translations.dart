/// Simple localization helper — maps keys to English and Arabic strings.
/// Usage: `tr(context, 'key')` — returns the translated string.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

String tr(BuildContext context, String key) {
  final lang = context.read<SettingsProvider>().language;
  final map = _translations[key];
  if (map == null) return key;
  return map[lang] ?? map['en'] ?? key;
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
  'create_task': {'en': 'Create Task', 'ar': 'إنشاء مهمة'},
  'enter_title_error': {'en': 'Please enter a task title', 'ar': 'الرجاء إدخال عنوان المهمة'},

  // ─── Events ──────────────────────────────
  'events': {'en': 'Events', 'ar': 'الأحداث'},
  'no_events': {'en': 'No Events', 'ar': 'لا أحداث'},
  'event_count_one': {'en': '1 Event', 'ar': '1 حدث'},
  'no_events_on_day': {'en': 'No events on this day', 'ar': 'لا أحداث في هذا اليوم'},
  'tap_add_event': {'en': 'Tap + to add an event', 'ar': 'اضغط + لإضافة حدث'},
  'new_event': {'en': 'New Event', 'ar': 'حدث جديد'},
  'event_title_hint': {'en': 'Event title', 'ar': 'عنوان الحدث'},
  'location': {'en': 'Location', 'ar': 'الموقع'},
  'add_event': {'en': 'Add Event', 'ar': 'إضافة حدث'},

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
};
