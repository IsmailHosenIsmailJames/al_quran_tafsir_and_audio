abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    'zh': chinese,
    'hi': hindi,
    'en': english,
    'es': spanish,
    'ar': arabic,
    'bn': bengali,
    'pt': portuguese,
    'ru': russian,
    'ja': japanese,
    'pa': punjabi,
    'de': german,
    'fr': french,
    'id': indonesian,
    'ur': urdu,
    'sw': swahili,
    'ko': korean,
    'tr': turkish,
    'vi': vietnamese,
    'ta': tamil,
    'it': italian,
  };
}

List<String> nativeSpelling = [
  'English',
  'العربية',
  'Bahasa Indonesia',
  'বাংলা',
  'हिन्दी',
  'اردو',
  'Türkçe',
  'فارسی',
  'ਪੰਜਾਬੀ',
  'پښتو',
  'Français',
  'Kiswahili',
  'Hausa',
  'Bahasa Melayu',
  'کوردی',
  'Af-Soomaali',
];

List<Map<String, String>> used20LanguageMap = [
  {'English': 'Chinese', 'Native': '中文 (Zhōngwén)', 'Code': 'zh'},
  {'English': 'Hindi', 'Native': 'हिन्दी (Hindī)', 'Code': 'hi'},
  {'English': 'English', 'Native': 'English', 'Code': 'en'},
  {'English': 'Spanish', 'Native': 'Español', 'Code': 'es'},
  {'English': 'Arabic', 'Native': 'العربية (Al-‘Arabīyah)', 'Code': 'ar'},
  {'English': 'Bengali', 'Native': 'বাংলা (Bāṅlā)', 'Code': 'bn'},
  {'English': 'Portuguese', 'Native': 'Português', 'Code': 'pt'},
  {'English': 'Russian', 'Native': 'Русский (Russkiy)', 'Code': 'ru'},
  {'English': 'Japanese', 'Native': '日本語 (Nihongo)', 'Code': 'ja'},
  {'English': 'Punjabi', 'Native': 'ਪੰਜਾਬੀ (Pañjābī)', 'Code': 'pa'},
  {'English': 'German', 'Native': 'Deutsch', 'Code': 'de'},
  {'English': 'French', 'Native': 'Français', 'Code': 'fr'},
  {'English': 'Indonesian', 'Native': 'Bahasa Indonesia', 'Code': 'id'},
  {'English': 'Urdu', 'Native': 'اُردُو (Urdū)', 'Code': 'ur'},
  {'English': 'Swahili', 'Native': 'Kiswahili', 'Code': 'sw'},
  {'English': 'Korean', 'Native': '한국어 (Hanguk-eo)', 'Code': 'ko'},
  {'English': 'Turkish', 'Native': 'Türkçe', 'Code': 'tr'},
  {'English': 'Vietnamese', 'Native': 'Tiếng Việt', 'Code': 'vi'},
  {'English': 'Tamil', 'Native': 'தமிழ் (Tamiḻ)', 'Code': 'ta'},
  {'English': 'Italian', 'Native': 'Italiano', 'Code': 'it'}
];

List<String> used20LanguageList = [
  'Chinese',
  'Hindi',
  'English',
  'Spanish',
  'Arabic',
  'Bengali',
  'Portuguese',
  'Russian',
  'Japanese',
  'Punjabi',
  'German',
  'French',
  'Indonesian',
  'Urdu',
  'Swahili',
  'Korean',
  'Turkish',
  'Vietnamese',
  'Tamil',
  'Italian',
];

Map<String, String> historyTrackingPlaylistFeatureTranslations = {
  'chinese': '历史记录跟踪与播放列表功能',
  'hindi': 'इतिहास ट्रैकिंग और प्लेलिस्ट सुविधा',
  'english': 'History Tracking & Playlist Feature',
  'spanish': 'Seguimiento del historial y función de lista de reproducción',
  'arabic': 'تتبع التاريخ وميزة قائمة التشغيل',
  'bengali': 'ইতিহাস ট্র্যাকিং এবং প্লেলিস্ট বৈশিষ্ট্য',
  'portuguese': 'Rastreamento de Histórico e Recurso de Playlist',
  'russian': 'Отслеживание истории и функция плейлистов',
  'japanese': '履歴追跡とプレイリスト機能',
  'punjabi': 'تریخ ٹریکنگ تے پلے لسٹ فیچر',
  'german': 'Verlaufsverfolgung & Playlist-Funktion',
  'french': 'Suivi de l\'historique et fonctionnalité de playlist',
  'indonesian': 'Pelacakan Riwayat & Fitur Daftar Putar',
  'urdu': 'تاریخ سے باخبر رہنا اور پلے لسٹ فیچر',
  'swahili': 'Ufuatiliaji wa Historia na Kipengele cha Orodha ya Kucheza',
  'korean': '기록 추적 및 재생 목록 기능',
  'turkish': 'Geçmiş Takibi ve Oynatma Listesi Özelliği',
  'vietnamese': 'Theo dõi lịch sử & Tính năng danh sách phát',
  'tamil': 'வரலாற்று கண்காணிப்பு & பிளேலிஸ்ட் அம்சம்',
  'italian': 'Tracciamento della cronologia e funzione playlist',
};

