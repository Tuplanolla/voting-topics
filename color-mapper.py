import colour
import numpy
import sys

targets = {}
with open('colors.data') as file:
  for line in file:
    code, name = line.strip().split(' ')
    rgb = colour.notation.HEX_to_RGB(code)
    targets[name] = colour.XYZ_to_Lab(colour.sRGB_to_XYZ(rgb))

sources = {}
for arg in sys.argv[1 :]:
  rgb = colour.notation.HEX_to_RGB(arg)
  sources[arg] = colour.XYZ_to_Lab(colour.sRGB_to_XYZ(rgb))

mappings = {}
for arg, actual in sources.items():
  diffs = []
  for name, expected in targets.items():
    distance = colour.delta_E(actual, expected)
    diffs.append((distance, name))
  mappings[arg] = sorted(diffs)

for arg, diffs in mappings.items():
  for diff in diffs[: 8]:
    numpy.set_printoptions(precision = 2)
    print('{0} {2} {1:.2f}'.format(arg, *diff))
