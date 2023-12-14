program tuxteen;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, Unit2
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Tuxteen';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForma, MainForma);
  Application.CreateForm(TAboutForma, AboutForma);
  Application.Run;
end.

