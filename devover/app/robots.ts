import type {MetadataRoute} from 'next'
export default function robots():MetadataRoute.Robots{return {rules:{userAgent:'*',allow:'/',disallow:'/api/'},sitemap:process.env.NEXT_PUBLIC_SITE_URL?new URL('/sitemap.xml',process.env.NEXT_PUBLIC_SITE_URL).href:undefined}}
