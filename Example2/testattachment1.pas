unit testAttachment1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics,  lclintf,
  PdfiumCtrl, PdfiumCore, Dialogs, ExtCtrls, StdCtrls, Buttons, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    lbox1: TListBox;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    mnu5Save: TMenuItem;
    mnu4Detach: TMenuItem;
    mnu1: TMenuItem;
    mnu3Attach: TMenuItem;
    mnu2: TMenuItem;
    mnu1OpenPdf: TMenuItem;
    od1: TOpenDialog;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbox1Click(Sender: TObject);
    procedure mnu1OpenPdfClick(Sender: TObject);
    procedure mnu2Pg2ImgClick(Sender: TObject);
    procedure mnu3AttachClick(Sender: TObject);
    procedure mnu4DetachClick(Sender: TObject);
    procedure mnu5SaveClick(Sender: TObject);
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
end;

procedure TForm1.lbox1Click(Sender: TObject);
var att: TPdfAttachment;  tx: string;
begin
  if lbox1.ItemIndex < 0 then Exit;
  Att := pdf1.Document.Attachments[lbox1.ItemIndex];
  if att.Name.IndexOf('utf8') >-1 then  // filename NOT containing utf8, default to be utf8 encoding
    att.GetContent(tx)
  else
    att.GetContent(tx, TEncoding.Unicode);
  Memo1.Lines.Text:= tx;
end;

procedure TForm1.ListAttachments;
var ii: integer; att: TPdfAttachment;
begin
  lbox1.Clear;  memo1.Clear;
  lbox1.Visible := pdf1.Document.Attachments.Count > 0;
  GroupBox1.Visible := lbox1.Visible;
  //    lbox1.Items.BeginUpdate;
  try
  //      lbox1.Column[0].Width :=500;
    for ii := 0 to pdf1.Document.Attachments.Count - 1 do
      begin
        Att := pdf1.Document.Attachments[ii];
        lbox1.Items.Add( Format('%s (%d Bytes)', [Att.Name, Att.ContentSize]));
      end;
    lbox1.ItemIndex := -1;
  finally
  //      lbox1.Items.EndUpdate;
  end;
end;

procedure TForm1.mnu1OpenPdfClick(Sender: TObject);
begin
  od1.Filter:= 'Pdf file (*.pdf)|*.pdf';
  if od1.Execute then
    begin
      pdf1.LoadFromFile(od1.FileName);
      ListAttachments;
    end;
end;

procedure TForm1.mnu2Pg2ImgClick(Sender: TObject);
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

procedure TForm1.mnu3AttachClick(Sender: TObject);
var att: TPdfAttachment;
begin
  if not pdf1.Document.Active then exit;
  od1.Filter:= 'Text files (*.txt)|*.Txt|All files (*.*)|*.*';
  if od1.Execute then
    begin
      att := pdf1.Document.Attachments.Add(ExtractFileName(od1.Filename));
      att.LoadFromFile(od1.Filename);
      ListAttachments;
    end;
end;

procedure TForm1.mnu4DetachClick(Sender: TObject);
var att: TPdfAttachment; ii: integer;
begin
  ii := lbox1.ItemIndex;
  att := pdf1.Document.Attachments[ii];
  att.SetContent('', nil);
  pdf1.Document.Attachments.Delete(ii);
  ListAttachments;
end;

procedure TForm1.mnu5SaveClick(Sender: TObject);
begin
  pdf1.Document.SaveToFile('tmp.pdf');
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  pdf1.Free;
end;


end.

