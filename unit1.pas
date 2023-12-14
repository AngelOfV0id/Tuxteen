unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, Menus, StdCtrls,
  ExtCtrls, ComCtrls, Unit2, Math;

type

  { TMainForma }

  TMainForma = class(TForm)
    GameBoard: TStringGrid;
    LevelLabel: TLabel;
    MovesLabel: TLabel;
    NewGameButton: TToggleBox;
    AboutButton: TToggleBox;
    ExitButton: TToggleBox;
    PlayTimer: TTimer;
    LevelTrackBar: TTrackBar;
    PauseButton: TToggleBox;
    procedure AboutButtonChange(Sender: TObject);
    procedure ExitButtonChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GameBoardClick(Sender: TObject);
    procedure NewGameButtonChange(Sender: TObject);
    procedure PauseButtonChange(Sender: TObject);
    procedure PlayTimerTimer(Sender: TObject);
  private

  public

  end;

var
  MainForma: TMainForma;
  moves, gametime: Integer;

implementation

{$R *.lfm}

{ TMainForma }

{ Set status label text }
procedure SetStatus;
begin
  MainForma.MovesLabel.Caption := Format('Moves: %d. Time: %d', [moves, gametime]);
end;

{ Just increase moves counter }
procedure IncMoves;
begin
  moves := moves + 1;
  SetStatus;
end;

{ Ask if user wants to start a new game }
procedure YouWin;
begin
   MainForma.PlayTimer.Enabled := false;
   MessageDlg('You Win', 'Congratulations, you solved the puzzle! :)', mtInformation, [mbOK], 0);
   MainForma.GameBoard.Enabled := false;
   MainForma.PauseButton.Enabled := false;
end;

{ Check if user wins }
procedure CheckWin;
var
   s: String;
   i, j: Integer;
begin
   s := '';
   for i := 0 to 3 do begin
     for j := 0 to 3 do begin
       s := s + MainForma.GameBoard.Cells[j, i];
     end;
   end;
   if (s = '123456789101112131415 ') then YouWin;
end;

{ Move one piece }
procedure MovePiece(x, y: Integer; c: Boolean);
var
   a, b: String;
   ox, oy: Integer;
begin
   ox := x; oy := y;
   a := MainForma.GameBoard.Cells[x, y];

   x := ox; y := oy - 1;
   if not (y < 0) and (MainForma.GameBoard.Cells[x, y] = ' ') then begin
      b := MainForma.GameBoard.Cells[x, y];
      MainForma.GameBoard.Cells[x, y] := a;
      MainForma.GameBoard.Cells[ox, oy] := b;
      IncMoves; if c then CheckWin; Exit;
   end;

   x := ox; y := oy + 1;
   if not (y > 3) and (MainForma.GameBoard.Cells[x, y] = ' ') then begin
      b := MainForma.GameBoard.Cells[x, y];
      MainForma.GameBoard.Cells[x, y] := a;
      MainForma.GameBoard.Cells[ox, oy] := b;
      IncMoves; if c then CheckWin; Exit;
   end;

   x := ox - 1; y := oy;
   if not (x < 0) and (MainForma.GameBoard.Cells[x, y] = ' ') then begin
      b := MainForma.GameBoard.Cells[x, y];
      MainForma.GameBoard.Cells[x, y] := a;
      MainForma.GameBoard.Cells[ox, oy] := b;
      IncMoves; if c then CheckWin; Exit;
   end;

   x := ox + 1; y := oy;
   if not (x > 3) and (MainForma.GameBoard.Cells[x, y] = ' ') then begin
      b := MainForma.GameBoard.Cells[x, y];
      MainForma.GameBoard.Cells[x, y] := a;
      MainForma.GameBoard.Cells[ox, oy] := b;
      IncMoves; if c then CheckWin; Exit;
   end;
end;

{ Start a new game }
procedure StartNewGame;
var
   i: Integer;
begin
     { Reset game board }
     MainForma.GameBoard.Enabled := true;
     MainForma.GameBoard.Cells[0, 0] := '1';
     MainForma.GameBoard.Cells[1, 0] := '2';
     MainForma.GameBoard.Cells[2, 0] := '3';
     MainForma.GameBoard.Cells[3, 0] := '4';
     MainForma.GameBoard.Cells[0, 1] := '5';
     MainForma.GameBoard.Cells[1, 1] := '6';
     MainForma.GameBoard.Cells[2, 1] := '7';
     MainForma.GameBoard.Cells[3, 1] := '8';
     MainForma.GameBoard.Cells[0, 2] := '9';
     MainForma.GameBoard.Cells[1, 2] := '10';
     MainForma.GameBoard.Cells[2, 2] := '11';
     MainForma.GameBoard.Cells[3, 2] := '12';
     MainForma.GameBoard.Cells[0, 3] := '13';
     MainForma.GameBoard.Cells[1, 3] := '14';
     MainForma.GameBoard.Cells[2, 3] := '15';
     MainForma.GameBoard.Cells[3, 3] := ' ';

     { Move some pieces }
     Randomize;
     for i := 1 to Round(Power(8, MainForma.LevelTrackBar.Position) * 16) do MovePiece(Random(4), Random(4), false);

     { Reset some stuff }
     moves := -1; IncMoves;
     gametime := 0;
     MainForma.PlayTimer.Enabled := true;
     MainForma.PauseButton.Enabled := true;
end;

{ Pause game }
procedure PauseGame;
begin
   MainForma.PlayTimer.Enabled := not MainForma.PlayTimer.Enabled;
   MainForma.GameBoard.Enabled := MainForma.PlayTimer.Enabled;
   if not MainForma.PlayTimer.Enabled
   then MainForma.MovesLabel.Caption := 'Game paused'
   else SetStatus;
end;

{ Start a new game when starting up }
procedure TMainForma.FormCreate(Sender: TObject);
begin
     StartNewGame;
end;

{ Move pieces }
procedure TMainForma.GameBoardClick(Sender: TObject);
begin
   MovePiece(GameBoard.Col, GameBoard.Row, true);
end;

{ Exit program }
procedure TMainForma.ExitButtonChange(Sender: TObject);
begin
     Close;
end;

{ Show AboutForma }
procedure TMainForma.AboutButtonChange(Sender: TObject);
begin
   	 AboutForma.Show;
end;

{ "New game" button pressed }
procedure TMainForma.NewGameButtonChange(Sender: TObject);
begin
     if PlayTimer.Enabled then begin
        if MessageDlg('New game', 'Are you sure you want to start a new game?', mtWarning, [mbYes, mbNo], 0) = mrYes
        then StartNewGame;
     end
     else StartNewGame;
end;

{ Pause game }
procedure TMainForma.PauseButtonChange(Sender: TObject);
begin
	 PauseGame;
end;

{ Gameplay timer }
procedure TMainForma.PlayTimerTimer(Sender: TObject);
begin
     gametime := gametime + 1;
     SetStatus;
end;

end.

