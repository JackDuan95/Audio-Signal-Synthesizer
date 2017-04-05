function modified = EnergyEqualizer(original,signal)
    O_Energy=sum(original.^2);
    S_Energy=sum(signal.^2);
    EngergyRatio = O_Energy/S_Energy;
    amplitudeRatio=sqrt(EngergyRatio);
    modified=signal.*amplitudeRatio;
end