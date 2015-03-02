%Cliff Walking where:
%N = Number of Episodes (Defaults to 50000)
%D = Discount Factor (Defaults to .9)
%E = E-Greedy % (Defaults to .1)
%P = Alpha or Learning Rate (Defaults to .2) if set to > 1 or < 0 we get a decreasing proportional of 1/N
function Cliff_Walking(N,D,E,P)
    if nargin < 4, P = .2; end
    if nargin < 3, E = .1; end
    if nargin < 2, D = .9; end
    if nargin < 1, N = 50000; end
    C = ones(48,4); %Visit Count for each State-Action Pair (Used for calculating Alpha)
    %Q(s,a) Reward Matrix for Cliff Walking -Inf Represents an Impossible Action
    %--------------------------------------------------------
    %    left  right  up   down    |  Grid Position  | State
    %--------------------------------------------------------
    R = [-Inf,   -1, -Inf,   -1; % | Row 1 Column 1  | 1
           -1,   -1, -Inf,   -1; % | Row 1 Column 2  | 2
           -1,   -1, -Inf,   -1; % | Row 1 Column 3  | 3
           -1,   -1, -Inf,   -1; % | Row 1 Column 4  | 4
           -1,   -1, -Inf,   -1; % | Row 1 Column 5  | 5
           -1,   -1, -Inf,   -1; % | Row 1 Column 6  | 6
           -1,   -1, -Inf,   -1; % | Row 1 Column 7  | 7
           -1,   -1, -Inf,   -1; % | Row 1 Column 8  | 8
           -1,   -1, -Inf,   -1; % | Row 1 Column 9  | 9
           -1,   -1, -Inf,   -1; % | Row 1 Column 10 | 10
           -1,   -1, -Inf,   -1; % | Row 1 Column 11 | 11
           -1, -Inf, -Inf,   -1; % | Row 1 Column 12 | 12
         -Inf,   -1,   -1,   -1; % | Row 2 Column 1  | 13
           -1,   -1,   -1,   -1; % | Row 2 Column 2  | 14
           -1,   -1,   -1,   -1; % | Row 2 Column 3  | 15
           -1,   -1,   -1,   -1; % | Row 2 Column 4  | 16
           -1,   -1,   -1,   -1; % | Row 2 Column 5  | 17
           -1,   -1,   -1,   -1; % | Row 2 Column 6  | 18
           -1,   -1,   -1,   -1; % | Row 2 Column 7  | 19
           -1,   -1,   -1,   -1; % | Row 2 Column 8  | 20
           -1,   -1,   -1,   -1; % | Row 2 Column 9  | 21
           -1,   -1,   -1,   -1; % | Row 2 Column 10 | 22
           -1,   -1,   -1,   -1; % | Row 2 Column 11 | 23
           -1, -Inf,   -1,   -1; % | Row 2 Column 12 | 24
         -Inf,   -1,   -1,   -1; % | Row 3 Column 1  | 25
           -1,   -1,   -1, -100; % | Row 3 Column 2  | 26
           -1,   -1,   -1, -100; % | Row 3 Column 3  | 27
           -1,   -1,   -1, -100; % | Row 3 Column 4  | 28
           -1,   -1,   -1, -100; % | Row 3 Column 5  | 29
           -1,   -1,   -1, -100; % | Row 3 Column 6  | 30
           -1,   -1,   -1, -100; % | Row 3 Column 7  | 31
           -1,   -1,   -1, -100; % | Row 3 Column 8  | 32
           -1,   -1,   -1, -100; % | Row 3 Column 9  | 33
           -1,   -1,   -1, -100; % | Row 3 Column 10 | 34
           -1,   -1,   -1, -100; % | Row 3 Column 11 | 35
           -1, -Inf,   -1,   -1; % | Row 3 Column 12 | 36
         -Inf, -100,   -1, -Inf; % | Row 4 Column 1  | 37
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 2  | 38
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 3  | 39
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 4  | 40
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 5  | 41
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 6  | 42
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 7  | 43
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 8  | 44
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 9  | 45
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 10 | 46
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 11 | 47
         -Inf, -Inf, -Inf, -Inf];% | Row 4 Column 12 | 48
    %--------------------------------------------------------
    %T(s,a) State Transition Matrix for Cliff Walking -Inf Represents an Impossible Action
    %--------------------------------------------------------
    T = [-Inf,    2, -Inf,   13; % | Row 1 Column 1  | 1
            1,    3, -Inf,   14; % | Row 1 Column 2  | 2
            2,    4, -Inf,   15; % | Row 1 Column 3  | 3
            3,    5, -Inf,   16; % | Row 1 Column 4  | 4
            4,    6, -Inf,   17; % | Row 1 Column 5  | 5
            5,    7, -Inf,   18; % | Row 1 Column 6  | 6
            6,    8, -Inf,   19; % | Row 1 Column 7  | 7
            7,    9, -Inf,   20; % | Row 1 Column 8  | 8
            8,   10, -Inf,   21; % | Row 1 Column 9  | 9
            9,   11, -Inf,   22; % | Row 1 Column 10 | 10
           10,   12, -Inf,   23; % | Row 1 Column 11 | 11
           11, -Inf, -Inf,   24; % | Row 1 Column 12 | 12
         -Inf,   14,    1,   25; % | Row 2 Column 1  | 13
           13,   15,    2,   26; % | Row 2 Column 2  | 14
           14,   16,    3,   27; % | Row 2 Column 3  | 15
           15,   17,    4,   28; % | Row 2 Column 4  | 16
           16,   18,    5,   29; % | Row 2 Column 5  | 17
           17,   19,    6,   30; % | Row 2 Column 6  | 18
           18,   20,    7,   31; % | Row 2 Column 7  | 19
           19,   21,    8,   32; % | Row 2 Column 8  | 20
           20,   22,    9,   33; % | Row 2 Column 9  | 21
           21,   23,   10,   34; % | Row 2 Column 10 | 22
           22,   24,   11,   35; % | Row 2 Column 11 | 23
           23, -Inf,   12,   36; % | Row 2 Column 12 | 24
         -Inf,   26,   13,   37; % | Row 3 Column 1  | 25
           25,   27,   14,   38; % | Row 3 Column 2  | 26
           26,   28,   15,   39; % | Row 3 Column 3  | 27
           27,   29,   16,   40; % | Row 3 Column 4  | 28
           28,   30,   17,   41; % | Row 3 Column 5  | 29
           29,   31,   18,   42; % | Row 3 Column 6  | 30
           30,   32,   19,   43; % | Row 3 Column 7  | 31
           31,   33,   20,   44; % | Row 3 Column 8  | 32
           32,   34,   21,   45; % | Row 3 Column 9  | 33
           33,   35,   22,   46; % | Row 3 Column 10 | 34
           34,   36,   23,   47; % | Row 3 Column 11 | 35
           35, -Inf,   24,   48; % | Row 3 Column 12 | 36
         -Inf,   38,   25, -Inf; % | Row 4 Column 1  | 37
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 2  | 38
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 3  | 39
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 4  | 40
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 5  | 41
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 6  | 42
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 7  | 43
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 8  | 44
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 9  | 45
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 10 | 46
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 11 | 47
         -Inf, -Inf, -Inf, -Inf];% | Row 4 Column 12 | 48     
    %--------------------------------------------------------
    %G(s,a) Initializes Grid to 0 (Because it can be Arbitrary) -Inf Represents an Impossible Action
    %--------------------------------------------------------
    G = [-Inf,    0, -Inf,    0; % | Row 1 Column 1  | 1
            0,    0, -Inf,    0; % | Row 1 Column 2  | 2
            0,    0, -Inf,    0; % | Row 1 Column 3  | 3
            0,    0, -Inf,    0; % | Row 1 Column 4  | 4
            0,    0, -Inf,    0; % | Row 1 Column 5  | 5
            0,    0, -Inf,    0; % | Row 1 Column 6  | 6
            0,    0, -Inf,    0; % | Row 1 Column 7  | 7
            0,    0, -Inf,    0; % | Row 1 Column 8  | 8
            0,    0, -Inf,    0; % | Row 1 Column 9  | 9
            0,    0, -Inf,    0; % | Row 1 Column 10 | 10
            0,    0, -Inf,    0; % | Row 1 Column 11 | 11
            0, -Inf, -Inf,    0; % | Row 1 Column 12 | 12
         -Inf,    0,    0,    0; % | Row 2 Column 1  | 13
            0,    0,    0,    0; % | Row 2 Column 2  | 14
            0,    0,    0,    0; % | Row 2 Column 3  | 15
            0,    0,    0,    0; % | Row 2 Column 4  | 16
            0,    0,    0,    0; % | Row 2 Column 5  | 17
            0,    0,    0,    0; % | Row 2 Column 6  | 18
            0,    0,    0,    0; % | Row 2 Column 7  | 19
            0,    0,    0,    0; % | Row 2 Column 8  | 20
            0,    0,    0,    0; % | Row 2 Column 9  | 21
            0,    0,    0,    0; % | Row 2 Column 10 | 22
            0,    0,    0,    0; % | Row 2 Column 11 | 23
            0, -Inf,    0,    0; % | Row 2 Column 12 | 24
         -Inf,    0,    0,    0; % | Row 3 Column 1  | 25
            0,    0,    0,    0; % | Row 3 Column 2  | 26
            0,    0,    0,    0; % | Row 3 Column 3  | 27
            0,    0,    0,    0; % | Row 3 Column 4  | 28
            0,    0,    0,    0; % | Row 3 Column 5  | 29
            0,    0,    0,    0; % | Row 3 Column 6  | 30
            0,    0,    0,    0; % | Row 3 Column 7  | 31
            0,    0,    0,    0; % | Row 3 Column 8  | 32
            0,    0,    0,    0; % | Row 3 Column 9  | 33
            0,    0,    0,    0; % | Row 3 Column 10 | 34
            0,    0,    0,    0; % | Row 3 Column 11 | 35
            0, -Inf,    0,    0; % | Row 3 Column 12 | 36
         -Inf,    0,    0, -Inf; % | Row 4 Column 1  | 37
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 2  | 38
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 3  | 39
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 4  | 40
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 5  | 41
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 6  | 42
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 7  | 43
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 8  | 44
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 9  | 45
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 10 | 46
         -Inf, -Inf, -Inf, -Inf; % | Row 4 Column 11 | 47
         -Inf, -Inf, -Inf, -Inf];% | Row 4 Column 12 | 48     
    %--------------------------------------------------------
    Q = G; %Q(s,a) Initialized for Q-Learning
    S = 37; %The Current (Initial) State S
    A = 0; %Holds The Action to be Taken (Not Initialized)
    W = 0; %The Whole Reward (Used for calculating Reward per Episode)
    
    fprintf(1, 'Where the Discount Factor = %f and E-Greedy = %f\n', D, E);
    fprintf(1, 'Calculating Q-Learning for %i Episodes (This May Take a While)! Please Wait...\n', N);
    for n = 1:N %Episodes
        while 1 %Steps
            if S == 1
                A = a2_4(Q,S,E);
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * max(Q(T(S,A),:))) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
            elseif (S >= 2)  && (S <= 11)
                A = a1_2_4(Q,S,E);
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * max(Q(T(S,A),:))) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
            elseif S == 12
                A = a1_4(Q,S,E);
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * max(Q(T(S,A),:))) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
            elseif (S == 13) || (S == 25)
                A = a2_3_4(Q,S,E);
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * max(Q(T(S,A),:))) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
            elseif (S >= 14) && (S <= 23)
                A = a1_2_3_4(Q,S,E);
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * max(Q(T(S,A),:))) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
            elseif S == 24
                A = a1_3_4(Q,S,E);
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * max(Q(T(S,A),:))) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
            elseif (S >= 26) && (S <= 35)
                A = a1_2_3_f4(Q,S,E);
                W = W + R(S,A);
                if (A == 1) || (A == 2) || (A == 3)
                    Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * max(Q(T(S,A),:))) - Q(S,A)));
                else
                    Q(S,A) = R(S,A);
                end
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
            elseif S == 36
                A = a1_3_4(Q,S,A);
                W = W + R(S,A);
                if (A == 1) || (A == 3)
                    Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * max(Q(T(S,A),:))) - Q(S,A)));
                else
                    Q(S,A) = R(S,A);
                end
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
            elseif S == 37
                A = a2_3(Q,S,A);
                W = W + R(S,A);
                if A == 3
                    Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * max(Q(T(S,A),:))) - Q(S,A)));
                else
                    Q(S,A) = R(S,A);
                end
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
            else
                S = 37;
                break;
            end
        end
        if n == 1
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 5
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 10
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 20
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 30
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 40
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 50
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 100
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 200
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 300
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 400
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 500
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 1000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 5000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 10000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 50000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 100000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 500000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 1000000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif mod(n, 1000000) == 0
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        end
    end
    fprintf(1, 'Final Reward per Episode is:\t%f\n', W/N);
    fprintf(1, '\nWhere 0 is Terminal, 1 is Left, 2 is Right, 3 is Up, and 4 is Down (With Combinations)\n');
    fprintf(1, 'Row 4 Column 1 is our Start State, and Row 4 Column 12 is our Goal State\n');
    fprintf(1, 'Q-Learning Path After %i Episodes is:\n', N);
    disp(Grid_Path(Q));
    
    C = ones(48,4); %Visit Count for each State-Action Pair (Used for calculating Alpha)
    Q = G; %Q(s,a) Initialized for SARSA
    S = 37; %The Current (Initial) State S
    B = 0; %Next Action Needed for SARSA (Not Initialized)
    W = 0; %The Whole Reward (Used for calculating Reward per Episode)
    
    fprintf(1, 'Where the Discount Factor = %f and E-Greedy = %f\n', D, E);
    fprintf(1, 'Calculating SARSA for %i Episodes (This May Take a While)! Please Wait...\n', N);
    for n = 1:N %Episodes
        while 1 %Steps
            if S == 1
                if A == 2
                    B = a1_2_4(Q,T(S,A),E);
                else
                    B = a2_3_4(Q,T(S,A),E);
                end
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * Q(T(S,A),B)) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
                A = B;
            elseif (S >= 2) && (S <= 11)
                if A == 1
                    if S == 2
                        B = a2_4(Q,T(S,A),E);
                    else
                        B = a1_2_4(Q,T(S,A),E);
                    end
                elseif A == 2
                    if S == 11
                        B = a1_4(Q,T(S,A),E);
                    else
                        B = a1_2_4(Q,T(S,A),E);
                    end
                else
                    B = a1_2_3_4(Q,T(S,A),E);
                end
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * Q(T(S,A),B)) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
                A = B;
            elseif S == 12
                if A == 1
                    B = a1_2_4(Q,T(S,A),E);
                else
                    B = a1_3_4(Q,T(S,A),E);
                end
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * Q(T(S,A),B)) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
                A = B;
            elseif (S == 13) || (S == 25)
                if A == 2
                    if S == 13
                        B = a1_2_3_4(Q,T(S,A),E);
                    else
                        B = a1_2_3_f4(Q,T(S,A),E);
                    end
                elseif A == 3
                    if S == 13
                        B = a2_4(Q,T(S,A),E);
                    else
                        B = a2_3_4(Q,T(S,A),E);
                    end
                else
                    if S == 13
                        B = a2_3_4(Q,T(S,A),E);
                    else
                        B = a2_3(Q,T(S,A),E);
                    end
                end
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * Q(T(S,A),B)) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
                A = B;
            elseif (S >= 14) && (S <= 23)
                if A == 1
                    if S == 14
                        B = a2_3_4(Q,T(S,A),E);
                    else
                        B = a1_2_3_4(Q,T(S,A),E);
                    end
                elseif A == 2
                    if S == 23
                        B = a1_3_4(Q,T(S,A),E);
                    else
                        B = a1_2_3_4(Q,T(S,A),E);
                    end
                elseif A == 3
                    B = a1_2_4(Q,T(S,A),E);
                else
                    B = a1_2_3_f4(Q,T(S,A),E);
                end
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * Q(T(S,A),B)) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
                A = B;
            elseif S == 24
                if A == 1
                    B = a1_2_3_4(Q,T(S,A),E);
                elseif A == 3
                    B = a1_4(Q,T(S,A),E);
                else
                    B = a1_3_4(Q,T(S,A),E);
                end
                W = W + R(S,A);
                Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * Q(T(S,A),B)) - Q(S,A)));
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
                A = B;
            elseif (S >= 26) && (S <= 35)
                if A == 1
                    if S == 26
                        B = a2_3_4(Q,T(S,A),E);
                    else
                        B = a1_2_3_f4(Q,T(S,A),E);
                    end
                elseif A == 2
                    if S == 35
                        B = a1_3_4(Q,T(S,A),E);
                    else
                        B = a1_2_3_f4(Q,T(S,A),E);
                    end
                elseif A == 3
                    B = a1_2_3_4(Q,T(S,A),E);
                end
                W = W + R(S,A);
                if (A == 1) || (A == 2) || (A == 3)
                    Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * Q(T(S,A),B)) - Q(S,A)));
                else
                    Q(S,A) = R(S,A);
                end
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
                A = B;
            elseif S == 36
                if A == 1
                    B = a1_2_3_f4(Q,T(S,A),E);
                elseif A == 3
                    B = a1_3_4(Q,T(S,A),E);
                end
                W = W + R(S,A);
                if (A == 1) || (A == 3)
                    Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * Q(T(S,A),B)) - Q(S,A)));
                else
                    Q(S,A) = R(S,A);
                end
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
                A = B;
            elseif S == 37
                A = a2_3(Q,S,E);
                B = a2_3_4(Q,T(S,A),E);
                W = W + R(S,A);
                if A == 3
                    Q(S,A) = Q(S,A) + ((Alpha(P,C(S))) * (R(S,A) + (D * Q(T(S,A),B)) - Q(S,A)));
                else
                    Q(S,A) = R(S,A);
                end
                C(S,A) = C(S,A) + 1;
                S = T(S,A);
                A = B;
            else
                S = 37;
                break;
            end
        end
        if n == 1
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 5
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 10
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 20
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 30
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 40
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 50
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 100
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 200
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 300
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 400
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 500
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 1000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 5000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 10000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 50000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 100000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 500000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif n == 1000000
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        elseif mod(n, 1000000) == 0
            fprintf(1, '%i Episodes Completed so Far! Reward per Episode:\t%f\n', n, W/n);
        end
    end
    fprintf(1, 'Final Reward per Episode is:\t%f\n', W/N);
    fprintf(1, '\nWhere 0 is Terminal, 1 is Left, 2 is Right, 3 is Up, and 4 is Down (With Combinations)\n');
    fprintf(1, 'Row 4 Column 1 is our Start State, and Row 4 Column 12 is our Goal State\n');
    fprintf(1, 'SARSA Path After %i Episodes is:\n', N);
    disp(Grid_Path(Q));
