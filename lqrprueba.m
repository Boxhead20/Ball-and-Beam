open matlab.mat
sys=ss(ans.arx941)
A = sys.A
B = sys.B
C = sys.C
D = sys.D
Sistema= ss(A,B,C,D); 
Cont = [B A*B A^2*B A^3*B A^4*B A^5*B A^6*B A^7*B A^8*B];
Rangocont = range(Cont)
Q = eye(9);
R =0.001;
[K,S,e] = lqr(A,B,Q,R)

B1 = [A-B*K]
syscontrol = ss(B1,B,C,D);
LQR = tf(syscontrol);
subplot(2,2,1);
step(Sistema);
subplot(2,2,2);
step(LQR);