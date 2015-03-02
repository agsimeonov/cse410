%Where N is the Time Horizon defaults to 20
%Where g is the Vertical Acceleration \ddot{x} defaults to 0 (Place Gravity Here)
function lunar_lander(N, g)
    if nargin < 2, g = 0; end
    if nargin < 1, N = 20; end

    v = 0; %The Vertical Velocity at dt = 1 \dot{x}
    if g == 0 %No Gravity
        Q = eye(2); %Given State Cost
        Q_f = 100 * eye(2); %Final State Cost
        A = [1,1;0,.9];
        B = [0;1];
    else %Affine Solution for Gravity
        Q = eye(2); %Given State Cost
        Q_f = 100 * eye(2); %Final State Cost
        A = [1,1;0,.9];
        B = [0;1];
    end
    R = 10; %Input Cost
    
    K = zeros(N,2);
    P = Q_f;
    K(N,:) = -1* inv(R + (B' * P * B)) * B' * P * A;
    t = N-1;
    while t ~= 0
        P = Q + (A' * P * A) - ((A' * P * B) * inv((R + (B' * P * B))) * (B' * P * A));
        K(t,:) = -1 * ((R + (B' * P * B))^-1) * B' * P * A;
        t = t-1;
    end

    X = zeros(2,N); %Height of Lander at each Timestep @ 1 Velocity @ 2
    U = zeros(1,N); %Downward Thrust of Lander at each Timestep
    fprintf('Time\tHeight\t\tThrust\n');
    for t = 1:N
        if t == 1
            X(1,t) = 100 + v;
            U(1,t) = K(t,:) * [0;100];
            X(2,t) = (.9 * v) + U(t) - g;
        else
            X(1,t) = X(1,t-1) + X(2,t-1);
            U(t) = K(t,:) * X(:,t-1);
            X(2,t) = (.9 *  X(2,t-1)) + U(t) - g;
        end
        fprintf('%i\t\t%f\t%f\n', t, X(1,t), U(t));
    end
    m = plot(X(1,:));
    hold all;
    n = plot(U);
    title('Lunar Lander');
    ylabel('Height/Thrust');
    xlabel('Timesteps');
end