end

function A = a2_3(Q,S,E)
    if Epsilon(E) == 0
        A = 3;
    else
        A = Dice([2,3]);
    end
end

function A = a1_2_3_f4(Q,S,E)
    if Epsilon(E) == 0
        if (Q(S,1) == Q(S,2) == Q(S,3)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,2,3]);
        elseif (Q(S,1) == Q(S,2)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,2]);
        elseif (Q(S,1) == Q(S,3)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,3]);
        elseif (Q(S,2) == Q(S,3)) && (Q(S,2) == max(Q(S,:)))
            A = Dice([2,3]);
        elseif Q(S,1) == max(Q(S,:))
            A = 1;
        elseif Q(S,2) == max(Q(S,:))
            A = 2;
        else
            A = 3;
        end
    else
        A = Dice([1,2,3,4]);
    end
end

function A = a1_3_4(Q,S,E)
    if Epsilon(E) == 0
        if (Q(S,1) == Q(S,3) == Q(S,4)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,3,4]);
        elseif (Q(S,1) == Q(S,3)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,3]);
        elseif (Q(S,1) == Q(S,4)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,4]);
        elseif (Q(S,3) == Q(S,4)) && (Q(S,3) == max(Q(S,:)))
            A = Dice([3,4]);
        elseif Q(S,1) == max(Q(S,:))
            A = 1;
        elseif Q(S,3) == max(Q(S,:))
            A = 3;
        else
            A = 4;
        end
    else
        A = Dice([1,3,4]);
    end
