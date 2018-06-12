%reference from Ken Schutte's variable length decoder
%takes a value from A, if greater than 128, increments the count, takes the
%next value from A, truncates both MSB, then converts it into an integer,
%increments the count again.
%this implementation of decoding deltatime was more efficient than one I
%made, so I decided to use it (can be seen in the unused trackparse file)

function [varint,count] = varLengthDecode(A,count)
varint = 0; %initialize the duration variable
n = 1;
while(n)
    if(A(count) < 128)
    n=0;
    end
    varint = varint*128 + mod(A(count),128);
    count = count+1;
end
end
