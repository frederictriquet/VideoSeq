<script lang="ts">
	import { sequencerState, sequencerActions } from '$lib/stores/sequencer';
	import Timeline from './Timeline.svelte';
	import VideoGrid from './VideoGrid.svelte';
	import TransportControls from './TransportControls.svelte';
	import InstrumentPanel from './InstrumentPanel.svelte';

	let fileInput: HTMLInputElement;
	let instrumentName = '';

	function handleFileSelect(event: Event) {
		const target = event.target as HTMLInputElement;
		const file = target.files?.[0];

		if (file && file.type.startsWith('video/')) {
			if (instrumentName.trim()) {
				sequencerActions.addInstrument(instrumentName.trim(), file);
				instrumentName = '';
				target.value = '';
			} else {
				alert('Veuillez entrer un nom pour l\'instrument');
			}
		} else {
			alert('Veuillez sélectionner un fichier vidéo valide');
		}
	}

	function triggerFileInput() {
		fileInput?.click();
	}

	// Debug info
	$: debugInfo = {
		isPlaying: $sequencerState.isPlaying,
		currentTime: $sequencerState.currentTime.toFixed(2),
		clips: $sequencerState.clips.length,
		instruments: $sequencerState.instruments.length
	};
</script>

<div class="video-sequencer">
	<header class="header">
		<h1>VideoSeq - Séquenceur Vidéo</h1>
		<div class="add-instrument">
			<input
				type="text"
				bind:value={instrumentName}
				placeholder="Nom de l'instrument"
				class="instrument-name-input"
			/>
			<button onclick={triggerFileInput} class="add-btn">
				+ Ajouter Vidéo
			</button>
			<input
				type="file"
				accept="video/*"
				bind:this={fileInput}
				onchange={handleFileSelect}
				style="display: none;"
			/>
		</div>
	</header>

	<div class="main-content">
		<div class="left-panel">
			<InstrumentPanel />
		</div>

		<div class="center-panel">
			<VideoGrid />
			<Timeline />
			<TransportControls />

			<!-- Debug Panel -->
			<div class="debug-panel">
				<span>🎵 Playing: {debugInfo.isPlaying ? 'YES' : 'NO'}</span>
				<span>⏱️ Time: {debugInfo.currentTime}</span>
				<span>🎬 Clips: {debugInfo.clips}</span>
				<span>🎸 Instruments: {debugInfo.instruments}</span>
			</div>
		</div>
	</div>
</div>

<style>
	.video-sequencer {
		width: 100%;
		height: 100vh;
		display: flex;
		flex-direction: column;
		background: #1a1a1a;
		color: #ffffff;
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
	}

	.header {
		padding: 1rem 2rem;
		background: #252525;
		border-bottom: 2px solid #333;
		display: flex;
		justify-content: space-between;
		align-items: center;
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
	}

	h1 {
		margin: 0;
		font-size: 1.5rem;
		font-weight: 600;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		-webkit-background-clip: text;
		-webkit-text-fill-color: transparent;
		background-clip: text;
	}

	.add-instrument {
		display: flex;
		gap: 0.5rem;
		align-items: center;
	}

	.instrument-name-input {
		padding: 0.5rem 1rem;
		background: #2a2a2a;
		border: 1px solid #444;
		border-radius: 4px;
		color: #ffffff;
		font-size: 0.9rem;
		outline: none;
		transition: border-color 0.2s;
	}

	.instrument-name-input:focus {
		border-color: #667eea;
	}

	.instrument-name-input::placeholder {
		color: #666;
	}

	.add-btn {
		padding: 0.5rem 1.5rem;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		border: none;
		border-radius: 4px;
		color: white;
		font-weight: 600;
		cursor: pointer;
		transition: transform 0.2s, box-shadow 0.2s;
		font-size: 0.9rem;
	}

	.add-btn:hover {
		transform: translateY(-1px);
		box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
	}

	.add-btn:active {
		transform: translateY(0);
	}

	.main-content {
		flex: 1;
		display: flex;
		overflow: hidden;
	}

	.left-panel {
		width: 250px;
		background: #202020;
		border-right: 2px solid #333;
		overflow-y: auto;
	}

	.center-panel {
		flex: 1;
		display: flex;
		flex-direction: column;
		overflow: hidden;
	}

	.debug-panel {
		background: #2a2a2a;
		border-top: 1px solid #444;
		padding: 0.5rem 1rem;
		display: flex;
		gap: 1.5rem;
		font-size: 0.85rem;
		color: #aaa;
		font-family: 'Courier New', monospace;
	}

	.debug-panel span {
		white-space: nowrap;
	}
</style>
