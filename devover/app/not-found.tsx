import Link from 'next/link'
import {Label} from '@/components/studio'
export default function NotFound(){return <section className="wrap sub"><Label index="404">PAGE NOT FOUND</Label><h1>Off the grid.</h1><p className="lead">This page is unavailable or has moved.</p><Link className="btn w-fit" href="/">Back to homepage ↗</Link></section>}