end

function A = a1_2_3_4(Q,S,E)
    if Epsilon(E) == 0
        if (Q(S,1) == Q(S,2) == Q(S,3) == Q(S,4)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,2,3,4]);
        elseif (Q(S,1) == Q(S,3) == Q(S,4)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,3,4]);
        elseif (Q(S,1) == Q(S,2) == Q(S,4)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,2,4]);
        elseif (Q(S,1) == Q(S,2) == Q(S,3)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,2,3]);
        elseif (Q(S,2) == Q(S,3) == Q(S,4)) && (Q(S,2) == max(Q(S,:)))
            A = Dice([2,3,4]);
        elseif (Q(S,1) == Q(S,2)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,2]);
        elseif (Q(S,1) == Q(S,3)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,3]);
        elseif (Q(S,1) == Q(S,4)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,4]);
        elseif (Q(S,2) == Q(S,3)) && (Q(S,2) == max(Q(S,:)))
            A = Dice([2,3]);
        elseif (Q(S,2) == Q(S,4)) && (Q(S,2) == max(Q(S,:)))
            A = Dice([2,4]);
        elseif (Q(S,3) == Q(S,4)) && (Q(S,3) == max(Q(S,:)))
            A = Dice([3,4]);
        elseif Q(S,1) == max(Q(S,:))
            A = 1;
        elseif Q(S,2) == max(Q(S,:))
            A = 2;
        elseif Q(S,3) == max(Q(S,:))
            A = 3;
        else
            A = 4;
        end
    else
        A = Dice([1,2,3,4]);
    end
