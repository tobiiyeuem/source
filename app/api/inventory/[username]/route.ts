import { NextRequest, NextResponse } from "next/server";
import { getUserIdByUsername, fetchUserInventory } from "@/lib/roblox-api";

export async function GET(
  request: NextRequest,
  context: { params: Promise<{ username: string }> }
) {
  try {
    const { username } = await context.params;

    if (!username || username.trim().length === 0) {
      return NextResponse.json(
        { error: "Invalid username. Please provide a valid Roblox username." },
        { status: 400 }
      );
    }

    // Get user ID from username
    const userId = await getUserIdByUsername(username);
    
    // Fetch user inventory
    const inventory = await fetchUserInventory(userId);
    
    return NextResponse.json({
      username,
      userId,
      items: inventory,
      totalItems: inventory.length,
    }, {
      headers: {
        "Cache-Control": "public, s-maxage=60, stale-while-revalidate=120",
      },
    });
  } catch (error) {
    console.error("Error fetching user inventory:", error);
    
    const errorMessage =
      error instanceof Error ? error.message : "Failed to fetch user inventory";
    
    return NextResponse.json(
      { error: errorMessage },
      { status: 500 }
    );
  }
}
