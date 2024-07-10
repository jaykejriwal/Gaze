# Developed by Jay Kejriwal (2021) for measuring prosodic values by external tools and non-sequencially 

form arguments
	comment File
	text filename D:\Jay\GAZE\dataset\Audio_resampled\GA-CO-AMO.WAV
	comment Start Time
	real starttime 1.225
	comment End Time
	real endtime 4.64
    comment Output file
    text outputfile D:\GA-CO-AMOnew.csv
endform

floorS = 50
ceilingS = 600
maximum_period_factor = 1.3
maximum_amplitude_factor = 1.6
silence_threshold = 0.03
voicing_threshold = 0.45

Open long sound file... 'filename$'
sound = Extract part: starttime, endtime, "no"
selectObject: sound
dur = Get total duration
To Intensity: 100, 0, "no"
mean = Get mean: 0, 0, "dB"
min = Get minimum: 0, 0, "Parabolic"
max = Get maximum: 0, 0, "Parabolic"

if mean = undefined
    mean = 0
endif

if min = undefined
    min = 0
endif

if max = undefined
    max = 0
endif

mean = round(mean)
min = round(min)
max = round(max)

selectObject: sound
To Pitch (ac)... 0 'floorS' 15 no 0.03 0.45 0.01 0.35 0.14 'ceilingS'
pitch1 = selected ("Pitch")
low = Get quantile... 0 0 0.15 Hertz
high = Get quantile... 0 0 0.65 Hertz
pitch_range_min = low*0.83
pitch_range_max = high*1.92
removeObject: pitch1
selectObject: sound
To Pitch (ac)... 0 pitch_range_min 15 no 0.03 0.45 0.01 0.35 0.14 pitch_range_max
pitch = selected ("Pitch")


min_pitch = Get minimum... 0 0 Hertz Parabolic
max_pitch = Get maximum... 0 0 Hertz Parabolic
mean_pitch = Get mean... 0 0 Hertz
median_pitch = Get quantile... 0 0 0.5 Hertz

selectObject: sound
pulses = To PointProcess (periodic, cc): pitch_range_min, pitch_range_max
selectObject: sound,pitch,pulses
voiceReport$ = Voice report: 0, 0, pitch_range_min, pitch_range_max, maximum_period_factor, maximum_amplitude_factor, silence_threshold, voicing_threshold

#mean_pitch = extractNumber (voiceReport$, "Mean pitch: ")
#min_pitch = extractNumber (voiceReport$, "Minimum pitch: ")
#max_pitch = extractNumber (voiceReport$, "Maximum pitch: ")
jitter_local = extractNumber (voiceReport$, "Jitter (local): ")
jitter_abs = extractNumber (voiceReport$, "Jitter (local, absolute): ")
jitter_rap = extractNumber (voiceReport$, "Jitter (rap): ")
jitter_ppq5 = extractNumber (voiceReport$, "Jitter (ppq5): ")
jitter_ddp = extractNumber (voiceReport$, "Jitter (ddp): ")
shimmer_local = extractNumber (voiceReport$, "Shimmer (local): ")
shimmer_local_db = extractNumber (voiceReport$, "Shimmer (local, dB): ")
shimmer_apq3 = extractNumber (voiceReport$, "Shimmer (apq3): ")
shimmer_apq5 = extractNumber (voiceReport$, "Shimmer (apq5): ")
shimmer_apq11 = extractNumber (voiceReport$, "Shimmer (apq11): ")
shimmer_dda = extractNumber (voiceReport$, "Shimmer (dda): ")
mean_nhr = extractNumber (voiceReport$, "Mean noise-to-harmonics ratio: ")






fileappend "'outputfile$'" 'outputfile$''tab$''filename$''tab$''dur:3''tab$''mean_pitch:3''tab$''min_pitch:3''tab$''max_pitch:3''tab$''median_pitch:3''tab$''mean:3''tab$''min:3''tab$''max:3''tab$''jitter_local:3''tab$''shimmer_local_db:3''tab$''mean_nhr:3''newline$'
# clean up
select all
Remove