end

function A = a2_3_4(Q,S,E)
    if Epsilon(E) == 0
        if (Q(S,2) == Q(S,3) == Q(S,4)) && (Q(S,2) == max(Q(S,:)))
            A = Dice([2,3,4]);
        elseif (Q(S,2) == Q(S,3)) && (Q(S,2) == max(Q(S,:)))
            A = Dice([2,3]);
        elseif (Q(S,2) == Q(S,4)) && (Q(S,2) == max(Q(S,:)))
            A = Dice([2,4]);
        elseif (Q(S,3) == Q(S,4)) && (Q(S,3) == max(Q(S,:)))
            A = Dice([3,4]);
        elseif Q(S,2) == max(Q(S,:))
            A = 2;
        elseif Q(S,3) == max(Q(S,:))
            A = 3;
        else
            A = 4;
        end
    else
        A = Dice([2,3,4]);
    end
end

function A = a1_4(Q,S,E)
    if Epsilon(E) == 0
        if Q(S,1) == Q(S,4)
            A = Dice([1,4]);
        elseif Q(S,1) > Q(S,4)
            A = 1;
        else
            A = 4;
        end
    else
        A = Dice([1,4]); 
    end
end

function A = a1_2_4(Q,S,E)
    if Epsilon(E) == 0
        if (Q(S,1) == Q(S,2) == Q(S,4)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,2,4]);
        elseif (Q(S,1) == Q(S,2)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,2]);
        elseif (Q(S,1) == Q(S,4)) && (Q(S,1) == max(Q(S,:)))
            A = Dice([1,4]);
        elseif (Q(S,2) == Q(S,4)) && (Q(S,2) == max(Q(S,:)))
            A = Dice([2,4]);
        elseif Q(S,1) == max(Q(S,:))
            A = 1;
        elseif Q(S,2) == max(Q(S,:))
            A = 2;
        else
            A = 4;
        end
    else
        A = Dice([1,2,4]);
    end
