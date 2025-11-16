export interface RobloxAssetDetails {
  AssetId: number;
  ProductId?: number;
  Name: string;
  Description: string;
  AssetTypeId: number;
  Creator: {
    Id: number;
    Name: string;
    CreatorType: string;
    CreatorTargetId: number;
  };
  IconImageAssetId?: number;
  Created: string;
  Updated: string;
  PriceInRobux?: number;
  Sales?: number;
  IsNew: boolean;
  IsForSale: boolean;
  IsPublicDomain: boolean;
  IsLimited: boolean;
  IsLimitedUnique: boolean;
  Remaining?: number;
  MinimumMembershipLevel?: number;
  ContentRatingTypeId?: number;
}

export interface RobloxCatalogItem {
  id: number;
  itemType: string;
  assetType: number;
  name: string;
  description: string;
  productId: number;
  genres?: string[];
  bundleType?: number;
  itemStatus?: string[];
  itemRestrictions?: string[];
  creatorHasVerifiedBadge: boolean;
  creatorType: string;
  creatorTargetId: number;
  creatorName: string;
  price?: number;
  priceStatus?: string;
  unitsAvailableForConsumption?: number;
  purchaseCount?: number;
  favoriteCount?: number;
  offSaleDeadline?: string;
  saleLocationType?: string;
  lowestPrice?: number;
  priceInRobux?: number;
  premiumPricing?: {
    premiumDiscountPercentage: number;
    premiumPriceInRobux: number;
  };
}

export interface RobloxThumbnail {
  targetId: number;
  state: string;
  imageUrl: string;
}

export interface ItemSearchResult {
  id: number;
  name: string;
  description: string;
  creator: string;
  creatorId: number;
  price: number | null;
  isForSale: boolean;
  isLimited: boolean;
  isLimitedUnique: boolean;
  remaining: number | null;
  assetType: string;
  thumbnailUrl: string;
  created: string;
  updated: string;
  rap?: number;
  sales?: number;
}

export interface RobloxInventoryItem {
  assetId: number;
  name: string;
  assetType: string;
  created: string;
}

export interface RobloxUserInfo {
  id: number;
  name: string;
  displayName: string;
}
