function [Y1]=dajin(C)
% C=imread('02s.png'); %��ȡͼ��
% figure,imshow(C);title('ԭʼ������ͼ��');  %��ԭͼ
count=imhist(C);                        %ֱ��ͼͳ��
[r,t]=size(C);                          %ͼ������С
N=r*t;                                  %ͼ�����ظ���
L=256;                                  %ָ��ͼ��Ҷȼ�Ϊ256��
count=count/N;                          %�����Ҷȳ��ֵĸ���
for i=2:L;
if count(i)~=0
    st=i-1;
    break
  end
end
%����ѭ�����ʵ��Ѱ�ҳ��ָ��ʲ�Ϊ0����С�Ҷ�ֵ

for i=L:-1:1
    if count(i)~=0;
        nd=i-1;
        break
    end
end
%ʵ���ҳ����ָ��ʲ�Ϊ0�����Ҷ�ֵ

f=count(st+1:nd+1);
p=st;
q=nd-st;                               %p��q�ֱ��ǻҶȵ���ʼ�ͽ���ֵ
u=0;
for i=1:q;
    u=u+f(i)*(p+i-1);
    ua(i)=u;
end
%����ͼ���ƽ���Ҷ�ֵ
for i=1:q;
    w(i)=sum(f(1:i));
end
%�����ѡ��ͬk��ʱ��A����ĸ���
d=(u*w-ua).^2./(w.*(1-w));               %�����ͬkֵʱ��䷽��
[y,tp]=max(d);                           %�����󷽲��Ӧ�ĻҶȼ�
th=tp+p;
if th<=160
    th=tp+p;
else
    th=160;
end                                     %���ݾ�������ʵ���������
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
    %����һ�δ���ʵ�ַָ�
%     figure,imshow(Y1);title('�Ҷ����޷ָ��ͼ��');