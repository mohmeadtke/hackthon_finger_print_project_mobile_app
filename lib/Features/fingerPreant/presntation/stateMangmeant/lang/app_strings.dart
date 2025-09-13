class AppStrings {
  static String getText(String englishText, String arabicText, bool isEnglish) {
    return isEnglish ? englishText : arabicText;
  }

  // Common strings
  static String home(bool isEnglish) => getText("Home", "الرئيسية", isEnglish);
  static String profile(bool isEnglish) =>
      getText("Profile", "الملف الشخصي", isEnglish);
  static String fingerprintScanner(bool isEnglish) =>
      getText("Fingerprint Scanner", "ماسح البصمة", isEnglish);
  static String register(bool isEnglish) =>
      getText("Register", "تسجيل", isEnglish);
  static String checkFingerprint(bool isEnglish) =>
      getText("Check Fingerprint", "فحص البصمة", isEnglish);
  static String name(bool isEnglish) => getText("Name", "الاسم", isEnglish);
  static String email(bool isEnglish) =>
      getText("Email", "البريد الإلكتروني", isEnglish);
  static String camera(bool isEnglish) =>
      getText("Camera", "الكاميرا", isEnglish);
  static String gallery(bool isEnglish) =>
      getText("Gallery", "المعرض", isEnglish);
  static String selectImageSource(bool isEnglish) =>
      getText("Select Image Source", "اختر مصدر الصورة", isEnglish);
  static String sendFingerprintData(bool isEnglish) =>
      getText("Send Fingerprint Data", "إرسال بيانات البصمة", isEnglish);
  static String processing(bool isEnglish) =>
      getText("Processing...", "جاري المعالجة...", isEnglish);
  static String loadingProfile(bool isEnglish) => getText(
    "Loading your profile...",
    "جاري تحميل ملفك الشخصي...",
    isEnglish,
  );
  static String logout(bool isEnglish) =>
      getText("Logout", "تسجيل الخروج", isEnglish);
  static String retry(bool isEnglish) =>
      getText("Retry", "إعادة المحاولة", isEnglish);
  static String error(bool isEnglish) => getText("Error", "خطأ", isEnglish);
  static String success(bool isEnglish) => getText("Success", "نجح", isEnglish);
  static String fingerprintApp(bool isEnglish) =>
      getText("Fingerprint App", "تطبيق البصمة", isEnglish);
  static String checkingAuthentication(bool isEnglish) =>
      getText("Checking authentication...", "جاري فحص المصادقة...", isEnglish);
  static String fullName(bool isEnglish) =>
      getText("Full Name", "الاسم الكامل", isEnglish);
  static String emailAddress(bool isEnglish) =>
      getText("Email Address", "عنوان البريد الإلكتروني", isEnglish);

  // Home page strings
  static String welcomeMessage(bool isEnglish) => getText(
    "Welcome to Secure Fingerprint Authentication",
    "مرحباً بك في نظام المصادقة الآمن بالبصمة",
    isEnglish,
  );
  static String registerNewFingerprint(bool isEnglish) =>
      getText("Register New Fingerprint", "تسجيل بصمة جديدة", isEnglish);
  static String verifyFingerprint(bool isEnglish) =>
      getText("Verify Fingerprint", "التحقق من البصمة", isEnglish);
  static String secureNote(bool isEnglish) => getText(
    "Your fingerprint data is encrypted and stored securely",
    "بيانات البصمة مشفرة ومحفوظة بأمان",
    isEnglish,
  );

  // Form strings
  static String pleaseEnterName(bool isEnglish) =>
      getText("Please enter your name", "يرجى إدخال اسمك", isEnglish);
  static String pleaseEnterEmail(bool isEnglish) => getText(
    "Please enter your email",
    "يرجى إدخال بريدك الإلكتروني",
    isEnglish,
  );
  static String pleaseEnterValidEmail(bool isEnglish) => getText(
    "Please enter a valid email",
    "يرجى إدخال بريد إلكتروني صالح",
    isEnglish,
  );
  static String completeAllFields(bool isEnglish) => getText(
    "Complete all fields to continue",
    "أكمل جميع الحقول للمتابعة",
    isEnglish,
  );

  // Security strings
  static String securityInfo(bool isEnglish) => getText(
    "Your profile information is secured with fingerprint authentication",
    "معلومات ملفك الشخصي محمية بمصادقة البصمة",
    isEnglish,
  );

  // Fingerprint specific strings
  static String secureAnalysis(bool isEnglish) =>
      getText("Secure Fingerprint Analysis", "تحليل البصمة الآمن", isEnglish);
  static String uploadDescription(bool isEnglish) => getText(
    "Upload your fingerprint image for secure processing",
    "قم بتحميل صورة البصمة للمعالجة الآمنة",
    isEnglish,
  );
  static String fingerprintVerification(bool isEnglish) =>
      getText("Fingerprint Verification", "التحقق من البصمة", isEnglish);
  static String verifyDescription(bool isEnglish) => getText(
    "Place your finger on the scanner or upload an image to verify your identity",
    "ضع إصبعك على الماسح أو قم بتحميل صورة للتحقق من هويتك",
    isEnglish,
  );

  // Error strings
  static String errorLoadingProfile(bool isEnglish) =>
      getText("Error Loading Profile", "خطأ في تحميل الملف الشخصي", isEnglish);
  static String unknownError(bool isEnglish) =>
      getText("Unknown error", "خطأ غير معروف", isEnglish);

  // Verification strings
  static String fingerprintReady(bool isEnglish) => getText(
    "Fingerprint image ready for verification",
    "صورة البصمة جاهزة للتحقق",
    isEnglish,
  );
  static String selectImageToContinue(bool isEnglish) => getText(
    "Select a fingerprint image to continue",
    "اختر صورة بصمة للمتابعة",
    isEnglish,
  );
  static String verifyingIdentity(bool isEnglish) =>
      getText("Verifying Identity...", "جاري التحقق من الهوية...", isEnglish);
  static String verifyFingerprintButton(bool isEnglish) =>
      getText("Verify Fingerprint", "التحقق من البصمة", isEnglish);
  static String selectImageToVerify(bool isEnglish) =>
      getText("Select Image to Continue", "اختر صورة للمتابعة", isEnglish);
  static String quickVerification(bool isEnglish) =>
      getText("Quick Verification", "تحقق سريع", isEnglish);
  static String onlyFingerprintRequired(bool isEnglish) => getText(
    "Only your fingerprint image is required for identity verification",
    "صورة البصمة فقط مطلوبة للتحقق من الهوية",
    isEnglish,
  );
  static String analyzingFingerprint(bool isEnglish) => getText(
    "Analyzing your fingerprint for verification",
    "جاري تحليل البصمة للتحقق",
    isEnglish,
  );
}
