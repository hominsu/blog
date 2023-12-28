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
  tags = [
    notequal("", VERSION) ? "${REPO}/blog:${VERSION}" : "",
    "${REPO}/blog:latest",
  ]
  platforms = ["linux/amd64", "linux/arm64"]
}