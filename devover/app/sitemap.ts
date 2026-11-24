import {services} from '@/lib/studio'
import type {MetadataRoute} from 'next'
export default function sitemap():MetadataRoute.Sitemap{const base=process.env.NEXT_PUBLIC_SITE_URL;if(!base)return [];return ['','services',...services.map(s=>'services/'+s[0]),'work','about','process','contact','start-project','privacy','terms'].map(s=>({url:new URL('/'+s,base).href}))}
