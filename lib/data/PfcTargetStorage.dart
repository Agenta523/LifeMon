// PFCの1日目標量を表すエンティティ
class PfcTarget {
  final double proteinGram;
  final double fatGram;
  final double carboGram;

  PfcTarget({
    required this.proteinGram,
    required this.fatGram,
    required this.carboGram,
  });

  // 永続化用にMapへ変換
  Map<String, dynamic> toMap() => {
        'proteinGram': proteinGram,
        'fatGram': fatGram,
        'carboGram': carboGram,
      };

  // Mapから復元
  factory PfcTarget.fromMap(Map<String, dynamic> map) {
    return PfcTarget(
      proteinGram: (map['proteinGram'] as num).toDouble(),
      fatGram:     (map['fatGram']     as num).toDouble(),
      carboGram:   (map['carboGram']   as num).toDouble(),
    );
  }
}