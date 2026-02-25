%% ES2/ES3/ES4
close all
clear all

a=1;
b=1;
umin=-1;
umax=1;
NB=8;
h=log(2.5);
t_end=1000;
init_point=-0.78;
dataratelimit(a,b,umin,umax,NB,h,init_point,t_end)