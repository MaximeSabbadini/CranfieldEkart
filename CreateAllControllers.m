close all;
clc;

kart_parameters2

load LinearizationModelsV1.mat 
load LinearizationModelsV2.mat
load LinearizationModelsV3.mat
load IMU_filt_100Hz.mat

fig = 0;

%% Controllers for 20kph
Controller1 = build_controller_PI(Lin_20kph_5deg, 5, .1*5, 0);
Controller2 = build_controller_PI(Lin_20kph_10deg, 5, .1*5, 0);
Controller3 = build_controller_PI(Lin_20kph_15deg, 5, .1*5, 0);
Controller4 = build_controller_PI(Lin_20kph_20deg, 5, .1*5, 0);
Controller5 = build_controller_PI(Lin_20kph_25deg, 5, .1*5, 0);
Controller6 = build_controller_PI(Lin_20kph_30deg, 5, .1*5, 0);
Controller7 = build_controller_PI(Lin_20kph_35deg, 5, .1*5, 0);
Controller8 = build_controller_PI(Lin_20kph_40deg, 5, .1*5, 0);

%% Controllers for 30kph

Controller9 = build_controller_PI(Lin_30kph_5deg, 5, .1*5, 0);
Controller10 = build_controller_PI(Lin_30kph_10deg, 5, .1*5, 0);
Controller11 = build_controller_PI(Lin_30kph_15deg, 5, .1*5, 0);
Controller12 = build_controller_PI(Lin_30kph_20deg, 5, .1*5, 0);
Controller13 = build_controller_PI(Lin_30kph_25deg, 5, .1*5, 0);
Controller14 = build_controller_PI(Lin_30kph_30deg, 5, .1*5, 0);
Controller15 = build_controller_PI(Lin_30kph_35deg, 5, .1*5, 0);
Controller16 = build_controller_PI(Lin_30kph_40deg, 5, .1*5, 0);
%% Controllers for 40kph

Controller17 = build_controller_PI(Lin_40kph_5deg, 5, .1*5, 0);
Controller18 = build_controller_PI(Lin_40kph_10deg, 5, .1*5, 0);
Controller19 = build_controller_PI(Lin_40kph_15deg, 5, .1*5, 0);
Controller20 = build_controller_PI(Lin_40kph_20deg, 5, .1*5, 0);
Controller21 = build_controller_PI(Lin_40kph_25deg, 5, .1*5, 0);
Controller22 = build_controller_PI(Lin_40kph_30deg, 5, .1*5, 0);
Controller23 = build_controller_PI(Lin_40kph_35deg, 5, .1*5, 0);
Controller24 = build_controller_PI(Lin_40kph_40deg, 5, .1*5, 0);


%% Gains 
P_20 = [0 0 Controller1.Numerator{1}(1) Controller2.Numerator{1}(1) Controller3.Numerator{1}(1) ...
    Controller4.Numerator{1}(1) Controller5.Numerator{1}(1) Controller6.Numerator{1}(1) ...
    Controller7.Numerator{1}(1) Controller8.Numerator{1}(1)];

I_20 = [0 0 Controller1.Numerator{1}(2) Controller2.Numerator{1}(2) Controller3.Numerator{1}(2) ...
    Controller4.Numerator{1}(2) Controller5.Numerator{1}(2) Controller6.Numerator{1}(2) ...
    Controller7.Numerator{1}(2) Controller8.Numerator{1}(2)];

P_30 = [0 0 Controller9.Numerator{1}(1) Controller10.Numerator{1}(1) Controller11.Numerator{1}(1) ...
    Controller12.Numerator{1}(1) Controller13.Numerator{1}(1) Controller14.Numerator{1}(1) ...
    Controller15.Numerator{1}(1) Controller16.Numerator{1}(1)];

I_30 = [0 0 Controller9.Numerator{1}(2) Controller10.Numerator{1}(2) Controller11.Numerator{1}(2) ...
    Controller12.Numerator{1}(2) Controller13.Numerator{1}(2) Controller14.Numerator{1}(2) ...
    Controller15.Numerator{1}(2) Controller16.Numerator{1}(2)];

