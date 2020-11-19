class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.9.6.tar.gz"
  sha256 "93e36ed92a5f8f08971ad31d30f2a9dc149345c695b5401da0b1e923748c9e16"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d99928e5a8fec2638e75d9c56a3bc73c7a2e4c9dd0c87788b25902523a76390" => :big_sur
    sha256 "513bee6c202b52e5edd07b0ff02758ee5f2d5c143ea5318e76e112ad2da7356c" => :catalina
    sha256 "4801d4e2d4705eb6b69c46b2e18fb34f4e441ee4950c13de1249214c317c7dcd" => :mojave
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
