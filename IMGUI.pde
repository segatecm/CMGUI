CMGUI im = new CMGUI();

PImage t;

void setup()
{
  size(800, 600);
  t = loadImage("icon.png");
}

void draw()
{
  background(255);
  
  im.BeginBox(0, 0, 300, 800);  
  TestScrollH();
  //TestButtons();
  im.EndBox();
  
  //im.BeginBox(0, 0, 300, 400);  
  //TestScrollH();
  ////TestSlider();
  ////TestInput();
  //im.EndBox();
  
  im.scroll_speed = 30;
  
  im.mouse_scroll = 0;
}

String txt_input = "";
void TestInput()
{
  txt_input = im.InputText(txt_input);
}

int off_y = 0;
boolean checked = false;
int selectd = 0;

boolean choose_one = true;
boolean choose_two = true;
boolean choose_three = true;

void TestScrollH()
{
  
  im.Label("Scroll View", CENTER, im.LastW());
  off_y = im.BegineScrollH(off_y, 200);
  for (int i = 0; i < 10; i++)
  {
    im.BeginHBox();
    
    if (i == selectd)
    {
      im.Dummy(color(21, 66, 143), im.LastW(), 50);
    }
    else
      if (im.Dummy(im.normal, im.LastW(), 50))
          selectd = i;
    
    im.Label("item:", LEFT);
    im.Image(t, 30);
    if (im.Debug("click" + i, true))
      println(i);
    im.EndHBox();
  }
  
  im.EndScollH();
  
  im.Label("check button", LEFT);
  im.BeginHBox();
  choose_one = im.CheckButton("one", choose_one, 50); //<>//
  choose_two = im.CheckButton("two", choose_two, 50);
  choose_three = im.CheckButton("three", choose_three, 50);
  im.EndHBox();
  
  im.Label("Margin", LEFT);
  im.Margin(20, 4);
  im.BeginHBox();
  
  im.Button("yes", im.LastW() / 2);
  im.Button("no");
  im.EndHBox();
  
  im.Margin(2, 2);
  TestSlider();
}

float slider = 0;
void TestSlider()
{
  im.BeginHBox();
  im.Label("value:" + slider, LEFT, 100);
  slider = im.SliderV(slider, 0, 100);
  im.EndHBox();
}

void Test4()
{
  im.BeginHBox();
  im.BeginVBox();
  im.Debug("0", true, 45);
  im.Debug("1", true, 60);
  im.EndVBox();
  im.Debug("2", true);
  im.EndHBox();
}

void Test0()
{
  im.Margin(20, 5);
  var w = (int)(im.LastW() * 0.5);
  for (int i = 0; i < 1; i++)
  {
    im.BeginHBox();
    im.Button("yes", w);
    im.Button("no", w);
    im.EndHBox();
  }
 
}

void TestImage()
{
  im.BeginHBox();
  im.Label("Hand:", LEFT);
  im.Image(t);
  im.EndHBox();
}

void Test3()
{
  im.BeginVBox();
  im.BeginHBox();
  im.BeginVBox();
  im.Debug("5", true, 100);
  im.Debug("6", true, 100);
  im.EndVBox();
  im.Debug("1", true, 100);
  im.Debug("2", true, 100);
  im.EndHBox();
  
  im.Debug("3", true);
  im.EndVBox();
}

void TestButtons()
{
  im.BeginHBox();
  im.Label("hello", LEFT);
  im.Button("1", 100);
  im.EndHBox();
  
  im.BeginHBox();
  im.Button("2", 50);
  im.Button("3");
  im.EndHBox();

}

void TestSeperator()
{
  im.BeginVBox();
  im.BeginHBox();
  im.Label("hello", LEFT);
  im.Seperator(5);
  im.Button("1", 100);
  im.EndHBox();
  
  im.Seperator(10);
  
  im.BeginHBox();
  im.Button("2", 50);
  im.Seperator(5);
  im.Button("3");
  im.EndHBox();
  im.EndVBox();
}

void Test2()
{
  im.BeginHBox();
  im.Debug("1", true, 100);
  im.Debug("2", true, 100);
  im.EndHBox();
  
  im.Debug("3", true);
}

void Test1()
{
  im.BeginHBox();
  im.BeginVBox();
  im.Debug("1", true, 150);
  im.Debug("2", true, 150);
  im.Debug("3", true, 150);
  im.EndVBox();
  
  im.BeginVBox();
  im.Debug("1", true, 150);
  im.Debug("2", true, 150);
  im.EndVBox();
  
  im.EndHBox();
}

void mouseWheel(MouseEvent event) {
  im.mouse_scroll = event.getCount();
}
