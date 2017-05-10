function [Y1]=dajin(C)
% C=imread('02s.png'); %读取图像
% figure,imshow(C);title('原始显著度图像');  %绘原图
count=imhist(C);                        %直方图统计
[r,t]=size(C);                          %图像矩阵大小
N=r*t;                                  %图像像素个数
L=256;                                  %指定图像灰度级为256级
count=count/N;                          %各级灰度出现的概率
for i=2:L;
if count(i)~=0
    st=i-1;
    break
  end
end
%以上循环语句实现寻找出现概率不为0的最小灰度值

for i=L:-1:1
    if count(i)~=0;
        nd=i-1;
        break
    end
end
%实现找出出现概率不为0的最大灰度值

f=count(st+1:nd+1);
p=st;
q=nd-st;                               %p和q分别是灰度的起始和结束值
u=0;
for i=1:q;
    u=u+f(i)*(p+i-1);
    ua(i)=u;
end
%计算图像的平均灰度值
for i=1:q;
    w(i)=sum(f(1:i));
end
%计算出选择不同k的时候，A区域的概率
d=(u*w-ua).^2./(w.*(1-w));               %求出不同k值时类间方差
[y,tp]=max(d);                           %求出最大方差对应的灰度级
th=tp+p;
if th<=160
    th=tp+p;
else
    th=160;
end                                     %根据具体情况适当修正门限
    Y1=zeros(r,t);
    for i=1:r
        for j=1:t
            X1(i,j)=double(C(i,j));
        end
    end
    for i=1:r
        for j=1:t
            if (X1(i,j)>=th)
                Y1(i,j)=X1(i,j);
            else
                Y1(i,j)=0;
            end
        end
    end
    %上面一段代码实现分割
%     figure,imshow(Y1);title('灰度门限分割的图像');