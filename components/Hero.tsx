import { Authors, allAuthors } from 'contentlayer/generated'
import { MDXLayoutRenderer } from 'pliny/mdx-components'
import AvatarLayout from '@/layouts/AvatarLayout'
import { coreContent } from 'pliny/utils/contentlayer'

export default function Hero() {
  const author = allAuthors.find((p) => p.slug === 'default') as Authors
  const mainContent = coreContent(author)

  return (
    <div className="my-6 flex flex-col items-center gap-x-12 xl:mb-12 xl:flex-row">
      <div className="max-w-2xl pt-6">
        <h1 className="pb-6 text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl sm:leading-10 md:text-6xl md:leading-14">
          Hi, I’m Homing So
        </h1>
        <h2 className="prose text-lg text-gray-600 dark:text-gray-400">
          <strong>{`A `}</strong>
          {`Day time student, Work time startuper, Free time open source enthusiast, Rest time loser.`}
        </h2>
      </div>
      <AvatarLayout content={mainContent}>
        <MDXLayoutRenderer code={author.body.code} />
      </AvatarLayout>
    </div>
  )
}
