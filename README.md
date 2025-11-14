# Roblox Item Tracker

A modern, responsive Next.js web application to search and track Roblox items by their ID or Asset ID. Get detailed information about items including price, description, creator, sale status, stock information, and more.

## Features

### Core Features

- **Item Search Interface**
  - Input field to enter Roblox item IDs or asset IDs
  - Search button to fetch item details
  - Search history to quickly access previously searched items

- **Item Details Display**
  - Item name and description
  - Item price (in Robux)
  - High-quality item thumbnail/image
  - Item type (gear, clothing, accessories, etc.)
  - Creator information with link to creator profile
  - Sale status (on sale, off sale, limited, limited U)
  - Stock information for limited items
  - Sales count
  - Creation and update dates
  - Direct link to view item on Roblox

- **User Interface**
  - Clean, modern design
  - Fully responsive layout (mobile-friendly)
  - Loading states while fetching data
  - Comprehensive error handling
  - Dark mode support
  - Clear feedback messages

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

1. **Search for an Item**: Enter a Roblox item ID or asset ID in the search field
2. **View Details**: Click "Search Item" to fetch and display the item details
3. **Browse History**: Click on any recent search in the history section to quickly view that item again
4. **View on Roblox**: Click the "View on Roblox" button to open the item page on Roblox.com

### Example Item IDs to Try

- `1365767` - Dominus Empyreus (Limited item)
- `11884330` - Builderman's Hat
- `607702535` - Robox (Popular limited item)

## Project Structure

```
source/
├── app/
│   ├── api/
│   │   └── items/
│   │       └── [id]/
│   │           └── route.ts       # API route for fetching item details
│   ├── layout.tsx                 # Root layout with metadata
│   ├── page.tsx                   # Main page
│   └── globals.css                # Global styles
├── components/
│   ├── ItemSearch.tsx             # Search interface component
│   └── ItemDetails.tsx            # Item details display component
├── lib/
│   └── roblox-api.ts              # API utilities for Roblox
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

- `https://economy.roblox.com/v2/assets/{assetId}/details` - Fetch asset details
- `https://thumbnails.roblox.com/v1/assets` - Fetch item thumbnails
- `https://catalog.roblox.com/v1/catalog/items/{itemId}/details` - Fetch catalog item details

No API key is required for these endpoints.

## Error Handling

The application handles various error scenarios:

- Invalid item IDs (non-numeric or negative values)
- Item not found (404 errors)
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
