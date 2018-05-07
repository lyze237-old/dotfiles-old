#!/usr/bin/python
import os
import re
from subprocess import check_output, call

# Mapping of cards and their default volumes
volumes = {'alsa_output.usb-Sennheiser_Sennheiser_3D_G4ME1-00.analog-stereo': 100,
           'alsa_output.pci-0000_00_1b.0.analog-stereo': 45}

null = open(os.devnull, 'w')

# Get available sinks
pactl_sinks = check_output(
    ['pactl', 'list', 'sinks', 'short']).decode('utf-8').split('\n')
sinks = []
for line in pactl_sinks:
    match = re.search('(alsa_output\..*?)\s', line)
    if match:
        sink = re.search('(alsa_output\..*?)\s', line).group(1)
        if 'echo-cancel' not in sink:
            sinks.append(sink)
print('Available sinks:')
for sink in sinks:
    print('    ' + sink)

# Get default sink
pactl_info = check_output(['pactl', 'info']).decode('utf-8')
sink_default = re.search(
    'Default Sink: (alsa_output\..*)\s', pactl_info).group(1)
print('Default sink:')
print('    ' + sink_default)

# Get next sink
index_default = [sink for sink in sinks].index(sink_default)
sink_next = sinks[(index_default + 1) % len(sinks)]
print('Next sink:')
print('    ' + sink_next)

# Set new default sink
call(['pacmd', 'set-default-sink %s' % sink_next], stdout=null)
call(['notify-send', '-i', 'multimedia-volume-control', 'Default Sink', 'Switched to ' + sink_next])

# Mute while moving inputs
call(['pactl', 'set-sink-volume', sink_next, '0%'], stdout=null)

# Get inputs to move
pacmd_inputs = check_output(
    ['pacmd', 'list-sink-inputs']).decode('utf-8')
inputs = re.findall('index: (\d+)', pacmd_inputs, re.DOTALL)
print('Inputs to move:')
print('    ' + ' '.join(inputs))
applications = re.findall('application\.process\.binary = "(.*?)"',
                          pacmd_inputs, re.DOTALL)
print('Applications to move:')
for application in applications:
    print('    ' + application)

# Move inputs
for input_ in inputs:
    call(['pacmd', 'move-sink-input', input_, sink_next], stdout=null)

# Unmute
if sink_next in volumes.keys():
    call(['pactl', 'set-sink-volume', sink_next,
          str(volumes[sink_next]) + '%'], stdout=null)
else:
    call(['pactl', 'set-sink-volume', sink_next, '100%'], stdout=null)