Map<String, String> chinese = {
  'Al Quran': '古兰经', 'Privacy Policy': '隐私政策',
  'Select a language for app': '选择应用语言',
  'Previous': '上一步',
  'Setup': '设置',
  'Data collected from': '数据来自',
  'and': '和',
  'Next': '下一步',
  'Translation of Quran': '古兰经翻译',
  'Translation Book': '译本',
  "Select language for Quran's Tafsir": '选择古兰经注释的语言',
  'Please Select Quran Translation Language': '请选择古兰经翻译语言',
  'Please select a language for app': '请选择应用语言',
  'Please Select Quran Translation Book': '请选择古兰经译本',
  'Please Select Quran Tafsir Language': '请选择古兰经注释语言',
  'Please Select Quran Tafsir Book': '请选择古兰经注释书',
  'Please select a default reciter': '请选择默认朗诵者',
  'Downloading': '下载中',
  'Getting Quran': '获取下载的古兰经',
  'Downloading Translation': '下载翻译',
  'Downloading Tafsir': '下载经注',
  'All Completed': '全部完成',
  'Failed to download translation': '翻译下载失败',
  'Failed to download tafsir': '经注下载失败',
  'Progress': '进度',
  'Processing tafsir': '处理经注',
  'Full Quran with 65+ Translations': '完整古兰经，含 65 种以上翻译',
  '12 Tafsir Books in 6 Languages': '6 种语言的 12 本经注书',
  '40+ Recitations & Quran Audio Book': '40多个朗诵版本和古兰经有声书',
  'Rich Notes, Bookmarks & Collections': '丰富笔记、书签和收藏集',
  'Cloud Backup & Sync': '云备份与同步',
  'History Tracking & Playlist Feature': '历史记录跟踪与播放列表功能',
  //
};
Map<String, String> hindi = {
  'Al Quran': 'अल कुरान', 'Privacy Policy': 'गोपनीयता नीति',
  'Select a language for app': 'ऐप के लिए भाषा चुनें',
  'Previous': 'पिछला',
  'Setup': 'सेटअप',
  'Data collected from': 'से डेटा एकत्र किया गया',
  'and': 'और',
  'Next': 'अगला',
  'Translation of Quran': 'कुरान का अनुवाद',
  'Translation Book': 'अनुवाद पुस्तक',
  "Select language for Quran's Tafsir":
      'कुरान की तफ़सीर के लिए भाषा का चयन करें',
  'Please Select Quran Translation Language':
      'कृपया कुरान अनुवाद भाषा का चयन करें',
  'Please select a language for app': 'कृपया ऐप के लिए भाषा चुनें',
  'Please Select Quran Translation Book':
      'कृपया कुरान अनुवाद पुस्तक का चयन करें',
  'Please Select Quran Tafsir Language': 'कृपया कुरान तफ़सीर भाषा का चयन करें',
  'Please Select Quran Tafsir Book': 'कृपया कुरान तफ़सीर पुस्तक का चयन करें',
  'Please select a default reciter': 'कृपया एक डिफ़ॉल्ट पाठ करनेवाला चुनें',
  'Downloading': 'डाउनलोड हो रहा है',
  'Getting Quran': 'कुरान डाउनलोड हो रहा है',
  'Downloading Translation': 'अनुवाद डाउनलोड हो रहा है',
  'Downloading Tafsir': 'तफ़सीर डाउनलोड हो रही है',
  'All Completed': 'सब पूरा हो गया',
  'Failed to download translation': 'अनुवाद डाउनलोड करने में विफल',
  'Failed to download tafsir': 'तफ़सीर डाउनलोड करने में विफल',
  'Progress': 'प्रगति',
  'Processing tafsir': 'तफ़सीर संसाधित हो रहा है',
  'Full Quran with 65+ Translations': '65+ अनुवादों के साथ पूर्ण कुरान',
  '12 Tafsir Books in 6 Languages': '6 भाषाओं में 12 तफ़सीर पुस्तकें',
  '40+ Recitations & Quran Audio Book': '40+ पाठ और कुरान ऑडियो बुक',
  'Rich Notes, Bookmarks & Collections': 'रिच नोट्स, बुकमार्क और संग्रह',
  'Cloud Backup & Sync': 'क्लाउड बैकअप और सिंक',
  'History Tracking & Playlist Feature': 'इतिहास ट्रैकिंग और प्लेलिस्ट सुविधा',
  //
};
Map<String, String> english = {
  'Al Quran': 'Al-Quran', 'Privacy Policy': 'Privacy Policy',
  'Select a language for app': 'Select app language',
  'Previous': 'Previous',
  'Setup': 'Setup',
  'Data collected from': 'Data collected from',
  'and': 'and',
  'Next': 'Next',
  'Translation of Quran': 'Translation of Quran',
  'Translation Book': 'Translation Book',
  "Select language for Quran's Tafsir": 'Select language for Quran\'s Tafsir',
  'Please Select Quran Translation Language':
      'Please Select Quran Translation Language',
  'Please select a language for app': 'Please select a language for app',
  'Please Select Quran Translation Book':
      'Please Select Quran Translation Book',
  'Please Select Quran Tafsir Language': 'Please Select Quran Tafsir Language',
  'Please Select Quran Tafsir Book': 'Please Select Quran Tafsir Book',
  'Please select a default reciter': 'Please select a default reciter',
  'Downloading': 'Downloading',
  'Getting Quran': 'Downloading Quran data',
  'Downloading Translation': 'Downloading Translation',
  'Downloading Tafsir': 'Downloading Tafsir',
  'All Completed': 'All Completed',
  'Failed to download translation': 'Failed to download translation',
  'Failed to download tafsir': 'Failed to download tafsir',
  'Progress': 'Progress',
  'Processing tafsir': 'Processing tafsir',
  'Full Quran with 65+ Translations': 'Full Quran with 65+ Translations',
  '12 Tafsir Books in 6 Languages': '12 Tafsir Books in 6 Languages',
  '40+ Recitations & Quran Audio Book': '40+ Recitations & Quran Audio Book',
  'Rich Notes, Bookmarks & Collections': 'Rich Notes, Bookmarks & Collections',
  'Cloud Backup & Sync': 'Cloud Backup & Sync',
  'History Tracking & Playlist Feature': 'History Tracking & Playlist Feature',
  //
};
Map<String, String> spanish = {
  'Al Quran': 'El Corán', 'Privacy Policy': 'Política de privacidad',
  'Select a language for app': 'Selecciona un idioma para la aplicación',
  'Previous': 'Anterior',
  'Setup': 'Configuración',
  'Data collected from': 'Datos recogidos de',
  'and': 'y',
  'Next': 'Siguiente',
  'Translation of Quran': 'Traducción del Corán',
  'Translation Book': 'Libro de traducciones',
  "Select language for Quran's Tafsir":
      'Selecciona el idioma para el Tafsir del Corán',
  'Please Select Quran Translation Language':
      'Por favor, seleccione el idioma de traducción del Corán',
  'Please select a language for app':
      'Por favor, selecciona un idioma para la aplicación',
  'Please Select Quran Translation Book':
      'Por favor, seleccione el libro de traducción del Corán',
  'Please Select Quran Tafsir Language':
      'Por favor, seleccione el idioma del Tafsir del Corán',
  'Please Select Quran Tafsir Book':
      'Por favor, seleccione el libro de Tafsir del Corán',
  'Please select a default reciter':
      'Por favor, seleccione un recitador predeterminado',
  'Downloading': 'Descargando',
  'Getting Quran': 'Descargando datos del Corán',
  'Downloading Translation': 'Descargando traducción',
  'Downloading Tafsir': 'Descargando Tafsir',
  'All Completed': 'Todo completado',
  'Failed to download translation': 'Error al descargar la traducción',
  'Failed to download tafsir': 'Error al descargar el tafsir',
  'Progress': 'Progreso',
  'Processing tafsir': 'Procesando tafsir',
  'Full Quran with 65+ Translations':
      'Corán completo con más de 65 traducciones',
  '12 Tafsir Books in 6 Languages': '12 Libros de Tafsir en 6 idiomas',
  '40+ Recitations & Quran Audio Book':
      'Más de 40 recitaciones y audiolibro del Corán',
  'Rich Notes, Bookmarks & Collections':
      'Notas enriquecidas, Marcadores y Colecciones',
  'Cloud Backup & Sync': 'Copia de seguridad y sincronización en la nube',
  'History Tracking & Playlist Feature':
      'Seguimiento del historial y función de lista de reproducción',
  //
};
Map<String, String> arabic = {
  'Al Quran': 'القرآن', 'Privacy Policy': 'سياسة الخصوصية',
  'Select a language for app': 'اختر لغة التطبيق',
  'Previous': 'السابق',
  'Setup': 'إعداد',
  'Data collected from': 'البيانات التي تم جمعها من',
  'and': 'و',
  'Next': 'التالي',
  'Translation of Quran': 'ترجمة القرآن',
  'Translation Book': 'كتاب الترجمة',
  "Select language for Quran's Tafsir": 'اختر لغة تفسير القرآن',
  'Please Select Quran Translation Language': 'الرجاء تحديد لغة ترجمة القرآن',
  'Please select a language for app': 'الرجاء تحديد لغة للتطبيق',
  'Please Select Quran Translation Book': 'الرجاء تحديد كتاب ترجمة القرآن',
  'Please Select Quran Tafsir Language': 'الرجاء تحديد لغة تفسير القرآن',
  'Please Select Quran Tafsir Book': 'الرجاء تحديد كتاب تفسير القرآن',
  'Please select a default reciter': 'الرجاء اختيار قارئ افتراضي',
  'Downloading': 'جارٍ التنزيل',
  'Getting Quran': 'جارٍ تنزيل بيانات القرآن',
  'Downloading Translation': 'جارٍ تنزيل الترجمة',
  'Downloading Tafsir': 'جارٍ تنزيل التفسير',
  'All Completed': 'اكتمل كل شيء',
  'Failed to download translation': 'فشل تنزيل الترجمة',
  'Failed to download tafsir': 'فشل تنزيل التفسير',
  'Progress': 'التقدم',
  'Processing tafsir': 'معالجة التفسير',
  'Full Quran with 65+ Translations':
      'القرآن الكريم كاملاً مع أكثر من 65 ترجمة',
  '12 Tafsir Books in 6 Languages': '12 كتاب تفسير بـ 6 لغات',
  '40+ Recitations & Quran Audio Book': '40+ تلاوة وكتاب القرآن الصوتي',
  'Rich Notes, Bookmarks & Collections': 'ملاحظات غنية وإشارات مرجعية ومجموعات',
  'Cloud Backup & Sync': 'النسخ الاحتياطي السحابي والمزامنة',
  'History Tracking & Playlist Feature': 'تتبع التاريخ وميزة قائمة التشغيل',
  //
};
Map<String, String> bengali = {
  'Al Quran': 'আল কুরআন', 'Privacy Policy': 'গোপনীয়তা নীতি',
  'Select a language for app': 'অ্যাপের জন্য ভাষা নির্বাচন করুন',
  'Previous': 'পূর্ববর্তী',
  'Setup': 'সেটআপ',
  'Data collected from': 'ডেটা সংগ্রহ করা হয়েছে',
  'and': 'এবং',
  'Next': 'পরবর্তী',
  'Translation of Quran': 'কুরআনের অনুবাদ',
  'Translation Book': 'অনুবাদ বই',
  "Select language for Quran's Tafsir":
      'কুরআনের তাফসীরের জন্য ভাষা নির্বাচন করুন',
  'Please Select Quran Translation Language':
      'অনুগ্রহ করে কুরআনের অনুবাদের ভাষা নির্বাচন করুন',
  'Please select a language for app':
      'অনুগ্রহ করে অ্যাপের জন্য একটি ভাষা নির্বাচন করুন',
  'Please Select Quran Translation Book':
      'অনুগ্রহ করে কুরআনের অনুবাদ বই নির্বাচন করুন',
  'Please Select Quran Tafsir Language':
      'অনুগ্রহ করে কুরআনের তাফসীর ভাষা নির্বাচন করুন',
  'Please Select Quran Tafsir Book':
      'অনুগ্রহ করে কুরআনের তাফসীর বই নির্বাচন করুন',
  'Please select a default reciter':
      'অনুগ্রহ করে একটি ডিফল্ট আবৃত্তিকার নির্বাচন করুন',
  'Downloading': 'ডাউনলোড হচ্ছে',
  'Getting Quran': 'কুরআন ডাউনলোড হচ্ছে',
  'Downloading Translation': 'অনুবাদ ডাউনলোড হচ্ছে',
  'Downloading Tafsir': 'তাফসীর ডাউনলোড হচ্ছে',
  'All Completed': 'সব সম্পন্ন হয়েছে',
  'Failed to download translation': 'অনুবাদ ডাউনলোড করতে ব্যর্থ হয়েছে',
  'Failed to download tafsir': 'তাফসীর ডাউনলোড করতে ব্যর্থ হয়েছে',
  'Progress': 'অগ্রগতি',
  'Processing tafsir': 'তাফসীর প্রক্রিয়া করা হচ্ছে',
  'Full Quran with 65+ Translations': '65+ অনুবাদ সহ সম্পূর্ণ কুরআন',
  '12 Tafsir Books in 6 Languages': '6টি ভাষায় 12টি তাফসীর বই',
  '40+ Recitations & Quran Audio Book': '40+ আবৃত্তি ও কুরআন অডিও বই',
  'Rich Notes, Bookmarks & Collections': 'রিচ নোট, বুকমার্ক এবং সংগ্রহ',
  'Cloud Backup & Sync': 'ক্লাউড ব্যাকআপ ও সিঙ্ক',
  'History Tracking & Playlist Feature':
      'ইতিহাস ট্র্যাকিং এবং প্লেলিস্ট বৈশিষ্ট্য',
  //
};
Map<String, String> portuguese = {
  'Al Quran': 'Alcorão', 'Privacy Policy': 'Política de Privacidade',
  'Select a language for app': 'Selecione o idioma do aplicativo',
  'Previous': 'Anterior',
  'Setup': 'Configuração',
  'Data collected from': 'Dados coletados de',
  'and': 'e',
  'Next': 'Próximo',
  'Translation of Quran': 'Tradução do Alcorão',
  'Translation Book': 'Livro de Tradução',
  "Select language for Quran's Tafsir":
      'Selecione o idioma para Tafsir do Alcorão',
  'Please Select Quran Translation Language':
      'Por favor, selecione o idioma de tradução do Alcorão',
  'Please select a language for app':
      'Por favor, selecione um idioma para o aplicativo',
  'Please Select Quran Translation Book':
      'Por favor, selecione o Livro de Tradução do Alcorão',
  'Please Select Quran Tafsir Language':
      'Por favor, selecione o idioma de Tafsir do Alcorão',
  'Please Select Quran Tafsir Book':
      'Por favor, selecione o Livro de Tafsir do Alcorão',
  'Please select a default reciter': 'Por favor, selecione um recitador padrão',
  'Downloading': 'A baixar',
  'Getting Quran': 'A baixar dados do Corão',
  'Downloading Translation': 'A baixar tradução',
  'Downloading Tafsir': 'A baixar Tafsir',
  'All Completed': 'Tudo Concluído',
  'Failed to download translation': 'Falha ao baixar a tradução',
  'Failed to download tafsir': 'Falha ao baixar o tafsir',
  'Progress': 'Progresso',
  'Processing tafsir': 'A processar tafsir',
  'Full Quran with 65+ Translations':
      'Alcorão Completo com mais de 65 Traduções',
  '12 Tafsir Books in 6 Languages': '12 Livros de Tafsir em 6 idiomas',
  '40+ Recitations & Quran Audio Book':
      'Mais de 40 recitações e audiolivro do Corão',
  'Rich Notes, Bookmarks & Collections': 'Notas Ricas, Marcadores e Coleções',
  'Cloud Backup & Sync': 'Backup e Sincronização na Nuvem',
  'History Tracking & Playlist Feature':
      'Rastreamento de Histórico e Recurso de Playlist',
  //
};
Map<String, String> russian = {
  'Al Quran': 'Коран', 'Privacy Policy': 'Политика конфиденциальности',
  'Select a language for app': 'Выберите язык приложения',
  'Previous': 'Предыдущий',
  'Setup': 'Настройка',
  'Data collected from': 'Данные, собранные из',
  'and': 'и',
  'Next': 'Далее',
  'Translation of Quran': 'Перевод Корана',
  'Translation Book': 'Книга переводов',
  "Select language for Quran's Tafsir": 'Выберите язык для Тафсира Корана',
  'Please Select Quran Translation Language':
      'Пожалуйста, выберите язык перевода Корана',
  'Please select a language for app':
      'Пожалуйста, выберите язык для приложения',
  'Please Select Quran Translation Book':
      'Пожалуйста, выберите книгу перевода Корана',
  'Please Select Quran Tafsir Language':
      'Пожалуйста, выберите язык Тафсира Корана',
  'Please Select Quran Tafsir Book':
      'Пожалуйста, выберите книгу Тафсира Корана',
  'Please select a default reciter': 'Пожалуйста, выберите чтеца по умолчанию',
  'Downloading': 'Загрузка',
  'Getting Quran': 'Загрузка данных Корана',
  'Downloading Translation': 'Загрузка перевода',
  'Downloading Tafsir': 'Загрузка Тафсира',
  'All Completed': 'Все завершено',
  'Failed to download translation': 'Не удалось загрузить перевод',
  'Failed to download tafsir': 'Не удалось загрузить тафсир',
  'Progress': 'Прогресс',
  'Processing tafsir': 'Обработка тафсира',
  'Full Quran with 65+ Translations': 'Полный Коран с 65+ переводами',
  '12 Tafsir Books in 6 Languages': '12 книг тафсиров на 6 языках',
  '40+ Recitations & Quran Audio Book': '40+ чтений и аудиокнига Корана',
  'Rich Notes, Bookmarks & Collections':
      'Расширенные заметки, Закладки и Коллекции',
  'Cloud Backup & Sync': 'Облачное резервное копирование и синхронизация',
  'History Tracking & Playlist Feature':
      'Отслеживание истории и функция плейлистов',
  //
};
Map<String, String> japanese = {
  'Al Quran': 'コーラン', 'Privacy Policy': 'プライバシーポリシー',
  'Select a language for app': 'アプリの言語を選択',
  'Previous': '前へ',
  'Setup': 'セットアップ',
  'Data collected from': 'からのデータ収集',
  'and': 'と',
  'Next': '次へ',
  'Translation of Quran': 'コーランの翻訳',
  'Translation Book': '翻訳書',
  "Select language for Quran's Tafsir": 'クルアーンのタفسィール（解釈）の言語を選択',
  'Please Select Quran Translation Language': 'クルアーンの翻訳言語を選択してください',
  'Please select a language for app': 'アプリの言語を選択してください',
  'Please Select Quran Translation Book': 'クルアーンの翻訳書を選択してください',
  'Please Select Quran Tafsir Language': 'クルアーンのタفسィール（解釈）の言語を選択してください',
  'Please Select Quran Tafsir Book': 'クルアーンのタفسィール（解釈）書を選択してください',
  'Please select a default reciter': 'デフォルトの朗読者を選択してください',
  'Downloading': 'ダウンロード中',
  'Getting Quran': 'コーランデータをダウンロード中',
  'Downloading Translation': '翻訳をダウンロード中',
  'Downloading Tafsir': 'タفسィールをダウンロード中',
  'All Completed': 'すべて完了',
  'Failed to download translation': '翻訳のダウンロードに失敗しました',
  'Failed to download tafsir': 'タفسィールのダウンロードに失敗しました',
  'Progress': '進捗',
  'Processing tafsir': 'タفسィールを処理中',
  'Full Quran with 65+ Translations': '65以上の翻訳付きフルコーラン',
  '12 Tafsir Books in 6 Languages': '6言語の12のタفسィール（解釈）書',
  '40+ Recitations & Quran Audio Book': '40以上の朗読とコーランオーディオブック',
  'Rich Notes, Bookmarks & Collections': 'リッチノート、ブックマーク、コレクション',
  'Cloud Backup & Sync': 'クラウドバックアップと同期',
  'History Tracking & Playlist Feature': '履歴追跡とプレイリスト機能',
  //
};
Map<String, String> punjabi = {
  'Al Quran': 'ਅਲ ਕੁਰਾਨ', 'Privacy Policy': 'ਪਰਾਈਵੇਸੀ ਪਾਲਿਸੀ',
  'Select a language for app': 'ਐਪ ਲਈ ਭਾਸ਼ਾ ਚੁਣੋ',
  'Previous': 'ਪਿਛਲਾ',
  'Setup': 'ਸੈਟਅੱਪ',
  'Data collected from': 'ਤੋਂ ਇਕੱਤਰ ਕੀਤਾ ਡਾਟਾ',
  'and': 'ਅਤੇ',
  'Next': 'ਅੱਗੇ',
  'Translation of Quran': 'ਕੁਰਾਨ ਦਾ ਅਨੁਵਾਦ',
  'Translation Book': 'ਅਨੁਵਾਦ ਪੁਸਤਕ',
  "Select language for Quran's Tafsir": 'قرآن دی تفسیر لئی بولی چونو',
  'Please Select Quran Translation Language':
      'براہ کرم قرآن ترجمہ زبان منتخب کرو',
  'Please select a language for app': 'براہ کرم ایپ لئی اک بولی چونو',
  'Please Select Quran Translation Book': 'براہ کرم قرآن ترجمہ کتاب منتخب کرو',
  'Please Select Quran Tafsir Language': 'براہ کرم قرآن تفسیر بولی منتخب کرو',
  'Please Select Quran Tafsir Book': 'براہ کرم قرآن تفسیر کتاب منتخب کرو',
  'Please select a default reciter': 'براہ کرم اک ڈیفالٹ قاری چونو',
  'Downloading': 'ਡਾਊਨਲੋਡ ਕੀਤਾ ਜਾ ਰਿਹਾ ਹੈ',
  'Getting Quran': 'قرآن ڈیٹا ڈاؤن لوڈ کیتا جا رہیا اے',
  'Downloading Translation': 'ترجمہ ڈاؤن لوڈ کیتا جا رہیا اے',
  'Downloading Tafsir': 'تفسیر ڈاؤن لوڈ کیتی جا رہی اے',
  'All Completed': 'سبھ مکمل ہو گیا',
  'Failed to download translation': 'ترجمہ ڈاؤن لوڈ کرن وچ ناکام رہیا',
  'Failed to download tafsir': 'تفسیر ڈاؤن لوڈ کرن وچ ناکام رہیا',
  'Progress': 'ترقی',
  'Processing tafsir': 'تفسیر پروسیس کیتی جا رہی اے',
  'Full Quran with 65+ Translations': '65+ ترجمیاں دے نال مکمل قرآن',
  '12 Tafsir Books in 6 Languages': '6 بولیاں وچ 12 تفسیر کتاباں',
  '40+ Recitations & Quran Audio Book': '40+ تلاوتاں تے قرآن آڈیو کتاب',
  'Rich Notes, Bookmarks & Collections': 'رچ نوٹس، بُک مارکس تے مجموعے',
  'Cloud Backup & Sync': 'کلاؤڈ بیک اپ تے سنک',
  'History Tracking & Playlist Feature': 'تریخ ٹریکنگ تے پلے لسٹ فیچر',
  //
};
Map<String, String> german = {
  'Al Quran': 'Der Koran', 'Privacy Policy': 'Datenschutzrichtlinie',
  'Select a language for app': 'App-Sprache auswählen',
  'Previous': 'Zurück',
  'Setup': 'Einrichtung',
  'Data collected from': 'Daten gesammelt von',
  'and': 'und',
  'Next': 'Weiter',
  'Translation of Quran': 'Übersetzung des Korans',
  'Translation Book': 'Übersetzungsbuch',
  "Select language for Quran's Tafsir": 'Sprache für Koran-Tafsir auswählen',
  'Please Select Quran Translation Language':
      'Bitte wählen Sie die Sprache für die Koranübersetzung aus',
  'Please select a language for app':
      'Bitte wählen Sie eine Sprache für die App aus',
  'Please Select Quran Translation Book':
      'Bitte wählen Sie ein Koran-Übersetzungsbuch aus',
  'Please Select Quran Tafsir Language':
      'Bitte wählen Sie die Sprache für Koran-Tafsir aus',
  'Please Select Quran Tafsir Book':
      'Bitte wählen Sie ein Koran-Tafsir-Buch aus',
  'Please select a default reciter':
      'Bitte wählen Sie einen Standard-Rezitator aus',
  'Downloading': 'Herunterladen',
  'Getting Quran': 'Lade Koran-Daten herunter',
  'Downloading Translation': 'Lade Übersetzung herunter',
  'Downloading Tafsir': 'Lade Tafsir herunter',
  'All Completed': 'Alles abgeschlossen',
  'Failed to download translation':
      'Übersetzung konnte nicht heruntergeladen werden',
  'Failed to download tafsir': 'Tafsir konnte nicht heruntergeladen werden',
  'Progress': 'Fortschritt',
  'Processing tafsir': 'Tafsir wird verarbeitet',
  'Full Quran with 65+ Translations':
      'Vollständiger Koran mit über 65 Übersetzungen',
  '12 Tafsir Books in 6 Languages': '12 Tafsir-Bücher in 6 Sprachen',
  '40+ Recitations & Quran Audio Book': '40+ Rezitationen & Koran-Hörbuch',
  'Rich Notes, Bookmarks & Collections':
      'Umfangreiche Notizen, Lesezeichen & Sammlungen',
  'Cloud Backup & Sync': 'Cloud-Backup & Synchronisierung',
  'History Tracking & Playlist Feature':
      'Verlaufsverfolgung & Playlist-Funktion',
  //
};
Map<String, String> french = {
  'Al Quran': 'Le Coran', 'Privacy Policy': 'Politique de confidentialité',
  'Select a language for app': 'Choisir la langue de l\'application',
  'Previous': 'Précédent',
  'Setup': 'Configuration',
  'Data collected from': 'Données recueillies auprès de',
  'and': 'et',
  'Next': 'Suivant',
  'Translation of Quran': 'Traduction du Coran',
  'Translation Book': 'Livre de traductions',
  "Select language for Quran's Tafsir":
      'Sélectionner la langue pour le Tafsir du Coran',
  'Please Select Quran Translation Language':
      'Veuillez sélectionner la langue de traduction du Coran',
  'Please select a language for app':
      'Veuillez sélectionner une langue pour l\'application',
  'Please Select Quran Translation Book':
      'Veuillez sélectionner un livre de traduction du Coran',
  'Please Select Quran Tafsir Language':
      'Veuillez sélectionner la langue du Tafsir du Coran',
  'Please Select Quran Tafsir Book':
      'Veuillez sélectionner un livre de Tafsir du Coran',
  'Please select a default reciter':
      'Veuillez sélectionner un récitant par défaut',
  'Downloading': 'Téléchargement en cours',
  'Getting Quran': 'Téléchargement des données du Coran',
  'Downloading Translation': 'Téléchargement de la traduction',
  'Downloading Tafsir': 'Téléchargement du Tafsir',
  'All Completed': 'Tout est terminé',
  'Failed to download translation': 'Échec du téléchargement de la traduction',
  'Failed to download tafsir': 'Échec du téléchargement du tafsir',
  'Progress': 'Progrès',
  'Processing tafsir': 'Tafsir en cours de traitement',
  'Full Quran with 65+ Translations':
      'Coran complet avec plus de 65 traductions',
  '12 Tafsir Books in 6 Languages': '12 Livres de Tafsir en 6 langues',
  '40+ Recitations & Quran Audio Book':
      'Plus de 40 récitations et livre audio du Coran',
  'Rich Notes, Bookmarks & Collections':
      'Notes enrichies, Signets & Collections',
  'Cloud Backup & Sync': 'Sauvegarde et synchronisation cloud',
  'History Tracking & Playlist Feature':
      'Suivi de l\'historique et fonctionnalité de playlist',
  //
};
Map<String, String> indonesian = {
  'Al Quran': 'Al-Qur\'an', 'Privacy Policy': 'Kebijakan Privasi',
  'Select a language for app': 'Pilih bahasa aplikasi',
  'Previous': 'Sebelumnya',
  'Setup': 'Pengaturan',
  'Data collected from': 'Data yang dikumpulkan dari',
  'and': 'dan',
  'Next': 'Selanjutnya',
  'Translation of Quran': 'Terjemahan Al-Qur\'an',
  'Translation Book': 'Buku Terjemahan',
  "Select language for Quran's Tafsir": 'Pilih bahasa untuk Tafsir Quran',
  'Please Select Quran Translation Language':
      'Silakan Pilih Bahasa Terjemahan Quran',
  'Please select a language for app': 'Silakan pilih bahasa untuk aplikasi',
  'Please Select Quran Translation Book': 'Silakan Pilih Buku Terjemahan Quran',
  'Please Select Quran Tafsir Language': 'Silakan Pilih Bahasa Tafsir Quran',
  'Please Select Quran Tafsir Book': 'Silakan Pilih Buku Tafsir Quran',
  'Please select a default reciter': 'Silakan pilih qari умолчанию',
  'Downloading': 'Mengunduh',
  'Getting Quran': 'Mengunduh Data Quran',
  'Downloading Translation': 'Mengunduh Terjemahan',
  'Downloading Tafsir': 'Mengunduh Tafsir',
  'All Completed': 'Semua Selesai',
  'Failed to download translation': 'Gagal mengunduh terjemahan',
  'Failed to download tafsir': 'Gagal mengunduh tafsir',
  'Progress': 'Progres',
  'Processing tafsir': 'Memproses tafsir',
  'Full Quran with 65+ Translations':
      'Al-Qur\'an Lengkap dengan 65+ Terjemahan',
  '12 Tafsir Books in 6 Languages': '12 Buku Tafsir dalam 6 Bahasa',
  '40+ Recitations & Quran Audio Book': '40+ Bacaan & Buku Audio Quran',
  'Rich Notes, Bookmarks & Collections': 'Catatan Kaya, Markah Buku & Koleksi',
  'Cloud Backup & Sync': 'Backup & Sinkronisasi Cloud',
  'History Tracking & Playlist Feature':
      'Pelacakan Riwayat & Fitur Daftar Putar',
  //
};
Map<String, String> urdu = {
  'Al Quran': 'القرآن', 'Privacy Policy': 'رازداری کی پالیسی',
  'Select a language for app': 'ایپ کے لیے زبان منتخب کریں',
  'Previous': 'پچھلا',
  'Setup': 'سیٹ اپ',
  'Data collected from': 'سے جمع کردہ ڈیٹا',
  'and': 'اور',
  'Next': 'اگلا',
  'Translation of Quran': 'قرآن کا ترجمہ',
  'Translation Book': 'ترجمہ کتاب',
  "Select language for Quran's Tafsir": 'قرآن کی تفسیر کے لیے زبان منتخب کریں',
  'Please Select Quran Translation Language':
      'برائے مہربانی قرآن ترجمہ کی زبان منتخب کریں',
  'Please select a language for app':
      'برائے مہربانی ایپ کے لیے ایک زبان منتخب کریں',
  'Please Select Quran Translation Book':
      'برائے مہربانی قرآن ترجمہ کتاب منتخب کریں',
  'Please Select Quran Tafsir Language':
      'برائے مہربانی قرآن تفسیر کی زبان منتخب کریں',
  'Please Select Quran Tafsir Book': 'برائے مہربانی قرآن تفسیر کتاب منتخب کریں',
  'Please select a default reciter': 'برائے مہربانی ایک ڈیفالٹ قاری منتخب کریں',
  'Downloading': 'ڈاؤن لوڈ ہو رہا ہے',
  'Getting Quran': 'قرآن ڈیٹا ڈاؤن لوڈ ہو رہا ہے',
  'Downloading Translation': 'ترجمہ ڈاؤن لوڈ ہو رہا ہے',
  'Downloading Tafsir': 'تفسیر ڈاؤن لوڈ ہو رہی ہے',
  'All Completed': 'سب مکمل ہو گیا',
  'Failed to download translation': 'ترجمہ ڈاؤن لوڈ کرنے میں ناکام',
  'Failed to download tafsir': 'تفسیر ڈاؤن لوڈ کرنے میں ناکام',
  'Progress': 'پیش رفت',
  'Processing tafsir': 'تفسیر پروسیس ہو رہی ہے',
  'Full Quran with 65+ Translations': '65+ تراجم کے ساتھ مکمل قرآن',
  '12 Tafsir Books in 6 Languages': '6 زبانوں میں 12 تفسیر کتب',
  '40+ Recitations & Quran Audio Book': '40+ تلاوتیں اور قرآن آڈیو کتاب',
  'Rich Notes, Bookmarks & Collections': 'رچ نوٹس، بُک مارکس اور مجموعے',
  'Cloud Backup & Sync': 'کلاؤڈ بیک اپ اور سنک',
  'History Tracking & Playlist Feature': 'تاریخ سے باخبر رہنا اور پلے لسٹ فیچر',
  //
};
Map<String, String> swahili = {
  'Al Quran': 'Kurani', 'Privacy Policy': 'Sera ya Faragha',
  'Select a language for app': 'Chagua lugha ya programu',
  'Previous': 'Iliyopita',
  'Setup': 'Usanidi',
  'Data collected from': 'Data zilizokusanywa kutoka',
  'and': 'na',
  'Next': 'Inayofuata',
  'Translation of Quran': 'Tafsiri ya Quran',
  'Translation Book': 'Kitabu cha Tafsiri',
  "Select language for Quran's Tafsir": 'Chagua lugha ya Tafsir ya Quran',
  'Please Select Quran Translation Language':
      'Tafadhali Chagua Lugha ya Tafsiri ya Quran',
  'Please select a language for app': 'Tafadhali chagua lugha ya programu',
  'Please Select Quran Translation Book':
      'Tafadhali Chagua Kitabu cha Tafsiri ya Quran',
  'Please Select Quran Tafsir Language':
      'Tafadhali Chagua Lugha ya Tafsir ya Quran',
  'Please Select Quran Tafsir Book':
      'Tafadhali Chagua Kitabu cha Tafsir ya Quran',
  'Please select a default reciter': 'Tafadhali chagua msomaji chaguo-msingi',
  'Downloading': 'Inapakua',
  'Getting Quran': 'Inapakua data za Quran',
  'Downloading Translation': 'Inapakua Tafsiri',
  'Downloading Tafsir': 'Inapakua Tafsir',
  'All Completed': 'Yote Yamekamilika',
  'Failed to download translation': 'Imeshindwa kupakua tafsiri',
  'Failed to download tafsir': 'Imeshindwa kupakua tafsir',
  'Progress': 'Maendeleo',
  'Processing tafsir': 'Inachakata tafsir',
  'Full Quran with 65+ Translations': 'Quran Kamili na Tafsiri 65+',
  '12 Tafsir Books in 6 Languages': 'Vitabu 12 vya Tafsir katika Lugha 6',
  '40+ Recitations & Quran Audio Book': 'Usomaji 40+ na Kitabu Sauti cha Quran',
  'Rich Notes, Bookmarks & Collections': 'Vidokezo Bora, Alamisho na Makusanyo',
  'Cloud Backup & Sync': 'Hifadhi Nakala na Usawazishaji Wingu',
  'History Tracking & Playlist Feature':
      'Ufuatiliaji wa Historia na Kipengele cha Orodha ya Kucheza',
  //
};
Map<String, String> korean = {
  'Al Quran': '코란', 'Privacy Policy': '개인 정보 정책',
  'Select a language for app': '앱 언어 선택',
  'Previous': '이전',
  'Setup': '설정',
  'Data collected from': '데이터 수집 출처',
  'and': '그리고',
  'Next': '다음',
  'Translation of Quran': '코란 번역',
  'Translation Book': '번역서',
  "Select language for Quran's Tafsir": '쿠란 타프시르 언어 선택',
  'Please Select Quran Translation Language': '쿠란 번역 언어를 선택하십시오',
  'Please select a language for app': '앱에 사용할 언어를 선택해주세요',
  'Please Select Quran Translation Book': '쿠란 번역서를 선택하십시오',
  'Please Select Quran Tafsir Language': '쿠란 타프시르 언어를 선택하십시오',
  'Please Select Quran Tafsir Book': '쿠란 타프시르 책을 선택하십시오',
  'Please select a default reciter': '기본 낭독자를 선택하십시오',
  'Downloading': '다운로드 중',
  'Getting Quran': '쿠란 데이터 다운로드 중',
  'Downloading Translation': '번역 다운로드 중',
  'Downloading Tafsir': '타프시르 다운로드 중',
  'All Completed': '모두 완료됨',
  'Failed to download translation': '번역 다운로드 실패',
  'Failed to download tafsir': '타프시르 다운로드 실패',
  'Progress': '진행',
  'Processing tafsir': '타프시르 처리 중',
  'Full Quran with 65+ Translations': '65개 이상의 번역본이 포함된 완전한 쿠란',
  '12 Tafsir Books in 6 Languages': '6개 언어로 된 12권의 타프시르 책',
  '40+ Recitations & Quran Audio Book': '40개 이상의 암송 및 쿠란 오디오북',
  'Rich Notes, Bookmarks & Collections': '풍부한 메모, 북마크 및 컬렉션',
  'Cloud Backup & Sync': '클라우드 백업 및 동기화',
  'History Tracking & Playlist Feature': '기록 추적 및 재생 목록 기능',
  //
};
Map<String, String> turkish = {
  'Al Quran': 'Kur\'an', 'Privacy Policy': 'Gizlilik Politikası',
  'Select a language for app': 'Uygulama dilini seçin',
  'Previous': 'Önceki',
  'Setup': 'Kurulum',
  'Data collected from': 'Veriler şuradan toplandı',
  'and': 've',
  'Next': 'Sonraki',
  'Translation of Quran': 'Kur\'an Tercümesi',
  'Translation Book': 'Tercüme Kitabı',
  "Select language for Quran's Tafsir": 'Kur\'an Tefsiri için dil seçin',
  'Please Select Quran Translation Language':
      'Lütfen Kur\'an Tercümesi Dilini Seçin',
  'Please select a language for app': 'Lütfen uygulama için bir dil seçin',
  'Please Select Quran Translation Book': 'Lütfen Kur\'an Tercüme Kitabı Seçin',
  'Please Select Quran Tafsir Language': 'Lütfen Kur\'an Tefsiri Dilini Seçin',
  'Please Select Quran Tafsir Book': 'Lütfen Kur\'an Tefsir Kitabı Seçin',
  'Please select a default reciter': 'Lütfen varsayılan bir okuyucu seçin',
  'Downloading': 'İndiriliyor',
  'Getting Quran': 'Kur\'an Verileri İndiriliyor',
  'Downloading Translation': 'Tercüme İndiriliyor',
  'Downloading Tafsir': 'Tefsir İndiriliyor',
  'All Completed': 'Hepsi Tamamlandı',
  'Failed to download translation': 'Tercüme indirilemedi',
  'Failed to download tafsir': 'Tefsir indirilemedi',
  'Progress': 'İlerleme',
  'Processing tafsir': 'Tefsir işleniyor',
  'Full Quran with 65+ Translations': '65+ Tercümeli Tam Kur\'an',
  '12 Tafsir Books in 6 Languages': '6 Dilde 12 Tefsir Kitabı',
  '40+ Recitations & Quran Audio Book': '40+ Tilavet ve Kur\'an Sesli Kitabı',
  'Rich Notes, Bookmarks & Collections':
      'Zengin Notlar, Yer İmleri ve Koleksiyonlar',
  'Cloud Backup & Sync': 'Bulut Yedekleme ve Senkronizasyon',
  'History Tracking & Playlist Feature':
      'Geçmiş Takibi ve Oynatma Listesi Özelliği',
  //
};
Map<String, String> vietnamese = {
  'Al Quran': 'Kinh Qur\'an', 'Privacy Policy': 'Chính sách bảo mật',
  'Select a language for app': 'Chọn ngôn ngữ ứng dụng',
  'Previous': 'Trước',
  'Setup': 'Thiết lập',
  'Data collected from': 'Dữ liệu thu thập từ',
  'and': 'và',
  'Next': 'Tiếp theo',
  'Translation of Quran': 'Bản dịch Kinh Quran',
  'Translation Book': 'Sách dịch',
  "Select language for Quran's Tafsir": 'Chọn ngôn ngữ cho Tafsir Kinh Quran',
  'Please Select Quran Translation Language':
      'Vui lòng chọn Ngôn ngữ dịch Kinh Quran',
  'Please select a language for app': 'Vui lòng chọn ngôn ngữ cho ứng dụng',
  'Please Select Quran Translation Book': 'Vui lòng chọn Sách dịch Kinh Quran',
  'Please Select Quran Tafsir Language':
      'Vui lòng chọn Ngôn ngữ Tafsir Kinh Quran',
  'Please Select Quran Tafsir Book': 'Vui lòng chọn Sách Tafsir Kinh Quran',
  'Please select a default reciter':
      'Vui lòng chọn một người ngâm thơ mặc định',
  'Downloading': 'Đang tải xuống',
  'Getting Quran': 'Đang tải dữ liệu Kinh Quran',
  'Downloading Translation': 'Đang tải bản dịch',
  'Downloading Tafsir': 'Đang tải Tafsir',
  'All Completed': 'Tất cả đã hoàn tất',
  'Failed to download translation': 'Tải xuống bản dịch không thành công',
  'Failed to download tafsir': 'Tải xuống tafsir không thành công',
  'Progress': 'Tiến độ',
  'Processing tafsir': 'Đang xử lý tafsir',
  'Full Quran with 65+ Translations': 'Toàn bộ Kinh Quran với hơn 65 bản dịch',
  '12 Tafsir Books in 6 Languages': '12 Sách Tafsir bằng 6 Ngôn ngữ',
  '40+ Recitations & Quran Audio Book': 'Hơn 40 Ngâm thơ & Sách nói Quran',
  'Rich Notes, Bookmarks & Collections':
      'Ghi chú phong phú, Dấu trang & Bộ sưu tập',
  'Cloud Backup & Sync': 'Sao lưu & Đồng bộ đám mây',
  'History Tracking & Playlist Feature':
      'Theo dõi lịch sử & Tính năng danh sách phát',
  //
};
Map<String, String> tamil = {
  'Al Quran': 'அல் குர்ஆன்', 'Privacy Policy': 'தனியுரிமைக் கொள்கை',
  'Select a language for app': 'பயன்பாட்டிற்கான மொழியைத் தேர்ந்தெடுக்கவும்',
  'Previous': 'முந்தைய',
  'Setup': 'அமைவு',
  'Data collected from': 'தரவு சேகரிக்கப்பட்டது',
  'and': 'மற்றும்',
  'Next': 'அடுத்து',
  'Translation of Quran': 'குர்ஆன் மொழிபெயர்ப்பு',
  'Translation Book': 'மொழிபெயர்ப்பு புத்தகம்',
  "Select language for Quran's Tafsir":
      'குர்ஆன் தஃப்சீர் மொழிக்குத் தேர்ந்தெடுக்கவும்',
  'Please Select Quran Translation Language':
      'குர்ஆன் மொழிபெயர்ப்பு மொழியைத் தேர்ந்தெடுக்கவும்',
  'Please select a language for app':
      'பயன்பாட்டிற்கு ஒரு மொழியைத் தேர்ந்தெடுக்கவும்',
  'Please Select Quran Translation Book':
      'குர்ஆன் மொழிபெயர்ப்பு புத்தகத்தைத் தேர்ந்தெடுக்கவும்',
  'Please Select Quran Tafsir Language':
      'குர்ஆன் தஃப்சீர் மொழியைத் தேர்ந்தெடுக்கவும்',
  'Please Select Quran Tafsir Book':
      'குர்ஆன் தஃப்சீர் புத்தகத்தைத் தேர்ந்தெடுக்கவும்',
  'Please select a default reciter': 'இயல்புநிலை ஓதுபவரைத் தேர்ந்தெடுக்கவும்',
  'Downloading': 'பதிவிறக்கம் செய்கிறது',
  'Getting Quran': 'குர்ஆன் தரவு பதிவிறக்கம் செய்கிறது',
  'Downloading Translation': 'மொழிபெயர்ப்பு பதிவிறக்கம் செய்கிறது',
  'Downloading Tafsir': 'தஃப்சீர் பதிவிறக்கம் செய்கிறது',
  'All Completed': 'அனைத்தும் முடிந்தது',
  'Failed to download translation': 'மொழிபெயர்ப்பைப் பதிவிறக்க முடியவில்லை',
  'Failed to download tafsir': 'தஃப்சீர் பதிவிறக்கம் செய்ய முடியவில்லை',
  'Progress': 'முன்னேற்றம்',
  'Processing tafsir': 'தஃப்சீர் செயலாக்கப்படுகின்றது',
  'Full Quran with 65+ Translations': '65+ மொழிபெயர்ப்புகளுடன் முழு குர்ஆன்',
  '12 Tafsir Books in 6 Languages': '6 மொழிகளில் 12 தஃப்சீர் புத்தகங்கள்',
  '40+ Recitations & Quran Audio Book':
      '40+ ஓதுதல்கள் & குர்ஆன் ஆடியோ புத்தகம்',
  'Rich Notes, Bookmarks & Collections':
      'சிறப்பான குறிப்புகள், புக்மார்க்குகள் & தொகுப்புகள்',
  'Cloud Backup & Sync': 'கிளவுட் காப்புப்பிரதி & ஒத்திசைவு',
  'History Tracking & Playlist Feature':
      'வரலாற்று கண்காணிப்பு & பிளேலிஸ்ட் அம்சம்',
  //
};
Map<String, String> italian = {
  'Al Quran': 'Il Corano', 'Privacy Policy': 'Informativa sulla privacy',
  'Select a language for app': 'Seleziona la lingua dell\'app',
  'Previous': 'Precedente',
  'Setup': 'Impostazioni',
  'Data collected from': 'Dati raccolti da',
  'and': 'e',
  'Next': 'Prossimo',
  'Translation of Quran': 'Traduzione del Corano',
  'Translation Book': 'Libro di traduzione',
  "Select language for Quran's Tafsir":
      'Seleziona la lingua per il Tafsir del Corano',
  'Please Select Quran Translation Language':
      'Si prega di selezionare la lingua di traduzione del Corano',
  'Please select a language for app':
      'Per favore, seleziona una lingua per l\'app',
  'Please Select Quran Translation Book':
      'Si prega di selezionare il libro di traduzione del Corano',
  'Please Select Quran Tafsir Language':
      'Si prega di selezionare la lingua del Tafsir del Corano',
  'Please Select Quran Tafsir Book':
      'Si prega di selezionare il libro del Tafsir del Corano',
  'Please select a default reciter':
      'Si prega di selezionare un recitatore predefinito',
  'Downloading': 'Download in corso',
  'Getting Quran': 'Download dei dati del Corano in corso',
  'Downloading Translation': 'Download della traduzione in corso',
  'Downloading Tafsir': 'Download del Tafsir in corso',
  'All Completed': 'Tutto completato',
  'Failed to download translation': 'Download della traduzione fallito',
  'Failed to download tafsir': 'Download del Tafsir fallito',
  'Progress': 'Progresso',
  'Processing tafsir': 'Tafsir in elaborazione',
  'Full Quran with 65+ Translations': 'Corano completo con oltre 65 traduzioni',
  '12 Tafsir Books in 6 Languages': '12 Libri di Tafsir in 6 lingue',
  '40+ Recitations & Quran Audio Book':
      'Oltre 40 recitazioni e audiolibro del Corano',
  'Rich Notes, Bookmarks & Collections': 'Note ricche, Segnalibri e Raccolte',
  'Cloud Backup & Sync': 'Backup e sincronizzazione cloud',
  'History Tracking & Playlist Feature':
      'Tracciamento della cronologia e funzione playlist',
  //
};
