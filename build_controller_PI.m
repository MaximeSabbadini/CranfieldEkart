function C = build_controller_PI(sys, Target_BW, Om_pi, fig)

om_rad = logspace(-4, 4, 1001);

Om_bw = Target_BW;

Kp = bode(sys, Om_bw);

Kp = 1/Kp;

Wpi = tf([1 Om_pi], [1 0]);

C = Wpi*Kp;

L = sys*C;
T = feedback(L, 1);
S = 1-T;
CS = feedback(C, sys);
% SP = feedback(P, C);

if fig==1
    figure(1)
    margin(sys, om_rad);
    grid on;
    hold on;
    margin(C*sys, om_rad);
    legend('Uncontrolled system', 'PI Controlled System')

    figure(2)
    % subplot(121)
    % margin(C*sys)

    bodemag(S, 'k-', T, 'b-', CS, 'k:', om_rad)
    legend('S', 'T', 'CS', 'Location', 'southwest')
    ylim([-80 40])
    grid on


    % subplot(224)
    % step(T, 'b-', 1)
end

end