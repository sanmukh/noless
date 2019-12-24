function Theta = combineBuilding(C, S)
%C = Curtailment value to be achieved (Note that this is the scaled curtailment)
%S = 2D Indicator Array of size building X (C_cap + 1)
%S will have a 0 entry when a curtailment cannot be achieved and 1 if it
%can be achieved. For simplicity, lets run singleBuilding algorithms with
%same C for all the buildings. That can be the overall curtailment target
%itself.

M = size(S,1)

set_size = size(S,2)

Theta = zeros(getCurtailIndex(C), M);

%Initialization
for c = 0:C
    if S(1,getCurtailIndex(c)) == 1
        Theta(getCurtailIndex(c), 1) = 1;  
    end
end

%Filling the table iteratively
for c = 0:C
    for b = 2:M
       for s1 = 0:c%set_size
           if Theta(getCurtailIndex(c), b) == 1
              break; 
           end
           
           if (c >=s1) && (Theta(getCurtailIndex(c - s1),b-1) == 1) && (S(b,getCurtailIndex(s1)) == 1)
              Theta(getCurtailIndex(c), b) = 1;
           end
       end
    end
end



end

%MATLAB is 1 indexed, hence we cannot have a table entry for 0.
%So we increment the curtailment value by 1.
function CAct = getCurtailIndex(c)
    CAct = c + 1;
end

