{ pkgs, ... }:
{

  home.file.".config/sublime-text/Packages/User/Preferences.sublime-settings".text = builtins.toJSON {
    # Apparence minimaliste
    theme = "Default.sublime-theme";
    color_scheme = "Mariana.sublime-color-scheme";
    
    # Interface épurée
    show_minimap = false;
    show_tabs = true;
    show_sidebar = true;
    
    # Police et taille
    font_face = "SF Mono";
    font_size = 13;
    
    # Lignes et espacement
    line_padding_top = 2;
    line_padding_bottom = 2;
    caret_style = "phase";
    highlight_line = true;
    
    # Gestion des fichiers
    save_on_focus_lost = true;
    atomic_save = false;
    ensure_newline_at_eof_on_save = true;
    trim_trailing_white_space_on_save = "all";
    
    # Indentation
    tab_size = 2;
    translate_tabs_to_spaces = true;
    detect_indentation = true;
    
    # Performance et comportement
    index_files = true;
    hot_exit = true;
    remember_open_files = true;
    
    # UI clean
    fade_fold_buttons = true;
    draw_white_space = "none";
    rulers = [ 80 ];
    
    # Markdown
    default_line_ending = "unix";
    word_wrap = true;
    wrap_width = 80;
  };

  home.file.".config/sublime-text/Packages/User/Markdown-PDF.sublime-build".text = ''
    {
      "shell_cmd": "pandoc \"$file\" -o \"$${file_path}/$${file_base_name}.pdf\" --pdf-engine=pdflatex --template=$HOME/.config/sublime-text/Packages/User/apple-template.tex -V geometry:margin=1in -V fontsize=11pt -V linestretch=1.2",
      "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
      "selector": "text.html.markdown",
      "variants": [
        {
          "name": "Preview",
          "shell_cmd": "pandoc \"$file\" -o \"$${file_path}/$${file_base_name}.pdf\" --pdf-engine=pdflatex --template=$HOME/.config/sublime-text/Packages/User/apple-template.tex -V geometry:margin=1in -V fontsize=11pt -V linestretch=1.2 && open \"$${file_path}/$${file_base_name}.pdf\""
        }
      ]
    }
  '';

  home.file.".config/sublime-text/Packages/User/apple-template.tex".text = ''
    \documentclass[$if(fontsize)$$fontsize$,$endif$$if(lang)$$babel-lang$,$endif$$if(papersize)$$papersize$paper,$endif$$for(classoption)$$classoption$$sep$,$endfor$]{article}

    % Polices et encodage
    \usepackage{ifxetex,ifluatex}
    \ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0
      \usepackage[T1]{fontenc}
      \usepackage[utf8]{inputenc}
    \else
      \usepackage{fontspec}
      \defaultfontfeatures{Ligatures=TeX,Scale=MatchLowercase}
      \setmainfont{Helvetica Neue}
      \setsansfont{Helvetica Neue}
      \setmonofont[Scale=0.9]{SF Mono}
    \fi

    % Marges et espacement
    \usepackage{geometry}
    $if(geometry)$
    \geometry{$for(geometry)$$geometry$$sep$,$endfor$}
    $endif$

    \usepackage{setspace}
    $if(linestretch)$
    \setstretch{$linestretch$}
    $endif$

    % Style minimaliste
    \usepackage{parskip}
    \setlength{\parindent}{0pt}
    \setlength{\parskip}{6pt plus 2pt minus 1pt}

    % En-têtes et pieds de page épurés
    \usepackage{fancyhdr}
    \pagestyle{fancy}
    \fancyhf{}
    \renewcommand{\headrulewidth}{0pt}
    \fancyfoot[C]{\thepage}

    % Liens
    \usepackage[unicode=true]{hyperref}
    \hypersetup{
      colorlinks=true,
      linkcolor=black,
      filecolor=black,
      citecolor=black,
      urlcolor=black
    }

    % Titres épurés
    \usepackage{titlesec}
    \titleformat{\section}{\large\bfseries}{\thesection}{1em}{}
    \titleformat{\subsection}{\normalsize\bfseries}{\thesubsection}{1em}{}
    \titleformat{\subsubsection}{\normalsize\itshape}{\thesubsubsection}{1em}{}

    % Code
    \usepackage{listings}
    \lstset{
      basicstyle=\ttfamily\small,
      breaklines=true,
      frame=none,
      backgroundcolor=\color{gray!10}
    }

    % Images
    \usepackage{graphicx}
    \makeatletter
    \def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
    \makeatother
    \setkeys{Gin}{width=\maxwidth,keepaspectratio}

    % Métadonnées
    $if(title)$
    \title{$title$}
    $endif$
    $if(author)$
    \author{$for(author)$$author$$sep$ \and $endfor$}
    $endif$
    $if(date)$
    \date{$date$}
    $endif$

    \begin{document}

    $if(title)$
    \maketitle
    $endif$

    $body$

    \end{document}
  '';
}
