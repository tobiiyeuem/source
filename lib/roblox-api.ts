import {
  RobloxAssetDetails,
  RobloxCatalogItem,
  ItemSearchResult,
} from "@/types/roblox";

const ASSET_TYPES: Record<number, string> = {
  1: "Image",
  2: "T-Shirt",
  3: "Audio",
  4: "Mesh",
  5: "Lua",
  8: "Hat",
  9: "Place",
  10: "Model",
  11: "Shirt",
  12: "Pants",
  13: "Decal",
  16: "Avatar",
  17: "Head",
  18: "Face",
  19: "Gear",
  21: "Badge",
  22: "Group Emblem",
  24: "Animation",
  25: "Arms",
  26: "Legs",
  27: "Torso",
  28: "Right Arm",
  29: "Left Arm",
  30: "Left Leg",
  31: "Right Leg",
  32: "Package",
  33: "YouTubeVideo",
  34: "Game Pass",
  37: "Shoulder Accessories",
  38: "Waist Accessories",
  39: "Back Accessories",
  40: "Neck Accessories",
  41: "Face Accessories",
  42: "Hair Accessories",
  43: "Front Accessories",
  44: "Emote Animation",
  45: "Climb Animation",
  46: "Death Animation",
  47: "Fall Animation",
  48: "Idle Animation",
  49: "Jump Animation",
  50: "Run Animation",
  51: "Swim Animation",
  52: "Walk Animation",
  53: "Pose Animation",
  54: "LocalizationTableManifest",
  55: "LocalizationTableTranslation",
  56: "Emote Animation",
  61: "Video",
  62: "T-Shirt Accessory",
  63: "Shirt Accessory",
  64: "Pants Accessory",
  65: "Jacket Accessory",
  66: "Sweater Accessory",
  67: "Shorts Accessory",
  68: "Left Shoe Accessory",
  69: "Right Shoe Accessory",
  70: "Dress Skirt Accessory",
};

export async function fetchAssetDetails(
  assetId: number
): Promise<ItemSearchResult> {
  try {
    // Fetch asset details from economy API
    const assetResponse = await fetch(
      `https://economy.roblox.com/v2/assets/${assetId}/details`,
      {
        headers: {
          "Content-Type": "application/json",
        },
        cache: "no-store",
      }
    );

    if (!assetResponse.ok) {
      throw new Error(`Failed to fetch asset details: ${assetResponse.status}`);
    }

    const assetData: RobloxAssetDetails = await assetResponse.json();

    // Fetch thumbnail
    const thumbnailResponse = await fetch(
      `https://thumbnails.roblox.com/v1/assets?assetIds=${assetId}&size=420x420&format=Png`,
      {
        headers: {
          "Content-Type": "application/json",
        },
        cache: "no-store",
      }
    );

    let thumbnailUrl = "/placeholder-item.png";
    if (thumbnailResponse.ok) {
      const thumbnailData = await thumbnailResponse.json();
      if (thumbnailData.data && thumbnailData.data.length > 0) {
        thumbnailUrl = thumbnailData.data[0].imageUrl;
      }
    }

    // Map to ItemSearchResult
    return {
      id: assetData.AssetId,
      name: assetData.Name,
      description: assetData.Description,
      creator: assetData.Creator.Name,
      creatorId: assetData.Creator.CreatorTargetId,
      price: assetData.PriceInRobux ?? null,
      isForSale: assetData.IsForSale,
      isLimited: assetData.IsLimited,
      isLimitedUnique: assetData.IsLimitedUnique,
      remaining: assetData.Remaining ?? null,
      assetType: ASSET_TYPES[assetData.AssetTypeId] || `Type ${assetData.AssetTypeId}`,
      thumbnailUrl,
      created: assetData.Created,
      updated: assetData.Updated,
      sales: assetData.Sales,
    };
  } catch (error) {
    throw new Error(
      `Failed to fetch asset ${assetId}: ${error instanceof Error ? error.message : "Unknown error"}`
    );
  }
}

export async function fetchCatalogItem(
  itemId: number
): Promise<ItemSearchResult> {
  try {
    // Fetch catalog item details
    const catalogResponse = await fetch(
      `https://catalog.roblox.com/v1/catalog/items/${itemId}/details`,
      {
        headers: {
          "Content-Type": "application/json",
        },
        cache: "no-store",
      }
    );

    if (!catalogResponse.ok) {
      throw new Error(`Failed to fetch catalog item: ${catalogResponse.status}`);
    }

    const catalogData: RobloxCatalogItem = await catalogResponse.json();

    // Fetch thumbnail
    const thumbnailResponse = await fetch(
      `https://thumbnails.roblox.com/v1/assets?assetIds=${catalogData.id}&size=420x420&format=Png`,
      {
        headers: {
          "Content-Type": "application/json",
        },
        cache: "no-store",
      }
    );

    let thumbnailUrl = "/placeholder-item.png";
    if (thumbnailResponse.ok) {
      const thumbnailData = await thumbnailResponse.json();
      if (thumbnailData.data && thumbnailData.data.length > 0) {
        thumbnailUrl = thumbnailData.data[0].imageUrl;
      }
    }

    // Determine sale status
    const isForSale = catalogData.priceStatus === "On Sale" || catalogData.price !== undefined;
    const isLimited = catalogData.itemRestrictions?.includes("Limited") || false;
    const isLimitedUnique = catalogData.itemRestrictions?.includes("LimitedUnique") || false;

    // Map to ItemSearchResult
    return {
      id: catalogData.id,
      name: catalogData.name,
      description: catalogData.description,
      creator: catalogData.creatorName,
      creatorId: catalogData.creatorTargetId,
      price: catalogData.price ?? catalogData.priceInRobux ?? null,
      isForSale,
      isLimited,
      isLimitedUnique,
      remaining: catalogData.unitsAvailableForConsumption ?? null,
      assetType: ASSET_TYPES[catalogData.assetType] || catalogData.itemType || `Type ${catalogData.assetType}`,
      thumbnailUrl,
      created: "", // Catalog API doesn't provide this
      updated: "", // Catalog API doesn't provide this
      sales: catalogData.purchaseCount,
    };
  } catch (error) {
    throw new Error(
      `Failed to fetch catalog item ${itemId}: ${error instanceof Error ? error.message : "Unknown error"}`
    );
  }
}

export async function fetchItemDetails(
  itemId: number
): Promise<ItemSearchResult> {
  // Try asset API first, fallback to catalog API
  try {
    return await fetchAssetDetails(itemId);
  } catch (assetError) {
    console.log("Asset API failed, trying catalog API...");
    try {
      return await fetchCatalogItem(itemId);
    } catch (catalogError) {
      throw new Error(
        `Failed to fetch item ${itemId} from both APIs: Asset error: ${assetError instanceof Error ? assetError.message : "Unknown"}, Catalog error: ${catalogError instanceof Error ? catalogError.message : "Unknown"}`
      );
    }
  }
}
