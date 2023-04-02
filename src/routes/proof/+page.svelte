<script lang="ts">
	import { createFFmpeg, fetchFile } from '@ffmpeg/ffmpeg';

	let fileDetails = {
		duration: null,
		audioFormat: '',
		audioTrackCount: 0,
		videoFormat: '',
		resolution: '0x0'
	}

	let options = {
		disableVideo: {
			flag: '-map 0:a', //'-vn',
			value: true
		},
		disableAudio: {
			flag: '-an',
			value: false
		},
	}

	let isReady = false,
		files: FileList,
		message = 'Starting',
		video: HTMLVideoElement,
		progress = 0,
		showProgress = false;

	const ffmpeg = createFFmpeg({
		log: true,
		progress: ({ ratio }) => {
			if (ratio >= 0) {
				progress = ratio * 100;
			}
		}
	});

	const checkIsReady = setInterval(() => {
		if (!ffmpeg.isLoaded() && message === 'Starting') {
			message = 'Loading';
			ffmpeg.load();
		} else if (ffmpeg.isLoaded()) {
			clearInterval(checkIsReady)
			isReady = true;
			message = 'Ready';
		}
	}, 1000)

	const evaluate = async () => {
		const { name } = files[0];
		ffmpeg.FS('writeFile', name, await fetchFile(files[0]));
		const file_details = await ffmpeg.run('-i', name);
		console.log(file_details)
	}

	const clearMemory = () => {
		// console.log('[info] unlinking old data');
		// change to wildcard => '*.mp4|*.mp3'
		// try {
		// 	ffmpeg.FS('unlink', '*.mp4|*.mp3');
		// } catch {}
		// try {
		// 	ffmpeg.FS('unlink', 'output.mp3');
		// } catch {}
		// try {
		// 	ffmpeg.FS('unlink', 'output.mp4');
		// } catch {}
	};

	const transcode = async () => {
		showProgress = true;
		clearMemory();
		// allow option to select output format
		const outputFiletype = !options.disableVideo.value? '.mp4': '.mp3'
		// let flags = options.disableVideo.value? options.disableVideo.flag: ''
		const { name } = files[0];

		// message = 'Trimming started';
		ffmpeg.FS('writeFile', name, await fetchFile(files[0]));
		// await ffmpeg.run('-i', name, '-an', '-ss', '0', '-to', '2', 'output.mp4');

		// const flags = `-i ${name} -map=0:a output${outputFiletype}`
		// console.log(flags)
		// await ffmpeg.run(flags);

		// message = 'Trimming finished';
		const data = ffmpeg.FS('readFile', 'output' + outputFiletype);
		video.src = URL.createObjectURL(new Blob([data.buffer], {
			type: !options.disableVideo.value? 'video/mp4': 'audio/mp3'
		}));
		showProgress = false;
	};
</script>

<svelte:head>
	<title>Proof-of-concept</title>
</svelte:head>

<div>
	<!-- {#each Object.keys(options) as key} -->
	{#each Object.entries(options) as [key, value]}
		{@const random = Math.random()}
		<div>
			<input id={'_' + random} type="checkbox" bind:checked={options[key].value} />
			<label for={'_' + random}>{key}</label>
		</div>
	{/each}
	
	<input id="files" class="hidden" type="file" disabled={!isReady} multiple bind:files on:change={evaluate} />
	<label for="files" style="cursor: pointer;">
		<h3>{files?.[0].name ?? 'Select file to convert'}</h3>
	</label>
	<button disabled={!isReady} on:click={transcode}>Convert</button>

	<div style='margin-top: 1rem;'>
		{#if showProgress}
			{progress.toFixed(2)}% done
		{:else}
			{message}
		{/if}
	</div>

	<!-- for development -->
	<div style='margin-top: 2rem;'>
		{JSON.stringify(fileDetails, null, "\t")}
	</div>

	<div class:hidden={!video?.src}>
		<!-- svelte-ignore a11y-media-has-caption -->
		<video bind:this={video} controls height="300px" />
	</div>
</div>

<style>
	:global(main > div) {
		height: 100%;
		padding: 2rem;
		border-radius: 1.5rem;
		background-color: #f0f5fa;
	}
	input:disabled + label {
		opacity: .5;
	}
	label {
		user-select: none;
	}
</style>
