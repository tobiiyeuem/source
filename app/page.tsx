import ItemSearch from "@/components/ItemSearch";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-12">
          <h1 className="text-4xl sm:text-5xl font-bold text-gray-900 dark:text-white mb-4">
            Roblox Item Tracker
          </h1>
          <p className="text-lg text-gray-600 dark:text-gray-300">
            Search and track Roblox items by ID or Asset ID
          </p>
        </div>
        
        <ItemSearch />
      </div>
    </div>
  );
}
