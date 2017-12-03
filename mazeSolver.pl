:- module(mazeSolver, [isValidMove/3, main/0]).

:- use_module(mazeInfo, [info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).

main :-
	start(X,Y),
	tryMove(X,Y,X,Y,0,[],[]),
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

isValidSolution(X,Y,LastButtonHit,MoveList) :-
	goal(X,Y),
	info(_,_,Mode),
	(
		Mode='a';
		num_buttons(LastButtonHit)
	),
	printList(MoveList).

isValidMove(X,Y,LastButtonHit) :-
	isValidLocation(X,Y),
	info(_,_,Mode),
	(	
		isValidSolution(X,Y,LastButtonHit,[]);
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
		(Mode='b');
		(
			Mode='c',
			Q2 is Q + 1,
			(button(X,Y,Q2))
		)
	).

printList([[X,Y]|TAIL]) :-
	printCoordinates(X,Y),
	printList(TAIL).

printList([]).

printCoordinates(X,Y) :-
	open('path-solution.txt',append,Stream),
	write(Stream, '['),
	write(Stream, X),
	write(Stream, ','),
	write(Stream, Y),
	write(Stream, ']'),
	nl(Stream),
	close(Stream).

doesNotContain(X,Y,[[A,B]|Tail]):-
	(
		\+(X=A);
		\+(Y=B)
	),
	doesNotContain(X,Y,Tail).

doesNotContain(_,_,[]).

isNewButtonPress(X,Y,ButtonsPressed):-
	button(X,Y,_),
	doesNotContain(X,Y,ButtonsPressed).

copyList(Old, New):-
	New = Old.

/* Return true if the move is valid, false otherwise */
validMove(X,Y,Direction, Distance, NumButtonsHit, ButtonsPressed):-
	(Distance = 0);
	(
		(
			(Direction = 'up', NewY is Y+1, NewX is X);
			(Direction = 'down', NewY is Y-1, NewX is X);
			(Direction = 'left', NewY is Y, NewX is X-1);
			(Direction = 'right', NewY is Y, NewX is X+1);
		),
		isValidMove(NewX,NewY,NumButtonsHit),
		(isNewButtonPress(X,Y,ButtonsPressed) -> 
			(B is NumButtonsHit + 1, append(ButtonsPressed,[[X,Y]],NewButtonList));
			(B is NumButtonsHit, copyList(ButtonsPressed, NewButtonList))
		),
		NewDist is Distance - 1,
		validMove(NewX,NewY,Direction,NewDist,B,NewButtonList)
	).

tryMove(X, Y, OldX, OldY, NumButtonsHit ,MoveList,ButtonsPressed) :-
	isValidMove(X,Y,NumButtonsHit),
	Up is Y+1,
	Down is Y-1,
	Left is X-1,
	Right is X+1,
	append(MoveList, [[X,Y]], NewMoveList),
	(isNewButtonPress(X,Y,ButtonsPressed) -> 
		(B is NumButtonsHit + 1, append(ButtonsPressed,[[X,Y]],NewButtonList));
		(B is NumButtonsHit, copyList(ButtonsPressed, NewButtonList))
	),
	(
		isValidSolution(X,Y,B,NewMoveList);
		((\+(Up = OldY)), tryMove(X,Up,X,Y,B,NewMoveList,NewButtonList));
		((\+(Down = OldY)), tryMove(X,Down,X,Y,B,NewMoveList,NewButtonList));
		((\+(Left = OldX)), tryMove(Left,Y,X,Y,B,NewMoveList,NewButtonList));
		((\+(Right = OldX)), tryMove(Right,Y,X,Y,B,NewMoveList,NewButtonList))
	).

	
