<script lang="ts">
	import { createFFmpeg } from '@ffmpeg/ffmpeg';
	let files: FileList;

	const convert = async () => {
		const ffmpeg = createFFmpeg({
			corePath: 'https://unpkg.com/@ffmpeg/core'
		});
		// corePath: 'https://unpkg.com/@ffmpeg/core-st@0.11.1/dist/ffmpeg-core.js',
		// corePath: 'https://unpkg.com/@ffmpeg/ffmpeg/src/index.js',
		// corePath: 'static/js/ffmpeg-core.js',

		await ffmpeg.load();
	};
</script>

<svelte:head>
	<title>Youtube Downloader Online</title>
	<!-- <script src='https://unpkg.com/@ffmpeg/ffmpeg@0.11.6/src/index.js' /> -->
</svelte:head>

<div class="row">
	<div id="controls">
		<input type="file" bind:files on:change={convert} />

		Paste link bar<br /><br />

		<div class="card">
			<div class="title">Formats</div>
			<div class="light">MP4 - 1080p</div>

			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 96 960 960" height="20" width="20"
				><path
					d="M480 936 300 756l44-44 136 136 136-136 44 44-180 180ZM344 444l-44-44 180-180 180 180-44 44-136-136-136 136Z"
				/></svg
			>
		</div>

		<button>Download</button>
	</div>
	<div>
		<div id="preview">
			<div class="imgContainer">&nbsp;</div>
			<div class="info">
				<div class="row">
					<div>
						<div>Source video</div>
						<div class="light">Size: 152MB</div>
					</div>
					<div align="right">
						<div>Output video</div>
						<div class="light">Esitmated size: 86.0MB</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<style>
	.light {
		padding-top: 0.15rem;
		font-size: 0.875rem;
		color: #5c6064;
	}

	.row {
		margin: 0 auto;
		height: 96%;
		max-width: 1280px;
		align-items: center;
		justify-content: space-between;
	}
	.row > * {
		max-width: 50%;
		width: 50%;
	}

	.card {
		position: relative;
		max-width: 350px;
		margin-bottom: 1rem;
		padding: 0.75rem 1.5rem;
		border: 1px solid #ebebeb;
		border-radius: 0.75rem;
	}
	.card .title {
		padding-bottom: 0.5rem;
		font-size: 1.125rem;
	}
	.card > svg {
		position: absolute;
		top: 0.9rem;
		right: 0.75rem;
	}

	button {
		margin-top: 1rem;
		padding: 1rem 1.5rem;
		background-color: #ebebeb;
		border: none;
		border-radius: 0.75rem;
		appearance: none;
		font-size: 1.125rem;
	}
	button:hover {
		cursor: pointer;
	}

	#preview {
		display: inline-block;
		margin: 0 auto;
		padding: 1rem;
		background-color: #ebebeb;
		border-radius: 1rem;
	}
	.imgContainer {
		height: 300px;
		/* width: 100px; */
		aspect-ratio: 16/9;
		background-color: #fff;
		/* color: #0078d4; */
		border-radius: 0.7rem;
	}
	.info {
		padding: 2rem 0;
		/* opacity: .85; */
	}
</style>
