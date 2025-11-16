import { ItemSearchResult } from "@/types/roblox";
import Image from "next/image";

interface ItemDetailsProps {
  item: ItemSearchResult;
}

export default function ItemDetails({ item }: ItemDetailsProps) {
  const formatDate = (dateString: string) => {
    if (!dateString) return "N/A";
    try {
      return new Date(dateString).toLocaleDateString("en-US", {
        year: "numeric",
        month: "long",
        day: "numeric",
      });
    } catch {
      return "N/A";
    }
  };

  const getSaleStatus = () => {
    if (!item.isForSale) return { text: "Off Sale", color: "text-gray-600" };
    if (item.isLimitedUnique) return { text: "Limited U", color: "text-purple-600" };
    if (item.isLimited) return { text: "Limited", color: "text-orange-600" };
    return { text: "On Sale", color: "text-green-600" };
  };

  const saleStatus = getSaleStatus();

  return (
    <div className="w-full max-w-4xl mx-auto bg-white dark:bg-zinc-900 rounded-lg shadow-lg overflow-hidden">
      <div className="grid md:grid-cols-2 gap-6 p-6">
        {/* Left side - Image */}
        <div className="flex items-center justify-center bg-gray-100 dark:bg-zinc-800 rounded-lg p-4">
          <div className="relative w-full aspect-square max-w-md">
            <Image
              src={item.thumbnailUrl}
              alt={item.name}
              fill
              className="object-contain"
              unoptimized
              priority
            />
          </div>
        </div>

        {/* Right side - Details */}
        <div className="flex flex-col gap-4">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
              {item.name}
            </h1>
            <p className="text-sm text-gray-600 dark:text-gray-400">
              Item ID: {item.id}
            </p>
          </div>

          {/* Description */}
          <div>
            <h2 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
              Description
            </h2>
            <p className="text-gray-800 dark:text-gray-200">
              {item.description || "No description available"}
            </p>
          </div>

          {/* Item Type */}
          <div className="flex items-center gap-2">
            <span className="text-sm font-semibold text-gray-700 dark:text-gray-300">
              Type:
            </span>
            <span className="px-3 py-1 bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200 rounded-full text-sm font-medium">
              {item.assetType}
            </span>
          </div>

          {/* Sale Status */}
          <div className="flex items-center gap-2">
            <span className="text-sm font-semibold text-gray-700 dark:text-gray-300">
              Status:
            </span>
            <span
              className={`px-3 py-1 rounded-full text-sm font-medium ${saleStatus.color} bg-opacity-10`}
            >
              {saleStatus.text}
            </span>
          </div>

          {/* Price */}
          <div className="flex items-center gap-2">
            <span className="text-sm font-semibold text-gray-700 dark:text-gray-300">
              Price:
            </span>
            <span className="text-xl font-bold text-gray-900 dark:text-white">
              {item.price !== null ? (
                <>
                  <span className="text-green-600">R$</span> {item.price.toLocaleString()}
                </>
              ) : (
                <span className="text-gray-500">Not for sale</span>
              )}
            </span>
          </div>

          {/* Limited Info */}
          {(item.isLimited || item.isLimitedUnique) && item.remaining !== null && (
            <div className="flex items-center gap-2">
              <span className="text-sm font-semibold text-gray-700 dark:text-gray-300">
                Stock:
              </span>
              <span className="text-lg font-semibold text-gray-900 dark:text-white">
                {item.remaining.toLocaleString()} remaining
              </span>
            </div>
          )}

          {/* Sales */}
          {item.sales !== undefined && (
            <div className="flex items-center gap-2">
              <span className="text-sm font-semibold text-gray-700 dark:text-gray-300">
                Sales:
              </span>
              <span className="text-gray-900 dark:text-white">
                {item.sales.toLocaleString()}
              </span>
            </div>
          )}

          {/* Creator */}
          <div>
            <h2 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
              Creator
            </h2>
            <a
              href={`https://www.roblox.com/users/${item.creatorId}/profile`}
              target="_blank"
              rel="noopener noreferrer"
              className="text-blue-600 dark:text-blue-400 hover:underline"
            >
              {item.creator}
            </a>
          </div>

          {/* Dates */}
          {item.created && (
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div>
                <span className="font-semibold text-gray-700 dark:text-gray-300">
                  Created:
                </span>
                <p className="text-gray-600 dark:text-gray-400">
                  {formatDate(item.created)}
                </p>
              </div>
              {item.updated && (
                <div>
                  <span className="font-semibold text-gray-700 dark:text-gray-300">
                    Updated:
                  </span>
                  <p className="text-gray-600 dark:text-gray-400">
                    {formatDate(item.updated)}
                  </p>
                </div>
              )}
            </div>
          )}

          {/* View on Roblox */}
          <a
            href={`https://www.roblox.com/catalog/${item.id}`}
            target="_blank"
            rel="noopener noreferrer"
            className="mt-4 w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors text-center"
          >
            View on Roblox
          </a>
        </div>
      </div>
    </div>
  );
}
