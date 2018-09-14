function tree=huffman(values,frequencys,sum)
n=length(values);
p(:,1)=frequencys;
p(:,2)=1:n;
node.left=int16(-1);
node.right=int16(-1);
node.parent=int16(-1);
node.value=int16(-1);
node.isleaf=false;
node.code='';
tree(2*n-1)=node;
if n==1 %ֻ��һ����
    tree(1).code='0';
    tree(1).value=values(1);
     tree(1).isleaf=true;
    return;
end
for i=1:n
    tree(i)=node;
    tree(i).value=int16(values(i));
    tree(i).isleaf=true;
end
for i=n+1:2*n-1
    tree(i)=node;
end

for i=1:n-1 %����n-1�κϲ�
    [q(:,1),ix]=sort(p(:,1));%��q��Ԫ�ذ��ս������зŵ�q��,
    q(:,2)=p(ix(:),2);
    p(:,:)=[q(1,:)+q(2,:);q(3:n,:);[sum,0]];
    p(1,2)=n+i;
    tree(n+i).left=int16(q(1,2));
    tree(n+i).right=int16(q(2,2));
    tree(q(1,2)).parent=n+i;
    tree(q(1,2)).code='0';
    tree(q(2,2)).parent=n+i;
    tree(q(2,2)).code='1';
end
front=0;
rear=0;
queue=zeros(2*n-1,2);%����,�洢ÿ��ڵ�
rear=rear+1;
queue(rear,1)=2*n-1;%�����ڵ�������
queue(rear,2)=1;%���ڵ����ĸ߶�Ϊ1
h=0;
while front~=rear
    h=h+1;
    hnodeindexs=[];%����ò�ڵ�
    hn=1;%hnodeindexs������±�
    %����߶�Ϊh�����нڵ�
    while front<2*n-1 && queue(front+1,2)==h %�����ܹ���2n-1���ڵ�
        front=front+1;
        hnodeindexs(hn)=queue(front,1);%ȡ��h���ϵ�һ���ڵ�
        hn=hn+1;
    end
    %�Ըò�ڵ������������,ʹ�øò��Ҷ�ӽڵ㼯����ǰ��,�ڽڵ㼯���ں���
    i=1;
    j=hn-1;
    if(hn>2)
        while i<j
            %Ѱ�Ҵ���ǰ��λ�õķ�Ҷ�ӽڵ�
            while i<j && tree(hnodeindexs(i)).isleaf==true
                i=i+1;
            end
            %Ѱ�Ҵ��ں���λ�õķ��ڽڵ�
            while j>i && tree(hnodeindexs(j)).isleaf==false
                j=j-1;
            end
            %���ڵ㽻��λ��
            ii=tree(hnodeindexs(i)).parent;
            jj=tree(hnodeindexs(j)).parent;
            %�޸ĸ��ڵ�����Һ���ָ��
            if tree(ii).left==hnodeindexs(i)
                if tree(jj).left==hnodeindexs(j)
                    tree(ii).left=hnodeindexs(j);
                    tree(jj).left=hnodeindexs(i);
                else
                    tree(ii).left=hnodeindexs(j);
                    tree(jj).right=hnodeindexs(i);
                    tree(hnodeindexs(i)).code='1';
                    tree(hnodeindexs(j)).code='0';
                end
            else
                if tree(jj).left==hnodeindexs(j)
                    tree(ii).right=hnodeindexs(j);
                    tree(jj).left=hnodeindexs(i);
                    tree(hnodeindexs(i)).code='0';
                    tree(hnodeindexs(j)).code='1';
                else
                    tree(ii).right=hnodeindexs(j);
                    tree(jj).right=hnodeindexs(i);
                end
            end
            %�޸����ڵ�ĸ��ڵ�ָ��
            tree(hnodeindexs(i)).parent=jj;
            tree(hnodeindexs(j)).parent=ii;
            %�޸����ڵ��ڸò��е�����
            temp=hnodeindexs(i);
            hnodeindexs(i)=hnodeindexs(j);
            hnodeindexs(j)=temp;
            %���ڵ��ѽ���,Ѱ����һ�Խڵ�
            i=i+1;
            j=j-1;
        end
        %���ò�ڵ�ĺ��ӽڵ�������        
    end
    for i=1:hn-1
        if tree(hnodeindexs(i)).left~=-1 %��Ҷ�ӽڵ�
            rear=rear+1;
            queue(rear,1)=tree(hnodeindexs(i)).left;
            queue(rear,2)=h+1;
            rear=rear+1;
            queue(rear,1)=tree(hnodeindexs(i)).right;
            queue(rear,2)=h+1;
        end
    end
end
%��Ҷ�ӽڵ���б���
for i=1:n
    p=tree(i).parent;
    while(p~=-1)
        tree(i).code=strcat(tree(p).code,tree(i).code);
        p=tree(p).parent;
    end
end
end