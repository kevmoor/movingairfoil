import PyPlot
PyPlot.pygui(true)
import FLOWMath

# Inputs
chord_length = 1.0 #m
windspeed = 15.0 #m/s
NchordFlow = 1.5
steady_state_time = 1/windspeed * NchordFlow/chord_length# sec, at 15m/s for a 1m chord, 1 chords is .67 seconds
# Potentially repeating/array of numbers
sin_duration = 2.0 # sec, for 15m/s and 1m chord, then 1/15 = 0.067 seconds per chord, and if (below) we are doing 20 chords in a full cycle, if we did 5 cycles, then that's 100 chords of flow, or 6.7 seconds, so just say 10 seconds to match up with the sim steps?
N_sin_points = 100
frequency_rot = 0.75 #hz -> 1 hz means we go from 0 to amplitude to negative amplitude to zero in one second.  for 15m/s and 1m chord, if we want 5 chords of flow when it hits the high side (1/4 stroke), then 1/15 = 0.067 seconds per chord, multiply by 5 = 0.33 seconds, so want full cycle in 4x that time, so 1 cycle in 1.33 seconds, 1/1.33 = 0.75 cycles/second
frequency_edge = 0.75 #hz
frequency_flap = 0.75 #hz
rot_amp_deg = 10.0 # deg
edge_amp_m = 0.25 # m
flap_amp_m = 0.125 # m
N_sample_out = 50

# Get to steady state
N_steady_state = 10

time_array = collect(LinRange(0.0, steady_state_time, N_steady_state))
theta_deg_array = collect(LinRange(0.0, 0.0, N_steady_state))
edge_offset_array = collect(LinRange(0.0, 0.0, N_steady_state))
flap_offset_array = collect(LinRange(0.0, 0.0, N_steady_state))

# Define motion, could do multiple input in a loop to get multiple different frequencies, amplitudes in a run, etc

# Intermediate time array
time_sin = collect(LinRange(1e-6, sin_duration, N_sin_points))

# Define sinusoidal rotation
sin_rotation_deg = rot_amp_deg*sin.(2*pi*frequency_rot*time_sin)

# Define sinusoidal edge motion
sin_edge_m = edge_amp_m*sin.(2*pi*frequency_edge*time_sin)

# define sinusoidal flap motion
sin_flap_m = flap_amp_m*sin.(2*pi*frequency_flap*time_sin)


time_array = [time_array; time_array[end].+time_sin]
theta_deg_array = [theta_deg_array; sin_rotation_deg]
edge_offset_array = [edge_offset_array; sin_edge_m]
flap_offset_array = [flap_offset_array; sin_flap_m]

span_offset_array = zeros(length(time_array))

# Spline
time_out = LinRange(time_array[1],time_array[end],N_sample_out)

theta_deg_out = FLOWMath.akima(time_array,theta_deg_array,time_out)
edge_offset_out = FLOWMath.akima(time_array,edge_offset_array,time_out)
flap_offset_out = FLOWMath.akima(time_array,flap_offset_array,time_out)

# Plot to verify
PyPlot.figure()
PyPlot.plot(time_array,theta_deg_array,"r",label="Theta (Deg)")
PyPlot.plot(time_array,edge_offset_array,"g",label="Edge offset (m)")
PyPlot.plot(time_array,flap_offset_array,"b",label="Flap offset (m)")

PyPlot.plot(time_out,theta_deg_out,"r--",label="Theta (Deg)")
PyPlot.plot(time_out,edge_offset_out,"g--",label="Edge offset (m)")
PyPlot.plot(time_out,flap_offset_out,"b--",label="Flap offset (m)")

PyPlot.legend()

# Now Create the output definition

println("    mesh_motion:
    - name: arbitrary_motion_airfoil
      mesh_parts: 
      - airfoil-HEX
      frame: non_inertial
      motion:")

# Rotations
for itime = 1:length(time_out)-1
    println("      - type: rotation
        angle: $(theta_deg_out[itime])
        start_time: $(time_out[itime]+1e-6)
        end_time: $(time_out[itime+1])
        axis: [0.0, 0.0, 1.0]
        origin: [0.0, 0.0, 0.0]")
end

# Displacements
for itime = 1:length(time_out)-1
    println("      - type: translation
        start_time: $(time_out[itime]+1e-6)
        end_time: $(time_out[itime+1])
        displacement: [$(flap_offset_out[itime]), $(edge_offset_out[itime]), 0.0]")
end