P_40 = [0 0 Controller17.Numerator{1}(1) Controller18.Numerator{1}(1) Controller19.Numerator{1}(1) ...
    Controller20.Numerator{1}(1) Controller21.Numerator{1}(1) Controller22.Numerator{1}(1) ...
    Controller23.Numerator{1}(1) Controller24.Numerator{1}(1)];

I_40 = [0 0 Controller17.Numerator{1}(2) Controller18.Numerator{1}(2) Controller19.Numerator{1}(2) ...
    Controller20.Numerator{1}(2) Controller21.Numerator{1}(2) Controller22.Numerator{1}(2) ...
    Controller23.Numerator{1}(2) Controller24.Numerator{1}(2)];

angles = [0 4.9 5 10 15 20 25 30 35 40];
speeds = [0 19.9 20 30 40];

table_p = [zeros(1, 10);
           zeros(1,10);
           P_20;
           P_30;
           P_40];

table_i = [zeros(1,10);
           zeros(1,10);
           I_20;
           I_30;
           I_40];
if(fig==1)
    figure(1)
    subplot(211)
    stairs(angles, P_20, 'LineWidth', 2)
    hold on;
    stairs(angles, P_30, 'LineWidth', 2, 'LineStyle', '--')
    stairs(angles, P_40, 'LineWidth', 2, 'LineStyle', '-.')
    legend('v_x=20kph', 'v_x=30kph', 'v_x=40kph')
    xlabel('Steering wheel angle (deg)')
    ylabel('Proportional gain of the Controller')
    title('Evolution of the P gain')
    grid on;
    subplot(212)
    stairs(angles, I_20, 'LineWidth', 2)
    hold on;
    stairs(angles, I_30, 'LineWidth', 2, 'LineStyle', '--')
    stairs(angles, I_40, 'LineWidth', 2, 'LineStyle', '-.')
    legend('v_x=20kph', 'v_x=30kph', 'v_x=40kph')
    ylabel('Integral gain of the Controller')
    xlabel('Steering wheel angle (deg)')
    title('Evolution of the I gain')
    grid on;
    
    figure(2)
    subplot(211)
    title('Evolution of the P gain for for v_x=30kph')
    stairs(angles, P_30, 'LineWidth', 2)
    xlabel('Steering wheel angle (deg)')
    ylabel('Proportional gain of the Controller')
    grid on;
    subplot(212)
    title('Evolution of the I gain for for v_x=30kph')
    stairs(angles, I_30, 'LineWidth', 2)
    ylabel('Integral gain of the Controller')
    xlabel('Steering wheel angle (deg)')
    grid on;
    
    figure(3)
    pzmap(Lin_30kph_5deg)
    hold on;
    pzmap(Lin_30kph_20deg)
    pzmap(Lin_30kph_40deg)
    legend('5deg', '20deg', '40deg')
    
    figure(4)
    bode(Lin_20kph_5deg, logspace(-4, 4, 1001))
    hold on;
    bode(Lin_20kph_10deg, logspace(-4, 4, 1001))
    bode(Lin_20kph_15deg, logspace(-4, 4, 1001))
    bode(Lin_20kph_20deg, logspace(-4, 4, 1001))
    bode(Lin_20kph_25deg, logspace(-4, 4, 1001))
    bode(Lin_20kph_30deg, logspace(-4, 4, 1001))
    bode(Lin_20kph_35deg, logspace(-4, 4, 1001))
    bode(Lin_20kph_40deg, logspace(-4, 4, 1001))
    legend('5 degrees', '10 degrees', '15 degrees', '20 degrees', '25 degrees', '30 degrees', '35 degrees', '40 degrees')


    figure(5)
    plot([20, 30, 40], [Controller1.Numerator{1}(1), Controller9.Numerator{1}(1), Controller17.Numerator{1}(1)] )
end