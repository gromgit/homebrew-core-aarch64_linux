class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.11.0.tar.gz"
  sha256 "5ccc467470a9020196c52ff8a8719bdb61e37ccdf579a9f7ce9a8e10d8cbb715"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9aeb0b585674044a86c8395fd1959f3b9f21e9bb85bf2e5b836971675670305"
    sha256 cellar: :any_skip_relocation, big_sur:       "b606d4c426916e7f99105feff8f3a4d50ef432a42db01969293f237691f4b295"
    sha256 cellar: :any_skip_relocation, catalina:      "1bb38e2c5a150de1f87c858bb9f43ba5466ff724bbe92aad3cf7aeda29576626"
    sha256 cellar: :any_skip_relocation, mojave:        "e870a15934e646b694afcbdf56888dcbc74a79bb0ba434cc4b47285da1f4fcd6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      autocreate: true
      image: okteto/ruby:2
      command: bash
      sync:
      - .:/usr/src/app
      forward:
      - 1234:1234
      - 8080:8080
      persistentVolume: {}
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
