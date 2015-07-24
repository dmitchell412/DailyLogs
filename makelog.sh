# This script generates a template for recording daily notes in LaTeX, compiles the PDF, and commits the results to GitHub.

#!/bin/bash
maketex() {
	if [ ! -d $1 ]; then
		mkdir $1
	fi
	if [ -f $1/$2.tex ]; then
		echo "Error: .tex already exists for this date or name."
	else
		cat > $1/$2.tex << END
		
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
		vim $1/$2.tex 
	fi
}

# Compile .pdf and remove extraneous files
makepdf() {
	if [ -f $1/$2.tex ]; then
		cd $1
		pdflatex $2.tex #WIP: Check exit status of pdflatex
		rm $2.out $2.log $2.aux # WIP: Check existence of extraneous files
		cd ..
	else
		echo "Error: .tex does not exist for this date or name."
	fi
}

# Add, commit, and push to GitHub
gitpush() {
	if [ -f $1/$2.tex ] || [ -f $1/$2.pdf ]; then
		if [ -f $1/$2.tex ]; then
			git add $1/$2.tex
		fi
		if [ -f $1/$2.pdf ]; then
			git add $1/$2.pdf
		fi
		git commit -m "Daily log update for $(date +"%A, %B %d, %Y")."
		git push origin master
	else
		echo "Error: Neither .tex nor .pdf for this date or name exists."
	fi
}

# Compile weekly summary
weeksum() {
	echo WIP # WIP: Make weekly summary function to compile logs for one week
}

# Define directory and file names
makevar() {
	if [[ "$1" =~ ^[0-9]+$ ]] && [ -z "$2" ]; then
		DIRNAME=logs_$(date -d "-$1 days" +"%Y-%m")
		FILENAME=log_DPM_$(date -d "-$1 days" +"%Y-%m-%d")
	elif [ -z "$2" ]; then
		DIRNAME=logs_misc
		FILENAME=log_DPM_$1
	else
		DIRNAME=logs_$2
		FILENAME=log_DPM_$1
	fi
}

# Select subset of functions
branchchoice() {
	if [ -z "$1" ] || [ "$1" = "all" ]; then # WIP: Make this branch structure a case
		maketex $2 $3
		makepdf $2 $3
		gitpush $2 $3
	elif [ "$1" = "tex" ]; then
		maketex $2 $3
	elif [ "$1" = "pdf" ]; then
		makepdf $2 $3
	elif [ "$1" = "git" ]; then
		gitpush $2 $3
	elif [ "$1" = "makeall" ]; then
		maketex $2 $3
		makepdf $2 $3
	elif [ "$1" = "makepush" ]; then
		makepdf $2 $3
		gitpush $2 $3
	else
		echo "Error: Invalid argument."
	fi
}

#branchchoice() {
#	case "$1" in
#	[ "$1" = "all" ] ) echo 1;;
#	[ "$1" = "tex" ] 		) echo 2;;
#	[ "$1" = "pdf" ]		) echo 3;;
#	[ "$1" = "git" ]		) echo 4;;
#	[ "$1" = "makeall" ]		) echo 5;;
#	[ "$1" = "makepush" ]		) echo 6;;
#	esac
#	if [ -z "$1" ] || [ "$1" = "all" ]; then # WIP: Make this branch structure a case
#		maketex $2 $3
#		makepdf $2 $3
#		gitpush $2 $3
#	elif [ "$1" = "tex" ]; then
#		maketex $2 $3
#	elif [ "$1" = "pdf" ]; then
#		makepdf $2 $3
#	elif [ "$1" = "git" ]; then
#		gitpush $2 $3
#	elif [ "$1" = "makeall" ]; then
#		maketex $2 $3
#		makepdf $2 $3
#	elif [ "$1" = "makepush" ]; then
#		makepdf $2 $3
#		gitpush $2 $3
#	else
#		echo "Error: Invalid argument."
#	fi
#}

# Perform functions from script input
branchchoice $1
#if [ -z "$1" ] || [ "$1" = "^\d+$" ]; then
#
#if [ $# -ge 2 ]; then
#	DIRNAME=logs_$(date -d "-$2 days" +"%Y-%m")
#	FILENAME=log_DPM_$(date -d "-$2 days" +"%Y-%m-%d")
#else
#	DIRNAME=logs_$(date +"%Y-%m")
#	FILENAME=log_DPM_$(date +"%Y-%m-%d")
#fi
