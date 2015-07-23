# This script generates a template for recording daily notes in LaTeX, compiles the PDF, and commits the results to GitHub.

DIRNAME="logs_$(date +"%Y-%m")"
FILENAME="DPM_log_$(date +"%Y-%m-%d").tex"
if [ ! -d $DIRNAME ]; then
	mkdir $DIRNAME
fi
if [ -a $DIRNAME/$FILENAME ]; then
	echo "Error: File already exists for this date."
else
	cat > $DIRNAME/$FILENAME << END
	
	\documentclass{article}         % Must use LaTeX 2e
	\usepackage[plainpages=false, colorlinks=true, citecolor=black, filecolor=black, linkcolor=black, urlcolor=black]{hyperref}		
	\usepackage[left=.75in,right=.75in,top=.75in,bottom=.75in]{geometry}
	\usepackage{makeidx,color,boxedminipage}
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
	%
	%	Here some macros that are needed in this document:
	
	\newcommand{\motion}{\mathbf{\varphi}}
	\newcommand{\hmotion}{\mbox{\boldmath $\hat{\varphi}$}}
	\newcommand{\cauchy}{\mbox{\boldmath $\sigma$}}
	\newcommand{\eqn}[1]{(\ref{#1})}
	\newcommand{\hOmega}{\hat{\Omega}}
	\newcommand{\homega}{\hat{\omega}}
	\newcommand{\nphalf}{n+\frac{1}{2}}
	\newcommand{\nmhalf}{n-\frac{1}{2}}
	\newcommand{\kmhalf}{k-\frac{1}{2}}
	\newcommand{\kphalf}{k+\frac{1}{2}}
	\newcommand{\picdir}{pdffig}
	
	\begin{document}                % The start of the document
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	\section{Mutual Information Problem Definition}\label{MIProblem}
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	\subsection{Signal Model}
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
END
	cd $DIRNAME
	vim $FILENAME 
	pdflatex $FILENAME
	cd ..
fi

# add commands to automatically pdflatex and rm aux files
# add commands to automatically commit to github
