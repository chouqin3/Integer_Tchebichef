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
if n==1 %只有一个数
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

for i=1:n-1 %共需n-1次合并
    [q(:,1),ix]=sort(p(:,1));%把q的元素按照降序排列放到q中,
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
queue=zeros(2*n-1,2);%队列,存储每层节点
rear=rear+1;
queue(rear,1)=2*n-1;%将根节点放入队列
queue(rear,2)=1;%根节点树的高度为1
h=0;
while front~=rear
    h=h+1;
    hnodeindexs=[];%保存该层节点
    hn=1;%hnodeindexs数组的下标
    %求出高度为h的所有节点
    while front<2*n-1 && queue(front+1,2)==h %队列总共有2n-1个节点
        front=front+1;
        hnodeindexs(hn)=queue(front,1);%取出h层上的一个节点
        hn=hn+1;
    end
    %对该层节点进行重新排序,使得该层的叶子节点集中在前面,内节点集中在后面
    i=1;
    j=hn-1;
    if(hn>2)
        while i<j
            %寻找处在前面位置的非叶子节点
            while i<j && tree(hnodeindexs(i)).isleaf==true
                i=i+1;
            end
            %寻找处在后面位置的非内节点
            while j>i && tree(hnodeindexs(j)).isleaf==false
                j=j-1;
            end
            %两节点交换位置
            ii=tree(hnodeindexs(i)).parent;
            jj=tree(hnodeindexs(j)).parent;
            %修改父节点的左右孩子指向
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
            %修改两节点的父节点指向
            tree(hnodeindexs(i)).parent=jj;
            tree(hnodeindexs(j)).parent=ii;
            %修改两节点在该层中的排序
            temp=hnodeindexs(i);
            hnodeindexs(i)=hnodeindexs(j);
            hnodeindexs(j)=temp;
            %两节点已交换,寻找下一对节点
            i=i+1;
            j=j-1;
        end
        %将该层节点的孩子节点放入队列        
    end
    for i=1:hn-1
        if tree(hnodeindexs(i)).left~=-1 %非叶子节点
            rear=rear+1;
            queue(rear,1)=tree(hnodeindexs(i)).left;
            queue(rear,2)=h+1;
            rear=rear+1;
            queue(rear,1)=tree(hnodeindexs(i)).right;
            queue(rear,2)=h+1;
        end
    end
end
%对叶子节点进行编码
for i=1:n
    p=tree(i).parent;
    while(p~=-1)
        tree(i).code=strcat(tree(p).code,tree(i).code);
        p=tree(p).parent;
    end
end
end