% ============================= Parameters =============================
% N : width of the board
% M : height of the board
% K : number of blue pieces to cover at most
% Be careful that, in the program, you should use N-1 and M-1 to get the last index of the board
% =====================================================================
% ============================= Pieces given ==========================
% We have a relation h/11 that gives the number of pieces available for each type
available(1, X) :- h(X,_,_,_,_,_,_,_,_,_,_).
available(2, X) :- h(_,X,_,_,_,_,_,_,_,_,_).
available(3, X) :- h(_,_,X,_,_,_,_,_,_,_,_).
available(4, X) :- h(_,_,_,X,_,_,_,_,_,_,_).
available(5, X) :- h(_,_,_,_,X,_,_,_,_,_,_).
available(6, X) :- h(_,_,_,_,_,X,_,_,_,_,_).
available(7, X) :- h(_,_,_,_,_,_,X,_,_,_,_).
available(8, X) :- h(_,_,_,_,_,_,_,X,_,_,_).
available(9, X) :- h(_,_,_,_,_,_,_,_,X,_,_).
available(10, X) :- h(_,_,_,_,_,_,_,_,_,X,_).
available(11, X) :- h(_,_,_,_,_,_,_,_,_,_,X).

blue(-1,-1). % Only there to avoid warnings
red(-1,-1). % Only there to avoid warnings
% =====================================================================


% ====== Type 1 : dot ========= 
% #
one(1, X, Y) :- params(N+1, M+1, K),
    X = 0..N,
    Y = 0..M.
% =============================    


% ===== Type 2 : small i ======
%  #
%  #
two(2, 0, X1, Y1, X1, Y2) :-
    params(N+1, M+1, K),
    X1 = 0..N,
    Y1 = 0..M-1,
    Y2 = Y1+1.

two(2, 90, X1, Y1, X2, Y1) :-
    % ##
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M.
% =============================


% Type 3 : medium i
%  #
%  #
%  #
three(3, 0, X1, Y1, X1, Y2, X1, Y3) :-
    params(N+1, M+1, K),
    X1 = 0..N,
    Y1 = 0..M-2,
    Y2 = Y1+1,
    Y3 = Y1+2.
three(3, 90, X1, Y1, X2, Y1, X3, Y1) :-
    %   ###
    params(N+1, M+1, K),
    X1 = 0..N-2,
    X2 = X1+1,
    X3 = X1+2,
    Y1 = 0..M.
    
% =============================


% Type 4 : corner 
%  # 
% ##
three(4, 0, X1, Y1, X2, Y1, X2, Y2) :-
    %  #
    % ##
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-1,
    Y2 = Y1+1.
three(4, 90, X1, Y1, X2, Y1, X1, Y2) :- 
    % #
    % ##
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-1,
    Y2 = Y1+1.

three(4, 180, X1, Y1, X1, Y2, X2, Y2) :- 
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-1,
    Y2 = Y1+1.

three(4, 270, X1, Y1, X2, Y1, X2, Y2) :-
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 1..M,
    Y2 = Y1-1.
	
% =============================


% Type 5 : square
% ##
% ##
four(5, 0, X1, Y1, X2, Y1, X1, Y2, X2, Y2) :-
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-1,
    Y2 = Y1+1.
% =============================


% Type 6 : S
%  ##
% ##
four(6, 0, X1, Y1, X2, Y1, X2, Y2, X3, Y2) :-
    params(N+1, M+1, K),
    X1 = 0..N-2,
    X2 = X1+1,
    X3 = X1+2,
    Y1 = 0..M-1,
    Y2 = Y1+1.

four(6, 90, X1, Y1, X1, Y2, X2, Y2, X2, Y3) :- 
    % #
    % ##
    %  #
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 2..M,
    Y2 = Y1-1,
    Y3 = Y1-2.

% =============================


% Type 7 : Z
% ##
%  ##
four(7, 0, X1, Y1, X2, Y1, X2, Y2, X3, Y2) :-
    params(N+1, M+1, K),
    X1 = 0..N-2,
    X2 = X1+1,
    X3 = X1+2,
    Y1 = 1..M,
    Y2 = Y1-1.
