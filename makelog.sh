#!/bin/bash

# This script generates a template for recording daily notes in LaTeX, compiles the PDF, and/or commits the results to GitHub.

# Open file in vim
openfile() {	# Arguments: $DIRNAME $FILENAME [$FILESEARCHSTRING] [$VSPLITFILENAME]
	if [ -z "$3" ]; then vim +1/Objectives -O "$1"/"$2".tex "$4"
	else vim +1/"$3" -O "$1"/"$2".tex "$4"; fi
}

# Create directory and .tex
maketex() {	# Arguments: $DIRNAME $FILENAME [$FILESEARCHSTRING] [$VSPLITFILENAME]
	if [ ! -d "$1" ]; then mkdir "$1"; fi
	if [ -f "$1"/"$2".tex ]; then
		read -p ""$1"/"$2".tex already exists. Open "$1"/"$2".tex? [y/n] " -n 1 -r; echo
		if [[ $REPLY =~ ^[Yy]$ ]]; then openfile "$@"; fi
	elif [ -n "$1" ] && [ -n "$2" ]; then
		cat > "$1"/"$2".tex << END
\documentclass{article}         % Must use LaTeX 2e
\usepackage[plainpages=false, colorlinks=true, citecolor=black, filecolor=black, linkcolor=black, urlcolor=black]{hyperref}		
\usepackage[left=.75in,right=.75in,top=.75in,bottom=.75in]{geometry}
\usepackage{makeidx,color,parskip}
\usepackage{graphicx,float}
\usepackage{amsmath,amsthm,amsfonts,amscd,amssymb} 
\allowdisplaybreaks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Some math support.					     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	Theorem environments (these need the amsthm package)
%
%% \theoremstyle{plain} %% This is the default

\newtheorem{thm}{Theorem}[section]
\newtheorem{cor}[thm]{Corollary}
\newtheorem{lem}[thm]{Lemma}
\newtheorem{prop}[thm]{Proposition}
\newtheorem{ax}{Axiom}

\theoremstyle{definition}
\newtheorem{defn}{Definition}[section]

\theoremstyle{remark}
\newtheorem{rem}{Remark}[section]
\newtheorem*{notation}{Notation}
\newtheorem*{exrcs}{Exercise}
\newtheorem*{exmple}{Example}

%\numberwithin{equation}{section}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Macros.							     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\eq}[1]{\begin{equation} #1 \end{equation}}

\newcommand{\R}{\mathbb{R}}
\newcommand{\Pbf}{\mathbf{P}}
\newcommand{\Rbf}{\mathbf{R}}
\newcommand{\Vbf}{\mathbf{V}}
\newcommand{\Xbf}{\mathbf{X}}
\newcommand{\Ybf}{\mathbf{Y}}
\newcommand{\zbf}{\mathbf{z}}
\newcommand{\Zbf}{\mathbf{Z}}
\newcommand{\mubf}{\boldsymbol{\mu}}
\newcommand{\Gammabf}{\mathbf{\Gamma}}
\newcommand{\Cbf}{\mathbf{C}}
\newcommand{\Sigmabf}{\boldsymbol{\Sigma}}
\newcommand{\zcond}{\mathbf{z}|\mu}
\newcommand{\signalG}{\mathcal{G}\paren{\mu,\mathbf{k}}}
\newcommand{\Nscript}{\mathcal{N}}
\newcommand{\CNscript}{\mathcal{CN}}
\newcommand{\im}{\mathrm{i}}

\newcommand{\paren}[1]{\left(#1\right)}
\newcommand{\bracket}[1]{\left[#1\right]}
\newcommand{\braced}[1]{\left\{#1\right\}}
\newcommand{\arr}[2]{\begin{array}{#1} #2 \end{array}}
\newcommand{\parenarray}[2]{\paren{\arr{#1}{#2}}}
\newcommand{\brkarray}[2]{\bracket{\arr{#1}{#2}}}

\newcommand{\expect}[1]{\mathrm{E}\left[#1\right]}
\newcommand{\reop}[1]{\operatorname{Re}\paren{#1}}
\newcommand{\imop}[1]{\operatorname{Im}\paren{#1}}

\newcommand{\qq}{\qquad\qquad}

\newcommand{\CNpdf}[4]{\frac{1}{\pi^k\sqrt{\mathrm{det}\paren{#3}\mathrm{det}\paren{\bar{#3} - \bar{#4}^T#3^{-1}#4}}} \exp\left\{-\frac{1}{2} \paren{\begin{array}{cc}\paren{\bar{#1} - \bar{#2}}^T & \paren{#1 - #2}^T\end{array}} \paren{\begin{array}{cc} #3 & #4 \\ \bar{#4}^T & \bar{#3} \end{array}}\paren{\begin{array}{c} #1 - #2 \\ \bar{#1} - \bar{#2} \end{array}}\right\}}

% END PREAMBLE

\begin{document}                % The start of the document

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Objectives}\label{Objectives}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Work}\label{Work}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Derivations}\label{Derivations}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Directions}\label{Directions}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



\end{document}

END
		openfile "$@"
	else
		echo "Error: Either DIRNAME or FILENAME is a null string."
	fi
}

# Compile .pdf and remove extraneous files
makepdf() {	# Arguments: $DIRNAME $FILENAME [$PDFVIEWSUPPRESS]
	if [ -f "$1"/"$2".tex ]; then
		cd "$1"
		pdflatex "$2".tex #WIP: Check exit status of pdflatex
		if [ -f "$2".out ]; then rm "$2".out; fi
		if [ -f "$2".log ]; then rm "$2".log; fi
		if [ -f "$2".aux ]; then rm "$2".aux; fi
		if [ ! "$3" = "noview" ]; then evince "$2".pdf & fi
		cd ..
	else
		echo "Error: "$1"/"$2".tex does not exist."
	fi
}

# Add, commit, and push to GitHub
gitpush() {	# Arguments: $DIRNAME $FILENAME
	if [ -f "$1"/"$2".tex ] || [ -f "$1"/"$2".pdf ]; then
		if [ -f "$1"/"$2".tex ]; then git add "$1"/"$2".tex; fi
		if [ -f "$1"/"$2".pdf ]; then git add "$1"/"$2".pdf; fi
		git commit -m "Daily log update for $(date +"%A, %B %d, %Y")." # WIP: Consider more informative message for misc
		git push origin master
	else
		echo "Error: Neither "$1"/"$2".tex nor "$1"/"$2".pdf exists."
	fi
}

# Compile weekly summary
weeksum() {
	echo WIP # WIP: Make weekly summary function to compile logs for one week
}

# Update preamble in this script from .tex files
updatepreamble() {
	echo WIP # WIP: Make function to pull new update preambles from .tex files and insert into this script
}

# Define directory and file names
makevar() {	# Arguments: [$FILENAME or $NUMBERDAYSPREVIOUS] [$DIRNAME]
	if [ -z "$1" ]; then
		DIRNAME=logs_$(date +"%Y-%m")
		FILENAME=log_DPM_$(date +"%Y-%m-%d")
	elif [[ "$1" =~ ^[0-9]+$ ]] && [ -z "$2" ]; then
		DIRNAME=logs_$(date -d "-"$1" days" +"%Y-%m")
		FILENAME=log_DPM_$(date -d "-"$1" days" +"%Y-%m-%d")
	elif [ -z "$2" ]; then
		DIRNAME=logs_misc
		FILENAME=log_DPM_"$1"
	else
		DIRNAME=logs_"$2"
		FILENAME=log_DPM_"$1"
	fi
}

# Select subset of functions
branchchoice() {	# Arguments: $CHOICE $DIRNAME $FILENAME
	declare -a choice=(all tex pdf git makeall makepush)
	if [ -z "$1" ] || [ "$1" = ${choice[0]} ]; then # WIP: Consider case for this branch structure
		maketex "$2" "$3"
		makepdf "$2" "$3"
		read -p "Push to GitHub? [y/n] " -n 1 -r; echo
		if [[ $REPLY =~ ^[Yy]$ ]]; then gitpush "$2" "$3"; fi
	elif [ "$1" = ${choice[1]} ]; then
		maketex "$2" "$3"
	elif [ "$1" = ${choice[2]} ]; then
		makepdf "$2" "$3"
	elif [ "$1" = ${choice[3]} ]; then
		gitpush "$2" "$3"
	elif [ "$1" = ${choice[4]} ]; then
		maketex "$2" "$3"
		makepdf "$2" "$3"
	elif [ "$1" = ${choice[5]} ]; then
		makepdf "$2" "$3"
		gitpush "$2" "$3"
	else
		echo "Error: Invalid argument."
	fi
}

# Perform functions from script input
#makevar "$1" "$2"
#branchchoice "$1" "$2" "$3" #$DIRNAME $FILENAME
makevar "$1" "$2"
maketex "$DIRNAME" "$FILENAME" "$3" "$4"
#makepdf "$1" "$2" "$3"

