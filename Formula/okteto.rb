class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.3.tar.gz"
  sha256 "6d95226c940b4696c44fe02ee924f4309d207231f9e4c680cf615089c4a078ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "afb8d871eba976348441adbca8536e5c22b6988c409bb4c52f40fb1a85bddcc1" => :catalina
    sha256 "9a75c3af2e162145415c51f4b785d9a47403818568112929e7a3557d62cb370f" => :mojave
    sha256 "7f18657213d32f5feeb89dd410e470bdfe489f6abf9b91bbe3d9c705ee447b48" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command:
      - bash
      workdir: /usr/src/app
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
