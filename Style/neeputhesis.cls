%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Huangrui Mo <huangrui.mo@gmail.com> 
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2017/01/01}{}{%
    \ClassError{neeputhesis}{TeXLive/MikTex >= 2017 is required ...}{}%
}
\ProvidesClass{neeputhesis}[2014/10/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexbook}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexbook}%
}
\newif\ifneepu@print \neepu@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexbook}%
    \neepu@printtrue%
}
%-
%-> Language
%-
\newif\ifneepu@plain \neepu@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexbook}%
    \neepu@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifneepu@versioninfo \neepu@versioninfofalse
\DeclareOption{draftversion}{%
    \neepu@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}%
\@ifclasslater{ctexbook}{2017/01/01}{}{%
    \ClassError{neeputhesis}{ctex >= 2017/01/01 is required ...}{}%
}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\newcommand{\neepuifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\neepuifstrbk}{\expandafter\ifblank\expandafter}% expansion control
\RequirePackage{expl3}% LaTeX3 programming environment
\ExplSyntaxOn
\newcommand{\neepulntotab}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/neeputhesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- c
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{165mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifneepu@print% if print layout enabled
    \setlength{\oddsidemargin}{0mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{0mm}% left side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{226.2mm}% set required text height first
\setlength{\voffset}{0mm}% set vertical offset
\setlength{\topmargin}{0.5mm}% vertical margin above header
\setlength{\headheight}{17.5pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.6}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    \RequirePackage{ulem}%
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.5em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-4em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
\def\neepu@value@ch@confidential{}
\newcommand{\confidential}[1]{\def\neepu@value@ch@confidential{#1}}
\def\neepu@value@ch@orderid{}
\newcommand{\orderid}[1]{\def\neepu@value@ch@orderid{#1}}
\def\neepu@value@ch@classid{}
\newcommand{\classid}[1]{\def\neepu@value@ch@classid{#1}}
\def\neepu@value@ch@udc{}
\newcommand{\udc}[1]{\def\neepu@value@ch@udc{#1}}
\def\neepu@value@ch@schoollogo{}
\newcommand{\schoollogo}[2][]{\def\neepu@value@ch@schoollogo{\neepuifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\neepu@value@ch@title{}
\def\neepu@value@ch@titlemark{}
\renewcommand{\title}[2][\neepu@value@ch@title]{%
    \def\neepu@value@ch@title{#2}
    %\def\neepu@value@ch@titlemark{\MakeUppercase{#1}}}
    \def\neepu@value@ch@titlemark{#1}}
\def\neepu@value@ch@author{}
\renewcommand{\author}[1]{\def\neepu@value@ch@author{#1}}
\def\neepu@value@ch@advisor{}
\newcommand{\advisor}[1]{\long\def\neepu@value@ch@advisor{#1}}
\def\neepu@value@ch@advisors{}
\newcommand{\advisors}[1]{\long\def\neepu@value@ch@advisors{#1}}
\def\neepu@value@ch@degree{}
\newcommand{\degree}[1]{\def\neepu@value@ch@degree{#1}}
\def\neepu@value@ch@degreetype{}
\newcommand{\degreetype}[1]{\def\neepu@value@ch@degreetype{#1}}
\def\neepu@value@ch@subject{}
\newcommand{\subject}[1]{\def\neepu@value@ch@subject{#1}}
\def\neepu@value@ch@major{}
\newcommand{\major}[1]{\def\neepu@value@ch@major{#1}}
\def\neepu@value@ch@institute{}
\newcommand{\institute}[1]{\long\def\neepu@value@ch@institute{#1}}
\def\neepu@value@ch@school{}
\newcommand{\school}[1]{\def\neepu@value@ch@school{#1}}
\def\neepu@value@ch@orginization{}
\newcommand{\orginization}[1]{\def\neepu@value@ch@orginization{#1}}
\def\neepu@value@ch@completedate{}
\newcommand{\completedate}[1]{\def\neepu@value@ch@completedate{#1}}
\def\neepu@value@ch@submitdate{}
\newcommand{\submitdate}[1]{\def\neepu@value@ch@submitdate{#1}}
\def\neepu@value@ch@studydatefrom{}
\newcommand{\studydatefrom}[1]{\def\neepu@value@ch@studydatefrom{#1}}
\def\neepu@value@ch@studydateto{}
\newcommand{\studydateto}[1]{\def\neepu@value@ch@studydateto{#1}}
\def\neepu@value@ch@date{}
\renewcommand{\date}[1]{\def\neepu@value@ch@date{#1}}
%-
%-> English item commands
%-
\def\neepu@value@en@title{}
\def\neepu@value@en@titlemark{}
\newcommand{\TITLE}[2][\neepu@value@en@title]{%
    \def\neepu@value@en@title{#2}
    %\def\neepu@value@en@titlemark{\MakeUppercase{#1}}}
    \def\neepu@value@en@titlemark{#1}}
\def\neepu@value@en@author{}
\newcommand{\AUTHOR}[1]{\def\neepu@value@en@author{#1}}
\def\neepu@value@en@advisor{}
\newcommand{\ADVISOR}[1]{\def\neepu@value@en@advisor{#1}}
\def\neepu@value@en@degree{}
\newcommand{\DEGREE}[1]{\edef\neepu@value@en@degree{\zap@space#1 \@empty}}% expand and remove space
\def\neepu@value@en@degreetype{}
\newcommand{\DEGREETYPE}[1]{\def\neepu@value@en@degreetype{#1}}
\def\neepu@value@en@thesistype{}
\newcommand{\THESISTYPE}[1]{\def\neepu@value@en@thesistype{#1}}
\def\neepu@value@en@major{}
\newcommand{\MAJOR}[1]{\def\neepu@value@en@major{#1}}
\def\neepu@value@en@institute{}
\newcommand{\INSTITUTE}[1]{\def\neepu@value@en@institute{#1}}
\def\neepu@value@en@school{}
\newcommand{\SCHOOL}[1]{\def\neepu@value@en@school{#1}}
\def\neepu@value@en@date{}
\newcommand{\DATE}[1]{\def\neepu@value@en@date{#1}}
\def\neepu@value@en@classid{}
\newcommand{\CLASSID}[1]{\def\neepu@value@en@classid{#1}}
\def\neepu@value@en@udc{}
\newcommand{\UDC}[1]{\def\neepu@value@en@udc{#1}}


%-
%-> Detect and adjust items
%-
\AtEndPreamble{%
    \neepuifstreq{\neepu@value@en@degree}{Bachelor}{%
        \def\neepu@label@ch@thesis{\neepu@label@ch@thesis@bac}%
        \def\neepu@label@ch@author{\neepu@label@ch@author@bac}%
        \def\neepu@label@ch@major{\neepu@label@ch@major@bac}%
        \def\neepu@label@ch@institute{\neepu@label@ch@institute@bac}%
        \def\neepu@value@en@thesistype{\neepu@value@en@thesistype@bac}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \neepuifstreq{\neepu@value@en@degree}{Master}{%
        \def\neepu@label@ch@thesis{\neepu@label@ch@thesis@mas}%
        \def\neepu@label@ch@author{\neepu@label@ch@author@mas}%
        \def\neepu@label@ch@major{\neepu@label@ch@major@mas}%
        \def\neepu@label@ch@institute{\neepu@label@ch@institute@mas}%
        \def\neepu@value@en@thesistype{\neepu@value@en@thesistype@mas}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \neepuifstreq{\neepu@value@en@degree}{Doctor}{%
        \def\neepu@label@ch@thesis{\neepu@label@ch@thesis@doc}%
        \def\neepu@label@ch@author{\neepu@label@ch@author@doc}%
        \def\neepu@label@ch@major{\neepu@label@ch@major@doc}%
        \def\neepu@label@ch@institute{\neepu@label@ch@institute@doc}%
        \def\neepu@value@en@thesistype{\neepu@value@en@thesistype@doc}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \neepuifstreq{\neepu@value@en@degree}{Postdoctor}{%
        \def\neepu@label@ch@thesis{\neepu@label@ch@thesis@pdc}%
        \def\neepu@label@ch@author{\neepu@label@ch@author@pdc}%
        \def\neepu@label@ch@major{\neepu@label@ch@major@pdc}%
        \def\neepu@label@ch@institute{\neepu@label@ch@institute@pdc}%
        \def\neepu@value@en@thesistype{\neepu@value@en@thesistype@pdc}%
        \def\maketitle{\maketitle@pdc}
        \def\MAKETITLE{\MAKETITLE@pdc}
    }{%
        \ClassWarning{neeputhesis}{Invalid value of '\string\DEGREE', please check the spelling}%
    }}}}%
}
%-
%-> 封面页
%-


%-
%-> 中文标题页
%-
\newcommand{\maketitle@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}

    
    % 分类号
    \begin{table}
        \zihao{-4}
        \flushleft
        \def\arraystretch{0.75}
        \begin{tabular}{p{10.5cm}l}
            \neepu@label@ch@classid \neepu@value@ch@classid & \neepu@label@ch@orderid \neepu@value@ch@orderid \\
            \neepu@label@ch@udc \neepu@value@ch@udc & \neepu@label@ch@confidential \neepu@value@ch@confidential \\
        \end{tabular}
    \end{table}

    \begin{center}
        \linespread{1.6}
        \zihao{4}
    
        % \vspace*{\stretch{4}}

        % 学校 logo
        % {\neepu@value@ch@schoollogo}

        \vspace*{\stretch{8}}

        % 论文标题
        {\zihao{2}\bfseries\sffamily {\neepu@value@ch@title}}

        \vspace*{\stretch{15}}

        % {\zihao{-3}\bfseries\sffamily \ulenhance[1.5pt]{\neepu@value@ch@title}}

        % \vspace*{\stretch{3}}

        % 作者信息
        \def\tabcolsep{1pt}
        \def\arraystretch{1.2}
        \begin{tabular}{rl}
            \bfseries \makebox[4.5cm][s]{\neepu@label@ch@author} & \neepu@value@ch@author \\
            \bfseries \makebox[4.5cm][s]{\neepu@label@ch@advisor} & \neepu@value@ch@advisor \\
            \bfseries \makebox[4.5cm][s]{\neepu@label@ch@degree} & \neepu@value@ch@degreetype\neepu@value@ch@degree \\
            \bfseries \makebox[4.5cm][s]{\neepu@label@ch@major} & \neepu@value@ch@major \\
            \bfseries \makebox[4.5cm][s]{\neepu@label@ch@institute} & \neepu@value@ch@institute \\
            \bfseries \makebox[4.5cm][s]{\neepu@label@ch@date} & \neepu@value@ch@date \\
            \bfseries \makebox[4.5cm][s]{\neepu@label@ch@school} & \neepu@value@ch@school \\
        \end{tabular}

        \vspace*{\stretch{4}}

        % 页脚日期
        % {\neepu@value@ch@date}

        % \vspace*{\stretch{4}}
    \end{center}

    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifneepu@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifneepu@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifneepu@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
\newcommand{\maketitle@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}

        \vspace*{30pt}

        \linespread{2.0}
        \zihao{4}

        \makebox[3.0em][s]{\neepu@label@ch@classid} \ulenhance{\ulextend[6em]{\zihao{5}\neepu@value@ch@classid}} \hfill{} \neepu@label@ch@confidential \ulenhance{\ulextend[6em]{\zihao{5}\neepu@value@ch@confidential}}

        \makebox[3.0em][s]{\neepu@label@ch@udc} \ulenhance{\ulextend[6em]{\zihao{5}\neepu@value@ch@udc}} \hfill{} \neepu@label@ch@orderid \ulenhance{\ulextend[6em]{\zihao{5}\neepu@value@ch@orderid}}

        \vspace*{\stretch{6}}

        {\ziju{1.5}\neepu@value@ch@schoollogo}

        \vspace*{\stretch{1}}

        {\zihao{-2}\bfseries\sffamily{\ziju{0.5}\neepu@label@ch@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-3} \ulenhance[1.5pt]{\neepu@value@ch@title}}

        \vspace*{\stretch{2.5}}

        \neepu@value@ch@author

        \vspace*{\stretch{2.5}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}c}
            \neepu@label@ch@completedate & \ulenhance{\ulextend[200pt]{\neepu@value@ch@completedate}}\\
            \neepu@label@ch@submitdate & \ulenhance{\ulextend[200pt]{\neepu@value@ch@submitdate}}\\
        \end{tabular}

        \vspace*{\stretch{2}}

        \neepu@value@ch@institute

        \neepu@value@ch@date

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
    \ifneepu@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
%-
%-> 英文标题页
%-
\newcommand{\MAKETITLE@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}

    % 分类号
    \begin{table}
        \zihao{-4}
        \flushleft
        \def\arraystretch{0.75}
        \begin{tabular}{p{10.5cm}l}
            \neepu@label@en@classid \neepu@value@en@classid \\
            \neepu@label@en@udc \neepu@value@en@udc \\
        \end{tabular}
    \end{table}

    \begin{center}
        \linespread{1.6}
        \zihao{4}

        \vspace*{\stretch{8}}

        % 论文标题
        {\zihao{-2}\bfseries {\neepu@value@en@title}}

        
        \vspace*{\stretch{15}}

        % 作者信息
        \def\tabcolsep{10pt}
        \def\arraystretch{1.2}
        \begin{tabular}{rl}
            \bfseries \neepu@label@en@author & \neepu@value@en@author \\
            \bfseries \neepu@label@en@advisor & \neepu@value@en@advisor \\
            \bfseries \neepu@label@en@degree & \neepu@value@en@degree~of~\neepu@value@en@degreetype \\
            \bfseries \neepu@label@en@major & \neepu@value@en@major \\
            \bfseries \neepu@label@en@institute & \neepu@value@en@institute \\
            \bfseries \neepu@label@en@date & \neepu@value@en@date \\
            \bfseries \neepu@label@en@school & \neepu@value@en@school \\
        \end{tabular}

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
\newcommand{\MAKETITLE@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{2.0}
        \zihao{4}

        \vspace*{50pt}

        {\zihao{3} \neepu@value@ch@title}

        \vspace*{\stretch{3}}

        {\zihao{-3} \neepu@value@en@title}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}l}
            \makebox[11em][s]{\neepu@label@ch@author} & \neepu@value@ch@author\\
            \makebox[11em][s]{\neepu@label@ch@subject} & \neepu@value@ch@subject\\
            \makebox[11em][s]{\neepu@label@ch@major} & \neepu@value@ch@major\\
        \end{tabular}

        \vspace*{\stretch{3}}

        \neepu@label@ch@studydatefrom \quad \neepu@value@ch@studydatefrom

        \neepu@label@ch@studydateto \quad \neepu@value@ch@studydateto

        \vspace*{\stretch{3}}

        \neepu@value@ch@orginization

        \neepu@value@ch@date

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> 原创性声明
%---------------------------------------------------------------------------%
\newcommand{\makedeclaration}{%
    % \cleardoublepage
    % \thispagestyle{empty}
    {
        \linespread{1.25}
        \zihao{5}

        \vspace*{5ex}

        \begin{center}
            {\zihao{-3}\sffamily \neepu@label@ch@declare@creativity}
        \end{center}

        {\neepu@value@ch@declare@creativity}

        \vspace*{5ex}

        {\hfill{} {\neepu@label@ch@declare@author \hspace*{10em}} \neepu@label@ch@declare@date \hspace*{9em}}

        \vspace*{10ex}

        \begin{center}
            {\zihao{-3}\sffamily \neepu@label@ch@declare@rights}
        \end{center}

        {\neepu@value@ch@declare@rights}

        {\neepu@value@ch@declare@rule}

        \vspace*{5ex}

        {\hfill{} {\neepu@label@ch@declare@author \hspace*{10em} \neepu@label@ch@declare@date \hspace*{9em}}}

        {\hfill{} {\neepu@label@ch@declare@advisor \hspace*{10em} \neepu@label@ch@declare@date \hspace*{9em}}}

        \vspace*{3ex}
    }
    \cleardoublepage[noheaderstyle]% 让文档总是结束于偶数页
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> 关键词
%---------------------------------------------------------------------------%
%- define chinese keywords
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\sffamily \neepu@label@ch@keywords} #1}
%- define engish keywords
\newcommand{\KEYWORDS}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \neepu@label@en@keywords} #1}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifneepu@plain%
    \def\contentsname{\neepu@label@en@tocname}
    \def\listfigurename{\neepu@label@en@lsfigname}
    \def\listtablename{\neepu@label@en@lstabname}
    \def\bibname{\neepu@label@en@bibname}
    \def\refname{\neepu@label@en@bibname}
    \def\algname{\neepu@label@en@algname}
    \def\bibetal{\neepu@label@en@bibetal}
    \def\biband{\neepu@label@en@biband}
    \def\axiomname{\neepu@label@en@axiomname}
    \def\theoremname{\neepu@label@en@theoremname}
    \def\lemmaname{\neepu@label@en@lemmaname}
    \def\corollaryname{\neepu@label@en@corollaryname}
    \def\assertionname{\neepu@label@en@assertionname}
    \def\propositionname{\neepu@label@en@propositionname}
    \def\conjecturename{\neepu@label@en@conjecturename}
    \def\definitionname{\neepu@label@en@definitionname}
    \def\examplename{\neepu@label@en@examplename}
    \def\remarkname{\neepu@label@en@remarkname}
    \def\proofname{\neepu@label@en@proofname}
    \def\@title{\neepu@value@en@titlemark}
    \def\@author{\neepu@value@en@author}
\else
    \def\contentsname{\neepu@label@ch@tocname}
    \def\listfigurename{\neepu@label@ch@lsfigname}
    \def\listtablename{\neepu@label@ch@lstabname}
    \def\algname{\neepu@label@ch@algname}
    \def\bibname{\neepu@label@ch@bibname}
    \def\refname{\neepu@label@ch@bibname}
    \def\bibetal{\neepu@label@ch@bibetal}
    \def\biband{\neepu@label@ch@biband}
    \def\axiomname{\neepu@label@ch@axiomname}
    \def\theoremname{\neepu@label@ch@theoremname}
    \def\lemmaname{\neepu@label@ch@lemmaname}
    \def\corollaryname{\neepu@label@ch@corollaryname}
    \def\assertionname{\neepu@label@ch@assertionname}
    \def\propositionname{\neepu@label@ch@propositionname}
    \def\conjecturename{\neepu@label@ch@conjecturename}
    \def\definitionname{\neepu@label@ch@definitionname}
    \def\examplename{\neepu@label@ch@examplename}
    \def\remarkname{\neepu@label@ch@remarkname}
    \def\proofname{\neepu@label@ch@proofname}
    \def\@title{\neepu@value@ch@titlemark}
    \def\@author{\neepu@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure layout
%---------------------------------------------------------------------------%
%- chapter
\ctexset {
    chapter = {
        format = \linespread{1.2}\zihao{-2}\sffamily\centering,
        nameformat = {},
        titleformat = {},
        number = \arabic{chapter},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {9pt},
        afterskip = {12pt},
        pagestyle = plain,
    }
}
%- section
\ctexset {
    section = {
        format = \linespread{1.0}\zihao{-3}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {12pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.0}\zihao{4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- appendix
\ctexset {
    appendix = {
        %numbering = true|false,
        %number = \rmfamily\Alph{chapter},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@chaptervspace{1ex}% vertical space between chapter titles

%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{-4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{-4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
%- redefine indentation for others
\renewcommand*\l@section{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3em}{3.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4em}{4.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{5em}{5.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{1em}{1.8em}}


%----------------------------------------
% Force Songti font for TOC entries
%----------------------------------------
\renewcommand*\l@section[2]{%
  \@dottedtocline{1}{1em}{1.8em}{\songti #1}{#2}%
}

\renewcommand*\l@subsection[2]{%
  \@dottedtocline{2}{2em}{2.8em}{\songti #1}{#2}%
}

\renewcommand*\l@subsubsection[2]{%
  \@dottedtocline{3}{3em}{3.8em}{\songti #1}{#2}%
}

%---------------------------------------------------------------------------%
\endinput

