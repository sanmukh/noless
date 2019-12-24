function Strategies = getStrategies(Theta, S, C)

T = size(Theta, 2);
N = size(Theta, 3);

C_cur = C;
Strategies = zeros(T,1);

for t=T:-1:1
    for j=1:N
       if Theta(getCurtailIndex(C_cur), t, j, 2) == 1
          C_cur = C_cur - S(j,t);
          Strategies(t) = j;
          break;
       end
    end
end

Strategies;
end

%MATLAB is 1 indexed, hence we cannot have a table entry for 0.
%So we increment the curtailment value by 1.
function CAct = getCurtailIndex(c)
    CAct = c + 1;
end