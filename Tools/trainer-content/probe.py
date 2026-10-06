# Projects rig joints through each exercise's framing with the app's camera
# (vertical FOV 32deg at z=2.05, viewport aspect 382/705) — unit coords.
import os as _os  # slim models reference Shared/AnatomyBody.usdc (share_body.py)
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
import sys, math, json
sys.path.insert(0, "/Users/sammanhcuong/Developer/GymWorkout/Tools/model-pipeline")
from framer import LONGEST, CENTER, D, TAN
from pxr import Usd, UsdSkel, UsdGeom
import numpy as np
ASPECT = 382 / 655   # trainer viewport since the setup drawer (was 382/705)
M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"
PI = math.pi
JOBS = {
 "Barbell Overhead Press": ("Shoulder/BarbellOverheadPress", -0.5, 0.654, (-0.009,-0.083,0.005)),
 "Dumbbell Shoulder Press": ("Shoulder/DumbbellShoulderPress", -0.5, 0.838, (-0.016,0.016,0.009)),
 "Arnold Press": ("Shoulder/ArnoldPress", -0.5, 0.839, (-0.005,0.016,0.003)),
 "Machine Shoulder Press": ("Shoulder/MachineShoulderPress", -0.6, 0.894, (0.002,0.033,-0.001)),
 "Dumbbell Lateral Raise": ("Shoulder/DumbbellLateralRaise", -0.25, 0.736, (-0.01,0.028,0.003)),
 "Cable Lateral Raise": ("Shoulder/CableLateralRaise", -0.25, 0.842, (-0.019,-0.023,0.005)),
 "Machine Lateral Raise": ("Shoulder/MachineLateralRaise", -0.25, 0.931, (0.008,0.045,-0.002)),
 "Dumbbell Front Raise": ("Shoulder/DumbbellFrontRaise", -0.55, 0.882, (0.073,0.026,-0.045)),
 "Reverse Dumbbell Fly": ("Shoulder/ReverseDumbbellFly", -2.3, 0.987, (-0.115,0.228,-0.129)),
 "Reverse Pec Deck": ("Shoulder/ReversePecDeck", 0.4, 0.846, (0.032,0.112,0.013)),
 "Face Pull": ("Shoulder/FacePull", -2.7, 0.874, (-0.061,0.019,-0.029)),
 "Cable Rear Delt Fly": ("Shoulder/CableRearDeltFly", -2.8, 0.689, (-0.104,-0.005,-0.037)),
 "Barbell Curl": ("Biceps/BarbellCurl", -0.4, 0.615, (0.004,0.019,-0.002)),
 "Triceps Pushdown": ("Triceps/CableTricepsPushdown", -0.6, 0.884, (0.031,0.028,-0.021)),
 "Rope Pushdown": ("Triceps/RopePushdown", -0.6, 0.883, (0.039,0.027,-0.026)),
 "Single-Arm Cable Pushdown": ("Triceps/SingleArmCablePushdown", -0.6, 0.88, (0.016,0.025,-0.011)),
 "Overhead Cable Triceps Extension": ("Triceps/OverheadCableTricepsExtension", -0.6, 0.802, (-0.027,-0.05,0.018)),
 "Dumbbell Overhead Triceps Extension": ("Triceps/DumbbellOverheadTricepsExtension", -0.6, 0.766, (-0.016,-0.039,0.011)),
 "Skull Crusher": ("Triceps/SkullCrusher", -1.0, 0.781, (-0.046,0.124,0.072)),
 "Bench Dip": ("Triceps/BenchDip", -1.0, 0.893, (0.009,0.135,-0.014)),
 "Assisted Dip": ("Triceps/AssistedDip", -0.6, 0.658, (-0.005,-0.042,0.004)),
 "Squat": ("Legs/Squat", 0, 1.0, (0,0.10,0)),
 "Lunge": ("Legs/Lunge", 0, 1.0, (0,0.10,0)),
 "Bulgarian Split Squat": ("Legs/BulgarianSplitSquatUpright", 0, 1.0, (0,0.10,0)),
 "Bulgarian Split Squat (Lean)": ("Legs/BulgarianSplitSquatLean", 0, 1.0, (0,0.10,0)),
 "Step-Up": ("Legs/StepUp", -0.9, 0.745, (0.03,-0.049,-0.038)),
 "Single-Leg Glute Bridge": ("Legs/SingleLegGluteBridge", PI/2, 0.62, (0,0.52,0)),
 "Push-Up": ("Chest/pushup", PI/2, 0.62, (0,0.30,0)),
 "Plank": ("Abs/Plank", PI/2, 0.62, (0,0.52,0)),
 # The three gated exercises re-exported, plus the lean lunge (2026-09-24).
 # "Squat" and "Lunge" above were the legacy models; these replace them.
 "Biceps Curl": ("Biceps/BicepsCurl", -0.4, 0.885, (0.023,0.026,-0.010)),
 "Squat": ("Legs/Squat", -0.5, 0.883, (0.070,0.026,-0.038)),
 "Lunge": ("Legs/Lunge", -1.3, 0.824, (0.051,0.054,-0.183)),
 "Lunge (Lean)": ("Legs/LungeLean", -1.3, 0.823, (0.051,0.074,-0.183)),
 # Back Squat after its barbell was grafted back on (graft_bar.py): framed
 # three-quarter so the 2.2 m bar stops cropping and depth reads.
 "Back Squat": ("Legs/BackSquat", -1.0, 0.828, (-0.021,0.019,0.033)),
 # Chest batch 101-131 (2026-09-25), solved at 382x655 (solve_all.py with ASPECT).
 "Dumbbell Floor Press": ("Chest/DumbbellFloorPress", -1.0, 0.722, (-0.009,0.207,0.014)),
 "Barbell Floor Press": ("Chest/BarbellFloorPress", -1.0, 0.582, (-0.038,0.14,0.059)),
 "Smith Machine Bench Press": ("Chest/SmithMachineBenchPress", -1.0, 0.537, (-0.054,-0.03,0.084)),
 "Smith Machine Incline Press": ("Chest/SmithMachineInclinePress", -1.0, 0.671, (-0.035,0.025,0.054)),
 "Smith Machine Decline Press": ("Chest/SmithMachineDeclinePress", -1.0, 0.51, (-0.04,-0.029,0.063)),
 "Single-Arm Dumbbell Bench Press": ("Chest/SingleArmDumbbellBenchPress", -1.0, 0.732, (-0.034,0.124,0.053)),
 "Alternating Dumbbell Bench Press": ("Chest/AlternatingDumbbellBenchPress", -1.0, 0.76, (-0.018,0.122,0.028)),
 "Neutral-Grip Dumbbell Press": ("Chest/NeutralGripDumbbellPress", -1.0, 0.76, (-0.018,0.124,0.028)),
 "Dumbbell Squeeze Press": ("Chest/DumbbellSqueezePress", -1.0, 0.76, (-0.018,0.129,0.028)),
 "Incline Dumbbell Squeeze Press": ("Chest/InclineDumbbellSqueezePress", -1.0, 0.761, (-0.029,0.08,0.045)),
 "Dumbbell Pullover": ("Chest/DumbbellPullover", -1.3, 0.625, (-0.027,0.113,0.096)),
 "Barbell Pullover": ("Chest/BarbellPullover", -1.3, 0.504, (-0.037,0.054,0.132)),
 "Cable Chest Press": ("Chest/CableChestPress", -0.7, 0.896, (0.05,0.036,-0.042)),
 "Single-Arm Cable Chest Press": ("Chest/SingleArmCableChestPress", -0.7, 0.896, (-0.017,0.036,0.015)),
 "Incline Cable Press": ("Chest/InclineCablePress", -1.0, 0.81, (-0.009,0.102,0.013)),
 "Decline Cable Press": ("Chest/DeclineCablePress", -1.0, 0.692, (0.003,0.154,-0.004)),
 "High-to-Low Cable Fly": ("Chest/HighToLowCableFly", 0, 0.629, (0.0,0.025,0.0)),
 "Single-Arm Cable Fly": ("Chest/SingleArmCableFly", 0, 0.698, (-0.158,-0.01,0.0)),
 "Incline Cable Fly": ("Chest/InclineCableFly", -1.0, 0.722, (-0.025,0.09,0.039)),
 "Decline Cable Fly": ("Chest/DeclineCableFly", -1.0, 0.516, (-0.047,-0.027,0.074)),
 "Cable Crossover": ("Chest/CableCrossover", 0, 0.629, (0.0,0.025,0.0)),
 "Iso-Lateral Chest Press": ("Chest/IsoLateralChestPress", -0.7, 0.82, (-0.002,-0.003,0.002)),
 "Incline Chest Press Machine": ("Chest/InclineChestPressMachine", -0.7, 0.952, (-0.002,0.082,0.002)),
 "Decline Chest Press Machine": ("Chest/DeclineChestPressMachine", -0.7, 0.91, (0.062,0.106,-0.052)),
 "Plate-Loaded Chest Press": ("Chest/PlateLoadedChestPress", -0.7, 0.95, (0.041,0.107,-0.035)),
 "Wide-Grip Chest Press Machine": ("Chest/WideGripChestPressMachine", -0.7, 0.885, (0.037,0.105,-0.031)),
 "Single-Arm Landmine Press": ("Chest/SingleArmLandminePress", -0.6, 0.543, (0.145,0.042,-0.099)),
 "Incline Push-Up": ("Chest/InclinePushUp", -1.35, 0.595, (0.007,0.094,-0.032)),
 # Batch 133-160 (2026-09-25), solved at 382x655 (solve_all.py with ASPECT).
 "Diamond Push-Up": ("Chest/DiamondPushUp", -1.2, 0.557, (-0.001,0.185,0.003)),
 "Wide-Grip Push-Up": ("Chest/WideGripPushUp", -0.8, 0.659, (0.005,0.231,-0.005)),
 "Archer Push-Up": ("Chest/ArcherPushUp", -0.8, 0.642, (0.019,0.225,-0.019)),
 "Medicine Ball Push-Up": ("Chest/MedicineBallPushUp", -1.2, 0.564, (-0.003,0.143,0.007)),
 "Pause Bench Press": ("Chest/PauseBenchPress", -1.0, 0.607, (-0.046,0.069,0.072)),
 "Larsen Press": ("Chest/LarsenPress", -1.0, 0.502, (-0.011,0.058,0.017)),
 "Reverse-Grip Bench Press": ("Chest/ReverseGripBenchPress", -1.0, 0.607, (-0.046,0.069,0.072)),
 "Rack Pull": ("Back/RackPull", -2.5, 0.586, (-0.015,0.028,-0.011)),
 "Block Pull": ("Back/BlockPull", -2.0, 0.856, (-0.027,0.057,-0.059)),
 "Sumo Deadlift": ("Back/SumoDeadlift", -2.0, 0.877, (-0.018,0.045,-0.039)),
 "Trap Bar Deadlift": ("Back/TrapBarDeadlift", -2.0, 0.868, (0.029,0.032,0.062)),
 "Snatch-Grip Deadlift": ("Back/SnatchGripDeadlift", -2.0, 0.843, (-0.009,0.034,-0.02)),
 "Deficit Deadlift": ("Back/DeficitDeadlift", -2.0, 0.812, (-0.008,0.006,-0.018)),
 "Barbell Yates Row": ("Back/BarbellYatesRow", -2.0, 0.995, (-0.032,0.113,-0.07)),
 "Reverse-Grip Barbell Row": ("Back/ReverseGripBarbellRow", -2.0, 0.908, (-0.042,0.153,-0.092)),
 "Wide-Grip Barbell Row": ("Back/WideGripBarbellRow", -2.0, 0.867, (-0.046,0.165,-0.1)),
 "Seal Row": ("Back/SealRow", -1.4, 0.55, (-0.009,0.091,0.055)),
 "Meadows Row": ("Back/MeadowsRow", 2.71, 1.035, (0.165,0.231,-0.076)),
 "Landmine Row": ("Back/LandmineRow", -2.0, 1.098, (-0.025,0.177,-0.056)),
 "Single-Arm Landmine Row": ("Back/SingleArmLandmineRow", -2.0, 0.993, (-0.03,0.157,-0.066)),
 "Dumbbell Bent-Over Row": ("Back/DumbbellBentOverRow", -2.0, 1.11, (-0.023,0.174,-0.05)),
 "Renegade Row": ("Back/RenegadeRow", -1.3, 0.566, (-0.009,0.148,0.032)),
 "Kettlebell Row": ("Back/KettlebellRow", -2.0, 1.099, (-0.02,0.166,-0.044)),
 "Gorilla Row": ("Back/GorillaRow", -2.0, 1.089, (-0.025,0.271,-0.054)),
 "Inverted Row": ("Back/InvertedRow", -1.35, 0.582, (0.01,0.131,-0.043)),
 "Feet-Elevated Inverted Row": ("Back/FeetElevatedInvertedRow", -1.35, 0.558, (0.009,0.096,-0.038)),
 "Underhand Inverted Row": ("Back/UnderhandInvertedRow", -1.35, 0.578, (0.009,0.131,-0.041)),
 # Batch 161-190 (2026-09-25), solved at 382x655 (solve_all.py with ASPECT).
 "Wide-Grip Pull-Up": ("Back/WideGripPullUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Neutral-Grip Pull-Up": ("Back/NeutralGripPullUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Archer Pull-Up": ("Back/ArcherPullUp", -2.6, 0.516, (0.005,-0.078,0.003)),
 "Weighted Pull-Up": ("Back/WeightedPullUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Assisted Pull-Up": ("Back/AssistedPullUp", -2.6, 0.58, (0.009,-0.073,0.005)),
 "Neutral-Grip Chin-Up": ("Back/NeutralGripChinUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Weighted Chin-Up": ("Back/WeightedChinUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Machine Pull-Up": ("Back/MachinePullUp", -2.6, 0.58, (0.009,-0.077,0.005)),
 "Wide-Grip Lat Pulldown": ("Back/WideGripLatPulldown", -2.6, 0.916, (0.017,0.066,0.01)),
 "Reverse-Grip Lat Pulldown": ("Back/ReverseGripLatPulldown", -2.6, 0.909, (0.015,0.062,0.009)),
 "Neutral-Grip Lat Pulldown": ("Back/NeutralGripLatPulldown", -2.6, 0.901, (0.019,0.057,0.011)),
 "V-Bar Lat Pulldown": ("Back/VBarLatPulldown", -2.6, 0.91, (0.012,0.062,0.007)),
 "Single-Arm Lat Pulldown": ("Back/SingleArmLatPulldown", -2.6, 0.899, (0.022,0.056,0.013)),
 "Kneeling Lat Pulldown": ("Back/KneelingLatPulldown", -2.6, 0.894, (0.025,0.053,0.015)),
 "Rope Lat Pulldown": ("Back/RopeLatPulldown", -2.6, 0.801, (0.011,-0.002,0.006)),
 "Machine Lat Pulldown": ("Back/MachineLatPulldown", -2.6, 0.881, (0.006,0.045,0.004)),
 "Iso-Lateral Lat Pulldown": ("Back/IsoLateralLatPulldown", -2.6, 0.886, (0.004,0.048,0.002)),
 "Wide-Grip Seated Cable Row": ("Back/WideGripSeatedCableRow", -2.2, 0.851, (-0.01,0.109,-0.013)),
 "Close-Grip Seated Cable Row": ("Back/CloseGripSeatedCableRow", -2.2, 0.936, (-0.028,0.12,-0.039)),
 "Single-Arm Cable Row": ("Back/SingleArmCableRow", -2.2, 0.902, (-0.021,0.116,-0.029)),
 "Standing Cable Row": ("Back/StandingCableRow", -2.2, 0.88, (-0.022,0.042,-0.03)),
 "Half-Kneeling Cable Row": ("Back/HalfKneelingCableRow", -2.2, 0.807, (0.025,0.117,0.035)),
 "High Cable Row": ("Back/HighCableRow", -2.2, 0.916, (-0.024,0.117,-0.033)),
 "Low Cable Row": ("Back/LowCableRow", -2.2, 0.902, (-0.021,0.116,-0.029)),
 "Machine Seated Row": ("Back/MachineSeatedRow", -2.4, 0.978, (-0.029,0.119,-0.027)),
 "Iso-Lateral Row Machine": ("Back/IsoLateralRowMachine", -2.4, 0.979, (-0.029,0.119,-0.027)),
 "Single-Arm Machine Row": ("Back/SingleArmMachineRow", -2.4, 1.017, (-0.053,0.124,-0.049)),
 "Reverse-Grip T-Bar Row": ("Back/ReverseGripTBarRow", -2.0, 1.051, (-0.03,0.169,-0.065)),
 "Dumbbell Pullover Row": ("Back/DumbbellPulloverRow", -1.3, 0.58, (-0.029,0.087,0.106)),
 "Machine Pullover": ("Back/MachinePullover", -0.9, 0.947, (-0.017,0.069,0.021)),
 # Batch 191-240 (2026-09-26), solved at 382x655 (solve_all.py with ASPECT).
 "Seated Barbell Overhead Press": ("Shoulder/SeatedBarbellOverheadPress", -0.8, 0.634, (-0.029,-0.024,0.03)),
 "Behind-the-Neck Press": ("Shoulder/BehindTheNeckPress", -0.8, 0.664, (-0.056,-0.079,0.058)),
 "Push Press": ("Shoulder/PushPress", -0.8, 0.628, (-0.014,-0.076,0.015)),
 "Dumbbell Push Press": ("Shoulder/DumbbellPushPress", -0.5, 0.742, (0.013,-0.053,-0.007)),
 "Standing Dumbbell Press": ("Shoulder/StandingDumbbellPress", -0.5, 0.728, (-0.005,-0.051,0.003)),
 "Seated Dumbbell Press": ("Shoulder/SeatedDumbbellPress", -0.5, 0.833, (-0.001,0.016,0.0)),
 "Neutral-Grip Dumbbell Shoulder Press": ("Shoulder/NeutralGripDumbbellShoulderPress", -0.6, 0.783, (0.001,0.045,0.0)),
 "Single-Arm Dumbbell Shoulder Press": ("Shoulder/SingleArmDumbbellShoulderPress", -0.5, 0.727, (-0.04,-0.052,0.022)),
 "Z Press": ("Shoulder/ZPress", -1.3, 0.721, (0.014,0.052,-0.049)),
 "Landmine Shoulder Press": ("Shoulder/LandmineShoulderPress", -1.0, 0.76, (-0.004,0.001,0.006)),
 "Half-Kneeling Landmine Press": ("Shoulder/KneelingLandminePress", -1.0, 0.863, (0.002,0.078,-0.003)),
 "Cable Shoulder Press": ("Shoulder/CableShoulderPress", -0.5, 0.679, (-0.089,-0.032,0.049)),
 "Single-Arm Cable Shoulder Press": ("Shoulder/SingleArmCableShoulderPress", -0.5, 0.76, (-0.026,-0.043,0.014)),
 "Smith Machine Shoulder Press": ("Shoulder/SmithMachineShoulderPress", -0.6, 0.843, (0.031,0.061,-0.021)),
 "Viking Press": ("Shoulder/VikingPress", -1.0, 0.791, (0.013,-0.009,-0.021)),
 "Leaning Lateral Raise": ("Shoulder/LeaningLateralRaise", -0.3, 0.726, (-0.015,0.038,0.005)),
 "Incline Lateral Raise": ("Shoulder/InclineLateralRaise", 1.0, 0.779, (0.064,0.033,0.1)),
 "Chest-Supported Lateral Raise": ("Shoulder/ChestSupportedLateralRaise", -2.8, 0.664, (-0.072,0.111,-0.025)),
 "Y-Raise": ("Shoulder/YRaise", -2.8, 0.752, (-0.06,0.069,-0.021)),
 "Cable Y-Raise": ("Shoulder/CableYRaise", -2.95, 0.812, (-0.028,0.004,-0.006)),
 "Lu Raise": ("Shoulder/LuRaise", -0.25, 0.62, (-0.012,-0.04,0.003)),
 "Plate Front Raise": ("Shoulder/PlateFrontRaise", -0.55, 0.884, (0.042,0.039,-0.026)),
 "Barbell Front Raise": ("Shoulder/BarbellFrontRaise", -1.0, 0.613, (0.024,0.016,-0.038)),
 "Cable Front Raise": ("Shoulder/CableFrontRaise", -0.55, 0.882, (0.064,0.04,-0.039)),
 "Alternating Dumbbell Front Raise": ("Shoulder/AlternatingDumbbellFrontRaise", -0.55, 0.884, (0.056,0.039,-0.034)),
 "Cable External Rotation": ("Shoulder/CableExternalRotation", -0.3, 0.891, (-0.053,0.038,0.016)),
 "Cable Internal Rotation": ("Shoulder/CableInternalRotation", -0.3, 0.891, (-0.053,0.038,0.016)),
 "Powell Raise": ("Shoulder/PowellRaise", 0.8, 0.672, (0.075,0.071,0.077)),
 "Rear Delt Row": ("Shoulder/RearDeltRow", -2.3, 1.024, (-0.047,0.127,-0.053)),
 "Machine Rear Delt Row": ("Shoulder/MachineRearDeltRow", 2.4, 0.866, (0.019,0.102,-0.017)),
 "Barbell Upright Row": ("Shoulder/BarbellUprightRow", -0.8, 0.652, (-0.006,0.027,0.006)),
 "Cable Upright Row": ("Shoulder/CableUprightRow", 0.6, 0.882, (0.012,0.04,0.008)),
 "Smith Machine Upright Row": ("Shoulder/SmithMachineUprightRow", -0.5, 0.885, (-0.01,0.039,0.005)),
 "Dumbbell Shrug": ("Back/DumbbellShrug", -0.5, 0.885, (-0.024,0.04,0.013)),
 "Barbell Shrug": ("Back/BarbellShrug", -0.8, 0.671, (-0.023,0.028,0.024)),
 "Smith Machine Shrug": ("Back/SmithMachineShrug", -0.5, 0.885, (0.003,0.04,-0.002)),
 "Cable Shrug": ("Back/CableShrug", -0.5, 0.885, (-0.026,0.04,0.014)),
 "Trap Bar Shrug": ("Back/TrapBarShrug", -0.8, 0.878, (-0.024,0.04,0.024)),
 "Behind-the-Back Barbell Shrug": ("Back/BehindTheBackBarbellShrug", -2.4, 0.617, (0.02,0.023,0.018)),
 "Farmer's Carry": ("Abs/FarmersCarry", -0.6, 0.888, (-0.002,0.03,0.001)),
 "Suitcase Carry": ("Abs/SuitcaseCarry", -0.3, 0.883, (-0.023,0.039,0.007)),
 "Overhead Carry": ("Abs/OverheadCarry", -1.0, 0.712, (-0.029,-0.056,0.045)),
 "Alternating Dumbbell Curl": ("Biceps/AlternatingDumbbellCurl", -0.4, 0.888, (0.029,0.039,-0.012)),
 "Spider Curl": ("Biceps/SpiderCurl", -2.0, 0.499, (-0.036,0.057,-0.078)),
 "Dumbbell Preacher Curl": ("Biceps/DumbbellPreacherCurl", -1.1, 0.994, (-0.024,0.119,0.048)),
 "Machine Biceps Curl": ("Biceps/MachineBicepsCurl", -1.0, 1.032, (-0.025,0.142,0.038)),
 # Legs 300-350 (2026-09-26).
 "Forward Lunge": ("Legs/ForwardLunge", -1.3, 0.703, (0.042,0.037,-0.151)),
 "Barbell Lunge": ("Legs/BarbellLunge", -0.6, 0.690, (0.057,0.057,-0.039)),
 "Smith Machine Reverse Lunge": ("Legs/SmithMachineReverseLunge", -1.0, 0.885, (-0.095,0.042,0.148)),
 "Curtsy Lunge": ("Legs/CurtsyLunge", -0.5, 0.892, (0.008,0.031,-0.004)),
 "Barbell Split Squat": ("Legs/BarbellSplitSquat", -1.3, 0.861, (-0.014,0.050,0.051)),
 "Dumbbell Split Squat": ("Legs/DumbbellSplitSquat", -1.3, 0.893, (-0.012,0.067,0.042)),
 "Smith Machine Split Squat": ("Legs/SmithMachineSplitSquat", -1.0, 0.903, (-0.017,0.075,0.026)),
 "Front-Foot-Elevated Split Squat": ("Legs/FrontFootElevatedSplitSquat", -1.3, 0.905, (-0.020,0.044,0.071)),
 "Rear-Foot-Elevated Split Squat": ("Legs/RearFootElevatedSplitSquat", -1.3, 0.834, (-0.006,0.063,0.023)),
 "Barbell Bulgarian Split Squat": ("Legs/BarbellBulgarianSplitSquat", -1.0, 0.793, (-0.032,0.057,0.051)),
 "Smith Machine Bulgarian Split Squat": ("Legs/SmithMachineBulgarianSplitSquat", -1.0, 0.897, (-0.007,0.076,0.011)),
 # Late additions (2026-09-27).
 "Seated Dumbbell Lateral Raise": ("Shoulder/SeatedDumbbellLateralRaise", -0.6, 0.653, (0.035,0.097,-0.024)),
 "Cable Rear Delt Row": ("Shoulder/CableRearDeltRow", -2.6, 0.867, (0.007,0.114,0.004)),
 "Dumbbell Upright Row": ("Shoulder/DumbbellUprightRow", -0.5, 0.885, (0.003,0.039,-0.002)),
 "Barbell Hip Thrust": ("Legs/BarbellHipThrust", -0.7, 0.879, (0.002,0.274,-0.002)),
 # Batch 241-300 (2026-09-27).
 "Single-Arm Machine Curl": ("Biceps/SingleArmMachineCurl", -1.0, 1.032, (-0.025,0.142,0.038)),
 "Cable Preacher Curl": ("Biceps/CablePreacherCurl", 1.1, 0.994, (0.022,0.119,0.043)),
 "Single-Arm Cable Curl": ("Biceps/SingleArmCableCurl", -1.5, 0.875, (-0.002,0.037,0.026)),
 "High Cable Curl": ("Biceps/HighCableCurl", -0.3, 0.652, (-0.012,0.015,0.004)),
 "Overhead Cable Curl": ("Biceps/OverheadCableCurl", -1.3, 0.867, (-0.074,0.022,0.266)),
 "Cable Hammer Curl": ("Biceps/CableHammerCurl", 1.4, 0.874, (0.0,0.038,0.001)),
 "Preacher Hammer Curl": ("Biceps/PreacherHammerCurl", -1.1, 0.994, (-0.024,0.119,0.048)),
 "Drag Curl": ("Biceps/DragCurl", -0.8, 0.653, (-0.008,0.027,0.008)),
 "EZ Bar Drag Curl": ("Biceps/EZBarDragCurl", -0.3, 0.891, (-0.012,0.038,0.004)),
 "Cable Drag Curl": ("Biceps/CableDragCurl", 1.1, 0.874, (0.023,0.039,0.046)),
 "Reverse Preacher Curl": ("Biceps/ReversePreacherCurl", -0.8, 1.0, (-0.02,0.123,0.02)),
 "Barbell Preacher Curl": ("Biceps/BarbellPreacherCurl", -0.8, 0.602, (-0.003,0.051,0.003)),
 "Dumbbell Spider Curl": ("Biceps/DumbbellSpiderCurl", -2.0, 0.599, (-0.018,0.069,-0.039)),
 "EZ Bar Spider Curl": ("Biceps/EZBarSpiderCurl", -2.0, 0.606, (-0.025,0.076,-0.055)),
 "Alternating Hammer Curl": ("Biceps/AlternatingHammerCurl", -0.4, 0.888, (0.003,0.039,-0.001)),
 "Dumbbell Wrist Curl": ("Forearms/DumbbellWristCurl", -0.7, 1.009, (0.142,0.23,-0.119)),
 "Barbell Reverse Wrist Curl": ("Forearms/BarbellReverseWristCurl", -1.0, 0.75, (0.1,0.172,-0.155)),
 "Dumbbell Reverse Wrist Curl": ("Forearms/DumbbellReverseWristCurl", -0.7, 1.009, (0.142,0.23,-0.119)),
 "Cable Wrist Curl": ("Forearms/CableWristCurl", 1.0, 0.932, (-0.097,0.195,-0.151)),
 "Cable Reverse Wrist Curl": ("Forearms/CableReverseWristCurl", 1.0, 0.932, (-0.097,0.195,-0.151)),
 "Behind-the-Back Wrist Curl": ("Forearms/BehindTheBackWristCurl", -2.4, 0.608, (0.023,0.023,0.021)),
 "Finger Curl": ("Forearms/FingerCurl", -1.0, 0.746, (0.106,0.171,-0.164)),
 "Plate Pinch Hold": ("Forearms/PlatePinchHold", -0.5, 0.887, (-0.023,0.041,0.012)),
 "Dumbbell Static Hold": ("Forearms/DumbbellStaticHold", -0.5, 0.885, (-0.023,0.04,0.012)),
 "Barbell Static Hold": ("Forearms/BarbellStaticHold", -0.8, 0.668, (-0.012,0.028,0.012)),
 "Towel Grip Hold": ("Forearms/TowelGripHold", -0.5, 0.75, (-0.023,-0.04,0.013)),
 # 30-leg set 02-27 (2026-09-28).
 "Lateral Lunge": ("Legs/LateralLunge", -0.3, 0.598, (-0.01,0.019,0.003)),
 "Cossack Squat": ("Legs/CossackSquat", -0.3, 0.659, (0.005,0.04,-0.002)),
 "Dumbbell Sumo Squat": ("Legs/DumbbellSumoSquat", -0.5, 0.905, (0.008,0.039,-0.004)),
 "Barbell Sumo Squat": ("Legs/BarbellSumoSquat", -0.8, 0.7, (-0.028,0.032,0.029)),
 "Kettlebell Goblet Squat": ("Legs/KettlebellGobletSquat", -0.5, 0.883, (0.037,0.026,-0.02)),
 "Box Squat": ("Legs/BoxSquat", -1.0, 0.847, (-0.025,0.019,0.039)),
 "Pause Squat": ("Legs/PauseSquat", -1.0, 0.85, (-0.026,0.017,0.04)),
 "Safety Bar Squat": ("Legs/SafetyBarSquat", -1.0, 0.776, (-0.003,0.026,0.005)),
 "Zercher Squat": ("Legs/ZercherSquat", -1.0, 0.809, (-0.003,0.027,0.004)),
 "Overhead Squat": ("Legs/OverheadSquat", -0.8, 0.698, (-0.029,-0.076,0.03)),
 "Landmine Squat": ("Legs/LandmineSquat", -0.9, 0.884, (0.034,0.03,-0.043)),
 "Belt Squat": ("Legs/BeltSquat", -1.5, 0.767, (0.004,-0.034,-0.061)),
 "Pendulum Squat": ("Legs/PendulumSquat", -1.3, 0.751, (-0.024,-0.018,0.088)),
 "V-Squat": ("Legs/VSquat", -1.3, 0.778, (-0.003,0.024,0.012)),
 "Vertical Leg Press": ("Legs/VerticalLegPress", -2.2, 0.861, (0.145,0.118,0.199)),
 "45-Degree Leg Press": ("Legs/LegPress45", -2.0, 0.681, (0.049,0.122,0.108)),
 "Single-Leg Press": ("Legs/SingleLegPress", -2.0, 0.681, (0.049,0.122,0.108)),
 "Narrow-Stance Leg Press": ("Legs/NarrowStanceLegPress", -2.0, 0.704, (0.055,0.127,0.121)),
 "Wide-Stance Leg Press": ("Legs/WideStanceLegPress", -2.0, 0.656, (0.043,0.119,0.094)),
 "Heel-Elevated Squat": ("Legs/HeelElevatedSquat", -1.0, 0.832, (-0.02,0.019,0.031)),
 "Cyclist Squat": ("Legs/CyclistSquat", -1.0, 0.863, (-0.032,0.019,0.05)),
 "Pistol Squat": ("Legs/PistolSquat", -1.2, 0.874, (0.05,0.026,-0.127)),
 "Assisted Pistol Squat": ("Legs/AssistedPistolSquat", -1.6, 0.878, (-0.005,0.03,-0.159)),
 # Calves 083-087 (2026-09-28).
 "Standing Calf Raise": ("Legs/StandingCalfRaise", -1.3, 0.76, (-0.003,-0.038,0.01)),
 "Seated Calf Raise": ("Legs/SeatedCalfRaise", -1.3, 0.993, (-0.028,0.094,0.1)),
 "Leg Press Calf Raise": ("Legs/LegPressCalfRaise", -2.4, 0.721, (0.148,0.108,0.136)),
 "Single-Leg Calf Raise": ("Legs/SingleLegCalfRaise", -1.3, 0.752, (-0.025,-0.043,0.09)),
 "Smith Machine Calf Raise": ("Legs/SmithMachineCalfRaise", -0.8, 0.628, (-0.115,-0.033,0.119)),
 # Exercises 1-50 redone (2026-09-29): the replaced models whose content
 # predates this script (chest and back), then the nine new exercises.
 "Barbell Bench Press": ("Chest/BarbellBenchPress", -1.0, 0.66, (-0.05,0.04,0.08)),
 "Incline Barbell Bench Press": ("Chest/InclineBarbellBenchPress", -1.0, 0.66, (-0.05,0.04,0.08)),
 "Decline Barbell Bench Press": ("Chest/DeclineBarbellBenchPress", -1.0, 0.66, (-0.05,0.04,0.08)),
 "Dumbbell Bench Press": ("Chest/DumbbellBenchPress", -1.0, 0.66, (-0.05,0.04,0.08)),
 "Incline Dumbbell Press": ("Chest/InclineDumbbellPress", -1.0, 0.66, (-0.05,0.04,0.08)),
 "Dumbbell Fly": ("Chest/DumbbellFly", -1.0, 0.66, (-0.05,0.04,0.08)),
 "Incline Dumbbell Fly": ("Chest/InclineDumbbellFly", -1.0, 0.66, (-0.05,0.04,0.08)),
 "Chest Press Machine": ("Chest/ChestPressMachine", -0.7, 0.62, (-0.023,0.03,0.019)),
 "Pec Deck Fly": ("Chest/PecDeckFly", 0, 0.68, (0,0.03,0)),
 "Cable Fly": ("Chest/CableFly", 0, 0.85, (0,0.03,0)),
 "Low-to-High Cable Fly": ("Chest/LowToHighCableFly", 0, 0.913, (0,0.037,0)),
 "Deadlift": ("Back/ConventionalDeadlift", -2, 0.866, (-0.048,0.031,-0.104)),
 "Barbell Bent-Over Row": ("Back/BarbellBentOverRow", -2, 0.856, (-0.053,0.143,-0.117)),
 "One-Arm Dumbbell Row": ("Back/OneArmDumbbellRow", -2, 0.86, (-0.001,0.118,-0.003)),
 "Chest-Supported Dumbbell Row": ("Back/ChestSupportedDumbbellRow", -2, 1.215, (-0.027,0.233,-0.06)),
 "Straight-Arm Pulldown": ("Back/StraightArmPulldown", -2.5, 0.94, (-0.063,0.044,-0.047)),
 "T-Bar Row": ("Back/TBarRow", -2.7, 0.809, (0.135,0.18,0.064)),
 "Chest-Supported Row Machine": ("Back/ChestSupportedRowMachine", 2.4, 1.065, (0.023,0.152,-0.021)),
 "Back Extension": ("Back/BackExtension", -1.9, 0.637, (-0.013,0.057,-0.037)),
 "Pendlay Row": ("Back/PendlayRow", -2.0, 0.803, (-0.058,0.219,-0.126)),
 "Dumbbell Curl": ("Biceps/DumbbellCurl", -0.4, 0.892, (0.016,0.03,-0.007)),
 "Incline Dumbbell Curl": ("Biceps/InclineDumbbellCurl", -0.9, 0.975, (-0.028,0.149,0.036)),
 "Preacher Curl": ("Biceps/PreacherCurl", -0.8, 0.969, (0.063,0.123,-0.065)),
 "Cable Curl": ("Biceps/CableCurl", -1.4, 0.883, (0.004,0.043,-0.023)),
 "Bayesian Cable Curl": ("Biceps/BayesianCableCurl", -1.2, 0.877, (-0.019,0.028,0.049)),
 "Reverse Curl": ("Biceps/ReverseCurl", -0.4, 0.823, (0.031,0.03,-0.013)),
 "Wrist Curl": ("Forearms/WristCurl", -0.7, 0.918, (0.024,0.124,-0.02)),
 "Close-Grip Bench Press": ("Triceps/CloseGripBenchPress", -1.0, 0.66, (-0.05,0.04,0.08)),
 # Redone 190-280 folder (2026-09-30): new.
 "Machine Preacher Curl": ("Biceps/MachinePreacherCurl", -1.0, 1.032, (-0.024,0.142,0.037)),
 # The "351-400" folder (2026-09-30): new hamstring, glute and hip exercises.
 "Single-Leg Romanian Deadlift": ("Legs/SingleLegRomanianDeadlift", -1.3, 0.599, (-0.024,0.011,0.087)),
 "Barbell Single-Leg Romanian Deadlift": ("Legs/BarbellSingleLegRomanianDeadlift", -1.3, 0.599, (-0.024,0.011,0.087)),
 "Dumbbell Single-Leg Romanian Deadlift": ("Legs/DumbbellSingleLegRomanianDeadlift", -1.3, 0.599, (-0.024,0.011,0.087)),
 "B-Stance Romanian Deadlift": ("Legs/BStanceRomanianDeadlift", -1.3, 0.897, (0.011,0.019,-0.04)),
 "Smith Machine Romanian Deadlift": ("Legs/SmithMachineRomanianDeadlift", -1.0, 0.915, (0.021,0.025,-0.032)),
 "Cable Romanian Deadlift": ("Legs/CableRomanianDeadlift", -1.0, 0.902, (0.031,0.021,-0.048)),
 "Kettlebell Romanian Deadlift": ("Legs/KettlebellRomanianDeadlift", -0.8, 0.904, (0.034,0.02,-0.035)),
 "Good Morning": ("Legs/GoodMorning", -2.3, 0.644, (-0.032,0.012,-0.035)),
 "Seated Good Morning": ("Legs/SeatedGoodMorning", -2.3, 0.593, (-0.026,0.057,-0.029)),
 "Smith Machine Good Morning": ("Legs/SmithMachineGoodMorning", -1.0, 0.926, (-0.04,0.019,0.062)),
 "Nordic Hamstring Curl": ("Legs/NordicHamstringCurl", -1.4, 0.556, (0.016,0.027,-0.096)),
 "Assisted Nordic Curl": ("Legs/AssistedNordicCurl", -1.4, 0.556, (0.016,0.027,-0.096)),
 "Glute-Ham Raise": ("Legs/GluteHamRaise", -1.4, 0.46, (0.003,-0.047,-0.018)),
 "Standing Leg Curl": ("Legs/StandingLegCurl", -1.3, 0.901, (-0.016,0.002,0.059)),
 "Kneeling Leg Curl": ("Legs/KneelingLegCurl", -1.3, 0.815, (0.002,0.043,-0.006)),
 "Cable Standing Leg Curl": ("Legs/CableStandingLegCurl", -1.3, 0.921, (-0.017,0.012,0.06)),
 "Swiss Ball Leg Curl": ("Legs/SwissBallLegCurl", -1.35, 0.603, (-0.013,0.129,0.057)),
 "Sliding Leg Curl": ("Legs/SlidingLegCurl", -1.35, 0.507, (-0.015,0.177,0.069)),
 "Single-Leg Sliding Curl": ("Legs/SingleLegSlidingCurl", -1.35, 0.511, (-0.016,0.132,0.071)),
 "Frog Pump": ("Legs/FrogPump", -1.57, 0.722, (0.0,0.282,0.125)),
 "Weighted Frog Pump": ("Legs/WeightedFrogPump", -1.57, 0.722, (0.0,0.239,0.125)),
 "Dumbbell Deadlift": ("Legs/DumbbellDeadlift", -0.8, 0.901, (0.021,0.018,-0.021)),
 "Cable Hip Adduction": ("Legs/CableHipAdduction", -0.3, 0.918, (-0.04,0.019,0.012)),
 "Standing Hip Abduction": ("Legs/StandingHipAbduction", -0.3, 0.914, (0.002,0.056,-0.001)),
 "Side-Lying Hip Abduction": ("Legs/SideLyingHipAbduction", 3.14, 0.482, (0.0,0.135,0.0)),
 "Banded Hip Abduction": ("Legs/BandedHipAbduction", -0.3, 1.052, (0.022,0.136,-0.007)),
 "Clamshell": ("Legs/Clamshell", 3.14, 0.643, (0.058,0.226,0.0)),
 # Exercises 51-150 redone (2026-09-30): models whose content predates this script.
 "Goblet Squat": ("Legs/GobletSquat", 0.0, 0.899, (0.0,0.03,0.0)),
 "Walking Lunge": ("Legs/WalkingLunge", 0.0, 0.649, (0.0,0.01,0.0)),
 "Reverse Lunge": ("Legs/ReverseLunge", 0.0, 0.897, (0.0,0.028,0.0)),
 "Leg Press": ("Legs/LegPress", -2.0, 0.683, (0.037,0.06,0.081)),
 "Romanian Deadlift": ("Legs/RomanianDeadlift", 0.0, 0.597, (0.0,0.019,0.0)),
 "Dumbbell Romanian Deadlift": ("Legs/DumbbellRomanianDeadlift", -0.8, 0.883, (0.034,0.029,-0.035)),
 "Stiff-Leg Deadlift": ("Legs/StiffLegDeadlift", -0.8, 0.666, (-0.007,0.021,0.007)),
 "Seated Leg Curl": ("Legs/SeatedLegCurl", -0.9, 0.813, (0.053,0.041,-0.067)),
 "Single-Leg Curl": ("Legs/SingleLegCurl", -1.35, 0.551, (-0.006,0.107,0.029)),
 "Glute Bridge": ("Legs/GluteBridge", -1.35, 0.474, (-0.015,0.168,0.068)),
 "Cable Side Kick": ("Legs/CableSideKick", -0.3, 0.834, (-0.016,0.024,0.005)),
 "Cable Hip Abduction": ("Legs/CableHipAbduction", -0.3, 0.893, (-0.015,0.029,0.005)),
 "Reverse Crunch": ("Abs/ReverseCrunch", -1.35, 0.441, (-0.011,0.113,0.048)),
 "Decline Crunch": ("Abs/DeclineCrunch", -1.35, 0.682, (-0.018,0.132,0.081)),
 "Hanging Knee Raise": ("Abs/HangingKneeRaise", -1.3, 0.674, (-0.002,-0.075,0.006)),
 "Hanging Leg Raise": ("Abs/HangingLegRaise", -1.3, 0.654, (0.015,-0.073,-0.053)),
 # The drive's "401-500" folder (2026-10-04), solved at 382x655.
 "Landmine Chest Press": ("Chest/LandmineChestPress", -0.8, 0.807, (0.054,0.036,-0.056)),
 "Chest Dip": ("Chest/ChestDip", -1.0, 0.785, (-0.045,-0.039,0.069)),
 "Weighted Chest Dip": ("Chest/WeightedChestDip", -1.0, 0.785, (-0.045,-0.039,0.069)),
 "Decline Push-Up": ("Chest/DeclinePushUp", -1.2, 0.521, (-0.025,0.166,0.063)),
 "Plyometric Push-Up": ("Chest/PlyometricPushUp", -1.2, 0.544, (-0.001,0.176,0.002)),
 "Rope Hammer Curl": ("Biceps/RopeHammerCurl", 1.4, 0.871, (-0.003,0.048,-0.019)),
 "Cross-Body Hammer Curl": ("Biceps/CrossBodyHammerCurl", -0.4, 0.878, (-0.002,0.044,0.001)),
 "Incline Hammer Curl": ("Biceps/InclineHammerCurl", -0.9, 0.692, (-0.054,0.146,0.068)),
 "Zottman Curl": ("Biceps/ZottmanCurl", -0.4, 0.878, (0.008,0.044,-0.004)),
 "Strict Curl": ("Biceps/StrictCurl", -1.0, 0.735, (0.007,0.029,-0.011)),
 "21s Curl": ("Biceps/Curl21s", -0.9, 0.698, (-0.006,0.034,0.007)),
 "EZ-Bar 21s": ("Biceps/EZBar21s", -0.4, 0.878, (0.004,0.044,-0.002)),
 "Waiter Curl": ("Biceps/WaiterCurl", -0.5, 0.875, (-0.001,0.044,0.001)),
 "Dumbbell Reverse Curl": ("Biceps/DumbbellReverseCurl", -0.4, 0.878, (0.033,0.044,-0.014)),
 "Seated Dumbbell Curl": ("Biceps/SeatedDumbbellCurl", -0.6, 0.783, (-0.023,0.137,0.016)),
 "Wrist Roller": ("Forearms/WristRoller", -0.7, 0.87, (0.035,0.045,-0.029)),
 "Dumbbell Hip Thrust": ("Legs/DumbbellHipThrust", -0.7, 0.663, (-0.037,0.213,0.031)),
 "Dumbbell Standing Calf Raise": ("Legs/DumbbellStandingCalfRaise", -1.3, 0.833, (0.009,0.02,-0.033)),
 "Single-Leg Dumbbell Calf Raise": ("Legs/SingleLegDumbbellCalfRaise", -1.3, 0.827, (-0.01,-0.052,0.036)),
 "Donkey Calf Raise": ("Legs/DonkeyCalfRaise", -1.3, 0.957, (0.038,0.105,-0.138)),
 "Machine Donkey Calf Raise": ("Legs/MachineDonkeyCalfRaise", -1.3, 0.957, (0.038,0.078,-0.138)),
 "Hack Squat Calf Raise": ("Legs/HackSquatCalfRaise", -0.6, 0.966, (-0.074,-0.02,0.051)),
 "Smith Machine Seated Calf Raise": ("Legs/SmithMachineSeatedCalfRaise", -0.4, 1.091, (0.017,0.162,-0.007)),
 "Barbell Seated Calf Raise": ("Legs/BarbellSeatedCalfRaise", -0.8, 0.694, (0.023,0.091,-0.024)),
 "Dumbbell Seated Calf Raise": ("Legs/DumbbellSeatedCalfRaise", -1.3, 0.954, (0.02,0.135,-0.072)),
 "Single-Leg Seated Calf Raise": ("Legs/SingleLegSeatedCalfRaise", -1.3, 0.991, (0.018,0.138,-0.064)),
 "Single-Leg Machine Calf Raise": ("Legs/SingleLegMachineCalfRaise", -1.3, 0.834, (-0.003,-0.063,0.011)),
 "Calf Press Machine": ("Legs/CalfPressMachine", -1.3, 0.719, (-0.041,-0.006,0.147)),
 "Horizontal Leg Press Calf Raise": ("Legs/HorizontalLegPressCalfRaise", -1.3, 0.647, (-0.006,0.007,0.021)),
 "Bodyweight Standing Calf Raise": ("Legs/BodyweightCalfRaise", -1.3, 0.833, (0.009,0.02,-0.033)),
 # Third round, 445-474 (2026-10-05), framings picked on viewport stills.
 "Toe-to-Bar": ("Abs/ToeToBar", -1.3, 0.659, (0.022,-0.15,-0.077)),
 "Hanging Oblique Knee Raise": ("Abs/HangingObliqueKneeRaise", -0.5, 0.615, (-0.052,-0.097,0.028)),
 "Lying Leg Raise": ("Abs/LyingLegRaise", -1.35, 0.527, (-0.001,0.089,0.003)),
 "Flutter Kick": ("Abs/FlutterKick", -0.8, 0.644, (0.025,0.179,-0.026)),
 "Scissor Kick": ("Abs/ScissorKick", -0.8, 0.619, (0.032,0.19,-0.033)),
 "Mountain Climber": ("Abs/MountainClimber", -0.8, 0.685, (-0.033,0.22,0.034)),
 "Plank Shoulder Tap": ("Abs/PlankShoulderTap", -0.8, 0.686, (-0.033,0.218,0.034)),
 "Plank Hip Dip": ("Abs/PlankHipDip", -0.6, 0.77, (-0.016,0.291,0.011)),
 "Plank Knee to Elbow": ("Abs/PlankKneeToElbow", -0.8, 0.603, (-0.053,0.191,0.055)),
 "RKC Plank": ("Abs/RKCPlank", -1.35, 0.531, (-0.015,0.204,0.065)),
 "Weighted Plank": ("Abs/WeightedPlank", -1.35, 0.535, (-0.018,0.202,0.079)),
 "Side Plank Hip Lift": ("Abs/SidePlankHipLift", 1.5, 0.548, (0.005,0.07,0.077)),
 "Copenhagen Plank": ("Abs/CopenhagenPlank", 1.5, 0.534, (0.005,0.067,0.069)),
 "Cable Side Bend": ("Abs/CableSideBend", 0.4, 0.836, (0.002,0.024,0.001)),
 "Dumbbell Side Bend": ("Abs/DumbbellSideBend", -0.3, 0.828, (-0.015,0.017,0.005)),
 "Reverse Cable Wood Chop": ("Abs/ReverseCableWoodChop", 0.5, 0.792, (-0.032,0.003,-0.017)),
 "Cable Rotation": ("Abs/CableRotation", 0.5, 0.86, (-0.067,0.04,-0.037)),
 "Landmine Rotation": ("Abs/LandmineRotation", -0.3, 0.761, (0.131,0.105,-0.041)),
 "Landmine 180": ("Abs/Landmine180", -0.3, 0.701, (0.097,0.074,-0.03)),
 "Medicine Ball Russian Twist": ("Abs/MedicineBallRussianTwist", -0.5, 0.842, (-0.022,0.27,0.012)),
 "Weighted Russian Twist": ("Abs/WeightedRussianTwist", -0.5, 0.831, (-0.025,0.266,0.014)),
 "Stability Ball Rollout": ("Abs/StabilityBallRollout", -0.8, 0.6, (0.019,0.123,-0.019)),
 "Body Saw": ("Abs/BodySaw", -0.8, 0.608, (-0.034,0.23,0.035)),
 "Bear Crawl": ("Abs/BearCrawl", -0.8, 0.753, (0.001,0.248,-0.001)),
 "Farmer Carry March": ("Abs/FarmerCarryMarch", -1.0, 0.86, (0.025,0.04,-0.039)),
 "Suitcase Carry March": ("Abs/SuitcaseCarryMarch", -0.3, 0.868, (0.014,0.04,-0.004)),
 "Barbell Thruster": ("Legs/BarbellThruster", -0.8, 0.65, (-0.017,-0.078,0.018)),
 "Dumbbell Thruster": ("Legs/DumbbellThruster", -0.6, 0.744, (0.011,-0.029,-0.008)),
 "Kettlebell Thruster": ("Legs/KettlebellThruster", -0.6, 0.744, (0.012,-0.029,-0.009)),
 "Clean and Press": ("Shoulder/CleanAndPress", -0.8, 0.631, (-0.009,-0.074,0.01)),
 # Second round, 415-444 (2026-10-04), framings picked on viewport stills.
 "Elevated Calf Raise": ("Legs/ElevatedCalfRaise", -1.3, 0.833, (0.009,-0.049,-0.032)),
 "Bent-Knee Calf Raise": ("Legs/BentKneeCalfRaise", -1.3, 0.856, (0.011,0.035,-0.039)),
 "Tibialis Raise": ("Legs/TibialisRaise", -1.3, 0.858, (-0.001,0.037,0.003)),
 "Machine Tibialis Raise": ("Legs/MachineTibialisRaise", -1.3, 1.061, (0.013,0.155,-0.047)),
 "Wall Tibialis Raise": ("Legs/WallTibialisRaise", -1.3, 0.718, (0.011,-0.058,-0.04)),
 "Single-Leg Tibialis Raise": ("Legs/SingleLegTibialisRaise", -1.3, 0.848, (-0.025,0.031,0.091)),
 "Farmer's Walk on Toes": ("Legs/FarmersWalkOnToes", -1.0, 0.83, (0.024,0.02,-0.038)),
 "Calf Raise Hold": ("Legs/CalfRaiseHold", -1.3, 0.832, (0.009,0.02,-0.033)),
 "Calf Raise Pulse": ("Legs/CalfRaisePulse", -1.3, 0.835, (0.009,0.021,-0.032)),
 "Banded Plantar Flexion": ("Legs/BandedPlantarFlexion", -0.8, 0.833, (-0.009,0.21,0.01)),
 "Banded Dorsiflexion": ("Legs/BandedDorsiflexion", -0.8, 0.761, (-0.035,0.224,0.036)),
 "Sit-Up": ("Abs/SitUp", -1.35, 0.607, (-0.011,0.168,0.049)),
 "Weighted Sit-Up": ("Abs/WeightedSitUp", -1.35, 0.607, (-0.011,0.168,0.049)),
 "Decline Sit-Up": ("Abs/DeclineSitUp", -1.35, 0.632, (-0.016,-0.006,0.07)),
 "Weighted Decline Sit-Up": ("Abs/WeightedDeclineSitUp", -1.35, 0.637, (-0.015,-0.003,0.069)),
 "Bicycle Crunch": ("Abs/BicycleCrunch", -0.8, 0.628, (-0.008,0.147,0.008)),
 "Oblique Crunch": ("Abs/ObliqueCrunch", -0.8, 0.659, (-0.02,0.222,0.02)),
 "Standing Cable Crunch": ("Abs/StandingCableCrunch", -1.35, 0.865, (0.016,0.042,-0.07)),
 "Oblique Cable Crunch": ("Abs/ObliqueCableCrunch", -0.4, 0.863, (0.033,0.039,-0.014)),
 "Machine Crunch": ("Abs/MachineCrunch", -1.35, 1.074, (0.02,0.181,-0.089)),
 "Ab Coaster Crunch": ("Abs/AbCoasterCrunch", -1.35, 0.627, (0.002,0.059,-0.009)),
 "Stability Ball Crunch": ("Abs/StabilityBallCrunch", -1.35, 0.681, (-0.016,0.127,0.072)),
 "Toe Touch Crunch": ("Abs/ToeTouchCrunch", -2.3, 0.85, (0.12,0.16,0.14)),
 "Cross-Body Crunch": ("Abs/CrossBodyCrunch", -0.8, 0.658, (-0.02,0.203,0.02)),
 "Dead Bug": ("Abs/DeadBug", -0.8, 0.538, (-0.013,0.144,0.013)),
 "Bird Dog": ("Abs/BirdDog", -0.8, 0.583, (-0.019,0.18,0.02)),
 "Hollow Body Hold": ("Abs/HollowBodyHold", -1.35, 0.484, (-0.008,0.167,0.036)),
 "Hollow Body Rock": ("Abs/HollowBodyRock", -1.35, 0.453, (-0.007,0.127,0.031)),
 "V-Up": ("Abs/VUp", -1.35, 0.456, (-0.009,0.089,0.039)),
 "Alternating V-Up": ("Abs/AlternatingVUp", -0.8, 0.521, (-0.015,0.098,0.015)),
}
JOINTS = ["support_TrapeziusUpper_L","support_TrapeziusUpper_R","head","neck","chest","spine","pelvis","scapula_L","upper_arm_L","forearm_L","hand_L",
          "scapula_R","upper_arm_R","forearm_R","hand_R","thigh_L","patella_L","shin_L","foot_L","thigh_R","patella_R","shin_R","foot_R",
          # Chest and lat anchors for the pressing and pullover cues (2026-09-25).
          "support_PectoralisMajor_Clavicular_L","support_PectoralisMajor_Sternal_L","support_PectoralisMajor_Abdominal_L",
          "support_PectoralisMajor_Clavicular_R","support_PectoralisMajor_Sternal_R","support_PectoralisMajor_Abdominal_R",
          "support_LatissimusDorsi_L","support_LatissimusDorsi_R",
          # Deltoid, upper-trap and collarbone anchors for the shoulder, shrug and carry cues (2026-09-26).
          "deltoid_arc_clavicle_2_L","deltoid_arc_clavicle_2_R","deltoid_arc_scapula_2_L","deltoid_arc_scapula_2_R",
          "attachment_TrapeziusUpper_L","attachment_TrapeziusUpper_R","clavicle_L","clavicle_R",
          # Toe joints of the 300-series legs (older rigs have none; skipped there).
          "toe_L","toe_R"]

# Lifts that switch legs between reps: probe.py also writes `<stem>_front` /
# `<stem>_back` points for their cue dots (legs 300-350, 2026-09-26).
ALTERNATING = {"Forward Lunge", "Barbell Lunge", "Smith Machine Reverse Lunge", "Curtsy Lunge"}
# Lifts that shift from side to side: `<stem>_bent` / `<stem>_straight` points
# follow the more bent knee's leg and the other, as BodyFrame.bentSide does
# in the app (30-leg set, 2026-09-28).
SIDE_SHIFT = {"Lateral Lunge", "Cossack Squat"}

def proj(p, yaw, zoom, off):
    s = zoom / LONGEST
    w = (np.array(p) - np.array(CENTER)) * s + np.array(off)
    c, sn = math.cos(yaw), math.sin(yaw)
    x = w[0]*c + w[2]*sn; y = w[1]; z = -w[0]*sn + w[2]*c
    dz = D - z
    return ((x/(dz*TAN*ASPECT))+1)/2, (1-(y/(dz*TAN)))/2, dz

# Names after the output path limit the run; the output then merges into an
# existing file instead of replacing it.
only = sys.argv[2:] or [n for n in JOBS if n not in ("Squat","Step-Up","Single-Leg Glute Bridge","Push-Up","Plank")]
fr = [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875]
import os
out = json.load(open(sys.argv[1])) if sys.argv[2:] and os.path.exists(sys.argv[1]) else {}
for name in only:
    res, yaw, zoom, off = JOBS[name]
    st = Usd.Stage.Open(M + res + ".usdc")
    t0, t1 = st.GetStartTimeCode(), st.GetEndTimeCode()
    sk = next(p for p in sorted(st.Traverse(), key=lambda q: "Anatomy_MasterRig" not in q.GetPath().pathString) if p.GetTypeName() == "Skeleton")
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk))
    names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    idx = {n: i for i, n in enumerate(names)}
    out[name] = {j: [] for j in JOINTS}
    for f in fr:
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t0 + (t1 - t0) * f))
        for j in JOINTS:
            if j not in idx:
                continue
            p = w[idx[j]].ExtractTranslation()
            u, v, _ = proj((p[0], p[1], p[2]), yaw, zoom, off)
            out[name][j].append((round(u, 3), round(v, 3)))
        if name in ALTERNATING:
            # The leading / trailing leg, chosen per sample the way the app's
            # BodyFrame.leadingSide does (foot further ahead along the level
            # forward from the hips, pelvis and neck), for `_front` / `_back` dots.
            P = {j: np.array(w[idx[j]].ExtractTranslation()) for j in ("pelvis", "neck", "thigh_L", "thigh_R", "foot_L", "foot_R")}
            up = P["neck"] - P["pelvis"]; up /= np.linalg.norm(up)
            across = (P["thigh_L"] - P["thigh_R"]); across -= np.dot(across, up) * up
            fwd = np.cross(across / np.linalg.norm(across), up); fwd[1] = 0; fwd /= np.linalg.norm(fwd)
            side = "L" if np.dot(P["foot_L"] - P["foot_R"], fwd) >= 0 else "R"
            other = "R" if side == "L" else "L"
            for stem in ("thigh", "patella", "shin", "foot", "toe"):
                for role, sd in (("front", side), ("back", other)):
                    j = f"{stem}_{sd}"
                    if j not in idx:
                        continue
                    p = w[idx[j]].ExtractTranslation()
                    u, v, _ = proj((p[0], p[1], p[2]), yaw, zoom, off)
                    out[name].setdefault(f"{stem}_{role}", []).append((round(u, 3), round(v, 3)))
        if name in SIDE_SHIFT:
            P = {j: np.array(w[idx[j]].ExtractTranslation()) for j in ("thigh_L", "thigh_R", "shin_L", "shin_R", "foot_L", "foot_R")}
            def bend(sd):
                a, b = P[f"thigh_{sd}"] - P[f"shin_{sd}"], P[f"foot_{sd}"] - P[f"shin_{sd}"]
                return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))
            side = "L" if bend("L") >= bend("R") else "R"
            other = "R" if side == "L" else "L"
            for stem in ("thigh", "patella", "shin", "foot", "toe"):
                for role, sd in (("bent", side), ("straight", other)):
                    j = f"{stem}_{sd}"
                    if j not in idx:
                        continue
                    p = w[idx[j]].ExtractTranslation()
                    u, v, _ = proj((p[0], p[1], p[2]), yaw, zoom, off)
                    out[name].setdefault(f"{stem}_{role}", []).append((round(u, 3), round(v, 3)))
json.dump(out, open(sys.argv[1], "w"))
print(len(out), "exercises")
