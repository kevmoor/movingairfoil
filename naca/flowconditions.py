import numpy as np

M   = 0.38
Re  = 3.8e6
rho = 1.225
a   = 340
mu  = 1.88e-5
k   = 0.075
alphabar = 2.1
alphaamp = 8.2

U = M * a
L = mu * Re / rho / U

omega = 2 * k * U / L
delta = 0.37 * L / Re**0.2
Cf = (2*np.log10(Re)-0.65)**(-2.3)
tauw = Cf * 0.5 * rho * U**2
ustar = np.sqrt(tauw/rho)
y1 = mu / rho / ustar

print(                            )
print( "alphabar:     ", alphabar )
print( "alphaamp:     ", alphaamp )
print( "U:            ", U        )
print( "L:            ", L        )
print( "period:       ", 1.0/(omega/2/np.pi)    )
print( "BL Thick:     ", delta    )
print( "first cell:   ", y1       )
print(                            )



  

