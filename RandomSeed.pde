public static class RandomSeed
{
  public static int fromString(String text)
  {
    int result = 0;
    byte[] bytes = text.getBytes();
    for(byte num : bytes)
    {
      result += num;
    }
    return result;
  }
}
