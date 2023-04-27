unit testAttachment1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics,  lclintf,
  PdfiumCtrl, PdfiumCore, Dialogs, ExtCtrls, StdCtrls, Buttons, Menus, ActnList;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    lbox1: TListBox;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    mnu31Enlarge: TMenuItem;
    mn33Fit: TMenuItem;
    mnu32Shrink: TMenuItem;
    mnu34Prev: TMenuItem;
    mnu35Next: TMenuItem;
    mnu3: TMenuItem;
    mnu2: TMenuItem;
    mnu19Quit: TMenuItem;
    mnu13Close: TMenuItem;
    mnu21Attach: TMenuItem;
    mnu22Del: TMenuItem;
    mnu23: TMenuItem;
    mnu12Save: TMenuItem;
    mnu11Open: TMenuItem;
    mnu1OpenPdf: TMenuItem;
    od1: TOpenDialog;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lbox1SelectionChange(Sender: TObject; User: boolean);
    procedure Memo1Enter(Sender: TObject);
    procedure Memo1Exit(Sender: TObject);
    procedure mn33FitClick(Sender: TObject);
    procedure mnu11OpenClick(Sender: TObject);
    procedure mnu23PgImgClick(Sender: TObject);
    procedure mnu21AttachClick(Sender: TObject);
    procedure mnu22DelClick(Sender: TObject);
    procedure mnu12SaveClick(Sender: TObject);
    procedure mnu13CloseClick(Sender: TObject);
    procedure mnu19QuitClick(Sender: TObject);
    procedure mnu31EnlargeClick(Sender: TObject);
    procedure mnu34PrevClick(Sender: TObject);
    procedure mnu35NextClick(Sender: TObject);
    procedure mnu32ShrinkClick(Sender: TObject);
  private
  public
    procedure ListAttachments;

  end;

function img2pdf(fn: string): Boolean; stdcall; external 'pdfx.dll';

var Form1: TForm1;
    pdf1: TPdfControl;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
begin
  pdf1 := TPdfControl.Create(Self);
  pdf1.Align := alClient;
  pdf1.Parent := Self;
  pdf1.Show;
  pdf1.Hint := 'You have modified the attachment.'#13 +
               'The modification will become permanent'#13+
               ' if you save this pdf file. ';
end;


procedure TForm1.lbox1SelectionChange(Sender: TObject; User: boolean);
var att: TPdfAttachment;  tx: string;
begin
  if lbox1.ItemIndex < 0 then Exit;
  Att := pdf1.Document.Attachments[lbox1.ItemIndex];
  if (att.Name.IndexOf('utf16') >-1) or  (att.Name.IndexOf('unicode') >-1)then  // filename NOT containing utf8, default to be utf8 encoding
    att.GetContent(tx, TEncoding.Unicode)
  else
    att.GetContent(tx);
  Memo1.Lines.Text:= tx;
end;

procedure TForm1.Memo1Enter(Sender: TObject);
begin
  memo1.modified := false;
end;


procedure TForm1.Memo1Exit(Sender: TObject);
var ii: integer; att: TPdfAttachment; tx: string;
begin
  ii := lbox1.ItemIndex;
  if (ii > -1) and memo1.Modified then
    begin
      Att := pdf1.Document.Attachments[ii];
      tx := memo1.text;
      if (att.Name.IndexOf('utf16') >-1) or  (att.Name.IndexOf('unicode') >-1) then  // filename contains 'utf16' or 'unicode', default to utf16 encoding
        att.SetContent(tx, TEncoding.Unicode)
      else //default utf8
        att.SetContent(tx);
      pdf1.ShowHint:= True;
    end;
end;

procedure TForm1.mn33FitClick(Sender: TObject);
begin
  pdf1.ScaleMode := smFitAuto;
end;


procedure TForm1.ListAttachments;
var ii, count: integer; att: TPdfAttachment;
begin
  lbox1.Clear;  memo1.Clear;  pdf1.ShowHint := False;
  count := pdf1.Document.Attachments.Count;
  try
    for ii := 0 to count - 1 do
      begin
        Att := pdf1.Document.Attachments[ii];
        lbox1.Items.Add( Format('%s (%d Bytes)', [Att.Name, Att.ContentSize]));
      end;
    if count > 0 then
      begin
        GroupBox1.Caption := 'Number of attachment found:'+ count.ToString;
        lbox1.ItemIndex := 0;
      end
    else
      begin
        GroupBox1.Caption := 'Attachment';
        lbox1.ItemIndex := -1;
      end;
  finally
  //      lbox1.Items.EndUpdate;
  end;
end;

procedure TForm1.mnu11OpenClick(Sender: TObject);
begin
  od1.Filter:= 'Pdf file (*.pdf)|*.pdf';
  if od1.Execute then
    begin
      try
        pdf1.LoadFromFile(od1.FileName);
        ListAttachments;
        mnu2.Enabled := pdf1.Document.Active;
      except
        mnu13CloseClick(nil);
      end;
    end;
end;

procedure TForm1.mnu23PgImgClick(Sender: TObject);
var png: TPortableNetworkGraphic; fn: string;
begin
  png := TPortableNetworkGraphic.Create;
  try
    pdf1.Document.PgToPNG(pdf1.PageIndex, png);
    fn := ChangeFileExt(pdf1.Document.Filename,
                        '_'+pdf1.PageIndex.ToString+'.png');
    png.SaveToFile(fn);
    OpenDocument(fn);
  finally
    png.Free;
  end;
end;

procedure TForm1.mnu21AttachClick(Sender: TObject);
var att: TPdfAttachment;  fn: string;
begin
  od1.Filter:= 'Text files (*.txt)|*.Txt|All files (*.*)|*.*';
  if od1.Execute then
    begin
      fn := ExtractFilename(od1.Filename);
      att := pdf1.Document.Attachments.Add(fn);
      att.LoadFromFile(od1.Filename);
      ListAttachments;
      pdf1.ShowHint:= True;
    end;
end;

procedure TForm1.mnu22DelClick(Sender: TObject);
var att: TPdfAttachment; ii: integer;
begin
  ii := lbox1.ItemIndex;
  att := pdf1.Document.Attachments[ii];
  att.SetContent('', nil);
  pdf1.Document.Attachments.Delete(ii);
  ListAttachments;
  pdf1.ShowHint:= True;
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

procedure TForm1.mnu13CloseClick(Sender: TObject);
begin
//  Memo1.Clear; lbox1.Clear; GroupBox1.Caption := 'Attachment';
  if not pdf1.Document.Active then Exit;
  ListAttachments;
  pdf1.Close;
  mnu2.Enabled := False;
end;

procedure TForm1.mnu19QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.mnu31EnlargeClick(Sender: TObject);
begin
  pdf1.ScaleMode := smZoom;
  if pdf1.ZoomPercentage < 200 then
    pdf1.ZoomPercentage := pdf1.ZoomPercentage +3;
end;

procedure TForm1.mnu34PrevClick(Sender: TObject);
begin
  pdf1.GotoPrevPage;
end;

procedure TForm1.mnu35NextClick(Sender: TObject);
begin
   pdf1.GotoNextPage;
end;

procedure TForm1.mnu32ShrinkClick(Sender: TObject);
begin
  pdf1.ScaleMode := smZoom;
  if pdf1.ZoomPercentage > 50 then
    pdf1.ZoomPercentage := pdf1.ZoomPercentage -3;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  pdf1.Free;
end;

end.

