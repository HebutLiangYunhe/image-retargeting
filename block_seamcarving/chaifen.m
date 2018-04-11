pnum=796;
url=strcat('..\block_seamcarving\image/00',num2str(pnum),'.jpg');
im=imread(url);
urls=strcat('..\block_seamcarving\image/00',strcat(num2str(pnum),'_wCtr_Optimized'),'.png');
imm=imread(urls);

figure;
imshow(imm);title('显著度图')
caijianshu=0.4*size(im,2);
imorg=im;
imsorg=imm;
 C=imm;
imm=dajin(C);
immbanchengpin=imm;
imm=(imm)>=1;
 figure;
 imshow(imm);title('大津二值化');
         Pot=sum(imm);
         s=sum(Pot);

[Pot1,index] =sort(Pot,'descend');
s=sum(Pot1);
s1=0;
for i=1:size(Pot,2)
    s1=s1+Pot1(i);
    if (s1/s>0.99);
        break;
    end
end


bili=i/size(Pot,2);
b=0.9;
a=0.99;
s1=0;
for i=1:size(Pot,2)
    im(:,index(i),1)=250;
    s1=s1+Pot1(i);
    if (s1/s>a)||(i>b*size(Pot,2));
        break;
    end
end

if(im(1,1,1)==250)
 im(:,1,1)=0;
end
if(im(1,size(Pot,2),1)==250)
 im(:,size(Pot,2),1)=0;
end

im1=im(:,:,1);
im2=sum(im1)/size(im1,1);

juzhenshu=2;
for i=2:size(Pot,2)-1
    if(im2(1,i-1)~=250 && im2(1,i)==250) 
        juzhenshu=juzhenshu+1;
        zuobiao1(juzhenshu-2)=i-1;
    end
    if(im2(1,i)==250 && im2(1,i+1)~=250) 
        zuobiao2(juzhenshu-2)=i;
    end
end
juzhenshu=juzhenshu-2;

 figure;
 imshow(im);title('标红后');

 feng1=[zuobiao1,size(Pot,2)];
 feng2=[1,zuobiao2];
fengkuan=feng1-feng2;
for i=2:size(fengkuan,2)-1
    if fengkuan(i)<0.03*size(Pot,2)
        for j=1:fengkuan(i)
             im(:,feng2(i)+j,1)=250;
        end
    end
end

im1=im(:,:,1);
im3=sum(im1)/size(im1,1);
juzhenshu2=2;

zuobiao3=[];zuobiao4=[];
for i=2:size(Pot,2)-1
    if(im3(1,i-1)~=250 && im3(1,i)==250) 
        juzhenshu2=juzhenshu2+1;
        zuobiao3(juzhenshu2-2)=i-1;
    end
    if(im3(1,i)==250 && im3(1,i+1)~=250) 
        zuobiao4(juzhenshu2-2)=i;
    end
end
if isempty(zuobiao4)
         zuobiao4(juzhenshu2-2)=i;
end
juzhenshu2=juzhenshu2-2;

  figure;
  imshow(im);title('去掉小缝');

juzhenkuan=zuobiao4-zuobiao3;
for i=1:size(juzhenkuan,2)
    if juzhenkuan(i)<0.03*size(Pot,2)  
        for j=1:juzhenkuan(i)
             im(:,zuobiao3(i)+j,1)=0;
        end
    end
end
qsqxq
im1=im(:,:,1);
im4=sum(im1)/size(im1,1);
juzhenshu3=2;

zuoiao5=[];zuobiao6=[];
for i=2:size(Pot,2)-1
    if(im4(1,i-1)~=250 && im4(1,i)==250) 
        juzhenshu3=juzhenshu3+1;
        zuobiao5(juzhenshu3-2)=i-1;
    end
    if(im4(1,i)==250 && im4(1,i+1)~=250) 
        zuobiao6(juzhenshu3-2)=i;
    end
end
      if isempty(zuobiao6)
         zuobiao6(juzhenshu3-2)=i;
     end
juzhenshu3=juzhenshu3-2;

    figure;
    imshow(im);title('去掉小块');

if zuobiao5>((size(Pot,2)-zuobiao6))
    big=zuobiao5;small=((size(Pot,2)-zuobiao6));
    k=0;
else
    big=((size(Pot,2)-zuobiao6));small=zuobiao5;
    k=1;
end
%% 

if(juzhenshu3==1)
    bili=(zuobiao6-zuobiao5)/size(im,2);
end
if(juzhenshu3==2)
    bili=(zuobiao6(1,1)-zuobiao5(1,1)+zuobiao6(1,2)-zuobiao5(1,2))/size(im,2);
end
%  
 bili1=floor(10*bili)+1;
switch bili1
        case 1
        xi1=0;xi0=1-xi1;
        case 2
        xi1=0;xi0=1-xi1;
        case 3
        xi1=0;xi0=1-xi1;
        case 4
        xi1=0;xi0=1-xi1;
        case 5    
        xi1=0;xi0=1-xi1;
        case 6
        xi1=(bili*10-5)*0.05;xi0=1-xi1;
        case 7
        xi1=(bili*10-6)*0.25+0.05;xi0=1-xi1;
        case 8
        xi1=(bili*10-7)*0.25+0.25;xi0=1-xi1;
        case 9
        xi1=(bili*10-8)*0.25+0.5;xi0=1-xi1;
