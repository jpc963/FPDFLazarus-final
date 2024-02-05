# FPDF Pascal
This is a translation of the renowned FPDF Project from PHP to Pascal / Delphi

# What is FPDF?
http://www.fpdf.org/

FPDF is a class which allows to generate PDF files with pure Code, that is to say without using any PDF library. "F" from FPDF stands for Free: you may use it for any kind of usage and modify it to suit your needs.

FPDF has other benefits: high level functions. Here is a list of its main features:
- Choice of measure unit, page format and margins
- Page header and footer management
- Automatic page break
- Automatic line break and text justification
- Image support (JPEG, PNG and ~~GIF~~)
- Colors
- Links
- HTML tags support in WriteHTML method
   - `<b>bold</b>`
   - `<i>italic</i>`
   - `<u>underlined</u>`
   - `<a href="http://link.com">text</a>`
   - `<br>`
- ~~TrueType, Type1 and encoding support~~
- Page compression

    (Note: ~~Strike~~ = not implemented in Pascal translation)

# What Can I do with FPDF Pascal ?
Please check the file: [FPDFPascalTest.pdf](https://github.com/Projeto-ACBr-Oficial/FPDF-Pascal/tree/main/demo/files/FPDFPascalTest.pdf)

These PDF is generated when you run the Project "demofpdfpascal"

# How to use
Use the force... read the sources...

Please open the projects on "demo" folder, like: "tuto1", "tuto2", "tuto3", "tuto4", etc... Notice whe provide the same demos for Delphi and Lazarus/FPC

You can also refer to original FPDF Reference Manual:
http://www.fpdf.org/en/doc/index.php

# Install using Boss
https://github.com/HashLoad/boss

Command line:

`boss install https://github.com/Projeto-ACBr-Oficial/FPDF-Pascal.git`

# Dependencies
In order to maintain compatibility with a large number of Pascal IDEs, Units have few or none dependencies.

# Compatibility
These fonts are intended to be compatible with a large number of IDEs, Frameworks and Platforms. We believe it is compatible with:
- Delphi
   - IDEs: D7-D11
   - Platforms: Windows, Linux, Android
   - Frameworks: VCL, FMX
- Lazarus/FPC
   - Version: 2.2.4 - FPC 3.3.2
   - Platforms: Windows, Linux

# Console Mode
We do not use "Graphics" Units. So you can use FPF-Pascal in CONSOLE Projects. No Graphical Server is needed.

# Reporting Bugs
Please report if you notice any compilation problem or other issues.

https://github.com/Projeto-ACBr-Oficial/FPDF-Pascal/issues

# License
We use MIT License. The same license from FPDF orginal sources.

https://github.com/Projeto-ACBr-Oficial/FPDF-Pascal/blob/main/LICENSE.TXT

# About the translation of sources.

We try to stay faithful as much as possible in translating sources from PHP to Pascal.

This may have caused an unusual programming style for the Pascal language. But we believe it will be strategic when we need to perform a new Merge, with the original sources, in PHP

The Unit **fpdf.pas**, is designed to have the same functionality as the oringal file, **fpdh.php**. This means that no additional Scripts or functionalities are included on this Unit.

The Unit **fpf_ext.pas**, has an extendeded version of **TFPDF** class. And incorporates several new functionalities and Scripts.

So, always prefer to use the **TFPDFExt** class of Unit **fpf_ext.pas**

# Dependencies of Third Party Units
Note that at the beginning of Unit **fpf_ext.pas**, you can turn on/off, the support for various external Units, using DEFINE directives

- **DEFINE USE_SYNAPSE:** Extend the "Image" method, allowing inform a Image by URL, and also allow to use "SetProtection" (password) features

- **DEFINE DelphiZXingQRCode:** Allows the generation of **QRCodes**

 
# Scripts embedded in **TFPDFExt**
| **Method** | **Script URL** | **Author** |
| --- | --- | --- |
| TFPDFScriptCodeEAN | http://www.fpdf.org/en/script/script5.php | Olivier |
|TFPDFScriptCode39 | http://www.fpdf.org/en/script/script46.php | The-eh |
| TFPDFScriptCodeI25 | http://www.fpdf.org/en/script/script67.php | Matthias Lau |
| TFPDFScriptCode128 | http://www.fpdf.org/en/script/script88.php | Roland Gautier |
| TFPDFExt.Rotate | http://www.fpdf.org/en/script/script2.php | Olivier |
| TFPDFExt.RoundedRect | http://www.fpdf.org/en/script/script35.php | Christophe Prugnaud |
| TFPDFExt.AddLayer | http://www.fpdf.org/en/script/script97.php | Oliver |
| TFPDFExt.SetProtection | http://www.fpdf.org/en/script/script37.php | Klemen Vodopivec |

# About the translator
Daniel Simões de Almeida is a Pascal multiplataform developer.
https://www.projetoacbr.com.br/

