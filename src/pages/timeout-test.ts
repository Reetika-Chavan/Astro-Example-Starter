// This route intentionally waits for 60 seconds to exceed the 30-second timeout limit

export async function GET() {
  const startTime = Date.now();

  await new Promise((resolve) => setTimeout(resolve, 60000));

  const elapsedTime = Date.now() - startTime;

  return new Response(
    JSON.stringify({
      message: "This response should not be reached due to timeout",
      elapsedTime: `${elapsedTime}ms`,
      timestamp: new Date().toISOString(),
    }),
    {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        "Cache-Control": "no-store",
      },
    }
  );
}
