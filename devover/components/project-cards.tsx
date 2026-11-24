import Link from 'next/link'
import type {ReactNode} from 'react'
type Project={slug:string;title:string;category:string;summary:string;technologies:string[];project_type:string;project_status:string;year:number;featured:boolean}
export function ProjectCards({projects}:{projects:Project[]}){return <div className="cards">{projects.map(p=><Link className="card project-card" href={'/work/'+p.slug} key={p.slug}><div className="card-top"><small>{p.category.toUpperCase()}</small><small>{p.year}</small></div><h3>{p.title}</h3><p>{p.summary}</p><div className="project-meta"><span>{p.project_type.toUpperCase()}</span><span>{p.project_status.replaceAll('_',' ').toUpperCase()}</span><span>{p.technologies.slice(0,3).join(' · ')}</span></div></Link>)}</div>}
export function ProjectArchive({children}:{children:ReactNode}){return <div className="empty"><small>PROJECT ARCHIVE</small>{children}</div>}
