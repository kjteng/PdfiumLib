# PdfiumLib
Example of a PDF VCL Control using PDFium

## Requirements
pdfium.dll (x86/x64) from the [pdfium-binaries](https://github.com/bblanchon/pdfium-binaries)

Binary release: [chromium/5052](https://github.com/bblanchon/pdfium-binaries/releases/tag/chromium%2F5052)

## Required pdfium.dll version
chromium/5052

## Features
This is a FreePascal port for PdfiumLib (Updated to chromium/5052) from                                https://github.com/ahausladen/PdfiumLib
I have compiled it with Lazarus(ver2.2.2)/Freepascal(version 3.2.2). 

The library/components works on some of my personal project (mainly to render pdf file). However, I am yet to test the methods relating to (i) pdf attachment; and (ii) pdf form.

All the amendments/changes for the freepascal port are kept within {$ifdef FPC} ...{$endif} block. 
Another directive {$ifndef FPC} ...{$endif} is used to exclude parts of orignal codes that are not applicable for free pascal. This way the original source shall be intact if the we comment out the line containing {$DEFINE FPC}.

A new method Pg2BMP(idx: integer; bmp: TBitMap) has been added. the purpose of this method is to convert a specific page of the pdf to bitmap.

Please ensure that Printer4Lazarus package is added to you project as it is REQUIRED for the components. Also, the component will not work with pdfium.dll dated on or before 2/3/2017 due to changes in the names of certain export functions. 

A pdflib.dpk file (and also Tpdfcontrol.lrs) is also included for those who wish to place the TPdfControl to the component palette in Lazarus. Before installing the dpk, please remember to uncomment the line containing {$DEFINE VCL_PALETTE} in pdfiumctrl.pas. You may also need to delete the files in project\lib\ folder to ensure a clean start.

The example file (PdfiumLibExample) is also originated from Andreas Hausladen's site, with some minor modification for Lazarus.

All the codes are distributed/released under MPL-2.0 license.	
