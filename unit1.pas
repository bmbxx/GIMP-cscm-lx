unit Unit1;                        // progressbar!!

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  DefaultTranslator, ExtCtrls, ComCtrls, StdCtrls, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  FileName, NewFileName: string;
  pixels: integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem4Click(Sender: TObject); // opens a file/image
begin
  if OpenDialog1.Execute then
    begin
      FileName := OpenDialog1.Filename;
    end;
  Form1.Image1.Picture.LoadFromFile(FileName);
end;

procedure TForm1.MenuItem5Click(Sender: TObject); // save as BMP  (!!!)
var vB: Byte;
    vW: Word;
    vI: Integer;
    f: File;
begin
  if SaveDialog1.Execute then
    begin
      NewFileName := SaveDialog1.FileName;
    end;
  assignFile(f, NewFileName + '.bmp');
  rewrite(f,1);

  // file header
  vB := ord('B');
  blocKWrite(f, vB, sizeof(vB));
  vB := ord('M');
  blocKWrite(f, vB, sizeof(vB));
  vI := 14 + 40 + (Image1.Height * Image1.Width * 3);   //!!!
  blocKWrite(f, vI, sizeof(vI));
  vW := word(0);
  blocKWrite(f, vW, sizeof(vW));
  blocKWrite(f, vW, sizeof(vW));

  // image header
  vI := 40;
  blocKWrite(f, vI, sizeof(vI));
  vI := Image1.Width;
  blocKWrite(f, vI, sizeof(vI));
  vI := Image1.Height;
  blocKWrite(f, vI, sizeof(vI));
  vW := word(1);
  blocKWrite(f, vW, sizeof(vW));

  // pixel data


  closeFile(f);
end;

procedure TForm1.Button1Click(Sender: TObject); // resets the image
begin
  Form1.Image1.Picture.LoadFromFile(FileName);
  ProgressBar1.Position := 0;
  pixels := 0;
end;

procedure TForm1.MenuItem6Click(Sender: TObject); //exits
begin
  Application.Terminate;
end;

procedure TForm1.MenuItem7Click(Sender: TObject); // brighter effect
var i, j: integer;
    r, g, b: byte;
    brightness: real;
    clr: TColor;
begin
  Form2.ShowModal; // shows track bar
  brightness := bP / 10; // brightness percentage
  for i := 0 to Image1.Picture.Width do
    begin
      for j := 0 to Image1.Picture.Height do
        begin
          clr := Image1.Picture.Bitmap.Canvas.Pixels[i, j];
          if (round( (Red(clr)) + (Red(clr) * brightness) ) > 255) then
            r := 255 // if it passes white, it stays white, else the correspondent color
            else
              r := round( (Red(clr)) + (Red(clr) * brightness) );
          if (round( (Green(clr)) + (Green(clr) * brightness) ) > 255) then
            g := 255
            else
              g := round( (Green(clr)) + (Green(clr) * brightness) );
          if (round( (Blue(clr)) + (Blue(clr) * brightness) ) > 255) then
            b := 255
            else
              b := round( (Blue(clr)) + (Blue(clr) * brightness) );
          Image1.Picture.Bitmap.Canvas.Pixels[i, j] := RGBToColor(r, g, b);
        end;
      Application.ProcessMessages;
    end;
end;

procedure TForm1.MenuItem8Click(Sender: TObject); // red channel
var i, j: integer;
    r: byte;
begin
  pixels := 0;
  ProgressBar1.Position := 0;
  for i := 0 to Image1.Picture.Width do
    begin
      for j := 0 to Image1.Picture.Height do
        begin
          r := Red(Image1.Picture.Bitmap.Canvas.Pixels[i, j]);
          Image1.Picture.Bitmap.Canvas.Pixels[i, j] := RGBToColor(r, 0, 0);
          pixels := pixels + 1;
          ProgressBar1.Position := round((pixels / (Image1.Picture.Width * Image1.Picture.Height)) * 100);
        end;
      Application.ProcessMessages;
    end;
end;

procedure TForm1.MenuItem9Click(Sender: TObject); // green channel
var i, j: integer;
    g: byte;
begin
  for i := 0 to Image1.Picture.Width do
    begin
      for j := 0 to Image1.Picture.Height do
        begin
          g := Green(Image1.Picture.Bitmap.Canvas.Pixels[i, j]);
          Image1.Picture.Bitmap.Canvas.Pixels[i, j] := RGBToColor(0, g, 0);
        end;
      Application.ProcessMessages;
    end;
end;

procedure TForm1.MenuItem10Click(Sender: TObject); // blue channel
var i, j: integer;
    b: byte;
begin
  for i := 0 to Image1.Picture.Width do
    begin
      for j := 0 to Image1.Picture.Height do
        begin
          b := Blue(Image1.Picture.Bitmap.Canvas.Pixels[i, j]);
          Image1.Picture.Bitmap.Canvas.Pixels[i, j] := RGBToColor(0, 0, b);
        end;
      Application.ProcessMessages;
    end;
end;

procedure TForm1.MenuItem11Click(Sender: TObject); // gray scale
var i, j: integer;
    r, g, b, y: byte;
begin
  for i := 0 to Image1.Picture.Width do
    begin
      for j := 0 to Image1.Picture.Height do
        begin
          r := Red(Image1.Picture.Bitmap.Canvas.Pixels[i, j]);
          g := Green(Image1.Picture.Bitmap.Canvas.Pixels[i, j]);
          b := Blue(Image1.Picture.Bitmap.Canvas.Pixels[i, j]);
          y := round((0.2126*r) + (0.7152*g) + (0.0722*b));
          Image1.Picture.Bitmap.Canvas.Pixels[i, j] := RGBToColor(y, y, y);
        end;
      Application.ProcessMessages;
    end;
end;

procedure TForm1.MenuItem12Click(Sender: TObject); // negative
var i, j: integer;
    r, g, b: byte;
begin
  for i := 0 to Image1.Picture.Width do
    begin
      for j := 0 to Image1.Picture.Height do
        begin
          r := Red(Image1.Picture.Bitmap.Canvas.Pixels[i, j]);
          g := Green(Image1.Picture.Bitmap.Canvas.Pixels[i, j]);
          b := Blue(Image1.Picture.Bitmap.Canvas.Pixels[i, j]);
          Image1.Picture.Bitmap.Canvas.Pixels[i, j] := RGBToColor(255-r, 255-g, 255-b);
        end;
      Application.ProcessMessages;
    end;
end;

procedure TForm1.MenuItem13Click(Sender: TObject); // box blur
var i, j, x, y, sR, sG, sB: integer;
    r, g, b: byte;
    backup: TImage;
begin
  backup := Image1;
  sR := 0;
  sG := 0;
  sB := 0;
  for i := 0 to Image1.Picture.Width do
    begin
      for j := 0 to Image1.Picture.Height do
        begin
          for x := -1 to 1 do
            begin
              for y := -1 to 1 do
                begin
                  sR := sR + Red(backup.Picture.Bitmap.Canvas.Pixels[i + x, j + y]);
                  sG := sG + Green(backup.Picture.Bitmap.Canvas.Pixels[i + x, j + y]);
                  sB := sB + Blue(backup.Picture.Bitmap.Canvas.Pixels[i + x, j + y]);
                end;
            end;
          r := round(sR / 9);
          g := round(sG / 9);
          b := round(sB / 9);
          sR := 0;
          sG := 0;
          sB := 0;
          Image1.Picture.Bitmap.Canvas.Pixels[i, j] := RGBToColor(r, g, b);
        end;
      Application.ProcessMessages;
    end;
end;



end.