end
if juzhenshu3==1
     if floor(big/small)>4&&k==0
        x0=zuobiao5/4;     n0=caijianshu*xi0/4;
        x1=x0+zuobiao5/4;  n1=caijianshu*xi0/4;
        x2=x1+zuobiao5/4;  n2=caijianshu*xi0/4;
        x3=zuobiao5;       n3=caijianshu*xi0/4;
        x4=size(Pot,2);    n4=caijianshu*xi1;
     end
     if floor(big/small)>4&&k==1
        x0=zuobiao6;                     n0=caijianshu*xi1;
        x1=x0+(size(Pot,2)-zuobiao6)/4;  n1=caijianshu*xi0/4;
        x2=x1+(size(Pot,2)-zuobiao6)/4;  n2=caijianshu*xi0/4;
        x3=x2+(size(Pot,2)-zuobiao6)/4;  n3=caijianshu*xi0/4;
        x4=size(Pot,2);                  n4=caijianshu*xi0/4;
     end
    if floor(big/small)>1&&k==0
        e1=(zuobiao5/(size(Pot,2)-zuobiao6+zuobiao5))/3;
        e2=(size(Pot,2)-zuobiao6)/(size(Pot,2)-zuobiao6+zuobiao5);
        x0=zuobiao5/3;         n0=caijianshu*xi0*e1;
        x1=x0+zuobiao5/3;      n1=caijianshu*xi0*e1;
        x2=zuobiao5;           n2=caijianshu*xi0*e1;
        x3=zuobiao6;           n3=caijianshu*xi1;
        x4=size(Pot,2);        n4=caijianshu*xi0*e2;
    end
     if floor(big/small)>1&&k==1
        e1=((size(Pot,2)-zuobiao6)/(size(Pot,2)-zuobiao6+zuobiao5))/3;
        e2=zuobiao5/(size(Pot,2)-zuobiao6+zuobiao5);   
        x0=zuobiao5;                                    n0=caijianshu*xi0*e2;
        x1=zuobiao6;                                    n1=caijianshu*xi1;
        x2=zuobiao6+(size(Pot,2)-zuobiao6)/3;           n2=caijianshu*xi0*e1;
        x3=x2+(size(Pot,2)-zuobiao6)/3;                 n3=caijianshu*xi0*e1;
        x4=size(Pot,2);                                 n4=caijianshu*xi0*e1;
     end
     if floor(big/small)==1
        e1=(zuobiao5/(size(Pot,2)-zuobiao6+zuobiao5))/2;
        e2=((size(Pot,2)-zuobiao6)/(size(Pot,2)-zuobiao6+zuobiao5))/2;  
        x0=zuobiao5/2;                                  n0=caijianshu*xi0*e1;
        x1=zuobiao5;                                    n1=caijianshu*xi0*e1;
        x2=zuobiao6;                                    n2=caijianshu*xi1;
        x3=zuobiao6+(size(Pot,2)-zuobiao6)/2;           n3=caijianshu*xi0*e2;
        x4=size(Pot,2);                                 n4=caijianshu*xi0*e2;
    end
end    

if juzhenshu3==2
    fenmu0=size(Pot,2)-zuobiao6(1,2)+(zuobiao5(1,2)-zuobiao6(1,1))+zuobiao5(1,1);
    fenmu1=size(Pot,2)-fenmu0;
    fenzi0=zuobiao5(1,1);
    fenzi1=zuobiao6(1,1)-zuobiao5(1,1);
    fenzi2=zuobiao5(1,2)-zuobiao6(1,1);
    fenzi3=zuobiao6(1,2)-zuobiao5(1,2);
    fenzi4=size(Pot,2)-zuobiao6(1,2);
    
    x0=zuobiao5(1,1);               n0=caijianshu*xi0*fenzi0/fenmu0;
    x1=zuobiao6(1,1);               n1=caijianshu*xi1*fenzi1/fenmu1;
    x2=zuobiao5(1,2);               n2=caijianshu*xi0*fenzi2/fenmu0;
    x3=zuobiao6(1,2);               n3=caijianshu*xi1*fenzi3/fenmu1;
    x4=size(Pot,2);                 n4=caijianshu*xi0*fenzi4/fenmu0;
end



im=imorg;
% im=im2double(im);
im1=im(:,1:x0,:);
imwrite(im1,'00001s.jpg');
ims1=imm(:,1:x0,:);
imms1=C(:,1:x0,:);
  figure;
  subplot(1,5,1);
   imshow(im1);title('分块');
im1s=seamcarving(im1,n0,ims1,imms1);
% figure;
% imshow(im1s);
im2=im(:,x0:x1,:);
imwrite(im2,'00002s.jpg');
ims2=imm(:,x0:x1,:);
 imms2=C(:,x0:x1,:);
%  figure;
  subplot(1,5,2);
  imshow(im2);
im2s=seamcarving(im2,n1,ims2,imms2);
% figure;
% imshow(im2s);
im3=im(:,x1:x2,:);
imwrite(im3,'00003s.jpg');
ims3=imm(:,x1:x2,:);
imms3=C(:,x1:x2,:);

%   figure;
   subplot(1,5,3);
  imshow(im3);
im3s=seamcarving(im3,n2,ims3,imms3);
% figure;
%  imshow(im3s);

im4=im(:,x2:x3,:);
imwrite(im4,'00004s.jpg');
 ims4=imm(:,x2:x3,:);
  imms4=C(:,x2:x3,:);
%      figure;
   subplot(1,5,4);
   imshow(im4);
im4s=seamcarving(im4,n3,ims4,imms4);
% figure;
% imshow(im4s);

im5=im(:,x3:x4,:);
imwrite(im5,'00005s.jpg');
ims5=imm(:,x3:x4,:);
imms5=C(:,x3:x4,:);
%  figure;
  subplot(1,5,5);
   imshow(im5);
im5s=seamcarving(im5,n4,ims5,imms5);
% figure;
% imshow(im5s);

ims=[im1s,im2s,im3s,im4s,im5s];
 figure;
 imshow(im);title('原图像');
   figure;
   imshow(ims);title('裁剪后')
 mkdir('dirname');
   clear;
%% 





