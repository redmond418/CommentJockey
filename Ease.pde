public enum Ease {
  LINEAR(0),
  IN_SINE(1),
  OUT_SINE(2),
  IN_OUT_SINE(3),
  IN_QUAD(4),
  OUT_QUAD(5),
  IN_OUT_QUAD(6),
  IN_CUBIC(7),
  OUT_CUBIC(8),
  IN_OUT_CUBIC(9),
  IN_QUART(10),
  OUT_QUART(11),
  IN_OUT_QUART(12),
  IN_QUINT(13),
  OUT_QUINT(14),
  IN_OUT_QUINT(15),
  IN_EXPO(16),
  OUT_EXPO(17),
  IN_OUT_EXPO(18),
  IN_EXPOHARD(19),
  OUT_EXPOHARD(20),
  IN_OUT_EXPOHARD(21);
  
  private final int num;

  private Ease(int num) {
    this.num = num;
  }
  
  public float evaluate(float x) {
    switch(num) {
      case 1: // easeInSine
        return 1 - cos((x * PI) / 2);
      case 2: // easeOutSine
        return sin((x * PI) / 2);
      case 3: // easeInOutSine
        return -(cos(PI * x) - 1) / 2;
      case 4: // easeInQuad
        return x * x;
      case 5: // easeOutQuad
        return 1 - (1 - x) * (1 - x);
      case 6: // easeInOutQuad
        return x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2;
      case 7: // easeInCubic
        return x * x * x;
      case 8: // easeOutCubic
        return 1 - pow(1 - x, 3);
      case 9: // easeInOutCubic
        return x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2;
      case 10: // easeInQuart
        return x * x * x * x;
      case 11: // easeOutQuart
        return 1 - pow(1 - x, 4);
      case 12: // easeInOutQuart
        return x < 0.5 ? 8 * x * x * x * x : 1 - pow(-2 * x + 2, 4) / 2;
      case 13: // easeInQuint
        return x * x * x * x * x;
      case 14: // easeOutQuint
        return 1 - pow(1 - x, 5);
      case 15: // easeInOutQuint
        return x < 0.5 ? 16 * x * x * x * x * x : 1 - pow(-2 * x + 2, 5) / 2;
      case 16: // easeInExpo
        return x == 0 ? 0 : pow(2, 10 * x - 10);
      case 17: // easeOutExpo
        return x == 1 ? 1 : 1 - pow(2, -10 * x);
      case 18: // easeInOutExpo
        if (x == 0) return 0;
        if (x == 1) return 1;
        return x < 0.5 ? pow(2, 20 * x - 10) / 2 : (2 - pow(2, -20 * x + 10)) / 2;
      case 19: // easeInExpoHard
        return x == 0 ? 0 : pow(2, 20 * x - 20);
      case 20: // easeOutExpoHard
        return x == 1 ? 1 : 1 - pow(2, -20 * x);
      case 21: // easeInOutExpoHard
        if (x == 0) return 0;
        if (x == 1) return 1;
        return x < 0.5 ? pow(2, 40 * x - 20) / 2 : (2 - pow(2, -40 * x + 20)) / 2;
      default: // linear
        return x;
    }
  }
}
