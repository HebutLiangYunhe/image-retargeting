 function im=seamcarving(im,k,immm,immmm)
%% illustrative example of Seam carving for content aware image resizing
%
%
% usage: carvedimg=seamcarving(im,k)
%
% k is how many vertical seams to remove.
% im is the image.
%
% example:
%   img=imread('peppers.png')
%   carvedimg=seamcarving(img,50)
%   image([carvedimg img]);
%   axis equal;
%
% Author: Aslak Grinsted 2007...
% Based on ideas from Avidan & Shamir:
% http://video.google.com/videoplay?docid=-6221880321193117495
% Note i havent read their paper and they have probably lots of smart tricks
% for optimizations.
%

demo=nargout==0;%输出参数的个数。
if nargin==0%输入参数个数。
%     fex={'peppers.png' 'liftingbody.png' 'pears.png' 'trees.tif' 'football.jpg' 'saturn.png'};%？？？？？？？？？？
     fex={ '815.jpg'};
    fex=fex{ceil(rand*length(fex))};%向上取整、产生均值为0，方差 σ^2 = 1，标准差σ = 1的正态分布的随机数或矩阵的函数。
    try
        [im,map]=imread(fex);%map里储存的是颜色索引，就是一张各个数字对应颜色的表格。im代表像素颜色值，map代表色谱
    catch
        [im,map]=imread('815.jpg');
    end
     k=160;%删减数
end
im=im2double(im);%转到double型
if demo%？？？？？？？？？？？？？？？？？？？？
    close(findobj(0,'type','figure','tag','seam carving demo'));%找到标志名为这些的控件，并关掉
    figure; %产生一个新图
    set(gcf,'tag','seam carving demo','name','Seam Carving','NumberTitle','off')%？？？？？？？
    axes('position', [0 0 1 1]);%设置坐标系
    if size(im,3)==1%通道数为1
        im=im/max(im(:));%除以图像矩阵中的最大数值
        him=imagesc(im);%将矩阵中的元素值按照大小转化为不同的颜色
        colormap gray%压缩
    else
        him=image(im);%image是用来显示附标图像，即显示的图像上有x,y坐标轴的显示，可以看到图像的像素大小。
    end
    origim=im;
    axis equal%坐标轴长度单位设置成相等
   axis off%关闭刻度。
end
          Potend=zeros(1,size(immmm,2));  
          for i=1:size(immmm,2)
              kk=0;
              s=zeros(1,1);
%              s=im2double(s);
              for j=1:size(immmm,1)
                  if(immm(j,i)==1)
                      a=double(immmm(j,i));
                      s=s+a;
                      kk=kk+1;
                  end
              end
              if kk==0
                  Potend(1,i)=mean(immmm(:,i));
              else Potend(1,i)=s/kk/255;
              end
          end

for jj=1:k
     G=costfunction(im);%成本函数
    %find shortest path in G
    Pot=G;
%     figure;imshow(G);
      for i=1:size(immmm,2)       
              for j=1:size(immmm,1)
                  if(G(j,i)>1)
                      G(j,i)=1;
                  end
              end                   
      end
      immmm=im2double(immmm)/255;
%        figure;imshow(immmm);
      G=(G+immmm)/2;
%        figure;imshow(G);
    
     for ii=2:size(Pot,1)%2到行数
        pp=Pot(ii-1,:);%依次把第一行到倒数第二行赋值到pp
         ix=pp(1:end-1)<pp(2:end);
         pp([false ix])=pp(ix);
         ix=pp(2:end)<pp(1:end-1);
         pp(ix)=pp([false ix]);
         Pot(ii,:)=Pot(ii,:)+pp;
     end
   Pot(end,:)=Potend; 
    %Walk down hill
                                                      
%           for i=1:size(immmm,2)
%               kk=0;
%               s=0;
%               for j=1:size(immmm,1)
%                   if(immmm(j,i)==1)
%                       s=s+immmm(j,i);
%                       kk=kk+1;
%                   end
%               end
%               if kk==0
%                   Pot(end,i)=mean(immmm(:,i));
%               else Pot(end,i)=s/kk;
%               end
%           end
%       imm=rgb2gray(im);
%   imm2=(imm)>=110;%i2是二值图像                                                 
%     Pot1=sum(imm2);
%     Pot(end,:)= Pot1;
    pix=zeros(size(G,1),1);%生成一个n行 1列的0向量。
    [mn,pix(end)]=min(Pot(end,:));%找出最后一行最小值以及位置。
    pp=find(Pot(end,:)==mn);%把最小值的位置找出来记录到pp里
    pix(end)=pp(ceil(rand*length(pp)));%随机抽一个
    
        l=1;r=1;
% % %     im(end,pix(end),:)=nan;
    for ii=size(G,1)-1:-1:1%生成缝，最开始ii的值是倒数第二行。
        %[mn,gg]=min(P3ot(ii,pix+(-1:1)));
        [mn,gg]=min(Pot(ii,max(pix(ii+1)-l,1):min(pix(ii+1)+r,end)));%倒数第二行 某三列
%         pix(ii)=gg+pix(ii+1)-2-(pix(ii+1)>2);
%          if(immm(ii,pix(ii+1))==true)
%              l=1;r=1;
%          end
%          if(immm(ii,pix(ii+1))==false)
%              l=1;r=1;
%          end
         if (pix(ii+1)>1) 
             pix(ii)=gg+pix(ii+1)-1-1; end
         if (pix(ii+1)<2) 
             pix(ii)=gg; end
          im(ii,pix(ii),:)=bitand(ii,1);%按位与,把缝显示出来。
             im(ii,pix(ii),:)=0;%按位与,把缝显示出来。
%        G(ii,pix(ii))=1;
     end
% ||pix(ii+1)==size(G,1)
    if demo%注释后不显示删除过程。
        set(him,'CDATA',im);
        %set(him,'CDATA',G,'CDataMapping','scaled');
        drawnow;%刷新屏幕
    end

    %remove seam from im & G:
    Potend(pix(end):end-1)= Potend(pix(end)+1:end); Potend(end)=[];
    for ii=1:size(im,1)
%        G(ii,pix(ii):end-1)=G(ii,pix(ii)+1:end);
          im(ii,pix(ii):end-1,:)=im(ii,pix(ii)+1:end,:);
          immm(ii,pix(ii):end-1,:)=immm(ii,pix(ii)+1:end,:);
          immmm(ii,pix(ii):end-1,:)=immmm(ii,pix(ii)+1:end,:);
    end
     im(:,end,:)=[];
     immm(:,end,:)=[];%可能删干净：下标索引必须为正整数类型或逻辑类型。
     immmm(:,end,:)=[];
%    G(:,end)=[];

end

if demo%注释后只显示一张图片
    set(him,'CDATA',[im origim])
    axis tight
end
if nargout==0
    clear im
end


%     function G=costfunction(im) %%(xi,yi)
%             G=zeros(size(im,1),size(im,2));
%             for ii=1:size(im,3)
%                 %G=G+abs(filter2([1 0 -1],im(:,:,ii)))+abs(filter2([1;0;-1],im(:,:,ii))); 
%                 G=G+(filter2([.5 1 .5; 1 -6 1; .5 1 .5],im(:,:,ii))).^2; %faster and reasonably good.
%             end
%     end
end



