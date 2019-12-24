function Curtailments = getBuildingCurtailments(Ccap, Phi, achievedCurtArray)

Ccur = Ccap;

M = size(Phi, 2);

Curtailments = zeros(M,1);

for b = M:-1:2
   for k = 0:Ccap
       if (achievedCurtArray(b,getCurtailIndex(k)) == 1) && (Ccur >= k) && (Phi(getCurtailIndex(Ccur - k), b-1) == 1)
           Curtailments(b) = k;
           Ccur = Ccur - k;
           
           if b == 2
              Curtailments(b-1) = Ccur; 
           end
           
           break;
       end
   end
end

%MATLAB is 1 indexed, hence we cannot have a table entry for 0.
%So we increment the curtailment value by 1.
function CAct = getCurtailIndex(c)
    CAct = c + 1;
end

end