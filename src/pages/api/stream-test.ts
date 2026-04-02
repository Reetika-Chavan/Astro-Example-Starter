import type { APIRoute } from "astro";

const WORDS = [
	"This",
	"replicates",
	"the",
	"iODigital",
	"customer",
	"use",
	"case.",
	"When",
	"Transfer-Encoding",
	"chunked",
	"streaming",
	"works,",
	"each",
	"word",
	"should",
	"appear",
	"incrementally",
	"as",
	"the",
	"server",
	"flushes",
	"chunks.",
	"If",
	"the",
	"edge",
	"or",
	"CDN",
	"buffers",
	"the",
	"response,",
	"you",
	"will",
	"see",
	"the",
	"full",
	"text",
	"only",
	"after",
	"the",
	"request",
	"finishes.",
	"Open",
	"DevTools",
	"→",
	"Network",
	"and",
	"watch",
	"the",
	"document",
	"or",
	"fetch",
	"timing",
	"while",
	"this",
	"stream",
	"runs.",
];

const DELAY_MS: Record<string, number> = {
	fast: 28,
	medium: 140,
	slow: 380,
};

export const GET: APIRoute = async ({ url }) => {
	const speed = url.searchParams.get("speed") ?? "medium";
	const delay = DELAY_MS[speed] ?? DELAY_MS.medium;

	const stream = new ReadableStream({
		async start(controller) {
			const encoder = new TextEncoder();
			try {
				for (const word of WORDS) {
					controller.enqueue(encoder.encode(word + " "));
					await new Promise((r) => setTimeout(r, delay));
				}
				controller.close();
			} catch (err) {
				controller.error(err);
			}
		},
	});

	return new Response(stream, {
		status: 200,
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
			"Cache-Control": "no-store, must-revalidate",
		},
	});
};