four(7, 90, X1, Y1, X1, Y2, X2, Y2, X2, Y3):-
    %  #
    % ##
    % #
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-2,
    Y2 = Y1+1,
    Y3 = Y1+2.
     
% =============================


% Type 8 : L
% #
% #
% ##
four(8, 0, X1, Y1, X1, Y2, X1, Y3, X2, Y1) :-
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-2,
    Y2 = Y1+1,
    Y3 = Y1+2.

four(8, 90, X1, Y1, X1, Y2, X2, Y2, X3, Y2) :-
    % ###
    % #
    params(N+1, M+1, K),
    X1 = 0..N-2,
    X2 = X1+1,
    X3 = X1+2,
    Y1 = 0..M-1,
    Y2 = Y1+1.
    

four(8, 180, X1, Y1, X2, Y1, X2, Y2, X2, Y3) :-
    % ##
    %  #
    %  #
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 2..M,
    Y2 = Y1-1,
    Y3 = Y1-2.
    

four(8, 270, X1, Y1, X2, Y1, X3, Y1, X3, Y2) :-
    %   #
    % ###
    params(N+1, M+1, K),
    X1 = 0..N-2,
    X2 = X1+1,
    X3 = X1+2,
    Y1 = 0..M-1,
    Y2 = Y1+1.
    
% =============================


% Type 9 : J
%   #
%   #
%  ##
four(9, 0, X1, Y1, X2, Y1, X2, Y2, X2, Y3) :-
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-2,
    Y2 = Y1+1,
    Y3 = Y1+2.
    
four(9, 90, X1, Y1, X1, Y2, X2, Y1, X3, Y1) :-
    % #
    % ###
    params(N+1, M+1, K),
    X1 = 0..N-2,
    X2 = X1+1,
    X3 = X1+2,
    Y1 = 0..M-1,
    Y2 = Y1+1.

four(9, 180, X1, Y1, X1, Y2, X1, Y3, X2, Y3) :-
    % ##
    % #
    % #
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-2,
    Y2 = Y1+1,
    Y3 = Y1+2.

four(9, 270, X1, Y1, X2, Y1, X3, Y1, X3, Y2) :-
    % ###
    %   #
    params(N+1, M+1, K),
    X1 = 0..N-2,
    X2 = X1+1,
    X3 = X1+2,
    Y1 = 1..M,
    Y2 = Y1-1.

% =============================  


% Type 10 : T
% ###
%  #
four(10, 0, X1, Y1, X2, Y1, X3, Y1, X2, Y2) :-
    params(N+1, M+1, K),
    X1 = 0..N-2,
    X2 = X1+1,
    X3 = X1+2,
    Y1 = 1..M,
    Y2 = Y1-1.

four(10, 90, X2, Y1, X2, Y2, X1, Y2, X2, Y3) :-
    %  #
    % ##
    %  #
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-2,
    Y2 = Y1+1,
    Y3 = Y1+2.
    
four(10, 180, X1, Y1, X2, Y1, X2, Y2, X3, Y1) :-
    %  #
    % ###
    params(N+1, M+1, K),
    X1 = 0..N-2,
    X2 = X1+1,
    X3 = X1+2,
    Y1 = 0..M-1,
    Y2 = Y1+1.

four(10, 270, X1, Y1, X1, Y2, X2, Y2, X1, Y3) :-
    % # 
    % ##
    % #
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-2,
    Y2 = Y1+1,
    Y3 = Y1+2.

% =============================


% Type 11 : I
% #
% #
% #
% #
four(11, 0, X1, Y1, X1, Y2, X1, Y3, X1, Y4) :-
    params(N+1, M+1, K),
    X1 = 0..N,
    Y1 = 0..M-3,
    Y2 = Y1+1,
    Y3 = Y1+2,
    Y4 = Y1+3.
four(11, 90, X1, Y1, X2, Y1, X3, Y1, X4, Y1) :-
    % ####
    params(N+1, M+1, K),
    X1 = 0..N-3,
    X2 = X1+1,
    X3 = X1+2,
    X4 = X1+3,
    Y1 = 0..M.
    
% =============================    
   


% ================= Solution generation =================
% Generate a solution for a size type of piece

