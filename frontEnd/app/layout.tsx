import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Nossa Seguros - Hackathon',
  description: 'Simple Project for Nosso Seguros',
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
