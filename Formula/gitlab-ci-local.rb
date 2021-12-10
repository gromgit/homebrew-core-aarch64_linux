require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.27.0.tgz"
  sha256 "6575b5552e3076ed911b40b2c8ac06e04e82dcb46ad481f72c30e85ec1377854"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2d3b8d9458fa405352d515c3a575dacc8007a22dba6562159b7fa87e1e57b4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2d3b8d9458fa405352d515c3a575dacc8007a22dba6562159b7fa87e1e57b4a"
    sha256 cellar: :any_skip_relocation, monterey:       "6e035cf7b13d7abf2d6ebdb81a8670c2a7708579ff622391926eb501efca2bf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e035cf7b13d7abf2d6ebdb81a8670c2a7708579ff622391926eb501efca2bf7"
    sha256 cellar: :any_skip_relocation, catalina:       "6e035cf7b13d7abf2d6ebdb81a8670c2a7708579ff622391926eb501efca2bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2d3b8d9458fa405352d515c3a575dacc8007a22dba6562159b7fa87e1e57b4a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YML
      ---
      stages:
        - build
        - tag
      variables:
        HELLO: world
      build:
        stage: build
        needs: []
        tags:
          - shared-docker
        script:
          - echo "HELLO"
      tag-docker-image:
        stage: tag
        needs: [ build ]
        tags:
          - shared-docker
        script:
          - echo $HELLO
    YML

    system "git", "init"
    system "git", "add", ".gitlab-ci.yml"
    system "git", "commit", "-m", "'some message'"
    rm ".git/config"

    (testpath/".git/config").write <<~EOS
      [core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
      [remote "origin"]
        url = git@github.com:firecow/gitlab-ci-local.git
        fetch = +refs/heads/*:refs/remotes/origin/*
      [branch "master"]
        remote = origin
        merge = refs/heads/master
    EOS

    assert_equal shell_output("#{bin}/gitlab-ci-local --list"), <<~OUTPUT
      name              description  stage  when        allow_failure  needs
      build                          build  on_success  false          []
      tag-docker-image               tag    on_success  false          [build]
    OUTPUT
  end
end
