function flag = compare(true,sim)

flag = 0;
for i = 1:size(true,1)
    if sim(i)>true(i,1)||sim(i)<true(i,3)
        flag = 1;
    end
end

end