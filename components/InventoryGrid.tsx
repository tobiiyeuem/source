import { ItemSearchResult } from "@/types/roblox";
import Image from "next/image";

interface InventoryGridProps {
  items: ItemSearchResult[];
  username: string;
}

export default function InventoryGrid({ items, username }: InventoryGridProps) {
  if (items.length === 0) {
    return (
      <div className="w-full max-w-6xl mx-auto bg-white dark:bg-zinc-900 rounded-lg shadow-lg p-8 text-center">
        <p className="text-gray-600 dark:text-gray-400">
          No items found in {username}&apos;s inventory
        </p>
      </div>
    );
  }

  return (
    <div className="w-full max-w-6xl mx-auto">
      <div className="bg-white dark:bg-zinc-900 rounded-lg shadow-lg p-6 mb-6">
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
          {username}&apos;s Inventory
        </h2>
        <p className="text-gray-600 dark:text-gray-400">
          {items.length} item{items.length !== 1 ? "s" : ""} found
        </p>
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        {items.map((item) => (
          <a
            key={item.id}
            href={`https://www.roblox.com/catalog/${item.id}`}
            target="_blank"
            rel="noopener noreferrer"
            className="bg-white dark:bg-zinc-900 rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow group"
          >
            <div className="relative aspect-square bg-gray-100 dark:bg-zinc-800">
              <Image
                src={item.thumbnailUrl}
                alt={item.name}
                fill
                className="object-contain p-2 group-hover:scale-110 transition-transform"
                unoptimized
              />
            </div>
            <div className="p-3">
              <h3 className="text-sm font-semibold text-gray-900 dark:text-white truncate">
                {item.name}
              </h3>
              <p className="text-xs text-gray-600 dark:text-gray-400 mt-1">
                {item.assetType}
              </p>
            </div>
          </a>
        ))}
      </div>
    </div>
  );
}
