import { writable, derived } from 'svelte/store';
import type { SequencerState, PlaybackState, VideoClip } from '$lib/types/sequencer';

// État principal du séquenceur
const initialState: SequencerState = {
	instruments: [],
	clips: [],
	isPlaying: false,
	currentTime: 0,
	bpm: 120,
	totalBeats: 64, // 16 mesures de 4 temps par défaut
	gridSize: { rows: 2, cols: 2 },
	loopMode: false
};

export const sequencerState = writable<SequencerState>(initialState);

// État de lecture en temps réel
export const playbackState = writable<PlaybackState>({
	currentBeat: 0,
	activeClips: new Set()
});

// Utilitaires pour calculer le temps
export const timeUtils = {
	beatsToSeconds: (beats: number, bpm: number): number => {
		return (beats / bpm) * 60;
	},
	secondsToBeats: (seconds: number, bpm: number): number => {
		return (seconds / 60) * bpm;
	}
};

// Actions du séquenceur
export const sequencerActions = {
	addInstrument: (name: string, videoFile: File | null = null, videoUrl: string | null = null) => {
		sequencerState.update((state) => {
			const url = videoFile ? URL.createObjectURL(videoFile) : videoUrl;
			const id = `instrument-${Date.now()}-${Math.random()}`;
			const availablePositions = Array.from(
				{ length: state.gridSize.rows * state.gridSize.cols },
				(_, i) => i
			);
			const usedPositions = state.instruments.map((inst) => inst.gridPosition);
			const freePositions = availablePositions.filter((pos) => !usedPositions.includes(pos));
			const gridPosition = freePositions[0] ?? 0;

			const colors = [
				'#FF6B6B',
				'#4ECDC4',
				'#45B7D1',
				'#FFA07A',
				'#98D8C8',
				'#F7DC6F',
				'#BB8FCE',
				'#85C1E2',
				'#F8B739'
			];
			const color = colors[state.instruments.length % colors.length];

			return {
				...state,
				instruments: [
					...state.instruments,
					{
						id,
						name,
						videoFile,
						videoUrl: url,
						color,
						gridPosition
					}
				]
			};
		});
	},

	removeInstrument: (id: string) => {
		sequencerState.update((state) => {
			// Révoquer l'URL de l'objet
			const instrument = state.instruments.find((inst) => inst.id === id);
			if (instrument?.videoUrl) {
				URL.revokeObjectURL(instrument.videoUrl);
			}

			return {
				...state,
				instruments: state.instruments.filter((inst) => inst.id !== id),
				clips: state.clips.filter((clip) => clip.instrumentId !== id)
			};
		});
	},

	addClip: (instrumentId: string, startTime: number, duration: number, trackIndex: number) => {
		sequencerState.update((state) => {
			const id = `clip-${Date.now()}-${Math.random()}`;
			return {
				...state,
				clips: [
					...state.clips,
					{
						id,
						instrumentId,
						startTime,
						duration,
						trackIndex
					}
				]
			};
		});
	},

	removeClip: (id: string) => {
		sequencerState.update((state) => ({
			...state,
			clips: state.clips.filter((clip) => clip.id !== id)
		}));
	},

	updateClip: (id: string, updates: Partial<VideoClip>) => {
		sequencerState.update((state) => ({
			...state,
			clips: state.clips.map((clip) => (clip.id === id ? { ...clip, ...updates } : clip))
		}));
	},

	setBpm: (bpm: number) => {
		sequencerState.update((state) => ({
			...state,
			bpm: Math.max(40, Math.min(300, bpm))
		}));
	},

	play: () => {
		sequencerState.update((state) => ({
			...state,
			isPlaying: true
		}));
	},

	pause: () => {
		sequencerState.update((state) => ({
			...state,
			isPlaying: false
		}));
	},

	stop: () => {
		sequencerState.update((state) => ({
			...state,
			isPlaying: false,
			currentTime: 0
		}));
		playbackState.update((state) => ({
			...state,
			currentBeat: 0,
			activeClips: new Set()
		}));
	},

	setCurrentTime: (time: number) => {
		sequencerState.update((state) => ({
			...state,
			currentTime: Math.max(0, Math.min(state.totalBeats, time))
		}));
	},

	toggleLoopMode: () => {
		sequencerState.update((state) => ({
			...state,
			loopMode: !state.loopMode
		}));
	},

	setGridSize: (rows: number, cols: number) => {
		sequencerState.update((state) => {
			// Vérifier si on peut réduire la grille
			const newTotalCells = rows * cols;
			const currentMaxPosition = Math.max(
				...state.instruments.map((inst) => inst.gridPosition),
				-1
			);

			// Si on réduit, vérifier que tous les instruments tiennent dans la nouvelle grille
			if (currentMaxPosition >= newTotalCells) {
				console.warn('Impossible de réduire: des instruments occupent des positions qui seraient supprimées');
				return state;
			}

			return {
				...state,
				gridSize: { rows, cols }
			};
		});
	},

	exportToJSON: (state: SequencerState) => {
		// Créer une version sérialisable (sans File et videoUrl)
		const exportData = {
			version: '1.0',
			bpm: state.bpm,
			totalBeats: state.totalBeats,
			gridSize: state.gridSize,
			instruments: state.instruments.map((inst) => ({
				id: inst.id,
				name: inst.name,
				color: inst.color,
				gridPosition: inst.gridPosition
			})),
			clips: state.clips.map((clip) => ({
				id: clip.id,
				instrumentId: clip.instrumentId,
				startTime: clip.startTime,
				duration: clip.duration,
				trackIndex: clip.trackIndex
			}))
		};

		const json = JSON.stringify(exportData, null, 2);
		const blob = new Blob([json], { type: 'application/json' });
		const url = URL.createObjectURL(blob);
		const a = document.createElement('a');
		a.href = url;
		a.download = `videoSeq-${Date.now()}.json`;
		a.click();
		URL.revokeObjectURL(url);
	},

	importFromJSON: async (jsonData: any) => {
		try {
			// Valider la version
			if (jsonData.version !== '1.0') {
				throw new Error('Version de fichier non supportée');
			}

			// Charger d'abord les vidéos depuis ./clips pour avoir les URLs
			const response = await fetch('/api/clips');
			const clipsData = await response.json();
			const availableVideos = new Map<string, string>();

			clipsData.files?.forEach((filename: string) => {
				const name = filename.replace(/\.[^/.]+$/, '');
				availableVideos.set(name, `/api/clips/${filename}`);
			});

			sequencerState.update((state) => {
				// Nettoyer les anciennes URLs
				state.instruments.forEach((inst) => {
					if (inst.videoUrl) {
						URL.revokeObjectURL(inst.videoUrl);
					}
				});

				// Reconstruire les instruments avec les vidéos disponibles
				const instruments = jsonData.instruments.map((inst: any) => {
					const videoUrl = availableVideos.get(inst.name) || null;
					return {
						id: inst.id,
						name: inst.name,
						color: inst.color,
						gridPosition: inst.gridPosition,
						videoFile: null,
						videoUrl
					};
				});

				// Restaurer l'état complet
				return {
					instruments,
					clips: jsonData.clips,
					isPlaying: false,
					currentTime: 0,
					bpm: jsonData.bpm,
					totalBeats: jsonData.totalBeats,
					gridSize: jsonData.gridSize
				};
			});

			return true;
		} catch (err) {
			console.error('Erreur lors de l\'import:', err);
			return false;
		}
	}
};
