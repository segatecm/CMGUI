class Rect
{
  public int x;
  public int y;
  public int w;
  public int h;
  
  Rect()
  {
  }
  
  Rect(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  int right()
  {
    return x + w;
  }
  
  int bottom()
  {
    return y + h;
  }
  
  boolean PointIn(int ix, int iy)
  {
    if (ix >= x && iy >= y && ix < x + w && iy < y + h)
      return true;
    else
      return false;
  }
  
  // rect 0: (x1,y1),(x2,y2)
  // rect 1: (x3,y3),(x4,y4)
  // return: max(x1,x3)<=min(x2,x4)&&max(y1,y3)<=min(y2,y4)
  boolean RectIn(Rect r)
  {
    return max(x, r.x) <= min(right(), r.right()) && max(y, r.y) <= min(bottom(), r.bottom());
  }
  
  void Set(int v)
  {
    this.x = v;
    this.y = v;
    this.w = v;
    this.h = v;
  }
  
  Rect Intersect(Rect r)
  {
    Rect new_r = new Rect();
    
    int max_left = max(r.x, x);
    int min_right = min(r.right(), right());
    int max_top = max(r.y, y);
    int min_bottom = min(r.bottom(), bottom());
    
    if (max_left >= min_right || max_top >= min_bottom)
      return new_r;
    else
    {
      new_r.x = max_left;
      new_r.w = min_right - max_left;
      new_r.y = max_top;
      new_r.h = min_bottom - max_top;
      return new_r;
    }
  }
}
