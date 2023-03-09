import type { LayoutServerLoad } from './$types';

export const load = (async ({ setHeaders }) => {
	setHeaders({
		'Cross-Origin-Opener-Policy': 'same-origin',
		'Cross-Origin-Embedder-Policy': 'require-corp'
	});
}) satisfies LayoutServerLoad;

export const prerender = true;
