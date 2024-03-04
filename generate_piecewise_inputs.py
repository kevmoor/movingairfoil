import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import Akima1DInterpolator

# Inputs
steady_state_time = 0.67
sin_duration = 10.0
N_sin_points = 100
frequency_rot = 0.75
frequency_edge = 0.75
frequency_flap = 0.75
rot_amp_deg = 10.0
edge_amp_m = 0.25
flap_amp_m = 0.125
N_sample_out = 60

# Get to steady state
N_steady_state = 10

time_array = np.linspace(0.0, steady_state_time, N_steady_state)
theta_deg_array = np.linspace(0.0, 0.0, N_steady_state)
edge_offset_array = np.linspace(0.0, 0.0, N_steady_state)
flap_offset_array = np.linspace(0.0, 0.0, N_steady_state)

# Define motion
time_sin = np.linspace(1e-6, sin_duration, N_sin_points)

# Define sinusoidal rotation
sin_rotation_deg = rot_amp_deg * np.sin(2 * np.pi * frequency_rot * time_sin)

# Define sinusoidal edge motion
sin_edge_m = edge_amp_m * np.sin(2 * np.pi * frequency_edge * time_sin)

# Define sinusoidal flap motion
sin_flap_m = flap_amp_m * np.sin(2 * np.pi * frequency_flap * time_sin)

time_array = np.concatenate((time_array, time_array[-1] + time_sin))
theta_deg_array = np.concatenate((theta_deg_array, sin_rotation_deg))
edge_offset_array = np.concatenate((edge_offset_array, sin_edge_m))
flap_offset_array = np.concatenate((flap_offset_array, sin_flap_m))

span_offset_array = np.zeros(len(time_array))

# Spline
time_out = np.linspace(time_array[0], time_array[-1], N_sample_out)

theta_deg_out = Akima1DInterpolator(time_array, theta_deg_array)(time_out)
edge_offset_out = Akima1DInterpolator(time_array, edge_offset_array)(time_out)
flap_offset_out = Akima1DInterpolator(time_array, flap_offset_array)(time_out)

# Plot to verify
plt.figure()
plt.plot(time_array, theta_deg_array, "r", label="Theta (Deg)")
plt.plot(time_array, edge_offset_array, "g", label="Edge offset (m)")
plt.plot(time_array, flap_offset_array, "b", label="Flap offset (m)")

plt.plot(time_out, theta_deg_out, "r--", label="Theta (Deg)")
plt.plot(time_out, edge_offset_out, "g--", label="Edge offset (m)")
plt.plot(time_out, flap_offset_out, "b--", label="Flap offset (m)")

plt.legend()
plt.show()

# Now Create the output definition
print("    mesh_motion:\n    - name: arbitrary_motion_airfoil\n      mesh_parts:\n      - airfoil-HEX\n      frame: non_inertial\n      motion:")

# Rotations
for i in range(len(time_out) - 1):
    print(f"      - type: rotation\n        angle: {theta_deg_out[i]}\n        start_time: {time_out[i]}\n        end_time: {time_out[i+1]}\n        axis: [0.0, 0.0, 1.0]\n        origin: [0.0, 0.0, 0.0]")

# Displacements
for i in range(len(time_out) - 1):
    print(f"      - type: translation\n        start_time: {time_out[i]}\n        end_time: {time_out[i+1]}\n        displacement: [{flap_offset_out[i]}, {edge_offset_out[i]}, 1.0]")
