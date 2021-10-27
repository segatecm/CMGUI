//
// ImGUI for Processing
//

class BoxState
{
  public int m_x;
  public int m_y;

  public int start_x;
  public int start_y;
  
  // c_w, c_h: box current size
  public int c_w;
  public int c_h;
  
  void ExtendTo(int x, int y)
  {
    if (start_x + c_w < x)
      c_w = x - start_x;
    if (start_y + c_h < y)
      c_h = y - start_y;
  }
  
  void SetY(int y)
  {
    c_h = y - start_y;
  }
}

enum ControlAction
{
  normal,
  over,
  select,
}

class CMGUI
{
  boolean box = false;
  
  Rect area = new Rect();
  Rect current = new Rect(0, 0, 0, 30);
  Rect maskR = new Rect();
  Rect renderR = new Rect();
  
  // means it has range limit
  boolean extend = true;
  int margin_hor = 2;
  int margin_col = 2;
  int mouse_x = 0;
  int mouse_y = 0;
  int mouse_scroll = 0;
  int scroll_speed = 10;
  
  // Vscroll box height
  int scroll_h = 0;
  
  // default control H
  int control_h = 40;
  
  int edit_input_id = 0;
  
  boolean mouse_down = false;
  
  color normal = color(100);
  color highlight = color(120);
  color select = color(50);
  color box_back = color(32, 32, 32, 127);
  
  color font_color = color(200);
  int font_size = 12;
  
  int control_id = 0;
  int select_id = 0;
  ControlAction action = ControlAction.normal;
  
  float mouse_wheel = 0;
  
  ArrayList<BoxState> work_state = new ArrayList();
  
  boolean InControl(int x, int y, int bx, int by, int bw, int bh)
  {
    if (area.PointIn(x, y))
    {
      if (x >= bx && y >= by && x <= bx + bw && y <= by + bh)
        return true;
      else
        return false;
    }
    else
      return false;
  }
  
  public int LastW()
  {
    return area.w - current.x;
  }
  
  public int LastH()
  {
    return area.h - current.y;
  }
  
  // param 
  // name is the box control id
  // 
  public void BeginBox(int x, int y, int w, int h)
  {
    if (box == true)
    {
      print("can not use box again");
    }
    area.x = 0;
    area.y = 0;
    area.w = w;
    area.h = h;
    box = true;
    
    current.w = area.w;
    current.x = 0;
    current.y = 0;
    
    mouse_x = mouseX - x;
    mouse_y = mouseY - y;
    
    pushMatrix();
    translate(x, y);
    BeginVBox();
    
    control_id = 0;
    
    imageMode(CORNER);
    
    // effect by translate
    clip(0, 0, area.w, area.h + 1);
    
    fill(box_back);
    noStroke();
    rect(area.x, area.y, area.w, area.h);
  }
   //<>//
  public void EndBox() //<>//
  {
    if (box == false)
    {
      print("can not use EndBox");
    }
    popMatrix();
    noClip();
    box = false;
    EndVBox();
    if (work_state.size() != 0)
      println("EndBox: work state not zero");
  }
  
  void PushState(int move_x, int move_y)
  {
    var bs = new BoxState();
    bs.m_x = move_x;
    bs.m_y = move_y;
    bs.start_x = current.x;
    bs.start_y = current.y;
    
    bs.c_w = 0;
    bs.c_h = 0;
    work_state.add(bs);
  }
  
  void PopState()
  {
    if (work_state.size() > 0)
      work_state.remove(work_state.size() - 1);
    else
      println("state pop error");
  }
  BoxState CurrentState()
  {
    if (work_state.size() > 0)
      return work_state.get(work_state.size() - 1);
    else
    {
      //println("state get error");
      return null;
    }
  }
  public void Label(String title, int alignx, int ... params)
  {
    var vis = LayoutControl(params);
    if (params.length == 0)
      renderR.w = (int)(textWidth(title) + 1);
    current.w = renderR.w + margin_hor;
    
    
    if (vis)
    {
      textAlign(alignx, CENTER);
    
      fill(font_color);
      text(title, renderR.x, renderR.y, renderR.w, renderR.h); //<>//
    }
    
    MoveToNext();
  }
  
  void ExtendAll(int x, int y)
  {
    for (int i = 0; i < work_state.size(); i++)
    {
      work_state.get(i).ExtendTo(x, y);
    }
  }
  
  void SetY(int y)
  {
    for (int i = 0; i < work_state.size(); i++)
    {
      work_state.get(i).SetY(y);
    }
  }
  
