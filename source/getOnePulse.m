function [xValuesOnePulse, yValuesOnePulse] = ...
    getOnePulse(phaseDuration, asymmetryRatio, polarityFirstPhase)
% arguments:
%       - Phase duration (in the desired unit)
%       - asymmetryRatio (negative means long phase first, 0 means monophasic)
%       - polarityFirstPhase (+1/-1)


% Short phase first
if isinf(asymmetryRatio)
    xValuesOnePulse = [0 0 phaseDuration phaseDuration];
    yValuesOnePulse = polarityFirstPhase*[0 1 1 0];
elseif asymmetryRatio > 0
    xValuesOnePulse = [0 0 phaseDuration phaseDuration ...
        (1+asymmetryRatio)*phaseDuration (1+asymmetryRatio)*phaseDuration];
    yValuesOnePulse = ...
        polarityFirstPhase*[0 1 1 -1/asymmetryRatio -1/asymmetryRatio 0];
elseif asymmetryRatio < 0% long phase first (short phase starts at zero)
    xValuesOnePulse = [asymmetryRatio*phaseDuration asymmetryRatio*phaseDuration 0 0 ...
        phaseDuration phaseDuration];
    yValuesOnePulse = polarityFirstPhase*[0 1/abs(asymmetryRatio) 1/abs(asymmetryRatio) -1 -1 0];
else % monophasic
    xValuesOnePulse = [0 0 phaseDuration phaseDuration];
    yValuesOnePulse = polarityFirstPhase*[0 1 1 0];    
end