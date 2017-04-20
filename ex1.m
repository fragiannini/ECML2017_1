% This script makes use of the MATLAB function 'quadprog' that is specific
% for quadratic programming problems. 


% Here, we assume fixed the supervised training sets L1, L2 and L3 as well 
% as the unsupervised training set U (common to all predicates) to evaluate
% logical constraints.

% We also assume as fixed two logical constraints F1 and F2. To get
% quadratic programming, we already deal with their equivalent linear forms.



%% INITIALIZATION

% In the paper we have L1={(0.1,0.5,-1),(0.4,0.4,-1),(0.3,0.8,1),
% (0.9,0.7,1)}, L2={(0.1,0.3,-1),(0.6,0.4,-1),(0.2,0.8,1),(0.7,0.6,1)}, L3=
% {(0.4,0.2,-1),(0.9,0.3,-1),(0.2,0.6,1),(0.5,0.7,1)} and U={(0.1,0.5),
% (0.3,0.7),(0.5,0.4),(0.8,0.3),(0.9,0.2),(1,0.5)}.



t=3;        % number of tasks
v=2;        % number of logical constraints considered
ns=0;       % number of pointwise constraints
lb=zeros(); 
ub=zeros(); 


L(:,:,1)=L1;
L(:,:,2)=L2;
L(:,:,3)=L3;


for i=1:t
    if v~=0
        u=size(U,2);               
        S(:,:,i)=[L(1:2,:,i),U];   % a tensor whose components are the sets for coherence constraints
    else
        u=0;
        S(:,:,i)=L(1:2,:,i);
    end
    l(i)=size(L(:,:,i),2);
    ns=ns+l(i);
    s(i)=size(S(:,:,i),2);
end
    
 
c1=2.5;   % degree of satisfaction for pointwise slacks
c2=2.5;  % degree of satisfaction for logical slacks


for i=1:3*t
    lb(i,1)=-100000;
    ub(i,1)=100000;
end
for i=3*t+1:3*t+ns+v
    lb(i,1)=0;
    ub(i,1)=100000;
end 


H=zeros(3*t+ns+v,3*t+ns+v);
for i=1:3*t
    if mod(i,3)~=0
        H(i,i)=1;
    end
end


f=zeros(3*t+ns+v,1);
for i=3*t+1:3*t+ns
    f(i)=c1;
end
for i=3*t+ns+1:3*t+ns+v
    f(i)=c2;
end


A=zeros();
b=zeros();
count=0; % row counter for constraints



%% POINTWISE CONSTRAINTS



for i=1:t
    k=3*(i-1)+1;  
    for j=1:l(i)
        A(j+count,k)=-2*L(1,j,i)*L(3,j,i);
        A(j+count,k+1)=-2*L(2,j,i)*L(3,j,i);
        A(j+count,k+2)=-2*L(3,j,i);
        A(j+count,count+j+3*t)=-2;  
        b(j+count,1)=-1-L(3,j,i);
    end
    count=count+j;
end



%%  CONCISTENCY CONSTRAINTS

% These constraints are taken into account whenever we have logical
% constraints to guarantee that predicates functions are [0,1]-valued.



if v>0
    for i=1:t
        k=(i-1)*3+1;
        for j=1:s(i)
            A(j+count,k)=S(1,j,i);
            A(j+count,k+1)=S(2,j,i);
            A(j+count,k+2)=1;
            b(j+count,1)=1;
            A(j+count+s,k)=-S(1,j,i);        
            A(j+count+s,k+1)=-S(2,j,i);        
            A(j+count+s,k+2)=-1;        
            b(j+count+s,1)=0;
        end
        count=count+2*s;
    end
end



%%   LOGICAL CONSTRAINTS

% Taking into account the same formulas of the paper, F1 and F2 can be
% re-written as conjunctions of linear functions of the form
% p1(x_i)-p2(x_i) and p2(x_i)-p3(x_i) for x_i in U.



if v>0
    for i=1:2
        k=3*(i-1)+1;
        for j=1:u
            A(j+count,k)=U(1,j);
            A(j+count,k+1)=U(2,j);
            A(j+count,k+2)=1;
            A(j+count,k+3)=-U(1,j);
            A(j+count,k+4)=-U(2,j);
            A(j+count,k+5)=-1;
            A(j+count,3*t+ns+i)=-1; 
            b(j+count,1)=0;
        end
        count=count+u;
    end
end



%%   OPTIMAL SOLUTION



x = quadprog(H,f,A,b,[],[],lb,ub)
  