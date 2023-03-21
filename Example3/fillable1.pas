unit Fillable1;

{$mode objfpc}{$H+}

interface

uses   pdfiumCtrl, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ActnList;

type

  { TForm1 }

  TForm1 = class(TForm)
    act1Plus: TAction;
    act2Minus: TAction;
    act3Fit: TAction;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
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
    procedure act1PlusExecute(Sender: TObject);
    procedure act2MinusExecute(Sender: TObject);
    procedure act3FitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnu13CloseClick(Sender: TObject);
    procedure mnu11OpenClick(Sender: TObject);
    procedure mnu12SaveClick(Sender: TObject);
    procedure mnu21FocusedTextClick(Sender: TObject);
    procedure mnu22SelectedTextClick(Sender: TObject);
    procedure mnu23ReplaceTextClick(Sender: TObject);
    procedure mnu24UndoClick(Sender: TObject);
    procedure mnu25RedoClick(Sender: TObject);
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

procedure TForm1.mnu13CloseClick(Sender: TObject);
begin
  pdf1.Close;
  mnu2.Enabled := False;
end;

procedure TForm1.act1PlusExecute(Sender: TObject);
begin
  pdf1.ScaleMode := smZoom;
  if pdf1.ZoomPercentage < 200 then
    pdf1.ZoomPercentage := pdf1.ZoomPercentage +3;
end;

procedure TForm1.act2MinusExecute(Sender: TObject);
begin
  pdf1.ScaleMode := smZoom;
  if pdf1.ZoomPercentage > 50 then
    pdf1.ZoomPercentage := pdf1.ZoomPercentage -3;
end;

procedure TForm1.act3FitExecute(Sender: TObject);
begin
  pdf1.ScaleMode := smFitAuto;
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
begin
  pdf1.Document.SaveToFile('tmp.pdf');
end;

procedure TForm1.mnu21FocusedTextClick(Sender: TObject);
begin
  Showmessage('FormGetFocusedText :-'+#13#10
                   +pdf1.CurrentPage.FormGetFocusedText);
end;

procedure TForm1.mnu22SelectedTextClick(Sender: TObject);
begin
  Showmessage('FormGetSelectedText :-'+#13#10
              +pdf1.CurrentPage.FormGetSelectedText);
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

end.

