:- use_module(mazeInfo, [info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).

main :-
open('output.txt',write,X),
write(X,'TEST'),
nl(X),
close(X),
tryMove(3,4,3,4,0),
write('true'),
nl.

isNotButton(X,Y) :- \+ button(X,Y,_).


isValidLocation(X,Y) :-
	isInbounds(X,Y),
	\+ isWall(X,Y).

isWall(X,Y) :- wall(X,Y).

isInbounds(X,Y) :- 
	X > -1, 
	Y > -1, 
	info(W, H,_), 
	X<W,Y<H.

isValidSolution(X,Y,LastButtonHit) :-
	goal(X,Y),
	info(_,_,Mode),
	(
		Mode='a';
		num_buttons(LastButtonHit)
	).

isValidMove(X,Y,LastButtonHit) :-
	isValidLocation(X,Y),
	info(_,_,Mode),
	(	
		isValidSolution(X,Y,LastButtonHit);
		\+ goal(X,Y)
	),
	(
		Mode='a';
		isNotButton(X,Y);
		isValidButtonPress(X,Y,LastButtonHit)
	).
		
isValidButtonPress(X,Y,Q) :-
	info(_,_,Mode),
	(
		(Mode='a');
		(
			Q2 is Q + 1,
			(button(X,Y,Q2))
		)
	).

tryMove(X, Y, OldX, OldY, LastButtonHit) :-
	isValidMove(X,Y,LastButtonHit),
	Up is Y+1,
	Down is Y-1,
	Left is X-1,
	Right is X+1,
	(isNotButton(X,Y) -> B is LastButtonHit; B is LastButtonHit + 1),
	(
		isValidSolution(X,Y,LastButtonHit);
		((\+(Up = OldY)), tryMove(X,Up,X,Y,B));
		((\+(Down = OldY)), tryMove(X,Down,X,Y,B));
		((\+(Left = OldX)), tryMove(Left,Y,X,Y,B));
		((\+(Right = OldX)), tryMove(Right,Y,X,Y,B))
	),
	write('test'), write(X),write(Y),write(LastButtonHit),nl.

	
