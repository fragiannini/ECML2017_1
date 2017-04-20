%% Print the optimal p1, p2 and p3 of the multi-task problem.



DATA1=L1;
DATA2=L2;
DATA3=L3;


X=0:.001:1;


X1=-(x(1)*X+x(3)-0.5)/x(2);
X2=-(x(4)*X+x(6)-0.5)/x(5);
X3=-(x(7)*X+x(9)-0.5)/x(8);


scatter(DATA1(1,1:2),DATA1(2,1:2),'r','o')
hold on
scatter(DATA1(1,3:4),DATA1(2,3:4),'r','filled')
hold on
scatter(DATA2(1,1:2),DATA2(2,1:2),'b','d')
hold on
scatter(DATA2(1,3:4),DATA2(2,3:4),'b','d','filled')
hold on
scatter(DATA3(1,1:2),DATA3(2,1:2),'k','s')
hold on
scatter(DATA3(1,3:4),DATA3(2,3:4),'k','s','filled')
hold on
plot(X,X1,'r:', X,X2,'b--',X,X3,'k-')
axis([0 1 0 1])
%legend('F_1-class','T_1-class','F_2-class','T_2-class','F_3-class','T_3-class','   p_1','   p_2','   p_3')

