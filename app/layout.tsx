import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Roblox Item Tracker - Search and Track Roblox Items",
  description: "Search and track Roblox items by ID. Get detailed information about items including price, creator, sale status, and more.",
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
