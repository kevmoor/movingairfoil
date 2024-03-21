import numpy as np

timestep    = 0.0005
steadysteps = 200
wiggleper   = 0.146
wiggleamp   = 8.2 * np.pi/180
totalsteps  = 2000

wigglefreq = 2*np.pi/wiggleper
steadytime = steadysteps * timestep

print("  mesh_motion:")
print("  - name: arbitrary_motion_airfoil")
print("    mesh_parts:")
print("    - airfoil-HEX")
print("    frame: non_inertial")
print("    motion:")

# Currently using the exact omega at the beginning of each interval as constant over the interval.
# This may lead to an overestimation of the aoa amplitude when integrated by nalu (like forward euler integrating a sine wave).
# Could use something else for better accuracy.  Midpoint would be easy.
# Not known whether specifying omega is better than specifying aoa, but I was concerned aoa was leading to jerky movement.

currenttime = steadytime
previousangle = wiggleamp
for i in range(0,totalsteps):
  currentangle = wiggleamp * np.cos(wigglefreq*(currenttime-steadytime))
  deltaangle = currentangle - previousangle
  currentomega = wiggleamp * wigglefreq * np.sin(wigglefreq*(currenttime-steadytime))
  print("    - type:       rotation")
  print("      omega:      "+str(currentomega))
  print("      start_time: "+str(currenttime))
  print("      end_time:   "+str(currenttime+timestep-1e-8))
  print("      axis:       [0.0, 0.0, 1.0]")
  print("      origin:     [0.0, 0.0, 0.0]")

  currenttime = currenttime + timestep
  previousangle = currentangle 