  void MoveToNext()
  {
    var state = CurrentState();
    //fill(0, 0, 255, 50);
    //noStroke();
    //rect(current.x + 3, current.y + 3, current.w - 6, current.h - 6);
    
    if (state.m_x == 1)
    {
      state.c_h = max(state.c_h, current.h);
      current.x += current.w * state.m_x;
    }
    else
    {
      state.c_w = max(state.c_w, current.w);
      current.y += current.h * state.m_y;
    }
    
    if (state.m_x == 1)
      ExtendAll(current.x, current.y + current.h);
    if (state.m_y == 1)
      ExtendAll(current.x + current.w, current.y);
  }
  
  
  // 1 : all 
  // 2 : left right, top bottom
  void Margin(int ... params)
  {
    if (params.length == 1)
    {
      margin_hor = margin_col = params[0];
    }
    else if (params.length == 2)
    {
      margin_hor = params[0];
      margin_col = params[1];
    }
  }
  
  boolean MouseControl()
  {
    boolean clicked = false;
    action = ControlAction.normal;
    
    Rect range;
    if (extend == false)
      range = maskR.Intersect(renderR);
    else
      range = renderR;
    if (InControl(mouse_x, mouse_y, range.x, range.y, range.w, range.h))
    {
      if (mousePressed && (mouseButton == LEFT)) 
      {
        if (mouse_down == false)
          select_id = control_id;
          
        mouse_down = true;
        action = ControlAction.select;
      }
      else
      {
        if (mouse_down == true)
        {
          if (select_id == control_id)
            clicked = true; //<>//
        }

        mouse_down = false;
        action = ControlAction.over;
      }
    }
      
    return clicked;
  }
  
  public boolean Button(String title, int ... params)
  {
    var vis = LayoutControl(params);
    
    var clicked = MouseControl();
    if (action == ControlAction.over)
      fill(highlight);
    else if (action == ControlAction.normal)
      fill(normal);
    else if (action == ControlAction.select)
      fill(select);
    
    if (vis)
    {
      stroke(highlight);
    
      // -1 for stroke
      rect(renderR.x, renderR.y, renderR.w - 1, renderR.h - 1, 4, 4, 4, 4);
      
      if (title.length() > 0)
      {
        textAlign(CENTER, CENTER);
        fill(font_color);
        text(title, renderR.x, renderR.y, renderR.w, renderR.h);
      }
    }
    
    
    MoveToNext();
      
    return clicked;
  }
  
  public boolean Dummy(color c, int ... params)
  {
    LayoutControl(params);
    fill(c);
    noStroke();
    rect(renderR.x, renderR.y, renderR.w, renderR.h);
    var clicked = MouseControl();
    return clicked;
  }
  
  public boolean CheckButton(String title, boolean check, int ... params)
  {
    var vis = LayoutControl(params);
    
    var clicked = MouseControl();
    if (clicked)
      check = !check;
    
    if (vis)
    {
      if (check)
        fill(select);
      else
        fill(normal);
      if (action == ControlAction.over)
        fill(highlight);
      
      stroke(highlight);
      // -1 for stroke
      rect(renderR.x, renderR.y, renderR.w - 1, renderR.h - 1, 4, 4, 4, 4);
      
      if (title.length() > 0)
      {
        textAlign(CENTER, CENTER);
        fill(font_color);
        text(title, renderR.x, renderR.y, renderR.w, renderR.h);
      }
    }
    
    
    MoveToNext();
      
    return check;
  }
  
  public void Image(PImage img, int ... params)
  {
    var vis = LayoutControl(params);
    float is = (float)img.width / (float)img.height;
    renderR.h = (int)(renderR.w / is);
    if (vis)
      image(img, renderR.x, renderR.y, renderR.w, renderR.h);
    MoveToNext();
  }
  
  public void BeginHBox()
  {
    PushState(1, 0);
  }
  
  // update current value
  public void EndHBox()
  {
    var state = CurrentState();
    //noFill();
    //stroke(255, 0, 0);
    //rect(state.start_x + 1, state.start_y + 1, state.c_w - 2, state.c_h - 2);
    
    PopState();
    var pre_state = CurrentState();
      
    if (pre_state != null)
    {
      if (pre_state.m_x == 1)
      {
        current.x = pre_state.start_x + pre_state.c_w;
        current.y = pre_state.start_y;
      }
      if (pre_state.m_y == 1)
      {
        current.x = pre_state.m_x;
        current.y = pre_state.start_y + pre_state.c_h;
      }
    }
  }
  
  public void BeginVBox()
  {
    PushState(0, 1);
  }
  
  // update current value
  public void EndVBox()
  {    
    var state = CurrentState();
    //noFill();
    //stroke(0, 255, 0);
    //rect(state.start_x, state.start_y, state.c_w, state.c_h);
    
    PopState();
    var pre_state = CurrentState();
      
    if (pre_state != null)
    {
      if (pre_state.m_x == 1)
      {
        current.x = pre_state.start_x + pre_state.c_w;
        current.y = pre_state.start_y;
      }
      if (pre_state.m_y == 1)
      {
        current.x = pre_state.m_x;
        current.y = pre_state.start_y + pre_state.c_h;
      }
    }
  }
  
