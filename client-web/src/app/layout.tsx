import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'GridFlow - PV Registration System',
  description: 'Open-source BPMN orchestration platform for automated grid connection (VDE-AR-N 4105)',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
