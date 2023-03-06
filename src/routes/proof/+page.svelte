<script lang="ts">
	import { createFFmpeg, fetchFile } from '@ffmpeg/ffmpeg';

	let files: FileList,
		message = 'Idle',
		video: HTMLVideoElement,
		progress = 0,
		showProgress = false;

	const ffmpeg = createFFmpeg({
		// 	corePath: 'https://unpkg.com/@ffmpeg/core',
		log: false,
		progress: ({ ratio }) => {
			if (ratio >= 0) {
				progress = ratio * 100;
			}
		}
	});

	message = 'Warming up';
	if (!ffmpeg.isLoaded()) {
		ffmpeg.load();
	}
	message = 'Ready';

	const clearMemory = () => {
		console.log('[info] unlinking old data');
		// change to wildcard => '*.mp4|*.mp3'
		try {
			ffmpeg.FS('unlink', 'output.mp3');
		} catch {}
		try {
			ffmpeg.FS('unlink', 'output.mp4');
		} catch {}
	};

	const transcode = async () => {
		showProgress = true;
		clearMemory();

		const { name } = files[0];

		if (!ffmpeg.isLoaded()) {
			await ffmpeg.load();
		}

		message = 'Trimming started';
		ffmpeg.FS('writeFile', name, await fetchFile(files[0]));
		await ffmpeg.run('-i', name, '-an', '-ss', '0', '-to', '2', 'output.mp4');
		// await ffmpeg.run('-i', name,  'output.mp4';

		message = 'Trimming finished';
		const data = ffmpeg.FS('readFile', 'output.mp4');
		video.src = URL.createObjectURL(new Blob([data.buffer], { type: 'video/mp4' }));
		showProgress = false;
	};
</script>

<main>
	<div>
		<!-- svelte-ignore a11y-media-has-caption -->
		<div class:hidden={!video?.src}>
			<video bind:this={video} controls height="300px" />
			<br /><br />
		</div>

		<input type="file" multiple bind:files on:change={transcode} />
		<p>{message}</p>

		{#if showProgress}
			{progress.toFixed(2)}% done
		{/if}
	</div>
</main>

<style>
	main {
		height: 100vh;
		padding: 1rem;
	}
	main > div {
		height: 100%;
		padding: 2rem;
		border-radius: 1.5rem;
		background-color: #f0f5fa;
	}
</style>
