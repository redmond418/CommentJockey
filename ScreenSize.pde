//フルスクリーン時とそうでない時で見た目が変わらないように無理やり歪める
public final int width = 800;
public final int height = 450;

public float getWidthRatio() { return (float)super.width / width; }
public float getHeightRatio() { return (float)super.height / height; }

public float getOriginWidth() { return super.width; }
public float getOriginHeight() { return super.height; }
