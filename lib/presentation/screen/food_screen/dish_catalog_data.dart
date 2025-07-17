class DishData {
  final String name;
  final String imagePath;

  DishData({required this.name, required this.imagePath});
}

final Map<String, List<String>> dishCatalogData = {
  '主食': [''],
  '主菜': ['ネギ塩炒め', '唐揚げ', 'ハンバーグ'],
  '副菜': ['サラダ', 'きんぴらごぼう', 'ポテトサラダ'],
  '汁物': ['味噌汁', 'コーンスープ'],
};
