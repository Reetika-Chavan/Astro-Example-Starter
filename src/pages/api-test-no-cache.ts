// Test API route WITHOUT explicit cache headers
// This will help verify if API routes are cached by default on Launch

export async function GET() {
  const timestamp = new Date().toISOString();
  const randomNumber = Math.floor(Math.random() * 10000);

  return new Response(
    JSON.stringify({
      message: "This API route has NO explicit cache headers",
      timestamp: timestamp,
      randomNumber: randomNumber,
      note: "If this is cached, timestamp and randomNumber should remain the same on subsequent requests",
    }),
    {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        // Intentionally NOT setting Cache-Control to test default behavior
      },
    }
  );
}
