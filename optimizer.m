clc
clear 
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=input('Please enter the number of rows of matrix S:\n');
n=input('Please enter the number of columns of matrix S:\n');
d=input('Please enter the number of columns of matrix U:\n');
filename = 'Book1.xlsx';
sheet = 1;
xlRange = 'A4:C27651';
St = xlsread(filename,sheet,xlRange);
[N,M]=size(St);
s=zeros(m,n);
for i=1:N
    s(St(i,1),St(i,2))=St(i,3);
end
[m,n]=size(s);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lt=xlsread(filename,'A43736:C59813');
[nl,ml]=size(Lt);
l1=zeros(n,d);
for i=1:nl
    l1(Lt(i,1),Lt(i,2))=Lt(i,3);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ut=xlsread(filename,'A27655:C43732');
[nu,mu]=size(Ut);
u1=zeros(n,d);
for i=1:nu
    u1(Ut(i,1),Ut(i,2))=Ut(i,3);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K=input('please enter upper bound K:\n');
[n,d]=size(u1);
f=[zeros(1,d),ones(1,n),zeros(1,n*d)];
lb = [zeros(n,1);reshape(l1,[],1)];
ub = [inf*ones(n,1);reshape(u1,[],1)];
Aeq=[];
beq=[];
A=[ones(1,d),zeros(1,n+n*d)];
b=K;
bl=[];
gamma=0;
socConstraints=zeros(1,n+d);
for i=1:d
    B=zeros(m,d+(n+1)*d);
    B(:,d+i*n+1:d+i*n+n)=s;
    D=zeros((n+1)*d+d,1);
    D(i,1)=1;
    socConstraints(i)=secondordercone(B,bl,D,gamma);
end
for i=1:n
    a=zeros(1,n*(d+2));
   
    D2=zeros(n*(d+2),1);
       for k=1:d
           a(1,k*n+d+i)=1;
       end
  a1=diag(a);
  D2(d+i)=1;
 
socConstraints(i+d)=secondordercone(a1,bl,D2,gamma);

end
[x,fval]=coneprog(f,socConstraints,A,b,Aeq,beq,lb,ub);

v=reshape(x,n,d+2);
v(:,1:2)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'output.xlsx';
A = [v];
xlswrite(filename,A);