% size 1 
0 {one_sol(T, X, Y) : one(T, X, Y)} Max :- available(T, Max).

% size 2
0 {two_sol(T,Rot,X1, Y1, X2, Y2) : two(T,Rot,X1, Y1, X2, Y2)} Max :- available(T, Max).

% size 3
0 {three_sol(T,Rot,X1, Y1, X2, Y2, X3, Y3) : three(T,Rot,X1, Y1, X2, Y2, X3, Y3)} Max :- available(T, Max).

% size 4
0 {four_sol(T,Rot,X1, Y1, X2, Y2, X3, Y3, X4, Y4) : four(T,Rot,X1, Y1, X2, Y2, X3, Y3, X4, Y4)} Max :- available(T, Max).



% ============================= Helpers =================================
isCovered(X, Y, T, 0) :- one_sol(T, X, Y).
isCovered(X, Y, T, R) :- two_sol(T, R, _, _, X, Y).
isCovered(X, Y, T, R) :- two_sol(T, R, X, Y, _, _).
isCovered(X, Y, T, R) :- three_sol(T, R, X, Y, _, _, _, _).
isCovered(X, Y, T, R) :- three_sol(T, R, _, _, X, Y, _, _).
isCovered(X, Y, T, R) :- three_sol(T, R, _, _, _, _, X, Y).
isCovered(X, Y, T, R) :- four_sol(T, R, X, Y, _, _, _, _, _, _).
isCovered(X, Y, T, R) :- four_sol(T, R, _, _, X, Y, _, _, _, _).
isCovered(X, Y, T, R) :- four_sol(T, R, _, _, _, _, X, Y, _, _).
isCovered(X, Y, T, R) :- four_sol(T, R, _, _, _, _, _, _, X, Y).             

% ============================= Constraints =============================
% Constraint 0 : A piece cannot overlap with another piece.
% a : if two piece of different types/rotation overlap
:- isCovered(X, Y, T1, _), isCovered(X, Y, T2, _), T1 != T2.
:- isCovered(X, Y, _, R1), isCovered(X, Y, _, R2), R1 != R2.
% b : if two piece of the same type and rotation overlap
:- two_sol(T, R, X, Y, _, _), two_sol(T, R, _, _, X, Y).

:- three_sol(T, R, X, Y, _, _, _, _), three_sol(T, R, _, _, X, Y, _, _).
:- three_sol(T, R, X, Y, _, _, _, _), three_sol(T, R, _, _, _, _, X, Y).
:- three_sol(T, R, _, _, X, Y, _, _), three_sol(T, R, _, _, _, _, X, Y).

:- four_sol(T, R, X, Y, _, _, _, _, _, _), four_sol(T, R, _, _, X, Y, _, _, _, _).
:- four_sol(t, R, X, Y, _, _, _, _, _, _), four_sol(T, R, _, _, _, _, X, Y, _, _).
:- four_sol(T, R, X, Y, _, _, _, _, _, _), four_sol(T, R, _, _, _, _, _, _, X, Y).


:- four_sol(T, R, _, _, X, Y, _, _, _, _), four_sol(T, R, _, _, _, _, X, Y, _, _).
:- four_sol(T, R, _, _, X, Y, _, _, _, _), four_sol(T, R, _, _, _, _, _, _, X, Y).

:- four_sol(T, R, _, _, _, _, X, Y, _, _), four_sol(T, R, _, _, _, _, _, _, X, Y).



% Constraint 1 : A red cell cannot be covered.
:- red(X, Y), isCovered(X, Y, _, _). % If a cell is red, it cannot be covered.

% Constraint 2 : Every white cell must be covered by a piece.
:- params(N+1,M+1,_), X=0..N, Y=0..M, not red(X, Y), not blue(X, Y), not isCovered(X, Y, _, _).

% Constraint 4 : At most K blue cells can be covered.
% If the number of blue cells that are covered are greater than K.
:- params(_,_,K), Number > K, Number = #count {covered(X,Y) : blue(X, Y),isCovered(X, Y, _, _)}.

% ========================================================================
#show one_sol/3.
#show two_sol/6.
#show three_sol/8.
#show four_sol/10.