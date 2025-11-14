# Roblox Inventory Tracker

A modern, responsive Next.js web application to track and view all items owned in any Roblox user's inventory. Automatically fetches and displays all collectible items, accessories, and more with thumbnails and details.

## Features

### Core Features

- **Inventory Tracking**
  - Input field to enter any Roblox username
  - Automatically fetches all items owned in the user's inventory
  - Search history to quickly access previously searched usernames

- **Inventory Display**
  - Grid layout showing all items with thumbnails
  - Item name and asset type
  - High-quality item thumbnails (420x420)
  - Direct links to view each item on Roblox
  - Total item count display

- **User Interface**
  - Clean, modern design with gradient backgrounds
  - Fully responsive grid layout (mobile-friendly)
  - Loading states while fetching inventory data
  - Comprehensive error handling
  - Dark mode support
  - Clear feedback messages
  - Hover effects on item cards

## Tech Stack

- **Next.js 16** - React framework with App Router
- **TypeScript** - Type-safe code
- **Tailwind CSS** - Modern styling
- **Roblox APIs** - Data fetching from official Roblox endpoints

## Getting Started

### Prerequisites

- Node.js 18.x or higher
- npm, yarn, or pnpm

### Installation

1. Clone the repository:
```bash
git clone https://github.com/tobiiyeuem/source.git
cd source
```

2. Install dependencies:
```bash
npm install
```

3. Run the development server:
```bash
npm run dev
```

4. Open [http://localhost:3000](http://localhost:3000) in your browser to see the application.

### Building for Production

To create a production build:

```bash
npm run build
```

To run the production build locally:

```bash
npm start
```

## Usage

1. **Enter Username**: Type any Roblox username in the search field
2. **Track Inventory**: Click "Track Inventory" to fetch all items owned by that user
3. **View Items**: Browse the grid of all items in the user's inventory
4. **Browse History**: Click on any recent username in the history section to quickly view that inventory again
5. **View on Roblox**: Click on any item card to open that item's page on Roblox.com

### Example Usernames to Try

- `Builderman` - Original Roblox account
- `Roblox` - Official Roblox account
- Any valid Roblox username

## Project Structure

```
source/
├── app/
│   ├── api/
│   │   ├── inventory/
│   │   │   └── [username]/
│   │   │       └── route.ts       # API route for fetching user inventory
│   │   └── items/
│   │       └── [id]/
│   │           └── route.ts       # API route for fetching item details
│   ├── layout.tsx                 # Root layout with metadata
│   ├── page.tsx                   # Main page
│   └── globals.css                # Global styles
├── components/
│   ├── ItemSearch.tsx             # Username input and search interface
│   ├── InventoryGrid.tsx          # Grid display for inventory items
│   └── ItemDetails.tsx            # Individual item details component
├── lib/
│   └── roblox-api.ts              # API utilities for Roblox (inventory & items)
├── types/
│   └── roblox.ts                  # TypeScript type definitions
├── public/                        # Static assets
├── package.json                   # Dependencies and scripts
├── tsconfig.json                  # TypeScript configuration
├── tailwind.config.ts             # Tailwind CSS configuration
└── README.md                      # This file
```

## API Integration

The application uses the following Roblox public APIs:

- `https://users.roblox.com/v1/usernames/users` - Convert username to user ID
- `https://inventory.roblox.com/v1/users/{userId}/assets/collectibles` - Fetch user inventory by asset type
- `https://thumbnails.roblox.com/v1/assets` - Fetch item thumbnails (420x420 resolution)
- `https://economy.roblox.com/v2/assets/{assetId}/details` - Fetch asset details (fallback)
- `https://catalog.roblox.com/v1/catalog/items/{itemId}/details` - Fetch catalog item details (fallback)

No API key is required for these public endpoints.

## Error Handling

The application handles various error scenarios:

- Invalid usernames (empty or non-existent users)
- User not found (404 errors)
- Empty inventories
- API rate limits
- Network errors
- Invalid API responses

All errors are displayed to the user with clear, helpful messages.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Built with [Next.js](https://nextjs.org/)
- Styled with [Tailwind CSS](https://tailwindcss.com/)
- Data from [Roblox APIs](https://create.roblox.com/docs/cloud/open-cloud)
