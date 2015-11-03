a = char(curfile);
[~,len] = size(a);
b = char();
i = len-4;
while a(i) ~= '_'    
    b = strcat(a(i),b);
    i = i - 1;
end