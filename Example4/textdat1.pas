unit textdat1;

{$mode objfpc}{$H+}

interface

uses   pdfiumCtrl, pdfiumCore, Classes, SysUtils, Forms, Controls, Graphics, LCLIntf,
  Dialogs, Menus,  StdCtrls, ActnList, ExtCtrls, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    act1Plus: TAction;
    act2Minus: TAction;
    act3Fit: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    mnu31Enlarge: TMenuItem;
    mnu3: TMenuItem;
    mnu23Weblink: TMenuItem;
    mnu22ReadText: TMenuItem;
    mnu21GetTextAt: TMenuItem;
    mnu2: TMenuItem;
    mnu11Open: TMenuItem;
    mnu1: TMenuItem;
    mnu12Close: TMenuItem;
    od1: TOpenDialog;
    Panel1: TPanel;
    procedure act1PlusExecute(Sender: TObject);
    procedure act2MinusExecute(Sender: TObject);
    procedure act3FitExecute(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnu11OpenClick(Sender: TObject);
    procedure mnu12CloseClick(Sender: TObject);
    procedure mnu21GetTextAtClick(Sender: TObject);
    procedure mnu22ReadTextClick(Sender: TObject);
    procedure mnu23WeblinkClick(Sender: TObject);
  private
    procedure WebLinkClick(Sender: TObject; Url: string);
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
  pdf1.OnWebLinkClick := @WebLinkClick;
end;

procedure TForm1.WebLinkClick(Sender: TObject; Url: string);
begin
  if Messagedlg('Open ' + url+'?', mtConfirmation, mbYesNo, 0) = mrYes then
    OpenURL(url);
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

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
//  if pdf1.Document.Active then
    pdf1.HightlightText(edit1.Text, false, false );
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  pdf1.ClearHighlightText;
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

procedure TForm1.mnu12CloseClick(Sender: TObject);
begin
  pdf1.Close;
  mnu2.Enabled:= False;
end;

procedure TForm1.mnu21GetTextAtClick(Sender: TObject);
var ii, cc: integer; Tx: string; rec: TPdfRect;
begin
  cc := pdf1.CurrentPage.GetTextRectCount(0, 65536);
  if cc > 0 then
    tx := 'Found ' +cc.ToString +' text item(s) in this page:-'#13#10
  else
    tx := 'No text item found in this page';
  for ii := 0 to cc-1 do
   begin
    rec := pdf1.CurrentPage.GetTextRect(ii);
    tx += ii.ToString + ': ' +pdf1.CurrentPage.GetTextAt(rec) + #13#10;//rec.Left, rec.Top, rec.Right, rec.Bottom);
  //  tx := //tx + ii.ToString +': '
    //     tx+pdf1.CurrentPage.GetTextAt(pdf1.CurrentPage.GetTextRect(ii)) +#13#10;
   end;
  Showmessage(tx)
end;

procedure TForm1.mnu22ReadTextClick(Sender: TObject);
begin
  Showmessage(pdf1.CurrentPage.ReadText(0, 65536));
end;

procedure TForm1.mnu23WeblinkClick(Sender: TObject);
var ii, cc: integer; tx: string;
begin
  if pdf1.Document.Active then
    with pdf1.CurrentPage do
    begin
      cc := GetWebLinkCount;
      if  cc >0 then
        tx := 'Found ' +cc.ToString +' weblink(s) in this page :-' +#13#10
      else
        tx := 'No weblink found in this page';

      for ii := 0 to cc-1 do
        tx := tx+ ii.ToString +': ' +GetWebLinkURL(ii) +#13#10;
      Showmessage(tx);
    end;
end;

end.

