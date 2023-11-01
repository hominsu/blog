interface Project {
  title: string,
  description: string,
  href?: string,
  imgSrc?: string,
}

const projectsData: Project[] = [
  {
    title: 'neujson',
    description: `neujson is a JSON parser and generator for C++. 
    It supports both SAX and DOM style API.`,
    imgSrc: "",
    href: 'https://github.com/hominsu/neujson',
  },
  {
    title: 'bencode',
    description: `A header-only Bencode parser and generator for C++17. 
    It supports both SAX and DOM style API.`,
    imgSrc: "",
    href: 'https://github.com/hominsu/bencode',
  },
  {
    title: 'slink',
    description: `A short link application base on kratos`,
    imgSrc: "",
    href: 'https://github.com/hominsu/slink',
  },
  {
    title: 'htp-platform',
    description: `An Intelligent phenotype Determination System for 
    High value-added Crops Based on a novel Rope-driven Parallel Robot`,
    imgSrc: "",
    href: 'https://github.com/ynu-e-young/htp-platform',
  },
]

export default projectsData
