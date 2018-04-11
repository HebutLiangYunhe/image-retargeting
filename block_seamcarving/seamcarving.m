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

demo=nargout==0;%��������ĸ�����
if nargin==0%�������������
%     fex={'peppers.png' 'liftingbody.png' 'pears.png' 'trees.tif' 'football.jpg' 'saturn.png'};%��������������������
     fex={ '815.jpg'};
    fex=fex{ceil(rand*length(fex))};%����ȡ����������ֵΪ0������ ��^2 = 1����׼��� = 1����̬�ֲ�������������ĺ�����
    try
        [im,map]=imread(fex);%map�ﴢ�������ɫ����������һ�Ÿ������ֶ�Ӧ��ɫ�ı��im����������ɫֵ��map����ɫ��
    catch
        [im,map]=imread('815.jpg');
    end
     k=160;%ɾ����
end
im=im2double(im);%ת��double��
if demo%����������������������������������������
    close(findobj(0,'type','figure','tag','seam carving demo'));%�ҵ���־��Ϊ��Щ�Ŀؼ������ص�
    figure; %����һ����ͼ
    set(gcf,'tag','seam carving demo','name','Seam Carving','NumberTitle','off')%��������������
    axes('position', [0 0 1 1]);%��������ϵ
    if size(im,3)==1%ͨ����Ϊ1
        im=im/max(im(:));%����ͼ������е������ֵ
        him=imagesc(im);%�������е�Ԫ��ֵ���մ�Сת��Ϊ��ͬ����ɫ
        colormap gray%ѹ��
    else
        him=image(im);%image��������ʾ����ͼ�񣬼���ʾ��ͼ������x,y���������ʾ�����Կ���ͼ������ش�С��
    end
    origim=im;
    axis equal%�����᳤�ȵ�λ���ó����
   axis off%�رտ̶ȡ�
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
     G=costfunction(im);%�ɱ�����
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
    
     for ii=2:size(Pot,1)%2������
        pp=Pot(ii-1,:);%���ΰѵ�һ�е������ڶ��и�ֵ��pp
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
%   imm2=(imm)>=110;%i2�Ƕ�ֵͼ��                                                 
%     Pot1=sum(imm2);
%     Pot(end,:)= Pot1;
    pix=zeros(size(G,1),1);%����һ��n�� 1�е�0������
    [mn,pix(end)]=min(Pot(end,:));%�ҳ����һ����Сֵ�Լ�λ�á�
    pp=find(Pot(end,:)==mn);%����Сֵ��λ���ҳ�����¼��pp��
    pix(end)=pp(ceil(rand*length(pp)));%�����һ��
    
        l=1;r=1;
% % %     im(end,pix(end),:)=nan;
    for ii=size(G,1)-1:-1:1%���ɷ죬�ʼii��ֵ�ǵ����ڶ��С�
        %[mn,gg]=min(P3ot(ii,pix+(-1:1)));
        [mn,gg]=min(Pot(ii,max(pix(ii+1)-l,1):min(pix(ii+1)+r,end)));%�����ڶ��� ĳ����
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
          im(ii,pix(ii),:)=bitand(ii,1);%��λ��,�ѷ���ʾ������
             im(ii,pix(ii),:)=0;%��λ��,�ѷ���ʾ������
%        G(ii,pix(ii))=1;
     end
% ||pix(ii+1)==size(G,1)
    if demo%ע�ͺ���ʾɾ�����̡�
        set(him,'CDATA',im);
        %set(him,'CDATA',G,'CDataMapping','scaled');
        drawnow;%ˢ����Ļ
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
     immm(:,end,:)=[];%����ɾ�ɾ����±���������Ϊ���������ͻ��߼����͡�
     immmm(:,end,:)=[];
%    G(:,end)=[];

end

if demo%ע�ͺ�ֻ��ʾһ��ͼƬ
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



