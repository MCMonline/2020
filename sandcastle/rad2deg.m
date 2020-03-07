function angleInDegrees = rad2deg(angleInRadians)

if isfloat(angleInRadians)
    angleInDegrees = (180/pi) * angleInRadians;
else
    error(message('MATLAB:rad2deg:nonFloatInput'))
end

end