close all;
clear variables;
clc;

load Torque_map.mat
load Torque_accel.mat

fig = 0; % Set to 0 for no graphs

%% Electric GoKart Parameters
m_kart = 130; % mass (kg) of the kart
m_driver = 70; % mass (kg) of the driver
M = m_kart + m_driver; % Total mass (kg) of the kart + driver
g = 9.81; 
h = 0.25; % CG height ??????????????
lf = 0.7; lr = 1.042-lf; L = lf+lr; % CG distance from front and rear tracks, wheelbase
W = M*g; 
wL = 1.035/2; wR = 1.035/2; % (half of) front and rear tracks
Jp = 42; % inertia about vertical axis ?????????
Jw = 1.04; Rw =  0.1305; % wheels' rot inertia and radius ?????????
steer_ratio = 2; % steering ratio (from steering wheel to front wheels)
gear_ratio = 3.2;
Ts = 10e-3;

% Tyre parameters (using simplified MF: f=D*sin(C*atan(B*x)))
BMFx = 16.28; CMFx = 1.697;
% Dx = 1.06; % Nominal value
DMFx = 0.9308; 
BMFy = 16.25; CMFy = 1.669;
% Dy = 0.92; % Nominal value
DMFy = 1.508; % Set in Carmaker
B = (BMFx+BMFy)/2; C = (CMFx+CMFy)/2; D = (DMFx+DMFy)/2; % Taking avg values from long and lat B, C and D above

clear BMFy BMFx CMFy CMFx DMFy DMFx;

fFz = M*9.81*lr/(lf+lr);
fRz = M*9.81*lf/(lf+lr);

Cf = B*C*D*fFz;
Cr = B*C*D*fRz;

%% Plot tyre characteristics

if fig==1
    alpha_deg = linspace(-20, 20, 1000);
    alpha_rad = alpha_deg*pi/180;
    slip_ratio = linspace(-1, 1, 1000);
    y1 = D*sin(C*atan(B*alpha_rad));
    y2 = D*sin(C*atan(B*slip_ratio));

    figure(1)
    subplot(211)
    plot(alpha_deg, y1, 'LineWidth', 2, 'Color', 'r')
    xlabel('Slip angle \alpha (deg)')
    ylabel('Normalized lateral tyre force')
    title('Lateral dynamics of the tyre')
    grid on;
    subplot(212)
    plot(slip_ratio, y2, 'LineWidth', 2)
    xlabel('Slip ratio')
    ylabel('Normalized longitudinal tyre force')
    title('Longitudinal dynamics of the tyre')
    grid on;
end

% Geometric calcs
lFL = sqrt(lf^2+wL^2); gammaFL = atan2(wL,lf);
lFR = sqrt(lf^2+wR^2); gammaFR = atan2(wR,lf);
lRL = sqrt(lr^2+wL^2); gammaRL = atan2(wL,lr);
lRR = sqrt(lr^2+wR^2); gammaRR = atan2(wR,lr);

lr_tilde = M*h*lr/((lf+lr)*(wL+wR));
lf_tilde = M*h*lf/((lf+lr)*(wL+wR));
wR_tilde = M*h*wR/((lf+lr)*(wL+wR));
wL_tilde = M*h*wL/((lf+lr)*(wL+wR));


% Static loads
fFL0 = M*g*lr*wR/((lf+lr)*(wL+wR));
fFR0 = M*g*lr*wL/((lf+lr)*(wL+wR));
fRL0 = M*g*lf*wR/((lf+lr)*(wL+wR));
fRR0 = M*g*lf*wL/((lf+lr)*(wL+wR));


%==========================================================================

% Initial Conditions
% z10 = V initial set within the model
z20 = 0;        % beta
z30 = 0;% pi/2;     % psi
z40 = 0;        % psidot
z50 = 0;        % x
z60 = 0;        % y

%% For NL Bicycle Model
v0 = 0;
r0 = 0;
psi0 = 0;
x0 = 0;
y0 = 0;


%==========================================================================

% Variables and Initial Conditions Matrices
par = [M g h lf lr W Jw Rw B C D wL wR Jp lFL lFR lRL lRR gammaFL gammaFR gammaRL gammaRR fFL0 fFR0 fRL0 fRR0 lr_tilde lf_tilde wR_tilde wL_tilde steer_ratio gear_ratio];
incond = [z20 z30 z40 z50 z60];