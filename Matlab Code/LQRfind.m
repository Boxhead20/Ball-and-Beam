%create thet data generated from the function ident in matlab and save it like matla.mat
open matlab.mat
sys=ss(ans.arx941)%change the name acrding to the function founded and named
%declare the space function 
A = sys.A
B = sys.B
C = sys.C
D = sys.D
Sistema= ss(A,B,C,D); 
Cont = [B A*B A^2*B A^3*B A^4*B A^5*B A^6*B A^7*B A^8*B];%controlability matrix
Rangocont = range(Cont)
Q = eye(9);
R =0.001;%this variable is depending on the function
[K,S,e] = lqr(A,B,Q,R)%calculates the  lqr values 

B1 = [A-B*K]
%show both diferences on graph
syscontrol = ss(B1,B,C,D);
LQR = tf(syscontrol);
subplot(2,2,1);
step(Sistema);
subplot(2,2,2);
step(LQR);
