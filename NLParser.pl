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
    verb(X),
    isObjectPhrase(Y,Z).

isVerbPhrase(X,Y,Z,W):-
    verb(X),
    isDirectionObjectPhrase(Y,Z,W).

isSentence([X,Y,A,B,C,D]):-
    isSubjectPhrase(X,Y),
    isVerbPhrase(A,B,C,D).

isSentence([X,Y,A,B,C]):-
    (   isSubjectPhrase(X,Y),
        isVerbPhrase(A,B,C)
    );
    (   subject(X),
        isVerbPhrase(Y,A,B,C)
    ).

isSentence([X,A,B,C]):-
    subject(X),
    isVerbPhrase(A,B,C),
    write("Is Sentence"),
    nl.

processWords(X,Y,[Sentence|Tail],LastButtonPressed) :-
	(isSentence(Sentence) -> write('IS SENTENCE'),nl; invalidSentence()),
	processWords(X,Y,Tail,LastButtonPressed).


invalidSentence():-
	writeToFile('Not a valid sentence').

writeToFile(Str):-
	open('output.txt',append, Stream),
	write(Stream, Str),
	nl(Stream),
	close(Stream).
	


 main :-
	open('NL-input.txt', read, Str),
	read_file(Str,Lines),
	%Convert the lines in file to an list of sentences that are lists of words
   lines_to_words(Lines, Words),
   %printlist(Words).
   %checkLines(Words).
	processWords(0,0,Words,0).
   


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