end

function A = a2_4(Q,S,E)
    if Epsilon(E) == 0
        if Q(S,2) == Q(S,4)
            A = Dice([2,4]);
        elseif Q(S,2) > Q(S,4)
            A = 2;
        else
            A = 4;
        end
    else
        A = Dice([2,4]);
    end
end

%Returns a constant if 0 <= Y <= 1 and 1/Z otherwise 
function X = Alpha(Y,Z)
    if (0 <= Y) && (Y <= 1)
        X = Y;
    else
        X = 1/Z
    end
end

%Epsilon is used for E-Greedy Exploration such that:
%Y*100 percent of the time X = 1 and 1-Y percent of the time X = 0
function X = Epsilon(Y)
    if rand < Y
        X = 1;
    else
        X = 0;
    end
end
    
%Functions as a numel(Y)-Sided Dice such that numel(Y) can be either 2, 3, or 4
%The elements in Y will represent the values on each side of the dice
function X = Dice(Y)
    Z = rand;
    switch numel(Y)
        case 2
            if Z < .5
                X = Y(1);
            else
                X = Y(2);
            end
        case 3
            if Z < .3333
                X = Y(1);
            elseif (Z >= .3333) && (Z < .6666)
                X = Y(2);
            else
                X = Y(3);
            end
        case 4
            if Z < .25
                X = Y(1);
            elseif (Z >= .25) && (Z < .5)
                X = Y(2);
            elseif (Z >= .5) && (Z < .75)
                X = Y(3);
            else
                X = Y(4);
            end
    end
