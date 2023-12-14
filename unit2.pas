unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  LCLIntf;

type

  { TAboutForma }

  TAboutForma = class(TForm)
    InfoMemo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private

  public

  end;

var
  AboutForma: TAboutForma;

const
  PROGRAM_VERSION = 1.2;

implementation

{$R *.lfm}

{ TAboutForma }

procedure TAboutForma.FormCreate(Sender: TObject);
var
  S: String;
begin
     S := InfoMemo.Text;
     S := S.Replace('$VERSION', FloatToStr(PROGRAM_VERSION));
     S := S.Replace('$BUILD_INFO', {$I %DATE%} + ' ' + {$I %TIME%});
     InfoMemo.Text := S;
end;

procedure TAboutForma.FormResize(Sender: TObject);
begin
  InfoMemo.Width := AboutForma.ClientWidth;
  InfoMemo.Height := AboutForma.ClientHeight;
end;

end.

