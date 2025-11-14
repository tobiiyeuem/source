import { NextRequest, NextResponse } from "next/server";
import { fetchItemDetails } from "@/lib/roblox-api";

export async function GET(
  request: NextRequest,
  context: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await context.params;
    const itemId = parseInt(id);

    if (isNaN(itemId) || itemId <= 0) {
      return NextResponse.json(
        { error: "Invalid item ID. Please provide a valid positive number." },
        { status: 400 }
      );
    }

    const itemDetails = await fetchItemDetails(itemId);
    
    return NextResponse.json(itemDetails, {
      headers: {
        "Cache-Control": "public, s-maxage=60, stale-while-revalidate=120",
      },
    });
  } catch (error) {
    console.error("Error fetching item details:", error);
    
    const errorMessage =
      error instanceof Error ? error.message : "Failed to fetch item details";
    
    return NextResponse.json(
      { error: errorMessage },
      { status: 500 }
    );
  }
}
