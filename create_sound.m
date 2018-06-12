function y = createSound(instrument,root,fs,dur)
switch instrument
    case 'Additive'
        y = additivesynth(fs,dur,root);
    case 'Subtractive'
        y = subtractsynth(fs,dur,root);
    case 'FM'
        y = FMsynth(fs,dur,root);
    case 'Waveshaper'
        y = waveshaping(fs,dur,root);
end
end
