\begin{center}

\mbox{}\\[3cm]

\textsc{\huge 2657 R Functions}\\[1.25cm]

\large
\emph{Maintained by}\\
Ananda Mahto

\emph{Last updated}\\
\today

\vfill
\textsc{\Large 2657 Productions}\\
\textsc{\small Santa Barbara, California, USA}\\
\textsc{\small Chennai, Tamil Nadu, India}\\[0.5cm]

\end{center}

\pagenumbering{gobble}
\pagestyle{plain}
\cleardoublepage

\textsc{\huge 2657 R Functions}

\vfill
\textsc{\Large 2657 Productions} \
\textsc{\small Santa Barbara, California, USA} \
\textsc{\small Chennai, Tamil Nadu, India}


\newpage

\small

The scripts and documentation within this collection \copyright\ 2012--\the\year\ by Ananda Mahto under a "Creative Commons *Attribution-ShareAlike* license". See \url{http://creativecommons.org/licenses/by-sa/3.0/}.

\vspace{.5 cm}

\scriptsize
\begin{sloppypar}
\flushleft
\begin{itemize} \itemsep1pt \parskip0pt \parsep0pt
    \item Partial script contributions by:
    \begin{itemize}
        \item Ben Bolker \url{http://www.math.mcmaster.ca/~bolker}, \url{http://stackoverflow.com/users/190277/ben-bolker}: \verb=stringseed.sampling=
        \item cbeleites \url{http://stackoverflow.com/users/755257/cbeleites}: \verb=which.quantile= funtion in \verb=row.extractor=
        \item David Winsemius \url{http://stackoverflow.com/users/1855677/dwin}: \verb=concat.split=
        \item Justin \url{http://stackoverflow.com/users/906490/justin}: \verb=multi.freq.table=
        \item kohske \url{http://stackoverflow.com/users/314020/kohske}: \verb=table2df=
    \end{itemize}

    \item Relevant questions or answers on Stack Overflow:
    \begin{itemize}
        \item \verb=concat.split=: \url{http://stackoverflow.com/q/10100887/1270695}; \url{http://stackoverflow.com/a/13912721/1270695}
        \item \verb=multi.freq.table=: \url{http://stackoverflow.com/q/11348391/1270695}; \url{http://stackoverflow.com/a/11623623/1270695}
        \item \verb=row.extractor=: \url{http://stackoverflow.com/q/10256503/1270695}
        \item \verb=stringseed.sampling=: \url{http://stackoverflow.com/q/10910698/1270695}
        \item \verb=table2df=: \url{http://stackoverflow.com/a/6463137/1270695}
    \end{itemize}

    \item ``Borrowed'' functions:
    \begin{itemize}
        \item \verb=LinearizeNestedList= function (loaded automatically when the \verb=CBIND= function is run) by Akhil S Bhel: \url{https://sites.google.com/site/akhilsbehl/geekspace/articles/r/linearize_nested_lists_in_r}
        \item \verb=mv= function by Rolf Turner: (\url{https://stat.ethz.ch/pipermail/r-help/2008-March/156035.html})
        \item \verb=round2= function by an anonymous commenter at the \emph{Statistically Significant} blog (see: \url{http://www.webcitation.org/68djeLBtJ}). See also: \url{http://stackoverflow.com/q/12688717/1270695}
    \end{itemize}
\end{itemize}
\end{sloppypar}

\vfill
\begin{flushright} \large
\textsc{\normalsize Ananda Mahto}\\
\textup{\scriptsize \url{http://news.mrdwab.com}}\\
\textup{\scriptsize \url{http://stackoverflow.com/users/1270695/ananda-mahto}}\\
\textup{\scriptsize \url{https://github.com/mrdwab}}\\
\textup{\scriptsize E-mail: ananda@mahto.info}\\
\end{flushright}
\normalsize

\newpage

\tableofcontents
\cleardoublepage

\setcounter{page}{1}
\pagenumbering{arabic}

\part{Function Descriptions and Examples}
