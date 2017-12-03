article(the).
article(it).
article(a).

subject(he).
subject(rat).
subject(einstein).
subject(rodent).
subject(a).
subject(it).

verb(ran).
verb(moved).
verb(pushed).
verb(scurried).

object(squares).
object(square).
object(cells).
object(cell).
object(button).

numb(1).
numb(2).
numb(3).
numb(4).
numb(5).
numb(6).
numb(7).
numb(8).
numb(9).

direction(left).
direction(right).
direction(up).
direction(down).

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
    verb(x),
    isDirectionObjectPhrase(Y,Z,W).

isSentence(X,Y,A,B,C,D):-
    isSubjectPhrase(X,Y),
    isVerbPhrase(A,B,C,D).

isSentence(X,Y,A,B,C):-
    (   isSubjectPhrase(X,Y),
        isVerbPhrase(A,B,C));
    (   subject(X),
        isVerbPhrase(Y,A,B,C)).

isSentence(X,A,B,C):-
    subject(X),
    isVerbPhrase(A,B,C).


    