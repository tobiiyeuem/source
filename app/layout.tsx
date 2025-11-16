import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Roblox Inventory Tracker - Track User Inventories",
  description: "Track and view all items owned in any Roblox user's inventory. See collectibles, accessories, and more with thumbnails and details.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}
