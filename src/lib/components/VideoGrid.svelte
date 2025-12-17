<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { sequencerState, playbackState, timeUtils } from '$lib/stores/sequencer';
	import type { VideoInstrument } from '$lib/types/sequencer';

	// Références aux éléments vidéo
	let videoRefs: Map<string, HTMLVideoElement> = new Map();
	let gridContainer: HTMLDivElement;

	// Action Svelte pour enregistrer une référence vidéo
	function videoAction(element: HTMLVideoElement, id: string) {
		videoRefs.set(id, element);
		element.preload = 'auto';
		element.loop = false;

		return {
			destroy() {
				videoRefs.delete(id);
			}
		};
	}

	// Créer la grille d'instruments
	$: gridArray = Array.from(
		{ length: $sequencerState.gridSize.rows * $sequencerState.gridSize.cols },
		(_, index) => {
			return $sequencerState.instruments.find((inst) => inst.gridPosition === index) || null;
		}
	);

	// Mapper les clips actifs avec leur progression
	let activeClipsMap = new Map<string, { clip: any; progress: number }>();

	// Stocker l'ID du clip actif et son temps de début pour chaque instrument
	let activeClipInfo = new Map<string, { clipId: string; startTime: number }>();

	// Réinitialiser quand on arrête de jouer
	$: if (!$sequencerState.isPlaying) {
		activeClipInfo.clear();
	}

	// Gérer la lecture des vidéos selon les clips actifs
	$: {
		// Si on ne joue pas, arrêter toutes les vidéos
		if (!$sequencerState.isPlaying) {
			videoRefs.forEach((video) => {
				if (!video.paused) {
					video.pause();
					video.currentTime = 0;
				}
			});
		} else {
			// Créer un set des instruments qui ont des clips actifs
			const currentActiveInstruments = new Set<string>();

			// Mode lecture : gérer les clips actifs
			$sequencerState.clips.forEach((clip) => {
				const clipStart = clip.startTime;
				const clipEnd = clipStart + clip.duration;
				const isActive =
					$sequencerState.currentTime >= clipStart && $sequencerState.currentTime < clipEnd;

				if (isActive) {
					currentActiveInstruments.add(clip.instrumentId);
					const video = videoRefs.get(clip.instrumentId);
					if (!video) return;

					// Vérifier si c'est un nouveau clip (différent ID)
					const currentInfo = activeClipInfo.get(clip.instrumentId);
					const isNewClip = !currentInfo || currentInfo.clipId !== clip.id;

					if (isNewClip) {
						// Nouveau clip : enregistrer ses infos et calculer le playbackRate
						activeClipInfo.set(clip.instrumentId, {
							clipId: clip.id,
							startTime: clipStart
						});

						// Assurer que la vidéo est chargée et a des métadonnées
						if (video.readyState < 2) {
							video.load();
						}

						// Calculer la durée du clip en secondes
						const clipDurationSeconds = timeUtils.beatsToSeconds(clip.duration, $sequencerState.bpm);

						// Ajuster la vitesse de lecture pour que la vidéo corresponde à la durée du clip
						// Si la vidéo dure 3s mais le clip doit durer 2s → playbackRate = 3/2 = 1.5
						const videoDuration = video.duration || clipDurationSeconds;
						video.playbackRate = videoDuration / clipDurationSeconds;

						// Démarrer depuis le début
						video.currentTime = 0;

						// Démarrer la lecture
						const playPromise = video.play();
						if (playPromise !== undefined) {
							playPromise.catch((err) => {
								if (err.name !== 'AbortError') {
									console.warn(`Erreur lecture vidéo ${clip.instrumentId}:`, err.message);
								}
							});
						}
					}
					// La vidéo joue déjà pour ce clip, on la laisse continuer
				}
			});

			// Arrêter les vidéos qui n'ont plus de clips actifs
			videoRefs.forEach((video, instrumentId) => {
				if (!currentActiveInstruments.has(instrumentId) && !video.paused) {
					video.pause();
					video.currentTime = 0;
					activeClipInfo.delete(instrumentId);
				}
			});
		}
	}

	// Nettoyer lors de la destruction
	onDestroy(() => {
		videoRefs.forEach((video) => {
			video.pause();
		});
		videoRefs.clear();
	});
</script>

<div
	class="video-grid"
	bind:this={gridContainer}
	style="--grid-cols: {$sequencerState.gridSize.cols}; --grid-rows: {$sequencerState.gridSize.rows}"
>
	{#each gridArray as instrument, index (index)}
		<div class="grid-cell" style="border: 2px solid {instrument?.color || '#333'}">
			{#if instrument && instrument.videoUrl}
				<video
					use:videoAction={instrument.id}
					src={instrument.videoUrl}
					class="video-player"
					muted={false}
				>
					<track kind="captions" />
				</video>
				<div class="instrument-label" style="background: {instrument.color}">
					{instrument.name}
				</div>
			{:else}
				<div class="empty-cell">
					<span class="cell-number">{index + 1}</span>
				</div>
			{/if}
		</div>
	{/each}
</div>

<style>
	.video-grid {
		display: grid;
		grid-template-columns: repeat(var(--grid-cols), 1fr);
		grid-template-rows: repeat(var(--grid-rows), 1fr);
		gap: 4px;
		background: #0a0a0a;
		padding: 1rem;
		aspect-ratio: 16 / 9;
		width: 100%;
		max-height: 50vh;
	}

	.grid-cell {
		position: relative;
		background: #1a1a1a;
		border-radius: 4px;
		overflow: hidden;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.video-player {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.instrument-label {
		position: absolute;
		bottom: 0;
		left: 0;
		right: 0;
		padding: 0.25rem 0.5rem;
		font-size: 0.75rem;
		font-weight: 600;
		color: white;
		text-align: center;
		opacity: 0.9;
		text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
	}

	.empty-cell {
		width: 100%;
		height: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
		color: #444;
		font-size: 2rem;
		font-weight: 300;
	}

	.cell-number {
		opacity: 0.3;
	}
</style>
