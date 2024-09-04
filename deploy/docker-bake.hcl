target "metadata" {}

group "default" {
  targets = [
    "blog",
  ]
}

target "cross" {
  platforms = [
    "linux/arm64", 
    "linux/amd64"
  ]
}

target "blog" {
  inherits = [ "metadata", "cross" ]
  dockerfile = "deploy/Dockerfile"
  secret = [
    "type=env,id=NEXT_PUBLIC_ALGOLIA_APIKEY",
    "type=env,id=NEXT_PUBLIC_ALGOLIA_APPID",
    "type=env,id=NEXT_PUBLIC_ALGOLIA_INDEX_NAME",
    "type=env,id=NEXT_PUBLIC_GISCUS_CATEGORY",
    "type=env,id=NEXT_PUBLIC_GISCUS_CATEGORY_ID",
    "type=env,id=NEXT_PUBLIC_GISCUS_REPO",
    "type=env,id=NEXT_PUBLIC_GISCUS_REPOSITORY_ID",
  ]
}
