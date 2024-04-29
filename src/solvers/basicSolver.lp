% ====== Type 1 : dot ========= 
% #
one(1, 0, X, Y) :- params(N+1, M+1, K),
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

two(2, 90, X1, Y1, XP2, YP2) :-
    % Rotation axis is (X1, Y1)
    params(N+1, M+1, K),
    two(2, 0, X1, Y1, X2, Y2),
    XP2 = X1 + 1,
    XP2 <= N,
    YP2 = Y1 - 1,
    YP2 >= 0.
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
three(3, 90, XP1, YP1, X2, Y2, XP3, YP3) :-
    % Rotation axis is (X2, Y2) (middle point)
    params(N+1, M+1, K),
    three(3, 0, X1, Y1, X2, Y2, X3, Y3),
    XP1 = X2 + 1,
    XP1 <= N,
    YP1 = Y2 - 1,
    YP1 >= 0,
    XP3 = X2 - 1,
    XP3 >= 0,
    YP3 = Y2 + 1,
    YP3 <= M.
% =============================


% Type 4 : corner 
%  # 
% ##
three(4, 0, X1, Y1, X2, Y1, X2, Y2) :-
    params(N+1, M+1, K),
    X1 = 0..N-1,
    X2 = X1+1,
    Y1 = 0..M-1,
    Y2 = Y1+1.
three(4, 90, X1, Y1+1, X2-1, Y2, X3, Y3-1) :- 
	three(4, 0, X1, Y1, X2, Y2, X3, Y3).
three(4, 180, X1+1, Y1, X2, Y2+1, X3-1, Y3) :- 
	three(4, 90, X1, Y1, X2, Y2, X3, Y3).
three(4, 270, X1, Y1-1, X2+1, Y2, X3, Y3+1) :- 
	three(4, 180, X1, Y1, X2, Y2, X3, Y3).
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
four(6, 90, X1, YP1, XP2, Y2, X3, YP3, X4, YP4) :- 
    params(N+1, M+1, K),
    four(6, 0, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    YP1 = Y1+1,
    YP1 <= M,
    XP2 = X2+1,
    XP2 <= N,
    YP3 = Y2-1,
    YP3 >= 0,
    YP4 = Y3-2,
    YP4 >= 0.
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
four(7, 90, XP1, Y1, X2, YP2, XP3, Y3, XP4, YP4):-
    params(N+1, M+1, K),
    four(7, 0, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP1 = X1+1,
    XP1 <= N,
    YP2 = Y2-1,
    YP2 <= M,
    XP3 = X3-1,
    XP3 >= 0,
    XP4 = X4-2,
    XP4 >= 0,
    YP4 = Y4-1,
    YP4 >= 0.    
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

four(8, 90, X1, Y1, XP2, YP2, XP3, YP3, XP4, YP4) :-
    params(N+1, M+1, K),
    four(8, 0, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP2 = X2+1,
    YP2 = Y2-1,
    XP3 = X3+2,
    XP3 <= N,
    YP3 = Y3-2,
    XP4 = X4-1,
    YP4 = Y4-1.
    YP4 >= 0.

four(8, 180, X1, Y1, XP2, YP2, XP3, YP3, XP4, YP4) :-
    params(N+1, M+1, K),
    four(8, 90, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP2 = X2-1,
    YP2 = Y2-1,
    XP3 = X3-2,
    YP3 = Y3-2,
    YP3 >= 0,
    XP4 = X4-1,
    XP4 >= 0,
    YP4 = Y4-1.

four(8, 270, X1, Y1, XP2, YP2, XP3, YP3, XP4, YP4) :-
    params(N+1, M+1, K),
    four(8, 180, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP2 = X2-1,
    YP2 = Y2+1,
    XP3 = X3-2,
    XP3 >= 0,
    YP3 = Y3+2,
    XP4 = X4+1,
    YP4 = Y4+1.
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

four(9, 90, XP1, YP1, X2, Y2, XP3, YP3, XP4, YP4) :-
    params(N+1, M+1, K),
    four(9, 0, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP1 = X1+1, 
    YP1 = Y1+1,
    XP3 = X3+1,
    XP3 <= N,
    YP3 = Y3-1,
    XP4 = X4+2,
    XP4 <= N,
    YP4 = Y4-2.
four(9, 180, XP1, YP1, X2, Y2, XP3, YP3, XP4, YP4) :-
    params(N+1, M+1, K),
    four(9, 90, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP1 = X1+1,
    YP1 = Y1-1,
    XP3 = X3-1,
    YP3 = Y3-1,
    YP3 >= 0,
    XP4 = X4-2,
    YP4 = Y4-2.
    YP4 >= 0.
four(9, 270, XP1, YP1, X2, Y2, XP3, YP3, XP4, YP4) :-
    params(N+1, M+1, K),
    four(9, 180, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP1 = X1-1,
    YP1 = Y1-1,
    XP3 = X3-1,
    YP3 = Y3+1,
    XP4 = X4-2,
    XP4 >= 0,
    YP4 = Y4+2.
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
four(10, 90, XP1, YP1, X2, Y2, XP3, YP3, XP4, YP4) :-
    params(N+1, M+1, K),
    four(10, 0, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP1 = X1+1,
    YP1 = Y1+1,
    YP1 <= M,
    XP3 = X3-1,
    YP3 = Y3-1,
    XP4 = X4-1,
    YP4 = Y4+1.
four(10, 180, XP1, YP1, X2, Y2, XP3, YP3, XP4, YP4) :-
    params(N+1, M+1, K),
    four(10, 90, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP1 = X1+1,
    YP1 = Y1-1,
    XP3 = X3-1,
    YP3 = Y3-1,
    XP4 = X4+1,
    YP4 = Y4+1.
four(10, 270, XP1, YP1, X2, Y2, XP3, YP3, XP4, YP4) :-
    params(N+1, M+1, K),
    four(10, 180, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP1 = X1-1,
    YP1 = Y1-1,
    XP3 = X3+1,
    YP3 = Y3+1,
    XP4 = X4+1,
    YP4 = Y4-1.
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
four(11, 90, XP1, YP1, X2, Y2, XP3, YP3, XP4, YP4) :-
    % Rotation axis is (X2, Y2)
    params(N+1, M+1, K),
    four(11, 0, X1, Y1, X2, Y2, X3, Y3, X4, Y4),
    XP1 = X1-1,
    XP1 >= 0,
    YP1 = Y1+1,
    XP3 = X3+1,
    XP3 <= N,
    YP3 = Y3-1,
    XP4 = X4+2,
    XP4 <= N,
    YP4 = Y4-2.
% =============================    
   
