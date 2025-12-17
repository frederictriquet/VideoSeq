#!/usr/bin/env python3
"""
Script de test de rendu VideoSeq avec MoviePy
"""

from moviepy import VideoFileClip, ColorClip, CompositeVideoClip
import os

# Configuration
CLIPS_DIR = "./clips"
OUTPUT_DIR = "./output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

DURATION = 6.0
WIDTH, HEIGHT = 1920, 1080
CELL_WIDTH = 960
CELL_HEIGHT = 540

print("🎬 Test rendu MoviePy")

# Fond noir
base = ColorClip(size=(WIDTH, HEIGHT), color=(0,0,0), duration=DURATION)

# Liste de tous les clips
clips = []

# Exemple: baeuh à 0s position (0,0)
video1 = VideoFileClip("./clips/baeuh.mp4")
clip_duration1 = min(2.0, video1.duration)
video1 = video1.subclipped(0, clip_duration1)
video1 = video1.resized((CELL_WIDTH, CELL_HEIGHT))
video1 = video1.with_start(0.0)
video1 = video1.with_position((0, 0))
clips.append(video1)

# boom à 2s position (1,0)
video2 = VideoFileClip("./clips/boom.mp4")
clip_duration2 = min(2.0, video2.duration)
video2 = video2.subclipped(0, clip_duration2)
video2 = video2.resized((CELL_WIDTH, CELL_HEIGHT))
video2 = video2.with_start(2.0)
video2 = video2.with_position((960, 0))
clips.append(video2)

# baeuh encore à 4s position (0,0)
video3 = VideoFileClip("./clips/baeuh.mp4")
clip_duration3 = min(2.0, video3.duration)
video3 = video3.subclipped(0, clip_duration3)
video3 = video3.resized((CELL_WIDTH, CELL_HEIGHT))
video3 = video3.with_start(4.0)
video3 = video3.with_position((0, 0))
clips.append(video3)

# Composer
print(f"Composition de {len(clips)} clips...")
final = CompositeVideoClip([base] + clips, size=(WIDTH, HEIGHT))

# Rendu
output_file = f"{OUTPUT_DIR}/test_render.mp4"
print(f"Rendu vers: {output_file}")

final.write_videofile(
    output_file,
    fps=30,
    codec='libx264',
    audio_codec='aac',
    bitrate='5000k',
    preset='medium'
)

print("✅ Test terminé!")
