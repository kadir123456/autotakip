class ScrollConfig {
  final String direction; // 'down', 'up', 'both'
  final int delaySeconds;
  final int repeatCount;
  
  const ScrollConfig({
    required this.direction,
    required this.delaySeconds,
    required this.repeatCount,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'direction': direction,
      'delay': delaySeconds,
      'repeat': repeatCount,
    };
  }
  
  factory ScrollConfig.fromMap(Map<String, dynamic> map) {
    return ScrollConfig(
      direction: map['direction'] ?? 'down',
      delaySeconds: map['delay'] ?? 2,
      repeatCount: map['repeat'] ?? 10,
    );
  }
  
  ScrollConfig copyWith({
    String? direction,
    int? delaySeconds,
    int? repeatCount,
  }) {
    return ScrollConfig(
      direction: direction ?? this.direction,
      delaySeconds: delaySeconds ?? this.delaySeconds,
      repeatCount: repeatCount ?? this.repeatCount,
    );
  }
}

class ScrollStatus {
  final bool isScrolling;
  final bool isPaused;
  final int currentCount;
  final int totalCount;
  final String direction;
  
  const ScrollStatus({
    required this.isScrolling,
    required this.isPaused,
    required this.currentCount,
    required this.totalCount,
    required this.direction,
  });
  
  factory ScrollStatus.initial() {
    return const ScrollStatus(
      isScrolling: false,
      isPaused: false,
      currentCount: 0,
      totalCount: 10,
      direction: 'down',
    );
  }
  
  factory ScrollStatus.fromMap(Map<dynamic, dynamic> map) {
    return ScrollStatus(
      isScrolling: map['isScrolling'] ?? false,
      isPaused: false,
      currentCount: map['currentCount'] ?? 0,
      totalCount: map['totalCount'] ?? 10,
      direction: map['direction'] ?? 'down',
    );
  }
  
  double get progress {
    if (totalCount == 0) return 0.0;
    return currentCount / totalCount;
  }
  
  ScrollStatus copyWith({
    bool? isScrolling,
    bool? isPaused,
    int? currentCount,
    int? totalCount,
    String? direction,
  }) {
    return ScrollStatus(
      isScrolling: isScrolling ?? this.isScrolling,
      isPaused: isPaused ?? this.isPaused,
      currentCount: currentCount ?? this.currentCount,
      totalCount: totalCount ?? this.totalCount,
      direction: direction ?? this.direction,
    );
  }
}