end
    
%Generates a Gridworld with a Path based on the Q(s,a) Cliff Walking Matrix Provided
%Here 0 is Terminal, 1 is Left, 2 is Right, 3 is Up, and 4 is Down
function G = Grid_Path(Q)
    G = zeros(4,12);
    for S = 1:48
        Y = ceil(S/12);
        X = mod(S, 12);
        if X == 0
            X = 12;
        end
        if (Q(S,1) == Q(S,2) == Q(S,3) == Q(S,4)) && (Q(S,1) ~= -Inf) && (Q(S,1) == max(Q(S,:)))
            G(Y,X) = 1234;
        elseif (Q(S,1) == Q(S,3) == Q(S,4)) && (Q(S,1) ~= -Inf) && (Q(S,1) == max(Q(S,:)))
            G(Y,X) = 134;
        elseif (Q(S,1) == Q(S,2) == Q(S,4)) && (Q(S,1) ~= -Inf) && (Q(S,1) == max(Q(S,:)))
            G(Y,X) = 124;
        elseif (Q(S,1) == Q(S,2) == Q(S,3)) && (Q(S,1) ~= -Inf) && (Q(S,1) == max(Q(S,:)))
            G(Y,X) = 123;
        elseif (Q(S,2) == Q(S,3) == Q(S,4)) && (Q(S,2) ~= -Inf) && (Q(S,2) == max(Q(S,:)))
            G(Y,X) = 234;
        elseif (Q(S,1) == Q(S,2)) && (Q(S,1) ~= -Inf) && (Q(S,1) == max(Q(S,:)))
            G(Y,X) = 12;
        elseif (Q(S,1) == Q(S,3)) && (Q(S,1) ~= -Inf) && (Q(S,1) == max(Q(S,:)))
            G(Y,X) = 13;
        elseif (Q(S,1) == Q(S,4)) && (Q(S,1) ~= -Inf) && (Q(S,1) == max(Q(S,:)))
            G(Y,X) = 14;
        elseif (Q(S,2) == Q(S,3)) && (Q(S,2) ~= -Inf) && (Q(S,2) == max(Q(S,:)))
            G(Y,X) = 23;
        elseif (Q(S,2) == Q(S,4)) && (Q(S,2) ~= -Inf) && (Q(S,2) == max(Q(S,:)))
            G(Y,X) = 24;
        elseif (Q(S,3) == Q(S,4)) && (Q(S,3) ~= -Inf) && (Q(S,3) == max(Q(S,:)))
            G(Y,X) = 34;
        elseif (Q(S,1) > Q(S,2)) && (Q(S,1) > Q(S,3)) && (Q(S,1) > Q(S,4))
            G(Y,X) = 1;
        elseif (Q(S,2) > Q(S,1)) && (Q(S,2) > Q(S,3)) && (Q(S,2) > Q(S,4))
            G(Y,X) = 2;
        elseif (Q(S,3) > Q(S,1)) && (Q(S,3) > Q(S,2)) && (Q(S,3) > Q(S,4))
            G(Y,X) = 3;
        elseif (Q(S,4) > Q(S,1)) && (Q(S,4) > Q(S,2)) && (Q(S,4) > Q(S,3))
            G(Y,X) = 4;
        end
    end
end