  // return: is the control in view range
  boolean LayoutControl(int ... params)
  {
    control_id++;
    
    current.w = area.w - current.x;
    current.h = control_h;
    // use input
    if (params.length >= 1)
      current.w = params[0];
    if (params.length >= 2)
      current.h = params[1];
      
    renderR.x = current.x + margin_hor;
    renderR.w = current.w - margin_hor * 2;
    renderR.y = current.y + margin_col;
    renderR.h = current.h - margin_col * 2;
    
    if (extend == false)
    {
      if (current.y + current.h < maskR.y)
        return false;
      if (current.y > maskR.bottom())
        return false;
    }
    
    return true;
  }
  
  void Seperator(int o)
  {
    var state = CurrentState();
    current.w = state.m_x * o;
    current.h = state.m_y * o;
    
    MoveToNext();
  }
  
  float SliderV(float vin, float vmin, float vmax, int ... params)
  {
    boolean vis = LayoutControl(params);
    if (vis)
    {
      int bx = renderR.x + 20;
      int bw = renderR.w - 40;
      int by = renderR.y + (renderR.h - 10) / 2;
      int bh = 10;
      
      int cx = bx;
      int cw = 20;
      int ch = 30;
      
      MouseControl();
      float v;
      if (current.PointIn(mouse_x, mouse_y) && mouse_down)
      {
        v = (float)(mouse_x - bx) / (float)bw;
        if (v < 0)
          v = 0;
        else if (v > 1)
          v = 1;
      }
      else
      {
        v = (vin - vmin) / (vmax - vmin);
      }

      cx = bx + (int)(v * bw);
      
      vin = vmin + v * (vmax - vmin);
      
      if (action == ControlAction.over)
        fill(highlight);
      else
        fill(normal);

      rect(bx, by, bw, bh);
      stroke(select);
      pushMatrix();
      translate(cx, by);
      rect(-10, -10, cw, ch, 4, 4, 0, 0);
      popMatrix();
    }
    MoveToNext();
    return vin;
  }
  
  public String InputText(String txt, int ... params)
  {
    boolean vis = LayoutControl(params);
    if (vis)
    {
      MouseControl();
      
      if (action == ControlAction.over)
      {
        if (keyPressed && frameCount % 8 == 0)
        {
          println(key);
        }
        fill(highlight);
      }
      else
        fill(normal);
      rect(renderR.x, renderR.y, renderR.w, renderR.h);
    }
    return txt;
  }
  
  public boolean Debug(String info, boolean debug_vis, int ... params)
  {
    boolean v = LayoutControl(params);
    var clicked = false;
    
    if (v)
      clicked = MouseControl();
    
    if (debug_vis && v)
    {
      stroke(0);
      fill(255);
      rect(renderR.x, renderR.y, renderR.w - 1, renderR.h - 1);
      fill(0);
      text(info, renderR.x, renderR.y, renderR.w, renderR.h);
    }
    
    MoveToNext();
    
    return clicked;
  }
  
  // params 0: scroll view height
  public int BegineScrollH(int position, int ... params)
  {
    extend = false;
    maskR.x = current.x;
    maskR.y = current.y;
    if (params.length == 0)
      maskR.h = LastH();
    else
      maskR.h = params[0];
    maskR.w = LastW();
    
    if (maskR.PointIn(mouse_x, mouse_y))
    {
      position += mouse_scroll * scroll_speed;
      if (position < 0) position = 0;
    }
    current.y -= position;
    
    
    PushState(0, 1);

    clip(maskR.x, maskR.y, maskR.w, maskR.h);
    
    
    return position;
  }
   //<>//
  public void EndScollH()
  {
    EndHBox();
    extend = true;
    current.y = maskR.y + maskR.h;
    SetY(current.y); // restore all stack h value
    noClip();
    
    //fill(255);
    //text("end scroll y:" + current.y, maskR.x, current.y); 
  }
  
  public boolean Block(color c, int ... params)
  {
    LayoutControl(params); //<>//
    
    var clicked = MouseControl();
    
    
    fill(c);
    rect(renderR.x, renderR.y, renderR.w, renderR.h);
    
    MoveToNext();
    return clicked;
  }
  
  // return index
  public int Pallet(color[] colors, int select, int column, int ... params)
  {
    BeginHBox();
    Label("select:", LEFT, 40);
    Block(colors[select]);
    EndHBox();
    int p_w = area.w / column;
    for (int i = 0; i < colors.length; i++)
    {
      if (i % column == 0) //<>// //<>//
        BeginHBox();
      if (Block(colors[i], p_w, p_w))
      {
        select = i;
      }
      if (i % column == column - 1)
        EndHBox();
    }
    if (colors.length % column != 0)
      EndHBox();
    
    MoveToNext();
    return select;
  }
}
