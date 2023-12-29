variable "REPO" {
  default = "hominsu"
}

variable "AUTHOR_NAME" {
  default = "Homing So"
}

variable "AUTHOR_EMAIL" {
  default = "homingso@foxmail.com"
}

variable "VERSION" {
  default = ""
}

group "default" {
  targets = [
    "blog",
  ]
}

target "blog" {
  context    = "."
  dockerfile = "deploy/Dockerfile"
  args       = {
    AUTHOR_NAME       = "${AUTHOR_NAME}"
    AUTHOR_EMAIL      = "${AUTHOR_EMAIL}"
    VERSION           = "$(VERSION)"
  }
  secret = [
    "type=env,id=NEXT_ALGOLIA_APIKEY",
    "type=env,id=NEXT_ALGOLIA_APPID",
    "type=env,id=NEXT_ALGOLIA_INDEX_NAME",
    "type=env,id=NEXT_PUBLIC_GISCUS_CATEGORY",
    "type=env,id=NEXT_PUBLIC_GISCUS_CATEGORY_ID",
    "type=env,id=NEXT_PUBLIC_GISCUS_REPO",
    "type=env,id=NEXT_PUBLIC_GISCUS_REPOSITORY_ID",
    "type=env,id=NEXT_UMAMI_ID"
  ]
  tags = [
    notequal("", VERSION) ? "${REPO}/blog:${VERSION}" : "",
    "${REPO}/blog:latest",
  ]
  platforms = ["linux/amd64", "linux/arm64"]
}