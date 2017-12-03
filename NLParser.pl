article("the").
article("it").
article("a").

subject("he").
subject("rat").
subject("einstein").
subject("rodent").
subject("a").
subject("it").

verb("ran").
verb("moved").
verb("pushed").
verb("scurried").

object("squares").
object("square").
object("cells").
object("cell").
object("button").

numb("1").
numb("2").
numb("3").
numb("4").
numb("5").
numb("6").
numb("7").
numb("8").
numb("9").

direction("left").
direction("right").
direction("up").
direction("down").

isSubjectPhrase(X,Y):-
	 write('is subject phrase'),nl,
	 write(X),nl,
	 write(Y),nl,
    article(X),
    subject(Y).


isObjectPhrase(X,Y):-
    article(X),
    object(Y).

isDirectionObjectPhrase(X,Y,Z):-
    numb(X),
    object(Y),
    direction(Z).

isVerbPhrase(X,Y,Z):-
	 write('is verb phrase/3'),nl,
    verb(X),
    isObjectPhrase(Y,Z).

isVerbPhrase(X,Y,Z,W):-
	 write('is verb phrase/4'),nl,
    verb(X),
    isDirectionObjectPhrase(Y,Z,W).

isSentence([X,Y,A,B,C,D]):-
	 write('is sentance/6'),
	 nl,
	 write(X),write(Y),nl,
    isSubjectPhrase(X,Y),
	 write('was subject phrase'),
	 nl,
    isVerbPhrase(A,B,C,D),
    write("Is Sentence"),
    nl.

isSentence([X,Y,A,B,C]):-
    (   isSubjectPhrase(X,Y),
        isVerbPhrase(A,B,C),
        write("Is Sentence"),
        nl);
    (   subject(X),
        isVerbPhrase(Y,A,B,C),
        write("Is Sentence"),
        nl).

isSentence([X,A,B,C]):-
    subject(X),
    isVerbPhrase(A,B,C),
    write("Is Sentence"),
    nl.


printlist([H|T]):-
    write(H),
    nl,
    printlist(T).

printlist([]).

checkLines([H|T]):-
    nth0(0,H,A),
    nth0(1,H,B),
    nth0(2,H,C),
    nth0(3,H,D),
    isSentence(A,B,C,D);
    checkLines(T).

%processWords(X,Y,Words,LastButtonPressed) :-
	
checkLines([]).

writeToFile(Str):-
	open('output.txt',append, Stream),
	write(Stream, Str).
	


 main :-
	open('NL-input.txt', read, Str),
	read_file(Str,Lines),
	%Convert the lines in file to an list of sentences that are lists of words
   lines_to_words(Lines, Words),
   %printlist(Words).
   %checkLines(Words).
	nth0(0,Words,Sentance),
	isSentence(Sentance).
   


% Credit to StackOverflow and author Ishq for file parser
% https://stackoverflow.com/a/4805931
% https://stackoverflow.com/users/577045/ishq
read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).

%Converts sentence to a list of words
lines_to_words([], []).
lines_to_words([H|T], [H2|T2]) :-
    split_string(H, " ", "", H2),
    lines_to_words(T, T2).
