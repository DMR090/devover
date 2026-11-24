import type {Metadata,Viewport} from 'next'
import Navigation from '@/components/navigation'
import {Footer} from '@/components/studio'
import './globals.css'
export const metadata:Metadata={title:{default:'DEVOVER — Software & Design Studio',template:'%s | DEVOVER'},description:'Independent software development and design. Websites, mobile applications and custom software built around real business needs.',...(process.env.NEXT_PUBLIC_SITE_URL?{metadataBase:new URL(process.env.NEXT_PUBLIC_SITE_URL)}:{})}
export const viewport:Viewport={themeColor:'#050505',colorScheme:'dark'}
export default function Layout({children}:{children:React.ReactNode}){return <html lang="en"><body><a className="skip" href="#main">Skip to content</a><Navigation/><main id="main">{children}</main><Footer/><script type="application/ld+json" dangerouslySetInnerHTML={{__html:JSON.stringify({'@context':'https://schema.org','@type':'Organization',name:'DEVOVER',slogan:'Engineering Beyond Expectations.'})}}/></body></html>}
