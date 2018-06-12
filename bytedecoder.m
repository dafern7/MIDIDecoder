%decodes up to four bytes decimal
function y = bytesdecode(A)
if length(A) == 1
y = A(1);
elseif length(A) == 2
y = A(1)*256 + A(2);
elseif length(A) == 3
y = A(1)*(256^2)+A(2)*(256)+A(3);
elseif length(A) == 4
y = A(1)*(256^3)+A(2)*(256^2)+A(3)*(256)+A(4);
else
    fprintf('duration is quite long');
end
end
