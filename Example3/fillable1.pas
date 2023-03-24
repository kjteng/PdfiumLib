unit Fillable1;

{$mode objfpc}{$H+}

interface

uses   pdfiumCtrl, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus,
   ActnList, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    mnu32Shrink: TMenuItem;
    mnu33Fit: TMenuItem;
    mnu34Prev: TMenuItem;
    mnu35Next: TMenuItem;
    mnu14Quit: TMenuItem;
    mnu13Close: TMenuItem;
    mnu31Enlarge: TMenuItem;
    mnu3: TMenuItem;
    mnu25Redo: TMenuItem;
    mnu24Undo: TMenuItem;
    mnu23ReplaceText: TMenuItem;
    mnu22SelectedText: TMenuItem;
    mnu21FocusedText: TMenuItem;
    mnu2: TMenuItem;
    mnu11Open: TMenuItem;
    mnu1: TMenuItem;
    mnu12Save: TMenuItem;
    od1: TOpenDialog;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    tx1: TStaticText;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure mnu31EnlargeClick(Sender: TObject);
    procedure mnu32ShrinkClick(Sender: TObject);
    procedure mnu33FitClick(Sender: TObject);
    procedure mnu34PrevClick(Sender: TObject);
    procedure mnu13CloseClick(Sender: TObject);
    procedure mnu11OpenClick(Sender: TObject);
    procedure mnu12SaveClick(Sender: TObject);
    procedure mnu14QuitClick(Sender: TObject);
    procedure mnu21FocusedTextClick(Sender: TObject);
    procedure mnu22SelectedTextClick(Sender: TObject);
    procedure mnu23ReplaceTextClick(Sender: TObject);
    procedure mnu24UndoClick(Sender: TObject);
    procedure mnu25RedoClick(Sender: TObject);
    procedure mnu35NextClick(Sender: TObject);
    procedure tx1MouseLeave(Sender: TObject);
  private

  public
    pdf1: TPdfControl;

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  pdf1 := TPdfControl.Create(Self);
  pdf1.Align := alClient;
  pdf1.Parent := Self;
  pdf1.ScaleMode := smZoom;
//  MaskFPUExceptions(true,true);
//  pdf1.Show;

end;

procedure TForm1.mnu31EnlargeClick(Sender: TObject);
begin
  pdf1.ScaleMode := smZoom;
  if pdf1.ZoomPercentage < 200 then
    pdf1.ZoomPercentage := pdf1.ZoomPercentage +3;
end;

procedure TForm1.mnu32ShrinkClick(Sender: TObject);
begin
  pdf1.ScaleMode := smZoom;
  if pdf1.ZoomPercentage > 50 then
    pdf1.ZoomPercentage := pdf1.ZoomPercentage -3;
end;

procedure TForm1.mnu33FitClick(Sender: TObject);
begin
  pdf1.ScaleMode := smFitAuto;
end;

procedure TForm1.mnu34PrevClick(Sender: TObject);
begin
  pdf1.GotoPrevPage;
end;

procedure TForm1.mnu13CloseClick(Sender: TObject);
begin
  pdf1.Close;
  mnu2.Enabled := False;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  pdf1.Free
end;

procedure TForm1.mnu11OpenClick(Sender: TObject);
begin
  od1.Filter:= 'Pdf file (*.pdf)|*.pdf';
  if od1.Execute then
    try
      pdf1.LoadFromFile(od1.FileName);
    finally
      mnu2.Enabled := pdf1.Document.Active;
    end;
end;

procedure TForm1.mnu12SaveClick(Sender: TObject);
var fn: String;
begin
  if not pdf1.Document.Active then Exit;
  fn := ChangeFileExt(pdf1.Document.FileName, '~.pdf');
  pdf1.Document.SaveToFile(fn);
  pdf1.ShowHint := False;
  Showmessage('File saves as ' + #13#10 +fn);
end;

procedure TForm1.mnu14QuitClick(Sender: TObject);
begin
  Close
end;

procedure TForm1.mnu21FocusedTextClick(Sender: TObject);
begin
  tx1.caption := 'FormGetFocusedText: '
                  +QuotedStr(pdf1.CurrentPage.FormGetFocusedText);
  tx1.BringToFront;
end;

procedure TForm1.mnu22SelectedTextClick(Sender: TObject);
begin
  tx1.caption := 'FormGetSelectedText: '
                    +QuotedStr(pdf1.CurrentPage.FormGetSelectedText);
end;

procedure TForm1.mnu23ReplaceTextClick(Sender: TObject);
begin
  pdf1.CurrentPage.FormSelectAllText;
  pdf1.CurrentPage.FormReplaceSelection('New Text');
end;

procedure TForm1.mnu24UndoClick(Sender: TObject);
begin
  if pdf1.CurrentPage.FormCanUndo then
    pdf1.CurrentPage.FormUndo
  else
    Showmessage('Undo is not applicable now');
end;

procedure TForm1.mnu25RedoClick(Sender: TObject);
begin
  if pdf1.CurrentPage.FormRedo then
    pdf1.CurrentPage.FormRedo
  else
    Showmessage('Redo is not applicable now');
end;

procedure TForm1.mnu35NextClick(Sender: TObject);
begin
  pdf1.GotoNextPage;
end;

procedure TForm1.tx1MouseLeave(Sender: TObject);
begin
  tx1.Caption :=''
end;

end.

